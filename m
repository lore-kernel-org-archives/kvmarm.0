Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3BE2DF68
	for <kvmarm@lists.linux.dev>; Fri, 15 Dec 2023 13:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yX1LFUNu"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-67ad531686eso14277906d6.1
        for <kvmarm@lists.linux.dev>; Fri, 15 Dec 2023 05:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702647825; x=1703252625; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m8UJ6tb6kcRt8oBCvZL98WE/76aRSieElnvZvZ4uAo4=;
        b=yX1LFUNuR6IOXwcFucEtTZ2Bsx0oBrMrC+zDKVB1N9WyVCeEoxW9u7iPuVbNcWwt0M
         gtSUu+9RjQjOXjoeP8zGLU+dPuYBXBF2sMZNm0CgOO8z/vmXbS8pK2S8miXafqbD6SDK
         ADwuQFD0cq6iHbCutUsaOb8SaPmXg6Wmg7y4moJTKbWZ2aoJvhCrlsBn5/AeZVajTN4n
         UZZoQTqYVaEdase4NYfXtD8iVJ8rB9JXz8NRisRGhFOq/KhjF+WpAGLv09AfvDWzUB07
         n7+6jfZc47qCsOk48GhKZIWrb6Vwmchdam0OgK4aoK/DU8+GPkNohP6j93LgXaHGRa/h
         14OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702647825; x=1703252625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m8UJ6tb6kcRt8oBCvZL98WE/76aRSieElnvZvZ4uAo4=;
        b=fq1PEqs+ipyr5zTDFKRyg5BcORNvavKFaX8gte/QSWbGYSoxh/Hc9RB0EDvVMhxM7W
         vAorGQXoYoXMQC/affkjWUKrqOIlcb9gxVjNnj5YMKEKcJQASGDcmY16Vx5ttJEVDyb/
         UvO6f8+zsOxcbC1kGtQ2eKDl/LWOPgDXskS4prQgTpIijBnGsjfuTb616hPJuES8ruL5
         fLrsYvf6lhTKqujryXNCuDQONNBXm16j+fwxPp4YX69jFqOLsTBaGnA6iH5UTkzUueRR
         Csi5U57NZUKG1X4dUYK8Is7kHr5U4OdXe21llULo8FN97OEox406vsz0EWlZ3DIdy35l
         rRbQ==
X-Gm-Message-State: AOJu0YxkRrQN6NdwDRmmklOgXBfgvewhWkW4/RRU5/p2IPhjksWBOqFh
	DLoNjxPSTIQE/kfRUMr2LKYrUnLufSho0cJT1TDSB4DPIIKCQ0Mz9woSrA==
X-Google-Smtp-Source: AGHT+IFtvR3QaF3eRdZN+IVHcOqiqWGDVXI+hmdtTpIots9kU2mCP6qGy68EpKLeTv5s3/jWv5h0/rHAiQTIUW2Ft/E=
X-Received: by 2002:a05:6214:1943:b0:67e:e82c:5bb2 with SMTP id
 q3-20020a056214194300b0067ee82c5bb2mr11254040qvk.9.1702647824817; Fri, 15 Dec
 2023 05:43:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com> <20231214100158.2305400-10-tabba@google.com>
In-Reply-To: <20231214100158.2305400-10-tabba@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 15 Dec 2023 13:43:08 +0000
Message-ID: <CA+EHjTwrcXjOdo7JG-6fr0YpDq2EtMoTQxngq5H-ELLdjyQG=A@mail.gmail.com>
Subject: Re: [PATCH v3 09/17] KVM: arm64: Handle HAFGRTR_EL2 trapping in
 nested virt
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Dec 14, 2023 at 10:02=E2=80=AFAM Fuad Tabba <tabba@google.com> wrot=
e:
>
> Add the encodings to fine grain trapping fields for HAFGRTR_EL2
> and add the associated handling code in nested virt. Based on
> DDI0601 2023-09. Add the missing field definitions as well,
> both to generate the correct RES0 mask and to be able to toggle
> their FGT bits.

I realized that HAFGRTR_EL2 is present only when both FEAT_AMUv1 and
FEAT_FGT are implemented. Otherwise, direct accesses to it are
UNDEFINED.

I'll fix this when I respin. In the meantime, below is the fix to this
patch. Note that checking for ARM64_HAS_AMU_EXTN is not enough, since,
among other things, it's a weak local cpu feature, i.e., not all cpus
need to have it (and none might).

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h
b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 22f3b916f60c..741d6f0a780a 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -79,6 +79,13 @@ static inline void __activate_traps_fpsimd32(struct
kvm_vcpu *vcpu)
                clr |=3D ~hfg & __ ## reg ## _nMASK;                      \
        } while(0)

+static inline bool cpu_has_amu(void)
+{
+       u64 pfr0 =3D read_sysreg_s(SYS_ID_AA64PFR0_EL1);
+
+       return cpuid_feature_extract_unsigned_field(pfr0,
+               ID_AA64PFR0_EL1_AMU_SHIFT);
+}

 static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 {
@@ -157,6 +164,9 @@ static inline void __activate_traps_hfgxtr(struct
kvm_vcpu *vcpu)
        write_sysreg_s(r_val, SYS_HDFGRTR_EL2);
        write_sysreg_s(w_val, SYS_HDFGWTR_EL2);

+       if (!cpu_has_amu())
+               return;
+
        ctxt_sys_reg(hctxt, HAFGRTR_EL2) =3D read_sysreg_s(SYS_HAFGRTR_EL2)=
;

        r_clr =3D r_set =3D 0;
@@ -185,7 +195,9 @@ static inline void
__deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
        write_sysreg_s(ctxt_sys_reg(hctxt, HFGITR_EL2), SYS_HFGITR_EL2);
        write_sysreg_s(ctxt_sys_reg(hctxt, HDFGRTR_EL2), SYS_HDFGRTR_EL2);
        write_sysreg_s(ctxt_sys_reg(hctxt, HDFGWTR_EL2), SYS_HDFGWTR_EL2);
-       write_sysreg_s(ctxt_sys_reg(hctxt, HAFGRTR_EL2), SYS_HAFGRTR_EL2);
+
+       if (cpu_has_amu())
+               write_sysreg_s(ctxt_sys_reg(hctxt, HAFGRTR_EL2),
SYS_HAFGRTR_EL2);
 }

 static inline void __activate_traps_common(struct kvm_vcpu *vcpu)


Cheers,
/fuad





>
> Also add the code for handling FGT trapping, reading of the
> register, to nested virt.
>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h       |  1 +
>  arch/arm64/kvm/emulate-nested.c         | 48 +++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 12 +++++++
>  arch/arm64/kvm/sys_regs.c               |  1 +
>  4 files changed, 62 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index 824f29f04916..ba14648e2de2 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -443,6 +443,7 @@ enum vcpu_sysreg {
>         HFGITR_EL2,
>         HDFGRTR_EL2,
>         HDFGWTR_EL2,
> +       HAFGRTR_EL2,
>         CNTHP_CTL_EL2,
>         CNTHP_CVAL_EL2,
>         CNTHV_CTL_EL2,
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nes=
ted.c
> index 89901550db34..431fd429932d 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -1012,6 +1012,7 @@ enum fgt_group_id {
>         HDFGRTR_GROUP,
>         HDFGWTR_GROUP,
>         HFGITR_GROUP,
> +       HAFGRTR_GROUP,
>
>         /* Must be last */
>         __NR_FGT_GROUP_IDS__
> @@ -1689,6 +1690,49 @@ static const struct encoding_to_trap_config encodi=
ng_to_fgt[] __initconst =3D {
>         SR_FGT(SYS_PMCR_EL0,            HDFGWTR, PMCR_EL0, 1),
>         SR_FGT(SYS_PMSWINC_EL0,         HDFGWTR, PMSWINC_EL0, 1),
>         SR_FGT(SYS_OSLAR_EL1,           HDFGWTR, OSLAR_EL1, 1),
> +       /*
> +        * HAFGRTR_EL2
> +        */
> +       SR_FGT(SYS_AMEVTYPER1_EL0(15),  HAFGRTR, AMEVTYPER115_EL0, 1),
> +       SR_FGT(SYS_AMEVTYPER1_EL0(14),  HAFGRTR, AMEVTYPER114_EL0, 1),
> +       SR_FGT(SYS_AMEVTYPER1_EL0(13),  HAFGRTR, AMEVTYPER113_EL0, 1),
> +       SR_FGT(SYS_AMEVTYPER1_EL0(12),  HAFGRTR, AMEVTYPER112_EL0, 1),
> +       SR_FGT(SYS_AMEVTYPER1_EL0(11),  HAFGRTR, AMEVTYPER111_EL0, 1),
> +       SR_FGT(SYS_AMEVTYPER1_EL0(10),  HAFGRTR, AMEVTYPER110_EL0, 1),
> +       SR_FGT(SYS_AMEVTYPER1_EL0(9),   HAFGRTR, AMEVTYPER19_EL0, 1),
> +       SR_FGT(SYS_AMEVTYPER1_EL0(8),   HAFGRTR, AMEVTYPER18_EL0, 1),
> +       SR_FGT(SYS_AMEVTYPER1_EL0(7),   HAFGRTR, AMEVTYPER17_EL0, 1),
> +       SR_FGT(SYS_AMEVTYPER1_EL0(6),   HAFGRTR, AMEVTYPER16_EL0, 1),
> +       SR_FGT(SYS_AMEVTYPER1_EL0(5),   HAFGRTR, AMEVTYPER15_EL0, 1),
> +       SR_FGT(SYS_AMEVTYPER1_EL0(4),   HAFGRTR, AMEVTYPER14_EL0, 1),
> +       SR_FGT(SYS_AMEVTYPER1_EL0(3),   HAFGRTR, AMEVTYPER13_EL0, 1),
> +       SR_FGT(SYS_AMEVTYPER1_EL0(2),   HAFGRTR, AMEVTYPER12_EL0, 1),
> +       SR_FGT(SYS_AMEVTYPER1_EL0(1),   HAFGRTR, AMEVTYPER11_EL0, 1),
> +       SR_FGT(SYS_AMEVTYPER1_EL0(0),   HAFGRTR, AMEVTYPER10_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR1_EL0(15),   HAFGRTR, AMEVCNTR115_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR1_EL0(14),   HAFGRTR, AMEVCNTR114_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR1_EL0(13),   HAFGRTR, AMEVCNTR113_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR1_EL0(12),   HAFGRTR, AMEVCNTR112_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR1_EL0(11),   HAFGRTR, AMEVCNTR111_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR1_EL0(10),   HAFGRTR, AMEVCNTR110_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR1_EL0(9),    HAFGRTR, AMEVCNTR19_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR1_EL0(8),    HAFGRTR, AMEVCNTR18_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR1_EL0(7),    HAFGRTR, AMEVCNTR17_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR1_EL0(6),    HAFGRTR, AMEVCNTR16_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR1_EL0(5),    HAFGRTR, AMEVCNTR15_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR1_EL0(4),    HAFGRTR, AMEVCNTR14_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR1_EL0(3),    HAFGRTR, AMEVCNTR13_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR1_EL0(2),    HAFGRTR, AMEVCNTR12_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR1_EL0(1),    HAFGRTR, AMEVCNTR11_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR1_EL0(0),    HAFGRTR, AMEVCNTR10_EL0, 1),
> +       SR_FGT(SYS_AMCNTENCLR1_EL0,     HAFGRTR, AMCNTEN1, 1),
> +       SR_FGT(SYS_AMCNTENSET1_EL0,     HAFGRTR, AMCNTEN1, 1),
> +       SR_FGT(SYS_AMCNTENCLR0_EL0,     HAFGRTR, AMCNTEN0, 1),
> +       SR_FGT(SYS_AMCNTENSET0_EL0,     HAFGRTR, AMCNTEN0, 1),
> +       SR_FGT(SYS_AMEVCNTR0_EL0(3),    HAFGRTR, AMEVCNTR03_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR0_EL0(2),    HAFGRTR, AMEVCNTR02_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR0_EL0(1),    HAFGRTR, AMEVCNTR01_EL0, 1),
> +       SR_FGT(SYS_AMEVCNTR0_EL0(0),    HAFGRTR, AMEVCNTR00_EL0, 1),
>  };
>
>  static union trap_config get_trap_config(u32 sysreg)
> @@ -1909,6 +1953,10 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>                         val =3D sanitised_sys_reg(vcpu, HDFGWTR_EL2);
>                 break;
>
> +       case HAFGRTR_GROUP:
> +               val =3D sanitised_sys_reg(vcpu, HAFGRTR_EL2);
> +               break;
> +
>         case HFGITR_GROUP:
>                 val =3D sanitised_sys_reg(vcpu, HFGITR_EL2);
>                 switch (tc.fgf) {
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp=
/include/hyp/switch.h
> index 7b4909dfd1f5..22f3b916f60c 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -156,6 +156,17 @@ static inline void __activate_traps_hfgxtr(struct kv=
m_vcpu *vcpu)
>
>         write_sysreg_s(r_val, SYS_HDFGRTR_EL2);
>         write_sysreg_s(w_val, SYS_HDFGWTR_EL2);
> +
> +       ctxt_sys_reg(hctxt, HAFGRTR_EL2) =3D read_sysreg_s(SYS_HAFGRTR_EL=
2);
> +
> +       r_clr =3D r_set =3D 0;
> +       compute_clr_set(vcpu, HAFGRTR_EL2, r_clr, r_set);
> +
> +       r_val =3D __HAFGRTR_EL2_nMASK;
> +       r_val |=3D r_set;
> +       r_val &=3D ~r_clr;
> +
> +       write_sysreg_s(r_val, SYS_HAFGRTR_EL2);
>  }
>
>  static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
> @@ -174,6 +185,7 @@ static inline void __deactivate_traps_hfgxtr(struct k=
vm_vcpu *vcpu)
>         write_sysreg_s(ctxt_sys_reg(hctxt, HFGITR_EL2), SYS_HFGITR_EL2);
>         write_sysreg_s(ctxt_sys_reg(hctxt, HDFGRTR_EL2), SYS_HDFGRTR_EL2)=
;
>         write_sysreg_s(ctxt_sys_reg(hctxt, HDFGWTR_EL2), SYS_HDFGWTR_EL2)=
;
> +       write_sysreg_s(ctxt_sys_reg(hctxt, HAFGRTR_EL2), SYS_HAFGRTR_EL2)=
;
>  }
>
>  static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 4735e1b37fb3..8bb297a2df38 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2532,6 +2532,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>         { SYS_DESC(SYS_DACR32_EL2), trap_undef, reset_unknown, DACR32_EL2=
 },
>         EL2_REG(HDFGRTR_EL2, access_rw, reset_val, 0),
>         EL2_REG(HDFGWTR_EL2, access_rw, reset_val, 0),
> +       EL2_REG(HAFGRTR_EL2, access_rw, reset_val, 0),
>         EL2_REG(SPSR_EL2, access_rw, reset_val, 0),
>         EL2_REG(ELR_EL2, access_rw, reset_val, 0),
>         { SYS_DESC(SYS_SP_EL1), access_sp_el1},
> --
> 2.43.0.472.g3155946c3a-goog
>
