Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA94C43463
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 07:41:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 891F5208C3
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 07:41:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SAafSQ9P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 891F5208C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D55EF4B44F;
	Fri, 18 Sep 2020 03:41:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oL4a1k+14JqA; Fri, 18 Sep 2020 03:41:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5CFF4B3ED;
	Fri, 18 Sep 2020 03:41:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A23E04B3C7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 03:41:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6cg6JH3ejL0k for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 03:41:47 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4DF24B3C0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 03:41:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600414907;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=jdlxnptKdLwu7IhJP9GgNsbTEOt9CXKptumM3YEZlQI=;
 b=SAafSQ9PH6+Ci3AKX7I2592UpvbwJl6aLmcyJsFuXmk/WkJVDfmpADQRsmyAXsS49DjKi4
 8R5Kx+f0Gr7R9Ez/ioz+qZ6Ww2BL7LqNSkHkunvf4/mKZmAq+2+MhtS2YotY8Iags0O+OM
 +XCnJ0oy4kqK6UENeNZnCkCpnVCaB/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-RGVfUhXXNUmZhezWJWVxZQ-1; Fri, 18 Sep 2020 03:41:43 -0400
X-MC-Unique: RGVfUhXXNUmZhezWJWVxZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE453873088;
 Fri, 18 Sep 2020 07:41:41 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.125])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 063265DA30;
 Fri, 18 Sep 2020 07:41:38 +0000 (UTC)
Date: Fri, 18 Sep 2020 09:41:35 +0200
From: Andrew Jones <drjones@redhat.com>
To: Peng Liang <liangpeng10@huawei.com>
Subject: Re: [RFC v2 4/7] kvm: arm64: introduce check_user
Message-ID: <20200918074135.67ahnd6rlh7db3is@kamzik.brq.redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-5-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200917120101.3438389-5-liangpeng10@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

On Thu, Sep 17, 2020 at 08:00:58PM +0800, Peng Liang wrote:
> Currently, if we need to check the value of the register defined by user
> space, we should check it in set_user.  However, some system registers
> may use the same set_user (for example, almost all ID registers), which
> make it difficult to validate the value defined by user space.

If sharing set_user no longer makes sense for ID registers, then we need
to rework the code so it's no longer shared. As I keep saying, we need
to address this problem one ID register at a time. So, IMO, the approach
should be to change one ID register at a time from using ID_SANITISED()
to having its own table entry with its own set/get_user code. There may
still be opportunity to share code among the ID registers, in which case
refactoring can be done as needed too.

Thanks,
drew

> 
> Introduce check_user to solve the problem.  And apply check_user before
> set_user to make sure that the value of register is valid.
> 
> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 7 +++++++
>  arch/arm64/kvm/sys_regs.h | 6 ++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 2b0fa8d5ac62..86ebb8093c3c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2684,6 +2684,7 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>  {
>  	const struct sys_reg_desc *r;
>  	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
> +	int err;
>  
>  	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
>  		return demux_c15_set(reg->id, uaddr);
> @@ -2699,6 +2700,12 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>  	if (sysreg_hidden_from_user(vcpu, r))
>  		return -ENOENT;
>  
> +	if (r->check_user) {
> +		err = (r->check_user)(vcpu, r, reg, uaddr);
> +		if (err)
> +			return err;
> +	}
> +
>  	if (r->set_user)
>  		return (r->set_user)(vcpu, r, reg, uaddr);
>  
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index 5a6fc30f5989..9bce5e9a3490 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -53,6 +53,12 @@ struct sys_reg_desc {
>  			const struct kvm_one_reg *reg, void __user *uaddr);
>  	int (*set_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  			const struct kvm_one_reg *reg, void __user *uaddr);
> +	/*
> +	 * Check the value userspace passed.  It should return 0 on success and
> +	 * otherwise on failure.
> +	 */
> +	int (*check_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +			  const struct kvm_one_reg *reg, void __user *uaddr);
>  
>  	/* Return mask of REG_* runtime visibility overrides */
>  	unsigned int (*visibility)(const struct kvm_vcpu *vcpu,
> -- 
> 2.26.2
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
