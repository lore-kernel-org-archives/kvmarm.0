Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D33431133
	for <kvmarm@lists.linux.dev>; Wed, 17 May 2023 17:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684344963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=puQWJvhyxYukjytjCrrZQqa3KW6zW1mGsvpp553sZtw=;
	b=fUO3lmQDbBgUNVmUimCg0UQbCIlZTwN53d1ADDfKV8LR0EFY2ZAZ28zUo2Kz1dJAD/JG85
	o6LVpSXUhDm6LNRGTn0n4kL9CIunGDxV0/90j2vS8tOmmV1skHM07hYZz/4qqtRbuZ75xE
	bKbTAp4VWIpN7WGknpxDOXNMN1DllOM=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-3E-0MyyfOvmDO9gNcO61cQ-1; Wed, 17 May 2023 13:36:02 -0400
X-MC-Unique: 3E-0MyyfOvmDO9gNcO61cQ-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-780fcc24da9so363204241.0
        for <kvmarm@lists.linux.dev>; Wed, 17 May 2023 10:36:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684344961; x=1686936961;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=puQWJvhyxYukjytjCrrZQqa3KW6zW1mGsvpp553sZtw=;
        b=DYCOPlbWJQ94B7E6aqFXEHaZsKcoa3QCa2rD4AYnsnhsN5DvJrnpC5O9N3cinIvVvG
         3lJCF6CKDkPvTTMZ2bx6OM/PojXOrhLfaXAH6U0Mb9rES1uDt17O9VP8YM2abo17q8lZ
         hfSe6bJi7/eZ+Sp/JYOcU3bBhpz3LXr/wpInID3n9VElYhoK/wScFjZf++Q3QaBAWuIP
         K7r7U7mtPKfCKiVWmCvuMfByZdNqPA/USakoGZxLymCOZsig5p7sfedO1c4NDrAT10GN
         jqxsj5pICSqzGLByfjC21BSga4HzoQnQtd1Ib8ji+owHRkUsLO9ep7mWTCswXFOBIk9U
         i71g==
X-Gm-Message-State: AC+VfDz4HSpiiu3UOLZIihgLa5oAqDFgHj5N5h+5BCcyGIMNBRTyhx6+
	B4/ecxRYgPad4AbHMCU1Nt6pzxdbim6ugbH/LV8961XkFG5otcNv6E7iJOl9c5ZcEnym0SM2jDE
	gbETSO0QT1XsBAuxtrIfBqtPC6J40oR+B
X-Received: by 2002:a67:e988:0:b0:436:1e1:685e with SMTP id b8-20020a67e988000000b0043601e1685emr13994172vso.28.1684344961432;
        Wed, 17 May 2023 10:36:01 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5CBOO9lrZpm38AXv4U8EwjpqzO9e3cjzo4meH70K3KkFLoiIuh6P2clRvBZTGyw+vABcuwrE5EAB3pyttPA9c=
X-Received: by 2002:a67:e988:0:b0:436:1e1:685e with SMTP id
 b8-20020a67e988000000b0043601e1685emr13994153vso.28.1684344961140; Wed, 17
 May 2023 10:36:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230511143638.350228-1-maz@kernel.org>
In-Reply-To: <20230511143638.350228-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 17 May 2023 19:35:50 +0200
Message-ID: <CABgObfYAHbrPJuSHFum4kkeHSb1Msh0u3-6BoOUZVGX6wVd7OQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.4, take #1
To: Marc Zyngier <maz@kernel.org>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Jingyu Wang <jingyuwang_vip@163.com>, 
	Mark Brown <broonie@kernel.org>, Mukesh Ojha <quic_mojha@quicinc.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 11, 2023 at 4:37=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Here's a first set of fixes, most of which has been simmering in -next
> for some time now. The most important one is a series from Oliver,
> plugging a (hard to trigger) race that would result in the wrong
> mapping being established at S2.
>
> The rest is a bunch of cleanups and HW workarounds (the usual Apple
> vgic issue that keeps cropping up on new SoCs).
>
> Please pull,

Done, thanks.

Paolo

> The following changes since commit ac9a78681b921877518763ba0e89202254349d=
1b:
>
>   Linux 6.4-rc1 (2023-05-07 13:34:35 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.4-1
>
> for you to fetch changes up to c3a62df457ff9ac8c77efe6d1eca2855d399355d:
>
>   Merge branch kvm-arm64/pgtable-fixes-6.4 into kvmarm-master/fixes (2023=
-05-11 15:26:01 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.4, take #1
>
> - Plug a race in the stage-2 mapping code where the IPA and the PA
>   would end up being out of sync
>
> - Make better use of the bitmap API (bitmap_zero, bitmap_zalloc...)
>
> - FP/SVE/SME documentation update, in the hope that this field
>   becomes clearer...
>
> - Add workaround for the usual Apple SEIS brokenness
>
> - Random comment fixes
>
> ----------------------------------------------------------------
> Christophe JAILLET (2):
>       KVM: arm64: Slightly optimize flush_context()
>       KVM: arm64: Use the bitmap API to allocate bitmaps
>
> Jingyu Wang (1):
>       KVM: arm64: Fix repeated words in comments
>
> Marc Zyngier (4):
>       KVM: arm64: Constify start/end/phys fields of the pgtable walker da=
ta
>       KVM: arm64: vgic: Add Apple M2 PRO/MAX cpus to the list of broken S=
EIS implementations
>       Merge branch kvm-arm64/misc-6.4 into kvmarm-master/fixes
>       Merge branch kvm-arm64/pgtable-fixes-6.4 into kvmarm-master/fixes
>
> Mark Brown (3):
>       KVM: arm64: Document check for TIF_FOREIGN_FPSTATE
>       KVM: arm64: Restructure check for SVE support in FP trap handler
>       KVM: arm64: Clarify host SME state management
>
> Oliver Upton (2):
>       KVM: arm64: Infer the PA offset from IPA in stage-2 map walker
>       KVM: arm64: Infer PA offset from VA in hyp map walker
>
>  arch/arm64/include/asm/cputype.h        |  8 +++++++
>  arch/arm64/include/asm/kvm_pgtable.h    |  1 +
>  arch/arm64/kvm/fpsimd.c                 | 26 +++++++++++++--------
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++++--
>  arch/arm64/kvm/hyp/pgtable.c            | 41 +++++++++++++++++++++++++--=
------
>  arch/arm64/kvm/inject_fault.c           |  2 +-
>  arch/arm64/kvm/vgic/vgic-v3.c           |  4 ++++
>  arch/arm64/kvm/vmid.c                   |  7 +++---
>  8 files changed, 76 insertions(+), 25 deletions(-)
>

