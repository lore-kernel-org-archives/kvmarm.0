Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453831A36A7
	for <kvmarm@lists.linux.dev>; Wed,  5 Jun 2024 12:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717589036; cv=none; b=F+8WdUN6GQD3p8W/qMLnJl+5MyEM5JZp22n7WnCt1ix9qwAUfDTCfr3Y22EBDJJkS7Oq2I9dkFTaofl3i0JjgrNpMDiF+TxNJ8pi1u7kV86xLeuci4JyVSjEat6zkGEcA0h2xgaWwtPC6pKS8A9njcOsMbEkTRcOHkgAHy05kHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717589036; c=relaxed/simple;
	bh=6XXxWiOiR+u276GHgRQbO10d9sLX/iCBmrOC3KZAeNQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gjmqkPMmkjtDoUh4/n6LXfnoWty+pOB7BgtJ+7QBWwdd4uB/qpMy3fQjwjRLdsp4yEcsyoFgJnkTmKYqcrrFgI1CTOjavGk/2sl8HZN4qeBd4EKFqSyKvaja28uPzQi54OTL28XjWpazz/PLxLODr4f9GOH3tO/+EtHkEjqw4aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KZlpAIqn; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KZlpAIqn"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6f264d5dadaso4055707a34.0
        for <kvmarm@lists.linux.dev>; Wed, 05 Jun 2024 05:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717589034; x=1718193834; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sfU5RvgXa6noLSObezkjdqjtTZtf5TE3PhxYWpHDRm8=;
        b=KZlpAIqnE/9t+jXCsb1qSpNBJxEOKrVOJ1xkJNJd8rN7yK66jFQ658+tDxK4+fJaAz
         //b7xGZ2PCmJArIsxK1KS2dZ3eNFvAwXxPxhzbLD9yicqBA1EdZ1uVxPvqrQqt4691Jm
         554x47CSDJCRdAmxUKSLV7pv71nPRX5Crjsl19998+KR6jcG3FiPVWtNZo2tXeR19gYw
         PVkHJv2+HttlQpWDbZxKmWZ9FULWU9RLt3MIY6bggCF18ABS4TUODexH0O2eaf4WUn4n
         wOFWZ/muXaiJhISFRBLZ6B4LCjM9y9hcSS6qJCUsZrtqZbMoNtUkRy9uBx4WaPH0XKwA
         JSCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717589034; x=1718193834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sfU5RvgXa6noLSObezkjdqjtTZtf5TE3PhxYWpHDRm8=;
        b=NzCLYt65x5zjQsVvbCYSTO2L+QPBT/vSF4zmNvHtpREbNVmzjLjlEQAKFl3Pov0WAI
         FzM+r8Nl85z+Lfuu+I8199TpsrTVGlE0CzpLRF8EFqBY8ERkaDHI5k93XCbwtKocXSp6
         zdJCdfi7HjjBF4q24jTwTkN0CnUNLof4FuJyHKeKr4HlkBmdbg2F3PB2sUXAlHi15BtF
         DrYXHsi9sOBoLr5HV2KNnO3W6llQtX3cMh7SpLoQp9pMeYRiikXPPoigX00prrzdwSE7
         9aP9o6PTuUfaRZOfktwRlWrxCtl+IlQbkJQjNZ9t3vNx0F0XdxVuBPeLVvP9Kz0FfEhP
         9hrA==
X-Forwarded-Encrypted: i=1; AJvYcCWLqX064BcN3Jd6JKKTzy5l/oVeF0bbYV8lbawrFXc9QltmJb4DbUjlkNfMRC5yGw+Nl+w/h9L5a71Qef/FuThF2Z38NRp1
X-Gm-Message-State: AOJu0YwMaCrBE4Q3qHk+oxdYHsJBnkJTjp8X6j5xCzVNZ3wRpsefTpII
	S9eOJGGX9Beq2J87/VkDi14RWBsTzLjnHz9LvjJ+UAguNG19Pes0ixj3En2SI3Lob9rxUbd0QrZ
	3FJgnUr4GUqjO/hcHbo1oFBCQMjx03ESMDAHS
X-Google-Smtp-Source: AGHT+IGgQiXZFEiixSSa68R2r8TivxLrnDReyAP/jHo+afBsrwWUzmjR3j17eq7K/ZdRWmJht89jR/C+XRFa0Bp4FFA=
X-Received: by 2002:a05:6808:3081:b0:3d1:fe2e:f896 with SMTP id
 5614622812f47-3d20429b7eemr2770398b6e.16.1717589033342; Wed, 05 Jun 2024
 05:03:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-0-680d6b43b4c1@kernel.org> <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-2-680d6b43b4c1@kernel.org>
In-Reply-To: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-2-680d6b43b4c1@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 5 Jun 2024 13:03:16 +0100
Message-ID: <CA+EHjTyGWu-5JQjhit310VY8fOeVZ1Ht7cbfYoF-AUi0yEDJYA@mail.gmail.com>
Subject: Re: [PATCH 2/4] arm64/fpsimd: Discover maximum vector length
 implemented by any CPU
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Wed, Jun 5, 2024 at 12:50=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
>
> When discovering the vector lengths for SVE and SME we do not currently
> record the maximum VL supported on any individual CPU.  This is expected
> to be the same for all CPUs but the architecture allows asymmetry, if we
> do encounter an asymmetric system then some CPUs may support VLs higher
> than the maximum Linux will use.  Since the pKVM hypervisor needs to
> support saving and restoring anything the host can physically set it
> needs to know the maximum value any CPU could have, add support for
> enumerating it and validation for late CPUs.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimd.h | 13 +++++++++++++
>  arch/arm64/kernel/fpsimd.c      | 26 +++++++++++++++++++++++++-
>  2 files changed, 38 insertions(+), 1 deletion(-)

Actually, I was working on fixing it and was about to send this, which
I think might be a bit simpler than what you have. Let me know what
you think and I'll send it as a proper patch if you agree:

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsim=
d.h
index bc69ac368d73..8bde13b7faa3 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -184,6 +184,9 @@ struct vl_info {
        int max_vl;
        int max_virtualisable_vl;

+       /* The maximum vl encountered for any cpu in the system. */
+       int max_system_vl;
+
        /*
         * Set of available vector lengths,
         * where length vq encoded as bit __vq_to_bit(vq):
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 82e8a6017382..e0af4c3c9a40 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1006,7 +1006,7 @@ int sme_get_current_vl(void)
 static void vec_probe_vqs(struct vl_info *info,
                          DECLARE_BITMAP(map, SVE_VQ_MAX))
 {
-       unsigned int vq, vl;
+       unsigned int vq, vl, max_vl =3D 0;

        bitmap_zero(map, SVE_VQ_MAX);

@@ -1031,7 +1031,12 @@ static void vec_probe_vqs(struct vl_info *info,

                vq =3D sve_vq_from_vl(vl); /* skip intervening lengths */
                set_bit(__vq_to_bit(vq), map);
+
+               if (!max_vl)
+                       max_vl =3D vl;
        }
+
+       info->max_system_vl =3D max((int) max_vl, info->max_system_vl);
 }

 /*
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 3fc8ca164dbe..9f751cce8081 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -52,7 +52,7 @@ int __init kvm_arm_init_sve(void)
 {
        if (system_supports_sve()) {
                kvm_sve_max_vl =3D sve_max_virtualisable_vl();
-               kvm_host_sve_max_vl =3D sve_max_vl();
+               kvm_host_sve_max_vl =3D vl_info[ARM64_VEC_SVE].max_system_v=
l;
                kvm_nvhe_sym(kvm_host_sve_max_vl) =3D kvm_host_sve_max_vl;

                /*
