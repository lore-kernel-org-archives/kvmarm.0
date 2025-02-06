Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79CF4C8E
	for <kvmarm@lists.linux.dev>; Thu,  6 Feb 2025 15:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738857090; cv=none; b=OIhxE8EZWo73MuOZ+o+eCF9bhOnZUsvQMLtM+MwoI9CdKqWqJ5KN65l2NQmkqYDZsQ5BIepTKCvmjWneryfqYeaLI5xP+yy/rvjSGhb6zJQ2f3mB/Fyk6rotqNRnQX/E4PDQZAdrMrh91UYFnU9b+nDJ9I9WPeGmsP4D46xM2zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738857090; c=relaxed/simple;
	bh=Ya3+9Wg953Jn+6r1BFFWGUmXlm/mTDHOFstHYyTPAz4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qc+F4ql+SKpE/Ec7/5T1TXRhMuPvJs+0L7IfYDYCwaf0CoGm8HKHZSY160nYGLN/qBuCJjIxjOlVuNI4tf26NSATZtb8hjunZNbefMxAh2RKuHdWvnFwu9mqphq69t1Ff3JhDYT2Vgi625EEGP5MuILoXUuCr4BTTmrYTI2AC6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EnhLeF5K; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EnhLeF5K"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6d92e457230so11058066d6.1
        for <kvmarm@lists.linux.dev>; Thu, 06 Feb 2025 07:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738857087; x=1739461887; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ya3+9Wg953Jn+6r1BFFWGUmXlm/mTDHOFstHYyTPAz4=;
        b=EnhLeF5Kq3RJcXQi03yuTxdX1FCJy26q7jPhksQF3tZvkmfgp6+eyr3zB0/F+RmQrD
         70qOO0q4/IKnPkuT2NzMs8JC4/Qthcdl1cPHKduy3B9/sEa1yXcKnLGAb6Ieq0GFYJnu
         5ddHv3lh/Hsuoqtd++ohhlcZDC3MINtTVs3PekCNIzRAZFZccZeAY/BCEYIQ3zZWw6wV
         77yVZOdt9rlFsWQ8cQ1f1OlXZx2Vz//5VGgqi8PBCKJJmc2v1r8v6TdFX7Pa08YgIgp0
         1PxPyiVp3lKAp7VCrfD4uOp9NVF7aPaPM2Vbm5RYHxxzrnmKRKAlArQoz6GGP6pEwTTI
         ENNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738857087; x=1739461887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ya3+9Wg953Jn+6r1BFFWGUmXlm/mTDHOFstHYyTPAz4=;
        b=bgYt9ozmxpYUowm1gBGCPBj5iHRdRL8PthrWQAUTrkvS3Ft2DU1k+5DzPm4tIpLrNz
         TkfZvELm1YK3gHHQKvSeD5ENKDLERD26CEXDmHkZ74EaNpLyOl2uCgTF6KwvuXlS/0ZB
         /+CNeUu72odnE5D5Qs/JX8BE1hmbii/GdzSazuoKyf0EsnyW79DqmTv5se07v7qNbFrY
         BUYHyTkQvHTOXOMMWxmNpXuw4GQ4wodZlppkTx00+l4Qy0EBmQ1JaXUrid+Dev2YU+4L
         oj973pdgLnPXSMRPvGuSWnk/pA6MVVwG3MV9yYAl6M4Hcz2jRPcCgXlkPp1xQ8ZyZPFM
         o6Dg==
X-Gm-Message-State: AOJu0Yz6OYy3OzTvijl73iCeadT9lNQwfAq+M+HonawZGEHOd1XbeSDb
	KdIpLzuY8BNqCrox9jBYmayw/aYIpQtvMgmhv0H2slLbYok3HljWZ3vf75DAxK4a2Q0xAgj5PT/
	W/H1Oh/kMmJei0KybVOgFRaqi4wQ0yqmt7HWG73u9HnzdxH0AgAWm
X-Gm-Gg: ASbGnctMyxJqCWJeGUn0cElXa1mVQxK/gWmy4qBN55LgwYfVswu5/xdYi4tzPb1ojzK
	Q5gn6GyANRxWiqOF2HehxZApexh07PGVNZ8pubKQhY/FxHFg51MVtvklK636K090bbbpUEEOC4m
	tsO5vbgiiLmDZOOmbzYgNb+VLPYSc=
X-Google-Smtp-Source: AGHT+IFMBJsyPwVR1HoBMqviD5Pyqu4vYLuB8gSFN9ZYqdsjCcNmHY1xh1xQXuMX0ieM7+vdGY+x3E+i/HgZsuYPxmg=
X-Received: by 2002:a05:6214:5085:b0:6dd:d317:e0aa with SMTP id
 6a1803df08f44-6e42fb0aa0fmr101443986d6.8.1738857087521; Thu, 06 Feb 2025
 07:51:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250206152100.1107909-1-maz@kernel.org> <20250206152100.1107909-4-maz@kernel.org>
In-Reply-To: <20250206152100.1107909-4-maz@kernel.org>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 6 Feb 2025 16:50:51 +0100
X-Gm-Features: AWEUYZn8_ydm0qkW8TG4DHZiHFcLg3-2ZneNEx2eq25GUfwj1j1D17RMpscxmHM
Message-ID: <CAG_fn=XLYmv-Q=b9vaLow82BG9oKDjM0BoCK24c14B4XweJfcA@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: arm64: vgic: Gracefully handle resetting an
 unallocated interrupt
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 6, 2025 at 4:21=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> Playing with racing vcpu reset and vgic teardown makes it relatively
> easy to trigger a case where, by the time we try to reset a mapped
> interrupt such as a timer's, the vgic is gone and there is no
> interrupt to play with.
>
> Check for NULL upfront to avoid further embarassement.
>
> Reported-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Alexander Potapenko <glider@google.com>
