Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793032791;
	b=atmQhIQ7AXhehLbuqh6WgOHx7rAkgaGW7Kkv5pi7iIBZO2rwwjJ1L8HsqH50hS1qW/Qh
	 06uI3y67Ck7l39R/5z5jk39cKqhK2JO5i1phJod0z+fMPpcqPLFmYn6WQmWnTXzCLFvZV
	 xQAx++epkXoW+2a/Dt6UwOThQS257gRHXeZYZuV3jrrMLerM3FH35Y65XFDmipXR8j5hj
	 uEKTGhAGbaXS9EBASPzGkUW1jWLZhhfeDfKOXPVL9ZwuP4c1qxi2kieGpuByr5EBgZILW
	 Qlt5raCDgkPwBvYNIghgmglbUlvduerdsDaJUjk3qH0jJnZsuW+1e4Kdt3UbqisOi2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793032791;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=ucD/WoA7wxIoPFGYELZoInIDrJz1mWtO2kaqtrfylpQ=;
	b=ga4LUeFQ0tA5KcFJbZcoLVgI9wKqoySdIcS+36ic9pVw+36+03oJ3QV+BjI1Inh+sZmO
	 oH8yItNtUmLuAS9WX5kz4hpOhdBMAxlPeoi+UJmVekmsK7mgSHaWuVk1skO5Pj4t+OwTa
	 D37/t/B1AYy4NHF0pYljGzEyr0sx12KRYfal0L+DsmgLeujcjjEL80MkHWP5ds8fqy5yM
	 RP62m6i388VKCh0uAo7ZMf/QkInCyZbBcXR4ZFiZ3BuI23ZWkL94JU85iZD8N746CBC2N
	 /cnKksZCal7cNZASKuMS1kfD/NieEOBYuUkti98PqdgCb+eGs6DKgZG1XPWPLq7v9Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=AD9vUmoi;
	arc=none smtp.remote-ip=209.85.128.71
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F826606A320
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 16:39:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F826606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=AD9vUmoi
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a1f03f2e8aso25488915e9.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 09:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793032789; x=1793637589; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ucD/WoA7wxIoPFGYELZoInIDrJz1mWtO2kaqtrfylpQ=;
        b=AD9vUmoiVrsS4xnkcTQYVy2V+oVeV0WTyQA52JF316Id+aIt3uRAma1Z8fH5OkLU67
         pMdkY1p1/j0Sdeu4n3rmeT4gKQiiXIU4jvOsiFBwiAq45mIRQXzLDr76aFiqL91FDbCb
         uvwysjRmnbGGyf2EoNnoABEI91UBpxBAjw0fPb3zr+wzxsEgkTJoSifixLq3Z6gBnhcY
         Wd8/ScoGuTkYD34OMEOZh9X2Ejhyneo2eKSS67d9DHI2eG+zlm7i2GH+I+mI8zL+R9mF
         wAD0ppHD91Wjb0lvT5rD5caBnz65+/K4mS/fQyFpNyFZT1hu9UDCEPQ76N8AHD4fim9K
         u50Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793032789; x=1793637589;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ucD/WoA7wxIoPFGYELZoInIDrJz1mWtO2kaqtrfylpQ=;
        b=0K1eGggd/06AKc6vy45799CrTEL3cxSQRchcUs5onFmP7cuf/fvr7a91wFraEPw1bZ
         +o9+qG0d7DNY2yjGBaxVn9wt7JHTvai1d/IQ1lGywO7KU4z66F9iDuAkZ5U2tC6ftQQJ
         x2P5nkWeCc7EAYs2hruZq7Ls9PDwuKzY+0/UY4DB8DNekb9TsIJJS0WvI9suctSpcr1L
         y0MbDuUeJHI6HC4dY5sRvnBTwDbb+HCQY3sN1RfGN1mg9UWgAYjvvWH1nNakURd4H6FR
         PFaTc+4QPe/la3VDJPw1RsVef9vtkqJfAbevWqrD8/m8EX4HCnpH8M3UXu49VhSyep2o
         Gdhg==
X-Forwarded-Encrypted: i=1; AKwUvBxQRPK7igHjmCeSx8NHP2tvONG7tNWWJTetToESH2VXDIly4Z5OC0N3ptQXZC5tPvkks902okY=@lists.linux.dev
X-Gm-Message-State: AFq9FYJR0uuyhrjvPUMrjKvHF/VWp/iT0y/sGSKzpsD0hmHesUoxOJhD
	wLE/eIDBTIEBsAVEP5qySv7HZNibl0JWZ+BlWqfnwE0sGWnFr95oIcGqTnnTbuORFhDsCNcaDwU
	GzVVNDNMM/ifjOwphhZjOCA==
X-Received: from wmfr7.prod.google.com ([2002:a05:600c:1587:b0:4a2:15e9:5ef1])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a318:b0:4a3:5aee:2c25 with SMTP id 5b1f17b1804b1-4a35aee2cfdmr103061435e9.31.1793032788588;
 Mon, 26 Oct 2026 09:39:48 -0700 (PDT)
Date: Mon, 26 Oct 2026 16:39:34 +0000
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
Message-ID: <20261026163937.963087-1-vdonnefort@google.com>
Subject: [PATCH v3 0/3] KVM: arm64: pkvm: Fix missing reset of GICv3 LRs
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

Following Marc's comments on v1, instead of handling the LR reset inside
the pKVM hypervisor, this series fixes the host CPU init, hotplug, and
PM paths to properly reset the vGIC LRs even when pKVM is enabled. This
removes a few calls to is_protected_kvm_enabled(), making the whole
hypervisor init machinery more generic.

Since pKVM can't trust the deprivileged host, keep the reset in the
CPU_ON/CPU_SUSPEND path.

Changelog:

v3:
  * Drop "KVM: arm64: pkvm: Avoid trapping on HVC_RESET_VECTORS". (Fuad)
  * Collect Fuad's tags.
  * Apply the few nits (Fuad)

v2 (https://lore.kernel.org/all/20261022140048.2522787-1-vdonnefort@google.com/):
  * Make the __vgic_v3_init_lrs HVC always available. (Marc)
  * Propagate __hyp_reset_vectors() error and remove
    is_protected_kvm_enabled() special-casing in the host CPU init/PM
    paths so the host resets the vGIC LRs. (Marc)

v1 (https://lore.kernel.org/all/20261021110000.508827-1-vdonnefort@google.com/)

Vincent Donnefort (3):
  KVM: arm64: Make __vgic_v3_init_lrs HVC always available
  KVM: arm64: pkvm: Fix missing reset of GICv3 LRs
  KVM: arm64: pkvm: Reset GICv3 LRs in the hypervisor

 arch/arm64/include/asm/kvm_asm.h     |  2 +-
 arch/arm64/include/asm/virt.h        |  2 +-
 arch/arm64/kvm/arm.c                 | 50 +++++++++++++++-------------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   |  5 +--
 arch/arm64/kvm/hyp/nvhe/psci-relay.c |  4 +++
 5 files changed, 36 insertions(+), 27 deletions(-)


base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
-- 
2.56.0.257.gf7497c7d27-goog

