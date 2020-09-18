Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69EC4C43464
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 07:55:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D66D020DD4
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 07:55:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C4VxsgYx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D66D020DD4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2304C4B3BA;
	Fri, 18 Sep 2020 03:55:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GpmM5xvCZhvt; Fri, 18 Sep 2020 03:55:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16EB54B3C0;
	Fri, 18 Sep 2020 03:55:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D78B54B3BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 03:55:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bKT8gedeIEWX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 03:55:26 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EEA5E4B35A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 03:55:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600415726;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=CRstiCQT/VcDTRvKLZn7v1dtfQ+01y/nuMpQlb2GpZI=;
 b=C4VxsgYxt71mEOk3sGOdWvK10KgTflml3MmZziBB1aX1TVbZB9EvajRtM2vXwXkU0TXe1C
 Cgy77DFjfRnmBElpN1G1gW4d7GZHDLhip8fOcMcTvcpFzUAGo8axTNP54M8ozm+fd4aqhi
 MbqpGZhG/gRPocCQDiYcpjbbbp+2sR4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-KoMoPJH4PFOdT1edYx-OfA-1; Fri, 18 Sep 2020 03:55:24 -0400
X-MC-Unique: KoMoPJH4PFOdT1edYx-OfA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 635AD8030A2;
 Fri, 18 Sep 2020 07:55:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.125])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 690C268865;
 Fri, 18 Sep 2020 07:55:21 +0000 (UTC)
Date: Fri, 18 Sep 2020 09:55:18 +0200
From: Andrew Jones <drjones@redhat.com>
To: Peng Liang <liangpeng10@huawei.com>
Subject: Re: [RFC v2 7/7] kvm: arm64: add KVM_CAP_ARM_CPU_FEATURE extension
Message-ID: <20200918075518.cbpjb3iswyj3lcym@kamzik.brq.redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-8-liangpeng10@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200917120101.3438389-8-liangpeng10@huawei.com>
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

On Thu, Sep 17, 2020 at 08:01:01PM +0800, Peng Liang wrote:
> Add KVM_CAP_ARM_CPU_FEATURE extension for userpace to check whether KVM
> supports to set CPU features in AArch64.
> 
> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
> ---
>  Documentation/virt/kvm/api.rst | 8 ++++++++
>  arch/arm64/kvm/arm.c           | 1 +
>  include/uapi/linux/kvm.h       | 1 +
>  3 files changed, 10 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index d2b733dc7892..50214ed8f50e 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6173,3 +6173,11 @@ specific interfaces must be consistent, i.e. if one says the feature
>  is supported, than the other should as well and vice versa.  For arm64
>  see Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL".
>  For x86 see Documentation/virt/kvm/msr.rst "MSR_KVM_STEAL_TIME".
> +
> +8.25 KVM_CAP_ARM_CPU_FEATURE
> +-----------------------------------

Too many '----'

> +
> +:Architecture: arm64
> +
> +This capability indicates that userspace can modify the ID registers via
> +KVM_SET_ONE_REG ioctl.

You should say something like "See KVM_SET_ONE_REG:ARM64 ID Registers"
here and also extend the "KVM_SET_ONE_REG" section with a "ARM64 ID
Register" section that describes the limits and return values.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 6d961e192268..918a7a56b224 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -178,6 +178,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
>  	case KVM_CAP_ARM_NISV_TO_USER:
>  	case KVM_CAP_ARM_INJECT_EXT_DABT:
> +	case KVM_CAP_ARM_CPU_FEATURE:
>  		r = 1;
>  		break;
>  	case KVM_CAP_ARM_SET_DEVICE_ADDR:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 7d8eced6f459..12356beadd5a 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1037,6 +1037,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_SMALLER_MAXPHYADDR 185
>  #define KVM_CAP_S390_DIAG318 186
>  #define KVM_CAP_STEAL_TIME 187
> +#define KVM_CAP_ARM_CPU_FEATURE 188
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.26.2
>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
