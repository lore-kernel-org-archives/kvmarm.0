Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86997C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 06:31:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F145349EF3;
	Mon, 25 Apr 2022 02:31:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2bJajacN2ljV; Mon, 25 Apr 2022 02:31:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A2F849ECF;
	Mon, 25 Apr 2022 02:31:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25E1449ECF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 02:31:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AqLR5qLN+xhF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 02:31:40 -0400 (EDT)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com
 [209.85.210.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B29DF41071
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 02:31:40 -0400 (EDT)
Received: by mail-ot1-f50.google.com with SMTP id
 e15-20020a9d63cf000000b006054e65aaecso10176804otl.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 24 Apr 2022 23:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=gfmyfBKzr6y+Q24t6trNowD3E0gJMVwVzasVksSwT9A=;
 b=g1J19A6tvdiHnzaz59fgMij9aZVTn8m3adN+kXCf4Aat3HaVedlp7O6IjlM5BEH5Sx
 i4lN+BFSmaacazfTvoSAXhCAnhX+ejpdMxmoakYdY+n1dDjC+rALHpHa16sGfv7GKGK7
 +BTiG+QBQGPqfayMcGVSYor11VwoJyiwtjgzCTjo8uMx+3DPuAoX9suuKHIdmjLWZogy
 ifnFSW2HuChlJxr0giFbktyL/h3NWutHsAXMPUbVImJFidktEGn6B5LfvH2mnlaavDhy
 Om0aaDjWkKM27IWrRnBTJxLldCQlTgdvaYta2iq2yhveZBpQFbCitZkIm3ce3Fo88hbf
 Y+eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=gfmyfBKzr6y+Q24t6trNowD3E0gJMVwVzasVksSwT9A=;
 b=xyNapwFIY+ofu+37vmpJl54jDe+1ZNDVFLwg3UDod+b0pI+0VLauxcvMxYPGL3izFJ
 t+rsuLtbmTAEkgVjj9QwtrXSe4QtW2kMw7KFnr7jjDxYMwx1AvwQHwUQa+7dUtVrpwI3
 Ky5RmekqZ1rP1nSZYjBSJG1+HYXCJ4z67hCThgH7mjy498drfauQQ1fmqWN6fZjZ7+Qd
 OHtuj1HEzCV2hRGn2W94gX0jFhZwZnfOg7E0IzuqLyJ68haUJBrjBB2bNH6QZfr+8ocg
 efMOqBuPOd/nhUljDPW36ztruQNQ82L0nWhQx6k9Jm3h79dACB1RdrcUPntPSzOTKl9X
 k53A==
X-Gm-Message-State: AOAM533pux3r5klvcT90ND9x9PsPbr2tVbbi6j2Dp3vnD/Ka1gMiUjwN
 2s0KmW0Wdt3mRqi7sEAZKOB3kiiX/hTWIPuBlw+nyw==
X-Google-Smtp-Source: ABdhPJwj2NO3QNUFQKAjUp7XjBssKGRRqRlhP7iJIG885KNHfLtVxA6nIWkL22SiO9d1MKJZ0CkuVis2TN+l+vuQ6D0=
X-Received: by 2002:a05:6830:18d:b0:605:4cfb:19cd with SMTP id
 q13-20020a056830018d00b006054cfb19cdmr5780150ota.177.1650868299671; Sun, 24
 Apr 2022 23:31:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220423000328.2103733-1-rananta@google.com>
 <20220423000328.2103733-7-rananta@google.com>
In-Reply-To: <20220423000328.2103733-7-rananta@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Sun, 24 Apr 2022 23:31:23 -0700
Message-ID: <CAAeT=FxPwaCGw32Xy7F4aY3CEtAhB29t-KsA=ptLQN8hvtsvrg@mail.gmail.com>
Subject: Re: [PATCH v6 6/9] Docs: KVM: Add doc for the bitmap firmware
 registers
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Raghu,

On Fri, Apr 22, 2022 at 5:03 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Add the documentation for the bitmap firmware registers in
> hypercalls.rst and api.rst. This includes the details for
> KVM_REG_ARM_STD_BMAP, KVM_REG_ARM_STD_HYP_BMAP, and
> KVM_REG_ARM_VENDOR_HYP_BMAP registers.
>
> Since the document is growing to carry other hypercall related
> information, make necessary adjustments to present the document
> in a generic sense, rather than being PSCI focused.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  Documentation/virt/kvm/api.rst            | 16 ++++
>  Documentation/virt/kvm/arm/hypercalls.rst | 94 ++++++++++++++++++-----
>  2 files changed, 92 insertions(+), 18 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 85c7abc51af5..ac489191d0a9 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -2542,6 +2542,22 @@ arm64 firmware pseudo-registers have the following bit pattern::
>
>    0x6030 0000 0014 <regno:16>
>
> +arm64 bitmap feature firmware pseudo-registers have the following bit pattern::
> +
> +  0x6030 0000 0016 <regno:16>
> +
> +The bitmap feature firmware registers exposes the hypercall services that are
> +available for userspace to configure. The set bits corresponds to the services
> +that are available for the guests to access. By default, KVM sets all the
> +supported bits during VM initialization. The userspace can discover the
> +available services via KVM_GET_ONE_REG, and write back the bitmap corresponding
> +to the features that it wishes guests to see via KVM_SET_ONE_REG.
> +
> +Note: These registers are immutable once any of the vCPUs of the VM has run at
> +least once. A KVM_SET_ONE_REG in such a scenario will return a -EBUSY to userspace.
> +
> +(See Documentation/virt/kvm/arm/hypercalls.rst for more details.)
> +
>  arm64 SVE registers have the following bit patterns::
>
>    0x6080 0000 0015 00 <n:5> <slice:5>   Zn bits[2048*slice + 2047 : 2048*slice]
> diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
> index d52c2e83b5b8..6327c504b2fb 100644
> --- a/Documentation/virt/kvm/arm/hypercalls.rst
> +++ b/Documentation/virt/kvm/arm/hypercalls.rst
> @@ -1,32 +1,32 @@
>  .. SPDX-License-Identifier: GPL-2.0
>
> -=========================================
> -Power State Coordination Interface (PSCI)
> -=========================================
> +=======================
> +ARM Hypercall Interface
> +=======================
>
> -KVM implements the PSCI (Power State Coordination Interface)
> -specification in order to provide services such as CPU on/off, reset
> -and power-off to the guest.
> +KVM handles the hypercall services as requested by the guests. New hypercall
> +services are regularly made available by the ARM specification or by KVM (as
> +vendor services) if they make sense from a virtualization point of view.
>
> -The PSCI specification is regularly updated to provide new features,
> -and KVM implements these updates if they make sense from a virtualization
> -point of view.
> -
> -This means that a guest booted on two different versions of KVM can
> -observe two different "firmware" revisions. This could cause issues if
> -a given guest is tied to a particular PSCI revision (unlikely), or if
> -a migration causes a different PSCI version to be exposed out of the
> -blue to an unsuspecting guest.
> +This means that a guest booted on two different versions of KVM can observe
> +two different "firmware" revisions. This could cause issues if a given guest
> +is tied to a particular version of a hypercall service, or if a migration
> +causes a different version to be exposed out of the blue to an unsuspecting
> +guest.
>
>  In order to remedy this situation, KVM exposes a set of "firmware
>  pseudo-registers" that can be manipulated using the GET/SET_ONE_REG
>  interface. These registers can be saved/restored by userspace, and set
> -to a convenient value if required.
> +to a convenient value as required.
>
> -The following register is defined:
> +The following registers are defined:
>
>  * KVM_REG_ARM_PSCI_VERSION:
>
> +  KVM implements the PSCI (Power State Coordination Interface)
> +  specification in order to provide services such as CPU on/off, reset
> +  and power-off to the guest.
> +
>    - Only valid if the vcpu has the KVM_ARM_VCPU_PSCI_0_2 feature set
>      (and thus has already been initialized)
>    - Returns the current PSCI version on GET_ONE_REG (defaulting to the
> @@ -74,4 +74,62 @@ The following register is defined:
>      KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
>        The workaround is always active on this vCPU or it is not needed.
>
> -.. [1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
> +
> +Bitmap Feature Firmware Registers
> +---------------------------------
> +
> +Contrary to the above registers, the following registers exposes the hypercall
> +services in the form of a feature-bitmap to the userspace. This bitmap is
> +translated to the services that are available to the guest. There is a register
> +defined per service call owner and can be accessed via GET/SET_ONE_REG interface.
> +
> +By default, these registers are set with the upper limit of the features that
> +are supported. This way userspace can discover all the electable hypercall services
> +via GET_ONE_REG. The user-space can write-back the desired bitmap back via
> +SET_ONE_REG. The features for the registers that are untouched, probably because
> +userspace isn't aware of them, will be exposed as is to the guest.
> +
> +Note that KVM would't allow the userspace to configure the registers anymore once
> +any of the vCPUs has run at least once. Instead, it will return a -EBUSY.
> +
> +The psuedo-firmware bitmap register are as follows:
> +
> +* KVM_REG_ARM_STD_BMAP:
> +    Controls the bitmap of the ARM Standard Secure Service Calls.
> +
> +  The following bits are accepted:
> +
> +    Bit-0: KVM_REG_ARM_STD_BIT_TRNG_V1_0:
> +      The bit represents the services offered under v1.0 of ARM True Random
> +      Number Generator (TRNG) specification, ARM DEN0098.
> +
> +* KVM_REG_ARM_STD_HYP_BMAP:
> +    Controls the bitmap of the ARM Standard Hypervisor Service Calls.
> +
> +  The following bits are accepted:
> +
> +    Bit-0: KVM_REG_ARM_STD_HYP_BIT_PV_TIME:
> +      The bit represents the Paravirtualized Time service as represented by
> +      ARM DEN0057A.
> +
> +* KVM_REG_ARM_VENDOR_HYP_BMAP:
> +    Controls the bitmap of the Vendor specific Hypervisor Service Calls.
> +
> +  The following bits are accepted:
> +
> +    Bit-0: KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT
> +      The bit represents the ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID
> +      function-id

Looking at the code,
the bit also represents ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID.

Thanks,
Reiji


> +
> +    Bit-1: KVM_REG_ARM_VENDOR_HYP_BIT_PTP:
> +      The bit represents the Precision Time Protocol KVM service.
> +
> +Errors:
> +
> +    =======  =============================================================
> +    -ENOENT   Unknown register accessed.
> +    -EBUSY    Attempt a 'write' to the register after the VM has started.
> +    -EINVAL   Invalid bitmap written to the register.
> +    =======  =============================================================
> +
> +.. [1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
> \ No newline at end of file
> --
> 2.36.0.rc2.479.g8af0fa9b8e-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
