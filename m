Return-Path: <SRS0=4KxT=LZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB4FC11F64
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 09:47:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C36A56147D
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 09:47:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C36A56147D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63B894B082;
	Thu,  1 Jul 2021 05:47:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 964V5lBbBxDN; Thu,  1 Jul 2021 05:47:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB1A94AEF8;
	Thu,  1 Jul 2021 05:47:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B96094AED4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 05:47:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DQ9PUnOSCigh for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jul 2021 05:47:26 -0400 (EDT)
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com
 [209.85.210.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 624994AC78
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 05:47:26 -0400 (EDT)
Received: by mail-ot1-f41.google.com with SMTP id
 i12-20020a05683033ecb02903346fa0f74dso5899121otu.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Jul 2021 02:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=zsiY35VRU0KRE6ycC2hbyPpUGePayp/Aq6sX8jQnzWI=;
 b=Bi+sw52YdNJcD7urX5LbqQiDQsJ+Y1Hrqgk11nyCz16H/nxxn+EDUKeF97N9fHlAzt
 5Dyzw0QzzXl0vtJGFJMSeGxN4iX3aIyuKBzJm0TXJy6AqPhg+xZ5j5VL4ja34eT5AzSx
 ZTtxNa5D4SG9Pf1l48XqAk42b4WopO/rnhayQeyn9BNY1AQt/hP60SGiQzXARcOaMETk
 1eXUZzcrjAjcQ7yEbdb9d/OmB//AC9xBStNARZa5iuQSAxDC3tGXzNPzBVJ5cK2Bxytw
 mhO6KWksSnX5XrMKtI5mDvXXm0U2cnJbPj9Jx3NL5jjxuTGKKxuLL1IuiX+Ze6tzQ6sv
 85IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=zsiY35VRU0KRE6ycC2hbyPpUGePayp/Aq6sX8jQnzWI=;
 b=Pm54gAGogPVsnQFimARaPAkdVX4C7OA/zLR4luLMAXIHAnari/k2ey5ICvAwels8YO
 4j7cE5e5PG/azLCSydMstCmTQle/Au02J4I+kMnkJl79xnksAXw2QjWSyrD4IXk3y57R
 B/oFxFNwxafukh0p5fjt8z1IZMNLKNGom7hbCYvt0MHerN40depbXdd2ES5KzZ1M0E/h
 aHRSwZFR9rcplp15kmBAvIDb3ShsNxCTtfF/bZPtrjb2LPAiXOS2THlGpbZOnSJc+vrX
 9ms57/YK+j8r2Sc0niGYZ6relWmKd8DEibWbEgWZPiUr30+C/wBmSqq37P0nhrZhgEaC
 HVjg==
X-Gm-Message-State: AOAM530C344FPqI75DK646PO6DOdUHTYP34WPURD2LPhHXouClN2rkIW
 1Yn8KFrU4MqbmZ8R5KIZm5XcOh4Oio9Czg+ZmPl2nA==
X-Google-Smtp-Source: ABdhPJw/QFkCbpCGUQAbBpB+Y2H3g4MmzTIletYTaYiXGjonZuiRQgRa2UfkMZodxyg4FqNBZkQcPTqkeyuIrK9Kktk=
X-Received: by 2002:a9d:17c5:: with SMTP id j63mr1308965otj.52.1625132845534; 
 Thu, 01 Jul 2021 02:47:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210608154805.216869-1-jean-philippe@linaro.org>
 <20210608154805.216869-6-jean-philippe@linaro.org>
In-Reply-To: <20210608154805.216869-6-jean-philippe@linaro.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 1 Jul 2021 10:46:49 +0100
Message-ID: <CA+EHjTwYC57y0+gDY_cXFRw12GnE_gEYTFTLsaoA9Zng-SGLag@mail.gmail.com>
Subject: Re: [RFC PATCH 5/5] KVM: arm64: Pass PSCI calls to userspace
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
> Let userspace request to handle PSCI calls, by setting the new
> KVM_CAP_ARM_PSCI_TO_USER capability.
>
> SMCCC probe requires PSCI v1.x. If userspace only implements PSCI v0.2,
> the guest won't query SMCCC support through PSCI and won't use the
> spectre workarounds. We could hijack PSCI_VERSION and pretend to support
> v1.0 if userspace does not, then handle all v1.0 calls ourselves
> (including guessing the PSCI feature set implemented by the guest), but
> that seems unnecessary. After all the API already allows userspace to
> force a version lower than v1.0 using the firmware pseudo-registers.
>
> The KVM_REG_ARM_PSCI_VERSION pseudo-register currently resets to either
> v0.1 if userspace doesn't set KVM_ARM_VCPU_PSCI_0_2, or
> KVM_ARM_PSCI_LATEST (1.0).
>
> Suggested-by: James Morse <james.morse@arm.com>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  Documentation/virt/kvm/api.rst      | 14 ++++++++++++++
>  Documentation/virt/kvm/arm/psci.rst |  1 +
>  arch/arm64/include/asm/kvm_host.h   |  1 +
>  include/kvm/arm_hypercalls.h        |  1 +
>  include/uapi/linux/kvm.h            |  1 +
>  arch/arm64/kvm/arm.c                | 10 +++++++---
>  arch/arm64/kvm/hypercalls.c         |  2 +-
>  arch/arm64/kvm/psci.c               | 13 +++++++++++++
>  8 files changed, 39 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 3d8c1661e7b2..f24eb70e575d 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6907,3 +6907,17 @@ available to the guest on migration.
>  This capability indicates that KVM can pass unhandled hypercalls to userspace,
>  if the VMM enables it. Hypercalls are passed with KVM_EXIT_HYPERCALL in
>  kvm_run::hypercall.
> +
> +8.34 KVM_CAP_ARM_PSCI_TO_USER
> +-----------------------------
> +
> +:Architectures: arm64
> +
> +When the VMM enables this capability, all PSCI calls are passed to userspace
> +instead of being handled by KVM. Capability KVM_CAP_ARM_HVC_TO_USER must be
> +enabled first.
> +
> +Userspace should support at least PSCI v1.0. Otherwise SMCCC features won't be
> +available to the guest. Userspace does not need to handle the SMCCC_VERSION
> +parameter for the PSCI_FEATURES function. The KVM_ARM_VCPU_PSCI_0_2 vCPU
> +feature should be set even if this capability is enabled.
> diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/psci.rst
> index d52c2e83b5b8..110011d1fa3f 100644
> --- a/Documentation/virt/kvm/arm/psci.rst
> +++ b/Documentation/virt/kvm/arm/psci.rst
> @@ -34,6 +34,7 @@ The following register is defined:
>    - Allows any PSCI version implemented by KVM and compatible with
>      v0.2 to be set with SET_ONE_REG
>    - Affects the whole VM (even if the register view is per-vcpu)
> +  - Defaults to PSCI 1.0 if userspace enables KVM_CAP_ARM_PSCI_TO_USER.

Should this be "to PSCI 1.x", to match the comment and for future expansion?

>
>  * KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
>      Holds the state of the firmware support to mitigate CVE-2017-5715, as
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 25554ce97045..5d74b769c16d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -124,6 +124,7 @@ struct kvm_arch {
>          */
>         bool return_nisv_io_abort_to_user;
>         bool hvc_to_user;
> +       bool psci_to_user;
>
>         /*
>          * VM-wide PMU filter, implemented as a bitmap and big enough for
> diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> index 0e2509d27910..b66c6a000ef3 100644
> --- a/include/kvm/arm_hypercalls.h
> +++ b/include/kvm/arm_hypercalls.h
> @@ -6,6 +6,7 @@
>
>  #include <asm/kvm_emulate.h>
>
> +int kvm_hvc_user(struct kvm_vcpu *vcpu);
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
>
>  static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index aa831986a399..2b8e55aa7e1e 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1085,6 +1085,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PTP_KVM 198
>  #define KVM_CAP_ARM_MP_HALTED 199
>  #define KVM_CAP_ARM_HVC_TO_USER 200
> +#define KVM_CAP_ARM_PSCI_TO_USER 201
>
>  #ifdef KVM_CAP_IRQ_ROUTING
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 074197721e97..bc3e63b0b3ad 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -83,7 +83,7 @@ int kvm_arch_check_processor_compat(void *opaque)
>  int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                             struct kvm_enable_cap *cap)
>  {
> -       int r;
> +       int r = -EINVAL;
>
>         if (cap->flags)
>                 return -EINVAL;
> @@ -97,8 +97,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                 r = 0;
>                 kvm->arch.hvc_to_user = true;
>                 break;
> -       default:
> -               r = -EINVAL;
> +       case KVM_CAP_ARM_PSCI_TO_USER:
> +               if (kvm->arch.hvc_to_user) {
> +                       r = 0;
> +                       kvm->arch.psci_to_user = true;
> +               }

Should this return -EINVAL if hvc_to_user isn't set, rather than
silently not setting psci_to_user, or should it be a parameter of
KVM_CAP_ARM_HVC_TO_USER rather than its own thing?

Thanks,
/fuad


>                 break;
>         }
>
> @@ -213,6 +216,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>         case KVM_CAP_PTP_KVM:
>         case KVM_CAP_ARM_MP_HALTED:
>         case KVM_CAP_ARM_HVC_TO_USER:
> +       case KVM_CAP_ARM_PSCI_TO_USER:
>                 r = 1;
>                 break;
>         case KVM_CAP_SET_GUEST_DEBUG2:
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index ccc2015eddf9..621d5a5b7e48 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -58,7 +58,7 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
>         val[3] = lower_32_bits(cycles);
>  }
>
> -static int kvm_hvc_user(struct kvm_vcpu *vcpu)
> +int kvm_hvc_user(struct kvm_vcpu *vcpu)
>  {
>         int i;
>         struct kvm_run *run = vcpu->run;
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 42a307ceb95f..7f44ee527966 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -353,6 +353,16 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
>         return 1;
>  }
>
> +static bool kvm_psci_call_is_user(struct kvm_vcpu *vcpu)
> +{
> +       /* Handle the special case of SMCCC probe through PSCI */
> +       if (smccc_get_function(vcpu) == PSCI_1_0_FN_PSCI_FEATURES &&
> +           smccc_get_arg1(vcpu) == ARM_SMCCC_VERSION_FUNC_ID)
> +               return false;
> +
> +       return vcpu->kvm->arch.psci_to_user;
> +}
> +
>  /**
>   * kvm_psci_call - handle PSCI call if r0 value is in range
>   * @vcpu: Pointer to the VCPU struct
> @@ -369,6 +379,9 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
>   */
>  int kvm_psci_call(struct kvm_vcpu *vcpu)
>  {
> +       if (kvm_psci_call_is_user(vcpu))
> +               return kvm_hvc_user(vcpu);
> +
>         switch (kvm_psci_version(vcpu, vcpu->kvm)) {
>         case KVM_ARM_PSCI_1_0:
>                 return kvm_psci_1_0_call(vcpu);
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
