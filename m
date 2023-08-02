Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3413C8F2
	for <kvmarm@lists.linux.dev>; Wed,  2 Aug 2023 15:55:56 +0000 (UTC)
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6bcae8c4072so6194a34.1
        for <kvmarm@lists.linux.dev>; Wed, 02 Aug 2023 08:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690991756; x=1691596556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ubQj/3dGnf4pbnMsHPiejppGoYTt9Wg22xTu32HO9BE=;
        b=PHGwRIHJcnyadfR6XMlYOTUzdIToWvVmA6TonalqrStJ1a/h7gV18QalYLEHqVp2bA
         dMzecMgMDncMgw0K1/JexArtgtCDqGpLjIVo2uAIBD+f5bw71Uk1imSeyztmDD8A/ZIG
         HLmpKfkVnagFWUDplPe2uQHAizQKt2kdJA6dePUzY47J93pxSYPItKh5Nx5cO3gVAFy3
         byVyl4G4NUdgTuFuOH6cgZ9gv3D/rUGnt78RxnRdiTh7jGXFosT9qkCpB1NxpC0js32o
         SAB8hgWPHNhu366rWAwuRitDAHggfmOiNf5c7NURqlmEHd4rV87iXvds9n671PElOgu8
         ThkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690991756; x=1691596556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ubQj/3dGnf4pbnMsHPiejppGoYTt9Wg22xTu32HO9BE=;
        b=kP1aJ+dMky1dDNwS28xKpax/JWpcxA2CvarqxENkTkK8XHXMdDkY+7uTptxMJ+HrNO
         Nka+uSbS33/xEJ7fHyGfYsYhmfyLJAD44sHINOqczxVavYAdtIwQPR5uJj552akA4LCt
         eXE3ic0qe8vDVwNayhbfk5eYuVoKirCXogvKs3NeCnBKQ4+4HPXoQcmN47FK6YmEfymU
         0DUtp8v9zYul+pbUBLuQ5wEOzTrrqn0TbqioCIhJZlTizoQw8xqogoUVWpLsrGfcoi3r
         QjJDRt4jUbfxQ3RdlwGzOMckcbF6U+Md7pbB9tD/9yJzGPbN+f62mQlVwvtgble9YanI
         qGRA==
X-Gm-Message-State: ABy/qLZ9w2TsXmJdVDdCQZQp1p0BZt4P2qCaqT0iD3attUWm3ioVM4+6
	KIO4ZqhQEGTy8Nz8YUZ1kA80RoNdu0T2wclo0E49aQ==
X-Google-Smtp-Source: APBJJlF4o1bIcGiQFf43fjASxBZeK7+bmV1iOO1ChqUB+DF24sSx0BBJWGweWhipBaZvn1pzE26kQZAvY9+DOmyer9E=
X-Received: by 2002:a05:6870:d613:b0:18d:4738:33fc with SMTP id
 a19-20020a056870d61300b0018d473833fcmr17382535oaq.37.1690991755595; Wed, 02
 Aug 2023 08:55:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
 <20230801152007.337272-2-jingzhangos@google.com> <ZMmdnou5Pk/9V1Gs@linux.dev>
In-Reply-To: <ZMmdnou5Pk/9V1Gs@linux.dev>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 2 Aug 2023 08:55:43 -0700
Message-ID: <CAAdAUtj-6tk53TE6p0TYBfmFghj94g+Sg2KK_80Gar18kJ=5OA@mail.gmail.com>
Subject: Re: [PATCH v7 01/10] KVM: arm64: Allow userspace to get the writable
 masks for feature ID registers
To: Oliver Upton <oliver.upton@linux.dev>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Suraj Jitindar Singh <surajjs@amazon.com>, 
	Cornelia Huck <cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Tue, Aug 1, 2023 at 5:04=E2=80=AFPM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> Hi Jing,
>
> On Tue, Aug 01, 2023 at 08:19:57AM -0700, Jing Zhang wrote:
> > Add a VM ioctl to allow userspace to get writable masks for feature ID
> > registers in below system register space:
> > op0 =3D 3, op1 =3D {0, 1, 3}, CRn =3D 0, CRm =3D {0 - 7}, op2 =3D {0 - =
7}
> > This is used to support mix-and-match userspace and kernels for writabl=
e
> > ID registers, where userspace may want to know upfront whether it can
> > actually tweak the contents of an idreg or not.
> >
> > Suggested-by: Marc Zyngier <maz@kernel.org>
> > Suggested-by: Cornelia Huck <cohuck@redhat.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 ++
> >  arch/arm64/include/uapi/asm/kvm.h | 25 +++++++++++++++
> >  arch/arm64/kvm/arm.c              |  3 ++
> >  arch/arm64/kvm/sys_regs.c         | 51 +++++++++++++++++++++++++++++++
> >  include/uapi/linux/kvm.h          |  2 ++
> >  5 files changed, 83 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index d3dd05bbfe23..3996a3707f4e 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1074,6 +1074,8 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> >                              struct kvm_arm_copy_mte_tags *copy_tags);
> >  int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
> >                                   struct kvm_arm_counter_offset *offset=
);
> > +int kvm_vm_ioctl_get_feature_id_writable_masks(struct kvm *kvm,
> > +                                            u64 __user *masks);
> >
> >  /* Guest/host FPSIMD coordination helpers */
> >  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uap=
i/asm/kvm.h
> > index f7ddd73a8c0f..2970c0d792ee 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -505,6 +505,31 @@ struct kvm_smccc_filter {
> >  #define KVM_HYPERCALL_EXIT_SMC               (1U << 0)
> >  #define KVM_HYPERCALL_EXIT_16BIT     (1U << 1)
> >
> > +/* Get feature ID registers userspace writable mask. */
> > +/*
> > + * From DDI0487J.a, D19.2.66 ("ID_AA64MMFR2_EL1, AArch64 Memory Model
> > + * Feature Register 2"):
> > + *
> > + * "The Feature ID space is defined as the System register space in
> > + * AArch64 with op0=3D=3D3, op1=3D=3D{0, 1, 3}, CRn=3D=3D0, CRm=3D=3D{=
0-7},
> > + * op2=3D=3D{0-7}."
> > + *
> > + * This covers all R/O registers that indicate anything useful feature
> > + * wise, including the ID registers.
> > + */
> > +#define ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)          \
> > +     ({                                                              \
> > +             __u64 __op1 =3D (op1) & 3;                               =
 \
> > +             __op1 -=3D (__op1 =3D=3D 3);                             =
     \
> > +             (__op1 << 6 | ((crm) & 7) << 3 | (op2));                \
> > +     })
> > +
> > +#define ARM64_FEATURE_ID_SPACE_SIZE  (3 * 8 * 8)
> > +
> > +struct feature_id_writable_masks {
> > +     __u64 mask[ARM64_FEATURE_ID_SPACE_SIZE];
> > +};
>
> This UAPI is rather difficult to extend in the future. We may need to
> support describing the masks of multiple ranges of registers in the
> future. I was thinking something along the lines of:
>
>         enum reg_mask_range_idx {
>                 FEATURE_ID,
>         };
>
>         struct reg_mask_range {
>                 __u64 idx;
>                 __u64 *masks;
>                 __u64 rsvd[6];
>         };
>
Since have the way to map sysregs encoding to the index in the mask
array, we can extend the UAPI by just adding a size field in struct
feature_id_writable_masks like below:
struct feature_id_writable_masks {
         __u64 size;
         __u64 mask[ARM64_FEATURE_ID_SPACE_SIZE];
};
The 'size' field can be used as input for the size of 'mask' array and
output for the number of masks actually read in.
This way, we can freely add more ranges without breaking anything in usersp=
ace.
WDYT?
> >  #endif
> >
> >  #endif /* __ARM_KVM_H__ */
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 72dc53a75d1c..c9cd14057c58 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1630,6 +1630,9 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned=
 int ioctl, unsigned long arg)
> >
> >               return kvm_vm_set_attr(kvm, &attr);
> >       }
> > +     case KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS: {
> > +             return kvm_vm_ioctl_get_feature_id_writable_masks(kvm, ar=
gp);
> > +     }
> >       default:
> >               return -EINVAL;
> >       }
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 2ca2973abe66..d9317b640ba5 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -3560,6 +3560,57 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu=
 *vcpu, u64 __user *uindices)
> >       return write_demux_regids(uindices);
> >  }
> >
> > +#define ARM64_FEATURE_ID_SPACE_INDEX(r)                      \
> > +     ARM64_FEATURE_ID_SPACE_IDX(sys_reg_Op0(r),      \
> > +             sys_reg_Op1(r),                         \
> > +             sys_reg_CRn(r),                         \
> > +             sys_reg_CRm(r),                         \
> > +             sys_reg_Op2(r))
> > +
> > +static bool is_feature_id_reg(u32 encoding)
> > +{
> > +     return (sys_reg_Op0(encoding) =3D=3D 3 &&
> > +             (sys_reg_Op1(encoding) < 2 || sys_reg_Op1(encoding) =3D=
=3D 3) &&
> > +             sys_reg_CRn(encoding) =3D=3D 0 &&
> > +             sys_reg_CRm(encoding) <=3D 7);
> > +}
> > +
> > +int kvm_vm_ioctl_get_feature_id_writable_masks(struct kvm *kvm, u64 __=
user *masks)
> > +{
>
> Use the correct type for the user pointer (it's a struct pointer).
Will fix.
>
> > +     /* Wipe the whole thing first */
> > +     for (int i =3D 0; i < ARM64_FEATURE_ID_SPACE_SIZE; i++)
> > +             if (put_user(0, masks + i))
> > +                     return -EFAULT;
>
> Why not:
>
>         if (clear_user(masks, ARM64_FEATURE_ID_SPACE_SIZE * sizeof(__u64)=
))
>                 return -EFAULT;
Sure, will do.
>
> Of course, this may need to be adapted if the UAPI struct changes.
>
> --
> Thanks,
> Oliver
Thanks,
Jing
