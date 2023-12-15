Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B642E40A
	for <kvmarm@lists.linux.dev>; Fri, 15 Dec 2023 13:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ubWicI/0"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-77f3c721c38so47930485a.1
        for <kvmarm@lists.linux.dev>; Fri, 15 Dec 2023 05:46:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702647991; x=1703252791; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Au5CVcebn6Vck8JCLxPLVdam9baahWxjR1JXzbH1ObI=;
        b=ubWicI/0hbCW+cJ7jEMEijiL8h1gxs7JPp4GTHWJ072CCjHC9SfoNQw2R9mADQtT5g
         JjjG5vu4guIMlvRdHjms5z7kbnpGMkenJc8jWqHLMo7pEJ47xI2qKMqI5GQEfYSnncGx
         aar4UubCf8Op41Q0QE/hsDlGa/Q2EJTT8yUsYKMe7yLIWE6fdcl6AyI+dedhju10vP3l
         6H/8cU66cu/uVs0OmBfio2C7Q7FJ0qOxGs+pdIn6+jfgLAuoLJuAlQzI8QRjfmHHKUbf
         EshtI+0g4dctNrOnxby9ctMSMuog11opopbxZozQPZNWZ180nbc5qPtZ6ebReu62hiei
         kiLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702647991; x=1703252791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Au5CVcebn6Vck8JCLxPLVdam9baahWxjR1JXzbH1ObI=;
        b=Mz+a4lo5mf769mR+3RhAA8hzJKyMybXhSIobR4MHIGMty4qwHkz5QQh+wmDZWd4E2w
         BaV4lq1mAHlRfiRJW2R0lZKkoLk6UkE726gg0vSWQnnghiml7+7uT7sL+y5xYGmX8AS3
         S2bl5WUEujvUP0Pa2irnQMESxu9FYRQFBbBMapJrbKQqwbwOxFs+nYqZtuSFlhqXL/yt
         FuBNvZYwL5WZhMYcjesE4PdynoZLcAs8W46GBc+r9kpV78GdN3p11Lpe3aTPm7hL2xya
         7fdmikAOu2LcSGM9CdUHZWQDA2BHWoQYUNrUG2k3W5VxsGkK5qF+Y2Y+7sJZP0al0e7b
         Q8/A==
X-Gm-Message-State: AOJu0YwvZIoHEeWrwK5/rBq0JMil5T36JlhoO9IHrRMlhiclexDemwEI
	T3oAJNB63FOYY44uoiNC3V1uSsv9jO0NwYL50Y1oHV6FOXyjqTSMwWcPwGNH
X-Google-Smtp-Source: AGHT+IHckMIooHkOETF5lF7Y0bNjW5UfPrSiTHk/PFAN/KgOn5XjCD7mnoVy4OhjHiU7akGBUvMp/xFGXczN5iFDV44=
X-Received: by 2002:ad4:5ecb:0:b0:67f:b1a:64a with SMTP id jm11-20020ad45ecb000000b0067f0b1a064amr3757015qvb.54.1702647990801;
 Fri, 15 Dec 2023 05:46:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com> <20231214100158.2305400-15-tabba@google.com>
In-Reply-To: <20231214100158.2305400-15-tabba@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 15 Dec 2023 13:45:53 +0000
Message-ID: <CA+EHjTw_728zgVqF6_UraP0CwvmvFH0WiYCbyN-gvNMNk8QMBQ@mail.gmail.com>
Subject: Re: [PATCH v3 14/17] KVM: arm64: Macros for setting/clearing FGT bits
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
> There's a lot of boilerplate code for setting and clearing FGT
> bits when activating guest traps. Refactor it into macros. These
> macros will also be used in future patch series.
>
> No functional change intended.
>
> Signed-off-by: Fuad Tabba <tabba@google.com>

And in relation to my email in "PATCH v3 09/17" [*] on HAFGRTR_EL2
being present only when FEAT_AMUv1 is implemented and FEAT_FGT:

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h
b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 58e450180f68..071d6db299f5 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -174,7 +174,9 @@ static inline void __activate_traps_hfgxtr(struct
kvm_vcpu *vcpu)
        update_fgt_traps(HFGITR_EL2);
        update_fgt_traps(HDFGRTR_EL2);
        update_fgt_traps(HDFGWTR_EL2);
-       update_fgt_traps(HAFGRTR_EL2);
+
+       if (cpu_has_amu())
+               update_fgt_traps(HAFGRTR_EL2);
 }

 static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)

* https://lore.kernel.org/all/CA+EHjTwrcXjOdo7JG-6fr0YpDq2EtMoTQxngq5H-ELLd=
jyQG=3DA@mail.gmail.com/

Cheers,
/fuad





> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 60 +++++++++----------------
>  1 file changed, 21 insertions(+), 39 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp=
/include/hyp/switch.h
> index 17ce40f5b006..e223fc0d5193 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -79,6 +79,23 @@ static inline void __activate_traps_fpsimd32(struct kv=
m_vcpu *vcpu)
>                 clr |=3D ~hfg & __ ## reg ## _nMASK;                     =
 \
>         } while(0)
>
> +#define update_fgt_traps_cs(reg, clr, set)                             \
> +       do {                                                            \
> +               struct kvm_cpu_context *hctxt =3D                        =
 \
> +                       &this_cpu_ptr(&kvm_host_data)->host_ctxt;       \
> +               u64 val, c =3D 0, s =3D 0;                               =
   \
> +                                                                       \
> +               ctxt_sys_reg(hctxt, reg) =3D read_sysreg_s(SYS_ ## reg); =
 \
> +               compute_clr_set(vcpu, reg, c, s);                       \
> +               val =3D __ ## reg ## _nMASK;                             =
 \
> +               val |=3D (s | set);                                      =
 \
> +               val &=3D ~(c | clr);                                     =
 \
> +               write_sysreg_s(val, SYS_ ## reg);                       \
> +       } while(0)
> +
> +#define update_fgt_traps(reg)                                          \
> +       update_fgt_traps_cs(reg, 0, 0)
> +
>  /*
>   * Validate the fine grain trap masks.
>   * Check that the masks do not overlap and that all bits are accounted f=
or.
> @@ -146,45 +163,10 @@ static inline void __activate_traps_hfgxtr(struct k=
vm_vcpu *vcpu)
>         if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
>                 return;
>
> -       ctxt_sys_reg(hctxt, HFGITR_EL2) =3D read_sysreg_s(SYS_HFGITR_EL2)=
;
> -
> -       r_set =3D r_clr =3D 0;
> -       compute_clr_set(vcpu, HFGITR_EL2, r_clr, r_set);
> -       r_val =3D __HFGITR_EL2_nMASK;
> -       r_val |=3D r_set;
> -       r_val &=3D ~r_clr;
> -
> -       write_sysreg_s(r_val, SYS_HFGITR_EL2);
> -
> -       ctxt_sys_reg(hctxt, HDFGRTR_EL2) =3D read_sysreg_s(SYS_HDFGRTR_EL=
2);
> -       ctxt_sys_reg(hctxt, HDFGWTR_EL2) =3D read_sysreg_s(SYS_HDFGWTR_EL=
2);
> -
> -       r_clr =3D r_set =3D w_clr =3D w_set =3D 0;
> -
> -       compute_clr_set(vcpu, HDFGRTR_EL2, r_clr, r_set);
> -       compute_clr_set(vcpu, HDFGWTR_EL2, w_clr, w_set);
> -
> -       r_val =3D __HDFGRTR_EL2_nMASK;
> -       r_val |=3D r_set;
> -       r_val &=3D ~r_clr;
> -
> -       w_val =3D __HDFGWTR_EL2_nMASK;
> -       w_val |=3D w_set;
> -       w_val &=3D ~w_clr;
> -
> -       write_sysreg_s(r_val, SYS_HDFGRTR_EL2);
> -       write_sysreg_s(w_val, SYS_HDFGWTR_EL2);
> -
> -       ctxt_sys_reg(hctxt, HAFGRTR_EL2) =3D read_sysreg_s(SYS_HAFGRTR_EL=
2);
> -
> -       r_clr =3D r_set =3D 0;
> -       compute_clr_set(vcpu, HAFGRTR_EL2, r_clr, r_set);
> -
> -       r_val =3D __HAFGRTR_EL2_nMASK;
> -       r_val |=3D r_set;
> -       r_val &=3D ~r_clr;
> -
> -       write_sysreg_s(r_val, SYS_HAFGRTR_EL2);
> +       update_fgt_traps(HFGITR_EL2);
> +       update_fgt_traps(HDFGRTR_EL2);
> +       update_fgt_traps(HDFGWTR_EL2);
> +       update_fgt_traps(HAFGRTR_EL2);
>  }
>
>  static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
> --
> 2.43.0.472.g3155946c3a-goog
>
