Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8692E1FFC48
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 19:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767813934; cv=pass; b=aCr6Y10f5JMau8S9CacEKKVln7dy/w0QKhhv3Tuxl5YB09UYJnZcCzSPCGsKmb+LDLE11QsnzBenEw6WAabzoU71d50n6vmip5bgUaKoGQIOKaHiQOJBLQ29Qou8Zy0FPvKcHuZGf17fwy7ie/aQqB9hpGfX6DLy60WOJpHX9O4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767813934; c=relaxed/simple;
	bh=z8fphxS7A/1Qur4z0EwbQJFYY7ZrGXkIomdruCTWhiw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RwqfHWtmEfQ3w3J1Ah+07ilbGcRHbCMjiujF3OJk57VFtqVW6AkPjONSzsqPhStJH9ojEh3cfKK1Gre878gSrlA+R7mlQAj3gYnJfx+CUQ2YCnpXX6QJA/0los8COEAmhRMASAqx4q5W9B3iqDa+ckm+LGj5o8O5mNCR+JWeZNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TAZRJnhu; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TAZRJnhu"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ee147baf7bso575631cf.1
        for <kvmarm@lists.linux.dev>; Wed, 07 Jan 2026 11:25:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767813930; cv=none;
        d=google.com; s=arc-20240605;
        b=F0fqmXieGyFaQBeUkjvPy4PJF2wEvdhSkF/34VGqNPtf8jzbWW3VRlP5IC5DSsOZGn
         nl3rJzzSX0ePKFwvccaZJWBQ6DPGqPDw5BxTN5MdBXFatiNVLIDz9nwMjtrGcDVXhizu
         A7iof2S19oa5u4hnhgA03Op2MeFsNYDXcGYuyp6FHOX/jzK2VaYuoVGLsDE+k40OKCuP
         M3OLPFkEiYvQzwTCIxsmJFDsGxcUqo7lMxyw0R6Se3iPb6z/MXNe27WlfPBvadwv4MYC
         m5qANOvr2bFJyWOtDvN2pHrVrq3wr938JFw4HJJf5OsSiQxZe5yJTkBvvEqN+KJaxAoV
         Kwqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=sdQze0tFMfdCcZRE+Fz1xsHkvoih7BkzLiCp0crO/Bc=;
        fh=tBCQ4llejgucIwwMOnuECiFavjLRcsvz9PlFV5XfMzY=;
        b=Ewax6O/xaoIzer2vM0lHdhjl6MStfT8CN9Dr9fbKEMh53AGXd79W51iePf6xcjesSU
         7TTYoqfXJ5B7+A4ubRZTKJJbwrMIi8zZGEgI4jQRr+/oXtZrKkKeXxz6orfmlsDwCxQ+
         rZyHriI6YfkZXLYIutnQmuAw7w+fQcWcqSAGr6jfyyUdOP2D2lbvZDkcmbvQktBSJUaC
         OmceQwvPN0RPjQPOIptwCLXN9goq2TrCAhOAFLWHl7y8CM76YJaEi19UsL+f4Vf7X5py
         kkb6xXtnHesgWMcclcP16NGaoempjZqXHjdlUBeSRcE8KC4DisfVtlzpofM5fKbyF4QO
         eCtQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767813930; x=1768418730; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sdQze0tFMfdCcZRE+Fz1xsHkvoih7BkzLiCp0crO/Bc=;
        b=TAZRJnhusLhxyOOBK8xOcCh9cZtFcMv5OY/NE0IimnmANto2LR14yqgP2sRLZBS7Nr
         riaJTy/IU+GXwWQB2Rl0EfBPSAce+01Z8txcQGScWYe440FV2wc2dELzENMLgpg44ghx
         0dbCSYYpunOTSu1l9UWeS+vUJVU3Bn/lyU9UBVwOGAGnA9/oAXwqq/KTsdWfoQ934kRt
         um9Pc9S0EP32nm0FiEvoODz/D4PO6ocY1biA65wd7Qm0PpyD1mNdXL3uiimUIVVn2QpE
         4eEDNpMV2Ev+khp/8a5GkO/19BNFbqKLlr6/ZEP77ip2xwzTIP44CjYz3Tl2UyVmNrA/
         yhGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767813930; x=1768418730;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sdQze0tFMfdCcZRE+Fz1xsHkvoih7BkzLiCp0crO/Bc=;
        b=CI2VY8oPqFg15NwxtPtR6igXCWLs/tzrIX5Ptp9z/juDlGBDLH2dAaDkLLXzNuXTqD
         QslcufNOt/MKsJKwxhUW1X9YULtmNSE6hdhxtTRj8HA0iOdMyJ1HQ3++6buNx8FGTNeA
         pf7/5mQRXLlr6O+MBb7FudAACsxqUu4TiedfD1mukPkADtcKn0xKkV9GSVyz4T7MH++m
         djwvSSigYxNEJGFNRPYJDFgroMTYj4jIhWpaj29Ej2Fa3LNERLy2acmlbYdSOgLr17EM
         GJmrQvYHKfOh+DSHizfzDHLtd8sLCjgYu3NXN2Z1osArP9wNulGVQZ+sLUN5rL75J1B7
         xA1A==
X-Forwarded-Encrypted: i=1; AJvYcCXEg5FRGCC9AuSjNFhi5MMn8F38RJj+eSeZu1do8oVuSu194cO9Jwy2XuxR6G/dZMEJaLBQh3M=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/iaVUrx4qs/kz9fvZ2a3gRIwm1WhCMPG4/WHtWUsgCYDa2T7x
	MkjSCu0vRNxJQYv3aRmIIfKWYYlMt/SwV7OrQSGFmOpNbCUAv+GNJKtHaTeJk9Co4c/gE9J4CX4
	/HO+y0cXGbQZVa06eKkaEOTDIyet3Iq5KiDHoyx0Z
X-Gm-Gg: AY/fxX4zM8NzoCohykz3Mfbz21qwAzL0KgSaaGDcYYKdbaIj30dPlQWPPn4sfZWJMA1
	wh3CvqROVjC97C0kB/yHIgyuMrToFr+fJI7xILD1UR9dXmhaGl0ZrW9ABFvAE7/NCFSYhkIpvAY
	3JYzPOuzeLFa4qPEa/7/qjqlTZlKLd+8+NE2XVEaQ/39V7gJcpaYFPDx5+IVG1YkCwxdYDmc0zE
	NQZc53aUR0vHw+3U8vM2dY+JTlgkkgEtd1DEZPLBrusRgyE2qdgZ0CMFhxlP6qaC32UezDY
X-Received: by 2002:a05:622a:5cc:b0:4ff:7d0c:c1cf with SMTP id
 d75a77b69052e-4ffb3aa6b6bmr15709851cf.0.1767813929956; Wed, 07 Jan 2026
 11:25:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-1-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-1-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 7 Jan 2026 19:24:52 +0000
X-Gm-Features: AQt7F2osm9O_NLuokFKY_-m1ya4_XJF8FlJHLjM1yNQTzxjP3vc84G0MiN9eNTY
Message-ID: <CA+EHjTwsX9+3XZBZo8PHvaP24fVxBKSdg_raJGL46nX5hE-4rA@mail.gmail.com>
Subject: Re: [PATCH v9 01/30] arm64/sysreg: Update SMIDR_EL1 to DDI0601 2025-06
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

On Tue, 23 Dec 2025 at 01:21, Mark Brown <broonie@kernel.org> wrote:
>
> Update the definiton of SMIDR_EL1 in the sysreg definition to reflect the

nit: definiton->definition

> information in DD0601 2025-06. This includes somewhat more generic ways of
> describing the sharing of SMCUs, more information on supported priorities
> and provides additional resolution for describing affinity groups.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

It matches the spec.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> ---
>  arch/arm64/tools/sysreg | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 8921b51866d6..6bf143bfe57c 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -3660,11 +3660,15 @@ Field   3:0     BS
>  EndSysreg
>
>  Sysreg SMIDR_EL1       3       1       0       0       6
> -Res0   63:32
> +Res0   63:60
> +Field  59:56   NSMC
> +Field  55:52   HIP
> +Field  51:32   AFFINITY2
>  Field  31:24   IMPLEMENTER
>  Field  23:16   REVISION
>  Field  15      SMPS
> -Res0   14:12
> +Field  14:13   SH
> +Res0   12
>  Field  11:0    AFFINITY
>  EndSysreg
>
>
> --
> 2.47.3
>
