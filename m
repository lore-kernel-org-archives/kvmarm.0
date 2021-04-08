Return-Path: <SRS0=McpZ=JF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46169C433B4
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 14:19:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B164A61151
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 14:19:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B164A61151
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 381544B94A;
	Thu,  8 Apr 2021 10:19:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2GcqtgQWWJFI; Thu,  8 Apr 2021 10:19:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A3814B968;
	Thu,  8 Apr 2021 10:19:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 244C84B94A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 10:19:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d8gjPC2JQrRu for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Apr 2021 10:19:02 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF8BA4B74C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 10:19:01 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id B87866024A;
 Thu,  8 Apr 2021 14:18:57 +0000 (UTC)
Date: Thu, 8 Apr 2021 15:18:55 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v10 2/6] arm64: kvm: Introduce MTE VM feature
Message-ID: <20210408141853.GA7676@arm.com>
References: <e0b88560-34e1-dcc4-aaa7-9a7a5b771824@arm.com>
 <20210330103013.GD18075@arm.com>
 <8977120b-841d-4882-2472-6e403bc9c797@redhat.com>
 <20210331092109.GA21921@arm.com>
 <d545a051-a02a-4c3a-0afe-66612839ba32@redhat.com>
 <86a968c8-7a0e-44a4-28c3-bac62c2b7d65@arm.com>
 <20210331184311.GA10737@arm.com>
 <e2612bd8-b356-a9cd-cfdf-26f4aa813578@arm.com>
 <20210407151458.GC21451@arm.com>
 <5e5bf772-1e4d-ca59-a9d8-058a72dfad4f@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5e5bf772-1e4d-ca59-a9d8-058a72dfad4f@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: David Hildenbrand <david@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Juan Quintela <quintela@redhat.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
 linux-kernel@vger.kernel.org
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

On Wed, Apr 07, 2021 at 04:52:54PM +0100, Steven Price wrote:
> On 07/04/2021 16:14, Catalin Marinas wrote:
> > On Wed, Apr 07, 2021 at 11:20:18AM +0100, Steven Price wrote:
> > > On 31/03/2021 19:43, Catalin Marinas wrote:
> > > > When a slot is added by the VMM, if it asked for MTE in guest (I guess
> > > > that's an opt-in by the VMM, haven't checked the other patches), can we
> > > > reject it if it's is going to be mapped as Normal Cacheable but it is a
> > > > ZONE_DEVICE (i.e. !kvm_is_device_pfn() + one of David's suggestions to
> > > > check for ZONE_DEVICE)? This way we don't need to do more expensive
> > > > checks in set_pte_at().
> > > 
> > > The problem is that KVM allows the VMM to change the memory backing a slot
> > > while the guest is running. This is obviously useful for the likes of
> > > migration, but ultimately means that even if you were to do checks at the
> > > time of slot creation, you would need to repeat the checks at set_pte_at()
> > > time to ensure a mischievous VMM didn't swap the page for a problematic one.
> > 
> > Does changing the slot require some KVM API call? Can we intercept it
> > and do the checks there?
> 
> As David has already replied - KVM uses MMU notifiers, so there's not really
> a good place to intercept this before the fault.
> 
> > Maybe a better alternative for the time being is to add a new
> > kvm_is_zone_device_pfn() and force KVM_PGTABLE_PROT_DEVICE if it returns
> > true _and_ the VMM asked for MTE in guest. We can then only set
> > PG_mte_tagged if !device.
> 
> KVM already has a kvm_is_device_pfn(), and yes I agree restricting the MTE
> checks to only !kvm_is_device_pfn() makes sense (I have the fix in my branch
> locally).

Indeed, you can skip it if kvm_is_device_pfn(). In addition, with MTE,
I'd also mark a pfn as 'device' in user_mem_abort() if
pfn_to_online_page() is NULL as we don't want to map it as Cacheable in
Stage 2. It's unlikely that we'll trip over this path but just in case.

(can we have a ZONE_DEVICE _online_ pfn or by definition they are
considered offline?)

> > BTW, after a page is restored from swap, how long do we keep the
> > metadata around? I think we can delete it as soon as it was restored and
> > PG_mte_tagged was set. Currently it looks like we only do this when the
> > actual page was freed or swapoff. I haven't convinced myself that it's
> > safe to do this for swapoff unless it guarantees that all the ptes
> > sharing a page have been restored.
> 
> My initial thought was to free the metadata immediately. However it turns
> out that the following sequence can happen:
> 
>  1. Swap out a page
>  2. Swap the page in *read only*
>  3. Discard the page
>  4. Swap the page in again
> 
> So there's no writing of the swap data again before (3). This works nicely
> with a swap device because after writing a page it stays there forever, so
> if you know it hasn't been modified it's pointless rewriting it. Sadly it's
> not quite so ideal with the MTE tags which are currently kept in RAM.

I missed this scenario. So we need to keep it around as long as the
corresponding swap storage is still valid.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
