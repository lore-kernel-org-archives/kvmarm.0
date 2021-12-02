Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3EDC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  2 Dec 2021 10:58:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D26AD4B121;
	Thu,  2 Dec 2021 05:58:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QcwTIF4ZXo0O; Thu,  2 Dec 2021 05:58:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DD274B164;
	Thu,  2 Dec 2021 05:58:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5A234B121
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 05:58:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zyno0eRCm7B4 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Dec 2021 05:58:54 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B2A64B11E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Dec 2021 05:58:54 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1638442734;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wRIl4oD7Y5fkUN5tfay4kekz4HgS1IifoWLggGlVW1I=;
 b=PqTU0J2QvLYOTWuMuXOYgSfWcNEfElkSvQjzdV82ylVbk8FmneTiTArWGLGE0m+kcC1fMT
 YrT4lthFlI0Dqh+XGdtq2825o+Jl3uu4KifjIxmCljcey+QeFpyF51om+eB7ffSBgx3EeW
 YbA/0PpDC/X7Z97g5vTl6nrvqv5z/hI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-431-86ivAji2Oty_q7f2spxyEA-1; Thu, 02 Dec 2021 05:58:53 -0500
X-MC-Unique: 86ivAji2Oty_q7f2spxyEA-1
Received: by mail-wm1-f71.google.com with SMTP id
 z138-20020a1c7e90000000b003319c5f9164so1489079wmc.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Dec 2021 02:58:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=wRIl4oD7Y5fkUN5tfay4kekz4HgS1IifoWLggGlVW1I=;
 b=treXuJdtw91ervZDABmNWbnlRJlDdBS/YA6TQiTwk7TxnMtdUGjsvHxYKDwFWbQQD7
 IsThayKkoGPVe1TAXGy6K8Y6RFrfyanAmx4oQsd4dH2S//yc6OICa4LEnkSXRfBWkmve
 QRXriAkMKd2ZJXs4kdS4L67cMV4dzIUB4LHVJ9DZOpUEn+66jqu5CGeMptdDMezJbEFt
 YineHiz7Iu54tD2JEiKS3QVwO0uYGM2r1SRdXsbGI17Qg7jAmGFGr2VApT7l643v7tMI
 U1cJHbT3Bn57yBIYij8LpJmDs+vJhj0OMy7twtSay0bN6sVQiSPTwY6eBMiVlhEiOOH2
 Vv5w==
X-Gm-Message-State: AOAM532S33VB6IVQ8qpyWJ3vMSD/QXunWDKBv7PDawj1n2IcwluRY5N2
 qU8djYS4IUu6wDZ3XgngVXs3E/H3ExGzBTreM2/bBDQXXuH3jS0LfRueKeGf2zNXSHxuuZJmbSK
 KyTCAi9vpmno2iYjAvTN74tYQ
X-Received: by 2002:a5d:59ae:: with SMTP id p14mr13407448wrr.365.1638442732171; 
 Thu, 02 Dec 2021 02:58:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwdyKWGj2oyPnzq4Mdj75inkETU6TFWFE6xL8kZngxharwOb3Jh07jKn6KFiajYEjau2R9aEw==
X-Received: by 2002:a5d:59ae:: with SMTP id p14mr13407422wrr.365.1638442731933; 
 Thu, 02 Dec 2021 02:58:51 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id c1sm2247743wrt.14.2021.12.02.02.58.50
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 02 Dec 2021 02:58:51 -0800 (PST)
Subject: Re: [RFC PATCH v3 02/29] KVM: arm64: Save ID registers' sanitized
 value per vCPU
To: Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.cs.columbia.edu
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-3-reijiw@google.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <9f6e8b7e-c2b3-5883-f934-5b537c4ce19b@redhat.com>
Date: Thu, 2 Dec 2021 11:58:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211117064359.2362060-3-reijiw@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>
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

Hi Reiji,

On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> registers' sanitized value in the array for the vCPU at the first
> vCPU reset. Use the saved ones when ID registers are read by
> userspace (via KVM_GET_ONE_REG) or the guest.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 10 +++++++
>  arch/arm64/kvm/sys_regs.c         | 43 +++++++++++++++++++------------
>  2 files changed, 37 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index edbe2cb21947..72db73c79403 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -146,6 +146,14 @@ struct kvm_vcpu_fault_info {
>  	u64 disr_el1;		/* Deferred [SError] Status Register */
>  };
>  
> +/*
> + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> + * where 0<=crm<8, 0<=op2<8.
> + */
> +#define KVM_ARM_ID_REG_MAX_NUM 64
> +#define IDREG_IDX(id)		((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> +#define IDREG_SYS_IDX(id)	(ID_REG_BASE + IDREG_IDX(id))
> +
>  enum vcpu_sysreg {
>  	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
>  	MPIDR_EL1,	/* MultiProcessor Affinity Register */
> @@ -210,6 +218,8 @@ enum vcpu_sysreg {
>  	CNTP_CVAL_EL0,
>  	CNTP_CTL_EL0,
>  
> +	ID_REG_BASE,
> +	ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
>  	/* Memory Tagging Extension registers */
>  	RGSR_EL1,	/* Random Allocation Tag Seed Register */
>  	GCR_EL1,	/* Tag Control Register */
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e3ec1a44f94d..5608d3410660 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -33,6 +33,8 @@
>  
>  #include "trace.h"
>  
> +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
> +
>  /*
>   * All of this file is extremely similar to the ARM coproc.c, but the
>   * types are different. My gut feeling is that it should be pretty
> @@ -273,7 +275,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
>  			  struct sys_reg_params *p,
>  			  const struct sys_reg_desc *r)
>  {
> -	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> +	u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
>  	u32 sr = reg_to_encoding(r);
>  
>  	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
> @@ -1059,17 +1061,9 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> -static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> -		struct sys_reg_desc const *r, bool raz)
> +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>  {
> -	u32 id = reg_to_encoding(r);
> -	u64 val;
> -
> -	if (raz)
> -		return 0;
> -
> -	val = read_sanitised_ftr_reg(id);
> +	u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
>  
>  	switch (id) {
>  	case SYS_ID_AA64PFR0_EL1:
> @@ -1119,6 +1113,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  	return val;
>  }
>  
> +static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> +		       struct sys_reg_desc const *r, bool raz)
> +{
> +	u32 id = reg_to_encoding(r);
> +
> +	return raz ? 0 : __read_id_reg(vcpu, id);
> +}
> +
>  static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
>  				  const struct sys_reg_desc *r)
>  {
> @@ -1178,6 +1180,16 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
>  	return REG_HIDDEN;
>  }
>  
> +static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
> +{
> +	u32 id = reg_to_encoding(rd);
> +
> +	if (vcpu_has_reset_once(vcpu))
> +		return;
The KVM API allows to call VCPU_INIT several times (with same
target/feature). With above check on the second call the ID_REGS won't
be reset. Somehow this is aligned with target/feature behavior. However
if this is what we want, I think we would need to document it in the KVM
API doc.

Thanks

Eric
> +
> +	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = read_sanitised_ftr_reg(id);
> +}
> +
>  static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  			       const struct sys_reg_desc *rd,
>  			       const struct kvm_one_reg *reg, void __user *uaddr)
> @@ -1223,9 +1235,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  /*
>   * cpufeature ID register user accessors
>   *
> - * For now, these registers are immutable for userspace, so no values
> - * are stored, and for set_id_reg() we don't allow the effective value
> - * to be changed.
> + * We don't allow the effective value to be changed.
>   */
>  static int __get_id_reg(const struct kvm_vcpu *vcpu,
>  			const struct sys_reg_desc *rd, void __user *uaddr,
> @@ -1382,6 +1392,7 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
>  #define ID_SANITISED(name) {			\
>  	SYS_DESC(SYS_##name),			\
>  	.access	= access_id_reg,		\
> +	.reset	= reset_id_reg,			\
>  	.get_user = get_id_reg,			\
>  	.set_user = set_id_reg,			\
>  	.visibility = id_visibility,		\
> @@ -1837,8 +1848,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
>  	if (p->is_write) {
>  		return ignore_write(vcpu, p);
>  	} else {
> -		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> -		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> +		u64 dfr = __read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
> +		u64 pfr = __read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
>  		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
>  
>  		p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
