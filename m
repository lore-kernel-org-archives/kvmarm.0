From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC v5 00/17] KVM PCIe/MSI passthrough on ARM/ARM64
Date: Wed, 2 Mar 2016 13:30:11 +0100
Message-ID: <56D6DCD3.7070004@linaro.org>
References: <1456856877-4817-1-git-send-email-eric.auger@linaro.org>
	<BY1PR0701MB1594168E79366B507B7C8A16E1BC0@BY1PR0701MB1594.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <BY1PR0701MB1594168E79366B507B7C8A16E1BC0-vsFp3N3nJ9josxbTuffl3E5OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Jaggi, Manish" <Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, "eric.auger-qxv4g6HH51o@public.gmane.org" <eric.auger-qxv4g6HH51o@public.gmane.org>, "robin.murphy-5wv7dgnIgG8@public.gmane.org" <robin.murphy-5wv7dgnIgG8@public.gmane.org>, "alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "will.deacon-5wv7dgnIgG8@public.gmane.org" <will.deacon-5wv7dgnIgG8@public.gmane.org>, "joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org" <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org" <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>, "marc.zyngier-5wv7dgnIgG8@public.gmane.org" <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, "christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org" <p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Manish,
On 03/02/2016 09:11 AM, Jaggi, Manish wrote:
> 
> 
>>> From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>> Sent: Tuesday, March 1, 2016 11:57 PM
>>> To: eric.auger-qxv4g6HH51o@public.gmane.org; eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org; robin.murphy-5wv7dgnIgG8@public.gmane.org; alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; will.deacon-5wv7dgnIgG8@public.gmane.org; joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org; tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org; >>jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org; marc.zyngier-5wv7dgnIgG8@public.gmane.org; christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org; linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org; kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org; kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> Cc: suravee.suthikulpanit-5C7GfCeVMHo@public.gmane.org; patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Jaggi, Manish; Bharat.Bhushan-KZfg59tc24xl57MIdRCFDg@public.gmane.org; >>pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org; iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
>>> Subject: [RFC v5 00/17] KVM PCIe/MSI passthrough on ARM/ARM64
> 
>>> This series addresses KVM PCIe passthrough with MSI enabled on ARM/ARM64.
>>> It pursues the efforts done on [1], [2], [3]. It also aims at covering the
>>> same need on PowerPC platforms although the same kind of integration
>>> .should be carried out.
>>>
> [snip]
>>> - Not tested: ARM GICv3 ITS
> 
> [snip]
>>> QEMU Integration:
>>> [RFC v2 0/8] KVM PCI/MSI passthrough with mach-virt
>>> (http://lists.gnu.org/archive/html/qemu-arm/2016-01/msg00444.html)
>>> https://git.linaro.org/people/eric.auger/qemu.git/shortlog/refs/heads/v2.5.0-pci-passthrough-rfc-v2
> 
> For gicv3 its, I believe, the below series for qemu and kernel is required for gicv3-its
> 
> [RFC PATCH v3 0/5] vITS support
> https://lists.gnu.org/archive/html/qemu-devel/2015-11/msg05197.html
> 
> and in kernel CONFIG_HAVE_KVM_MSI must be enabled so that qemu sees MSI capability KVM_CAP_SIGNAL_MSI
> 
> This has a dependency on gsi routing support
> KVM: arm/arm64: gsi routing support
> https://lkml.org/lkml/2015/6/29/290

which has a dependency on Andre's ITS emulation series too.

The Kernel series will be resent soon on top on new vgic design.
> 
> I had both the above series in 4.2 in my local 4.2 tree. 

Did you have a chance to test with GICv3 ITS already?

Best Regards

Eric


> 
> BR
> -Manish
> 
> 
