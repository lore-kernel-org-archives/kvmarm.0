Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C17C433C1
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 11:33:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4F75961992
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 11:33:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F75961992
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E34C04B411;
	Mon, 22 Mar 2021 07:33:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id inb3QizwnsdG; Mon, 22 Mar 2021 07:33:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DACCF4B41A;
	Mon, 22 Mar 2021 07:33:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91C8F4B3B5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 07:33:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bCXtBhcbDIRX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 07:33:27 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8F9404B2BF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 07:33:27 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC56061984;
 Mon, 22 Mar 2021 11:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1616412806;
 bh=6NU8CoeVuy+xBCKoKihnD9B6AGKpzEVVYiFH3UaLDyk=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=hcbvPInN/ygnKoUF6quhfsskpgiEr0UaC3QmE06DLMyacDxFWj+MwPETGfaf9kYGu
 zDo7TsVsbSvfUWsGBeSSHa9NyS/b4HH7jpnn3sLEfg//A5Eu11MfxLgCgLccuEy8l9
 HHFt9/qD3rDSNTFpTLaVB0DvvTqwAYO0/OH5HnZk97F8bkKwggzVb/95O5141sXFfJ
 ZsHoZoZBw546UT6xSQXDl3llEHxCXeuKrqtmzQP9SeREnlannavgbOwyGo22j6F608
 mMAMYez9XflctPuRnTyskBuBxYBCX38k0pvKQVqVymzOsx6ApySA67mKOWOgLMYPBh
 7lY6nKkCYnOXw==
Date: Mon, 22 Mar 2021 11:33:20 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v6 33/38] KVM: arm64: Introduce KVM_PGTABLE_S2_IDMAP
 stage 2 flag
Message-ID: <20210322113320.GD10318@willie-the-truck>
References: <20210319100146.1149909-1-qperret@google.com>
 <20210319100146.1149909-34-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210319100146.1149909-34-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Fri, Mar 19, 2021 at 10:01:41AM +0000, Quentin Perret wrote:
> Introduce a new stage 2 configuration flag to specify that all mappings
> in a given page-table will be identity-mapped, as will be the case for
> the host. This allows to introduce sanity checks in the map path and to
> avoid programming errors.
> 
> Suggested-by: Will Deacon <will@kernel.org>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 2 ++
>  arch/arm64/kvm/hyp/pgtable.c         | 3 +++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 55452f4831d2..c3674c47d48c 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -60,9 +60,11 @@ struct kvm_pgtable_mm_ops {
>   * enum kvm_pgtable_stage2_flags - Stage-2 page-table flags.
>   * @KVM_PGTABLE_S2_NOFWB:	Don't enforce Normal-WB even if the CPUs have
>   *				ARM64_HAS_STAGE2_FWB.
> + * @KVM_PGTABLE_S2_IDMAP:	Only use identity mappings.
>   */
>  enum kvm_pgtable_stage2_flags {
>  	KVM_PGTABLE_S2_NOFWB			= BIT(0),
> +	KVM_PGTABLE_S2_IDMAP			= BIT(1),
>  };
>  
>  /**
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b22b4860630c..c37c1dc4feaf 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -760,6 +760,9 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  		.arg		= &map_data,
>  	};
>  
> +	if (WARN_ON((pgt->flags & KVM_PGTABLE_S2_IDMAP) && (addr != phys)))
> +		return -EINVAL;

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
