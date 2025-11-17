Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B86A30C639
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763375717; cv=none; b=aYDocf4+PS1qKE1XykqGkoRRfLiWNOQPj601DX/VtTAmFgWMS+ogdF0LFei6tzKXGqGT/VEPjUrgtbTiz87o9PMghzRYTH8R7/Uda3SiCvftwFDbv2PrHeyzXtMavUNIcQIyzRsxVOGIwWNomI+Ggh1iw61HiHYyoVrc52JPvho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763375717; c=relaxed/simple;
	bh=1amoj1sKKYr1XLj2M/noyNE2YeQgsGaERFXZC4W3TJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uZRF3mIA2snK1b1gT7w/jMFluz/73oMrX/PifAbDYvok2Iul/gqBLQFFxLLQ+MmLvPRLAYbceT83DLZ1M4pqSiiCdlmT+ZeZWWZV54iXgSQ3QRWPldTePPzbkAAizDZnsx1+9ft1LdvRmglz1RaaJWsY4+cGNyT420DifsJAS9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hePDOCfQ; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hePDOCfQ"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ee147baf7bso403021cf.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 02:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763375713; x=1763980513; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6UMb76mn8fRdulKyLx/a7XYom3+koOQ6PHrThZtOCmE=;
        b=hePDOCfQogyBs1f4yIdjOh/MFVzP6CokkYTpH4xNqeEJWYln4e6FaQ+9Lf6JwfyTq0
         8cgywuTCPhGHnwL8MIWR9Gy6Z33tcpctnoQvzguWquFY3nIRAelCKK/Rwp6jprDPyhB6
         azBOKAb64JGO5IxmILv+Z5Eo3Xv0J5u1p+PQRoP+ZP+tTdBSOfgBq+uQxeEhs28ZVyV8
         4OFE1VpxRTwUSwha6GUf2v+qQUdCvsd0r+uv9+F5cJXOqemjXheiyN8iyPxlyjp+kORr
         aT+V/i5qBN5Hg1qup0ZPip8aD2I2p+6nWS3PaMUJpNFYpnx7eEr8AFILzv/+OA12zQjW
         IBog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763375713; x=1763980513;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6UMb76mn8fRdulKyLx/a7XYom3+koOQ6PHrThZtOCmE=;
        b=nd/ih3E/PE3cuK6pQqW5subBOQKIEhjXB4w9zyBXGfAGTc9o1rFFG7mGYLQ+fCM/tU
         p7FBsQpNEK+qooM2WKscmaDg5opiHzGcscu87MHykNTpo9aYknmZRtDV0ZnocACAQGAs
         LqsqOL8y71kKysxtB8A+pvo9tpYKI14ZrTgHHou1icR1g6+K748iHNf0LfJVt8A37QcM
         8N1M1kIyEkC8Sya8tW+R84m2dVNcBtxDsWrDj+IY18F3uoWAl0MpgCVcXNg2+4QuJ5Es
         CFdG8qo5L0rpju5m5ONxq/qRqsYXZ7HdmjFEmL4TcfntaL7ufErDGFXYj/yY1ZBpdG04
         km2w==
X-Gm-Message-State: AOJu0Yzn4KnYYw1f8QKiBNJhVjZyROQiUIE28EeGobNfpb6OWgFh9UIt
	uVd0CHjHSJiy5PgU/EfbAJL6OqbDbEXtT5ZrAo8jiCc+Ai1qkYCSb6YeoZKaW4RBMekg2FPi1x7
	Wilc8SsfqtQ+Njm35NqM0S6Ok6PBBpvgqbGbPjUvW
X-Gm-Gg: ASbGncu/vPF+f2Na32g9zUGs9u69wpuJoa4yrCKSOfrgFDDwWIoRtsds6ETITrWyw9S
	0JYP30MDtxmMehSfzpvW6mzWFKrIjF4txjwOK0NV0ratV4mwjBNkIufI8wsEzgPeUYMIkLuifu/
	S/DUBrFNZ9X0FLGSQUTSh94oam4E2N7X/nAbrPvkzZm477AaB177l94+9RemCNrNubi5cLA8KZN
	FK7uDD1gckMWEvp9SkOIlmHOpZMDhqGLR5GOzcQDccdI9C4yr9oE8Jn20g+wk+u0vKp47s=
X-Google-Smtp-Source: AGHT+IEeDf8TqrvbNoWWGhOaSKTbd2JM8FcWY8tyPNdC251IWOGGbR4OQunLQUmX2T6cgbU3MIvYtVGTrvUN+xb9V7A=
X-Received: by 2002:a05:622a:647:b0:4e6:eaee:a944 with SMTP id
 d75a77b69052e-4ee02febe71mr10646641cf.4.1763375713065; Mon, 17 Nov 2025
 02:35:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <20251117091527.1119213-2-maz@kernel.org>
In-Reply-To: <20251117091527.1119213-2-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 10:34:36 +0000
X-Gm-Features: AWmQ_blgezKjAAmHyIWXBoJZICk6tQG5D6YP6HkWhKHbDls8Zob-nCh13_5IZ4w
Message-ID: <CA+EHjTy93dmoTysS91+jFmey8ei55VWNUf-FsqVz9Ho4W1NWBQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] KVM: arm64: GICv3: Don't advertise
 ICH_HCR_EL2.En==1 when no vgic is configured
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 17 Nov 2025 at 09:15, Marc Zyngier <maz@kernel.org> wrote:
>
> Configuring GICv3 to deal with the lack of GIC in the guest relies
> on not setting ICH_HCR_EL2.En in the shadow register, as this is
> an indication of the fact that we want to trap all system registers
> to report an UNDEF in the guest.
>
> Make sure we leave vgic_hcr untouched in this case.
>
> Reported-by: Mark Brown <broonie@kernel.org>
> Tested-by: Mark Brown <broonie@kernel.org>
> Closes: https://lore.kernel.org/r/72e1e8b5-e397-4dc5-9cd6-a32b6af3d739@sirena.org.uk
> Fixes: 877324a1b5415 ("KVM: arm64: Revamp vgic maintenance interrupt configuration")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-v3.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 598621b14a30d..1d6dd1b545bdd 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -26,6 +26,9 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
>  {
>         struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
>
> +       if (!irqchip_in_kernel(vcpu->kvm))
> +               return;
> +

Bear with me, since I'm not too familiar with this code. This is the
only function that initializes cpuif->vgic_hcr. Should we be
explicitly setting it to 0, or warn if ICH_HCR_EL2_En is set?

Cheers,
/fuad

>         cpuif->vgic_hcr = ICH_HCR_EL2_En;
>
>         if (irqs_pending_outside_lrs(als))
> --
> 2.47.3
>
>
