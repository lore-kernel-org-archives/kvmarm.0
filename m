Return-Path: <SRS0=VfsR=K6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB8E0C07E94
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 14:06:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6525F61405
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 14:06:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6525F61405
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D790B4B09E;
	Fri,  4 Jun 2021 10:06:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fhogdS4e1+Qq; Fri,  4 Jun 2021 10:05:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 249304B0F7;
	Fri,  4 Jun 2021 10:05:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A7AA4B0DA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 10:05:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t5OYzTSBaOiN for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jun 2021 10:05:51 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D4D64B09E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 10:05:51 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 148D4613FF;
 Fri,  4 Jun 2021 14:05:46 +0000 (UTC)
Date: Fri, 4 Jun 2021 15:05:44 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v13 4/8] KVM: arm64: Introduce MTE VM feature
Message-ID: <20210604140544.GF31173@arm.com>
References: <20210524104513.13258-1-steven.price@arm.com>
 <20210524104513.13258-5-steven.price@arm.com>
 <20210603160031.GE20338@arm.com>
 <a0810f3b-4f13-e8b5-7057-a9de1201887a@arm.com>
 <20210604113658.GD31173@arm.com>
 <2265cbf6-d643-9122-79a8-90198ea16c64@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2265cbf6-d643-9122-79a8-90198ea16c64@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Fri, Jun 04, 2021 at 01:51:38PM +0100, Steven Price wrote:
> On 04/06/2021 12:36, Catalin Marinas wrote:
> > On Fri, Jun 04, 2021 at 11:42:11AM +0100, Steven Price wrote:
> >> On 03/06/2021 17:00, Catalin Marinas wrote:
> >>> On Mon, May 24, 2021 at 11:45:09AM +0100, Steven Price wrote:
> >>>> @@ -971,8 +1007,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >>>>  	if (writable)
> >>>>  		prot |= KVM_PGTABLE_PROT_W;
> >>>>  
> >>>> -	if (fault_status != FSC_PERM && !device)
> >>>> +	if (fault_status != FSC_PERM && !device) {
> >>>> +		ret = sanitise_mte_tags(kvm, pfn, vma_pagesize);
> >>>> +		if (ret)
> >>>> +			goto out_unlock;
> >>>
> >>> Maybe it was discussed in a previous version, why do we need this in
> >>> addition to kvm_set_spte_gfn()?
> >>
> >> kvm_set_spte_gfn() is only used for the MMU notifier path (e.g. if a
> >> memslot is changed by the VMM). For the initial access we will normally
> >> fault the page into stage 2 with user_mem_abort().
> > 
> > Right. Can we move the sanitise_mte_tags() call to
> > kvm_pgtable_stage2_map() instead or we don't have the all the
> > information needed?
> 
> I tried that before: kvm_pgtable_stage2_map() is shared with the
> hypervisor so sadly we can't go poking around in the host as this breaks
> on nVHE. I mentioned it in the v12 cover letter but it was in a wall of
> text:

Ah, I missed this in the cover letter (haven't read it).

So, apart from the nitpick with the early return for less indentation,
feel free to add:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
