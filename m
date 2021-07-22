Return-Path: <SRS0=vB6B=MO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B8EC63799
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 09:50:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4CE1A61287
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 09:50:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CE1A61287
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D272D4A195;
	Thu, 22 Jul 2021 05:50:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kDHIn-VBDw3i; Thu, 22 Jul 2021 05:50:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C180C4A1B0;
	Thu, 22 Jul 2021 05:50:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D8274A1B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 05:50:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mhL2CcqiWEOz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Jul 2021 05:50:17 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59FF84A195
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jul 2021 05:50:17 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B7FB60725;
 Thu, 22 Jul 2021 09:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1626947416;
 bh=1fTJzkwRBBXvLw3M2jo2NjL1Gq2JwYZPXQMQ+PsKlKU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=dSihkVRV1wezfnc8Z4ZiE7ndBzY/FfUy7o6c23SS0bLn5V7c+2QCW9tuk3p6ZmfEf
 lPBGNoiVcmQYKpjqWF+x/tqps0JMdtOSbHzB1griSKgXbNg8uEJgfuuJxGG9y/Dv8N
 PIJr10rsZMwLAdTgp3nY3u1A/u6FNKG/IckpsjdVAg8PnkRFKToryQ7Lw0zVtMV0rv
 8aKKlbyQ7JItbrbEn7RTuZf0ZpJ7IvODALCZiao/X3xTQf50nIsXw1Lwe8J2IyPITj
 42fXMSDwLqZ61wc2xtDFxT9raPBi4CHfP3ZA/eFvqmxQQoRPs7SpcArbVr/u7NSVLg
 ppSo48UESDOgQ==
Date: Thu, 22 Jul 2021 10:50:10 +0100
From: Will Deacon <will@kernel.org>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 3/3] kvm/arm: Align the VMID allocation with the arm64
 ASID one
Message-ID: <20210722095010.GA12012@willie-the-truck>
References: <20210616155606.2806-1-shameerali.kolothum.thodi@huawei.com>
 <20210616155606.2806-4-shameerali.kolothum.thodi@huawei.com>
 <20210721163138.GD11003@willie-the-truck>
 <f7d708704fb84380af85298a98f7a48c@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f7d708704fb84380af85298a98f7a48c@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Linuxarm <linuxarm@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

On Thu, Jul 22, 2021 at 06:45:14AM +0000, Shameerali Kolothum Thodi wrote:
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c
> > b/arch/arm64/kvm/hyp/nvhe/tlb.c
> > > index 83dc3b271bc5..42df9931ed9a 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> > > @@ -140,10 +140,10 @@ void __kvm_flush_cpu_context(struct
> > kvm_s2_mmu *mmu)
> > >  	__tlb_switch_to_host(&cxt);
> > >  }
> > >
> > > -void __kvm_flush_vm_context(void)
> > > +void __kvm_tlb_flush_local_all(void)
> > >  {
> > > -	dsb(ishst);
> > > -	__tlbi(alle1is);
> > > +	dsb(nshst);
> > > +	__tlbi(alle1);
> > >
> > >  	/*
> > >  	 * VIPT and PIPT caches are not affected by VMID, so no maintenance
> > > @@ -155,7 +155,7 @@ void __kvm_flush_vm_context(void)
> > >  	 *
> > >  	 */
> > >  	if (icache_is_vpipt())
> > > -		asm volatile("ic ialluis");
> > > +		asm volatile("ic iallu" : : );
> > >
> > > -	dsb(ish);
> > > +	dsb(nsh);
> > 
> > Hmm, I'm wondering whether having this local stuff really makes sense for
> > VMIDs. For ASIDs, where rollover can be frequent and TLBI could result in
> > IPI on 32-bit, the local option was important, but here rollover is less
> > frequent, DVM is relied upon to work and the cost of a hypercall is
> > significant with nVHE.
> > 
> > So I do think you could simplify patch 2 slightly to drop the
> > flush_pending and just issue inner-shareable invalidation on rollover.
> > With that, it might also make it straightforward to clear active_asids
> > when scheduling out a vCPU, which would solve the other problem I
> > mentioned
> > about unnecessarily reserving a bunch of the VMID space.
> 
> Ok. I will try out the above suggestion. Hope it will be acceptable for 8 bit 
> VMID systems as well as there is a higher chance for rollover especially
> when we introduce pinned VMIDs(I am not sure such platforms care about
> Pinned VMID or not. If not, we could limit Pinned VMIDs to 16 bit systems).

So I woke up at 3am in a cold sweat after dreaming about this code.

I think my suggestion above still stands for the VMID allocator, but
interestingly, it would _not_ be valid for the ASID allocator because there
the ASID is part of the active context and so, during the window where the
active_asid is out of sync with the TTBR, receiving a broadcast TLBI from a
concurrent rollover wouldn't be enough to knock out the old ASID from the
TLB despite it subsequently being made available for reallocation. So the
local TLB invalidation is not just a performance hint as I said; it's crucial
to the way the thing works (and this is also why the CnP code has to switch
to the reserved TTBR0).

As an aside: I'm more and more inclined to rip out the CnP stuff given
that it doesn't appear to being any benefits, but does have some clear
downsides. Perhaps something for next week.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
