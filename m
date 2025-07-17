Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD6C2F7D15
	for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 15:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752765040; cv=none; b=lZBujFKRYZU14DmeaM9Hj4csau+yuUN3EBH1JQmXvtG/AAv7cpui7ATf9R7p9wBDmk2vBAtWjkCfnH16cx+3NiZuVI+b2G/Ob3jOKEn60Fj2y0pkkblHZhksj1rLM16tYpqfca3ZAKeJC0PuJsduPbMR/iWSXNrgHW67stAwjh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752765040; c=relaxed/simple;
	bh=poCj92+UAzU5WvbVhRNoWdrEAB1GWQRAmRpltnsXCfM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EcU6cIwBL8jPGmVO7+DK19Vu3S47B8jpNlZrUeHIExNIOfgrboxeCIFRNPf5iN8kBApGEWpQMUfpmKTX4LyVHDuYezNQdtqPlZIiL6TQKWPYr4hnpcH4k1VPqxD0UTbXW3dF2kN5MyImKoE6kWuuWzYAxMHYUwc1++yNAfUSkUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ADHc4XZQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ADHc4XZQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752765037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SEjYoBcwqDptwkNDt9J1x/LYBRGTVclbAUkgXREtLhI=;
	b=ADHc4XZQljoNFevHZP8H0bx1aTzMM+31EqZFc3zREluiWfw7ud5XW9vjNgC5MCYunBcf30
	eF0mdSk9qXqaNwJlw4SFe6fT5mSv+4xr9UpQaRImjdNuIMeT3TZFcDIys8CVobZSscqVZs
	U0felrOTeGYY7ehrb27OvqCWBtk65uc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-m69irDEkM_6LlDpno-jzYA-1; Thu, 17 Jul 2025 11:10:36 -0400
X-MC-Unique: m69irDEkM_6LlDpno-jzYA-1
X-Mimecast-MFC-AGG-ID: m69irDEkM_6LlDpno-jzYA_1752765035
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45611579300so7425995e9.0
        for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 08:10:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752765034; x=1753369834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SEjYoBcwqDptwkNDt9J1x/LYBRGTVclbAUkgXREtLhI=;
        b=nOi0cio/Fg9GeMK3MJe7ZGDrUOF+hiJM2wcdCcBnUacS1d+N5qY/Jt2AcLENDIhmtt
         cUcZXof4OiJCjurT1UB2ppzx3i4p5bMvTJOWKKsIsy4Cntw4In9F/diTHZTw+F18F/Ky
         oup46Po8R/WjUZJNKsFeOpoBPEt1Ho/ODVVe3tQAAw14mX0NU3r/jVKVSOyerYA7XLd9
         F/yJI1ExUhuQ3gSvhq25sZGKnFumzo7+LOTa3A333sX6Xap7mI8a3vki84TLiYodDtzm
         8q+RlJs+1n/A8i9EAz/+NpS+gNHsene+9iwL9hGEedH3EQHi4vkhfictc9xlddWx0ynA
         N9hg==
X-Forwarded-Encrypted: i=1; AJvYcCW49TT1i9P6wOmQOzob6gR6TAgeA74ZUD8GGdfpqRPQ0kQEfxAGUcMVEm1C0PjclUvOEfhrAV0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwGZNLyz3SW6Fmhangxcec7DKJSWr1sf8iZVhGcdXA8uQe04pV7
	UxyzmcreVN94P2d5iimOcmwswuEg1Peb5YJ7qSKub0NmCkm4EeWXAVXvAQIZqpoW1uZLD7fAG0N
	vnAelnY7kRoRQsoFN+KR7ox6flQmgeH30QEgpACshyLL5NMIw5bYuJoV4lTMu1pTKgZpobarhdq
	e64aXuvuIMI7q/LOr12bAVvZCUnSMg0u+9
X-Gm-Gg: ASbGncvSC+t6SdWr2k3aKJdmE7k9+fjsC9hedmCI1XBOwM9Ef/A+3jDu+DtkOE4sPgN
	X1rn8nxL8QCmVzWBrqj+rC691OU8QZIEpvI3iA5CJAS79jvmpp6cKI8EPFh6T+PQVeO/8NlLbkw
	TDLAQxq+EoxvDwyAPR25k0
X-Received: by 2002:a05:600c:8206:b0:456:1ac8:cac8 with SMTP id 5b1f17b1804b1-456389d8648mr20322695e9.15.1752765034256;
        Thu, 17 Jul 2025 08:10:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqFKu12WNYkyuv+EBrH40VIjm3DSpAGBvOZK5BRr1yGNQvSYPEChTjgLpLHbHmtfrETxQh9JFrb2OtUf6QmQA=
X-Received: by 2002:a05:600c:8206:b0:456:1ac8:cac8 with SMTP id
 5b1f17b1804b1-456389d8648mr20322395e9.15.1752765033769; Thu, 17 Jul 2025
 08:10:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250711084835.2411230-1-maz@kernel.org>
In-Reply-To: <20250711084835.2411230-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 17 Jul 2025 17:10:21 +0200
X-Gm-Features: Ac12FXzzA7dEcA7kGiq4t8H3V98DgvDEFcCmXVWP7oItkogbslxByYn5IOuKZ9c
Message-ID: <CABgObfbEXvmbSFdku=bRKaB+1Pe9g_7ZuVmy-vmgJwUczA99cg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.16, take #6
To: Marc Zyngier <maz@kernel.org>
Cc: Ben Horgan <ben.horgan@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a5KAYEo4PxpHL7OuFxmHfjzT3JJyUGyAXhCltyyisv0_1752765035
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025 at 10:49=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Paolo,
>
> Here the (hopefully) last fix for 6.16, addressing what can adequately
> be called a brain fart in dealing with the sanitisation of the number
> of PMU registers in nested virt.
>
> Please pull,
>
>         M.
>
> The following changes since commit 42ce432522a17685f5a84529de49e555477c0a=
1f:
>
>   KVM: arm64: Remove kvm_arch_vcpu_run_map_fp() (2025-07-03 10:39:24 +010=
0)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.16-6
>
> for you to fetch changes up to 2265c08ec393ef1f5ef5019add0ab1e3a7ee0b79:
>
>   KVM: arm64: Fix enforcement of upper bound on MDCR_EL2.HPMN (2025-07-09=
 13:19:24 +0100)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.16, take #6
>
> - Fix use of u64_replace_bits() in adjusting the guest's view of
>   MDCR_EL2.HPMN.
>
> ----------------------------------------------------------------
> Ben Horgan (1):
>       KVM: arm64: Fix enforcement of upper bound on MDCR_EL2.HPMN
>
>  arch/arm64/kvm/sys_regs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

