Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7873EAC9B
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 10:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784110465; cv=none; b=HoXWL0UrqH9hNZY0zMtDhlfoZhyJ67t5Jkcqe4i4GY7dJZFtjC2MgpI8kJ9mERjfLStRQL9s3Z0FCYEe18kGFw8MYOODLvFQffr4rmeHILWPBPVzm5FknnAFYw45wK6aX227vUzpw5PoERvs38MDAybfvzahT9ll7dr+fpagK/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784110465; c=relaxed/simple;
	bh=bQhFfWQ2UxJga9eW4whcQbngDhCAqLTkvi+3GBBScv4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XNLw2HWR70cU8+tjI4LxKPr6vN09RHK4+di8lcidKP+O6Irn4iJVAh8YUN8dmPr+u5eQ8dyHiCLDpsCvav42nZ7dodcViDCxiweP9QpX5ddcZXxUUMl6P7GC3Q5JeLwrSMf8d6cDpaEXweNPbX+qhbyra8KqOAdonvVPGJdWq24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CCz7Lmqj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CCz7Lmqj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784110463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OTfS1o6FG2+VSRsM8RoeMYV4oV1nuMVaP/qPFLezgiM=;
	b=CCz7LmqjaBLeLgxGhJqmXaUUkUyu8fZ3koycP6UsOVGeab/4+X5XuOvCGST07T6hZEnX4x
	53AJZ1Cgv9a2C226HM0BQ33g9CPObAMW7BwXa2DIWJ9LRocHUzfyD5RV7+4fvj8nknjn88
	s5+MmTBkbngXe2MqVAFasfVK29afxi4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-c2jxRdaMOJKMUs9x5ZOs6Q-1; Wed, 15 Jul 2026 06:14:21 -0400
X-MC-Unique: c2jxRdaMOJKMUs9x5ZOs6Q-1
X-Mimecast-MFC-AGG-ID: c2jxRdaMOJKMUs9x5ZOs6Q_1784110461
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47dfc23ac71so4275768f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 03:14:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784110460; x=1784715260;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OTfS1o6FG2+VSRsM8RoeMYV4oV1nuMVaP/qPFLezgiM=;
        b=Jq6zNgoZqxb0EcF/DW4KQSwE6LoIesDs5HV7iwbVQhMSNnSjvXXJ/CBUBmB0CvJtaQ
         VsYpi2XpPv+gQ3V7nOwUssXfTTWItxVBIzslUrPyzIgC6gSjyGRCw7q6CooY/ZBbuNei
         ORPMMpDxbE5CKTyOJBrrac4e+sqnH3XW7r1oL0AA0HDIh3qrvSOONtsZRpsUbTYgAD83
         gzgY+HX3GljqZ1zOusnCn7OLYn6bisK6L6663WwZafZaq2Xh067k1l7070ii9c26MM8U
         2es2BGllxcfy0Q0dnNsThsfzsEis+s4XF+/T1UGwRCrQrshlifQAyg8tHfwvkNygUdn0
         9aag==
X-Forwarded-Encrypted: i=1; AHgh+Ro6PXt5Bh3W7eU+ulnSLtyRUg5W0p1JEwJ7l/Dy8kKinRWPp8xQtJ8+7mOBvnkq8J6p8qL/nuc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMYfsA7oaQrPv2MQe8Wr7pwC72DHfbZpbdqMADge2lGHYD0ELm
	LUAalk6tnr+P26qoOKtWSolDk5Cpg6cnjGdkD7HiU5bOsCaKcDEGOoQ3GcOH3QBQPLYGhPLzBOS
	A8NT7vCfJRW/jZkyuk0ClYmkL6YTyrxZ/KMv6g+T1u2FaGqBqnNpJVUqPbW6zq0+UL4H569V5qh
	flrG+pF/0o4FV9Ugg46vFymT8C3Maw+dYF
X-Gm-Gg: AfdE7cloP35IpvXm1w6PJg+/DrtRtsY2UPtxAc5hU0v511t+shu4JG0hbjOOPZaqS1x
	QAKmAf5x+GhRWk6fkDcxoHv4EdXGVHJwGzAD20PN5qg/aKhxNIffEtv1rxeXo1Co0g5XyRaMaXm
	t0biAEBWan8NZcZgGgXEuIrNUX9enJ2KEcS307e/x72WNVlFbecOqG1lje8hTgdIrHSii6bzRjw
	7cj7S+7r7juT0DuxWAskNVgHKHkOZVlwkY9d+QOnJHTpVvu89k5jjX5YuMiDX4MDVRnpw==
X-Received: by 2002:adf:f0c3:0:b0:460:3233:beef with SMTP id ffacd0b85a97d-47f46386e3fmr7594781f8f.43.1784110460622;
        Wed, 15 Jul 2026 03:14:20 -0700 (PDT)
X-Received: by 2002:adf:f0c3:0:b0:460:3233:beef with SMTP id
 ffacd0b85a97d-47f46386e3fmr7594731f8f.43.1784110460011; Wed, 15 Jul 2026
 03:14:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260708161242.1912769-1-maz@kernel.org>
In-Reply-To: <20260708161242.1912769-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 15 Jul 2026 12:14:08 +0200
X-Gm-Features: AUfX_mzYYojltzRopjsZWj-BSyvTHnDNy-EhsjgnxP0aoffOaIAQ3DKZpIh1JXg
Message-ID: <CABgObfbpDt2iATf=d-BiawY_41rLnYFzNiDLDx8W8c-iRCxEXA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 7.2, take #2
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Mark Brown <broonie@kernel.org>, 
	Mostafa Saleh <smostafa@google.com>, Oliver Upton <oupton@kernel.org>, 
	Sebastian Ene <sebastianene@google.com>, Sudeep Holla <sudeep.holla@kernel.org>, 
	Vincent Donnefort <vdonnefort@google.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Will Deacon <will@kernel.org>, Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dmtyJBmVt-WHfSJkDOZyjmzzrK5m_VL01-Zcyzz_P-8_1784110461
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 8, 2026 at 6:13=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Here's the second drop of KVM/arm64 fixes for 7.2. This time around,
> we have a locking issue in kvm_io_bus_get_dev(), which is only used by
> arm64, a few S2 page table fixes, a set of FFA proxy fixes for pKVM,
> and finally a very esoteric fix for emulation of sign-extended loads
> from MMIO. Not only this is rather niche, it dates back to day one of
> KVM support for 32bit ARM...
>
> Note that this is on top of the kvmarm-fixes-7.2-1 tag pull request
> posted at [1] about 12 days ago.

Yes, pulled that first and then this one.

Paolo

> Please pull,
>
>         M.
>
> [1] https://lore.kernel.org/all/20260626133526.817232-1-maz@kernel.org
>
> The following changes since commit d098bb75d14fde2f12155f1a95ec0168160867=
ce:
>
>   KVM: arm64: account pKVM reclaim against the VM mm (2026-06-22 10:48:08=
 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-7.2-2
>
> for you to fetch changes up to 8d187d4b33c262c0f3e44842553521151d8629e8:
>
>   KVM: arm64: Fix propagation of TLBI level in kvm_pgtable_stage2_relax_p=
erms() (2026-07-07 17:43:39 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 7.2, take #2
>
> - Move locking for kvm_io_bus_get_dev() into the caller, ensuring
>   race-free checks that the returned object is of the correct type
>
> - Fix initialisation of the page-table walk level when relaxing
>   permissions
>
> - Correctly update the XN attribute when relaxing permissions
>
> - Fix the sign extension of loads from emulated MMIO regions
>
> - Assorted collection of fixes for pKVM's FFA proxy, together with a
>   couple of FFA driver adjustments
>
> ----------------------------------------------------------------
> Fuad Tabba (2):
>       KVM: arm64: Fix sign-extension of MMIO loads
>       KVM: arm64: selftests: Add MMIO sign-extending load test
>
> Marc Zyngier (2):
>       KVM: Move kvm_io_bus_get_dev() locking responsibilities to callers
>       KVM: arm64: Fix propagation of TLBI level in kvm_pgtable_stage2_rel=
ax_perms()
>
> Mostafa Saleh (3):
>       KVM: arm64: Fix bounds checking in do_ffa_mem_reclaim()
>       KVM: arm64: Ensure FFA ranges are page aligned
>       firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmi=
t()
>
> Oliver Upton (2):
>       KVM: arm64: Ensure level is always initialized when relaxing perms
>       KVM: arm64: Only update XN attr when requested during S2 relaxation
>
> Sebastian Ene (3):
>       KVM: arm64: Validate the offset to the mem access descriptor
>       KVM: arm64: Zero out the stack initialized data in the FFA handler
>       firmware: arm_ffa: Fix Endpoint Memory Access Descriptor offset cal=
culation
>
>  arch/arm64/kvm/hyp/nvhe/ffa.c                     |  44 ++--
>  arch/arm64/kvm/hyp/pgtable.c                      |  15 +-
>  arch/arm64/kvm/mmio.c                             |   7 +-
>  arch/arm64/kvm/vgic/vgic-its.c                    |   2 +
>  drivers/firmware/arm_ffa/driver.c                 |  25 ++-
>  include/linux/arm_ffa.h                           |   9 +-
>  tools/testing/selftests/kvm/Makefile.kvm          |   1 +
>  tools/testing/selftests/kvm/arm64/mmio_sign_ext.c | 255 ++++++++++++++++=
++++++
>  virt/kvm/kvm_main.c                               |  16 +-
>  9 files changed, 331 insertions(+), 43 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/arm64/mmio_sign_ext.c
>

