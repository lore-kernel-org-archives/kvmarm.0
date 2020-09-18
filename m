Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADEE7C43465
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 07:31:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 17E8820874
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 07:31:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KGI2Wv3W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17E8820874
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BA6E4B3FD;
	Fri, 18 Sep 2020 03:31:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mHhR70r4Kskz; Fri, 18 Sep 2020 03:31:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A8E64B403;
	Fri, 18 Sep 2020 03:31:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F71D4B403
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 03:31:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yRyDKmNol1FZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 03:31:11 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BCD44B3FD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 03:31:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600414271;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=LdWnLFcFIegyMjIcLSZb+4Ju1sWLp3HPRysavBCaabU=;
 b=KGI2Wv3WalhIyHsxiAVQFTk+8zXJcCFZR0fkr1TDwqWd4gaUprY6rVBjPzJU/sT59zhOWf
 o9LtKq7jtwOSza+Q6ueFEsAUG9qCKMZ4WO01n2UJCza7VPra5zxLqxzbxiaN6Dzu+gYX1c
 FaGdHmyxbWiHfE/G4xCjjiJ2h203kVQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-FdsgkyYBOICbB1TLa-515w-1; Fri, 18 Sep 2020 03:31:06 -0400
X-MC-Unique: FdsgkyYBOICbB1TLa-515w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E541100855A;
 Fri, 18 Sep 2020 07:31:05 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.125])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 027435DEBB;
 Fri, 18 Sep 2020 07:31:02 +0000 (UTC)
Date: Fri, 18 Sep 2020 09:30:59 +0200
From: Andrew Jones <drjones@redhat.com>
To: Peng Liang <liangpeng10@huawei.com>
Subject: Re: [RFC v2 2/7] arm64: introduce check_features
Message-ID: <20200918073059.izmscvrtbnsbgnlj@kamzik.brq.redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-3-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200917120101.3438389-3-liangpeng10@huawei.com>
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

On Thu, Sep 17, 2020 at 08:00:56PM +0800, Peng Liang wrote:
> To emulate ID registers, we need to validate the value of the register
> defined by user space.  For most ID registers, we need to check whether
> each field defined by user space is no more than that of host (whether
> host support the corresponding features) and whether the fields are
> supposed to be exposed to guest.  Introduce check_features to do those
> jobs.
> 
> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
> ---
>  arch/arm64/include/asm/cpufeature.h |  2 ++
>  arch/arm64/kernel/cpufeature.c      | 23 +++++++++++++++++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 2ba7c4f11d8a..954adc5ca72f 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -579,6 +579,8 @@ void check_local_cpu_capabilities(void);
>  
>  u64 read_sanitised_ftr_reg(u32 id);
>  
> +int check_features(u32 sys_reg, u64 val);
> +
>  static inline bool cpu_supports_mixed_endian_el0(void)
>  {
>  	return id_aa64mmfr0_mixed_endian_el0(read_cpuid(ID_AA64MMFR0_EL1));
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 698b32705544..e58926992a70 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2850,3 +2850,26 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
>  
>  	return sprintf(buf, "Vulnerable\n");
>  }
> +
> +int check_features(u32 sys_reg, u64 val)
> +{
> +	struct arm64_ftr_reg *reg = get_arm64_ftr_reg(sys_reg);
> +	const struct arm64_ftr_bits *ftrp;
> +	u64 exposed_mask = 0;
> +
> +	if (!reg)
> +		return -ENOENT;
> +
> +	for (ftrp = reg->ftr_bits; ftrp->width; ftrp++) {
> +		if (arm64_ftr_value(ftrp, reg->sys_val) <
> +		    arm64_ftr_value(ftrp, val)) {
> +			return -EINVAL;

This assumes that 0b1111 is invalid if the host has e.g. 0b0001,
but, IIRC, there are some ID registers where 0b1111 means the
feature is disabled.

> +		}
> +		exposed_mask |= arm64_ftr_mask(ftrp);
> +	}
> +
> +	if (val & ~exposed_mask)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> -- 
> 2.26.2
> 

I don't think we should be trying to do the verification at the ftr_bits
level, at least not generally. Trying to handle all ID registers the
same way is bound to fail, for the 0b1111 vs. 0b0000 reason pointed
out above, and probably other reasons. As I stated before, we should be
validating each feature of each ID register on a case by case basis,
and we should be using higher level CPU feature checking APIs to get
that right.

Also, what about validating that all VCPUs have consistent features
exposed? Each VCPU could select a valid feature mask by this check,
but different ones, which will obviously create a completely broken
guest.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
