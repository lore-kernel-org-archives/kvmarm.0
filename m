Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D2BC433DB
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 16:33:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5721E64F2F
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 16:33:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5721E64F2F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFF604B2F6;
	Mon, 15 Mar 2021 12:33:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iAOacwnLN3GD; Mon, 15 Mar 2021 12:33:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 287D24B2C6;
	Mon, 15 Mar 2021 12:33:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52BA14B2F3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 12:33:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BASENFcobnEV for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 12:33:31 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6741C4B27F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 12:33:31 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1A4664E42;
 Mon, 15 Mar 2021 16:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615826008;
 bh=f4K1PQi5GoA8DyancBzvuA/NuLTUjdftl7M7gxwy1No=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=EjR/pS1cN3N97EsHHqVbRHIBpoeGPaSsRmHGYdei+80OM7tDfbC1i28OhSuN6mh3e
 el0hMbHrqnIr7uMJfvqUWvkl6ZWIsYs7xuEvtZA+virmRuz8lnOTQDvyi4Bz3iB1PU
 sb8UCVALUTP17F3wvYYCzD/GfJpxTi3tiPShtzvB6jKwi/GJFp0fGwRvOzacFJQWLG
 cdwk6YxVlVYVtn0c6AaW99h4Ccx0UvP4R40QO03FMjcwqYHdvXusB5yWCemYBotqCy
 fJQHP4Wd7rrcs6Rjfqp7Xc9Gb2uKyN1H1ckKf1Lf4Y86ol/YwKwUZisOzJy3fPZ/uP
 wsfFBPi3b+O2A==
Date: Mon, 15 Mar 2021 16:33:23 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v5 14/36] KVM: arm64: Provide __flush_dcache_area at EL2
Message-ID: <20210315163322.GE3430@willie-the-truck>
References: <20210315143536.214621-1-qperret@google.com>
 <20210315143536.214621-15-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210315143536.214621-15-qperret@google.com>
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

On Mon, Mar 15, 2021 at 02:35:14PM +0000, Quentin Perret wrote:
> We will need to do cache maintenance at EL2 soon, so compile a copy of
> __flush_dcache_area at EL2, and provide a copy of arm64_ftr_reg_ctrel0
> as it is needed by the read_ctr macro.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_cpufeature.h |  2 ++
>  arch/arm64/kvm/hyp/nvhe/Makefile        |  3 ++-
>  arch/arm64/kvm/hyp/nvhe/cache.S         | 13 +++++++++++++
>  arch/arm64/kvm/sys_regs.c               |  1 +
>  4 files changed, 18 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/cache.S
> 
> diff --git a/arch/arm64/include/asm/kvm_cpufeature.h b/arch/arm64/include/asm/kvm_cpufeature.h
> index 3fd9f60d2180..efba1b89b8a4 100644
> --- a/arch/arm64/include/asm/kvm_cpufeature.h
> +++ b/arch/arm64/include/asm/kvm_cpufeature.h
> @@ -13,3 +13,5 @@
>  #define KVM_HYP_CPU_FTR_REG(name) extern struct arm64_ftr_reg kvm_nvhe_sym(name)
>  #endif
>  #endif
> +
> +KVM_HYP_CPU_FTR_REG(arm64_ftr_reg_ctrel0);

I still think this is a bit weird. If you really want to macro-ise stuff,
then why not follow the sort of thing we do for e.g. per-cpu variables and
have separate DECLARE_HYP_CPU_FTR_REG and DEFINE_HYP_CPU_FTR_REG macros.

That way kvm_cpufeature.h can have header guards like a normal header and
we can drop the '#ifndef KVM_HYP_CPU_FTR_REG' altogether. I don't think
the duplication of the symbol name really matters -- it should fail at
build time if something is missing.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
