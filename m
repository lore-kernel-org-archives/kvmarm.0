Return-Path: <SRS0=VGwd=LQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A5BBC2B9F4
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 08:08:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ADB2B61356
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 08:08:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADB2B61356
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BAD8401A4;
	Tue, 22 Jun 2021 04:08:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Lq5BLeQoeOQJ; Tue, 22 Jun 2021 04:08:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 226E84031F;
	Tue, 22 Jun 2021 04:08:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3771402BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 04:08:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PSdT54wRSknN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jun 2021 04:08:28 -0400 (EDT)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com
 [209.85.210.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 80CF2401A4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 04:08:28 -0400 (EDT)
Received: by mail-ot1-f42.google.com with SMTP id
 v22-20020a0568301416b029044e2d8e855eso11216745otp.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 01:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Beo38iuohodlyRGHyjXttlsvIYg9mKSm+zuOAhH7bbI=;
 b=eXFdd6VxuZa/DYPOmOXnXEky4VQsJMT/UQpduHu02BEU1YhAn1pFfY4FaYLDYL+ikC
 uAHK2J/vbGb40UKTAEfT/yo1IYWvbxUDVqFGzgBAydAhPlRO4zmhMwZL5+u7HGavYZKH
 H12WEshODfMx+D7fAubGmbmY9lBoPGpqkW3J/X+5gcKxM/i2xzfNbVMqDiYsTU1158qs
 gg9IWNeR2Yza7A5Ic/pwJaQ449BMitgtZvwr4VOY6PjYgZeq5ar+lh1ej3pCQJ9MnJwZ
 JvE5EgYzJz7WiQzsrYxSPY3I6n1l+xuGf8aj3ziygHc6+Z2EAocVErEEFRefl+xrNi8E
 nKHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Beo38iuohodlyRGHyjXttlsvIYg9mKSm+zuOAhH7bbI=;
 b=HRKr+unWnZMJTqY4Z1SekRaTmkiDEeO5n+ECUXe0RcMrFJHgvfEIWbOm04hyPX0XHO
 o5wFr47Z93QHBrXwlT2Viku9IRjNUqxezoiZRmTN5bAXCbU/f/y6NLvShVs8UJ/D+/7B
 P7F136e7iSOrarvD8J1FV9ckMJCA3X993p27t8QKC/aAqZsOsaENceUPr63cIKcv0ShG
 bXVRkYCSifZKVbfh7Sk8Mq6vpyxVeOlrsoSFanuhIWQLNJmlyUgj73nX6qurM2HLCETl
 MGNELPE802vmG/Ppu2U1x3+zz05kqEfq2M6mB5WZJQGX+qzVFBZtmpMiHqoYilRRRBOJ
 dLsQ==
X-Gm-Message-State: AOAM532dcLmFXR8PNI4YHjC3qLWVTZQTEr5aRLkvMSLG+ngJJMdbG3N7
 89HJEJqGk6UpB6G4xS65tiAyiqommR9bhtTahY92cQ==
X-Google-Smtp-Source: ABdhPJyiET1EnWwNel3SWJVHizN68wDafL2KmojvV1sgueaM5ziIuDkR6iIl0gSG5oojwkafjVs4ZM7JoA8uNdQS05g=
X-Received: by 2002:a05:6830:1598:: with SMTP id
 i24mr2089639otr.52.1624349307481; 
 Tue, 22 Jun 2021 01:08:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210621111716.37157-1-steven.price@arm.com>
 <20210621111716.37157-5-steven.price@arm.com>
In-Reply-To: <20210621111716.37157-5-steven.price@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jun 2021 09:07:51 +0100
Message-ID: <CA+EHjTzuduzTcJo+jjVzVAVUB4i3Nr3mki4jyiNW9K=pr-HPYA@mail.gmail.com>
Subject: Re: [PATCH v17 4/6] KVM: arm64: Expose KVM_ARM_CAP_MTE
To: Steven Price <steven.price@arm.com>
Cc: Juan Quintela <quintela@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
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

Hi,

On Mon, Jun 21, 2021 at 12:18 PM Steven Price <steven.price@arm.com> wrote:
>
> It's now safe for the VMM to enable MTE in a guest, so expose the
> capability to user space.
>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/kvm/arm.c      | 9 +++++++++
>  arch/arm64/kvm/reset.c    | 4 ++++
>  arch/arm64/kvm/sys_regs.c | 3 +++
>  3 files changed, 16 insertions(+)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e720148232a0..28ce26a68f09 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -93,6 +93,12 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                 r = 0;
>                 kvm->arch.return_nisv_io_abort_to_user = true;
>                 break;
> +       case KVM_CAP_ARM_MTE:
> +               if (!system_supports_mte() || kvm->created_vcpus)
> +                       return -EINVAL;
> +               r = 0;
> +               kvm->arch.mte_enabled = true;
> +               break;
>         default:
>                 r = -EINVAL;
>                 break;
> @@ -237,6 +243,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>                  */
>                 r = 1;
>                 break;
> +       case KVM_CAP_ARM_MTE:
> +               r = system_supports_mte();
> +               break;
>         case KVM_CAP_STEAL_TIME:
>                 r = kvm_arm_pvtime_supported();
>                 break;
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index d37ebee085cf..9e6922b9503a 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -244,6 +244,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>         switch (vcpu->arch.target) {
>         default:
>                 if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
> +                       if (vcpu->kvm->arch.mte_enabled) {
> +                               ret = -EINVAL;
> +                               goto out;
> +                       }
>                         pstate = VCPU_RESET_PSTATE_SVC;
>                 } else {
>                         pstate = VCPU_RESET_PSTATE_EL1;

nit: I was wondering whether this check would be better suited in
kvm_vcpu_set_target, rather than here (kvm_reset_vcpu). kvm_reset_vcpu
is called by kvm_vcpu_set_target, but kvm_vcpu_set_target is where
checking for supported features happens. It might be better to group
all such checks together. I don't think that there is any risk of this
feature being toggled by the other call path to kvm_reset_vcpu (via
check_vcpu_requests).

Cheers,
/fuad

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5c75b24eae21..f6f126eb6ac1 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1312,6 +1312,9 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
>                                    const struct sys_reg_desc *rd)
>  {
> +       if (kvm_has_mte(vcpu->kvm))
> +               return 0;
> +
>         return REG_HIDDEN;
>  }
>
> --
> 2.20.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
