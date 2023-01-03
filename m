Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A70C46467
	for <kvmarm@archiver.kernel.org>; Wed,  4 Jan 2023 11:03:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBBF34BAB1;
	Wed,  4 Jan 2023 06:03:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GR4m1U-5vn4J; Wed,  4 Jan 2023 06:03:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 930BD4BAE2;
	Wed,  4 Jan 2023 06:03:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2106A4BB65
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 12:59:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sEHD5nI+Ap33 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Jan 2023 12:59:18 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF7B84B906
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 12:59:17 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 80847B81082;
 Tue,  3 Jan 2023 17:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B243C433EF;
 Tue,  3 Jan 2023 17:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1672768755;
 bh=BQBoYvfeaYrZ/ZnQHX8h/k1Ir4dAZykoRUflCWLpJfA=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=RkCE0jAhiVPssH7l8lOr8dQjbEUrpGkUrth2kWwRPYN1I+NLfcClNKp1sqla6Me7o
 SMHzi91kte32ChBAoysjwEBkuOuEy4DVBMIKXOyU+TJpc4t7nwPYbcH/ZF/dyYFrpO
 jp1FgiyAZPCQ7aBzo2V7BbfzWv/sc37DTDzyfNQ3yiETANpZV8/qT++PEHJChb13Fw
 DdBMt5VuYcUfHleNL8O95sq/f1YUwky4n9BmSJC/qIS1O2IeghkDvMhZGltZVeDLxu
 5SxNY1YP3++6tX/FGXkBkaJlPg0hcvEB+dmH39TvLUCIiEDj1XKHgmqXV46P01TNpQ
 5LBiMveMr6/bQ==
Date: Tue, 3 Jan 2023 10:59:12 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/3] KVM: arm64: vgic: Add Apple M2 cpus to the list of
 broken SEIS implementations
Message-ID: <Y7Rs8Lc5u6L2Bz6o@dev-arch.thelio-3990X>
References: <20230103095022.3230946-1-maz@kernel.org>
 <20230103095022.3230946-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20230103095022.3230946-2-maz@kernel.org>
X-Mailman-Approved-At: Wed, 04 Jan 2023 06:03:29 -0500
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Sven Peter <sven@svenpeter.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Hector Martin <marcan@marcan.st>,
 linux-kernel@vger.kernel.org, asahi@lists.linux.dev, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Marc,

I have only been lurking on the kvmarm mailing list for a little bit and
it has mainly just been reading patches/review to get more familiar with
various virtualization concepts so I apologize if the following review
is rather shallow but...

On Tue, Jan 03, 2023 at 09:50:20AM +0000, Marc Zyngier wrote:
> I really hoped that Apple had fixed their not-quite-a-vgic implementation
> when moving from M1 to M2. Alas, it seems they didn't, and running
> a buggy EFI version results in the vgic generating SErrors outside
> of the guest and taking the host down.
> 
> Apply the same workaround as for M1. Yes, this is all a bit crap.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/cputype.h | 4 ++++
>  arch/arm64/kvm/vgic/vgic-v3.c    | 3 ++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
> index 4e8b66c74ea2..683ca3af4084 100644
> --- a/arch/arm64/include/asm/cputype.h
> +++ b/arch/arm64/include/asm/cputype.h
> @@ -124,6 +124,8 @@
>  #define APPLE_CPU_PART_M1_FIRESTORM_PRO	0x025
>  #define APPLE_CPU_PART_M1_ICESTORM_MAX	0x028
>  #define APPLE_CPU_PART_M1_FIRESTORM_MAX	0x029
> +#define APPLE_CPU_PART_M2_BLIZZARD	0x032
> +#define APPLE_CPU_PART_M2_AVALANCHE	0x033
>  
>  #define AMPERE_CPU_PART_AMPERE1		0xAC3
>  
> @@ -177,6 +179,8 @@
>  #define MIDR_APPLE_M1_FIRESTORM_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM_PRO)
>  #define MIDR_APPLE_M1_ICESTORM_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM_MAX)
>  #define MIDR_APPLE_M1_FIRESTORM_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM_MAX)
> +#define MIDR_APPLE_M2_BLIZZARD MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_BLIZZARD)
> +#define MIDR_APPLE_M2_AVALANCHE MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M2_AVALANCHE)
>  #define MIDR_AMPERE1 MIDR_CPU_MODEL(ARM_CPU_IMP_AMPERE, AMPERE_CPU_PART_AMPERE1)
>  
>  /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 826ff6f2a4e7..c6442b08fe80 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -615,7 +615,8 @@ static const struct midr_range broken_seis[] = {
>  	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_PRO),
>  	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_PRO),
>  	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_MAX),
> -	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_MAX),

The commit message makes no note of this removal, was it intentional?
MIDR_APPLE_M1_FIRESTORM_MAX is only used here so I assume it is not.

> +	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD),
> +	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE),
>  	{},
>  };
>  
> -- 
> 2.34.1
> 

Cheers,
Nathan
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
