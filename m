Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EFE2836AF
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 11:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763378791; cv=none; b=kYCvm7kzOpmXB2Sf+E6jHtuBGyDx/yrz0kQaQTk1Yc11ust/gl1NfeCMWe/gkJmsu5q8MDewG2L2nty/tm9Hiev6PFQwcU8qpJrA19MifbCaXdx4CRYO5NbODbB5aoJ7fETTfF4nV2ZNkJUSLuP+SqNTSTY7hNxWKNaQ5xh86hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763378791; c=relaxed/simple;
	bh=/rhf9hmgiMKFdWRnE5GdTAp4asqaldwnLnA3FvpRkxY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OpXKzEfjk327Ui0MakuTmnJgT6KUc0+y7HNNDOd582Ddtfro2cKQYXwTomH/trozKdRVnIUn9adRO7yTFZQ95bt3r1RUbeiqPJd7uugVhGHt2/YZUrhHsl9AZcidDnNk/N63+D0uWdkQZDOGHUiW18tpOqVauNKm81f7N434ALw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wTP8YKLw; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wTP8YKLw"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ee243b98caso185591cf.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 03:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763378789; x=1763983589; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=49ctbnqVDAwIBJX5k40l0vJpezvfhKgkxScmbFVG3vs=;
        b=wTP8YKLw8030YxRXlI74hPW/uLCqyUssfp4fHDKicKHp0p/Jkk+84v0wbKiZuYmROo
         1d+IinEh1ex02YcjhCukDagpYtbWJHFRxRfwYdrH1zlMhTpd359g6zp3/g225V8R7m7H
         M1yGPGfnVfShKXWoXMEK4bP9yqB+sYbOtNZkh6mSzpF3HUVsQr6dRy3+TSe6MF3F/70+
         okFgsCXX+Ay4bPfMABF6DVwRrw7eXKjRR/HQjRYrrpqxTi+uZVNSNpqhbyOgX3R5GYFA
         wOh47C2FcfSrUSigK7XbDujKiIbwAjKycDLfpFzUzJUml4zN+kO1bJXIZ0zOanq1I8L/
         +CIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763378789; x=1763983589;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=49ctbnqVDAwIBJX5k40l0vJpezvfhKgkxScmbFVG3vs=;
        b=HrxLoFQO6TF1rdqYBgrGDnSuDuAowhJYN/UmygygXvJUDSg47ojxUlXmqznbQtu44d
         0jZgtUKqQpEYBmeXFF7FvoSoGVnDNVMqvHcNi00eZxP9omnmxTkE+jSPiI8r0l8/0BXY
         nzYbnl70GC8mZE7dL2hxx7hl24waU50hRJgn59J3qMvwPvvGVOhQa6/O7sjszqCRWVRO
         5QAy7EvrT4pGdHNmmq0uzWcF1zRfKG0H1tQcLsCDNPPJABPBvat1Z5k4za1+hdTfha+4
         zjN+Mk9qw3ZbBcc9iJBpJUN32SVGXGpcJywq26wIQnL2dbc79yCM2wnECSq2JzDAWh1f
         aBGw==
X-Gm-Message-State: AOJu0YyVJbpoJTZ1HKBNWjwSBsgPsVI9wadYpaigFmN0L79Pzl4yN0f+
	sqWOq4K1vxJYu/SXJHqUxLfwY4fZ9Oy36IyD+98Eq/otQRlBFllguL5rGF+2W9NUtDYY9A/0+LY
	Z7TU998Zwzlp42ql/SrQtSUTr4hQPp5YynCIznfmLDK2RG6PT63ZAHRJdWOw=
X-Gm-Gg: ASbGnctq9fn1l43rHnQD33ef90i7ZVg3gDq//53DEmiP4NMlbBSowS4rN31J34YfhZo
	/CGbaAz2ZZOo07ewI2ZaR8qBZOQhcn5vTtN3CL8DU497ikdh0KGAvM5xA6EV90rkNOjHp2WvdWh
	TBXI96HLxS7aZBhWyLRszAgQZ1vBGLWyen/E9EqqdPa9U7rPfnnjVIwenkaoDne6zZ7rQKVouuq
	u+IxUTdBTxLcG2zzprHB1sl4xAxisQ4gIimJx+WqviCyG16d2rh2CxVnBwkAwW+PE75MJDcJqv0
	IDGZV49+XJFFWjH0
X-Google-Smtp-Source: AGHT+IEioMYFsqCc/4jnG0fmbEwZ6LA1WtQ/uRrIvwVWDiUcLFKyLiTmWE933E92hMBlL3D5tgBe1zTgaGIOHcn1qNw=
X-Received: by 2002:a05:622a:1191:b0:4b7:9b06:ca9f with SMTP id
 d75a77b69052e-4ee0279d624mr12602131cf.2.1763378788577; Mon, 17 Nov 2025
 03:26:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <20251117091527.1119213-5-maz@kernel.org>
In-Reply-To: <20251117091527.1119213-5-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 11:25:52 +0000
X-Gm-Features: AWmQ_bmeFv51Sa8WTg6Ls1D8vjiLqQnByeUS2NLYDYoerk0mUC01snRaXzO25Vg
Message-ID: <CA+EHjTwEj_-tDvq2+2x9MxTom2yw7Rx0ZZg7XuBOWxFxBJ-n9Q@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] KVM: arm64: GICv3: Remove vgic_hcr workaround
 handling leftovers
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 17 Nov 2025 at 09:20, Marc Zyngier <maz@kernel.org> wrote:
>
> There's a bizarre or'ing of a 0 with the guest's ICH_HCR_EL2's
> value, which is a leftover from the host workaround merging
> code. Just kill it.
>
> Fixes: ca30799f7c2d0 ("KVM: arm64: Turn vgic-v3 errata traps into a patched-in constant")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  arch/arm64/kvm/vgic/vgic-v3-nested.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> index bf37fd3198ba7..40f7a37e0685c 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> @@ -323,10 +323,9 @@ static void vgic_v3_create_shadow_state(struct kvm_vcpu *vcpu,
>                                         struct vgic_v3_cpu_if *s_cpu_if)
>  {
>         struct vgic_v3_cpu_if *host_if = &vcpu->arch.vgic_cpu.vgic_v3;
> -       u64 val = 0;
>         int i;
>
> -       s_cpu_if->vgic_hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2) | val;
> +       s_cpu_if->vgic_hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
>         s_cpu_if->vgic_vmcr = __vcpu_sys_reg(vcpu, ICH_VMCR_EL2);
>         s_cpu_if->vgic_sre = host_if->vgic_sre;
>
> --
> 2.47.3
>
>
