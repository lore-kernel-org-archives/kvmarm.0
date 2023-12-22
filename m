Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775D13219D
	for <kvmarm@lists.linux.dev>; Fri, 22 Dec 2023 23:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IuXVLwr9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703286289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hXe/8VtmdvUr+lm0RVr5Ij0UYLvS5yHTZ9FlnC77NOQ=;
	b=IuXVLwr9YD4pfNPqC+cwglv9FOAjqz7Ls70mWKvnoNVve8vG2Q+zh5y+JTcsf8IEurkIBj
	YKANTNiwkMRb5232ZBG2zgQjIoowwk+7hyldVcwFZgbuiG3hb1/3JaKaMCdp3o026F9pkE
	G86XNf7QzHvzUsMfNEi7yCd5GoMKuJk=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-wIdUeGroNSCHOx0WZswJFQ-1; Fri, 22 Dec 2023 18:04:48 -0500
X-MC-Unique: wIdUeGroNSCHOx0WZswJFQ-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3bb6d341ed9so2770021b6e.3
        for <kvmarm@lists.linux.dev>; Fri, 22 Dec 2023 15:04:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703286287; x=1703891087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hXe/8VtmdvUr+lm0RVr5Ij0UYLvS5yHTZ9FlnC77NOQ=;
        b=Vf/QbuVdo44QRem+BUZtavVAD2QxsP7wdtyO1/Vk0VjSHSZ498BMclXSbyurgNUchf
         adijqEE5gwb5BtvrcOqDpT7Z2S40e24K95ZDsX81wR4bLOIgU3aSzH39VG6EFbrzs7aD
         D8/lLLf/0XkTXnSpOXOnb/wtEd6vU16Iosgxp9E1/MSpqZwYtFu1575rsnqnxiXw486O
         JLi+qR7VTH1ml7ktGObJcD8UgseWGoklGPAgnZDJ61jBIjC/P1Uo9w4rB31ZpZ4wsoQG
         Zg3TI/XUltqA2dDMaQILIroqZ8/ee7RPIF7bKHPFCDmsVLC3d/7bDCcHzmfrvSK/Mv8f
         IKNw==
X-Gm-Message-State: AOJu0YwwNyrUe//xmZtIWFtQIf/hXMm9A6T2D/v8ggCpw7Kcx3WFrz+9
	Yoqnt7j1wHJjWg7faqNxG2UjrWFE2aK4Eyx6p5TXpYMy2E273FhCBRRKqdS7YWScjROvXcxfEi0
	LvLRrw2KXGeRUoxepqQ+EHPB195CI9Hcy4m7ianQCjAOZfim+
X-Received: by 2002:a05:6808:ec3:b0:3ba:11ee:ac78 with SMTP id q3-20020a0568080ec300b003ba11eeac78mr2374139oiv.102.1703286287289;
        Fri, 22 Dec 2023 15:04:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG4n5fs9DVhrOTLY0NXUBQC6fd9G3OPJbvjYm49U+Dc3LtMyfHjP0OdGy0TQQ5MqyNe9DlymV8mfbV9utYg2OA=
X-Received: by 2002:a05:6808:ec3:b0:3ba:11ee:ac78 with SMTP id
 q3-20020a0568080ec300b003ba11eeac78mr2374131oiv.102.1703286287057; Fri, 22
 Dec 2023 15:04:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZYCaxOtefkuvBc3Z@thinky-boi>
In-Reply-To: <ZYCaxOtefkuvBc3Z@thinky-boi>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 23 Dec 2023 00:04:34 +0100
Message-ID: <CABgObfYyPcKAhuWFNPfbtYyVizW256SZe2HJctm-Wqz5FptqKw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.7, part #2
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 18, 2023 at 8:17=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Paolo,
>
> Here's the second batch of fixes for 6.7. Please note that this pull
> is based on -rc4 instead of my first fixes tag as the KVM selftests
> breakage was introduced by one of my changes that went through the
> perf tree.
>
> Please pull.

Pulled, thanks.

Paolo

>
> --
> Thanks,
> Oliver
>
> The following changes since commit 33cc938e65a98f1d29d0a18403dbbee050dcad=
9a:
>
>   Linux 6.7-rc4 (2023-12-03 18:52:56 +0900)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.7-2
>
> for you to fetch changes up to 0c12e6c8267f831e491ee64ac6f216601cea3eee:
>
>   KVM: selftests: Ensure sysreg-defs.h is generated at the expected path =
(2023-12-12 16:49:43 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.7, part #2
>
>  - Ensure a vCPU's redistributor is unregistered from the MMIO bus
>    if vCPU creation fails
>
>  - Fix building KVM selftests for arm64 from the top-level Makefile
>
> ----------------------------------------------------------------
> Marc Zyngier (5):
>       KVM: arm64: vgic: Simplify kvm_vgic_destroy()
>       KVM: arm64: vgic: Add a non-locking primitive for kvm_vgic_vcpu_des=
troy()
>       KVM: arm64: vgic: Force vcpu vgic teardown on vcpu destroy
>       KVM: arm64: vgic: Ensure that slots_lock is held in vgic_register_a=
ll_redist_iodevs()
>       KVM: Convert comment into an assertion in kvm_io_bus_register_dev()
>
> Oliver Upton (1):
>       KVM: selftests: Ensure sysreg-defs.h is generated at the expected p=
ath
>
>  arch/arm64/kvm/arm.c                 |  2 +-
>  arch/arm64/kvm/vgic/vgic-init.c      | 47 ++++++++++++++++++++++--------=
------
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c   |  4 ++-
>  arch/arm64/kvm/vgic/vgic.h           |  1 +
>  tools/testing/selftests/kvm/Makefile | 26 ++++++++++++--------
>  virt/kvm/kvm_main.c                  |  3 ++-
>  6 files changed, 52 insertions(+), 31 deletions(-)
>

