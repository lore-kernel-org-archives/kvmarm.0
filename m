Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF0C7E6
	for <kvmarm@lists.linux.dev>; Fri, 10 Mar 2023 02:14:34 +0000 (UTC)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-1755e639b65so4434891fac.3
        for <kvmarm@lists.linux.dev>; Thu, 09 Mar 2023 18:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678414474;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UM2gsUWwVSpEQWLnAnDEt7Ju3bE40/PbNcNR4oeIX2E=;
        b=czYP0S2zC0Bfx0whBmhspkdXqQsiv9IBS1vTRpN6404GElyuNGqPG2WKbkpw4mry8p
         BRejBew2K3QtczJW2rgu/S44/8c++rZBaCifneLBH6SofnpAIvNclAZxwKRn9mzixySW
         uqUOBf03mC1k4g0ITTiUA/t6sHCJ51v80QPmSoWcgDtdNKC2S6sB0sA6Rt+THLB8xl6U
         EQU+6FT6vmYaQSkyn4mSUvff9Pz/RpKHYa/IB1R2rkkxAC383TfOSlK2Krg7UvnmUNCR
         bUr+2s9RdD6PQsJroiMxQywfRwTfj1FGGGJRZEajW4IIpE0TT4Vs6/CfyDRKWjIfFFbb
         tBQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678414474;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UM2gsUWwVSpEQWLnAnDEt7Ju3bE40/PbNcNR4oeIX2E=;
        b=DIetm/uRNwiazqhkAOGmoI0a6QI0g+7l7hA/F6NgYLRCByltySKA0U/RxQY2rFTRA9
         k0WuLWQW4cZhb4a5BHx6YrOFuot78qeLVPlxGf0D+a2a3o9+Qu+TafAcHKqVwxUff4yp
         ySMXoNCBGQz/JADA748VZWeUUKPECy8CJYfDZdJVEEqGYR+XQSDzT5unVHeDz2alwfGl
         PFSujclGC06ixoZ0zIRpN3gRbmf5yxousGIrRQP9CxuM102k1N78FTn5EKTkOst/zgWO
         TgtIGkjY/nrcYJ+RpYeh5xFIPUnSau2SoRl4pESnH40jG8YOexF2/fWRnJgIVWvKQ8ZG
         1iAw==
X-Gm-Message-State: AO0yUKVMmdYM+eF6x5Jea7Jj2J+ytXPuODtEOkqZLxdBd6OwMYFbCIPc
	M0d3NidVly/3cQWG1uJU/G6pjMT8hvCVe3vYTrN9iQ==
X-Google-Smtp-Source: AK7set+UZWwWlbF+ncnAtRwRtYIOCwi2htXVbIVui7/Bd76qnjiQJE8YdNXuy7rPQbZmfxWyQgtgs+24KwVDHVVibCU=
X-Received: by 2002:a05:6870:5aa5:b0:175:2698:9a85 with SMTP id
 dt37-20020a0568705aa500b0017526989a85mr8465693oab.11.1678414473836; Thu, 09
 Mar 2023 18:14:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230228062246.1222387-1-jingzhangos@google.com>
 <20230228062246.1222387-3-jingzhangos@google.com> <ZAe+XettpauZe84X@linux.dev>
In-Reply-To: <ZAe+XettpauZe84X@linux.dev>
From: Jing Zhang <jingzhangos@google.com>
Date: Thu, 9 Mar 2023 18:14:21 -0800
Message-ID: <CAAdAUtjL-4izpM6fOu7q6OtVav3MCOUED86z-=zX4V6xoz-XsQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] KVM: arm64: Save ID registers' sanitized value per guest
To: Oliver Upton <oliver.upton@linux.dev>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Tue, Mar 7, 2023 at 2:44 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hi Jing,
>
> On Tue, Feb 28, 2023 at 06:22:42AM +0000, Jing Zhang wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
> > and save ID registers' sanitized value in the array at KVM_CREATE_VM.
> > Use the saved ones when ID registers are read by the guest or
> > userspace (via KVM_GET_ONE_REG).
> >
> > No functional change intended.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Co-developed-by: Jing Zhang <jingzhangos@google.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 12 +++++++++
> >  arch/arm64/kvm/arm.c              |  1 +
> >  arch/arm64/kvm/id_regs.c          | 44 ++++++++++++++++++++++++-------
> >  arch/arm64/kvm/sys_regs.c         |  2 +-
> >  arch/arm64/kvm/sys_regs.h         |  1 +
> >  5 files changed, 50 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index a1892a8f6032..5c1cec4efa37 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -245,6 +245,16 @@ struct kvm_arch {
> >        * the associated pKVM instance in the hypervisor.
> >        */
> >       struct kvm_protected_vm pkvm;
> > +
> > +     /*
> > +      * Save ID registers for the guest in id_regs[].
> > +      * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in it
> > +      * is (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
> > +      */
> > +#define KVM_ARM_ID_REG_NUM   56
> > +#define IDREG_IDX(id)                (((sys_reg_CRm(id) - 1) << 3) | sys_reg_Op2(id))
> > +#define IDREG(kvm, id)               kvm->arch.id_regs[IDREG_IDX(id)]
>
> I feel like the IDREG(...) macro just obfuscates what is otherwise a
> simple array access.
>
Sure, will use array access.
> > +static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
> > +{
> > +     if (sysreg_visible_as_raz(vcpu, r))
> > +             return 0;
> > +
> > +     return kvm_arm_read_id_reg_with_encoding(vcpu, reg_to_encoding(r));
>
> nit: you could probably drop the '_with_encoding' suffix, as I don't
> believe there are any other flavors of accessors.
>
Yes, will do.
> > +}
> > +
> >  /* cpufeature ID register access trap handlers */
> >
> >  static bool access_id_reg(struct kvm_vcpu *vcpu,
> > @@ -504,3 +505,28 @@ int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
> >       }
> >       return total;
> >  }
> > +
> > +/*
> > + * Set the guest's ID registers that are defined in id_reg_descs[]
> > + * with ID_SANITISED() to the host's sanitized value.
> > + */
> > +void kvm_arm_set_default_id_regs(struct kvm *kvm)
> > +{
> > +     int i;
> > +     u32 id;
> > +     u64 val;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> > +             id = reg_to_encoding(&id_reg_descs[i]);
> > +             if (WARN_ON_ONCE(!is_id_reg(id)))
> > +                     /* Shouldn't happen */
> > +                     continue;
>
> Could you instead wire in a check to kvm_sys_reg_table_init() or do
> something similar to it? Benefit of going that route is we outright
> refuse to run KVM with such an egregious bug.
>
The check is already added in the first commit, which is
kvm_arm_check_idreg_table() and improved progressively in later
commits.
> > +
> > +             if (id_reg_descs[i].visibility == raz_visibility)
> > +                     /* Hidden or reserved ID register */
> > +                     continue;
>
> This sort of check works only for registers known to be RAZ at compile
> time, but not for others that depend on runtime configuration. Is it
> possible to reset the ID register values on the first call to
> KVM_ARM_VCPU_INIT?
>
> The set of configured features is available at that point so you can
> actually handle things like SVE and 32-bit ID registers correctly.
>
This function actually will be replaced with another init function as
you suggested in a later commit (6/6), which would be called in
kvm_arch_init_vm.
> --
> Thanks,
> Oliver
