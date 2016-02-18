From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC v3 07/15] iommu: iommu_get/put_single_reserved
Date: Thu, 18 Feb 2016 18:18:44 +0100
Message-ID: <56C5FCF4.4010509@linaro.org>
References: <1455264797-2334-1-git-send-email-eric.auger@linaro.org>
	<1455264797-2334-8-git-send-email-eric.auger@linaro.org>
	<20160218110616.05108071@arm.com> <56C5F472.1020003@linaro.org>
	<56C5F679.8000002@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <56C5F679.8000002-5wv7dgnIgG8@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>
Cc: eric.auger-qxv4g6HH51o@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Thomas.Lendacky-5C7GfCeVMHo@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sherry.hurwitz-5C7GfCeVMHo@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,
On 02/18/2016 05:51 PM, Marc Zyngier wrote:
> On 18/02/16 16:42, Eric Auger wrote:
>> Hello,
>> On 02/18/2016 12:06 PM, Marc Zyngier wrote:
>>> On Fri, 12 Feb 2016 08:13:09 +0000
>>> Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>>
>>>> This patch introduces iommu_get/put_single_reserved.
>>>>
>>>> iommu_get_single_reserved allows to allocate a new reserved iova page
>>>> and map it onto the physical page that contains a given physical address.
>>>> It returns the iova that is mapped onto the provided physical address.
>>>> Hence the physical address passed in argument does not need to be aligned.
>>>>
>>>> In case a mapping already exists between both pages, the IOVA mapped
>>>> to the PA is directly returned.
>>>>
>>>> Each time an iova is successfully returned a binding ref count is
>>>> incremented.
>>>>
>>>> iommu_put_single_reserved decrements the ref count and when this latter
>>>> is null, the mapping is destroyed and the iova is released.
>>>
>>> I wonder if there is a requirement for the caller to find out about the
>>> size of the mapping, or to impose a given size... MSIs clearly do not
>>> have that requirement (this is always a 32bit value), but since. 
>>> allocations usually pair address and size, I though I'd ask...
>> Yes. Currently this only makes sure the host PA is mapped and returns
>> the corresponding IOVA. It is part of the discussion we need to have on
>> the API besides the problematic of which API it should belong to.
> 
> One of the issues I have with the API at the moment is that there is no
> control on the page size. Imagine you have allocated a 4kB IOVA window
> for your MSI, but your IOMMU can only map 64kB (not unreasonable to
> imagine on arm64). What happens then?
The code checks the IOVA window size is aligned with the IOMMU page size
so I think that case is handled at iova domain creation
(arm_smmu_alloc_reserved_iova_domain).
> 
> Somehow, userspace should be told about it, one way or another.
I agree on that point. The user-space should be provided with the
information about the requested iova pool size and alignments. This is
missing in current rfc series.

Best Regards

Eric
> 
> Thanks,
> 
> 	M.
> 
