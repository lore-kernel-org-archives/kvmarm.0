Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793801186;
	b=tYajHQKBvQHlLoQMhAXrYM7ZOQ3mYkvEc8fq2GNzTrOWCsWGGmAXXwMy/TZCJKFk7Kg5
	 Eh+1iJR0wu//XZrK0GDLsJw61ZYm/u/LeDVKCLHYlgIumjaP7j01r/d+kNEYFU78uxs7w
	 9TCOxVXeAZ2FnSSpX6pU8hbvHCm+mlDaYJSvzRxFsfF14eJyTjfxxsIeV9WS/0ZeiCqXd
	 l7NlI18g/rHyCRIR1KPG93sFuMcb6rFLqJdohImJg9MdwkFXJOmoqqo3SJPbiRakG4OYj
	 MZYyLAF//d5VNy6pk9rMjOHkvr2OiimzB9h8P4xw2FFI4aHVej7nzTTbtITSruwUvIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793801186;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=N/SsdHu+Po4v4WPdkAdXaeFtGaJ5FCa56QFJpxcXNro=;
	b=rIpweTPAoTcIAGSXURdBCjuaq0XB7nrLj8TAbozQMYjDwv6lKt/Nq8yZYyXZ4wH1x3oc
	 lYK/zWxulABk/EZoi3X1lJp3fOgoKM3DMLakaFp6IbbnDs5v8eawV4EAaQiDN7fT0EZrE
	 ile7LgtKvEc24hc5L73/dNJbc4emfRP6iYAf2Olq3oYxXUHZwGbdtKN+KutbCrE6rhR0t
	 TYnH/fVFqIFkzRDkpe+TI5N1xGtpEue7V93iVS2XgFqsQjGfJf4W1FmFjK29fYS98SsU6
	 F+MB1zTVt+/HNyFb4/0+fPKwIylW68ApvHEq8+DNCujbquqnUw60jaH82ewxVCBM2dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=V16LjnbT;
	arc=none smtp.remote-ip=209.85.128.69
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BCC606A31B
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 14:06:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36BCC606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=V16LjnbT
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4994d67d0e3so5909465e9.2
        for <kvmarm@lists.linux.dev>; Wed, 04 Nov 2026 06:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793801184; x=1794405984; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=N/SsdHu+Po4v4WPdkAdXaeFtGaJ5FCa56QFJpxcXNro=;
        b=V16LjnbTyFT/UXYwMwJ96tVbmWDl1T/RNhUfvAp0EQTpToFZRY5biPjQB5rzV9L2tA
         H6Yen0y+S38titXRpcPnQBhfi2lVxTHF1UihCzxE4eVK2f/J7Subj3e110ZnOB22CeVH
         wixj3KgNrKzWDK+kd4DQ0zzMI65KTRengtugzx4o/lFNDiR7Qug4JWsrI4vZPh8NG7ze
         CUbJoSdDcr6HGQB49prgnkVBgte1TJkMAhtNu9casPtNTnaWjoAS3VwWe9V64mK56y/O
         JkYTL30mJc7a1HyY+0dNCOW68VEXvo8/lSFS8q1yKap/6BdeGaNRsAWgEEU5FFVjRF4C
         QABQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793801184; x=1794405984;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N/SsdHu+Po4v4WPdkAdXaeFtGaJ5FCa56QFJpxcXNro=;
        b=mSf7QoVtpDHuw5emvMZzG5M8b8VwARnO302Wmkh7Z8UENNCcBqNPnWPhCLrU4ZJd/5
         49lG76xkreLT/jP3EvS8JIMqqns1/qcO6S4Vu3PhMinPkjYQ55l7r00Y5zaDAhDJYFMz
         m0APHyMxdpwttBBTCK8Z3OVESRZ9CLpVbK3swAXZjpsiDREWYMKCDqKU87xTVYDFPcgo
         2wDyzegH3eT84NDUNHH30OdAs+Ezmy18lHopIBgxCF0zJjd1uKgsVCfcCziRfa8tj21y
         fsMsapV2digqM9qx/TbUiBAIZufyTXPq+jNP8jn8f+DHh3ugC/9xgZvLOnF+syLz+9GN
         6Tkw==
X-Forwarded-Encrypted: i=1; AKwUvBxT93bErgZYcIBFUDHqRe44FUg8JqqWW5yiGX0NY8n1Ox4MRI7LbGkdbHdR683xWrU4tGgB2vg=@lists.linux.dev
X-Gm-Message-State: APuU4Z+ZUzNW29Aaqm6bELU/LSahJ29yuGM9lZa9frzATyHwz+nLj6j7
	2x19hALgsfvmxJmyPjKLJx2csEjDkMWVGAkhANmhTM3TNZtRRVPwtiMSr5aCRpO6gqAimcL933m
	g6XcYNcVRJlVD16H7Ah1Yxg==
X-Received: from wmpo23.prod.google.com ([2002:a05:600c:3397:b0:4a2:c25:d91a])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:354a:b0:4a3:5a55:f454 with SMTP id 5b1f17b1804b1-4ac17e10ac3mr382089215e9.19.1793801184306;
 Wed, 04 Nov 2026 06:06:24 -0800 (PST)
Date: Wed,  4 Nov 2026 14:06:07 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261104140612.137869-1-vdonnefort@google.com>
Subject: [PATCH v2 0/5] KVM: arm64: pkvm: Extend hypervisor entering tracing reasons
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

This series makes the hyp_enter event more detailed by adding a "from="
field and by using the ESR class when relevant. This is interesting for
example to know when the guest has exited for an HVC.

Speaking of HVCs, protected VMs issue an HVC to share memory with the
host. Without this memory sharing, it is impossible to get logs. So if
for any reason it fails, debugging is quite cumbersome. Add a specific
guest_hvc event that will give even more details than hyp_enter
provides.

Also, add a host_hvc event, so that the host gets similar coverage to a
protected VM.

Changelog:

v2:
  * Add missing exception classes to kvm_arm_exception_class (Fuad)
  * Split the HYP_REASON_PSCI -> HYP_REASON_ERET_HOST fix in
    __kvm_host_psci_cpu_entry() into a separate patch.
  * Add missing <asm/esr.h> (Fuad)
  * Read ESR_EL2 only when hyp_enter is enabled (Fuad)
  * Drop the handled field from guest_hvc and trace only
    hypervisor-handled HVCs.
  * Rename ret to x1 in host_hvc (Fuad) and val to x0 in guest_hvc.
  * Log the SMCCC function ID in host_hvc instead of the host_hcall[]
    index. (Fuad)
  * remote_event_format_show() field alignment fixed
    separately (https://lore.kernel.org/all/20261009132848.709379-1-vdonnefort@google.com/). (Fuad)
  * Rebased on top of v7.4-rc1.

v1 (https://lore.kernel.org/all/20261009084529.462577-1-vdonnefort@google.com/)

Vincent Donnefort (5):
  KVM: arm64: Add missing exception classes to kvm_arm_exception_class
  KVM: arm64: Use HYP_REASON_ERET_HOST on trace_hyp_exit from
    PSCI_CPU_ON
  KVM: arm64: Add ESR class to the hyp_enter hyp event
  KVM: arm64: Add guest_hvc hyp event
  KVM: arm64: Add host_hvc hyp event

 arch/arm64/include/asm/kvm_arm.h       | 13 +++---
 arch/arm64/include/asm/kvm_hypevents.h | 55 ++++++++++++++++++++------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  9 ++---
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 12 +++++-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c   |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c       |  6 ++-
 arch/arm64/kvm/hyp_trace.c             | 52 ++++++++++++++++++------
 7 files changed, 111 insertions(+), 38 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.0.455.g6c5a503b38-goog

