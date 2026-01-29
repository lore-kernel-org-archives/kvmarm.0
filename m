Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D311A28934F
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 16:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769704782; cv=none; b=dM1qLQCetJLCpOjEkBpPpfKrYRIZt135fpQIISIsfbViJXmKaVnTIJGnaPSLGJXMv4TKCcsOsyWZg91svnqKj8mHpRQG8lHRx7+k3GdFXtcD6QkToiI6inn3Rkh7VdrM+K+dqadxGGq3kv2kGjKMlj1Mtvm3dqZbA4kzAAIRH4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769704782; c=relaxed/simple;
	bh=B/VHJ92gUrkCQ08cznGlZPMEjHU0vpIWoo2Ylnqd+/4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=U8xIM68AF9uk+OoT5PLgtQVdHFRZAcwFGr4a5V2qGOnFQ2EWsc//zMG4d9UHeLWf3iT9pohI2TiteKpI68hkxURdXRGtZ2FR2BVRGsUALEVGR2P2D12dRRdpmtNd0NWUqxCw8cDhhVNLz9Wb1wUZ2JEM/NmLyLhZbOujgSdtRWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ePOWaA4F; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ePOWaA4F"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47fedb7c68dso12486875e9.2
        for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 08:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1769704775; x=1770309575; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=twFvpc0i3TryasBkxK98iJJPXOi65K0zMxpJo29cyB0=;
        b=ePOWaA4FkEkp5GhKrXdK3RRZ1GAYEmtucB3PbRLuv7VhfDVECRsHipbS9HQ8xKbpfF
         /IIeMiBeEgLeJE1uB2CPIW9ey65NyKQ56wpfeF0gOlFddH9uwckmqYat7ZSnvsSp60hA
         tabV2yYTU6c4FJbFQHQDEj/2mHOUl3XNLsAAbAccUDm4qsSYjgWNRGj1VEA5cIl+U564
         cab0QHEyTA28miRh+sZqyp71rv1+Ts3zBdr2yKgj3LDXi/wqtqOgNANmQvFuzzPD5AVA
         XZowW90LtnHieN0sfGc22teM5kQg7wYCasps86M7XIIU8OPFY/MSsPt/h4dDgU4hq4Q4
         /tQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769704775; x=1770309575;
        h=content-transfer-encoding:mime-version:user-agent:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=twFvpc0i3TryasBkxK98iJJPXOi65K0zMxpJo29cyB0=;
        b=dimnQshNS29LGhqn9mIeVX7oSy6diGpKFt7H6sWsz61gCivCQn1n0h99rHbaD2xk7b
         MCvI+V0vfjm9EuhOYXG+mWnGdPuJsHAmiyh1l8E3ByfBeLK8Hwcggk9jJaqVkgpXGboM
         wcGn4HVd7ad2NyMeRDns2xl4ZKiUQcIt4pMWqtQHREDO2b7vvKh3JcvEu2hzCR92+PWX
         ToI1s7erSEdpKvYShp07ZA7rVvVYz39bLWrmrtlpKGhfRu6kkYbNzzPui5HzI4UfEB4p
         9Mj2eDP2dA5v0cM3q1ClpAEf99J/oI0ASyJe2ZMQgNKNTtSpjqFF/Pwxf8gHpIe132z9
         /gMA==
X-Forwarded-Encrypted: i=1; AJvYcCW5Bo+XvAs9BtG3OC+7zkDQeD8Xk8hGdStCRbxDNkz24BM9xMxBtRYOgB3ZDKF9zEgAroh/7oE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxv6wmdHRhQI/Aizo5dkFSId/jf4K7JSussh0SrFZHLEfDXJxm9
	vD08D+pXBuyRT+OeiYRD3IFqWXt1Y5tMnUVETybKU+OiLPl/ejp5CbcvXy/v09W0MP8=
X-Gm-Gg: AZuq6aKh+EH8qqoCRbDWtfuYJV1rrOlN+7a3ILcGZWx3sM5ySMBu1tiEHNej7QUGreD
	KIOSos3lxL55NYeXRp9re5tLFW/m7y3H7Ij2me+2Va6/IRPAMq3sbpG58IPBpe8U5XlCYUxT+xy
	uuGmqUn5HrpL+rD+3YMsYuPh/yQP7H5+u+CT4MbTIpidpnRav0fYjAp9266MPpJ8FVTsJz+7KLI
	LZc4MyOroDaxz+1lIfpbJE0t4vuOqydWXqQTHUuOO1plvHxx0iym9h4Gwg7tKscFuDmrHhuNESo
	bnq6Qg1j3QDPaR5VC4ng0Qpg3Ngej7le31jH/uN59/rn594IUCItE2EPLwS9xNYqbE1kXGufR93
	zF93QHIb9yCsLY0gEfZK5Z5YgvSaH3ZBrB5H9lLX8CFWqJ/IWOtPn0Qte8LGxvYzVoxzxsZKvRn
	0PNWUZIVDFuHQ=
X-Received: by 2002:a05:6000:184e:b0:432:5b81:48b with SMTP id ffacd0b85a97d-435f3ad5c6dmr249217f8f.61.1769704775134;
        Thu, 29 Jan 2026 08:39:35 -0800 (PST)
Received: from draig.lan ([185.124.0.126])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e131cfd4sm14914838f8f.25.2026.01.29.08.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 08:39:34 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id A5D885F878;
	Thu, 29 Jan 2026 16:39:33 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,  Joey Gouly <joey.gouly@arm.com>,
  Catalin Marinas <catalin.marinas@arm.com>,  Suzuki K Poulose
 <suzuki.poulose@arm.com>,  Will Deacon <will@kernel.org>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Jonathan Corbet <corbet@lwn.net>,  Shuah Khan
 <shuah@kernel.org>,  Oliver Upton <oupton@kernel.org>,  Dave Martin
 <Dave.Martin@arm.com>,  Fuad Tabba <tabba@google.com>,  Mark Rutland
 <mark.rutland@arm.com>,  Ben Horgan <ben.horgan@arm.com>,
  linux-arm-kernel@lists.infradead.org,  kvmarm@lists.linux.dev,
  linux-kernel@vger.kernel.org,  kvm@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-kselftest@vger.kernel.org,  Peter
 Maydell <peter.maydell@linaro.org>,  Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v9 04/30] arm64/fpsimd: Check enable bit for FA64 when
 saving EFI state
In-Reply-To: <20251223-kvm-arm64-sme-v9-4-8be3867cb883@kernel.org> (Mark
	Brown's message of "Tue, 23 Dec 2025 01:20:58 +0000")
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
	<20251223-kvm-arm64-sme-v9-4-8be3867cb883@kernel.org>
Date: Thu, 29 Jan 2026 16:39:33 +0000
Message-ID: <87343o8jay.fsf@draig.linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mark Brown <broonie@kernel.org> writes:

> Currently when deciding if we need to save FFR when in streaming mode pri=
or
> to EFI calls we check if FA64 is supported by the system. Since KVM guest
> support will mean that FA64 might be enabled and disabled at runtime swit=
ch
> to checking if traps for FA64 are enabled in SMCR_EL1 instead.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kernel/fpsimd.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 887fce177c92..f4e8cee00198 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -1948,6 +1948,11 @@ static bool efi_sm_state;
>   * either doing something wrong or you need to propose some refactoring.
>   */
>=20=20
> +static bool fa64_enabled(void)
> +{
> +	return read_sysreg_s(SYS_SMCR_EL1) & SMCR_ELx_FA64;
> +}
> +
>  /*
>   * __efi_fpsimd_begin(): prepare FPSIMD for making an EFI runtime servic=
es call
>   */
> @@ -1980,7 +1985,7 @@ void __efi_fpsimd_begin(void)
>  				 * Unless we have FA64 FFR does not
>  				 * exist in streaming mode.
>  				 */
> -				if (!system_supports_fa64())
> +				if (!fa64_enabled())
>  					ffr =3D !(svcr & SVCR_SM_MASK);
>  			}
>=20=20
> @@ -2028,7 +2033,7 @@ void __efi_fpsimd_end(void)
>  					 * Unless we have FA64 FFR does not
>  					 * exist in streaming mode.
>  					 */
> -					if (!system_supports_fa64())
> +					if (!fa64_enabled())
>  						ffr =3D false;
>  				}
>  			}

This is conflicting with the now merged 63de2b3859ba1 (arm64/efi: Remove
unneeded SVE/SME fallback preserve/store handling) so I think this patch
can now be dropped?

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro
