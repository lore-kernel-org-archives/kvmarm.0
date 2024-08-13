Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B45F433B9
	for <kvmarm@lists.linux.dev>; Tue, 13 Aug 2024 10:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723543629; cv=none; b=qHktvVaIzK1CVp3IP0aM8allpfLP8np0Hm1q+3Pm22A2E5H/5qZ/kqzXhLB0vkZGxaJJ2Y/WpAV+vc7hwoyB1S5UjNW4UdBkjNQ5GzRk7ehU3q368HQMhFB4Gb1n+2AnV79IfpBS5ttM8LOnCmA/rrjmNkw+WnOadH4GDWig3S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723543629; c=relaxed/simple;
	bh=OpU1+ywTBKCCT1UVkJHl2CzzFHTxAXlIpSi9zVut8Ow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UiEobnCjfAmBAZ4I3tu+6BJ4gWm2m6fFZVUSSJsiqBGyfc0ryFCJmK+pFsW+sKBMb7jy8GltztW2mUimN0uQXREwGmdAYqmo6Frf5dI9TAFac+klIDszOWws0KZ9nrQUFQPetW3maSI4D745TO/Hyi6WItTL2qTIKzKZZCk3YfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=haWuzjqh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="haWuzjqh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723543626;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZdGpFIJhXUbfoxC6RL3l2LvGdIi9u4emfZaadOLgiuo=;
	b=haWuzjqhFIFX+T+PavrDFVrAFwZx2qUnJ7QbYLqvTekbH+HLbslH9kozFs5sVOhk6kPBf/
	6SY0sdFydgIhtpPuq+MdTxnN3surD5RNuVFRigmP3tQX9h0KWqOii2V4wxQOwb6sGNKfHp
	LAu7NiYcdrueMaXjPFS/cMwOApQvPr0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-UpzdPk49PHWiqqm0KgriTg-1; Tue, 13 Aug 2024 06:07:04 -0400
X-MC-Unique: UpzdPk49PHWiqqm0KgriTg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3685e0df024so3071624f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 13 Aug 2024 03:07:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723543623; x=1724148423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZdGpFIJhXUbfoxC6RL3l2LvGdIi9u4emfZaadOLgiuo=;
        b=xIqfEIfFfPEpDgAC78yBsW7D5Fm/XTORTL8JpwEHBe6eRj0kRX3Sn9jqzcULW/ODkB
         hdxYSHKkpRfL4SefqO1vwWVlCPObPdMgzCQMaw3PuCRRNWsFhyhSLT/jTLR0KlpTXpUZ
         HzUNz9trHQydWZRRCeJMp587zwPHKv+qn+qmN2KFL22HWkmumzXmtNWKSN/jLT9tvI1S
         yXG8zybnE6a/DRAXsQ6ceNe0EX5yeuKIEUVBcIM6259HKXRPPdF3mBtneHN7LPz4OX8l
         jKqUxcnU+1k1ysbZCF6pLLjhbB/mRLWvOEYFe7RXQlyR50GJQDqepPhatNJ6OYt4nwd2
         inaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrXKBvqma/B130bEsLwxD8t6u23BdDRhNXNXRQSrBjN0PzZHNEM69yaDvUJyGNVLHox7zkgOJeuBA3DQ3/YzzpQcMVexUq
X-Gm-Message-State: AOJu0YzP6MxycKeTcC77fTL/mOHvNfaEl5lWj4QPtdLeN60gQpinSpP6
	XjTd/4iCH18kyPg5xRxx2S9/zP/LdBC7isj1u+QRAWHi/AjXIosclHwDnHWZg1hUpG1jaJy9FEU
	kyIIszDArMHXbPU2YTsi9QDzff3zENwp6aoF+O18sMH5HXxrNcHEbIGTRbN050030xB6GLjjmcv
	vXQ/L7NZ8FOMsRy0uKUuUctMDJeV8x
X-Received: by 2002:a05:6000:45:b0:366:ebd1:3bc1 with SMTP id ffacd0b85a97d-3716ccd71aemr1739829f8f.3.1723543622994;
        Tue, 13 Aug 2024 03:07:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDvTUTDd+LsRhjmB6zNVog1K4fVcAdlK3qvWE8ZDFz2Q/6hzL0KTKDRwibjwzk8bnEf5C27ISqUKXY48zo5Zg=
X-Received: by 2002:a05:6000:45:b0:366:ebd1:3bc1 with SMTP id
 ffacd0b85a97d-3716ccd71aemr1739813f8f.3.1723543622487; Tue, 13 Aug 2024
 03:07:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZrXPY7yIG0eu8mQU@linux.dev>
In-Reply-To: <ZrXPY7yIG0eu8mQU@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 13 Aug 2024 12:06:51 +0200
Message-ID: <CABgObfa=AL_+-oYAAOYM+gbS=UXnoBfsroohB5B+b1g4cvoJbg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.11, round #1
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Alexander Potapenko <glider@google.com>, Mark Brown <broonie@kernel.org>, 
	Fuad Tabba <tabba@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Takahiro Itazuri <itazur@amazon.com>, Sebastian Ott <sebott@redhat.com>, 
	Danilo Krummrich <dakr@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 9, 2024 at 10:12=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Paolo,
>
> Decent bit of fixes this time around. The most noteworthy among these
> is probably Marc's vgic fix that closes a race which can precipitate a
> UAF, as seen w/ syskaller.
>
> Please pull.

Pulled, thanks.

Paolo

> --
> Thanks,
> Oliver
>
> The following changes since commit 8400291e289ee6b2bf9779ff1c83a291501f01=
7b:
>
>   Linux 6.11-rc1 (2024-07-28 14:19:55 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.11-1
>
> for you to fetch changes up to 9eb18136af9fe4dd688724070f2bfba271bd1542:
>
>   KVM: arm64: vgic: Hold config_lock while tearing down a CPU interface (=
2024-08-08 16:58:22 +0000)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.11, round #1
>
>  - Use kvfree() for the kvmalloc'd nested MMUs array
>
>  - Set of fixes to address warnings in W=3D1 builds
>
>  - Make KVM depend on assembler support for ARMv8.4
>
>  - Fix for vgic-debug interface for VMs without LPIs
>
>  - Actually check ID_AA64MMFR3_EL1.S1PIE in get-reg-list selftest
>
>  - Minor code / comment cleanups for configuring PAuth traps
>
>  - Take kvm->arch.config_lock to prevent destruction / initialization
>    race for a vCPU's CPUIF which may lead to a UAF
>
> ----------------------------------------------------------------
> Danilo Krummrich (1):
>       KVM: arm64: free kvm->arch.nested_mmus with kvfree()
>
> Fuad Tabba (1):
>       KVM: arm64: Tidying up PAuth code in KVM
>
> Marc Zyngier (2):
>       KVM: arm64: Enforce dependency on an ARMv8.4-aware toolchain
>       KVM: arm64: vgic: Hold config_lock while tearing down a CPU interfa=
ce
>
> Mark Brown (1):
>       KVM: selftests: arm64: Correct feature test for S1PIE in get-reg-li=
st
>
> Sebastian Ott (3):
>       KVM: arm64: fix override-init warnings in W=3D1 builds
>       KVM: arm64: fix kdoc warnings in W=3D1 builds
>       KVM: arm64: vgic: fix unexpected unlock sparse warnings
>
> Takahiro Itazuri (1):
>       docs: KVM: Fix register ID of SPSR_FIQ
>
> Zenghui Yu (1):
>       KVM: arm64: vgic-debug: Exit the iterator properly w/o LPI
>
>  Documentation/virt/kvm/api.rst                     |  2 +-
>  arch/arm64/include/asm/kvm_ptrauth.h               |  2 +-
>  arch/arm64/kvm/Kconfig                             |  1 +
>  arch/arm64/kvm/Makefile                            |  3 +++
>  arch/arm64/kvm/arm.c                               | 15 +++++----------
>  arch/arm64/kvm/hyp/include/hyp/switch.h            |  1 -
>  arch/arm64/kvm/hyp/nvhe/Makefile                   |  2 ++
>  arch/arm64/kvm/hyp/nvhe/switch.c                   |  5 ++---
>  arch/arm64/kvm/hyp/vhe/Makefile                    |  2 ++
>  arch/arm64/kvm/nested.c                            |  2 +-
>  arch/arm64/kvm/vgic/vgic-debug.c                   |  5 +++--
>  arch/arm64/kvm/vgic/vgic-init.c                    |  3 +--
>  arch/arm64/kvm/vgic/vgic-irqfd.c                   |  7 ++++---
>  arch/arm64/kvm/vgic/vgic-its.c                     | 18 +++++++++++-----=
--
>  arch/arm64/kvm/vgic/vgic-v3.c                      |  2 +-
>  arch/arm64/kvm/vgic/vgic.c                         |  2 +-
>  arch/arm64/kvm/vgic/vgic.h                         |  2 +-
>  tools/testing/selftests/kvm/aarch64/get-reg-list.c |  4 ++--
>  18 files changed, 42 insertions(+), 36 deletions(-)
>

