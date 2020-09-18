Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E3AC43463
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 07:50:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D8A22206CA
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 07:50:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hv9QsWOD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8A22206CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C0ED4B391;
	Fri, 18 Sep 2020 03:50:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vWV9DxOk3hkY; Fri, 18 Sep 2020 03:50:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44FBB4B3E8;
	Fri, 18 Sep 2020 03:50:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04EEF4B3CB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 03:50:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gARYUMHgjz3j for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 03:50:48 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA3384B391
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 03:50:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600415448;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=1/cmhRd1IcV5cBU/89mNL7deEGSS2dukfQx9yWJhGmM=;
 b=Hv9QsWODmW3w3Y0KuCzU+YFw25eO1VM1cVLEMTPAJlY9K1omorBv2bX0Ze/Y+Wg7gzdg8O
 rP/stf/cFrDoG9GFY2XS47BzXf7kc9wF3FtnDRZSWDt65u8QeHzOa6H3VHLFRo7/yLZjxJ
 FJTBC9WxTSY5sqHDawFzgQNhIIj0Y4U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-uBxPGBpjMWuwkZ9QL6d_Lw-1; Fri, 18 Sep 2020 03:50:46 -0400
X-MC-Unique: uBxPGBpjMWuwkZ9QL6d_Lw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2A0C81CAFB;
 Fri, 18 Sep 2020 07:50:44 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.125])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A9ACE73660;
 Fri, 18 Sep 2020 07:50:42 +0000 (UTC)
Date: Fri, 18 Sep 2020 09:50:39 +0200
From: Andrew Jones <drjones@redhat.com>
To: Peng Liang <liangpeng10@huawei.com>
Subject: Re: [RFC v2 6/7] kvm: arm64: make ID registers configurable
Message-ID: <20200918075039.36eezfwbsiearq3h@kamzik.brq.redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-7-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200917120101.3438389-7-liangpeng10@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

On Thu, Sep 17, 2020 at 08:01:00PM +0800, Peng Liang wrote:
> It's time to make ID registers configurable.  When userspace (but not
> guest) want to set the values of ID registers, save the value in
> sysreg file so that guest can read the modified values.
> 
> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index a642ecfebe0a..881b66494524 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1263,10 +1263,6 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
>  
>  /*
>   * cpufeature ID register user accessors
> - *
> - * For now, these registers are immutable for userspace, so no values
> - * are stored, and for set_id_reg() we don't allow the effective value
> - * to be changed.
>   */
>  static int __get_id_reg(struct kvm_vcpu *vcpu,
>  			const struct sys_reg_desc *rd, void __user *uaddr,
> @@ -1290,9 +1286,15 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
>  	if (err)
>  		return err;
>  
> -	/* This is what we mean by invariant: you can't change it. */
> -	if (val != read_id_reg(vcpu, rd, raz))
> -		return -EINVAL;
> +	if (raz) {
> +		if (val != read_id_reg(vcpu, rd, raz))

val != 0 ?

> +			return -EINVAL;
> +	} else {
> +		u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
> +				     (u32)rd->CRm, (u32)rd->Op2);
> +		/* val should be checked in check_user */

It really doesn't make sense to share this trivial set_user function and
have different check functions. Just don't share the set_user function.

> +		__vcpu_sys_reg(vcpu, ID_REG_INDEX(reg_id)) = val;
> +	}
>  
>  	return 0;
>  }
> -- 
> 2.26.2
> 

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
