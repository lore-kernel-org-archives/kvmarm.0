Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF10A238176
	for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 22:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753484019; cv=none; b=jaFzMxby30D7AhegxWUqaIaR+2wHGs/VIS6nGeK0neks2M3b2j2MGQUZqcMaBOlo0DoSx9MptIrwBRwtv71oJmQsoaHNDcg0uuIhNZ327d2+S4bZ3uG10t/HiQITRJg5S3CV1qKjVL9TWsZXuhPz+9XMJWC1Mp4w9zHs7ruST68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753484019; c=relaxed/simple;
	bh=moHUI1Q157DM+aXkuajrMR/WIm8yUk/L3gekBDHPJoM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z9CSblvqag1718Xim99JLvJBYF5cQyZ8er1FYN5LBOzbHOrtThKXLqt1ZktjB6u16vPaNTh4BxlF6gw8Wduw74HS+aRQviSnA3kh+uoyBi8Q5UVsjJdqLMx+z8KFGJC93X+Jm51I4c0SxYzjUUIA0b1rS6m/OAX6QyahO5d8sK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ot///LOG; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ot///LOG"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ab3855fca3so46871cf.1
        for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 15:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753484016; x=1754088816; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=moHUI1Q157DM+aXkuajrMR/WIm8yUk/L3gekBDHPJoM=;
        b=Ot///LOGruwJQLAZ2uOI5lhdCYoT1MKbAlp9cuzoQg2LsFPpYmpFpOszzotTELCRMj
         fVP6yAxfzeGZP4KrcBovB5jZPijiJziz4uKxclTBXv65sEGFj5+cj4XKVPlBSqGgvjeN
         cpGonJG9DVzfodZG56UnsUA1apkxlfATBDxSJRZHAIm5HwIm13f5g2v60HGsCHn1I00G
         BZsu4hbJsejL4fn8B0iAPxbMGxjTw1l96Fmfzwld8tSqWv06UXR9sxKmoazOh+ZNXDnH
         AKcwl3jdqV/3tbjyflzGFV0rp5Tq4QWVPmIt4u+7g/bTPirqDUvlNJUcd7ngJfC5JJBC
         UVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753484016; x=1754088816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=moHUI1Q157DM+aXkuajrMR/WIm8yUk/L3gekBDHPJoM=;
        b=sVNJnbHxboJ5qMvcao/6EthdrqABEKi8sF1iKNUp1ca+5+3PQ3Pau1rIHkMiSjnF13
         3wCehC2tev2B/BriELfrjwn62p05TCRscn/hznel3CC1QreneZldOUOWxVdCX13Yw/0P
         DaQHZP6CtsYe4xYGLCJwC1Q+2PwrTE/9MOgZuROtFFxwjoJYGDSkRrUJKrO3Ukh2Pvnk
         s5zakoQ6QPP4BY2HVICZENNMQ9uV0ePYR/SIgZSim5OYb9IsMx7oiB33Thz0S+MSA8Uy
         6kkPi4/sz4qF9rgWQV7lMeuW9DzlEMxwwhqnC0/ByoEy7WEyvjkWQZYTdW/7VGHLrLxs
         adJQ==
X-Gm-Message-State: AOJu0Yywqk7+zwV2gm6yKps0ZGtJn5x0NAtC1OjwoPPMCWanN/xJ3sTa
	qAgOUm4GjyIwTURxpsI1cCjmeSgOatRMy69VnBIX4QSDl0adMpSm3srIvDJzRZqEOKkm05D7gNY
	mycfUg/snkQxPEvoRszsw3picRhHruOEm/jN4hoM1
X-Gm-Gg: ASbGncsNdufQLO0spVGtHqxPZ6R8Rvzb891RjxvJTxD4R+oDbB+4uNZ3QbfUXVy1qWT
	knKUe/f7bFAiKgvEmWq/hv6KGGIDiiHe86bQCQ0etPSLn6wlszvwYOK4OMBzr5Z7NnF76JXUIAT
	mlBSfQPeRwCmrJQa0nkFYXOqTojGTjcGg8L2cIJJZyvm9pzA9pGuqWDJj3Gs9oH/Cxs6KPcUcUu
	lZ+B4s=
X-Google-Smtp-Source: AGHT+IFH3wRT5qWZy3EesxnK819MKyNbuV6tiKn5OxtfULODoiboDaTtc8Vimoapa4n7n82anSRVuln3NDE8H2N1BFY=
X-Received: by 2002:a05:622a:148c:b0:4a7:e3b:50be with SMTP id
 d75a77b69052e-4ae9cc0b2f3mr1152601cf.16.1753484016324; Fri, 25 Jul 2025
 15:53:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250724062805.2658919-1-oliver.upton@linux.dev> <20250724062805.2658919-5-oliver.upton@linux.dev>
In-Reply-To: <20250724062805.2658919-5-oliver.upton@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 25 Jul 2025 15:53:23 -0700
X-Gm-Features: Ac12FXwA9jU61cue45o9fsz-eRkdy_1EahKC5IhCflrNSyz_acNrYzjFgU3yYPg
Message-ID: <CAJHc60wXquZzFNP+ekWZeVKAYkrB8eG+16c-LWLYX75NpYd03g@mail.gmail.com>
Subject: Re: [PATCH v5 4/6] KVM: arm64: vgic-v3: Allow userspace to write GICD_TYPER2.nASSGIcap
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Eric Auger <eauger@redhat.com>, Ben Horgan <ben.horgan@arm.com>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Wed, Jul 23, 2025 at 11:28=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> From: Raghavendra Rao Ananta <rananta@google.com>
>
> KVM unconditionally advertises GICD_TYPER2.nASSGIcap (which internally
> implies vSGIs) on GICv4.1 systems. Allow userspace to change whether a
> VM supports the feature. Only allow changes prior to VGIC initialization
> as at that point vPEs need to be allocated for the VM.
>
> For convenience, bundle support for vLPIs and vSGIs behind this feature,
> allowing userspace to control vPE allocation for VMs in environments
> that may be constrained on vPE IDs.
>
Is the "bundling vLPI and vSGI" part missing from this series? Unless
I'm using a wrong base, we call vgic_v4_init() if
vgic_supports_direct_irqs(), which will be true even if userspace
turned off GICD_TYPER2.nASSGIcap. Am I missing something?

Thank you.
Raghavendra
