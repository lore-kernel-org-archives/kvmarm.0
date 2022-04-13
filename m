Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A172C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 13 Apr 2022 17:02:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 593994B0D6;
	Wed, 13 Apr 2022 13:02:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ewvnl2SwYH-A; Wed, 13 Apr 2022 13:02:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0173E4B0A0;
	Wed, 13 Apr 2022 13:02:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC4684B0D6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 13:02:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ku-n2Plz4QUf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Apr 2022 13:02:08 -0400 (EDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com
 [209.85.219.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9966E4B0A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 13:02:08 -0400 (EDT)
Received: by mail-yb1-f171.google.com with SMTP id z33so4894929ybh.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2022 10:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Yd7U9Ti5RDg8NJvME8HI4I8ItMkX9qmr1z2pf1IvYK8=;
 b=ewxTAo1Qxsd5Ttb0O86NkxjzsCqY01zIpBDm2cwF6BqdFEGon1NsnDPdf682lfbOa9
 Shw2OpMrmSKooJl5WijgnYp33iEwsr20SAiQIrfsZjy0wJsgzKLugwH65+GOrV+knXDI
 YT2tG5uoU9WZUy5YcBjkbcLtJYnXmvsIyf9yF5A7Td9FOLGNGy7G2ZFUvAqilgOBVGmE
 A7uVZqdOms/O/YK9ifqhJ9rCAAOsIuIQy54vWIG9TFj24ufGOhIe7QyWiOB9vLocsjUo
 FqxxsaFY6BuZ3B43l/MjCcOMumvMep4s/a6U2Mn/fp3OhkrkefL71H2LuR0a4ANnGF3D
 GnPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Yd7U9Ti5RDg8NJvME8HI4I8ItMkX9qmr1z2pf1IvYK8=;
 b=1Ye6LwXMSKf+3CYX1TBNyrYeUg/jM5g8YDIaNm2JOFsgEj4ejVyscLQ5D2XU1s/YLE
 9SUi0FlXU6zaAK0mVfOsuxvLWu9qRic2ALisx2ZM8MrtBaEbNUOSyggFgQBRtxxRlppK
 26ouUmhPUU0db/pj4f84W4CVnQX1JblWdhvIVD0ibTPTDwKhxHXEoief/620JpLfQrrH
 vLI7tT9oHkv9D5WXXoJ6X1HOCC8GxJX4GAWZ3qgghdL8GaaK3Z1pMLdokXiB+m3Ds9qI
 JV+Bvs1B9aT2CfFOQ295R0bf+dPuvt4szkbGd37al7UVIn0weY+V7kfV9wUq9O+tjgNC
 0brQ==
X-Gm-Message-State: AOAM530yhQUHYWyn0dtC0Mu6vWaZ0h82vihz6EyrIX/g+JSSs/C0AhOr
 8+SHOajuDYpf+AKupAHWSuZX7tVj3oap1F0UfJdCUg==
X-Google-Smtp-Source: ABdhPJxdvNBdxrvRM8ACW9KEOZDUovcWoMkKQluaavSot9hEcA4WNXQ4PgMeFjkiHodhkVrU2iGiruZZGD+RbyPxoCE=
X-Received: by 2002:a25:b9c8:0:b0:633:7725:779 with SMTP id
 y8-20020a25b9c8000000b0063377250779mr29609038ybj.280.1649869327532; Wed, 13
 Apr 2022 10:02:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220407011605.1966778-1-rananta@google.com>
 <20220407011605.1966778-7-rananta@google.com>
 <5dac0a4e-735f-40e3-5073-b548a2ba9855@redhat.com>
In-Reply-To: <5dac0a4e-735f-40e3-5073-b548a2ba9855@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 13 Apr 2022 10:01:56 -0700
Message-ID: <CAJHc60yjozXARv8tR1vTG6nPsjkYvOiNpY0s7Tc65jpCfu+vkw@mail.gmail.com>
Subject: Re: [PATCH v5 06/10] Docs: KVM: Add doc for the bitmap firmware
 registers
To: Gavin Shan <gshan@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Tue, Apr 12, 2022 at 11:40 PM Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Raghavendra,
>
> On 4/7/22 9:16 AM, Raghavendra Rao Ananta wrote:
> > Add the documentation for the bitmap firmware registers in
> > hypercalls.rst and api.rst. This includes the details for
> > KVM_REG_ARM_STD_BMAP, KVM_REG_ARM_STD_HYP_BMAP, and
> > KVM_REG_ARM_VENDOR_HYP_BMAP registers.
> >
> > Since the document is growing to carry other hypercall related
> > information, make necessary adjustments to present the document
> > in a generic sense, rather than being PSCI focused.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >   Documentation/virt/kvm/api.rst            | 17 ++++
> >   Documentation/virt/kvm/arm/hypercalls.rst | 95 ++++++++++++++++++-----
> >   2 files changed, 94 insertions(+), 18 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index d13fa6600467..e0107b157965 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -2542,6 +2542,23 @@ arm64 firmware pseudo-registers have the following bit pattern::
> >
> >     0x6030 0000 0014 <regno:16>
> >
> > +arm64 bitmap feature firmware pseudo-registers have the following bit pattern::
> > +
> > +  0x6030 0000 0016 <regno:16>
> > +
> > +The bitmap feature firmware registers exposes the hypercall services that are
> > +available for userspace to configure. The set bits corresponds to the services
> > +that are available for the guests to access. By default, KVM sets all the
> > +supported bits during VM initialization. The userspace can discover the
> > +available services via KVM_GET_ONE_REG, and write-back the bitmap corresponding
> > +to the features that it wishes guests to see via KVM_SET_ONE_REG.
> > +
> > +Note: These registers are immutable once any of the vCPUs of the VM has run at
> > +least once. A KVM_SET_ONE_REG in such a scenario will return a -EBUSY to userspace.
> > +If there's no change in the value that's being written, 0 (success) is returned.
> > +
> > +(See Documentation/virt/kvm/arm/hypercalls.rst for more details.)
> > +
> >   arm64 SVE registers have the following bit patterns::
> >
> >     0x6080 0000 0015 00 <n:5> <slice:5>   Zn bits[2048*slice + 2047 : 2048*slice]
> > diff --git a/Documentation/virt/kvm/arm/hypercalls.rst b/Documentation/virt/kvm/arm/hypercalls.rst
> > index d52c2e83b5b8..ccda9fc2d253 100644
> > --- a/Documentation/virt/kvm/arm/hypercalls.rst
> > +++ b/Documentation/virt/kvm/arm/hypercalls.rst
> > @@ -1,32 +1,32 @@
> >   .. SPDX-License-Identifier: GPL-2.0
> >
> > -=========================================
> > -Power State Coordination Interface (PSCI)
> > -=========================================
> > +=======================
> > +ARM Hypercall Interface
> > +=======================
> >
> > -KVM implements the PSCI (Power State Coordination Interface)
> > -specification in order to provide services such as CPU on/off, reset
> > -and power-off to the guest.
> > +KVM handles the hypercall services as requested by the guests. New hypercall
> > +services are regularly made available by the ARM specification or by KVM (as
> > +vendor services) if they make sense from a virtualization point of view.
> >
> > -The PSCI specification is regularly updated to provide new features,
> > -and KVM implements these updates if they make sense from a virtualization
> > -point of view.
> > -
> > -This means that a guest booted on two different versions of KVM can
> > -observe two different "firmware" revisions. This could cause issues if
> > -a given guest is tied to a particular PSCI revision (unlikely), or if
> > -a migration causes a different PSCI version to be exposed out of the
> > -blue to an unsuspecting guest.
> > +This means that a guest booted on two different versions of KVM can observe
> > +two different "firmware" revisions. This could cause issues if a given guest
> > +is tied to a particular version of a hypercall service, or if a migration
> > +causes a different version to be exposed out of the blue to an unsuspecting
> > +guest.
> >
> >   In order to remedy this situation, KVM exposes a set of "firmware
> >   pseudo-registers" that can be manipulated using the GET/SET_ONE_REG
> >   interface. These registers can be saved/restored by userspace, and set
> > -to a convenient value if required.
> > +to a convenient value as required.
> >
> > -The following register is defined:
> > +The following registers are defined:
> >
> >   * KVM_REG_ARM_PSCI_VERSION:
> >
> > +  KVM implements the PSCI (Power State Coordination Interface)
> > +  specification in order to provide services such as CPU on/off, reset
> > +  and power-off to the guest.
> > +
> >     - Only valid if the vcpu has the KVM_ARM_VCPU_PSCI_0_2 feature set
> >       (and thus has already been initialized)
> >     - Returns the current PSCI version on GET_ONE_REG (defaulting to the
> > @@ -74,4 +74,63 @@ The following register is defined:
> >       KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
> >         The workaround is always active on this vCPU or it is not needed.
> >
> > -.. [1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
> > +
> > +Bitmap Feature Firmware Registers
> > +---------------------------------
> > +
> > +Contrary to the above registers, the following registers exposes the hypercall
> > +services in the form of a feature-bitmap to the userspace. This bitmap is
> > +translated to the services that are available to the guest. There is a register
> > +defined per service call owner and can be accessed via GET/SET_ONE_REG interface.
> > +
> > +By default, these registers are set with the upper limit of the features that
> > +are supported. This way userspace can discover all the electable hypercall services
> > +via GET_ONE_REG. The user-space can write-back the desired bitmap back via
> > +SET_ONE_REG. The features for the registers that are untouched, probably because
> > +userspace isn't aware of them, will be exposed as is to the guest.
> > +
> > +Note that KVM would't allow the userspace to configure the registers anymore once
> > +any of the vCPUs has run at least once. Instead, it will return a -EBUSY. However,
> > +if there's no change in the incoming value, it simply returns a success.
> > +
>
> It would be better to replace "a success" with "zero", to be consistent
> with "-EBUSY". The suggestion may be invalid if the code needs changes
> based on Marc's suggestions.
>
Yes, I agree. Mentioning 'zero' makes more sense. However, I would be
scraping off this logic and return -EBUSY for all the writes after the
VM has started.

> > +The psuedo-firmware bitmap register are as follows:
> > +
> > +* KVM_REG_ARM_STD_BMAP:
> > +    Controls the bitmap of the ARM Standard Secure Service Calls.
> > +
> > +  The following bits are accepted:
> > +
> > +    Bit-0: KVM_REG_ARM_STD_BIT_TRNG_V1_0:
> > +      The bit represents the services offered under v1.0 of ARM True Random
> > +      Number Generator (TRNG) specification, ARM DEN0098.
> > +
> > +* KVM_REG_ARM_STD_HYP_BMAP:
> > +    Controls the bitmap of the ARM Standard Hypervisor Service Calls.
> > +
> > +  The following bits are accepted:
> > +
> > +    Bit-0: KVM_REG_ARM_STD_HYP_BIT_PV_TIME:
> > +      The bit represents the Paravirtualized Time service as represented by
> > +      ARM DEN0057A.
> > +
> > +* KVM_REG_ARM_VENDOR_HYP_BMAP:
> > +    Controls the bitmap of the Vendor specific Hypervisor Service Calls.
> > +
> > +  The following bits are accepted:
> > +
> > +    Bit-0: KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT
> > +      The bit represents the ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID
> > +      function-id
> > +
> > +    Bit-1: KVM_REG_ARM_VENDOR_HYP_BIT_PTP:
> > +      The bit represents the Precision Time Protocol KVM service.
> > +
> > +Errors:
> > +
> > +    =======  =============================================================
> > +    -ENOENT   Unknown register accessed.
> > +    -EBUSY    Attempt a 'write' to the register after the VM has started.
> > +    -EINVAL   Invalid bitmap written to the register.
> > +    =======  =============================================================
> > +
> > +.. [1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
> > \ No newline at end of file
> >
>
> Thanks,
> Gavin
>
Regards,
Raghavendra
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
