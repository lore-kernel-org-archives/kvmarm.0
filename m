Return-Path: <SRS0=NTVD=U4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF47EC5B57B
	for <kvmarm@archiver.kernel.org>; Sat, 29 Jun 2019 22:42:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 75F9E2086D
	for <kvmarm@archiver.kernel.org>; Sat, 29 Jun 2019 22:42:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75F9E2086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC45B4A4F0;
	Sat, 29 Jun 2019 18:42:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7ZCzBkFaSt-b; Sat, 29 Jun 2019 18:42:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79AC34A4F6;
	Sat, 29 Jun 2019 18:42:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E26664A4EC
 for <kvmarm@lists.cs.columbia.edu>; Sat, 29 Jun 2019 18:42:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A0eTbUc61M4S for <kvmarm@lists.cs.columbia.edu>;
 Sat, 29 Jun 2019 18:42:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F7D64A479
 for <kvmarm@lists.cs.columbia.edu>; Sat, 29 Jun 2019 18:42:41 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA799344;
 Sat, 29 Jun 2019 15:42:40 -0700 (PDT)
Received: from why (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 118E73F246;
 Sat, 29 Jun 2019 15:42:39 -0700 (PDT)
Date: Sat, 29 Jun 2019 23:42:32 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
To: Jan Kiszka <jan.kiszka@web.de>
Subject: Re: KVM works on RPi4
Message-ID: <20190629234232.484ca3c0@why>
In-Reply-To: <1d1198c2-f362-840d-cb14-9a6d74da745c@web.de>
References: <1d1198c2-f362-840d-cb14-9a6d74da745c@web.de>
Organization: ARM Ltd
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>
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

On Sat, 29 Jun 2019 19:09:37 +0200
Jan Kiszka <jan.kiszka@web.de> wrote:

Hi Jan,

> Hi all,
> 
> just got KVM running on the Raspberry Pi4. Seems they now embedded all
> required logic into that new SoC.

Yeah, someone saw the light and decided to enter the 21st century by
attaching a GICv2 to the thing. Who knows, they may plug a GICv3 and a
SMMU in 2050 at that rate! ;-)

> However, as the Raspberry kernel is not yet ready for 64-bit (and
> upstream is not in sight), I had to use legacy 32-bit mode. And there we
> stumble over the core detection. This little patch made it work, though:
> 
> diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
> index 2b8de885b2bf..01606aad73cc 100644
> --- a/arch/arm/kvm/guest.c
> +++ b/arch/arm/kvm/guest.c
> @@ -290,6 +290,7 @@ int __attribute_const__ kvm_target_cpu(void)
>  	case ARM_CPU_PART_CORTEX_A7:
>  		return KVM_ARM_TARGET_CORTEX_A7;
>  	case ARM_CPU_PART_CORTEX_A15:
> +	case ARM_CPU_PART_CORTEX_A72:
>  		return KVM_ARM_TARGET_CORTEX_A15;
>  	default:
>  		return -EINVAL;
> 
> That raises the question if this is hack or a valid change and if there
> is general interest in mapping 64-bit cores on 32-bit if they happen to
> run in 32-bit mode.

The real thing to do here would be to move to a generic target, much
like we did on the 64bit side. Could you investigate that instead? It
would also allow KVM to be used on other 32bit cores such as
A12/A17/A32.

Although some would argue that the *real* real thing to do would be "rm
-rf arch/arm/kvm" and be done with it, but that's a discussion for next
week... ;-)

> Jan
> 
> PS: The RPi device tree lacks description of the GICH maintenance
> interrupts. Seems KVM is fine without that - because it has the
> information hard-coded or because it can live without that interrupt?

Nah, it really should have an interrupt here. You can end-up in
situation where new virtual interrupts are delayed until the next
natural exit if you don't get a maintenance interrupt. Feels like a bug.

Anyway, if you know of any effort to get a 64bit kernel on that thing,
I'm interested in helping. I bought one on Monday, but didn't get a
change to do any hacking on it just yet...

Thanks,

	M.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
