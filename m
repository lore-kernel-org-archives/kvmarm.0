From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 0/7] KVM PCIe/MSI passthrough on ARM/ARM64: kernel part
	1/3: iommu changes
Date: Fri, 8 Apr 2016 15:31:49 +0200
Message-ID: <5707B2C5.5050008@linaro.org>
References: <1459757222-2668-1-git-send-email-eric.auger@linaro.org>
	<20160406171534.794c6824@t450s.home> <5706528B.2010906@linaro.org>
	<20160407115001.25de7d1e@t450s.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160407115001.25de7d1e-1yVPhWWZRC1BDLzU/O5InQ@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: julien.grall-5wv7dgnIgG8@public.gmane.org, eric.auger-qxv4g6HH51o@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,
On 04/07/2016 07:50 PM, Alex Williamson wrote:
> On Thu, 7 Apr 2016 14:28:59 +0200
> Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> 
>> Hi Alex,
>> On 04/07/2016 01:15 AM, Alex Williamson wrote:
>>> On Mon,  4 Apr 2016 08:06:55 +0000
>>> Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>>   
>>>> This series introduces the dma-reserved-iommu api used to:
>>>> - create/destroy an iova domain dedicated to reserved iova bindings
>>>> - map/unmap physical addresses onto reserved IOVAs.
>>>> - unmap and destroy all IOVA reserved bindings  
>>>
>>> Why are we making the decision to have an unbalanced map vs unmap, we
>>> can create individual mappings, but only unmap the whole thing and
>>> start over?  That's a strange interface.  Thanks,  
>> The "individual" balanced unmap also exists (iommu_put_reserved_iova)
>> and this is the "normal" path. This happens on msi_domain_deactivate
>> (and possibly on msi_domain_set_affinity).
>>
>> I added iommu_unmap_reserved to handle the case where the userspace
>> registers a reserved iova domain and fails to unregister it. In that
>> case one need to handle the cleanup on kernel-side and I chose to
>> implement this on vfio_iommu_type1 release. All the reserved IOMMU
>> bindings get destroyed on that event.
>>
>> Any advice to handle this situation?
> 
> If we want to model it similar to regular iommu domains, then
> iommu_free_reserved_iova_domain() should release all the mappings and
> destroy the iova domain.
Yes this sounds obvious now.
  Additionally, since the reserved iova domain
> is just a construct on top of an iommu domain, it should be sufficient
> to call iommu_domain_free() to also remove the reserved iova domain if
> one exists.  Thanks,
Yes. For dma cookie (iommu_put_dma_cookie) I see this is done from the
iommu driver domain_free callback.

Thanks

Eric
> 
> Alex
> 
