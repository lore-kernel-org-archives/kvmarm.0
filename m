Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FA71F61F
	for <kvmarm@lists.linux.dev>; Fri,  8 Dec 2023 18:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fFvNqzqc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702059140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/TkwU2denrfJVnTiAIr/mTvHxt1y7el//yhAIkwpoKI=;
	b=fFvNqzqcsyyjKH4iPJvkc881fjGtkS+GhKaGqzVgvofYH/nCIT1IAJGFiKYt1PSVId8uJk
	WQvbdK7kR1872zcyBiTPfKVJbFE1af2VsGUYd/TgYLpsbkr/JcaQmHFzSQBp2AQ3qjAj0Y
	KCCgkxiYdhJP5WSIvzEYtDA+p1iJTgw=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-qjIsQmxmOPuvvnWNxjrPiw-1; Fri, 08 Dec 2023 13:12:19 -0500
X-MC-Unique: qjIsQmxmOPuvvnWNxjrPiw-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6d8647941eeso3174091a34.3
        for <kvmarm@lists.linux.dev>; Fri, 08 Dec 2023 10:12:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702059138; x=1702663938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/TkwU2denrfJVnTiAIr/mTvHxt1y7el//yhAIkwpoKI=;
        b=ATYfA4+y04dSa9AFVM5DRHPWmCSWsfBcjJ0kEXrNSU7h7v1RYDhXsM5z/6/j4xKQTU
         4RFobvjOPL1QyjqPETrNufRlS5Ds7//iI0qRdu15hffVmmx7UOSMEAMEj1dfaHO99wyn
         qW2/Y1ooOf90CoRdkEfWTu9eYPLLovXFjI6BPK9ZoZAmpdulLoChVAC/DHpVDmadzUYI
         uRcR/FSf6pwCbL0x+yT+spUqAszTVjvmfhcr6wFNnHeT5UMCZ/7/p1SGUwwsCJ4HayJ1
         h3bw0naoLu166n4pP36lXNqWuTcdTVmEN3IgZdmh6uDKRMK4fy1Gz2g85v3aYtJosdtF
         nuWg==
X-Gm-Message-State: AOJu0YxXM5X6sodmTUh5qk+JwuOpd5uNFWtgn/xhoaEIzGU1YXQuoHAQ
	fFpH+WZHLonyBl/eUb7huJA9CRu7AJUiiXmLF2UeOxWyVgF/fU9QlsZXCYoT8rspTCyHpzH95D1
	M6AqMljvJCIyKSygkGyZl0wEoRFwUjv0s
X-Received: by 2002:a05:6870:4728:b0:1fb:75a:de78 with SMTP id b40-20020a056870472800b001fb075ade78mr583896oaq.102.1702059138560;
        Fri, 08 Dec 2023 10:12:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG1dBdgMfiuSi5uz+rVRXvKDkpoT9HYByD4Nc2YMvjQiYfF5kVpiZ92tDqJoUOJ4qc/qdT3rZOFMba0vNgZ4z4=
X-Received: by 2002:a05:6870:4728:b0:1fb:75a:de78 with SMTP id
 b40-20020a056870472800b001fb075ade78mr583887oaq.102.1702059138295; Fri, 08
 Dec 2023 10:12:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZWufQneeJiBJLnPb@thinky-boi>
In-Reply-To: <ZWufQneeJiBJLnPb@thinky-boi>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 8 Dec 2023 19:12:05 +0100
Message-ID: <CABgObfbCy-9VpN+tOvXtS3RcA-M67Vwm7GmoBGmaG+0wrs1Eeg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.7, take #1
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Kunkun Jiang <jiangkunkun@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 2, 2023 at 10:19=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Paolo,
>
> Here's the first set of fixes for 6.7. There hasn't been very many
> interesting issues that have come up this cycle, so it is only a single
> patch this time around.
>
> Please pull :)

Pulled, thanks.

Paolo

> --
> Thanks,
> Oliver
>
> The following changes since commit b85ea95d086471afb4ad062012a4d73cd328fa=
86:
>
>   Linux 6.7-rc1 (2023-11-12 16:19:07 -0800)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.7-1
>
> for you to fetch changes up to 8e4ece6889a5b1836b6a135827ac831a5350602a:
>
>   KVM: arm64: GICv4: Do not perform a map to a mapped vLPI (2023-11-20 19=
:13:32 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.7, take #1
>
>  - Avoid mapping vLPIs that have already been mapped
>
> ----------------------------------------------------------------
> Kunkun Jiang (1):
>       KVM: arm64: GICv4: Do not perform a map to a mapped vLPI
>
>  arch/arm64/kvm/vgic/vgic-v4.c | 4 ++++
>  1 file changed, 4 insertions(+)
>

