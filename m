Return-Path: <SRS0=n2ZT=KJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECC1C433B4
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 17:53:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F3D8E61408
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 17:53:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3D8E61408
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 716F04B9B9;
	Fri, 14 May 2021 13:53:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2uqStqrBTfEt; Fri, 14 May 2021 13:53:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF4334B9BA;
	Fri, 14 May 2021 13:53:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28AC84B9B8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 13:53:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mx7XxZbMvM0y for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 May 2021 13:53:08 -0400 (EDT)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 99A0C4B9B6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 13:53:08 -0400 (EDT)
Received: by mail-pf1-f176.google.com with SMTP id k19so275000pfu.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 May 2021 10:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=41yO8Va57ioWWsjHATF1Of9kOAfW6M275O9j1jXypcY=;
 b=LnAh7ahOdwDtv4sCfsgcSDdQm2mof4guWSD1Trdy806n1lKVCG++dfWP5x/mPCGBTC
 AkrEFHI7FQ1b64lcida2nsMeU7UKYRnZ1KfC+U4uucrt0xEe3FRDIWcSjAcR8Zn8oRii
 /Xf/7VYB98KPJzFC3h4D3Q9wqcX9mOZoqhgJRZQOTxgKCiaaLhQBM6bjWkm/sP14xLmw
 BPbUzjIrcWFmDGVGbLYmpozQssexvn1EvjUWRJXxHys9HOfFoKvanceaWqu6VrWFKMvE
 EF1FcxV7227J4xcLataEonm7Y3iAglhncqG0kbAw0Bb2q0kmq4Qtzf9c3uwfsU6Y6AJ8
 vFkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=41yO8Va57ioWWsjHATF1Of9kOAfW6M275O9j1jXypcY=;
 b=LwoD589YEk9FRCnjdvwQO6LSi8TvyYQgxuuCMIVpGxHvoqQUSYWbuzae6ULBaivvpk
 WfasYiOcqUsKruPXHT52Ajpj74MQSNgIgDN4PhMr6k7vpfNnh8R3gPXx0nVDlnNxgJXk
 E3qcLogsq17Jmdliz75SqjCjdrD+e+BEDhYSe8eGm4z92isGA9H8Dq2MxZoB4kJuMcWS
 PoRMCcdA4UZXFIhvLsso2b8Ga0hWYAyiCFkuKQvmoCki4oJYMkxS5q7TKdqhcrYekUmh
 /iVvyysPc25okRppdCCQ7EeqxL7AXq9CSHCr6xuKYQdmKHOVVBkxii+l+a6bGYHcsRAn
 pSyQ==
X-Gm-Message-State: AOAM533i4zdhvC/hrZV1ulCQH2kvayL1h0bcXjBvCbjSqZWUjernzZme
 2/orAI25y2OP0g7T/XqGMkEbnA==
X-Google-Smtp-Source: ABdhPJw2STCFTK/SD7nGvzKA6e7dz/NC+FMWdiWQmVbDQsjLxytc0OqwdNOFHniSPGQdx5CWpeEhww==
X-Received: by 2002:aa7:955b:0:b029:28e:a874:d0c2 with SMTP id
 w27-20020aa7955b0000b029028ea874d0c2mr46297999pfq.66.1621014787428; 
 Fri, 14 May 2021 10:53:07 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id d3sm4673557pfn.141.2021.05.14.10.53.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 14 May 2021 10:53:06 -0700 (PDT)
Date: Fri, 14 May 2021 10:53:03 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Add missing index for trapping debug registers
Message-ID: <YJ64/5AQz0ISl0oX@google.com>
References: <20210514014906.392401-1-ricarkol@google.com>
 <87bl9dohgu.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87bl9dohgu.wl-maz@kernel.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Fri, May 14, 2021 at 09:19:29AM +0100, Marc Zyngier wrote:
> Hi Ricardo,
> 
> On Fri, 14 May 2021 02:49:06 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > Trapping an access to debug register <n> (like bvr<n>, bcr<n>, wvr<n>,
> > wcr<n>) results in storing and loading values from the vcpu copy at
> > index 0 (irrespective of <n>). So, this guest test fails:
> > 
> >   /* traps and wrongly stores 0x123 into vcpu->bvr[0] */
> >   write_sysreg(dbgbvr1_el1, 0x123);
> >   /* reads 0 from the real bvr[1] without trapping */
> >   GUEST_ASSERT(read_sysreg(dbgbvr1_el1) == 0x123); /* check fails */
> 
> Bummer... But nice catch! I broke it in 03fdfb2690099 ("KVM: arm64:
> Don't write junk to sysregs on reset").
> 
> > Fix this by setting the register index in macro DBG_BCR_BVR_WCR_WVR_EL1
> > to <n>.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 76ea2800c33e..e4ec9edd49fa 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -935,13 +935,13 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >  /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
> >  #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
> >  	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
> > -	  trap_bvr, reset_bvr, 0, 0, get_bvr, set_bvr },		\
> > +	  trap_bvr, reset_bvr, n, 0, get_bvr, set_bvr },		\
> >  	{ SYS_DESC(SYS_DBGBCRn_EL1(n)),					\
> > -	  trap_bcr, reset_bcr, 0, 0, get_bcr, set_bcr },		\
> > +	  trap_bcr, reset_bcr, n, 0, get_bcr, set_bcr },		\
> >  	{ SYS_DESC(SYS_DBGWVRn_EL1(n)),					\
> > -	  trap_wvr, reset_wvr, 0, 0,  get_wvr, set_wvr },		\
> > +	  trap_wvr, reset_wvr, n, 0,  get_wvr, set_wvr },		\
> >  	{ SYS_DESC(SYS_DBGWCRn_EL1(n)),					\
> > -	  trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
> > +	  trap_wcr, reset_wcr, n, 0,  get_wcr, set_wcr }
> >  
> >  #define PMU_SYS_REG(r)						\
> >  	SYS_DESC(r), .reset = reset_unknown, .visibility = pmu_visibility
> 
> Unfortunately, I don't think that's the right fix either, and just
> setting it to the debug register index will do the wrong thing in
> reset_sys_reg_descs().
> 

I see, got it.

> The reason is that the debug registers don't live in the per-vcpu
> sysreg array, but instead in some private structure, owing to the fact
> that we support both guest and host-side debugging. The value '0' here
> is in indication that the shadow registers are "somewhere else".
> 
> I think the correct fix is to use the register encoding itself, which
> contains everything we need (for all the debug regs, the CRm field is
> the debug register index). That's what it should have been the first
> place.
> 
> Could you please give the following patch a go?
> 

I just tried it and it fixes the test described in the commit message:
wr(bvr1),rd(bvr1).

Thanks,
Ricardo

> Thanks,
> 
> 	M.
> 
> From cfca75f1e2ab5dd1933de59b90f31293821fd2de Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Fri, 14 May 2021 09:05:41 +0100
> Subject: [PATCH] KVM: arm64: Fix debug register indexing
> 
> Commit 03fdfb2690099 ("KVM: arm64: Don't write junk to sysregs on
> reset") flipped the register number to 0 for all the debug registers
> in the sysreg table, hereby indicating that these registers live
> in a separate shadow structure.
> 
> However, the author of this patch failed to realise that all the
> accessors are using that particular index instead of the register
> encoding, resulting in all the registers hitting index 0. Not quite
> a valid implementation of the architecture...
> 
> Address the issue by fixing all the accessors to use the CRm field
> of the encoding, which contains the debug register index.
> 
> Fixes: 03fdfb2690099 ("KVM: arm64: Don't write junk to sysregs on reset")
> Reported-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/kvm/sys_regs.c | 42 +++++++++++++++++++--------------------
>  1 file changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 76ea2800c33e..1a7968ad078c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -399,14 +399,14 @@ static bool trap_bvr(struct kvm_vcpu *vcpu,
>  		     struct sys_reg_params *p,
>  		     const struct sys_reg_desc *rd)
>  {
> -	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
> +	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
>  
>  	if (p->is_write)
>  		reg_to_dbg(vcpu, p, rd, dbg_reg);
>  	else
>  		dbg_to_reg(vcpu, p, rd, dbg_reg);
>  
> -	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
> +	trace_trap_reg(__func__, rd->CRm, p->is_write, *dbg_reg);
>  
>  	return true;
>  }
> @@ -414,7 +414,7 @@ static bool trap_bvr(struct kvm_vcpu *vcpu,
>  static int set_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  		const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
> +	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
>  
>  	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
>  		return -EFAULT;
> @@ -424,7 +424,7 @@ static int set_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  static int get_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  	const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
> +	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
>  
>  	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
>  		return -EFAULT;
> @@ -434,21 +434,21 @@ static int get_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  static void reset_bvr(struct kvm_vcpu *vcpu,
>  		      const struct sys_reg_desc *rd)
>  {
> -	vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg] = rd->val;
> +	vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm] = rd->val;
>  }
>  
>  static bool trap_bcr(struct kvm_vcpu *vcpu,
>  		     struct sys_reg_params *p,
>  		     const struct sys_reg_desc *rd)
>  {
> -	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
> +	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
>  
>  	if (p->is_write)
>  		reg_to_dbg(vcpu, p, rd, dbg_reg);
>  	else
>  		dbg_to_reg(vcpu, p, rd, dbg_reg);
>  
> -	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
> +	trace_trap_reg(__func__, rd->CRm, p->is_write, *dbg_reg);
>  
>  	return true;
>  }
> @@ -456,7 +456,7 @@ static bool trap_bcr(struct kvm_vcpu *vcpu,
>  static int set_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  		const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
> +	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
>  
>  	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
>  		return -EFAULT;
> @@ -467,7 +467,7 @@ static int set_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  static int get_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  	const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
> +	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
>  
>  	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
>  		return -EFAULT;
> @@ -477,22 +477,22 @@ static int get_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  static void reset_bcr(struct kvm_vcpu *vcpu,
>  		      const struct sys_reg_desc *rd)
>  {
> -	vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg] = rd->val;
> +	vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm] = rd->val;
>  }
>  
>  static bool trap_wvr(struct kvm_vcpu *vcpu,
>  		     struct sys_reg_params *p,
>  		     const struct sys_reg_desc *rd)
>  {
> -	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
> +	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm];
>  
>  	if (p->is_write)
>  		reg_to_dbg(vcpu, p, rd, dbg_reg);
>  	else
>  		dbg_to_reg(vcpu, p, rd, dbg_reg);
>  
> -	trace_trap_reg(__func__, rd->reg, p->is_write,
> -		vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg]);
> +	trace_trap_reg(__func__, rd->CRm, p->is_write,
> +		vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm]);
>  
>  	return true;
>  }
> @@ -500,7 +500,7 @@ static bool trap_wvr(struct kvm_vcpu *vcpu,
>  static int set_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  		const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
> +	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm];
>  
>  	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
>  		return -EFAULT;
> @@ -510,7 +510,7 @@ static int set_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  static int get_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  	const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
> +	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm];
>  
>  	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
>  		return -EFAULT;
> @@ -520,21 +520,21 @@ static int get_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  static void reset_wvr(struct kvm_vcpu *vcpu,
>  		      const struct sys_reg_desc *rd)
>  {
> -	vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg] = rd->val;
> +	vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm] = rd->val;
>  }
>  
>  static bool trap_wcr(struct kvm_vcpu *vcpu,
>  		     struct sys_reg_params *p,
>  		     const struct sys_reg_desc *rd)
>  {
> -	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
> +	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
>  
>  	if (p->is_write)
>  		reg_to_dbg(vcpu, p, rd, dbg_reg);
>  	else
>  		dbg_to_reg(vcpu, p, rd, dbg_reg);
>  
> -	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
> +	trace_trap_reg(__func__, rd->CRm, p->is_write, *dbg_reg);
>  
>  	return true;
>  }
> @@ -542,7 +542,7 @@ static bool trap_wcr(struct kvm_vcpu *vcpu,
>  static int set_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  		const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
> +	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
>  
>  	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
>  		return -EFAULT;
> @@ -552,7 +552,7 @@ static int set_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  static int get_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  	const struct kvm_one_reg *reg, void __user *uaddr)
>  {
> -	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
> +	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
>  
>  	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
>  		return -EFAULT;
> @@ -562,7 +562,7 @@ static int get_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  static void reset_wcr(struct kvm_vcpu *vcpu,
>  		      const struct sys_reg_desc *rd)
>  {
> -	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg] = rd->val;
> +	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm] = rd->val;
>  }
>  
>  static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> -- 
> 2.30.2
> 
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
