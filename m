Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD685C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 14:04:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D5402242A
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 14:04:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D5402242A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 985D44B4F6;
	Mon, 26 Oct 2020 10:04:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7LD3ARvDjL1K; Mon, 26 Oct 2020 10:04:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83DC14B4F4;
	Mon, 26 Oct 2020 10:04:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FFB84B4F6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 10:04:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ATI+LFqStVS2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 10:04:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 039894B4F2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 10:04:39 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 894B230E;
 Mon, 26 Oct 2020 07:04:39 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.56.187])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 180C33F68F;
 Mon, 26 Oct 2020 07:04:37 -0700 (PDT)
Date: Mon, 26 Oct 2020 14:04:35 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 03/11] KVM: arm64: Make kvm_skip_instr() and co private
 to HYP
Message-ID: <20201026140435.GE12454@C02TD0UTHF1T.local>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-4-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201026133450.73304-4-maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
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

On Mon, Oct 26, 2020 at 01:34:42PM +0000, Marc Zyngier wrote:
> In an effort to remove the vcpu PC manipulations from EL1 on nVHE
> systems, move kvm_skip_instr() to be HYP-specific. EL1's intent
> to increment PC post emulation is now signalled via a flag in the
> vcpu structure.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

[...]

> +/*
> + * Adjust the guest PC on entry, depending on flags provided by EL1
> + * for the purpose of emulation (MMIO, sysreg).
> + */
> +static inline void __adjust_pc(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu->arch.flags & KVM_ARM64_INCREMENT_PC) {
> +		kvm_skip_instr(vcpu);
> +		vcpu->arch.flags &= ~KVM_ARM64_INCREMENT_PC;
> +	}
> +}

What's your plan for restricting *when* EL1 can ask for the PC to be
adjusted?

I'm assuming that either:

1. You have EL2 sanity-check all responses from EL1 are permitted for
   the current state. e.g. if EL1 asks to increment the PC, EL2 must
   check that that was a sane response for the current state.

2. You raise the level of abstraction at the EL2/EL1 boundary, such that
   EL2 simply knows. e.g. if emulating a memory access, EL1 can either
   provide the response or signal an abort, but doesn't choose to
   manipulate the PC as EL2 will infer the right thing to do.

I know that either are tricky in practice, so I'm curious what your view
is. Generally option #2 is easier to fortify, but I guess we might have
to do #1 since we also have to support unprotected VMs?

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
