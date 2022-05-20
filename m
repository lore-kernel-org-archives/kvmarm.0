Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E12FC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 20 May 2022 13:30:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60DB44B214;
	Fri, 20 May 2022 09:30:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mh+tJ6WdEPYN; Fri, 20 May 2022 09:30:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 203914B29B;
	Fri, 20 May 2022 09:30:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD0CE4B214
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 09:30:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Si2LL+uKshIR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 May 2022 09:30:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BF504B1F7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 09:30:52 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EAF451477;
 Fri, 20 May 2022 06:30:51 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 889D63F73D;
 Fri, 20 May 2022 06:30:50 -0700 (PDT)
Date: Fri, 20 May 2022 14:31:03 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH kvmtool] aarch64: Give up with MTE for AArch32 guest
Message-ID: <YoeYF/J2O/cLXmXZ@monolith.localdoman>
References: <20220520123844.127733-1-vladimir.murzin@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220520123844.127733-1-vladimir.murzin@arm.com>
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi Vladimir,

When I run an --aarch32 guest with --debug this is the message that I'm
getting:

  Info: (arm/aarch64/kvm.c) kvm__arch_enable_mte:146: MTE capability not available

Would you mind elaborating on the merits of the message that you are
proposing:

  Info: (arm/aarch64/kvm.c) kvm__arch_enable_mte:124: MTE is incompatible with AArch32

Is it because it explains why the capability is not available?

Thanks,
Alex

On Fri, May 20, 2022 at 01:38:44PM +0100, Vladimir Murzin wrote:
> KVM doesn't support combination of MTE and AArch32 guest, so do not
> even try.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
> ---
>  arm/aarch64/kvm.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
> index 1b992dd..f3fe854 100644
> --- a/arm/aarch64/kvm.c
> +++ b/arm/aarch64/kvm.c
> @@ -120,6 +120,11 @@ void kvm__arch_enable_mte(struct kvm *kvm)
>  		.cap = KVM_CAP_ARM_MTE,
>  	};
>  
> +	if (kvm->cfg.arch.aarch32_guest) {
> +		pr_debug("MTE is incompatible with AArch32");
> +		return;
> +	}
> +
>  	if (kvm->cfg.arch.mte_disabled) {
>  		pr_debug("MTE disabled by user");
>  		return;
> -- 
> 2.25.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
