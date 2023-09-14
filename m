Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20FD28E32
	for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 15:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694704020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6SQ8P9dIo86mGdYMXEQK4IXZZmN0xP5iEUDVuGzb4As=;
	b=FsZ/NwkgMDrKBG7mK43Lnww0Dcf7BWAEGCcjNJt3wC79eeCehnWN8UjmhQXyhSoxYC+Eau
	RHXNYIGRKUNdDueyiaZxl3hgsk3go/EvPl/hZU7RIpvgDmIE16yF+l58eVE+fIPVMFtd1p
	rdg4hX4qrhOfctiJOqvovzeDzS10Dsw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-wedAhwoMNmyyHvx_SNYzaA-1; Thu, 14 Sep 2023 11:06:57 -0400
X-MC-Unique: wedAhwoMNmyyHvx_SNYzaA-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-76efd8bf515so155853285a.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 08:06:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694704017; x=1695308817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6SQ8P9dIo86mGdYMXEQK4IXZZmN0xP5iEUDVuGzb4As=;
        b=BsSq/iYhqcdJGXdWileE2DAAkAd5pnVEmN6zNPvQ3tfR4N5S5ByJIjpFJEvTE/PoAx
         kMzLIWdkBbwgAT2WbLHZhtWeixJ3/i0Ep8mEd27Ywu0UN/JsmMSlEoTM+Hp9mjD6yNnR
         zRRaXbJioAz0tE9sQ+T3WGMqOFZLSmQtzzQBZAMTJ3Fd6JyKGmnPzixcEt7XUbDYxbIf
         IUt5TlclDrah/TxN09lRRmj4HpEGkvJKSdxfG+iUxlUI5W+izLkZF3xmOJGlBamMfEix
         WVsiUDnxHKu4pMTYE6Xewtb+aCHquqyqnod1WSijem2PSouLj81aDAK3NElv/Hvb2ugJ
         SqDw==
X-Gm-Message-State: AOJu0YwjVd9WQxRU2NLwu1lm3WOE6kty4fo8U23VpZ36k9gzAgwYE26T
	LYfJkWUwHzIQByslJTgWP27xKXWHRAyt+Qwn1cmHlb7xPYk6BTQMFIv0XvhHVcTvnRB87Td6sqQ
	PumXOGiiG7dKuBxWnVQzNmi/5LeMjWENW
X-Received: by 2002:a05:620a:394c:b0:76e:f7f3:723e with SMTP id qs12-20020a05620a394c00b0076ef7f3723emr2511744qkn.38.1694704016760;
        Thu, 14 Sep 2023 08:06:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGr5GWcNmJQqe0VBfr6DB/4guT1vGO8AReywmKm2vd5XigC6NeS7B46k887wY3VGiqerPvT3lVSVi0vWsHoqlY=
X-Received: by 2002:a05:620a:394c:b0:76e:f7f3:723e with SMTP id
 qs12-20020a05620a394c00b0076ef7f3723emr2511720qkn.38.1694704016470; Thu, 14
 Sep 2023 08:06:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230914144802.1637804-1-maz@kernel.org>
In-Reply-To: <20230914144802.1637804-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 14 Sep 2023 17:06:43 +0200
Message-ID: <CABgObfarGB50ZCUdLWLeTGFV+7Z8iriv1B61KaTX-1RnXRtJ7A@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.6, take #1
To: Marc Zyngier <maz@kernel.org>
Cc: Ben Horgan <ben.horgan@arm.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Vincent Donnefort <vdonnefort@google.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 14, 2023 at 4:48=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Here's the first set of fixes for 6.6, addressing two regressions: use
> of uninitialised memory as a VA to map the GICv2 CPU interface at EL2
> stage-1, and a SMCCC fix covering the use of the SVE hint.
>
> Please pull.,

Done, thanks.

Paolo

>         M.
>
> The following changes since commit 0bb80ecc33a8fb5a682236443c1e740d5c917d=
1d:
>
>   Linux 6.6-rc1 (2023-09-10 16:28:41 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.6-1
>
> for you to fetch changes up to 373beef00f7d781a000b12c31fb17a5a9c25969c:
>
>   KVM: arm64: nvhe: Ignore SVE hint in SMCCC function ID (2023-09-12 13:0=
7:37 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.6, take #1
>
> - Fix EL2 Stage-1 MMIO mappings where a random address was used
>
> - Fix SMCCC function number comparison when the SVE hint is set
>
> ----------------------------------------------------------------
> Jean-Philippe Brucker (1):
>       KVM: arm64: nvhe: Ignore SVE hint in SMCCC function ID
>
> Marc Zyngier (1):
>       KVM: arm64: Properly return allocated EL2 VA from hyp_alloc_private=
_va_range()
>
>  arch/arm64/include/asm/kvm_hyp.h      | 2 +-
>  arch/arm64/kvm/hyp/include/nvhe/ffa.h | 2 +-
>  arch/arm64/kvm/hyp/nvhe/ffa.c         | 3 +--
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S    | 1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c    | 8 ++++++--
>  arch/arm64/kvm/hyp/nvhe/psci-relay.c  | 3 +--
>  arch/arm64/kvm/mmu.c                  | 3 +++
>  include/linux/arm-smccc.h             | 2 ++
>  8 files changed, 16 insertions(+), 8 deletions(-)
>

