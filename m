Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7F7EBD
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 04:57:39 +0000 (UTC)
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6bd045336c6so499474a34.2
        for <kvmarm@lists.linux.dev>; Wed, 09 Aug 2023 21:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691643458; x=1692248258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P52oQjHv/N2kxb4CuFKB34l5IFDBzPIKadzPY+GGP68=;
        b=Lkb61h4kUtgMRTA3aUaqDDZuiLx+K/0iIovSASA1mmuUpLRSxvDOZejTUq9UYS/hQG
         oCzT+AgABGj/4qbBCXZXQ+UqZ72LpcGpfEtgePIEvXcQOSOS7DjPQ8Kblr90Iwxt6ss2
         wo8IdfpTHYoKCLKdszP2bJReZGFoTr0X98swZ1CNSog5zxs8WNPFbxYfZZpOwv3Gsd++
         LTipHbp8VhK1sTUr4qdqb49NYz+oM6LzC+ukXblIaO0mkwX69ukRY0qUKoeJpGKHl0FF
         C84hVTm9Is2YOkSI7ooAeIUJzWkTIcYM9DgCzmGTevEO8lHosuKyjtKOZSWOdMLdfh3L
         k/Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691643458; x=1692248258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P52oQjHv/N2kxb4CuFKB34l5IFDBzPIKadzPY+GGP68=;
        b=Q9crCd5ITn1rwjeP4E7M0bU0LaOzsLZcaLPNu67quVUvEEFYNt5xPMhrEQgnPYjotA
         wIUS+YQO8jW0JcsRO1qGazAkDbaGqKnOWwdonxN66KDFbmqvgsdmMUz0U8xNmvdr1dra
         jRuyMRkV34tybBH+5muyVF/OVccD7pypiCUklxH6WFNOny1qNRqAdekQ2HqQXlLjNYOB
         EPlyM/8V3j9C2kYfns49Uq4vsPW3F/X6+rqE4xsrXweRaGSlEOYvOJuRLKJ4E4CtIZaW
         ey3hcocHpIXMIOQRrOL9RZ+lZ77PdKRo461Tl1iF67wWbs+J7MHlr1HSs+UHR8b8L920
         JH5g==
X-Gm-Message-State: AOJu0Yyaap4PjtlhN+WnixmTNhXm/5KokeyVVicW3Wl7yQ4icO+dxOnh
	Dp5XzyA35mUffWQOtp7W/6bZnfNAALT4l7L9Yqecfg==
X-Google-Smtp-Source: AGHT+IHcng480T2w3xq2RGK8TOxp1jaeYp8+wPXdE27TF2cwqsMbSbzFhIjrwGcrCcnPpMzPcvFjRHUH6CgN4y12t1c=
X-Received: by 2002:a05:6870:b387:b0:1bf:80f2:8429 with SMTP id
 w7-20020a056870b38700b001bf80f28429mr1539917oap.40.1691643458125; Wed, 09 Aug
 2023 21:57:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
 <20230801152007.337272-2-jingzhangos@google.com> <f3853532-a449-fb62-5366-3d3ce689c3ff@redhat.com>
In-Reply-To: <f3853532-a449-fb62-5366-3d3ce689c3ff@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 9 Aug 2023 21:57:25 -0700
Message-ID: <CAAdAUtgcGcJLkf4AMvtvZgPsTX3p38ytSmX4RybndvAP6C1_NA@mail.gmail.com>
Subject: Re: [PATCH v7 01/10] KVM: arm64: Allow userspace to get the writable
 masks for feature ID registers
To: Shaoqin Huang <shahuang@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Suraj Jitindar Singh <surajjs@amazon.com>, 
	Cornelia Huck <cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Shaoqin,

On Wed, Aug 9, 2023 at 9:27=E2=80=AFPM Shaoqin Huang <shahuang@redhat.com> =
wrote:
>
> Hi Jing,
>
> On 8/1/23 23:19, Jing Zhang wrote:
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
> >   arch/arm64/include/asm/kvm_host.h |  2 ++
> >   arch/arm64/include/uapi/asm/kvm.h | 25 +++++++++++++++
> >   arch/arm64/kvm/arm.c              |  3 ++
> >   arch/arm64/kvm/sys_regs.c         | 51 ++++++++++++++++++++++++++++++=
+
> >   include/uapi/linux/kvm.h          |  2 ++
> >   5 files changed, 83 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index d3dd05bbfe23..3996a3707f4e 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1074,6 +1074,8 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> >                              struct kvm_arm_copy_mte_tags *copy_tags);
> >   int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
> >                                   struct kvm_arm_counter_offset *offset=
);
> > +int kvm_vm_ioctl_get_feature_id_writable_masks(struct kvm *kvm,
> > +                                            u64 __user *masks);
> >
> >   /* Guest/host FPSIMD coordination helpers */
> >   int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uap=
i/asm/kvm.h
> > index f7ddd73a8c0f..2970c0d792ee 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -505,6 +505,31 @@ struct kvm_smccc_filter {
> >   #define KVM_HYPERCALL_EXIT_SMC              (1U << 0)
> >   #define KVM_HYPERCALL_EXIT_16BIT    (1U << 1)
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
> > +
> >   #endif
> >
> >   #endif /* __ARM_KVM_H__ */
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
> >   }
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
>
> A fool question.
>
> In the code base, there is a function is_id_reg() to check if it's a
> id_reg, what's the difference between the is_feature_id_reg() and the
> is_id_reg()?
>
> /*
>   * Return true if the register's (Op0, Op1, CRn, CRm, Op2) is
>   * (3, 0, 0, crm, op2), where 1<=3Dcrm<8, 0<=3Dop2<8.
>   */
> static inline bool is_id_reg(u32 id)
> {
>         return (sys_reg_Op0(id) =3D=3D 3 && sys_reg_Op1(id) =3D=3D 0 &&
>                 sys_reg_CRn(id) =3D=3D 0 && sys_reg_CRm(id) >=3D 1 &&
>                 sys_reg_CRm(id) < 8);
> }
>
> Thanks,
> Shaoqin
>

Basically, is_feature_id_reg() is used to check whether the reg is in
the feature ID system register space. You can refer to page 6788 at
DDI0487J.a, D19.2.66 for the feature ID space range as below:
The Feature ID space is defined as the System register space in
AArch64 with op0=3D=3D3, op1=3D=3D{0,
1, 3}, CRn=3D=3D0, CRm=3D=3D{0-7}, op2=3D=3D{0-7}.

But is_id_reg() is used to check whether the reg is one of the ID_*
regs which have been defined in the previous feature ID space range.
You can refer to the table D18-2 at page D18-6308 for the encoding.

Agreed that the names are somewhat confusing.

> > +
> > +int kvm_vm_ioctl_get_feature_id_writable_masks(struct kvm *kvm, u64 __=
user *masks)
> > +{
> > +     /* Wipe the whole thing first */
> > +     for (int i =3D 0; i < ARM64_FEATURE_ID_SPACE_SIZE; i++)
> > +             if (put_user(0, masks + i))
> > +                     return -EFAULT;
> > +
> > +     for (int i =3D 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> > +             const struct sys_reg_desc *reg =3D &sys_reg_descs[i];
> > +             u32 encoding =3D reg_to_encoding(reg);
> > +             u64 val;
> > +
> > +             if (!is_feature_id_reg(encoding) || !reg->set_user)
> > +                     continue;
> > +
> > +             /*
> > +              * For ID registers, we return the writable mask. Other f=
eature
> > +              * registers return a full 64bit mask. That's not necessa=
ry
> > +              * compliant with a given revision of the architecture, b=
ut the
> > +              * RES0/RES1 definitions allow us to do that.
> > +              */
> > +             if (is_id_reg(encoding)) {
> > +                     if (!reg->val)
> > +                             continue;
> > +                     val =3D reg->val;
> > +             } else {
> > +                     val =3D ~0UL;
> > +             }
> > +
> > +             if (put_user(val, (masks + ARM64_FEATURE_ID_SPACE_INDEX(e=
ncoding))))
> > +                     return -EFAULT;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> >   int __init kvm_sys_reg_table_init(void)
> >   {
> >       struct sys_reg_params params;
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index f089ab290978..86ffdf134eb8 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1555,6 +1555,8 @@ struct kvm_s390_ucas_mapping {
> >   #define KVM_ARM_MTE_COPY_TAGS         _IOR(KVMIO,  0xb4, struct kvm_a=
rm_copy_mte_tags)
> >   /* Available with KVM_CAP_COUNTER_OFFSET */
> >   #define KVM_ARM_SET_COUNTER_OFFSET _IOW(KVMIO,  0xb5, struct kvm_arm_=
counter_offset)
> > +#define KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS \
> > +                     _IOR(KVMIO,  0xb6, struct feature_id_writable_mas=
ks)
> >
> >   /* ioctl for vm fd */
> >   #define KVM_CREATE_DEVICE     _IOWR(KVMIO,  0xe0, struct kvm_create_d=
evice)
>
> --
> Shaoqin
>

Jing
