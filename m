From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 09/10] vfio-pci: create an iommu mapping for msi address
Date: Tue, 26 Jan 2016 16:14:23 +0100
Message-ID: <56A78D4F.9020503@linaro.org>
References: <201601262259.1kktHLzi%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <201601262259.1kktHLzi%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, eric.auger-qxv4g6HH51o@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,
On 01/26/2016 03:43 PM, kbuild test robot wrote:
> Hi Eric,
> 
> [auto build test WARNING on v4.5-rc1]
> [also build test WARNING on next-20160125]
> [cannot apply to iommu/next]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Eric-Auger/KVM-PCIe-MSI-passthrough-on-ARM-ARM64/20160126-211921
> config: i386-allmodconfig (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All warnings (new ones prefixed by >>):
> 
>    drivers/vfio/pci/vfio_pci_intrs.c: In function 'vfio_set_mapped_msi_addr':
>>> drivers/vfio/pci/vfio_pci_intrs.c:324:43: warning: left shift count >= width of type [-Wshift-count-overflow]
>      msi_addr = (phys_addr_t)(msg.address_hi) << 32 |
>                                               ^
>>> drivers/vfio/pci/vfio_pci_intrs.c:333:34: warning: right shift count >= width of type [-Wshift-count-overflow]
>      msg.address_hi = (u32)(msi_iova >> 32);
I definitively need to revisit that code. I Better understand Alex'
comment now :-(

Thanks

Eric
>                                      ^
> 
> vim +324 drivers/vfio/pci/vfio_pci_intrs.c
> 
>    318		dma_addr_t msi_iova;
>    319		struct vfio_group *group = vdev->vfio_group;
>    320		struct msi_msg msg;
>    321		int ret;
>    322	
>    323		get_cached_msi_msg(irq, &msg);
>  > 324		msi_addr = (phys_addr_t)(msg.address_hi) << 32 |
>    325				(phys_addr_t)(msg.address_lo);
>    326	
>    327		ret = vfio_group_alloc_map_reserved_iova(group, msi_addr,
>    328							 IOMMU_WRITE, &msi_iova);
>    329		if (ret)
>    330			goto out;
>    331	
>    332		/* Re-program the msi-address with the iova */
>  > 333		msg.address_hi = (u32)(msi_iova >> 32);
>    334		msg.address_lo = (u32)(msi_iova & 0xffffffff);
>    335		pci_write_msi_msg(irq, &msg);
>    336	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
