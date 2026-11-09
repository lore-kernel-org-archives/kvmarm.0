Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243845;
	b=WalxYGoztyDK8AaqaI8aykz8j01BB5huBJUpicqBZYmCVQcyw+vtbW0pUNt5vs5W9r8U
	 HzV0BP39KrPHG9Mf84DKPLgtmZMdax86yh8mjlN63PvmFw46gYnzffbmhaOST4FyKo8Tr
	 5k+T//MjQDR95PO/cxwNTE4pselVum8p87rf0zivDHK1b/vS4FykWrxiI1G3DTCAYWBoQ
	 bmMkJ5L+9bEkIIkjmaAJFFGoxe+5/iBcYrGdLddVMU+o5MjJlKjG+EETSAGUWFgHAkahP
	 mKCHGtHTA2c+uETHkGnrpqNuFDwwAjSjyQCW76sXGKbDW5yBU5mX5eXZB5MK5eRQX+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243845;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=0EWvuGDjpdzfrT48VxmbWbJfJ7psCITFWwBtNzuBTDo=;
	b=dhmfTdhRdMFqJ0GclwaYNxt6CAVZEP2WHDjq26zMMQ7v4bHqXjv5sZZvGLgWLAmLropn
	 A1DUxij2cMa+B1rmYXJnrgOnRo7Q7zoqeg27nvALF3Vnhvm+Hf5DOhTz9YgDWzIZJl66v
	 CVQdBp6IYWDBlqsDYFR2gpmfMLgB8ps4kfyrr6A9KOSA+f32sjQvq5vDGWhC1vtC5E75m
	 yUptrKpbPQ7JKcBdmZ0EGUiQM3UCsWvGTRxlcTaWFzBaueXPHegOSe250lcL8QAJi/CGy
	 nqabPiOxwu/IDXpkzguWFbQ2KhOMyIU63ljsscndtBXKhScTl6fW31MjcngqqRhA0rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=hXzBIQVq;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 641CC606A31C
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 17:04:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 641CC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=hXzBIQVq
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A03D1477;
	Mon,  9 Nov 2026 09:03:59 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 013B03F632;
	Mon,  9 Nov 2026 09:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794243842; bh=WkYL04xaYS7b8Z+q+VC+SEHKe0pWirqoeIlkkhpf1d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hXzBIQVqh+iLTHEXQkeAPzr/lBlPBZHqm2tMqYhZxGxQsEQSj4Ke+SPiLh6CILfhO
	 VESPblvkgDpkSkcyo9A53eUffklTwLq5saQdc3vQ3PNJlcf2HaWuD3qmdGrQl5HnEF
	 dJREHMtW9rh9h4t2NZZAK08G5Zl9MTNzQ+0drcVs=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH 5/8] KVM: arm64: Use ->visibility() to filter MTE CMO instructions
Date: Mon,  9 Nov 2026 17:03:58 +0000
Message-ID: <avH8_i8njhPKjzue@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104192124.3932743-6-oupton@kernel.org>
References: <20261104192124.3932743-1-oupton@kernel.org> <20261104192124.3932743-6-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Nov 04, 2026 at 11:21:21AM -0800, Oliver Upton wrote:
> More descriptors for MTE CMO instructions are on the way; prepare by
> using sys_reg_desc::visibility() to hide instructions when MTE isn't
> implemented.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 30 +++++++++++++-----------------
>  1 file changed, 13 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 0b21b454242c..b45635471344 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -556,17 +556,6 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> -static bool access_dcgsw(struct kvm_vcpu *vcpu,
> -			 struct sys_reg_params *p,
> -			 const struct sys_reg_desc *r)
> -{
> -	if (!kvm_has_mte(vcpu->kvm))
> -		return undef_access(vcpu, p, r);
> -
> -	/* Treat MTE S/W ops as we treat the classic ones: with contempt */
> -	return access_dcsw(vcpu, p, r);
> -}
> -
>  static void get_access_mask(const struct sys_reg_desc *r, u64 *mask, u64 *shift)
>  {
>  	switch (r->aarch32_map) {
> @@ -4306,10 +4295,17 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  		.access = (access_fn),					\
>  	}
>  
> +#define MTE_CMO_INSN(insn, access_fn)					\
> +	{								\
> +		SYS_DESC(SYS_##insn),					\
> +		.access	= (access_fn),					\
> +		.visibility = mte_visibility,				\
> +	}
> +
>  static struct sys_reg_desc sys_insn_descs[] = {
>  	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
> -	{ SYS_DESC(SYS_DC_IGSW), access_dcgsw },
> -	{ SYS_DESC(SYS_DC_IGDSW), access_dcgsw },
> +	MTE_CMO_INSN(DC_IGSW, access_dcsw),
> +	MTE_CMO_INSN(DC_IGDSW, access_dcsw),
>  
>  	SYS_INSN(AT_S1E1R, handle_at_s1e01),
>  	SYS_INSN(AT_S1E1W, handle_at_s1e01),
> @@ -4320,11 +4316,11 @@ static struct sys_reg_desc sys_insn_descs[] = {
>  	SYS_INSN(AT_S1E1A, handle_at_s1e01),
>  
>  	{ SYS_DESC(SYS_DC_CSW), access_dcsw },
> -	{ SYS_DESC(SYS_DC_CGSW), access_dcgsw },
> -	{ SYS_DESC(SYS_DC_CGDSW), access_dcgsw },
> +	MTE_CMO_INSN(DC_CGSW, access_dcsw),
> +	MTE_CMO_INSN(DC_CGDSW, access_dcsw),
>  	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
> -	{ SYS_DESC(SYS_DC_CIGSW), access_dcgsw },
> -	{ SYS_DESC(SYS_DC_CIGDSW), access_dcgsw },
> +	MTE_CMO_INSN(DC_CIGSW, access_dcsw),
> +	MTE_CMO_INSN(DC_CIGDSW, access_dcsw),
>  
>  	SYS_INSN(TLBI_VMALLE1OS, handle_tlbi_el1),
>  	SYS_INSN(TLBI_VAE1OS, handle_tlbi_el1),
> -- 
> 2.47.3
> 


I understand the MTE_CMO_INSN to be just about making this sys_insn_descs[] 
easier to read. I also noticed you changed access_dcgsw() to access_dcsw() 
when you removed the function. 

The difference between the 2 is that access_dcgsw() checks for MTE before 
returning access_dcsw().

Since you now added .visibility = mte_visibility, which just returns 
REG_HIDDEN if !kvm_has_mte() it makes sense that access_dcgsw() became 
unnecessary.


FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
