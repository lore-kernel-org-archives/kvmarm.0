From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 00/10] KVM PCIe/MSI passthrough on ARM/ARM64
Date: Mon, 1 Feb 2016 14:03:51 +0000
Message-ID: <20160201140351.GE6828@arm.com>
References: <1453813968-2024-1-git-send-email-eric.auger@linaro.org>
	<1454017899.23148.0.camel@redhat.com> <56AB78B1.2030202@linaro.org>
	<1454096004.9301.1.camel@redhat.com> <56ABD8E0.6080409@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56ABD8E0.6080409-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: eric.auger-qxv4g6HH51o@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 29, 2016 at 10:25:52PM +0100, Eric Auger wrote:
> On 01/29/2016 08:33 PM, Alex Williamson wrote:
> >>> We know that x86 handles MSI vectors specially, so there is some
> >>> hardware that helps the situation.  It's not just that x86 has a fixed
> >>> range for MSI, it's how it manages that range when interrupt remapping
> >>> hardware is enabled.  A device table indexed by source-ID references a
> >>> per device table indexed by data from the MSI write itself.  So we get
> >>> much, much finer granularity,
> >> About the granularity, I think ARM GICv3 now provides a similar
> >> capability with GICv3 ITS (interrupt translation service). Along with
> >> the MSI MSG write transaction, the device outputs a DeviceID conveyed on
> >> the bus. This DeviceID (~ your source-ID) enables to index a device
> >> table. The entry in the device table points to a DeviceId interrupt
> >> translation table indexed by the EventID found in the msi msg. So the
> >> entry in the interrupt translation table eventually gives you the
> >> eventual interrupt ID targeted by the MSI MSG.
> >> This translation capability if not available in GICv2M though, ie. the
> >> one I am currently using.
> >>  
> >> Those tables currently are built by the ITS irqchip (irq-gic-v3-its.c)

That's right. GICv3/ITS disambiguates the interrupt source using the
DeviceID, which for PCI is derived from the Requester ID of the endpoint.
GICv2m is less flexible and requires a separate physical frame per guest
to achieve isolation.

Will
