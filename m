Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEDB17AD9
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 23:37:52 +0000 (UTC)
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2b9f48b6796so90781341fa.3
        for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 16:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692142671; x=1692747471;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q8/Z8rt+EfsVmOxUyWP+mbbnL7pEZ6nBvIqSNe1Ie/I=;
        b=511hE7xFxwsqH1wGEtJpV29FnrC2vDOCbjMyX3pZdjhQ6jeV1uHayBjBwysM+3Gg5X
         p5YN7jd3O52nTAu2dmpIC1wI2f5CU9G2HE4xd6OOff3v8LfchezbDUnWMaNbXOF/nbQs
         hvnxM9NOFmr+NxqKlXg0rhPzMMDjb3UjhFNoEni1ZzVi2BAeQC7qCBHjpyUyMd04Yn6+
         MRep9SDRgW5IsZX1KUA1HfdQ/13Y3M+h6K6AtJCOyzvNYn+ZJHb9v1COzgVtmEdfszgg
         w9Sw+D4ZC7gqagP3yzwu2SM1lYih9o4HcDY2Tw86u5U9NG2G3RoB7MH9QTPteEidkoKd
         UhUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692142671; x=1692747471;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q8/Z8rt+EfsVmOxUyWP+mbbnL7pEZ6nBvIqSNe1Ie/I=;
        b=VgwFtgYB6Fr8yDNoN1lWdUvhn+gHmGakD4WQjLLwrWVYiL/5zuOCiS3NAfl2DQVPYr
         dUcSAGocfAy6njhr1cXTYwC9nK5jedvqiSFGjfYtpumav6TyZXM9vDOY6wcFDrEyJeri
         XNLzyTbG1mJ/mDFxChZyV4i4dMr25Idld2vkF8ZiFYNZI3m5yshGdWPHGmAANIHEj3Xz
         60tCTJqMf+e+UXF3dThD5YhRcMrrIB4OaZhoFatibY/ZhkpZCjsQH9HNqQQN24np21G8
         g/cyGyRpvq4SIyzPbd7HJ8O23EgD2pmH8ld9j+VM35e9jRG6k7QnwSbgV0q7y9P77Bvz
         fwdg==
X-Gm-Message-State: AOJu0YzyoNTSrfyl+G3e4CGez4pwPeUEt29G3OJ4887j5Wn/+bO6jfVn
	1505nvdOmiW4G9EUnAFaNLzUJ0xamoWm4APk0e3ntA==
X-Google-Smtp-Source: AGHT+IFxr0rejdPhxZuhZIxqY0a6IV1bqNq2o77jjGVN3czLaNIruw4D6qhQMspIFWCLgwdClPX0VZvwMC0XH8dUQQk=
X-Received: by 2002:a2e:300e:0:b0:2b9:6d6e:df5c with SMTP id
 w14-20020a2e300e000000b002b96d6edf5cmr159209ljw.5.1692142670864; Tue, 15 Aug
 2023 16:37:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-26-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-26-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 15 Aug 2023 16:37:38 -0700
Message-ID: <CAAdAUth1M7Y9wpP9WEkS0==y3OJ1NM0=MDjSCQ2XfmOYwmLYsQ@mail.gmail.com>
Subject: Re: [PATCH v4 25/28] KVM: arm64: nv: Add switching support for HFGxTR/HDFGxTR
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Andre Przywara <andre.przywara@arm.com>, 
	Chase Conklin <chase.conklin@arm.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	Darren Hart <darren@os.amperecomputing.com>, Miguel Luis <miguel.luis@oracle.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Tue, Aug 15, 2023 at 11:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Now that we can evaluate the FGT registers, allow them to be merged
> with the hypervisor's own configuration (in the case of HFG{RW}TR_EL2)
> or simply set for HFGITR_EL2, HDGFRTR_EL2 and HDFGWTR_EL2.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 48 +++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp=
/include/hyp/switch.h
> index e096b16e85fd..a4750070563f 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -70,6 +70,13 @@ static inline void __activate_traps_fpsimd32(struct kv=
m_vcpu *vcpu)
>         }
>  }
>
> +#define compute_clr_set(vcpu, reg, clr, set)                           \
> +       do {                                                            \
> +               u64 hfg;                                                \
> +               hfg =3D __vcpu_sys_reg(vcpu, reg) & ~__ ## reg ## _RES0; =
 \
> +               set |=3D hfg & __ ## reg ## _MASK;                       =
 \
> +               clr |=3D ~hfg & __ ## reg ## _nMASK;                     =
 \
> +       } while(0)
>
>
>  static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
> @@ -97,6 +104,10 @@ static inline void __activate_traps_hfgxtr(struct kvm=
_vcpu *vcpu)
>         if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
>                 w_set |=3D HFGxTR_EL2_TCR_EL1_MASK;
>
> +       if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
> +               compute_clr_set(vcpu, HFGRTR_EL2, r_clr, r_set);
> +               compute_clr_set(vcpu, HFGWTR_EL2, w_clr, w_set);
> +       }
>
>         /* The default is not to trap anything but ACCDATA_EL1 */
>         r_val =3D __HFGRTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
> @@ -109,6 +120,38 @@ static inline void __activate_traps_hfgxtr(struct kv=
m_vcpu *vcpu)
>
>         write_sysreg_s(r_val, SYS_HFGRTR_EL2);
>         write_sysreg_s(w_val, SYS_HFGWTR_EL2);
> +
> +       if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
> +               return;
> +
> +       ctxt_sys_reg(hctxt, HFGITR_EL2) =3D read_sysreg_s(SYS_HFGITR_EL2)=
;
> +
> +       r_set =3D r_clr =3D 0;
> +       compute_clr_set(vcpu, HFGITR_EL2, r_clr, r_set);
> +       r_val =3D __HFGITR_EL2_nMASK;
> +       r_val |=3D r_set;
> +       r_val &=3D ~r_clr;
> +
> +       write_sysreg_s(r_val, SYS_HFGITR_EL2);
> +
> +       ctxt_sys_reg(hctxt, HDFGRTR_EL2) =3D read_sysreg_s(SYS_HDFGRTR_EL=
2);
> +       ctxt_sys_reg(hctxt, HDFGWTR_EL2) =3D read_sysreg_s(SYS_HDFGWTR_EL=
2);
> +
> +       r_clr =3D r_set =3D w_clr =3D w_set =3D 0;
> +
> +       compute_clr_set(vcpu, HDFGRTR_EL2, r_clr, r_set);
> +       compute_clr_set(vcpu, HDFGWTR_EL2, w_clr, w_set);
> +
> +       r_val =3D __HDFGRTR_EL2_nMASK;
> +       r_val |=3D r_set;
> +       r_val &=3D ~r_clr;
> +
> +       w_val =3D __HDFGWTR_EL2_nMASK;
> +       w_val |=3D w_set;
> +       w_val &=3D ~w_clr;
> +
> +       write_sysreg_s(r_val, SYS_HDFGRTR_EL2);
> +       write_sysreg_s(w_val, SYS_HDFGWTR_EL2);
>  }
>
>  static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
> @@ -121,7 +164,12 @@ static inline void __deactivate_traps_hfgxtr(struct =
kvm_vcpu *vcpu)
>         write_sysreg_s(ctxt_sys_reg(hctxt, HFGRTR_EL2), SYS_HFGRTR_EL2);
>         write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
>
> +       if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
> +               return;
>
> +       write_sysreg_s(ctxt_sys_reg(hctxt, HFGITR_EL2), SYS_HFGITR_EL2);
> +       write_sysreg_s(ctxt_sys_reg(hctxt, HDFGRTR_EL2), SYS_HDFGRTR_EL2)=
;
> +       write_sysreg_s(ctxt_sys_reg(hctxt, HDFGWTR_EL2), SYS_HDFGWTR_EL2)=
;
>  }
>
>  static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
> --
> 2.34.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
