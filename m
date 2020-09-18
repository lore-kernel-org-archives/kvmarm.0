Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E18C43464
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 07:35:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B116021973
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 07:35:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T9LzCMMr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B116021973
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 051994B3BB;
	Fri, 18 Sep 2020 03:35:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8x5IdQL6BRSL; Fri, 18 Sep 2020 03:35:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8AA94B392;
	Fri, 18 Sep 2020 03:35:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C3544B392
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 03:35:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cY+czGd2q+1C for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 03:35:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4454A4B38C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 03:35:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600414502;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ox5LRgVtiT3VFJprA7ZGyCt4n6U1i6dAZJM16IeV6b4=;
 b=T9LzCMMrGH/mX27RF5dIfXLR1tE2S/v7AN+k0Bpx152cdz78pp0qOOHFN08Msf/aSWtfQT
 AjW1GRvGRAWuetGr1yZLVvIUVy/bSJyoHDYZScnUqqH349mGFFwzT2HGKBsJ+59PeIljMv
 7u6HI9zdI8PKybl9VmL4PUPKR66Zs1s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382--GXeX8dEM-e_wj0rTpDqdA-1; Fri, 18 Sep 2020 03:34:57 -0400
X-MC-Unique: -GXeX8dEM-e_wj0rTpDqdA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 863421882FB3;
 Fri, 18 Sep 2020 07:34:56 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.125])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8AD2660BEC;
 Fri, 18 Sep 2020 07:34:54 +0000 (UTC)
Date: Fri, 18 Sep 2020 09:34:51 +0200
From: Andrew Jones <drjones@redhat.com>
To: Peng Liang <liangpeng10@huawei.com>
Subject: Re: [RFC v2 3/7] kvm: arm64: save ID registers to sys_regs file
Message-ID: <20200918073451.ifmw4exn26x6kq3k@kamzik.brq.redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-4-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200917120101.3438389-4-liangpeng10@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Cc: zhang.zhanghailiang@huawei.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 17, 2020 at 08:00:57PM +0800, Peng Liang wrote:
> To emulate the ID registers, we need a place to storage the values of
> the ID regsiters.  Maybe putting them in sysreg file is a good idea.
> 
> This commit has no functional changes but only code refactor.  When
> initializing a vCPU, get the values of the ID registers from
> arm64_ftr_regs and storage them in sysreg file.  And we just read
> the value from sysreg file when getting/setting the value of the ID
> regs.
> 
> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_coproc.h |  2 ++
>  arch/arm64/include/asm/kvm_host.h   |  3 +++
>  arch/arm64/kvm/arm.c                |  2 ++
>  arch/arm64/kvm/sys_regs.c           | 33 +++++++++++++++++++++++++----
>  4 files changed, 36 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_coproc.h b/arch/arm64/include/asm/kvm_coproc.h
> index d6bb40122fdb..76e8c3cb0662 100644
> --- a/arch/arm64/include/asm/kvm_coproc.h
> +++ b/arch/arm64/include/asm/kvm_coproc.h
> @@ -35,4 +35,6 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *);
>  int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *);
>  unsigned long kvm_arm_num_sys_reg_descs(struct kvm_vcpu *vcpu);
>  
> +void kvm_arm_sys_reg_init(struct kvm_vcpu *vcpu);
> +
>  #endif /* __ARM64_KVM_COPROC_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 905c2b87e05a..50152e364c4f 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -184,6 +184,9 @@ enum vcpu_sysreg {
>  	CNTP_CVAL_EL0,
>  	CNTP_CTL_EL0,
>  
> +	ID_REG_BASE,
> +	ID_REG_END = ID_REG_BASE + 55,
> +
>  	/* 32bit specific registers. Keep them at the end of the range */
>  	DACR32_EL2,	/* Domain Access Control Register */
>  	IFSR32_EL2,	/* Instruction Fault Status Register */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index b588c3b5c2f0..6d961e192268 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -274,6 +274,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	if (err)
>  		return err;
>  
> +	kvm_arm_sys_reg_init(vcpu);
> +
>  	return create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
>  }
>  
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 077293b5115f..2b0fa8d5ac62 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1119,13 +1119,16 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +#define ID_REG_INDEX(id)						\
> +	(ID_REG_BASE + (((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id)))
> +
>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
> -static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> +static u64 read_id_reg(struct kvm_vcpu *vcpu,
>  		struct sys_reg_desc const *r, bool raz)
>  {
>  	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
>  			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
> -	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
> +	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, ID_REG_INDEX(id));
>  
>  	if (id == SYS_ID_AA64PFR0_EL1) {
>  		if (!vcpu_has_sve(vcpu))
> @@ -1265,7 +1268,7 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
>   * are stored, and for set_id_reg() we don't allow the effective value
>   * to be changed.
>   */
> -static int __get_id_reg(const struct kvm_vcpu *vcpu,
> +static int __get_id_reg(struct kvm_vcpu *vcpu,
>  			const struct sys_reg_desc *rd, void __user *uaddr,
>  			bool raz)
>  {
> @@ -1275,7 +1278,7 @@ static int __get_id_reg(const struct kvm_vcpu *vcpu,
>  	return reg_to_user(uaddr, &val, id);
>  }
>  
> -static int __set_id_reg(const struct kvm_vcpu *vcpu,
> +static int __set_id_reg(struct kvm_vcpu *vcpu,
>  			const struct sys_reg_desc *rd, void __user *uaddr,
>  			bool raz)
>  {
> @@ -2854,3 +2857,25 @@ void kvm_sys_reg_table_init(void)
>  	/* Clear all higher bits. */
>  	cache_levels &= (1 << (i*3))-1;
>  }
> +
> +static int get_cpu_ftr(u32 id, u64 val, void *argp)

'get' doesn't seem like the right verb here, but I don't think we need
this function anyway, since we don't need arm64_cpu_ftr_regs_traverse().
Just put the for-loop for arm64_cpu_ftr_regs_traverse() and this code
directly in kvm_arm_sys_reg_init().

> +{
> +	struct kvm_vcpu *vcpu = argp;
> +
> +	/*
> +	 * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> +	 * where 1<=crm<8, 0<=op2<8.
> +	 */
> +	if (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
> +	    sys_reg_CRn(id) == 0 && sys_reg_CRm(id) > 0 &&
> +	    sys_reg_CRm(id) < 8) {
> +		__vcpu_sys_reg(vcpu, ID_REG_INDEX(id)) = val;
> +	}
> +
> +	return 0;
> +}
> +
> +void kvm_arm_sys_reg_init(struct kvm_vcpu *vcpu)
> +{
> +	arm64_cpu_ftr_regs_traverse(get_cpu_ftr, vcpu);
> +}
> -- 
> 2.26.2
>

Besides the pointless functions, this patch looks fine to me.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
