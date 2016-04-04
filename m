From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 4/4] msi: IOMMU map the doorbell address when needed
Date: Mon, 4 Apr 2016 11:28:22 +0200
Message-ID: <570233B6.8080805@linaro.org>
References: <201604041717.U3ElVlv7%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <201604041717.U3ElVlv7%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
Cc: eric.auger-qxv4g6HH51o@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-5wv7dgnIgG8@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/04/2016 11:22 AM, kbuild test robot wrote:
> Hi Eric,
> 
> [auto build test ERROR on tip/irq/core]
> [also build test ERROR on v4.6-rc2 next-20160404]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Eric-Auger/KVM-PCIe-MSI-passthrough-on-ARM-ARM64-kernel-part-2-3-msi-changes/20160404-162527
> config: x86_64-randconfig-s1-04041632 (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>>> kernel/irq/msi.c:21:38: fatal error: linux/dma-reserved-iommu.h: No such file or directory
>    compilation terminated.

Yes this was expected. this series needs to be applied on part 1: [PATCH
v6 0/7] KVM PCIe/MSI passthrough on ARM/ARM64: kernel part 1/3: iommu
changes, https://lkml.org/lkml/2016/4/4/90.

Same for part 3.

I split the whole series to ease the review process however this comes
at the expense of automatic testing. Sorry for that.

Best Regards

Eric


> 
> vim +21 kernel/irq/msi.c
> 
>     15	#include <linux/irqdomain.h>
>     16	#include <linux/msi.h>
>     17	
>     18	/* Temparory solution for building, will be removed later */
>     19	#include <linux/pci.h>
>     20	#include <linux/iommu.h>
>   > 21	#include <linux/dma-reserved-iommu.h>
>     22	
>     23	struct msi_desc *alloc_msi_entry(struct device *dev)
>     24	{
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
