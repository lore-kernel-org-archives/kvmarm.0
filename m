Return-Path: <SRS0=fGD+=OV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4906C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 06:05:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 48EEF6135E
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 06:05:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 48EEF6135E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADB7D40642;
	Fri,  1 Oct 2021 02:05:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VEyEaEZzMIpi; Fri,  1 Oct 2021 02:05:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A412049FB7;
	Fri,  1 Oct 2021 02:05:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6812840642
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 02:04:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MJHnB5fX+XSD for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Oct 2021 02:04:58 -0400 (EDT)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
 [209.85.210.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F84340762
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 02:04:58 -0400 (EDT)
Received: by mail-pf1-f173.google.com with SMTP id 145so6991218pfz.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 23:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=e2wqNWElK598ybE2Qe8b3dIJWb4ay7c1EVylkxkO37M=;
 b=N++DXUpWfiG2mjIuDrz8lQsYFnE7bx09S5IgCMnyYfhp84Sw7ybrZt8R/ckr8Z7x2y
 HEpGbgda/PBlPLK4cVgN36cffhya6xEriD/QEGYUmZo0DEqSTUS4wyKKza362uj0wx94
 kPGYaXMnXeVRyYIsofGtkFl0btMQDSMK47TpPD3eH7eaBjoUpuiTSPZKiJiuSIrB2KGR
 Rz04WESPIval8ta1OWjwafhWswE8GpfkeS29u/WAVfS5oSjxf2KcyhCtzkxs9leVxrYr
 JLvtSUP9yBbPUj4YOISw6jKrfwJzsXuNC5meApCa8hrQq4hm0WVoOsGfDOwbY5BGWoPY
 Trjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=e2wqNWElK598ybE2Qe8b3dIJWb4ay7c1EVylkxkO37M=;
 b=teszes5sAVoOBoBi6D0suuAqRiy3jiGMNgkrNS2wjwCU3p6R1+8BwhkviOzzc/ML39
 DUg22Cnz/xkS+rZSrnuw8+B0F5Nu4Dr7jOspSwrlwo0en4Js2miVrfvFEcYadMoQft8H
 zBTjLgKQMQZ7HtHE7cDJrdCn/U7X3u2UQzdVtdR5e8cU4sar51Z4rXQirlzK6q+kVzjx
 EdQipSEpThUxKv3NoPk8YjnVwZYuWu2EJ9DV3s3Gh5RqYdj0j+sGjnXMF1osYmR6PLSO
 CAvZpMjpVCJcKP0uUTSP1vm7d9LsHFoVpEc2CT7VjOFdOZ8Tfw1vgk3FiHDzK90DJf9q
 HlxQ==
X-Gm-Message-State: AOAM5325/OUB6nyzmHtmDWJ/0yOAotPLCAHUPMi7vgjDY8Y+KO29e5lj
 NzCeis2sA5aHdTpOmyPv/sJ5boxaXBaHkLCQdm9WKA==
X-Google-Smtp-Source: ABdhPJz5HfFFIeXgipaL9sR3oaEPdPGSeCu2dY2viPYbBLHdo2XPRjZRYoOs4Wc0+pSoq2L+LTC210m4iC4eHs5H21I=
X-Received: by 2002:aa7:8246:0:b0:44b:4870:1b09 with SMTP id
 e6-20020aa78246000000b0044b48701b09mr8430611pfn.82.1633068297060; Thu, 30 Sep
 2021 23:04:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-4-oupton@google.com>
In-Reply-To: <20210923191610.3814698-4-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 30 Sep 2021 23:04:41 -0700
Message-ID: <CAAeT=FxXsJdnrQCr4m-LcADr=WX5pKEa2OdeTf3bRGM08iC3Uw@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] KVM: arm64: Encapsulate reset request logic in a
 helper function
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, Sep 23, 2021 at 12:16 PM Oliver Upton <oupton@google.com> wrote:
>
> In its implementation of the PSCI function, KVM needs to request that a
> target vCPU resets before its next entry into the guest. Wrap the logic
> for requesting a reset in a function for later use by other implemented
> PSCI calls.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/psci.c | 59 +++++++++++++++++++++++++------------------
>  1 file changed, 35 insertions(+), 24 deletions(-)
>
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 310b9cb2b32b..bb59b692998b 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -64,9 +64,40 @@ static inline bool kvm_psci_valid_affinity(unsigned long affinity)
>         return !(affinity & ~MPIDR_HWID_BITMASK);
>  }
>
> -static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> +static void kvm_psci_vcpu_request_reset(struct kvm_vcpu *vcpu,
> +                                       unsigned long entry_addr,
> +                                       unsigned long context_id,
> +                                       bool big_endian)
>  {
>         struct vcpu_reset_state *reset_state;
> +
> +       lockdep_assert_held(&vcpu->kvm->lock);
> +
> +       reset_state = &vcpu->arch.reset_state;
> +       reset_state->pc = entry_addr;
> +
> +       /* Propagate caller endianness */
> +       reset_state->be = big_endian;
> +
> +       /*
> +        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> +        * the general purpose registers are undefined upon CPU_ON.
> +        */
> +       reset_state->r0 = context_id;
> +
> +       WRITE_ONCE(reset_state->reset, true);
> +       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> +
> +       /*
> +        * Make sure the reset request is observed if the change to
> +        * power_state is observed.
> +        */
> +       smp_wmb();
> +       vcpu->arch.power_off = false;
> +}
> +
> +static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> +{
>         struct kvm *kvm = source_vcpu->kvm;
>         struct kvm_vcpu *vcpu = NULL;
>         unsigned long cpu_id;
> @@ -90,29 +121,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>                         return PSCI_RET_INVALID_PARAMS;
>         }
>
> -       reset_state = &vcpu->arch.reset_state;
> -
> -       reset_state->pc = smccc_get_arg2(source_vcpu);
> -
> -       /* Propagate caller endianness */
> -       reset_state->be = kvm_vcpu_is_be(source_vcpu);
> -
> -       /*
> -        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> -        * the general purpose registers are undefined upon CPU_ON.
> -        */
> -       reset_state->r0 = smccc_get_arg3(source_vcpu);
> -
> -       WRITE_ONCE(reset_state->reset, true);
> -       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> -
> -       /*
> -        * Make sure the reset request is observed if the change to
> -        * power_state is observed.
> -        */
> -       smp_wmb();
> -
> -       vcpu->arch.power_off = false;
> +       kvm_psci_vcpu_request_reset(vcpu, smccc_get_arg2(source_vcpu),
> +                                   smccc_get_arg3(source_vcpu),
> +                                   kvm_vcpu_is_be(source_vcpu));
>         kvm_vcpu_wake_up(vcpu);
>
>         return PSCI_RET_SUCCESS;
> --
> 2.33.0.685.g46640cef36-goog

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Not directly related to the patch, but the (original) code doesn't
do any sanity checking for the entry address although the PSCI spec says:

"INVALID_ADDRESS is returned when the entry point address is known
by the implementation to be invalid, because it is in a range that
is known not to be available to the caller."


Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
