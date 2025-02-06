Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC1D22616F
	for <kvmarm@lists.linux.dev>; Thu,  6 Feb 2025 09:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738834767; cv=none; b=DC6XkosDu6VbTAYZOjwJ8kb6R/0WwBs1jGQtno8mhCSX5sMCy4SivtrN4ogDhtnfMlgs3fYtuyhyxfUgof6dHERIWEiXQywGFeStxaBaJZxf8ujBBvQWiP89cnBO/zSELTZFdyWAcDMPqGzDBwbRxV3aHFf3Ldmz/49HlMfLv58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738834767; c=relaxed/simple;
	bh=gHZyVt/xSbXZtV8kcHlEOIKgq/QQx2RvyNdyyAQthno=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oocK7vvJ4LZG+UFERvKsjYzYRH1AktPcSWnUxBIMZYSDIbrwCO2ZguLnCWBo/aq8cULd/q7UQFE3DdVJMGKH8hlcufD1er0nHrWunG7BhCFTz4eU3/71vEACoqviN6oqm3+V4+3hSJj6obWe8gNnudFzNEZpWZ3Ch8DQ6Qx7cDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UDWVcYYj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UDWVcYYj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738834764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zK/6lQqcEYL/R1meCPdVrlsxMHj74L1KpqoscZburOw=;
	b=UDWVcYYjuO9r4NRwiGtQWuWYqzCQnPegseOgjlIofjtAX8Ec+de2VTU8HWqd8WS1b44nxf
	cwn8FIm/qDqzLVKw4p+CL/Zca3PR5rab+FgXr1ecIIXFgTHwGvw5BrU37avZiaBpUzS9gB
	qOd1/uORsSleF27EWNyLp3+USR0cxJY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-xaUjC8BYN9O9jWc_T47MlA-1; Thu, 06 Feb 2025 04:39:23 -0500
X-MC-Unique: xaUjC8BYN9O9jWc_T47MlA-1
X-Mimecast-MFC-AGG-ID: xaUjC8BYN9O9jWc_T47MlA
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38dbe7b6087so250753f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 06 Feb 2025 01:39:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738834762; x=1739439562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zK/6lQqcEYL/R1meCPdVrlsxMHj74L1KpqoscZburOw=;
        b=ZqHM1KwL6Klicl4M/ViiyQ4srXndBLhVQlNdG5S2mztdU5BBOkrGdUCPWZsRtiR60v
         9HOZfhsOBn2yVTLC8ekv8VHwlVGFQgWDXUbvEYWXvG30B2b5EJb16yKMxa+rBx34cM4Z
         9QoljflqAcPQt5F5rOTSyZpTGu8Z4y63l+iiU/ZY5gXuH5swdnLp0/MwRuY6JDw570QJ
         IgffzeQlxOQkz81maTywvwjHf37KOMUel2D7FoE4HSUcTrwKIsGK/rqHVttJ4VOnoFJ1
         +KKeZO+Ak80yAtwqxNW81WP8/+gccFoIP3NOybjcwMODWDXtJffWRS1/YkIiczEkyFab
         eJYQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2B/wY9/B7hd5vWok1wJF14gQmoXfSocXEGaqMQGanxw0r3EKWMKhJdM3B8wws72RhbtxbTlw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwhZJc6x8sQAGDXxDCoDwljjAxSjdcAXl+L9aQ1e7ksVdhrE249
	uZUdvFYmz2VqeZ9fansLE2ajXU4XbFV/GDsD6tz5zFqFGj7+zjwFFiX7cfLsPvbXDixDN5nH01Q
	wqTrDuS2oICcDj+XNBywBfEu0x2DcHmNfqvVmUoPLo6kbHFHEiZ3+nYOHNzDwHZA+EwvjVS7iXO
	XiwNOS2vArDV9GRfYJ6cG7aguK7lZO
X-Gm-Gg: ASbGncvpnPUWVChoAgikcQbLh7Mh0RpY0sRxIOJ4Q3yaDVWa80fEn6kGXSVfDgIwyXl
	jHY6KF0n7g2XwF7uk261VaNgSQ9nUofb4YiKvPekUSC3oSHB5Xgrrx8sKR5gq
X-Received: by 2002:a5d:6da8:0:b0:38a:a11e:7af6 with SMTP id ffacd0b85a97d-38db48a92bbmr4538305f8f.6.1738834761939;
        Thu, 06 Feb 2025 01:39:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFpew+3VV/qOv0PNC07nCRiS2S9+c5C+JNNGHJrfpdky5+B8ifZWgPwO9qowgfQ/usuET5m5ZbGL4B3N12rG2g=
X-Received: by 2002:a5d:6da8:0:b0:38a:a11e:7af6 with SMTP id
 ffacd0b85a97d-38db48a92bbmr4538285f8f.6.1738834761541; Thu, 06 Feb 2025
 01:39:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250204155656.775615-1-maz@kernel.org>
In-Reply-To: <20250204155656.775615-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 6 Feb 2025 10:39:10 +0100
X-Gm-Features: AWEUYZno2kuDpIE83k3643TzUSKf5V_RnzWbIr0C8_DMiPc6ZkU3_VvAeoPh5cU
Message-ID: <CABgObfaY9iXAj8QVn0keEpuLR6Fe0z3NLNdx2COnbgDGTLX7sQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.14, take #1
To: Marc Zyngier <maz@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Dmytro Terletskyi <dmytro_terletskyi@epam.com>, 
	Fuad Tabba <tabba@google.com>, Lokesh Vutla <lokeshvutla@google.com>, 
	Mark Brown <broonie@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>, Wei-Lin Chang <r09922117@csie.ntu.edu.tw>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: I-lpwzPxCJsKJhCB-RWpHp_ien4vPnmtg_nqhJhUlUI_1738834762
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 4, 2025 at 4:57=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> This is the first set of KVM/arm64 fixes for 6.14, most of them
> addressing issues exposed by code introduced in the merge window
> (timers, debug, protected mode...). Details in the tag, as usual.
>
> Please pull,

Done, thanks.

Paolo

>
>         M.
>
> The following changes since commit 01009b06a6b52d8439c55b530633a971c13b6c=
b2:
>
>   arm64/sysreg: Get rid of TRFCR_ELx SysregFields (2025-01-17 11:07:55 +0=
000)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.14-1
>
> for you to fetch changes up to 0e459810285503fb354537e84049e212c5917c33:
>
>   KVM: arm64: timer: Don't adjust the EL2 virtual timer offset (2025-02-0=
4 15:10:38 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.14, take #1
>
> - Correctly clean the BSS to the PoC before allowing EL2 to access it
>   on nVHE/hVHE/protected configurations
>
> - Propagate ownership of debug registers in protected mode after
>   the rework that landed in 6.14-rc1
>
> - Stop pretending that we can run the protected mode without a GICv3
>   being present on the host
>
> - Fix a use-after-free situation that can occur if a vcpu fails to
>   initialise the NV shadow S2 MMU contexts
>
> - Always evaluate the need to arm a background timer for fully emulated
>   guest timers
>
> - Fix the emulation of EL1 timers in the absence of FEAT_ECV
>
> - Correctly handle the EL2 virtual timer, specially when HCR_EL2.E2H=3D=
=3D0
>
> ----------------------------------------------------------------
> Lokesh Vutla (1):
>       KVM: arm64: Flush hyp bss section after initialization of variables=
 in bss
>
> Marc Zyngier (4):
>       KVM: arm64: Fix nested S2 MMU structures reallocation
>       KVM: arm64: timer: Always evaluate the need for a soft timer
>       KVM: arm64: timer: Correctly handle EL1 timer emulation when !FEAT_=
ECV
>       KVM: arm64: timer: Don't adjust the EL2 virtual timer offset
>
> Oliver Upton (2):
>       KVM: arm64: Flush/sync debug state in protected mode
>       KVM: arm64: Fail protected mode init if no vgic hardware is present
>
>  arch/arm64/kvm/arch_timer.c        | 49 +++++++++-----------------------=
------
>  arch/arm64/kvm/arm.c               | 20 ++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 24 +++++++++++++++++++
>  arch/arm64/kvm/nested.c            |  9 +++----
>  arch/arm64/kvm/sys_regs.c          | 16 ++++++++++---
>  5 files changed, 73 insertions(+), 45 deletions(-)
>

