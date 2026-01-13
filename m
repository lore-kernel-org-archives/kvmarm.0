Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B055E2857CF
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 14:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768315118; cv=pass; b=PmLzOY7QytfOaeAcUM441r/6y7RpfedwZ2SGwoa31yKGISR8ckM2Zx1j5FFa5FaAJUO/pm4KxgRfPnHijJ4h1jdcZ1DBYZQnDB8z3n+Q50FOPNcvOmKuatXdOi6hsdtGGH0BEBMHckXWPT89KBy82HbcmZFShAcjQBW4fc4+Y98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768315118; c=relaxed/simple;
	bh=HCdvS5NkY0vXw8KWKY8kVRjAzF9gX4xS/N5ZGLvpz88=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E7tqU0k5sUcN9DmIAhRxw2LZEqF2lN2tRxNtCtgbwfR41Htm5TQVXnuE2YizGEtcP5cUN6HPnmNst61cHW9x0Fm02H7wIVQNi6quKKCuYtkMeCKg3eRJZkUR9aMXfuXlt8+I+yYWIcJcNyTLiiQVtguTTjgHC2SmCUpaMqke7Rw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FQipA074; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FQipA074"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ffbaaafac4so577801cf.0
        for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 06:38:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768315116; cv=none;
        d=google.com; s=arc-20240605;
        b=CUIAUDkfl6uQnWfdybB4HaknPc1D1We55qJRftPzZeowSuz0eK3TrPYuN4OzfULuo7
         JNBnndxU1qw91avC0avcJuU73Opc5M+NaETCrLKhFXcKTfBXFNtCyEUNq6d/oIGTds9/
         c573VrWsg5Rff1V+EpUSKblwItvjiovVxIpbKV97wGIy/6p0XiuT2jaZb7cqcsmG4cJo
         p1ASTGYt9DKg6FBPg0TiJ7rD1Kc57dXyB5E39ZmxMgwhAnsBywq39vBa1VGoVZJbSSwT
         gELkNMVMDGNW20ksKFWe6goTkEFL11r9yG6GferRiIzLKjr6mKlN0jYK0IPmtJws/FSF
         G9CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=z0SrzDaVUXRmKWRvPdSPBpUEx4WP+XB1ix/xiAgEPgg=;
        fh=wFYarulVRmcLjW4x1lhKMCO/TrLow6YZwtWetJlnB4o=;
        b=Dc6092Ks9mPk1SY/0SsSKAHfVMSKFYprvZvM3JMbKatCmrDX1XzRpEOr6BSs/Uf8Us
         85qvSjNWqOi1kbye1bMbsPnU7reYHTNxxZwbBHpZbH0KmClYtcYkPvAmCmFWxZWjTNhl
         aBlHdhPvbhxbBDFhDf37gbnL5ZTXDeHfoTRhECnzG4OXnZco9Id4iD+x0T6PU94oNi8f
         JDGQl3Zi+5717vVs4N31W0lbhS6hX3lfOnpIWGLTqDBaJQefUmbw3HrQmzV4MUZYTlP0
         yFdSYKFHJT3sdLfna5MUpJv9mZmNK06oLaUBuJkBMg7gHit4BYjODxXuL45o4833YlkG
         tMAA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768315116; x=1768919916; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z0SrzDaVUXRmKWRvPdSPBpUEx4WP+XB1ix/xiAgEPgg=;
        b=FQipA074eaNcPTKkJxEoEynMCmqxdxqV2sVUEU4qdzik5OliusJucSHatdFpKjofpZ
         TDDFM/lPZ5BipjvyO7EuJ205y/B2xWD8G+irSPpPfa9F2r8mqUgzXmsIdlOi2JHkY4al
         jwiiJrdm30dHtjdPhD3OYUD4gKob045GmGZpB7khKZQpphaH5eJv3Jw8L10+RbDpuQL5
         OQ8RgG+TRdK6VV599Js0UDBnJliQGuHa5lxnv4SgZEVPAklnF8me+lwoGcTxNVzxcmnA
         G7/GCCTPSa9f/myMLrgVhNzLkHH9YXYwifH+j8Ze7VzFLsgrk9xJXjBcOPn8ufnEEkBE
         ZgMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768315116; x=1768919916;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z0SrzDaVUXRmKWRvPdSPBpUEx4WP+XB1ix/xiAgEPgg=;
        b=YYHkjuV4wL/kxihVOcy8eAepBam8/lQ2BSIyufFfSq8++Lv2ufZQpSMoFQnmdlXauz
         BEs7yyVpVQONzyxVI1wtLv40TtIGqMvYXTW+M8aSdUEaWr0+bJbUYkvWKVVuV71Cw1k5
         bIfhsXOS9ZCg1tUSh44Gr00Xe/NHiVxnATfYY3OJTf6SAlD/3GZ5H3cGFRCm2BFkedZv
         Mzf1iTgKweR4Wrv4BGQMJ93zS/HwcUKYRwUeNicEqJIWtmDX2sNgrKxPCrTg7/G+g3kD
         WxdoDbMz40fH+R6CTxuQMaABvkR2f17DbqS6sfMTrpctdQgarQLd0Ij5MxGhuAlkwp3a
         qQfQ==
X-Forwarded-Encrypted: i=1; AJvYcCW01DkzRjvO2Gl3PZX9SaoG6HhSz5WS5z/1tUc3GFpYiB5p5HfzQe+z8g0gMa7YvkcZmskLTyc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzwaM44p+LyEPUOBMjnCCNDg4dXcT6vnQg7jCpEihLZ0fNly0fp
	RfsIE3zlLolUqLat42YC27voiUblbZPi0lZo/UxfW4aE9UwoFBwH6GPPPEzdkEsQkMqWS0PkFbl
	zEnSl5zWxmZzsKFLsDmXFZBr3YO2sVnwtXhwRw9Ov
X-Gm-Gg: AY/fxX7UW1+8nOLotFh2M3d5CPxC5ZqrZgmo16Qo4nagNcRSS3WNsFkErOZ1zDlAE2F
	UcbQRGe73vWul1ZiMkPCB2UU5m3ly7hoDgyzslwTQLKRQ+YnoI1XIs5fX9LYqUJ51lMNsTaKqC1
	WvaFjxQW9pVWV/2R8Tq3F/5V62PAnhFXg7C7p+vsl2x/8n+OwTkTbg5BKgqsGv5k6Rtp9p3Vv0p
	y3ztP+j3+tSMnXhsWJQPSqnsO0a5Ma6NNnB4EP05VvZKxwLsZGU+K8PlJnFz4AxGKuwY+u69DDe
	E/AcLhU5Hdqz4QyLyWkW+OAK5A==
X-Received: by 2002:a05:622a:90:b0:501:19ce:5bdd with SMTP id
 d75a77b69052e-5013a21b63dmr4606041cf.6.1768315114958; Tue, 13 Jan 2026
 06:38:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-25-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-25-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 13 Jan 2026 14:37:57 +0000
X-Gm-Features: AZwV_Qi2DCwvCxhy1IBJRUhKVRAZLawBqR0npBrkyjREHFYNX_l_ocigtzC7uIo
Message-ID: <CA+EHjTwZCcMFT6gAM2oaQz5V_vqEBmVuggFBbABbXPvC+U919Q@mail.gmail.com>
Subject: Re: [PATCH v9 25/30] KVM: arm64: Expose SME to nested guests
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Dec 2025 at 01:23, Mark Brown <broonie@kernel.org> wrote:
>
> With support for context switching SME state in place allow access to SME
> in nested guests.
>
> The SME floating point state is handled along with all the other floating
> point state, SME specific floating point exceptions are directed into the
> same handlers as other floating point exceptions with NV specific handling
> for the vector lengths already in place.
>
> TPIDR2_EL0 is context switched along with the other TPIDRs as part of the
> main guest register context switch.
>
> SME priority support is currently masked from all guests including nested
> ones.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index cdeeb8f09e72..a0967ca8c61e 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1534,14 +1534,13 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
>                 break;
>
>         case SYS_ID_AA64PFR1_EL1:
> -               /* Only support BTI, SSBS, CSV2_frac */
> +               /* Only support BTI, SME, SSBS, CSV2_frac */
>                 val &= ~(ID_AA64PFR1_EL1_PFAR           |
>                          ID_AA64PFR1_EL1_MTEX           |
>                          ID_AA64PFR1_EL1_THE            |
>                          ID_AA64PFR1_EL1_GCS            |
>                          ID_AA64PFR1_EL1_MTE_frac       |
>                          ID_AA64PFR1_EL1_NMI            |
> -                        ID_AA64PFR1_EL1_SME            |

Should we also limit this to SME2, i.e.

+ val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64PFR1_EL1, SME, SME2);

That said, we don't do anything similar to SVE, but it might also be
worth doing that there.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>                          ID_AA64PFR1_EL1_RES0           |
>                          ID_AA64PFR1_EL1_MPAM_frac      |
>                          ID_AA64PFR1_EL1_MTE);
>
> --
> 2.47.3
>
