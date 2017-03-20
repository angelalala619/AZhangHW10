//
//  PageVC.swift
//  Weather Gift
//
//  Created by Angela Zhang on 3/4/17.
//  Copyright © 2017 Angela Zhang. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {
    var currentPage = 0
    var locationsArray = ["Local City", "Sydney, Australia", "Accra, Ghana", "Uglich, Russia"]
    var pageControl: UIPageControl!
    var listButton: UIButton!
    let barButtonWidth: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        
        setViewControllers([createDetailVC(forPage: 0)], direction: .forward, animated: false, completion: nil)
        
        configurePageControl()
        configureListButton()
    }
    
    // MARK: - UI Configuration Methods
    func configurePageControl() {
        let pageControlHeight: CGFloat = barButtonWidth
        let pageControlWidth: CGFloat = view.frame.width - (barButtonWidth * 2)
        
        pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth) / 2 , y: view.frame.height - pageControlHeight, width: pageControlWidth, height: pageControlHeight))
        
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        pageControl.addTarget(self, action: #selector(pageControlPressed), for: .touchUpInside)
        view.addSubview(pageControl)
        
    }
    
    func configureListButton() {
        
        let barButtonHeight = barButtonWidth
        
        listButton = UIButton(frame: CGRect (x: view.frame.width - barButtonWidth, y: view.frame.height - barButtonHeight, width: barButtonWidth, height: barButtonHeight))
        listButton.setBackgroundImage(UIImage(named: "listbutton"), for: .normal)
        listButton.setBackgroundImage(UIImage(named: "listbutton-highlighted"), for: .normal)
        listButton.addTarget(self, action: #selector(segueToListVC), for: .touchUpInside)
        
        view.addSubview(listButton)
    }
    
    //MARK: - Segues
    func segueToListVC (sender: UIButton!) {
        print("Error1")
        performSegue(withIdentifier: "ToListVC", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToListVC" {
            print("ERROR2")
            let controller = segue.destination as! ListVC
            controller.locationsArray = locationsArray
            controller.currentPage = currentPage
            print("Error3")
        }
    }
    
    @IBAction func unwindFromListVC(sender: UIStoryboardSegue) {
        pageControl.numberOfPages = locationsArray.count 
        pageControl.currentPage = currentPage
        setViewControllers([createDetailVC(forPage: currentPage)], direction: .forward, animated: false, completion: nil)
    }


    // MARK: - Create View Controller for UIPageViewController
    func createDetailVC(forPage page: Int) -> DetailVC {
        
        currentPage = min(max(0, page), locationsArray.count - 1)
        
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "DetaiLVC") as! DetailVC
        
        detailVC.locationsArray = locationsArray
        detailVC.currentPage = currentPage
        
        return detailVC

    }
}

extension PageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let currentViewController = viewController as? DetailVC {
            if currentViewController.currentPage < locationsArray.count - 1 {
                return createDetailVC(forPage: currentViewController.currentPage + 1)
            }
        }
        return nil
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentViewController = viewController as? DetailVC {
            if currentViewController.currentPage > 0 {
                return createDetailVC(forPage: currentViewController.currentPage - 1)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers? [0] as? DetailVC {
            pageControl.currentPage = currentViewController.currentPage
        }
        
    }
    func pageControlPressed() {
        if let currentViewController = self.viewControllers?[0] as? DetailVC {
            currentPage = currentViewController.currentPage
            if pageControl.currentPage < currentPage {
                setViewControllers([createDetailVC(forPage: pageControl.currentPage)], direction: .reverse, animated: true, completion: nil)
            } else if pageControl.currentPage > currentPage {
                setViewControllers([createDetailVC(forPage: pageControl.currentPage)], direction: .forward, animated: true, completion: nil)
            }
        }
        
        }
    }
