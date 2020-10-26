Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F08C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 14:22:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F209B22202
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 14:22:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F209B22202
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30FB04B4DF;
	Mon, 26 Oct 2020 10:22:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2OMDGBnNwrmJ; Mon, 26 Oct 2020 10:22:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1344D4B4E1;
	Mon, 26 Oct 2020 10:22:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 276514B4AC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 10:22:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hHvozyFKgtQ1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 10:22:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE7FC4B47B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 10:22:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FD4530E;
 Mon, 26 Oct 2020 07:22:05 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.56.187])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E35753F68F;
 Mon, 26 Oct 2020 07:22:03 -0700 (PDT)
Date: Mon, 26 Oct 2020 14:22:01 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 07/11] KVM: arm64: Inject AArch64 exceptions from HYP
Message-ID: <20201026142201.GH12454@C02TD0UTHF1T.local>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-8-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201026133450.73304-8-maz@kernel.org>
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

On Mon, Oct 26, 2020 at 01:34:46PM +0000, Marc Zyngier wrote:
> Move the AArch64 exception injection code from EL1 to HYP, leaving
> only the ESR_EL1 updates to EL1. In order to come with the differences
> between VHE and nVHE, two set of system register accessors are provided.
> 
> SPSR, ELR, PC and PSTATE are now completely handled in the hypervisor.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

>  void kvm_inject_exception(struct kvm_vcpu *vcpu)
>  {
> +	switch (vcpu->arch.flags & KVM_ARM64_EXCEPT_MASK) {
> +	case KVM_ARM64_EXCEPT_AA64_EL1_SYNC:
> +		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
> +		break;
> +	case KVM_ARM64_EXCEPT_AA64_EL1_IRQ:
> +		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_irq);
> +		break;
> +	case KVM_ARM64_EXCEPT_AA64_EL1_FIQ:
> +		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_fiq);
> +		break;
> +	case KVM_ARM64_EXCEPT_AA64_EL1_SERR:
> +		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_serror);
> +		break;
> +	default:
> +		/* EL2 are unimplemented until we get NV. One day. */
> +		break;
> +	}
>  }

Huh, we're going to allow EL1 to inject IRQ/FIQ/SERROR *exceptions*
directly, rather than pending those via HCR_EL2.{VI,VF,VSE}? We never
used to have code to do that.

If we're going to support that we'll need to check against the DAIF bits
to make sure we don't inject an exception that can't be architecturally
taken. 

I guess we'll tighten that up along with the synchronous exception
checks, but given those three cases aren't needed today it might be
worth removing them from the switch for now and/or adding a comment to
that effect.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
