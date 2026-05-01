Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E8812367DF
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 13:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777643257; cv=none; b=srfWzn3VLHhqeklCYN/TxbNE9MSxR2XxQByb+MGAIU9hMC/On1UC/t6zwLMVolNMyzQjWeY9qH8bE96uF21dSMJGaSvib7atGaGB9gfG3WVaZAIbbSUiVKewk6djD9u0E4xsGUuINdKoBTr+efdPQUu3LPSUywinmBS/kg2dFaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777643257; c=relaxed/simple;
	bh=rwgXGr1STx/LEHE1ouffCIS69kHVohj7ROm+8Hh7vEg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rGmU67TnAAHNU4zOBj20vFWzRwEt2E+JfRSHvWM4OqwUslMR6sPYx556HhxrCom/Ef40LCVsrCiOSsqvY2zR+JH0jOKh07aOypxzfh7zrpsyDUi6T6Ix2/CWETm/PavEOM/xhn5EtrIzDPl+SQ7/YjE2UFf3H2k9wUqXon3pLBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=b6X4zW3y; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="b6X4zW3y"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CD2C176A;
	Fri,  1 May 2026 06:47:30 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0FB5E3F62B;
	Fri,  1 May 2026 06:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777643255; bh=rwgXGr1STx/LEHE1ouffCIS69kHVohj7ROm+8Hh7vEg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=b6X4zW3yp5qT6RabLlXDQVO/FeL7tPN2xjUmAxUqOuHLBhfKm042NUohm2aji/+WR
	 JXlvItA0VhST3veBOd24n4TpwRBypzfIiq0UjILPpKh+oQ7G2jDOi9Th/SzhmBj2wi
	 Mp8ScD8Qpzo9B9QD9wBvCHhHiQzQuAJaeSRIIU/4=
Message-ID: <a7e2ac96-b710-40e5-a159-b49555bcf518@arm.com>
Date: Fri, 1 May 2026 14:47:27 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH v2 1/6] KVM: arm64: Make EL2 exception entry and exit
 context-synchronization events
To: Fuad Tabba <tabba@google.com>, maz@kernel.org, oliver.upton@linux.dev
Cc: james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 qperret@google.com, vdonnefort@google.com, catalin.marinas@arm.com,
 will@kernel.org, yaoyuan@linux.alibaba.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260501112149.2824881-1-tabba@google.com>
 <20260501112149.2824881-2-tabba@google.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20260501112149.2824881-2-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 5/1/26 12:21, Fuad Tabba wrote:
> SCTLR_EL2.EIS and SCTLR_EL2.EOS control whether exception entry and
> exit at EL2 are Context Synchronisation Events (CSEs). Per ARM DDI
> 0487 M.b D24.2.175 (p. D24-9754):
> 
>   - !FEAT_ExS: the bit is RES1, so the entry/exit is unconditionally
>     a CSE.
>   - FEAT_ExS: the reset value is architecturally UNKNOWN; software
>     must set the bit to make the entry/exit a CSE.
> 
> INIT_SCTLR_EL2_MMU_ON in arch/arm64/include/asm/sysreg.h sets neither
> bit. KVM/arm64 hot paths rely on ERET from EL2 being a CSE, and on
> synchronous EL1->EL2 entry being a CSE, to elide explicit ISBs after
> MSRs to context-switching system registers (HCR_EL2, ZCR_EL2,
> ptrauth keys, etc.). On FEAT_ExS hardware those reliances are not
> architecturally backed unless EOS=1 (and, for entry, EIS=1).
> 
> Until commit 0a35bd285f43 ("arm64: Convert SCTLR_EL2 to sysreg
> infrastructure"), SCTLR_EL2_RES1 was a hand-rolled mask that
> included BIT(11) (EOS) and BIT(22) (EIS), so INIT_SCTLR_EL2_MMU_ON
> was setting both unconditionally. The conversion made
> SCTLR_EL2_RES1 auto-generated; because the sysreg tooling only
> models unconditionally-RES1 fields and EIS/EOS are RES1 only when
> FEAT_ExS is absent, the auto-generated mask is UL(0). The seven
> other bits dropped from the old mask (positions 4, 5, 16, 18, 23,
> 28, 29) are unconditionally RES1 in the E2H=0 SCTLR_EL2 layout per
> DDI 0487 M.b D24.2.175, so dropping them is harmless. EIS and EOS
> are the only bits whose semantics changed for FEAT_ExS hardware
> and where the kernel relies on the value being 1.
> 
> Make the guarantee explicit: include SCTLR_ELx_EIS | SCTLR_ELx_EOS in
> INIT_SCTLR_EL2_MMU_ON so that EL2 exception entry and exit are
> unconditionally CSEs regardless of whether FEAT_ExS is implemented.
> This matches the pairing in arch/arm64/kvm/config.c which treats EIS
> and EOS together as RES1 under !FEAT_ExS.

In v1 you also had this sentence:

"INIT_SCTLR_EL2_MMU_OFF is left unchanged: that path is used during
very early EL2 init and the EL2 MMU-off transition, neither of which
relies on these bits in the same way."

To me, it seems useful to keep that sentence as it makes it clear that INIT_SCTLR_EL2_MMU_OFF is purposely not changed.
Or is there a reason why you dropped it? Perhaps it's just obvious to people more familiar with this code.

Thanks,

Ben

> 
> Fixes: 0a35bd285f43 ("arm64: Convert SCTLR_EL2 to sysreg infrastructure")
> Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
> Assisted-by: Gemini:gemini-3.1-pro review-prompts
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
> -	 SCTLR_ELx_ITFSB | SCTLR_EL2_RES1)
> +	 SCTLR_ELx_ITFSB | SCTLR_ELx_EIS | SCTLR_ELx_EOS | SCTLR_EL2_RES1)
>  
>  #define INIT_SCTLR_EL2_MMU_OFF \
>  	(SCTLR_EL2_RES1 | ENDIAN_SET_EL2)

