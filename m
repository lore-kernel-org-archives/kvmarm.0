Return-Path: <SRS0=4KxT=LZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99743C11F69
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 09:46:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B02D61481
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 09:46:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B02D61481
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4541406D3;
	Thu,  1 Jul 2021 05:46:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6fnTasVvQzvC; Thu,  1 Jul 2021 05:46:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86BC14B07F;
	Thu,  1 Jul 2021 05:46:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFE954AED4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 05:46:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O83Jlqkjt4q5 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jul 2021 05:46:24 -0400 (EDT)
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com
 [209.85.210.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 90644406D3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 05:46:24 -0400 (EDT)
Received: by mail-ot1-f52.google.com with SMTP id
 x22-20020a9d6d960000b0290474a76f8bd4so4306086otp.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Jul 2021 02:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=KqXQbQzlGVwEb4hWk4vNvj2KHxy2ozKcVZUp0ZucZUA=;
 b=pzYWtZ85Xr0ACe20qL8ekATUPFSpPXGUulouerDSLObu1bRaA7gRhx52fZhiD8XvcR
 vflwJvbUaibOzGeRTfsrgCBkdimwmu9Fd+xLUZlY+Q1aDSq0FFDRarNgdyuf+y/WIplp
 oMssndh9bXrM90I0syKFbHoN1LCfcyNp5O/N8fuUeCUnmhbBEUJ3Zl88HMXba/6VhEaI
 tlv9KuGDpoZriGyjRg6MblOaem9DEmEAF/GxRRtk1wBU52an2+zwWw0JPPfb5KN98Oew
 huvnk5ShQ1DjVzE7/CS80XPF1GPJZJ+ol72Lq9lNp8b1ZHmRQ0PF9TH5Xma/Ybcmdci0
 /J/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=KqXQbQzlGVwEb4hWk4vNvj2KHxy2ozKcVZUp0ZucZUA=;
 b=GN2BClcVYdo4954yiNjg5Q1+twYA5/EjQSk+XM2cQS3194ywprB3Hckx9VyhMeyq0S
 dfAKMDEE5ynHSTGB+GS8t+BC5uMBp+T8rnmZZkGHFq5CZHSD3r0kT/XSSNebDpAHvMe1
 v00/tbLZqIrP+A6GBMCa4sHUSkDz6CTajfN95N9uKvYK8P4ly4O6xsJBTdu1QOtJWXnv
 qb3oqmRwM6LPuK6CkHt9KI/ieK6K5eUkT9+OCcRxDm8RCl7AwfEGinAWx2sdKV6N2V7t
 lsHd7QxaEzhfWohXMe3VgGuz5u9b7Q3wACaUrusmG6E7LViC9XssLXOV5joY5l1uvfaB
 hOuA==
X-Gm-Message-State: AOAM532/m0Qjq1DWOAn+oCkbQ0j11UD5RTzwr1K1NLwEDjxyWWD+T+8Q
 +bN9Y543E3bDuD3pLV2shyF4bcWbKS7PgcqxNt4ogw==
X-Google-Smtp-Source: ABdhPJzkPZ4KZLlvCnTvoKpFFW/fJBrw9Dhv5ZuJscqzhxX3tORpPfVsjsrdFi0cULSbHzUPEuJxSs3HMxEpPJek4t8=
X-Received: by 2002:a05:6830:18da:: with SMTP id
 v26mr12685796ote.144.1625132783894; 
 Thu, 01 Jul 2021 02:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210608154805.216869-1-jean-philippe@linaro.org>
 <20210608154805.216869-4-jean-philippe@linaro.org>
In-Reply-To: <20210608154805.216869-4-jean-philippe@linaro.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 1 Jul 2021 10:45:47 +0100
Message-ID: <CA+EHjTzSSVbJGyWbR98eyshZbNsaf6uSu8zqJs7kHkwGYZf2yQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/5] KVM: arm64: Allow userspace to request WFI
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: salil.mehta@huawei.com, lorenzo.pieralisi@arm.com, kvm@vger.kernel.org,
 corbet@lwn.net, maz@kernel.org, jonathan.cameron@huawei.com,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, pbonzini@redhat.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Jean-Philippe,

On Tue, Jun 8, 2021 at 4:54 PM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> To help userspace implement PSCI CPU_SUSPEND, allow setting the "HALTED"
> MP state to request a WFI before returning to the guest.
>
> Userspace won't obtain a HALTED mp_state from a KVM_GET_MP_STATE call
> unless they set it themselves. When set by KVM, to handle wfi or
> CPU_SUSPEND, it is consumed before returning to userspace.
>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  Documentation/virt/kvm/api.rst | 15 +++++++++------
>  include/uapi/linux/kvm.h       |  1 +
>  arch/arm64/kvm/arm.c           | 11 ++++++++++-
>  3 files changed, 20 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 7fcb2fd38f42..e4fe7fb60d5d 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1416,8 +1416,8 @@ Possible values are:
>                                   which has not yet received an INIT signal [x86]
>     KVM_MP_STATE_INIT_RECEIVED    the vcpu has received an INIT signal, and is
>                                   now ready for a SIPI [x86]
> -   KVM_MP_STATE_HALTED           the vcpu has executed a HLT instruction and
> -                                 is waiting for an interrupt [x86]
> +   KVM_MP_STATE_HALTED           the vcpu has executed a HLT/WFI instruction
> +                                 and is waiting for an interrupt [x86,arm64]

Considering that arm64 has a HLT instruction (for debugging), which is
very different from the x86 one, would it be good to clarify that in
the comment. e.g.,

"the vcpu has executed a HLT(x86)/WFI(arm64) instruction"?

Thanks,
/fuad


>     KVM_MP_STATE_SIPI_RECEIVED    the vcpu has just received a SIPI (vector
>                                   accessible via KVM_GET_VCPU_EVENTS) [x86]
>     KVM_MP_STATE_STOPPED          the vcpu is stopped [s390,arm/arm64]
> @@ -1435,8 +1435,9 @@ these architectures.
>  For arm/arm64:
>  ^^^^^^^^^^^^^^
>
> -The only states that are valid are KVM_MP_STATE_STOPPED and
> -KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
> +Valid states are KVM_MP_STATE_STOPPED and KVM_MP_STATE_RUNNABLE which reflect
> +if the vcpu is paused or not. If KVM_CAP_ARM_MP_HALTED is present, state
> +KVM_MP_STATE_HALTED is also valid.
>
>  4.39 KVM_SET_MP_STATE
>  ---------------------
> @@ -1457,8 +1458,10 @@ these architectures.
>  For arm/arm64:
>  ^^^^^^^^^^^^^^
>
> -The only states that are valid are KVM_MP_STATE_STOPPED and
> -KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.
> +Valid states are KVM_MP_STATE_STOPPED and KVM_MP_STATE_RUNNABLE which reflect
> +if the vcpu should be paused or not. If KVM_CAP_ARM_MP_HALTED is present,
> +KVM_MP_STATE_HALTED can be set, to wait for interrupts targeted at the vcpu
> +before running it.
>
>  4.40 KVM_SET_IDENTITY_MAP_ADDR
>  ------------------------------
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 79d9c44d1ad7..06ba64c49737 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1083,6 +1083,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_SGX_ATTRIBUTE 196
>  #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
>  #define KVM_CAP_PTP_KVM 198
> +#define KVM_CAP_ARM_MP_HALTED 199
>
>  #ifdef KVM_CAP_IRQ_ROUTING
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index d8cbaa0373c7..d6ad977fea5f 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -207,6 +207,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>         case KVM_CAP_SET_GUEST_DEBUG:
>         case KVM_CAP_VCPU_ATTRIBUTES:
>         case KVM_CAP_PTP_KVM:
> +       case KVM_CAP_ARM_MP_HALTED:
>                 r = 1;
>                 break;
>         case KVM_CAP_SET_GUEST_DEBUG2:
> @@ -469,6 +470,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>         case KVM_MP_STATE_RUNNABLE:
>                 vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>                 break;
> +       case KVM_MP_STATE_HALTED:
> +               kvm_arm_vcpu_suspend(vcpu);
> +               break;
>         case KVM_MP_STATE_STOPPED:
>                 kvm_arm_vcpu_power_off(vcpu);
>                 break;
> @@ -699,7 +703,12 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
>                         preempt_enable();
>                 }
>
> -               if (kvm_check_request(KVM_REQ_SUSPEND, vcpu)) {
> +               /*
> +                * Check mp_state again in case userspace changed their mind
> +                * after requesting suspend.
> +                */
> +               if (kvm_check_request(KVM_REQ_SUSPEND, vcpu) &&
> +                   vcpu->arch.mp_state == KVM_MP_STATE_HALTED) {
>                         if (!irq_pending) {
>                                 kvm_vcpu_block(vcpu);
>                                 kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> --
> 2.31.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
