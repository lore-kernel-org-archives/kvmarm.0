Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0694F328245
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 11:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763378993; cv=none; b=Qqg+mjxhqRLceOVbEahBvG8ymuFyCmC/YJ3DYEjlqJSJ1UNG8Dq5lqbYj7aeZxZdzLVd/7u5jFgptfjz2qRdG99onCaQljdb/69XA4iZ0ivnbqMb/OOwN3y8Lk0RpQ58+1VWFsD0nfb8irgbYURTSdXAigil0mw2Z0fHKiOgQgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763378993; c=relaxed/simple;
	bh=l8wcHeWSdysycrv/3lpnqDHBw3TkLAFGkLfKnbgKX3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JN4ob1V+ZzTWASUUWpoeJLwqB1REhjfZiiNAWc0Z84LWKm+v4e3Lx23Ot9P2nmwnGZN8TKIN7UXL7cPYqljj6pIM2Kr7wXPF1p3V4zTbaaga6LQgAq0+nvZ9WXO74X1xitTfxIiXroRyKx42gY2xHE1FZIzJq+dnbpTFuXyAim0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=skkdU6Qd; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="skkdU6Qd"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ee243b98caso186641cf.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 03:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763378991; x=1763983791; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hyqx4r4nQhUfWXnWTqZF9HfLyEHZr57gV1AR9j4NAXk=;
        b=skkdU6QdDhIXXOXOR28mGgukMMonePGya7QhXm1ma/R9p5Fl+Co+lL6k6ZEzjNMhaP
         se03qTdooSkA/eyqtSmzflTxYt9uhl2lG3CiPJu7/7ijOISnk3bRFc20LUEnGR01Zpe4
         MEf3YPSuq5S1JsnAohtRvQQ6e6pjjjLkEOLPXGRGezkHsF+Q4yfFd59xHqnvVBxykwPy
         FoMbII11JkG5Ee9JBAIeqGrIJGv+zNXGEoZk9MyTIBkLQfoneWmpGLDUzALwzXBEXEp5
         biWwY+SFijz2jke7YalpYbxXGuYZJBgFilT32c4pG21tRWrfsPGjSHpPf3JY7ipQaw7R
         HT6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763378991; x=1763983791;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hyqx4r4nQhUfWXnWTqZF9HfLyEHZr57gV1AR9j4NAXk=;
        b=bBSm03J/VQUSyLEBTdyOIYvBuSUw8kuItvtKfWb2H2PoXR9TtAjP4HvJmspB3NCkWd
         30zmsF3lY28AZL9uCtWu+PNe2XEH7GT3hc8MBy90Y/KcltYc04Aqohmie/hCUBaqS2aT
         Rt0uIj8oAUSZVY+V1R/m4E2bPZlBS7nZWIkVDfhrdaDWGqA7rUgrowtidhDn1vAJWZ+d
         0HiBBqt1i4+5Cm5sTzOgzZbgTwxkuZ8RXgyjgTGUEbQo3bCBhWSSGNRauYYfaS0xxGbE
         E+bZYcPutF/aKtovb2MYFolkZsNJprUngbNrl6RsxK7Q89FxV32fKJFqw0+NmQoEUyP2
         wfMw==
X-Gm-Message-State: AOJu0Yx2lvmBNoNf7IQk7ViGfLzjO1mrFYGIRCnhoTl66e52ob2RYpfE
	3xxyUa1fJC+fW354OtU7xDM4oBEvi6OStFFzTnROFXy0iyXXoYR/pbsb95Ena3HQcUUEVCFTlhX
	vUWotJ7IOHnbJrRRxXgKoWP1kT+abwpsAqrXm/gHI
X-Gm-Gg: ASbGncuLFAFvt3qCFxGCeNTjL1uNBVSTBdeF1W160JbJjYi/cqyKXhMGiu8Ggj7PyJ4
	/96+zP8l6q+YrjGtCDxFuDSbVifQZP+Ku9GRBABVBHYVKEE/75YHK3ITSl4rwO38msAVUWDqUpK
	vZ5whB+WUfU8gsOh9P/lF5z3PNTQncfC/5mcqv0dK374xs5YIvXbRwLNOvRYKaPVK5LywTEInxk
	CXQ53FwUqgZ+3BsWQCGpQlCQviOMnIZpax0wOxVykLwHhlxkbI4AR7k9USiPvo40iyhfs5c2c+Q
	ppdIDw==
X-Google-Smtp-Source: AGHT+IFIOxZ//wrmDM1cUR4nb6LDG7ma+elT+J0SRvK2XWzC5avyhLG6D40y3PR+JjZ4wC9eFj5753jVYjCTDfo9sNA=
X-Received: by 2002:a05:622a:4f13:b0:4ed:ff77:1a87 with SMTP id
 d75a77b69052e-4ee02a994a9mr8299811cf.19.1763378990715; Mon, 17 Nov 2025
 03:29:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <20251117091527.1119213-2-maz@kernel.org>
In-Reply-To: <20251117091527.1119213-2-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 11:29:13 +0000
X-Gm-Features: AWmQ_bmzdmE29Dyex3S07XvvcAkxx0qUh2gMXUSYHUgIgZOO3S3AS3FjH6bjm7o
Message-ID: <CA+EHjTxUhpUT8s0v6P=TNTqwHnF32arTsd7SCXOU+9uJ3wO82Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] KVM: arm64: GICv3: Don't advertise
 ICH_HCR_EL2.En==1 when no vgic is configured
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

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

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

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
>         cpuif->vgic_hcr = ICH_HCR_EL2_En;
>
>         if (irqs_pending_outside_lrs(als))
> --
> 2.47.3
>
>
