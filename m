Return-Path: <SRS0=hhnY=BX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E3EC433E1
	for <kvmarm@archiver.kernel.org>; Thu, 13 Aug 2020 09:09:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 151592074D
	for <kvmarm@archiver.kernel.org>; Thu, 13 Aug 2020 09:09:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d2YMDOEr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 151592074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9007D4B96D;
	Thu, 13 Aug 2020 05:09:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z8Zk0Tf8amms; Thu, 13 Aug 2020 05:09:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 857B24B8F6;
	Thu, 13 Aug 2020 05:09:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFC824B8F6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Aug 2020 05:09:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2OwN2ybxCpFf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Aug 2020 05:09:36 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 118FB4B8E8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Aug 2020 05:09:35 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597309775;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=huCoVCoxH7DGOX1gt2J0Q8XYRcnSSnTcRRYMzxvz/ZQ=;
 b=d2YMDOEriSop8yL3mq/vpn/7MJsioeFs0emfLO/1dyCfbvO+5FVD8HftPhET1mSA9QD0NJ
 X/Agkh+zFhnoxz4v8U14K8vKZO13tHgtpZ8qMQc63+bCvnh0HiluJpjDzX46NyAlln4IVM
 b/OLMn3KT2faVoxSWt2TzTqT/iWnlk0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-gEA45nlrMSC5q-0uUalZsQ-1; Thu, 13 Aug 2020 05:09:34 -0400
X-MC-Unique: gEA45nlrMSC5q-0uUalZsQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CCFE79EC1;
 Thu, 13 Aug 2020 09:09:32 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.72])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 82C6117150;
 Thu, 13 Aug 2020 09:09:30 +0000 (UTC)
Date: Thu, 13 Aug 2020 11:09:27 +0200
From: Andrew Jones <drjones@redhat.com>
To: Peng Liang <liangpeng10@huawei.com>
Subject: Re: [RFC 3/4] kvm: arm64: make ID registers configurable
Message-ID: <20200813090927.busuifugzatw5sem@kamzik.brq.redhat.com>
References: <20200813060517.2360048-1-liangpeng10@huawei.com>
 <20200813060517.2360048-4-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200813060517.2360048-4-liangpeng10@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

On Thu, Aug 13, 2020 at 02:05:16PM +0800, Peng Liang wrote:
> It's time to make ID registers configurable.  When userspace (but not
> guest) want to set the values of ID registers, save the value in
> kvm_arch_vcpu so that guest can read the modified values.
> 
> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 776c2757a01e..f98635489966 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1111,6 +1111,14 @@ static u64 kvm_get_id_reg(struct kvm_vcpu *vcpu, u64 id)
>  	return ri->sys_val;
>  }
>  
> +static void kvm_set_id_reg(struct kvm_vcpu *vcpu, u64 id, u64 value)
> +{
> +	struct id_reg_info *ri = kvm_id_reg(vcpu, id);
> +
> +	BUG_ON(!ri);
> +	ri->sys_val = value;
> +}
> +
>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
>  static u64 read_id_reg(struct kvm_vcpu *vcpu,
>  		struct sys_reg_desc const *r, bool raz)
> @@ -1252,10 +1260,6 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
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
> @@ -1279,9 +1283,14 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
>  	if (err)
>  		return err;
>  
> -	/* This is what we mean by invariant: you can't change it. */
> -	if (val != read_id_reg(vcpu, rd, raz))
> -		return -EINVAL;
> +	if (raz) {
> +		if (val != read_id_reg(vcpu, rd, raz))
> +			return -EINVAL;
> +	} else {
> +		u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
> +				     (u32)rd->CRm, (u32)rd->Op2);
> +		kvm_set_id_reg(vcpu, reg_id, val);

So userspace can set the ID registers to whatever they want? I think each
register should have its own sanity checks applied before accepting the
input.

Thanks,
drew

> +	}
>  
>  	return 0;
>  }
> -- 
> 2.18.4
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
