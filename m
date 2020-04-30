Return-Path: <SRS0=Ot4E=6O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82AEC8300A
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 10:26:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 94D452137B
	for <kvmarm@archiver.kernel.org>; Thu, 30 Apr 2020 10:26:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eyqt08hG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94D452137B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 014F94B527;
	Thu, 30 Apr 2020 06:26:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CpEefpBSo+Er; Thu, 30 Apr 2020 06:26:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD80C4B530;
	Thu, 30 Apr 2020 06:26:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A9544B527
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 06:26:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kXgxyF1NH0h2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Apr 2020 06:26:02 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 834294B517
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Apr 2020 06:26:02 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id F06B420787;
 Thu, 30 Apr 2020 10:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588242361;
 bh=XMmX9NJ0VAXG1hzFUjwysZJZQwf95tai622IpWnK1ik=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Eyqt08hGlFtbAnwMcBbF8peC3OELFpvIkdOun0mkg1RH+la7llBFjFvbHtXK1llA0
 Vrhty+N7PRBTgmP5NznHqff7InfdZymwESJNyYURv8aIv7wG8s8xQRyerSJTQJPxCZ
 foRDopU4ChTxUozDR5O8vCPx9J0ncjH05G69bYIk=
Date: Thu, 30 Apr 2020 11:25:56 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix 32bit PC wrap-around
Message-ID: <20200430102556.GE19932@willie-the-truck>
References: <20200430101513.318541-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200430101513.318541-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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

On Thu, Apr 30, 2020 at 11:15:13AM +0100, Marc Zyngier wrote:
> In the unlikely event that a 32bit vcpu traps into the hypervisor
> on an instruction that is located right at the end of the 32bit
> range, the emulation of that instruction is going to increment
> PC past the 32bit range. This isn't great, as userspace can then
> observe this value and get a bit confused.
> 
> Conversly, userspace can do things like (in the context of a 64bit
> guest that is capable of 32bit EL0) setting PSTATE to AArch64-EL0,
> set PC to a 64bit value, change PSTATE to AArch32-USR, and observe
> that PC hasn't been truncated. More confusion.
> 
> Fix both by:
> - truncating PC increments for 32bit guests
> - sanitize PC every time a core reg is changed by userspace, and
>   that PSTATE indicates a 32bit mode.

It's not clear to me whether this needs a cc stable. What do you think? I
suppose that it really depends on how confused e.g. QEMU gets.

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/guest.c     | 4 ++++
>  virt/kvm/arm/hyp/aarch32.c | 8 ++++++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 23ebe51410f0..2a159af82429 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -200,6 +200,10 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	}
>  
>  	memcpy((u32 *)regs + off, valp, KVM_REG_SIZE(reg->id));
> +
> +	if (*vcpu_cpsr(vcpu) & PSR_AA32_MODE_MASK)
> +		*vcpu_pc(vcpu) = lower_32_bits(*vcpu_pc(vcpu));

It seems slightly odd to me that we don't enforce this for *all* the
registers when running as a 32-bit guest. Couldn't userspace be equally
confused by a 64-bit lr or sp?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
