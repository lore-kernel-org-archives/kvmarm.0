Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4560E335BCC
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 19:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767813956; cv=pass; b=F8i4qcbybsl9lE7igKpbt+YcxPJbF573SPsLWRGLu+Pb543Lmn25BGbRC9E625nIxfKWqYId15FmT+oh1weu8CJkLqifzlxiNa8jpjAiKi8zaMIZb1+9UlXahwlFF3vER2EnpyA/Cf/BFvervZVItsTz43neTO77e1E6GaSlyQU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767813956; c=relaxed/simple;
	bh=y8s3ifhfbIRmZEac0G5rIHRfhu/0TKZaV0wEbXVBJlI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q72zNSmamyCszdam99j9bJajXwmpTPMRYP6TKAAgyUfOyIf57l31TX+ETIoDlduqoY+2zD9T3UxluuOLvrd/JNgD+N/61SXMWKmlWxoXUw1gQGh4dgEDKOsLQAA52pvGSWPQp7Vl0EgbAwKAwpL2vqXOMA2ET2jYPyLAsJHiN9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cIsCmC8Q; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cIsCmC8Q"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4edb8d6e98aso720201cf.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Jan 2026 11:25:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767813953; cv=none;
        d=google.com; s=arc-20240605;
        b=a+SceBvF21yZleezm1RSxpdz4Ox4J5DsGAhJtOtgAmTjpI0rrkNSD68LDGkVm/XBq8
         jEnel7vJZ0Jr2Xv0ugLQBAUUELE4bjbjevgQouJhErAAZZqfUI6XkVgWil/sEw8nu2DU
         AZq8i7Mb5Rw3AtUvrKir8XRbxJ8JooU9ZQjWyBVoyNbTCsZKbeDklHmWjUZIMCsmmL7p
         txcKJKO5Ujz5RkwFfDrci4a2WrLD+W2HPa2v+y6/Et38u7tgX+Kynf7r28ePzpFZ6bYz
         Z9C1G50oNGmRoMha+jxK+AJuxjhHSufn1Q0HOBWTA47vIYVo3ojSQrysxvYm3UQBgwhr
         Ax+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=DwyOUMrzmFja205ZMg1MEdCnMMj8lyhbUqchQTaZ7Og=;
        fh=/HiOgFc00fd34zc0MyprXeAbCctsWRaOpshAyMPmkz4=;
        b=MCan9bNIsR/lcRMj//KuwqWDHLvGvoiM0l4t4SJoCuAMVigfNOQpBjKjVvxbC777oj
         EQOA8hBtRaj4mnn75SKLt20y+cU6LnckswaFmK99anoLNNGaKQ/81NNmSg0Hn9uH4LVH
         M+In/CuLDr1e/puWvAEwqZ1jOI7zQj+yhgvrB9DWNhImflTudlSZ3IAn0P4qoMprWUnz
         96R7Wupj+6k1r8HccwjPoczLqKeW29p0mq7/vU7G4JbCN7nho8b2ygUguRNOnX7f+Er/
         ybvAkDjxTLeJ5zt+E8sRoOYu+DHon4eirW9/nlgHYVSlWyB3FuhABM594LHl0pgSobz6
         S36Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767813953; x=1768418753; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DwyOUMrzmFja205ZMg1MEdCnMMj8lyhbUqchQTaZ7Og=;
        b=cIsCmC8QHgrzG4N4KAG37rO98Ot6CUnnuDoHSQ/UF/6Q13fBxG6nWxagmkvxpYFMTZ
         hluQo/qwaj6lo3d5GzKynOnb9wxYwI0xsWqL3zbvBPJh9ky2mYb28ObKnBIAQHpJzHrO
         dANW2z2EE1j0yVaXxOs3kQdICdVxHaPXUQYEmSAZxqVKwJVY0tcwQOojhGajRKyuLi9v
         ehI9w815oX+mNFGa3GwFhNNrfws7ETo1pMsLyBHd77v+h1GBav04lk6l56WV821TpJ3G
         ikVlO7ICD3wHGBfDrrdoo/TUd0Ne7y7mBtXmNirrFJdpMD1S4u6yT3xLk2Psr3TsuO76
         wTdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767813953; x=1768418753;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DwyOUMrzmFja205ZMg1MEdCnMMj8lyhbUqchQTaZ7Og=;
        b=cXUVcjacyttVxJUL7PR3tRstdh0MnoqkH10fITF8eI73lD12Fy69Enqd/+tJIldc1R
         kDVnmq/4vvjmtotNi0lq/jO+mbzq7bXXiMa0GiWw4meh9TZPnoju81BOOh/iUUTJp509
         nAC/C6z7Rn+LIozksPSYYlBUOl4hwTcYcZdAnUnfyE+6oov42o/u27+F+OiK48ExezKF
         9J3YWDaXcwyjQ8XihV7Fr2YrinwF5YSfF500QTuMcE6GsJLB3SEG7/L9BtVGYQo6JGsm
         KixWkDqu1x6EgBnqi0uyVJjeyPnnYGuqfR4UFoX+bFe8qb1mtAh0cbJYIh0pOunsTDhR
         zq8w==
X-Forwarded-Encrypted: i=1; AJvYcCU/sB8nP74XtWkYrOnyooQVk7LJIlwvR+FQMFyzbF28WTW/AT2xOyloSY5kmmbctiNYvnj42eg=@lists.linux.dev
X-Gm-Message-State: AOJu0YywebM3QRGCS97k/8/2U4J937KWegKHujuVH52xSqjB1eMzGpZ4
	yQ9/GZZTd6Xc0pBX6bGt9ou1htqyzGCFdycfq++NCCc9h56UWTTLfNRQkhXQVpgYodDAae97UdT
	1SE1bazG3Exws4A2NVpoGd2NTXE9n8+d999zz2FFB
X-Gm-Gg: AY/fxX4XmVf0ieLIvEwii+2dytpMrWokgpaIXUVaxiDsXrt5wqIkWVauYTqhoXkup0D
	94zgGEgOwYxYYRkHZdMTn438Ri8r002GD5JJ7P1BTG2yfl/oRU+kl45M9KG/G+QapoUC0HAp6zv
	CsBxp4mPDQ+2bpLAR7aBf1IwX0NY4gKyujQ9O8hrIJQTpCv20fr4dbR3YcylAM3iqvJFprbOI5N
	wOqD16InxGxN6x5D9jag3hZjItekxJLViNS5zwOJrbrP4mPWixFo+/LzCE98d38ykDSbCuM/OYO
	Vye2xGA=
X-Received: by 2002:ac8:5e06:0:b0:4f3:5474:3cb9 with SMTP id
 d75a77b69052e-4ffb3e48178mr14762551cf.14.1767813952742; Wed, 07 Jan 2026
 11:25:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-4-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-4-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 7 Jan 2026 19:25:15 +0000
X-Gm-Features: AQt7F2r6YVCRnMI_bYmOfq7HyyiGhMeA9fZkYBf6xbcFUjdNaJYVtQzKKg3T4fA
Message-ID: <CA+EHjTzDxJsLi315RF43g14psdv44YOuxk6dP6SLgFz4WaY4Hw@mail.gmail.com>
Subject: Re: [PATCH v9 04/30] arm64/fpsimd: Check enable bit for FA64 when
 saving EFI state
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
> Currently when deciding if we need to save FFR when in streaming mode prior
> to EFI calls we check if FA64 is supported by the system. Since KVM guest
> support will mean that FA64 might be enabled and disabled at runtime switch
> to checking if traps for FA64 are enabled in SMCR_EL1 instead.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


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
>
> +static bool fa64_enabled(void)
> +{
> +       return read_sysreg_s(SYS_SMCR_EL1) & SMCR_ELx_FA64;
> +}
> +
>  /*
>   * __efi_fpsimd_begin(): prepare FPSIMD for making an EFI runtime services call
>   */
> @@ -1980,7 +1985,7 @@ void __efi_fpsimd_begin(void)
>                                  * Unless we have FA64 FFR does not
>                                  * exist in streaming mode.
>                                  */
> -                               if (!system_supports_fa64())
> +                               if (!fa64_enabled())
>                                         ffr = !(svcr & SVCR_SM_MASK);
>                         }
>
> @@ -2028,7 +2033,7 @@ void __efi_fpsimd_end(void)
>                                          * Unless we have FA64 FFR does not
>                                          * exist in streaming mode.
>                                          */
> -                                       if (!system_supports_fa64())
> +                                       if (!fa64_enabled())
>                                                 ffr = false;
>                                 }
>                         }
>
> --
> 2.47.3
>
