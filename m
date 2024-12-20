Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C21B259497
	for <kvmarm@lists.linux.dev>; Fri, 20 Dec 2024 01:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734658750; cv=none; b=fwQGH05TFxc20+txLhV9GwtyWhFuHD3iooxui7OOyWl05CSzxh6ttZ/1WU7rT/xzPKXxCgjUQXOlslNtXGRyl2CyWHsbLT2vDejwWR4GLVAmtGYH9dpiod50CXqURGZjTR1kglqyRX7wVADmLlYFMdBLC/KPsYmzmyF5cOkeJUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734658750; c=relaxed/simple;
	bh=iOtbn0YZnKIsu57KSQS/WdzlFtmyeZ6SuWU2WK8fyWM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=KY0E2ZLZOhQGsg/JTIB6paOSusbH3fYMwbrL6MSusVGEppt0H8PcqULMO4J05kF7DfCEQRX+u+62QOhka7ZoKlhjP6mAUi/OCVquRmASN+kQtWkNtcidXbTqGeDL6eZ4E0zpxm8gPLELxRsafauCWNdZjvVE9h0zX6s6pQPtIHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nrag5QDs; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nrag5QDs"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7fd5777a6aaso1096871a12.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 17:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734658748; x=1735263548; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cRDKUGnjPxUGgjTzF3qCkNkq62oEn2vSDO7JvD7Kppc=;
        b=nrag5QDsMZhhksGUXW+szu7xuN7PRsu7GZhfoGaVSZLVzeVLBci7OQfYYwlniOQ1a4
         0jbHMNrX3BX/MIph3WzLB+X+AyhUHJciYM4f7liDhzArtHC+yK8E+8WBYpsbYryyjyD4
         JIg3BLPkFfwIeAMWlFcuQ6BYgwjnRJ3xJw9uv4Ni7II7O+H4yW54YYOG1ZC9vqmds2Ht
         7CUNrsj529fyOeciv+rmO4HBvhrZIdWDstvPh0kP98x6Dc6YtshC6Ve/ZVouvYp8YZqV
         zwj3SZ2a3zR7Ga9VH9qbJkQC5BjV6BEmd+bNln7vqD99pg0hNI7qenfHEWG9yUBRfkrC
         Gx7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734658748; x=1735263548;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cRDKUGnjPxUGgjTzF3qCkNkq62oEn2vSDO7JvD7Kppc=;
        b=X8kTozmVEDTlj/e0qrElZ874AS05EJjrR7kXtTzQcniqWrnlYZ7aULMuU63zwbuFuz
         o9xLSupWlI2q4plswul82FGvgG5LKLA/8gyP6F5LbF4b7qrvP0nTv/3ohxt9yjNEo7tO
         Hy4w12eQhK53xAtYuTFd3tfCufo9XaAHg/vLXKRyDRkFmmOZloDrDqmXR5YpGQExi5VU
         TR0XF1omtqY4sSxCOqnuJo+PgTvbWnb4rGGX1hVvo3AamhkCRDl2qDy65/Jm+1DXmZ4c
         qp0Jy7gvMepd2W8KQCkB1FbgTTkJ5JU+Z4983cv7IslROe9ddQjaGccrNP4sZQcGfrwh
         OuJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNtwpaO8Igdk1SR1fhUwPOe0mLXOV4ZIEhG5QDfDasTvDbSZuMn0xREOJBB1pl7qhrLKd7ZmY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzcM/fsv2EQvVm7dfdueyR06Q+EOKanKacRS6UUgaNP5RnoZ6uL
	iWPckNdCJGJoNxJmVx+GGcG06fLb+mGQDFIFXr9MdhZr51EbddQ4+A92HWrbNzukqAgkGUuSRtK
	BNA==
X-Google-Smtp-Source: AGHT+IGKk1u1qooE3KT9EvHF6/wnmuA9XWAa8TXLf9DPPdKposqbF1SIF5jz7mHb6qxYFc6rf04T8dQlWu4=
X-Received: from pgbda1.prod.google.com ([2002:a05:6a02:2381:b0:7fd:4bf0:25fa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7fa6:b0:1e3:c763:74d4
 with SMTP id adf61e73a8af0-1e5c6d6b62dmr8239281637.0.1734658748516; Thu, 19
 Dec 2024 17:39:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 19 Dec 2024 17:38:58 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241220013906.3518334-1-seanjc@google.com>
Subject: [PATCH 0/8] KVM: selftests: Binary stats fixes and infra updates
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

FWIW, I'm not entirely convinced enumerating all stats is worth doing in
selftests.  It seems nice to have?  But I don't know that it'll be worth
the maintenance cost.  It was easy enough to implement, so here it is...

Sean Christopherson (8):
  KVM: selftests: Fix mostly theoretical leak of VM's binary stats FD
  KVM: selftests: Close VM's binary stats FD when releasing VM
  KVM: selftests: Assert that __vm_get_stat() actually finds a stat
  KVM: selftests: Macrofy vm_get_stat() to auto-generate stat name
    string
  KVM: selftests: Add struct and helpers to wrap binary stats cache
  KVM: selftests: Get VM's binary stats FD when opening VM
  KVM: selftests: Add infrastructure for getting vCPU binary stats
  KVM: selftests: Add compile-time assertions to guard against stats
    typos

Sean Christopherson (8):
  KVM: selftests: Fix mostly theoretical leak of VM's binary stats FD
  KVM: selftests: Close VM's binary stats FD when releasing VM
  KVM: selftests: Assert that __vm_get_stat() actually finds a stat
  KVM: selftests: Macrofy vm_get_stat() to auto-generate stat name
    string
  KVM: selftests: Add struct and helpers to wrap binary stats cache
  KVM: selftests: Get VM's binary stats FD when opening VM
  KVM: selftests: Add infrastructure for getting vCPU binary stats
  KVM: selftests: Add compile-time assertions to guard against stats
    typos

 .../kvm/include/arm64/kvm_util_arch.h         |  12 ++
 .../testing/selftests/kvm/include/kvm_util.h  |  49 ++++++--
 .../selftests/kvm/include/kvm_util_types.h    |   6 +
 .../kvm/include/riscv/kvm_util_arch.h         |  14 +++
 .../kvm/include/s390/kvm_util_arch.h          | 113 ++++++++++++++++++
 .../selftests/kvm/include/x86/kvm_util_arch.h |  52 ++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  79 ++++++------
 .../kvm/x86/dirty_log_page_splitting_test.c   |   6 +-
 .../selftests/kvm/x86/nx_huge_pages_test.c    |   4 +-
 .../selftests/kvm/x86/xapic_ipi_test.c        |   2 +
 10 files changed, 286 insertions(+), 51 deletions(-)


base-commit: dcab55cef6f247a71a75a239d4063018dc83a671
-- 
2.47.1.613.gc27f4b7a9f-goog

