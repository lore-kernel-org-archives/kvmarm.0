Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792677732;
	b=AEzx82rINFQvJEtcteGQ5Fgo4B7UMrvRjLEhD+hDjLwJNb5htX+zs5qK2oIddNS0i1Dp
	 8KTn/SpCSnKa9KJ4WUlpb0QynaTXLpMbMxL2P0E5JvvdBYdyy9td9PJmDSQ5vD9siDIlq
	 +M+SKqSSTW4HdsdFQj2II3KRVVM/k0bkbG9CaZrlTiDKW1wsEgVnNUji8r8R2OOyC3xIm
	 8a3kJB00f5sMV/Eypjr7yDma6igQx/6fCuijpaYnDdkKFpog31rWkyGIDkle8IXH3hFt/
	 FnSIyN6jsoNmrxJ8Sf6H1METBGA+moHcCW6bujiA3300L6BmMmoN2I8rbNz7QDHoWPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792677732;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=vsmRRVaV1+5+TACeJIusWgJrEDczJxQiGTc7WIupIyY=;
	b=f9NC2iL8hNwpFNG7B6bWnj/54ElqQV0E0FmVjnLUmW2uRMrydApDMviIUJ+04TARl4VH
	 ydUcuJ5m/oHAX5mn/TETjIA0iDO/Wv1JlkiNHO9c7AGCgYDHqy2ZO83/cLXfZXltFWwR6
	 dRtI8SlIXxxQAe1RSVaFMaSYMO73MdDP6IU5i0WTWQmVFZDzLtrLguKZ+GdMr2JtmglPz
	 sGFg5j4ipT7CwRjQssCtPrvV5Ye33Hqo1VGwJuYHQdLD1hDoJ190xs+raTPSxT49Lkg1Z
	 6RF4P2qhFgcQZICct1B8Ed3IH3RoVTQOZa9IE97tOl+gvHhwVzgHDPFshLxsiTC0BzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=UwHYpVYD;
	arc=none smtp.remote-ip=209.85.128.71
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AE9606A319
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 14:02:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01AE9606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=UwHYpVYD
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a0284121c6so17807715e9.3
        for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 07:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792677730; x=1793282530; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vsmRRVaV1+5+TACeJIusWgJrEDczJxQiGTc7WIupIyY=;
        b=UwHYpVYDE6lelA1TfXKpLGH5Snn/NG8v7woZzO2Efx7NcbTPtK6qyJUHWOdFWAEJaZ
         l4uluhG5uiSJ8hDmQVyFSQazVnZ/A1KpxDLALoJAh6QrkCCUPcSoYkwlLox+0bHhILZh
         2WMgxC0MpWeC7rZvTFtR123V3HlTg9iNz/N8Vm6PtOuO3Wkn8DcfrBxoKr5LlW4i2OOt
         Az97Sb2mwmw9qviUhNst9R1MMDWBafGH2Hko//DtUj115XMnGaBoSj1bw6lj7ETMqrPW
         Ur0s6XTjMG8r6VHeIu3IXhpr8JZIP0ocrmvtvzIdVSoNNjFMsPBC7WhAlJ9AvLk1zeOf
         aHgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792677730; x=1793282530;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vsmRRVaV1+5+TACeJIusWgJrEDczJxQiGTc7WIupIyY=;
        b=SM00j8Npxowmt9X2b2pf2LmxTOlHk2Q7vT8YYTMIXKCI8NZq0uG1hH1tk+54c+5+rr
         Bp+77qJ/aQBx5Mw4UTNE0hu7iLJayrI88PF5wzyCL4EHMDAMtsIDiiMNXca42HV7/bFg
         VuHFYztdZhxirjbltiz7C7xzf0jsnAb+u7OyBuj5btPMmhbTCb/1KaUHgZKYDltTGPYL
         z+bUxkfkD83zA9M8JzSikj4ze6DgLf0RnXTWZPRwflpxXGPT/0KoXAywRaVfvMczzV0E
         2uU3k5gTjfNRcSX17Kkb0fUbdhxiInnWaH35tZClUWlMZP8QcObZ7qs17/yNMMTEbP1j
         +IEw==
X-Forwarded-Encrypted: i=1; AKwUvBx9JS1XwQjbVuA/qvsoLdxrgdPXugSuL6VwV76FtWa/YRpXnixSNE/yqAorY8RhJrSTx3z1F1M=@lists.linux.dev
X-Gm-Message-State: AFq9FYKhf+CAYvH9H93Dbbiaq3rw7fna4nz42HR4R+hSxl+0TlN20lC7
	52Gae4Jeo79pNAMSI693svzeDVWsLJpEZq64Q0m3oNNqZXcRrrZdfjFLt3GyBTH8BMjWm7s2eVW
	yDqf1/9teQRP3hqWJPoE2kQ==
X-Received: from wmby14.prod.google.com ([2002:a05:600c:c04e:b0:4a1:fc99:15d6])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3ba1:b0:4a2:d82:11bb with SMTP id 5b1f17b1804b1-4a20d8214a7mr12734265e9.30.1792677729944;
 Thu, 22 Oct 2026 07:02:09 -0700 (PDT)
Date: Thu, 22 Oct 2026 15:00:44 +0100
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022140048.2522787-1-vdonnefort@google.com>
Subject: [PATCH v2 0/4] KVM: arm64: pkvm: Fix missing reset of GICv3 LRs
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The GICv3 List Registers (LRs) are architecturally UNKNOWN when a CPU
boots or wakes up from a low-power state. When pKVM is enabled,
__vgic_v3_init_lrs() is currently never called on boot, CPU hotplug, or
CPU PM resume.

Following Marc's comments on v1, instead of handling the LR reset purely
inside the pKVM hypervisor, this series fixes the host CPU init, hotplug,
and PM paths to properly reset the vGIC LRs even when pKVM keeps the EL2
installed. This removes a few calls to is_protected_kvm_enabled() making
the whole hypervisor init machinery more generic.

Since pKVM can't trust the a deprivileged host, keep the reset in the
CPU_ON/CPU_SUSPEND path.

Changelog:

v2:
  * Make the __vgic_v3_init_lrs HVC always available. (Marc)
  * Propagate __hyp_reset_vectors() error and remove
    is_protected_kvm_enabled() special-casing in the host CPU init/PM
    paths so the host resets the vGIC LRs. (Marc)

v1 (https://lore.kernel.org/all/20261021110000.508827-1-vdonnefort@google.com/)

Vincent Donnefort (4):
  KVM: arm64: Make __vgic_v3_init_lrs HVC always available
  KVM: arm64: pkvm: Fix missing reset of GICv3 LRs
  KVM: arm64: pkvm: Reset GICv3 LRs in the hypervisor
  KVM: arm64: pkvm: Avoid trapping on HVC_RESET_VECTORS

 arch/arm64/include/asm/kvm_asm.h     |  2 +-
 arch/arm64/include/asm/virt.h        |  2 +-
 arch/arm64/kvm/arm.c                 | 58 ++++++++++++++++------------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   |  5 ++-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c |  4 ++
 5 files changed, 43 insertions(+), 28 deletions(-)


base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
-- 
2.56.0.257.gf7497c7d27-goog

