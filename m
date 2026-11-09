Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794245306;
	b=DYjtt6g0c5fwBbnENtxITVHXAlaZnwaISnZCQe2oC/6y3TthH1cRV70qrjd6LlXljdsF
	 fKgyFsdkSan8RkPhQfkv3m3441od8UelZE2TCBDN7D1ag1N3D1BO8mC7YUOLkOchY/CFz
	 ATgFtFlIKiX/RWY6hn6JKsntfGWvox+7MZK0uJdIlBCxBuMx7SpZ1C/rSSxUmnqPIuhzb
	 1I02jlu9sgO+2j0CMIoQHZWVy6R+ybpmqM5Xdeavq9BhaaCTElYGztWOl5ehVcT+w+O5n
	 URWcaRR7UhOAeDyMavbggW/SulbeiorVYYiIkySVpDPvQvE4VZCFWX5F2raVLh0nj8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794245306;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=idRy2pWZwdOKwrw4mQsHyy46kwdf1XSQIvkugJx6fsk=;
	b=l8D4zQhvxyZyxavvQmSMg97IfGF+R7MQUw3LpNEFQhcrJ0zE5OzuM+fRt3yCXy0v+jZW
	 rZBiviIRK0lN3MVHOSJWh7bzuYukpUxcUrQRhrH4CPFjPXHFTSWoOf5fxXZBJMA/NLUoG
	 k59cDWNnFAI4+iLxx7OOF8G6TzlpMJzPdsOXvuI77URlVvyi8KzvglbKzcIudRBHyhSJo
	 AtSWrB9ZcxQdJXcyjsJzUUYtx1lSB8NBXOj9vL3P4xZlAOSbD6OGl0e6EY9OvT4Rik53X
	 ciZvGJ1yb2bHfwlgkU2yhS8mCdBeuPWq+HFAIBR0RqMYRLYn0oBbTy+gdL/8+74WUbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=AMLjW+mf;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48103606A326
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 17:28:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48103606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=AMLjW+mf
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BC701476;
	Mon,  9 Nov 2026 09:28:21 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 20B183F673;
	Mon,  9 Nov 2026 09:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794245304; bh=JohJON2LUPAhhPpTBBTczW2nM5ozofpVwsslEXLoJbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AMLjW+mfnRTmBxcxy8sz5NaDZGC17CBBX0qol0P1H61ncADxdzmrT4IcAj1w3uazd
	 aSRyydrt0tyDjxWjLRaGY7g8Vkh3tWdK0QpnxGizDIgUBIKQ6kT5/0Su9x5BeeqL0D
	 wYuY1NwNuGRTzvJQBnU0Y94HOugSz06bkJqh2Qns=
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
Subject: Re: [PATCH 6/8] KVM: arm64: Add sys_reg_descs for remaining MTE CMO instructions
Date: Mon,  9 Nov 2026 17:28:20 +0000
Message-ID: <avICtPQtRH108ILM@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104192124.3932743-7-oupton@kernel.org>
References: <20261104192124.3932743-1-oupton@kernel.org> <20261104192124.3932743-7-oupton@kernel.org>
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

On Wed, Nov 04, 2026 at 11:21:22AM -0800, Oliver Upton wrote:
> Filtering unsupported cache maintenance instructions from a guest relies
> on either having a suitable FGU bit for the feature or a descriptor with
> a visibility() hook.
> 
> MTE CMO instructions can be trapped by HCR_EL2.TPCP and lack a suitable
> FGU. Add descriptors for the CMO instructions that UNDEF if MTE isn't
> implemented for the VM.
> 

I think I get the idea of using MTE_CMO_INSN(): having the visibility test 
for MTE defined in the previous patch, which makes sense with the above 
commit message: if !mte -> hidden, then on access it injects undefined.

Please help me understand the other way: if we have mte, then it calls the 
'access' callback, which is bad_cmo_trap(), which also inject undefined. 
What is the goal here?

Thanks!
Leo



> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index b45635471344..7f7a197a9ad6 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -4295,6 +4295,12 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  		.access = (access_fn),					\
>  	}
>  
> +static bool bad_cmo_trap(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			 const struct sys_reg_desc *r)
> +{
> +	return bad_trap(vcpu, p, r, "MTE CMO trap");
> +}
> +
>  #define MTE_CMO_INSN(insn, access_fn)					\
>  	{								\
>  		SYS_DESC(SYS_##insn),					\
> @@ -4304,7 +4310,9 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  
>  static struct sys_reg_desc sys_insn_descs[] = {
>  	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
> +	MTE_CMO_INSN(DC_IGVAC, bad_cmo_trap),
>  	MTE_CMO_INSN(DC_IGSW, access_dcsw),
> +	MTE_CMO_INSN(DC_IGDVAC, bad_cmo_trap),
>  	MTE_CMO_INSN(DC_IGDSW, access_dcsw),
>  
>  	SYS_INSN(AT_S1E1R, handle_at_s1e01),
> @@ -4321,6 +4329,7 @@ static struct sys_reg_desc sys_insn_descs[] = {
>  	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
>  	MTE_CMO_INSN(DC_CIGSW, access_dcsw),
>  	MTE_CMO_INSN(DC_CIGDSW, access_dcsw),
> +	MTE_CMO_INSN(DC_CIGDVAPS, bad_cmo_trap),
>  
>  	SYS_INSN(TLBI_VMALLE1OS, handle_tlbi_el1),
>  	SYS_INSN(TLBI_VAE1OS, handle_tlbi_el1),
> @@ -4394,6 +4403,15 @@ static struct sys_reg_desc sys_insn_descs[] = {
>  	SYS_INSN(TLBI_VALE1NXS, handle_tlbi_el1),
>  	SYS_INSN(TLBI_VAALE1NXS, handle_tlbi_el1),
>  
> +	MTE_CMO_INSN(DC_CGVAC, bad_cmo_trap),
> +	MTE_CMO_INSN(DC_CGDVAC, bad_cmo_trap),
> +	MTE_CMO_INSN(DC_CGVAP, bad_cmo_trap),
> +	MTE_CMO_INSN(DC_CGDVAP, bad_cmo_trap),
> +	MTE_CMO_INSN(DC_CGVADP, bad_cmo_trap),
> +	MTE_CMO_INSN(DC_CGDVADP, bad_cmo_trap),
> +	MTE_CMO_INSN(DC_CIGVAC, bad_cmo_trap),
> +	MTE_CMO_INSN(DC_CIGDVAC, bad_cmo_trap),
> +
>  	SYS_INSN(AT_S1E2R, handle_at_s1e2),
>  	SYS_INSN(AT_S1E2W, handle_at_s1e2),
>  	SYS_INSN(AT_S12E1R, handle_at_s12),
> -- 
> 2.47.3
> 
