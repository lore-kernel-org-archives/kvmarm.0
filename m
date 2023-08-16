Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE9A389
	for <kvmarm@lists.linux.dev>; Wed, 16 Aug 2023 00:18:02 +0000 (UTC)
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-4fe82ac3ab4so8935451e87.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 17:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692145080; x=1692749880;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wxsVtxBsz7ZNtnDwLhhwnSt+LGT+C0m0E563LOEZPKk=;
        b=WtzBhpDqdhUBNm5VH13yzUSiSHI0N9XrI5mWChHlQ9n/DkgpIAyeAYSEowCeuvXfx7
         8qiQfz9LYegTG08yqNKqho0DqARpZsxeWCxAPNmrlo5m/AYXVE0T967xlS716jqZWkWw
         u5xSych/CU/3n7wkdlQhmzVy+1ID9r29uuc9LDRW0m1LuN/HbAbP0Wl/sNWTFPftvReC
         asRBYFYjYQJI27G0lXXyq98Y/1r8iNWE6CzvvVuUjhwnEgSuNJjWs9GQI8mcqOdQPzz+
         +GumoDw5VkYNIXijh8aMhHLN6iT85P8vmGO52lfaa7eX8rxBEKRMeI/tja1CiijHuxjV
         U9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692145080; x=1692749880;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wxsVtxBsz7ZNtnDwLhhwnSt+LGT+C0m0E563LOEZPKk=;
        b=bg5bU2Ya9VtUtrkkAv3T+TuBzXVCYHdC48HA6zJZyh+SVJeBe/0LZ8Tw0pL4RB9jmE
         RwQkYoCYW7FVoAi21YfqrC6QKFCdDBUkUpMruuQ7bVY94ltyKenuDsTnJLmthKMO7XOY
         0J39kaBxUAwQaYAd2G+8BLOhgKjw7N1LyQafeUmxjXLeZmZEuieL2Ox4WEH7uyhoclzy
         mgDWV2ehrtrt0q8HO+kv633+u6+e8MSNm96z0tiFiueZqMGT1NDXppSOC4af+uFQxtVa
         AKtDaiWV0MfLPP6H5V9iNCfyenyLwBq1FWyVGLxru7ccQE/UP1XaCrRKc5G6LS5N5Iz2
         +90A==
X-Gm-Message-State: AOJu0YxAbP+VoVuTfNjugrGKzVdqz1LAlY9+tGMpJas+bxWcH2rs10Ez
	LZhcfiGmBPdPtL7MgA5idU4dFFCLcMXwjyhgaKpRtw==
X-Google-Smtp-Source: AGHT+IF12jnPwdWfNDlBt25Ulla0zbJGJNh6+KSwv6ddCheINsAa1uFX3+jNn5WBCCn41kPZZ5e/4Qs4Ymb7s1FhcQ8=
X-Received: by 2002:a2e:9c99:0:b0:2b6:e618:b593 with SMTP id
 x25-20020a2e9c99000000b002b6e618b593mr242669lji.31.1692145080284; Tue, 15 Aug
 2023 17:18:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-28-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-28-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 15 Aug 2023 17:17:47 -0700
Message-ID: <CAAdAUth98bjh_tyB0BT+dJnrxF7o7WVNddUZRDrkPmEZGOL=UA@mail.gmail.com>
Subject: Re: [PATCH v4 27/28] KVM: arm64: Move HCRX_EL2 switch to load/put on
 VHE systems
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
> Although the nVHE behaviour requires HCRX_EL2 to be switched
> on each switch between host and guest, there is nothing in
> this register that would affect a VHE host.
>
> It is thus possible to save/restore this register on load/put
> on VHE systems, avoiding unnecessary sysreg access on the hot
> path. Additionally, it avoids unnecessary traps when running
> with NV.
>
> To achieve this, simply move the read/writes to the *_common()
> helpers, which are called on load/put on VHE, and more eagerly
> on nVHE.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp=
/include/hyp/switch.h
> index a4750070563f..060c5a0409e5 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -197,6 +197,9 @@ static inline void __activate_traps_common(struct kvm=
_vcpu *vcpu)
>         vcpu->arch.mdcr_el2_host =3D read_sysreg(mdcr_el2);
>         write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>
> +       if (cpus_have_final_cap(ARM64_HAS_HCX))
> +               write_sysreg_s(HCRX_GUEST_FLAGS, SYS_HCRX_EL2);
> +
>         __activate_traps_hfgxtr(vcpu);
>  }
>
> @@ -213,6 +216,9 @@ static inline void __deactivate_traps_common(struct k=
vm_vcpu *vcpu)
>                 vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
>         }
>
> +       if (cpus_have_final_cap(ARM64_HAS_HCX))
> +               write_sysreg_s(HCRX_HOST_FLAGS, SYS_HCRX_EL2);
> +
>         __deactivate_traps_hfgxtr(vcpu);
>  }
>
> @@ -227,9 +233,6 @@ static inline void ___activate_traps(struct kvm_vcpu =
*vcpu)
>
>         if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
>                 write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
> -
> -       if (cpus_have_final_cap(ARM64_HAS_HCX))
> -               write_sysreg_s(HCRX_GUEST_FLAGS, SYS_HCRX_EL2);
>  }
>
>  static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
> @@ -244,9 +247,6 @@ static inline void ___deactivate_traps(struct kvm_vcp=
u *vcpu)
>                 vcpu->arch.hcr_el2 &=3D ~HCR_VSE;
>                 vcpu->arch.hcr_el2 |=3D read_sysreg(hcr_el2) & HCR_VSE;
>         }
> -
> -       if (cpus_have_final_cap(ARM64_HAS_HCX))
> -               write_sysreg_s(HCRX_HOST_FLAGS, SYS_HCRX_EL2);
>  }
>
>  static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
> --
> 2.34.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
