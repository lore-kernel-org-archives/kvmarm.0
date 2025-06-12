Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F0F26FDB6
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 15:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749742806; cv=none; b=OQZj+B0MTSZUsWyjMF/OpjmA31DKew4cVNbPqUVsvJ2YDfFzwejbgSSS4ozoW8+wb1tOpsEOZYaBeWSSrHz8kZbRzuw5JVf9cg110D15/ryj0RsNyPyJMBHLB9wIgYxPdEEFr/U+39tCABLrW6+D+iN0i85Swmgd+qkZs4kdhDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749742806; c=relaxed/simple;
	bh=u+ldXLd1xeDpOb/xXRqVkjW3b7nBGEbXLmynyoaiGFQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qpgJx1WguTiuTQUzs9xT9abFp7pJcEcSnSx6KRw54zCj31HKZTWXEwpkGSCEhz+L3vfC50Rz7nSSf0KXeCDWqEm8da6YsP0ca4aHdblYHCW6bSWONVBrO0A4hX4nJZeh4xiWwwSIMl6KI99eg9/mRiTKJHSuXNvZfPQF1BEQb+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WSnLS+Ku; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WSnLS+Ku"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-70e3c6b88dbso7558597b3.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 08:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749742803; x=1750347603; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0GCneGgfExrxwfR8Ui0kwChdEvpsbQ0IMrzfOgR23iA=;
        b=WSnLS+KuccCmvmg8ovipza99BoO9O8c2jIx9Ny+J2QFsXICTXJhIxqJTkx6f+DS+7Y
         7zY52AiNtwi6M908gtMF1NAyzPi/lvvtoou58o7haLk/DjYPcGlWBl3Fr4ZoGxokHFZQ
         9BJBm++Svi2y7JJ/kpjGgqfATtBW55BYdHfjQNHg/+NOLpSuAmcHSfxNs1aQqmO8B9Mj
         JYJhcUNMTK5xs9t3G8Azjj8o+B7Q3P8zLOIPNcf9Y2g1M+RWqajzkRnxqlIwz21eUJvY
         krg5lW5SKQRd63TUaRgEPhK3AX6E4d/SmZU2IBejus3QAhajnNSrhq1hdOspbeHEM8df
         +vRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749742803; x=1750347603;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0GCneGgfExrxwfR8Ui0kwChdEvpsbQ0IMrzfOgR23iA=;
        b=mJHVU+5dK7WI1im+dmsm77Z19XMAaC5GlBUu3inEOvAwMsZyjuAD3Uce8JWdCfqLzB
         e7HXUAfdVqCAvQF7al0Wri1h/nENM55YrmWqXZoRfmiRxJGNhgw51yRmjdXoqGAtZaSf
         PPlYvGqJINHBLMXYlfvxHnVBG62ARVuqrdHzRPT/vvWMOozs62xWuDOgeNSUOANHPTlF
         uROu/W+cKIx8FX/orIp8u+InhbDId46L6H1EZqok7BNbF1jNmkVTYkUDPalgAbXAEsg5
         CuM4J3XidC290sOFc1lRw3iLnrBJ6RN234KaM4/PFe8c6YVeRX+SWVK6g2QZi/4Rkl1f
         2LYA==
X-Forwarded-Encrypted: i=1; AJvYcCXY35o+boUGuE8ix71nVpuBWNe5uzIILqtoxyZkl6l0ovcMSEMrdSlUAPAhjy1reNKFlQ/YYPU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyM0/dT8H95MC9IrvU7YO2YYwLVtPvTv4xANvRK1hmH5KS3dZrP
	U6BxfmjibAazlO6bLlYlhWwDKXfmuI/zIRPSnf6mpcDa9u4IWsaI2j3DHx4QS+hiZf7eIkOQ4ns
	4n5LQQ/EznavGpBAu18hl4BFV7+o4mMh7s6q/wP117g==
X-Gm-Gg: ASbGncuBYpFn+ABWV1vhWOiU3jDFTHIseUDFlPxS47tlOmoStnNxwVqRr7GcA5uctMU
	jlw7xClUL0kJ+Max6Eqj8BqM6OAQfHRiaozjEvxtrFQlpPxaUwhkGMxmJBPyprxpopTwzUDJDnE
	Va+U5lkMZjMWkjjZ4KscPoeNqAPg1WIi9jw5abR9+X6a6wiSrPag8uOMA=
X-Google-Smtp-Source: AGHT+IHBHeJeONG3H7FZDZ2gzpluKSyc9U5d3tSDDj9TAvFgb1FASvHR12UGnIXjylLAo97HcqblKFJamwURpnJdu+I=
X-Received: by 2002:a05:690c:3584:b0:70c:a57c:94ba with SMTP id
 00721157ae682-71140ab7fe8mr120867917b3.17.1749742803370; Thu, 12 Jun 2025
 08:40:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250515153907.151174-1-cohuck@redhat.com> <20250515153907.151174-3-cohuck@redhat.com>
 <CAFEAcA8y_wwZPoqkyPrNscRNTEwiOQm5Or9C=aiSNMGcZmq8CQ@mail.gmail.com> <87cyb99doe.fsf@redhat.com>
In-Reply-To: <87cyb99doe.fsf@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 12 Jun 2025 16:39:51 +0100
X-Gm-Features: AX0GCFsSzIs_NzMxA8HzPGOMVkRaS0W_5TAvxGj8ZsUFrqoq2Opm_C-WeWiw9RI
Message-ID: <CAFEAcA9P9W3jVzX6T6X3CW0zVwDbxdo1aeiG4ogGzpnHmQ8xgQ@mail.gmail.com>
Subject: Re: [PATCH v7 02/14] arm/cpu: Store aa64isar0/aa64zfr0 into the
 idregs arrays
To: Cornelia Huck <cohuck@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org, 
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org, 
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev, 
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com, 
	berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com, 
	agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Jun 2025 at 16:34, Cornelia Huck <cohuck@redhat.com> wrote:
>
> On Thu, Jun 12 2025, Peter Maydell <peter.maydell@linaro.org> wrote:
>
> > On Thu, 15 May 2025 at 16:39, Cornelia Huck <cohuck@redhat.com> wrote:
> >>
> >> From: Eric Auger <eric.auger@redhat.com>
> >>
> >> Also add kvm accessors for storing host features into idregs.
> >>
> >> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> >> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> >
> >
> >>      if (!cpu->has_neon && !cpu->has_vfp) {
> >> -        uint64_t t;
> >> +        unit64_t t;
> >
> > This doesn't compile :-)

> Hum... weird that my compile didn't hit it.

Patch 3 changes it back to uint64_t, so unless you do a
test build after each patch you won't see it.

-- PMM
