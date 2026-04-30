Received: from out199-12.us.a.mail.aliyun.com (out199-12.us.a.mail.aliyun.com [47.90.199.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BA3230264
	for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 02:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.199.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777515747; cv=none; b=cK3Ojos7IaXzgmFQW8JFhhTvSKqpIjin6SVZPdLAcrQQVoMSBECgV21AkIsvOiEuAZwAQyAfr4U1rmXEEwHjR1a/SPGhYXl0TICPJjH2lpl5OQjDju7gl2DYQL4EAY0jNSImfSejkTEZncbo9fEjo56LbuHblb7Ivu8xyLnBGS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777515747; c=relaxed/simple;
	bh=kskXGl60052vWFg2uJaxvo0jP+mKoelIHMmuGjmHezA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=prJFC98gv88Abu7RYjsXr7ybISYUi+Z9exmSKZIBgNR3S4Ja/8YhBHqJYYvngFJCg1CDvwU5GQ94ZwMPJGUVLiNCQ3oxknAvR054u+r6bVpDrB1vnaxcwn+kFKedctofHuho+VtPUpyTVGwnBwSSbfuTloFcwXCGiKpNYqZlBIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=lJ7cmyo1; arc=none smtp.client-ip=47.90.199.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="lJ7cmyo1"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1777515728; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=H46ycR2cIdd55PmtPaTFZw2OcVc3hi3Ihdl6EegFnqI=;
	b=lJ7cmyo1tUN1B8eGVCIvY1nnLRNPxZMKHVZiM4AE38UAZxzxsyRWn92/OeuMd77bK3YEOZwkWA2HJSUH+DAc4mee6C6OqaiaWHbG7uuKGUC/PVw1r3PZH3D8Z83pX43dXQdDvs1GFglTxU3GsrgVDyLYeDWbGVNUwgdcEEh42Jw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X1za2vT_1777515727;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X1za2vT_1777515727 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 30 Apr 2026 10:22:08 +0800
Date: Thu, 30 Apr 2026 10:22:07 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Fuad Tabba <tabba@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com, vdonnefort@google.com, 
	catalin.marinas@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/8] KVM: arm64: Make EL2 exception entry and exit
 context-synchronization events
Message-ID: <ygj3ik6y6kqggfnoyz72klhk3ttv72qv2ob4qferjdo7wvtxc7@zvhup2sqtc2p>
References: <20260428103008.696141-1-tabba@google.com>
 <20260428103008.696141-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428103008.696141-2-tabba@google.com>

On Tue, Apr 28, 2026 at 11:30:01AM +0800, Fuad Tabba wrote:
> SCTLR_EL2.EIS and SCTLR_EL2.EOS control whether exception entry and
> exit at EL2 are Context Synchronisation Events (CSEs). Per ARM DDI
> 0487 M.b, EIS is governed by D1.4.2 rule RBBSRF (p. D1-7205) and EOS
> by D1.4.4.1 rule RBWCFK (p. D1-7209). D24.2.175 (p. D24-9754):
>
>   - !FEAT_ExS: the bit is RES1, so the entry/exit is unconditionally
>     a CSE.
>   - FEAT_ExS: the reset value is architecturally UNKNOWN; software
>     must set the bit to make the entry/exit a CSE.
>
> INIT_SCTLR_EL2_MMU_ON in arch/arm64/include/asm/sysreg.h sets neither
> bit. KVM/arm64 hot paths rely on ERET from EL2 being a CSE, and on
> synchronous EL1->EL2 entry being a CSE, to elide explicit ISBs after
> MSRs to context-switching system registers (HCR_EL2, HFGxTR_EL2,
> HCRX_EL2, ZCR_EL2, CPACR_EL1, CPTR_EL2, SCTLR_EL1, ptrauth keys,
> etc.); examples include the activate-traps path,
> ptrauth_switch_to_guest, and the FPSIMD trap re-enable in
> kvm_hyp_handle_fpsimd. On FEAT_ExS hardware those reliances are not
> architecturally backed unless EOS=1 (and, for entry, EIS=1), and
> whether they hold today depends on firmware initialisation outside
> the kernel's control.
>
> Make the guarantee explicit: include SCTLR_ELx_EIS | SCTLR_ELx_EOS in
> INIT_SCTLR_EL2_MMU_ON so that EL2 exception entry and exit are
> unconditionally CSEs regardless of whether FEAT_ExS is implemented.
> This matches the pairing in arch/arm64/kvm/config.c which treats EIS
> and EOS together as RES1 under !FEAT_ExS.
>
> INIT_SCTLR_EL2_MMU_OFF is left unchanged: that path is used during
> very early EL2 init and the EL2 MMU-off transition, neither of which
> relies on these bits in the same way.
>
> Fixes: fe2c8d19189e ("KVM: arm64: Turn SCTLR_ELx_FLAGS into INIT_SCTLR_EL2_MMU_ON")
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/sysreg.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 736561480f36..7aa08d59d494 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -844,7 +844,7 @@
>  #define INIT_SCTLR_EL2_MMU_ON						\
>  	(SCTLR_ELx_M  | SCTLR_ELx_C | SCTLR_ELx_SA | SCTLR_ELx_I |	\
>  	 SCTLR_ELx_IESB | SCTLR_ELx_WXN | ENDIAN_SET_EL2 |		\

Hi Fuad,

> -	 SCTLR_ELx_ITFSB | SCTLR_EL2_RES1)
> +	 SCTLR_ELx_ITFSB | SCTLR_ELx_EIS | SCTLR_ELx_EOS | SCTLR_EL2_RES1)

LGTM.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>
>  #define INIT_SCTLR_EL2_MMU_OFF \
>  	(SCTLR_EL2_RES1 | ENDIAN_SET_EL2)
> --
> 2.54.0.545.g6539524ca2-goog
>
