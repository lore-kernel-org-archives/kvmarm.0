Return-Path: <SRS0=McOM=P3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1AEC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  8 Nov 2021 07:46:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0516461179
	for <kvmarm@archiver.kernel.org>; Mon,  8 Nov 2021 07:46:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0516461179
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76ED74B16E;
	Mon,  8 Nov 2021 02:46:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yYZE0LIRsp1i; Mon,  8 Nov 2021 02:46:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3A014B174;
	Mon,  8 Nov 2021 02:46:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42C3B4B16C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 02:46:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G65KT3hqlOIF for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 02:46:01 -0500 (EST)
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com
 [209.85.215.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93A5249F8F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 02:46:01 -0500 (EST)
Received: by mail-pg1-f177.google.com with SMTP id q126so10478448pgq.13
 for <kvmarm@lists.cs.columbia.edu>; Sun, 07 Nov 2021 23:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=MZURfzT5WqgPzciBayl8Gbd6sno0JzLLiamB607T0vk=;
 b=ZnIUt1JelCsTRR6fIzHidHe9/7Y978GVEDrK4rCMnCd37KYtexjWuBJyJIJuoJ1YeX
 gzom3TeGtLqJcUGnvikaRIeXPjkg22zZ/+dE2a3/2nPtK+6kQzsEqcEkHSlXav4n/0K8
 If3SqjQU+Aj5R4JTA00GrXupya0xWHIimf5z75WSAlaWkBCpaASVIL6YxQDxaJFf2Wje
 QibRNnuZfhxddqdtqDg8azZburkkhB5y+ubuho9D33nshXwB/49ClTnUOMnXI/Kcp/ti
 3JmMtI37F7Cmho4jaSuQhc7jolji8loTld6rvBp2Kv5/Tk1ytCpZcDLIWYIB6VaXhbvl
 49zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=MZURfzT5WqgPzciBayl8Gbd6sno0JzLLiamB607T0vk=;
 b=NNkhX86+Bm9eIKGHqe/NBiIsrU9irzpb4HJADEi5P8PJxaC4WkXhVH5gebl0pUt8q9
 YMppZwamSoyFQUqZ8VxVzOfBP2rZ51YiLHuUDnrCRJBYJsiYgO/7AQC2gA49y5J5fcRL
 3O/wHksWYEiaT1bUdvsAv/M66SF/eyo4IdN9V8obGigI0KWxs0Qb6VVdCxVvDZeFS+Uq
 51XIkuC32vm9Z1kLbsAdT8PVCAWiRmX7bfWXRyANKy1QipeDsGALns1JviEbxQG9wef+
 sKulpDoaPaTi8/tZ/36TII0vq3zKiMxbMI0gTNDw7KSYwBvw1BMpday4NjZKOgg4GnXq
 NJbA==
X-Gm-Message-State: AOAM5311XKlvCwlLnh2CfVa/t0+ZgpcPKBINlBvneAL5Vx9kBISR55ye
 ZQcbO66IW1ejiSvBgOGW6o6mX+0DNeluI3Wo6h2V1w==
X-Google-Smtp-Source: ABdhPJx7WXF80L+8m+mkuvMLgSvWfhN3xBVAqB7AEFTyz0qB+7z/x/1Trxos8znWh3vl0Z8zHcVz8O9fi87762zc1Ek=
X-Received: by 2002:aa7:8246:0:b0:44b:4870:1b09 with SMTP id
 e6-20020aa78246000000b0044b48701b09mr81055621pfn.82.1636357560558; Sun, 07
 Nov 2021 23:46:00 -0800 (PST)
MIME-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
 <20211103062520.1445832-5-reijiw@google.com>
 <YYQLdtcjiTESMFES@google.com>
In-Reply-To: <YYQLdtcjiTESMFES@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Sun, 7 Nov 2021 23:45:44 -0800
Message-ID: <CAAeT=Fw61dX4fZQf04OTi8TammDZq8N=5jufMe76FVdWAjPYJA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 04/28] KVM: arm64: Keep consistency of ID registers
 between vCPUs
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
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

Hi Oliver,

On Thu, Nov 4, 2021 at 9:34 AM Oliver Upton <oupton@google.com> wrote:
>
> On Tue, Nov 02, 2021 at 11:24:56PM -0700, Reiji Watanabe wrote:
> > All vCPUs that are owned by a VM must have the same values of ID
> > registers.
> >
> > Return an error at the very first KVM_RUN for a vCPU if the vCPU has
> > different values in any ID registers from any other vCPUs that have
> > already started KVM_RUN once.  Also, return an error if userspace
> > tries to change a value of ID register for a vCPU that already
> > started KVM_RUN once.
> >
> > Changing ID register is still not allowed at present though.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 ++
> >  arch/arm64/kvm/arm.c              |  4 ++++
> >  arch/arm64/kvm/sys_regs.c         | 31 +++++++++++++++++++++++++++++++
> >  3 files changed, 37 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 0cd351099adf..69af669308b0 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -745,6 +745,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
> >  long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> >                               struct kvm_arm_copy_mte_tags *copy_tags);
> >
> > +int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu);
> > +
> >  /* Guest/host FPSIMD coordination helpers */
> >  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> >  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index fe102cd2e518..83cedd74de73 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -595,6 +595,10 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
> >               return -EPERM;
> >
> >       vcpu->arch.has_run_once = true;
> > +     if (kvm_id_regs_consistency_check(vcpu)) {
> > +             vcpu->arch.has_run_once = false;
> > +             return -EPERM;
> > +     }
>
> It might be nice to return an error to userspace synchronously (i.e. on
> the register write). Of course, there is still the issue where userspace
> writes to some (but not all) of the vCPU feature ID registers, which
> can't be known until the first KVM_RUN.

Yes, I agree that it would be better.  As I mentioned for patch-02,
I will remove the consistency checking amongst vCPUs anyway though.


> >       kvm_arm_vcpu_init_debug(vcpu);
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 64d51aa3aee3..e34351fdc66c 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1436,6 +1436,10 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
> >       if (val != read_id_reg(vcpu, rd, raz) && !GET_ID_REG_INFO(encoding))
> >               return -EINVAL;
> >
> > +     /* Don't allow to change the reg after the first KVM_RUN. */
> > +     if (vcpu->arch.has_run_once)
> > +             return -EINVAL;
> > +
> >       if (raz)
> >               return 0;
> >
> > @@ -3004,6 +3008,33 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
> >       return write_demux_regids(uindices);
> >  }
> >
> > +int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu)
> > +{
> > +     int i;
> > +     const struct kvm_vcpu *t_vcpu;
> > +
> > +     /*
> > +      * Make sure vcpu->arch.has_run_once is visible for others so that
> > +      * ID regs' consistency between two vCPUs is checked by either one
> > +      * at least.
> > +      */
> > +     smp_mb();
> > +     WARN_ON(!vcpu->arch.has_run_once);
> > +
> > +     kvm_for_each_vcpu(i, t_vcpu, vcpu->kvm) {
> > +             if (!t_vcpu->arch.has_run_once)
> > +                     /* ID regs still could be updated. */
> > +                     continue;
> > +
> > +             if (memcmp(&__vcpu_sys_reg(vcpu, ID_REG_BASE),
> > +                        &__vcpu_sys_reg(t_vcpu, ID_REG_BASE),
> > +                        sizeof(__vcpu_sys_reg(vcpu, ID_REG_BASE)) *
> > +                                     KVM_ARM_ID_REG_MAX_NUM))
> > +                     return -EINVAL;
> > +     }
> > +     return 0;
> > +}
> > +
>
> Couldn't we do the consistency check exactly once per VM? I had alluded
> to this when reviewing Raghu's patches, but I think the same applies
> here too: an abstraction for detecting the first vCPU to run in a VM.
>
> https://lore.kernel.org/all/YYMKphExkqttn2w0@google.com/

Yes, the same applies to this, as well.

Thank you so much for your review !

Regards,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
