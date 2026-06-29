Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8463F823C
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 08:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782723227; cv=pass; b=OQjMf6+4aKc24MnHhzrdFmzmUgxiCBsmkmj0gXIwUTB7AjgM4J1TYwAg22SppMUVyBsXt7yAz32xNJBr8J3sBF90DNyPFeYjyCWfoTglzFbG9jXLaWA95onWxcIQU9qXslS4BMNBPv1FqsFWm85t34Uyr7GMQynECEgeuxDjAU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782723227; c=relaxed/simple;
	bh=3wsBQ5BeEJgTtidFgbbjOCTde6FZFgO30nCGnSXQTfM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c0XQVB6dEFinLCTYWLyOm1TdAK1vGlneEeBjY5hAjV8Ij+3mHjuVIW8AOggZLlYLooMkFLVZEMQpP8iGv34idf+bHQHG1mJa/v8xdkhIFdqc/MivveBR4nXykdBoEH/57oI8jeCA0GM83JGGR8jBkzvGvJM2lxWU5n14l+yggig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oNVBwUF8; arc=pass smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oNVBwUF8"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-447bb8bb754so2226340fac.1
        for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 01:53:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782723225; cv=none;
        d=google.com; s=arc-20260327;
        b=RFvYHOug6tjGd26iyQHkXvAa6MznmssuMFZE8C5YlSLbX9x8Fxn/zf6qKgQWwwlIB/
         UJEMpfm+SLAA2hFj57Wcx0Z1sXPmJ4J0bWNSqNHJFdYsxiaYCS159krk/4gy0plMiCAq
         HxNfXtjDUjwIhG/7rf82g+bulneBMfOQ4rTd/zm0mMt0sFAyvGbGm70AZbSGxn77fCQp
         KqkNRDorcbBK+BhihnvFMkk+QNCaD7vFR/QlVNrj0CozOX72mBWaz24JHG5vVKPE3brh
         4xo0NSxPldDOA5GuHqTLd2cWkIgLeELk965b+bSVuNoaGhBZbN6wzq8v8TXloGBn3WW9
         BGUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Kom0ZAk0sd+EvCK6HQibq96i7GIy+t3E/vTkY+JP0bw=;
        fh=TzhA8/HJDdvchB2MUms1m6Vv8u5ZgTgj1kVmahaYnoE=;
        b=moOYNK80uqv3/R+y8j0DBdcLLFOv1sDwtikpXQPWsplZrHLvzflz3eM1EelXkXUkpe
         EnL9yAnwE9sRNRze9Bm38lGL06i9rMNO9X7OaJTnCKmcenuFN26AamUMh0vFkZ8kFfUA
         /zIoMnv6qM1U5OCjPd+vge1fZszP3C9czUpVmFTpjR7XFPdNt4svMwbrCrvNm1FzwNlr
         2rR8OJ3RzSuNvpEgxtBPbTgcNZQ/z4QGrjSkPA0YQPAjxE9eY68LSl3qiiVNpuM7KqRn
         6jBkYYOhtkEjCbjm2wT1r/3uuswiwon7h2iFQMiA6zLXJnQgcruWvNITS009jSH8ANWU
         +mIQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1782723225; x=1783328025; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kom0ZAk0sd+EvCK6HQibq96i7GIy+t3E/vTkY+JP0bw=;
        b=oNVBwUF8Cqyk28U5OxCTekZ4NvU26ROsv1Z9k4JhCuJZGG1C52YjPJjWHFNliHn3T4
         JGNxCwgSyuS85ivr6KypI8qf6j02AtkLQuIttPn9yF9IDK9GZixcWDduBM5WSWPQofGn
         3j0CNZ2xyBAwccafxj6A7Tpwxf84uUdmtDjcNIqwPFoK4hUM8QxYR1uIkHAjUXB+dwTZ
         EGsFKDcDzkSEgF3UjRioeDevVUMN+t9iYSuUErd8dhTAENhKnn/mNY6cqWU7YWx+Cv1z
         QUId2s4ntRWS0US+D3zcBqficMnyQpGFTecHrEjgFzn+2m3T4hj0NJORlm6lGE8kzkuI
         y6hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782723225; x=1783328025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Kom0ZAk0sd+EvCK6HQibq96i7GIy+t3E/vTkY+JP0bw=;
        b=G+bjVuK+OBmWCXxWsopN02vYPlalsRPhwHIMY4QnoZXh+7mxogFGzjt71I9rsgv6uY
         lgRnTO9NWsMiRnc0PW9KNYb6W+5ZeVf2S2w/RS7tI5j5JHqygzIgk7uoOSndXxIZRb3j
         8H3CjoeuMirYzUU7qaLukCV4udxIkXpNP8eQH1gRC8QFmNfZT0YxtZX5B1SS9PNFz9bS
         1G8oH7ttwZv/wSAWdNoYjM2+pN1leGPxt+8clOf2J67KSAqYX/UWj8xMO9/YfZmEPsa+
         3vcMt4V0ZlhoCvvMkAyhxKrdp4/NvuOUtiL23qNGxJ+QBldPDqU3A2YmM6VXFE3Fdzj+
         2WtA==
X-Forwarded-Encrypted: i=1; AHgh+RrQcto6FgxTDgnKAOjMBsKv328F910kof/V+espYumVGKy1FCEpDaKIif35g0I2Ui+C6Zy9DhM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwDQufQPJPjjetsVxiTVIbSSo8ttaETjB5LUmAdoujHMpxdkKMv
	nMQpdIW61ntw6lgJG1cvrtuuYYsbTpaC1fP0OU+k/wrSGU99a8uSHE6p7WWmQoLL7vS9+PUvB3c
	ubs/Q11cSw3JgiBMJjoM3+AWqyLGfSyELjA6I/0AICw==
X-Gm-Gg: AfdE7clE/KavIOqS+J7505pogf67kGULD8K4MYtg6db0XJT0OQr4wqj43chvWJWTMlm
	2Oshs+7Scyrjo+YSGZc/LCjoOcW3UoKtm88zDNQ+MwZojjRSSMn7C8PoBmCv5vrMFhmR+1k2fxr
	Pn4JW8zLHBnle1kZao++H/DJs2opO4yWsfic8reCjxMGAjr4EFKcsOKSKDJJqToVDw647WwxHEf
	UMStOoOlCxLX9Hy9gNhx8I8gwafXE/SDvSqZ6qHFJepbR7k8qCZCzBRTrrEMiedbwtakW9gebj9
	7gCUWVtHIKkP13boF3J60VNNdvvdKtMxM3ydjg==
X-Received: by 2002:a05:6870:b3f3:b0:439:b99e:4414 with SMTP id
 586e51a60fabf-447aa7368f0mr16814855fac.6.1782723224733; Mon, 29 Jun 2026
 01:53:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260617145130.3729015-1-sebastianene@google.com> <20260617145130.3729015-2-sebastianene@google.com>
In-Reply-To: <20260617145130.3729015-2-sebastianene@google.com>
From: Jens Wiklander <jens.wiklander@linaro.org>
Date: Mon, 29 Jun 2026 10:53:33 +0200
X-Gm-Features: AVVi8CdwEgzZOnIaRh41XK3ftF9jm9u6SUDMnMyJOJvWlzRi07xhGUj8Wp9l8xs
Message-ID: <CAHUa44GST=efeDepEHWs_=ehr7JVnkg+y0ZLebcLAGZXxpNegA@mail.gmail.com>
Subject: Re: [PATCH v7 1/7] optee: ffa: Add NULL check in optee_ffa_lend_protmem
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, oupton@kernel.org, sudeep.holla@kernel.org, 
	will@kernel.org, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com, maz@kernel.org, mrigendra.chaubey@gmail.com, 
	op-tee@lists.trustedfirmware.org, perlarsen@google.com, seiden@linux.ibm.com, 
	smostafa@google.com, sumit.garg@kernel.org, suzuki.poulose@arm.com, 
	vdonnefort@google.com, yuzenghui@huawei.com, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 17, 2026 at 4:51=E2=80=AFPM Sebastian Ene <sebastianene@google.=
com> wrote:
>
> From: Mostafa Saleh <smostafa@google.com>
>
> From: Mostafa Saleh <smostafa@google.com>
>
> Sashiko (locally) reports a possible null dereference under memory
> pressure due to the lack of validation of the allocated pointer.
>
> Fix that by adding the missing check.
>
> Fixes: 2b78d79cdf96 ("optee: FF-A: dynamic protected memory allocation")
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> ---
>  drivers/tee/optee/ffa_abi.c | 3 +++
>  1 file changed, 3 insertions(+)

I'm picking up this isolated patch from the patchset.

Cheers,
Jens
