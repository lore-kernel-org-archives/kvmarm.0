Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F6618A6DB
	for <kvmarm@lists.linux.dev>; Wed, 29 Oct 2025 20:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761770724; cv=none; b=pnMteN2h4lSYE+IAoxEbPuLfs3fU4yNfKr+iQtqdgjGF7pzUbEmbrRcv1Htbh7cydyw20mGOykM6/ePEObWpRnoIlHqrE3ptxAIbSVbzYj9n7WAwLhxoMeA4EHdTAD20n8NDGxkENuBG+//Zhq3Ojb6fzRVhe2DXTu0T4h2eU1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761770724; c=relaxed/simple;
	bh=ulLgOXrempxnhkc8QBuR1SScFtqimPNsNISkAaKWKoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SjtnLm7hHltwMUS25so9ZzpkGA4m/kX1LjqXuPtGxJ0pLsZrlnZcNw+/2/wOv4Cq2avdBYEJoUFG+ZzXMmyWAcQTpyw8oy/D6vyvrPbZ4LaXgQcsuyR1CNpf0K3CYUln76jkYNZMgPTloXSguECKzkL5lCmABJhY3N1JnQTfqNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cDUZ9O0J; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cDUZ9O0J"
Date: Wed, 29 Oct 2025 13:45:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761770720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hjWyo6uOfN+xF80KKFI5BtoiaYMueiNClbqh3PY0wpI=;
	b=cDUZ9O0J21zXqhP2dHUhcwFujSNAC6y/8SVTyl1TJZ+/KF/5mr+B4mG8uv5x1qwaJyCM8Q
	AqzfI26kFG4jEcgCi+yIaqJVIJZjHHRAxoIQdNPj2Thm/A/q1ZKihK9SVthLU7FvjEhSLD
	ZPooe3pbRgDNnhWhlmRquAimlOyMl9k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ben Horgan <ben.horgan@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	shuah@kernel.org
Subject: Re: [PATCH 2/3] KVM: arm64: selftests: Remove
 ARM64_FEATURE_FIELD_BITS and its last user
Message-ID: <aQJ8so_oAXfeyxn_@linux.dev>
References: <20251014102108.2442391-1-ben.horgan@arm.com>
 <20251014102108.2442391-3-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014102108.2442391-3-ben.horgan@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Ben,

On Tue, Oct 14, 2025 at 11:21:07AM +0100, Ben Horgan wrote:
> ARM64_FEATURE_FIELD_BITS is set to 4 but not all ID register fields are 4
> bits. See for instance ID_AA64SMFR0_EL1. The last user of this define,
> ARM64_FEATURE_FIELD_BITS, is the set_id_regs selftest. Its logic assumes
> the fields aren't a single bits; assert that's the case and stop using the
> define. As there are no more users, ARM64_FEATURE_FIELD_BITS is removed.
> 
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
>  arch/arm64/include/asm/sysreg.h                 | 2 --
>  tools/testing/selftests/kvm/arm64/set_id_regs.c | 8 ++++++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 6455db1b54fd..d9aa76d08e13 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -1129,8 +1129,6 @@
>  #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
>  #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
>  
> -#define ARM64_FEATURE_FIELD_BITS	4
> -
>  #ifdef __ASSEMBLY__
>  
>  	.macro	mrs_s, rt, sreg

You can send this diff as a separate patch. Selftests actually uses the
definition from tools/arch/arm64/include/asm/sysreg.h, so you'll want to
drop that definition along with the change to set_id_regs.

Thanks,
Oliver
