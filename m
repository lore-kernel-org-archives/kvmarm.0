Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B33751588D
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 15:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782549; cv=none; b=i/8zXyf2HU7ZHEXGeYBqiFgBp9VpBiNay9izE+Bvh/uMyGxpYN6diVh+4Qdwu9MydE7KWt4yOugfHyQNWSxFcqh/JlYWdaoKUDVPeywMG4aJtuO1F9wmNAa+7hNHlbTufBHaurvwxZzZahy+yKNKCB/sgo3g+9jScWne/RCDnEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782549; c=relaxed/simple;
	bh=rHpjp9NnfBeLqm9BJgCaz6UI7vJf4/thF9Jb3lTI/oQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=S/4T6f6GLKfuY8XL7m3vrkZQhNhn5R3PXqJus+ADI0ohRkNDJPzcoB81awCsnMDohmOb2y2fmG47e8YJO8p3kCpP+BBFO/nB0iIKjhAnKP2kn+7xfp9rnH+3h5U91+0DJHHY1mwS/l/q4LnD/d457CcmJJeMR12WbrfOeUGFU8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fyoghi5U; arc=none smtp.client-ip=209.85.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fyoghi5U"
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6ac6961203fso4072445a12.2
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 08:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790782523; x=1791387323; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=e9Vds2cdlvlYZjJIgGDWs1EJC1YhBNT7rk3OYBjOaX8=;
        b=fyoghi5UrIwPNFcBucGPWrG5ELL/9C4mhXlEY10WcweC4vsS+PewWGi2e/8tfA0YM4
         VDiVPhD9eUqevsJD3VflYBH0g56i0zyHYdkQnfyfXEi6dPboc2iwSo1KU2S0baOTrgdd
         iF9eYUgE1VG6zV9B5KGarMAyOVCOMobHlIaC4fwr6c1XqfGXA4CALxZ/L5L4yCfpFene
         nRVxnu99+tkBgd/lnBGHH1GedobICMTnS0ADKcQeLl4U6K8flN6411lRe1hRjlly+HFm
         mwCKXk/mWJo89BgJlZpCD7vt/3iT/Wov4Rm72onbF6CsbUl027kqPJBLmpHedjuihgl3
         Fx+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790782523; x=1791387323;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e9Vds2cdlvlYZjJIgGDWs1EJC1YhBNT7rk3OYBjOaX8=;
        b=pSOJL3qU+0jpJmbcQamlQKh9+ENuSNB35vcYIyORjxPMoI3XKzvN1V8tb0sNtXL1uw
         4beuqJ92Vv6i1WgfFFnVD30XUBAG4RgJZwb6K7oxwERdv7DGp76wlo6NYdWh9+d5nljA
         lcSbt15hkX7gz7RhF9TC7NmqvTr4fS4ULoSArZY2wDNjl76NaNyUIifrxwEdA9v4xJAy
         C3Rq7D35JiFuhSOu5Ckk50sclqDkIz1IbDU2AWd333eDByXmETM34Xo1M0Mv/UtUZBi0
         4tExkaPCNKOeUkRiKF3rraX3yMQoLw2AHlKOyMyCFsA3WG2iLPxE+0zAsKyp1WraUtkD
         Sj/A==
X-Forwarded-Encrypted: i=1; AKwUvBy+dYVBGhwmJ38ACHLjAhLeHIJiBaiVdmX8XRL0X0Zy4V8ZP6PGHpD8BlgPNdC8dnTWl20cBl0=@lists.linux.dev
X-Gm-Message-State: AFq9FYJF5L9U8HUkq2Fr/ZI9+eeSdnV87vaaJ3Wjf60+SXxE2p6MyaC9
	JACxjimx0vDbW9GaaTIGadzvKiJ1WOQiIDXLAL29jloXguBcSu6e5LS971Pf5MEfec+JlYrj3Du
	8Itdn1IRSH3CyCZP7dgyAKw==
X-Received: from edvx9.prod.google.com ([2002:aa7:cd89:0:b0:6ac:c249:42c4])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:4552:b0:6aa:9fef:641c with SMTP id 4fb4d7f45d1cf-6ae1992adcamr1193267a12.28.1790782522587;
 Wed, 30 Sep 2026 08:35:22 -0700 (PDT)
Date: Wed, 30 Sep 2026 16:35:01 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260930153505.2144559-1-vdonnefort@google.com>
Subject: [PATCH v3 0/4] trace_hyp_printk() for pKVM/nVHE hypervisor
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi all,

This series adds a hypervisor event "hyp_printk" which enables
developers to log pretty much anything into the hypervisor tracing
buffer, just like the kernel function trace_printk().

This enables rich logging from the hypervisor, while leaving all the
string parsing burden to the kernel. This has been the main way of
debugging pKVM in Android.

Even though not strictly related to trace_hyp_printk, I have added the
following two patches:

  * KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp

    This one mainly intends to support one of the new features I have
    posted here [1], which allows to enable tracing as early as
    possible. I have added it here to limit cross-posting.

  * KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/

    This one is just a cleanup.

[1] https://lore.kernel.org/all/20260605163825.1762953-1-vdonnefort@google.com/

Changelog:

v3:
  - Collect Steven's tag
  - Rebase on 7.3-rc3

v2 (https://lore.kernel.org/all/20260708075435.47419-1-vdonnefort@google.com/):
  - Collect Fuad's tags
  - Rebase on 7.2-rc2
  - Warn when trace_hyp_printk callsites are exhausted (Fuad)

v1 (https://lore.kernel.org/all/20260612142245.1015744-1-vdonnefort@google.com/)

Vincent Donnefort (4):
  KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
  KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
  tracing/remotes: Add REMOTE_EVENT_CUSTOM_PRINTK() helper
  KVM: arm64: Add hyp_printk event to nVHE/pKVM hyp

 arch/arm64/include/asm/kvm_asm.h              |  4 +-
 arch/arm64/include/asm/kvm_hypevents.h        | 14 ++++
 arch/arm64/include/asm/kvm_hyptrace.h         |  8 +++
 arch/arm64/kernel/image-vars.h                |  1 +
 arch/arm64/kernel/vmlinux.lds.S               |  4 ++
 .../define_hypevents.h}                       |  0
 .../kvm/hyp/include/nvhe/define_events.h      |  2 -
 arch/arm64/kvm/hyp/include/nvhe/trace.h       | 65 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/events.c              |  6 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  2 +-
 arch/arm64/kvm/hyp_trace.c                    | 63 +++++++++++++++++-
 include/trace/define_remote_events.h          | 19 +++++-
 12 files changed, 179 insertions(+), 9 deletions(-)
 rename arch/arm64/{include/asm/kvm_define_hypevents.h => kvm/define_hypevents.h} (100%)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

