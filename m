Return-Path: <SRS0=p2dm=M2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71868C432BE
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 11:39:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E4AB860560
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 11:39:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E4AB860560
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DEB0407B0;
	Tue,  3 Aug 2021 07:39:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SaIc-NJwKnY6; Tue,  3 Aug 2021 07:39:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BA0240877;
	Tue,  3 Aug 2021 07:39:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86982406E7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 07:39:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M1IBmEoqMcdZ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Aug 2021 07:39:03 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 62138406E0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 07:39:03 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17CA360BD3;
 Tue,  3 Aug 2021 11:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1627990742;
 bh=mME2Y3V/e+bRBo+xbl4UW9QXkdNerzgDg+UYaH+HLKI=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=HV3jZitur7fF0Gywc+XPBQncXgR0TP63CgpxLPROPkzgdPlfCOj1xSDG1Oqy2W6en
 IaSGccub/3lkMnF1h1q2cAbKUiBJqciCauHUUxQP4RBIOPmKmSedJp1E8ftKlzqYWk
 lkot2D/XqzZUp/LVVR4MxI2rYAwbvzfSgFoX6ZDIeVIz6xK+6C2DMnFLZX6/GTrjA8
 NSjqVj8ulxUwienXToTjFjg9UZx0DRyGfAnSDQHVqV1Qk03iunM55qd1h+kG/lQmqC
 9DT0DRQa0DZcZG9pK3cFEVISG/Mbim8DNaVr6GlEufQub8K0J0nDhUNZlSswmGW+hI
 BjgwNcwiyuaTA==
Date: Tue, 3 Aug 2021 12:38:56 +0100
From: Will Deacon <will@kernel.org>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v3 1/4] KVM: arm64: Introduce a new VMID allocator for KVM
Message-ID: <20210803113856.GA30853@willie-the-truck>
References: <20210729104009.382-1-shameerali.kolothum.thodi@huawei.com>
 <20210729104009.382-2-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210729104009.382-2-shameerali.kolothum.thodi@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: jean-philippe@linaro.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, Jul 29, 2021 at 11:40:06AM +0100, Shameer Kolothum wrote:
> A new VMID allocator for arm64 KVM use. This is based on
> arm64 ASID allocator algorithm.
> 
> One major deviation from the ASID allocator is the way we
> flush the context. Unlike ASID allocator, we expect less
> frequent rollover in the case of VMIDs. Hence, instead of
> marking the CPU as flush_pending and issuing a local context
> invalidation on the next context switch, we broadcast TLB
> flush + I-cache invalidation over the inner shareable domain
> on rollover.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---

[...]

> +void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid)
> +{
> +	unsigned long flags;
> +	unsigned int cpu;
> +	u64 vmid, old_active_vmid;
> +
> +	vmid = atomic64_read(&kvm_vmid->id);
> +
> +	/*
> +	 * Please refer comments in check_and_switch_context() in
> +	 * arch/arm64/mm/context.c.
> +	 */
> +	old_active_vmid = atomic64_read(this_cpu_ptr(&active_vmids));
> +	if (old_active_vmid && vmid_gen_match(vmid) &&
> +	    atomic64_cmpxchg_relaxed(this_cpu_ptr(&active_vmids),
> +				     old_active_vmid, vmid))
> +		return;
> +
> +	raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
> +
> +	/* Check that our VMID belongs to the current generation. */
> +	vmid = atomic64_read(&kvm_vmid->id);
> +	if (!vmid_gen_match(vmid)) {
> +		vmid = new_vmid(kvm_vmid);
> +		atomic64_set(&kvm_vmid->id, vmid);

new_vmid() can just set kvm_vmid->id directly

> +	}
> +
> +	cpu = smp_processor_id();

Why?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
