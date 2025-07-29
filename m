Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98810242D9B
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 19:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753817629; cv=none; b=PtJOd/3Y1NkTXfuxYIDUj3We9ql36RfmVwkQKb86UVWWeAOiObqmd5IPG7aWiCuiOvyZ5TbrBXXGbJghiED2XA/emzOXBvKVRiXuyHviPienmawTxe10PTCDGE9tUdW1cl9iAC7HuHr1BNUZK6bWMKbK1bA1rpndhFTsAixnZv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753817629; c=relaxed/simple;
	bh=uRUA1Dw0gwf9VF6IMVv4hpWTJUqHYnh2F1froOP8Hrc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jPSZ9+SyJ3sdYyiMDL/rW426cjy7hPxr2T3yEdur++OrL9O7DNJuZH7nvPEsYsuCIzlomI1ZjsKrtoRBn3s/JY4qejzFsPbjB0TWGWo3syshlEP1I70k4xsaLnsrQK7azb5vjJyLJL3SUED/FcATFQSBzPFVK7uD6N66p0kMJqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fHA1lPP5; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fHA1lPP5"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31f3cfdd3d3so820702a91.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 12:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753817627; x=1754422427; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vr2NEPUlMUbu3MZ3j1bjKONtMkJFv/DS/JUFQy2VOuc=;
        b=fHA1lPP5mP1NL6FWM2V0p/1EatvoBlkFUuMeZM5qrDi0FWrt6WqG7hHkl7jbWk/4yB
         xIySYA8qbpgQkT3NNOiuVZH8ui/rSLtsx4ZpvnI+dJ9Y/gmb4XPlpHiPE5cMzy0/0TK3
         sdt2W3UMFOuka+dRARx6/UA9NOmdC+nyE6B62Nu3esZIX/cpjDv/DK0ZC/LW7sUA0Me2
         ZUkLs7d/toWE0D4SXJIgJwRavrEBQM92vl0g9j5I3F+raIEDSJQcXVrlh9Wz9OYRUR1d
         4N0Wx9SW9n3r13gn8D6rop6BxoBWkgt5qO/w1if8sLp6CtaJklXcJRCZMQNIlMJ1Lp9W
         6X6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753817627; x=1754422427;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vr2NEPUlMUbu3MZ3j1bjKONtMkJFv/DS/JUFQy2VOuc=;
        b=w7vOSndOInx4Jn4MtHLYJR6riwd3sARzsuT870Oe40S2Tklo73picV4ooPaQ+OdFsD
         Z2v5UnnRR22cU82x5l0sK2PVqZwtpntl325DQub3iB1KaJkHYljvyZSrfSezXSCXuVEL
         zGWcMY9k/qfXp40hGAf8urBkJiGIycAAXHyK+hYGZ71dkeVkN6UppL4hVsWIvFOal3Dm
         fuoIbg0oKZx08VkdVqH4aLY9TBt5h/MBvPrlZmyz6pBoVSDT+CTMIz9LRXBg901mHat4
         pK1fC516IB84GuztUolItRhj2k0FvYnsXGKtxUZlgUoi7IBtsSodZxPLkmolBRHRIvRN
         lIyA==
X-Forwarded-Encrypted: i=1; AJvYcCWavj4M9YIvus8vknpgnY1u4IEeKumK32KmWVcWPB7c7U7XXexla8NLmf3xzablcvRsITzhs0U=@lists.linux.dev
X-Gm-Message-State: AOJu0YxcNximSfsJn0RNCLVuS3U2cl80wbgIFC4jRmX6sLCpQt6Uxe1M
	CXQMDXz7bJ9Zkzqb2QP2Z5aKQwhVTzpVe64qKhhOanJBu326sm2XCTRxu4/7tQ4y75PsOAva8rn
	KqrMnLQ==
X-Google-Smtp-Source: AGHT+IEpCUyIaefYP0YL7w8y1faaEZii0WVM++l9+v+mc/1ojeZtttZMEz40RX0OKzEWa3Hqy78BV9878sU=
X-Received: from pja11.prod.google.com ([2002:a17:90b:548b:b0:313:17cf:434f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:562b:b0:31e:d9f0:9b96
 with SMTP id 98e67ed59e1d1-31f5ddb6641mr902917a91.14.1753817626768; Tue, 29
 Jul 2025 12:33:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 12:33:35 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729193341.621487-1-seanjc@google.com>
Subject: [PATCH 0/5] KVM: Drop vm_dead, pivot on vm_bugged for -EIO
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Nikolay Borisov <nik.borisov@suse.com>
Content-Type: text/plain; charset="UTF-8"

Drop vm_dead and instead reject ioctls based only on vm_bugged.  Checking
vm_dead (or vm_bugged) is inherently racy due as it's not protected by any
locks.  For vm_bugged, imperfection is a-ok as the goal is purely to limit
the damage done by a kernel/hardware bug.  But rejecting ioclts based on
vm_dead is dangerous as it gives us a false sense of security, e.g. see the
race found by syzbot in commit ecf371f8b02d ("KVM: SVM: Reject SEV{-ES}
intra host migration if vCPU creation is in-flight").

This series was motivated by the last patch, a.k.a. KVM_TDX_TERMINATE_VM.
I applied a slightly different version of that patch for 6.17[*], but I'm
reposting it with the vm_dead changes due to Paolo's question about whether
or not we should have a generic KVM_TERMINATE_VM; dropping vm_dead doesn't
make much sense if we want to add KVM_TERMINATE_VM.

[*] https://lore.kernel.org/all/20250725220713.264711-13-seanjc@google.com

Sean Christopherson (5):
  KVM: Never clear KVM_REQ_VM_DEAD from a vCPU's requests
  KVM: TDX: Exit with MEMORY_FAULT on unexpected pending S-EPT Violation
  KVM: Reject ioctls only if the VM is bugged, not simply marked dead
  KVM: selftests: Use for-loop to handle all successful SEV migrations
  KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM

 Documentation/virt/kvm/x86/intel-tdx.rst      | 22 ++++++++-
 arch/arm64/kvm/arm.c                          |  2 +-
 arch/arm64/kvm/vgic/vgic-init.c               |  2 +-
 arch/x86/include/uapi/asm/kvm.h               |  7 ++-
 arch/x86/kvm/mmu/mmu.c                        |  2 +-
 arch/x86/kvm/vmx/tdx.c                        | 45 +++++++++++++------
 arch/x86/kvm/vmx/tdx.h                        |  1 +
 arch/x86/kvm/x86.c                            |  2 +-
 include/linux/kvm_host.h                      | 11 +++--
 .../selftests/kvm/x86/sev_migrate_tests.c     | 34 ++++++--------
 virt/kvm/kvm_main.c                           | 10 ++---
 11 files changed, 90 insertions(+), 48 deletions(-)


base-commit: beafd7ecf2255e8b62a42dc04f54843033db3d24
-- 
2.50.1.552.g942d659e1b-goog

