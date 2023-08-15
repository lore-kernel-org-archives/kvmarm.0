Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198F717AD9
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 23:28:54 +0000 (UTC)
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2b9b5ee9c5aso93135651fa.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 16:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692142133; x=1692746933;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tdNRv3vafCuyDrqB+n8+gIjJewhkzMEcQknvKyMzHps=;
        b=Cv33u7OxmWIF91fZgxdk2/XjKLfXMlPd6pER6F5YS14+3WQBgXzDxNzWthVLuq37zo
         Tijtw4BisAnREscZqugPZSfUFN9DVLaQe/6xsjkG+nLFl6wT7eF+2QC3aczlhWTrsWRc
         0eYO3QPGA0/lB2GZRx3VBtTNCaJX2nb25nnyF4p1MRxkRoiQ/EGxI6n3DP1MYHVrHgap
         xJtA6+pEbyVoGWlIaP87FfUVGTb44dsFrcZyYW4vtLGVeJMgNPcxmbrQNXjjrBXZBD/v
         sRzcTNbiVB4a1uQVRR/Bw0Hys4ppEk748VM5xb95VRSLRY3MFVPsLk8dJakRg/wW2Bds
         fTqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692142133; x=1692746933;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tdNRv3vafCuyDrqB+n8+gIjJewhkzMEcQknvKyMzHps=;
        b=EfVHZ3vu4Bp3AuRFMWBP7NSwfKjdhE4MWIlHXWuJfdoL3Pp0Rf2Q8VGUUq8YAUAXiE
         jL2RiRAp2i/wPwG9TRQhtC0WBdYnY2Aw5Qe8ZfoCtIQaNndnI2df3H5d3KIRbQKpNJzD
         9nPaN3ReRDePAiQqTzn1kr9sAPjBazPcAX97zhkqYJY/02ngNdPmLVaH6meg9yZhtAiV
         x88sgUa/qDwalhfKqwALFnleGx4FgR7iSwqu2onWz8MdtoQH6XSRAkabWk638bmhaH+s
         cLZmTlqmWAwAmqyftySniNQEibXzS0Hler+d+YEeCHMspyVbut8MVk2Vh/vv0HsfvcsF
         c85g==
X-Gm-Message-State: AOJu0Yx1llv4ueMc15eegl2X2+TWLQWuA8jyrfDEw/NzGUfHvqAGBphl
	G/uvT+GZJiHtHbJCIi1BI2MMNDOUyI0kjbNr2QCZBg==
X-Google-Smtp-Source: AGHT+IG8dMxkf/NsuhkaETZ1xc2m6q3/iV8JR4cGiRVhUhuHwBcqzPEkWxrcRQxEmIroRBttAL8DlU/uJCR1spu0Uz8=
X-Received: by 2002:a2e:241a:0:b0:2b9:df53:4c2a with SMTP id
 k26-20020a2e241a000000b002b9df534c2amr183575ljk.20.1692142132865; Tue, 15 Aug
 2023 16:28:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-25-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-25-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 15 Aug 2023 16:28:40 -0700
Message-ID: <CAAdAUtjNVK8fPtCW0b6QV94fNeDYn1V+o+RR0dSN_eWibN7BnQ@mail.gmail.com>
Subject: Re: [PATCH v4 24/28] KVM: arm64: nv: Expand ERET trap forwarding to
 handle FGT
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
> We already handle ERET being trapped from a L1 guest in hyp context.
> However, with FGT, we can also have ERET being trapped from L2, and
> this needs to be reinjected into L1.
>
> Add the required exception routing.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/handle_exit.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 3b86d534b995..617ae6dea5d5 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -222,7 +222,22 @@ static int kvm_handle_eret(struct kvm_vcpu *vcpu)
>         if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_ERET_ISS_ERET)
>                 return kvm_handle_ptrauth(vcpu);
>
> -       kvm_emulate_nested_eret(vcpu);
> +       /*
> +        * If we got here, two possibilities:
> +        *
> +        * - the guest is in EL2, and we need to fully emulate ERET
> +        *
> +        * - the guest is in EL1, and we need to reinject the
> +         *   exception into the L1 hypervisor.
> +        *
> +        * If KVM ever traps ERET for its own use, we'll have to
> +        * revisit this.
> +        */
> +       if (is_hyp_ctxt(vcpu))
> +               kvm_emulate_nested_eret(vcpu);
> +       else
> +               kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +
>         return 1;
>  }
>
> --
> 2.34.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
