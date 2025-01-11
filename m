Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769D528FF
	for <kvmarm@lists.linux.dev>; Sat, 11 Jan 2025 00:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736556653; cv=none; b=OFHNMLlj8zpiv0/9Vto0xdoBp9G+2cIaAT94ZoO/006NsYXEhwecsQbTv7nn+NSCvt0UzIW+OTEV6DdBTkAQuE8pN9nxfpnh1f42JuafykYonixyZvsgkNjyNrXXKzB8EsMv78CVBB42QUXkneO4xJryrTo0O4ptvsj0XYCqTyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736556653; c=relaxed/simple;
	bh=kul+Fw4DW6osdE/Z2GoPabxZf5HTWm/6V8saFNmXeC0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=H3gOaPL4koE8w+gty01TgEMyqeGVqk8sQ1hnIfvDH7gEYPw3IwofBEQ/UUvOsG5UN1EQqdcDK/PH1v44eNfGMOwE0ObZ6pyx61PV+sYbHAXq0Y2M0XQgqse/DyteTjssIh/mbL2pEJ6RrDg4fzV5fgBApkf3XC5rl4YCSInGqMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sf4dqIpy; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sf4dqIpy"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef728e36d5so4812758a91.3
        for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 16:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736556652; x=1737161452; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9xron+KThU7T77R5VL2QV4m0fAH5NzD4XXNwhcBHEXQ=;
        b=Sf4dqIpyVY5uGMM19zwwjnkoV9z0F+COR3FN8xsOy0BzwUs9ZUcI+O8xMt+N7nh8U1
         sh6TiGCrLXuLQ/lHcbsyY8Ug9wwUn6t4te9dYZ//RrzsOLrXUC+jJU31Pr+8NiEkD4gj
         GHLCLICXgxmhhgNK0vY00fFQCFfyCi5YZ/WhFp0LnD8vFXhnaKxHryhgR7KKvYWpEM1Z
         N4BFPSKj830bM9EHFp9SW0AdkXSB5gDkiqX/HxhhhYP6yOlAksh/lWJSIHQjXC55FuwE
         h2E2OPeI7oDshxrCRJ32RcOrr7m5m5Tv5Ejc7GVpvF45NTmEB0oa5B0LQxuW59VOXvSe
         bP6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736556652; x=1737161452;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9xron+KThU7T77R5VL2QV4m0fAH5NzD4XXNwhcBHEXQ=;
        b=Y0hq5itOXBGLSS8et9pXUMX7j4O/AhQ4sMV2Yz878tl/A3wrRnzWsRdxFOxKRLO8Vt
         bhOisaOFleGgXbPo6IKgkzttKH9PPS1Huu56Sv82SHmsfOk/JodvHHLI5yB0WhuYWcHc
         pWNP02QKodsEGWUpyv4WWRv7BQU9wbORLKA0Y6oRxEU5/aiKQrLd9TZgVLZbOnmn3PG/
         ebNGjYpMUUUw4vpt8tM07o4F3UwjjssvczTitWedLzFH8g7FS3Rk9bzfajZ4pQCB9IyK
         AjFX9SbdsIeDjg3TYrUer8/GZgT/4aeh4mgT/X3wc9xjHieQbPArIFNbQnKD4j9P7P90
         hfmw==
X-Forwarded-Encrypted: i=1; AJvYcCVMZ1hiIXgssUZnwL9ICwuw1nqK7UKolhoz0w3TK91s7taxN9HTZczhpJChDYtNtRVF46KS4w0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRITs8F2B3qY/yL/+JulJ5ZjOrEDD/ksgNtEGnmBIPP3xjm3r3
	DYpnI+gYYfBDY1P0MnKFATgKZ8TVYSUGpaGtnCUQ27pH2wE44CMFhIcrYEEKMKcvQAfT2yFhzak
	hHA==
X-Google-Smtp-Source: AGHT+IFGHtmLK/IYHq0Rf1GMc11fdZBgGQoU3n0wFrQS04Q/FED/wp6nrTmZr2LCO3EYVe3us4g7I58uwQQ=
X-Received: from pjbqi13.prod.google.com ([2002:a17:90b:274d:b0:2ef:82c0:cb8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a44:b0:2ea:61de:38f7
 with SMTP id 98e67ed59e1d1-2f548f1d420mr19019162a91.29.1736556651751; Fri, 10
 Jan 2025 16:50:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 16:50:40 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111005049.1247555-1-seanjc@google.com>
Subject: [PATCH v2 0/9] KVM: selftests: Binary stats fixes and infra updates
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fix a handful of bugs in the binary stats infrastructure, expand support
to vCPU-scoped stats, enumerate all KVM stats in selftests, and use the
enumerated stats to assert at compile-time that {vm,vcpu}_get_stat() is
getting a stat that actually exists.

Most of the bugs are benign, and AFAICT, none actually cause problems in
the current code base.  The worst of the bugs is lack of validation that
the requested stat actually exists, which is quite annoying if someone
fat fingers a stat name, tries to get a vCPU stat on a VM FD, etc.

As called out multiple times in v1, I'm on the fence regarding the last
patch (compile-time assertions).  My plan is to apply everything except the
last patch fairly quickly, so that the vCPU stats stuff in particular can be
used in x86 tests, and hold off on the compile-time assertion goo until
someone comes along with a strong opinion one way or the other.

v2:
 - Update rlimit number of files for all "standard" VMs.
 - Account for the vCPU stats fd when updating rlimits.

v1: https://lore.kernel.org/all/20241220013906.3518334-1-seanjc@google.com

Sean Christopherson (9):
  KVM: selftests: Fix mostly theoretical leak of VM's binary stats FD
  KVM: selftests: Close VM's binary stats FD when releasing VM
  KVM: selftests: Assert that __vm_get_stat() actually finds a stat
  KVM: selftests: Macrofy vm_get_stat() to auto-generate stat name
    string
  KVM: selftests: Add struct and helpers to wrap binary stats cache
  KVM: selftests: Get VM's binary stats FD when opening VM
  KVM: selftests: Adjust number of files rlimit for all "standard" VMs
  KVM: selftests: Add infrastructure for getting vCPU binary stats
  KVM: selftests: Add compile-time assertions to guard against stats
    typos

 .../kvm/include/arm64/kvm_util_arch.h         |  12 ++
 .../testing/selftests/kvm/include/kvm_util.h  |  51 ++++++--
 .../selftests/kvm/include/kvm_util_types.h    |   6 +
 .../kvm/include/riscv/kvm_util_arch.h         |  14 +++
 .../kvm/include/s390/kvm_util_arch.h          | 113 +++++++++++++++++
 .../selftests/kvm/include/x86/kvm_util_arch.h |  52 ++++++++
 .../selftests/kvm/kvm_create_max_vcpus.c      |  28 +----
 tools/testing/selftests/kvm/lib/kvm_util.c    | 114 ++++++++++++------
 .../kvm/x86/dirty_log_page_splitting_test.c   |   6 +-
 .../selftests/kvm/x86/nx_huge_pages_test.c    |   4 +-
 .../selftests/kvm/x86/xapic_ipi_test.c        |   2 +
 11 files changed, 324 insertions(+), 78 deletions(-)


base-commit: 10b2c8a67c4b8ec15f9d07d177f63b563418e948
-- 
2.47.1.613.gc27f4b7a9f-goog

