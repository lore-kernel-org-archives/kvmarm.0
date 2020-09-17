Return-Path: <SRS0=ijLG=C2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6222EC433E2
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 07:23:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BBA41208DB
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 07:23:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HmaMHzUn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBA41208DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 289B54B609;
	Thu, 17 Sep 2020 03:23:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J+ZnJAQ4MJba; Thu, 17 Sep 2020 03:23:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA3914B844;
	Thu, 17 Sep 2020 03:23:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92B474B840
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 03:23:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UJx4rAW3+RMB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2020 03:23:30 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FD544B609
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 03:23:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1600327410;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=gFxz3S6YXoMOrSDJxG1vrsRe6APjmH4iiOKdeMf0Zas=;
 b=HmaMHzUnGjOdNqNyh5GlAHSMGf9MRf9T0flE21F58KBGPlFF0i6YzfgUkXSFfdeCAka8uf
 zzYxsyCqVRYv7wzByITdty4Qe+mcFWWUXwCBRLm9K0OkGr9D0dIfeK/HZlOI12SlSS2lAg
 F34S0PzgWOoC9yyT61lFd/apzFSZ1D8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-zNR9MrB_OvyWpgZYHgXS_g-1; Thu, 17 Sep 2020 03:23:27 -0400
X-MC-Unique: zNR9MrB_OvyWpgZYHgXS_g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B0CE10BBEC3;
 Thu, 17 Sep 2020 07:23:26 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.179])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 636B97880B;
 Thu, 17 Sep 2020 07:23:22 +0000 (UTC)
Date: Thu, 17 Sep 2020 09:23:20 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ying Fang <fangying1@huawei.com>
Subject: Re: [PATCH 1/2] KVM: arm64: add KVM_CAP_ARM_MP_AFFINITY extension
Message-ID: <20200917072320.busfksdm62ltpdfp@kamzik.brq.redhat.com>
References: <20200917023033.1337-1-fangying1@huawei.com>
 <20200917023033.1337-2-fangying1@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200917023033.1337-2-fangying1@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: zhang.zhanghailiang@huawei.com, kvm@vger.kernel.org, maz@kernel.org,
 alex.chen@huawei.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 17, 2020 at 10:30:32AM +0800, Ying Fang wrote:
> Add KVM_CAP_ARM_MP_AFFINITY extension for userspace to check
> whether KVM supports setting MPIDR on AArch64 platform. Thus
> we can give userspace control over the MPIDR to present
> cpu topology information.
> 
> Signed-off-by: Ying Fang <fangying1@huawei.com>
> ---
>  Documentation/virt/kvm/api.rst | 8 ++++++++
>  arch/arm64/kvm/arm.c           | 1 +
>  include/uapi/linux/kvm.h       | 1 +
>  3 files changed, 10 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index eb3a1316f03e..d2fb18613a34 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6159,3 +6159,11 @@ KVM can therefore start protected VMs.
>  This capability governs the KVM_S390_PV_COMMAND ioctl and the
>  KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
>  guests when the state change is invalid.
> +
> +8.24 KVM_CAP_ARM_MP_AFFINITY
> +----------------------------
> +
> +:Architecture: arm64
> +
> +This capability indicates that KVM_ARM_SET_MP_AFFINITY ioctl is available.
> +It is used by to set MPIDR from userspace.
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 46dc3d75cf13..913c8da539b3 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -178,6 +178,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
>  	case KVM_CAP_ARM_NISV_TO_USER:
>  	case KVM_CAP_ARM_INJECT_EXT_DABT:
> +	case KVM_CAP_ARM_MP_AFFINITY:
>  		r = 1;

Caps should only return 1 after, or at the same time as, the feature is
introduced, otherwise bisection is broken.

>  		break;
>  	case KVM_CAP_ARM_SET_DEVICE_ADDR:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f6d86033c4fa..c4874905cd9c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1035,6 +1035,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_LAST_CPU 184
>  #define KVM_CAP_SMALLER_MAXPHYADDR 185
>  #define KVM_CAP_S390_DIAG318 186
> +#define KVM_CAP_ARM_MP_AFFINITY 187
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.23.0
>

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
