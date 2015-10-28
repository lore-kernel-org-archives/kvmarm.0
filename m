From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC] vfio/type1: handle case where IOMMU does not support
 PAGE_SIZE size
Date: Wed, 28 Oct 2015 19:00:25 +0100
Message-ID: <56310D39.6090500@linaro.org>
References: <1446037965-2341-1-git-send-email-eric.auger@linaro.org>
 <1446049648.8018.397.camel@redhat.com> <563101A0.7020404@linaro.org>
 <1446053858.8018.406.camel@redhat.com> <56310A79.4020309@linaro.org>
 <20151028175533.GM18966@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C06B3411BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2015 13:57:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zC+C2rQ3jEkx for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Oct 2015 13:57:34 -0400 (EDT)
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
 [209.85.212.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE4F8410EB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2015 13:57:33 -0400 (EDT)
Received: by wicfv8 with SMTP id fv8so22443753wic.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2015 11:00:27 -0700 (PDT)
In-Reply-To: <20151028175533.GM18966@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/28/2015 06:55 PM, Will Deacon wrote:
> On Wed, Oct 28, 2015 at 06:48:41PM +0100, Eric Auger wrote:
>> On 10/28/2015 06:37 PM, Alex Williamson wrote:
>>> Ok, so with hopefully correcting my understand of what this does, isn't
>>> this effectively the same:
>>>
>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>> index 57d8c37..7db4f5a 100644
>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>> @@ -403,13 +403,19 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, stru
>>>  static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
>>>  {
>>>         struct vfio_domain *domain;
>>> -       unsigned long bitmap = PAGE_MASK;
>>> +       unsigned long bitmap = ULONG_MAX;
>>>  
>>>         mutex_lock(&iommu->lock);
>>>         list_for_each_entry(domain, &iommu->domain_list, next)
>>>                 bitmap &= domain->domain->ops->pgsize_bitmap;
>>>         mutex_unlock(&iommu->lock);
>>>  
>>> +       /* Some comment about how the IOMMU API splits requests */
>>> +       if (bitmap & ~PAGE_MASK) {
>>> +               bitmap &= PAGE_MASK;
>>> +               bitmap |= PAGE_SIZE;
>>> +       }
>>> +
>>>         return bitmap;
>>>  }
>> Yes, to me it is indeed the same
>>>  
>>> This would also expose to the user that we're accepting PAGE_SIZE, which
>>> we weren't before, so it was not quite right to just let them do it
>>> anyway.  I don't think we even need to get rid of the WARN_ONs, do we?
>>> Thanks,
>>
>> The end-user might be afraid of those latter. Personally I would get rid
>> of them but that's definitively up to you.
> 
> I think Alex's point is that the WARN_ON's won't trigger with this patch,
> because he clears those lower bits in the bitmap.
ah yes sure!

Thanks

Eric
> 
> Will
> 
