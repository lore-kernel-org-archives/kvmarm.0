Return-Path: <SRS0=ZMJ6=GP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E71C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 19:53:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A39222202
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 19:53:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A39222202
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9DD04B1D0;
	Tue, 12 Jan 2021 14:53:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EIxXCTqVjouN; Tue, 12 Jan 2021 14:53:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B17A24B1DB;
	Tue, 12 Jan 2021 14:53:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CB164B11C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 14:53:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DbeM3nVfuEaG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2021 14:53:50 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6F074B1CE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 14:53:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610481230;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=jGddw3AEKpcsMt4782p5IEc+z+Jt2DqrmaucsUPFqxQ=;
 b=bB1gzM9eI+QsSN16XHCj+JZIt12rpjffm8pbFXCetKoORwuCrwSOOY1EiqIWdVnOwnoVEf
 4YIGoDT2bNwYu4wQFP8q7ruTRdk5O6SDOuW7wfpiyLd/jj5jbu4wjUgZgjDu7jJMyElLpx
 DhtzfBGN9k6WJ1WSEtkAof7wXrIu1r4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-GgrlOiiGOUaQkw9W9zNYKA-1; Tue, 12 Jan 2021 14:53:45 -0500
X-MC-Unique: GgrlOiiGOUaQkw9W9zNYKA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D877101AFCD;
 Tue, 12 Jan 2021 19:53:40 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com
 [10.3.112.255])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 66C2C100AE4F;
 Tue, 12 Jan 2021 19:53:32 +0000 (UTC)
Date: Tue, 12 Jan 2021 12:53:31 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH 4/5] vfio/iommu_type1: Carefully use unmap_unpin_all
 during dirty tracking
Message-ID: <20210112125331.789f47a5@omen.home.shazbot.org>
In-Reply-To: <198f0afd-343a-9fbc-9556-95670ca76a2c@huawei.com>
References: <20210107092901.19712-1-zhukeqian1@huawei.com>
 <20210107092901.19712-5-zhukeqian1@huawei.com>
 <20210111144913.3092b1b1@omen.home.shazbot.org>
 <198f0afd-343a-9fbc-9556-95670ca76a2c@huawei.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Kirti Wankhede <kwankhede@nvidia.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Marc
 Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Alexios Zavras <alexios.zavras@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 iommu@lists.linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
 Robin Murphy <robin.murphy@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, 12 Jan 2021 20:04:38 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> On 2021/1/12 5:49, Alex Williamson wrote:
> > On Thu, 7 Jan 2021 17:29:00 +0800
> > Keqian Zhu <zhukeqian1@huawei.com> wrote:
> >   
> >> If we detach group during dirty page tracking, we shouldn't remove
> >> vfio_dma, because dirty log will lose.
> >>
> >> But we don't prevent unmap_unpin_all in vfio_iommu_release, because
> >> under normal procedure, dirty tracking has been stopped.  
> > 
> > This looks like it's creating a larger problem than it's fixing, it's
> > not our job to maintain the dirty bitmap regardless of what the user
> > does.  If the user detaches the last group in a container causing the
> > mappings within that container to be deconstructed before the user has
> > collected dirty pages, that sounds like a user error.  A container with
> > no groups is de-privileged and therefore loses all state.  Thanks,
> > 
> > Alex  
> 
> Hi Alex,
> 
> This looks good to me ;-). That's a reasonable constraint for user behavior.
> 
> What about replacing this patch with an addition to the uapi document of
> VFIO_GROUP_UNSET_CONTAINER? User should pay attention to this when call this
> ioctl during dirty tracking.

Here's the current uapi comment:

/**
 * VFIO_GROUP_UNSET_CONTAINER - _IO(VFIO_TYPE, VFIO_BASE + 5)
 *
 * Remove the group from the attached container.  This is the
 * opposite of the SET_CONTAINER call and returns the group to
 * an initial state.  All device file descriptors must be released
 * prior to calling this interface.  When removing the last group
 * from a container, the IOMMU will be disabled and all state lost,
 * effectively also returning the VFIO file descriptor to an initial
 * state.
 * Return: 0 on success, -errno on failure.
 * Availability: When attached to container
 */

So we already indicate that "all state" of the container is lost when
removing the last group, I don't see that it's necessarily to
explicitly include dirty bitmap state beyond that statement.  Without
mappings there can be no dirty bitmap to track.

 > And any comments on other patches? thanks.

I had a difficult time mapping the commit log to the actual code
change, I'll likely have some wording suggestions.  Is patch 5/5 still
necessary if this patch is dropped?  Thanks,

Alex

> >> Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
> >> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> >> ---
> >>  drivers/vfio/vfio_iommu_type1.c | 14 ++++++++++++--
> >>  1 file changed, 12 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index 26b7eb2a5cfc..9776a059904d 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -2373,7 +2373,12 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
> >>  			if (list_empty(&iommu->external_domain->group_list)) {
> >>  				vfio_sanity_check_pfn_list(iommu);
> >>  
> >> -				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
> >> +				/*
> >> +				 * During dirty page tracking, we can't remove
> >> +				 * vfio_dma because dirty log will lose.
> >> +				 */
> >> +				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu) &&
> >> +				    !iommu->dirty_page_tracking)
> >>  					vfio_iommu_unmap_unpin_all(iommu);
> >>  
> >>  				kfree(iommu->external_domain);
> >> @@ -2406,10 +2411,15 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
> >>  		 * iommu and external domain doesn't exist, then all the
> >>  		 * mappings go away too. If it's the last domain with iommu and
> >>  		 * external domain exist, update accounting
> >> +		 *
> >> +		 * Note: During dirty page tracking, we can't remove vfio_dma
> >> +		 * because dirty log will lose. Just update accounting is a good
> >> +		 * choice.
> >>  		 */
> >>  		if (list_empty(&domain->group_list)) {
> >>  			if (list_is_singular(&iommu->domain_list)) {
> >> -				if (!iommu->external_domain)
> >> +				if (!iommu->external_domain &&
> >> +				    !iommu->dirty_page_tracking)
> >>  					vfio_iommu_unmap_unpin_all(iommu);
> >>  				else
> >>  					vfio_iommu_unmap_unpin_reaccount(iommu);  
> > 
> > .
> >   
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
