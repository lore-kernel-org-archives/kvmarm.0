Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 363F933D4E2
	for <kvmarm@lists.linux.dev>; Sat, 16 May 2026 18:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778956257; cv=none; b=JLU2jzFCnUu3tF2VvOplnfXgSHTLHnWOwpjanzfy1GqEzify+toYJWzIZ5viWNQrY6hTkZiywc7e27Lzy7dfUFid28TEKFuWAdw7BiI4FkOtp0TLbd0AQoqEZSwKzr78eV3PnZEdTYLY5cljvFYNBg9zY7XtyKixpMROSeBuyZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778956257; c=relaxed/simple;
	bh=NPq7c3O7m9YoMQfFgefKlCXS40W630c66ivNjwX7VnY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A+jG3ggVlVoszuWCg1xrRir2y4wm1szepuZ3pSukPkWzRop9VJNQKmfi9G4xdgm6zoeb7iDCzjmcA6kW5/g67VXr3CVduGx7Wk5OowmpRcchIskl0ddvs01tfvDnG7A7UVMITX3WNAYzrkT4DzvkNu7klgPwKo8kbLg/jBCXmjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=X3AVoYMi; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="X3AVoYMi"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E9861BF3;
	Sat, 16 May 2026 11:30:43 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 023AD3F85F;
	Sat, 16 May 2026 11:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778956248; bh=NPq7c3O7m9YoMQfFgefKlCXS40W630c66ivNjwX7VnY=;
	h=From:To:Cc:Subject:Date:From;
	b=X3AVoYMic76EhjPA5QnkayYsO/uqgN8aSmHiHRkVLmdd4+gKne8/4SxtqHitV5VIx
	 dR79teEEA0ZcD5I9q2lArcEV20ly23EVs3HPgOHZ+4qtsomrkBjl7lvv3Q00yg1i4R
	 60pEIp5GvT2zSy+ff9ZHmAN7EC8SaBkbkzOjSYNo=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 0/9] KVM: arm64: selftests: Basic nested guest support
Date: Sat, 16 May 2026 19:29:54 +0100
Message-ID: <20260516183003.799058-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This is v3 of adding basic support for running nested guests (L2) in
kselftest. This time a framework for enabling stage-2 in the guest is
added, including the s2_mmu struct, s2 translation control setup, and
a stage-2 page table generator. Similar to L2 vCPU management, all
stage-2 work is done in the guest instead of userspace.

An additional shadow_stage2 test is added which leverages the framework
to run L2 with stage-2 enabled.

* Changes from v2 [1]:

  - Update vm_paddr_t to gpa_t, vm_vaddr_t to gva_t.

  - Added framework for enabling stage-2 in the guest.

  - Added shadow_stage2 test.

Thanks!

[1]: https://lore.kernel.org/kvmarm/20260412142216.3806482-1-weilin.chang@arm.com/

Wei-Lin Chang (9):
  KVM: arm64: selftests: Add GPR save/restore functions for NV
  KVM: arm64: selftests: Add helpers for guest hypervisors
  KVM: arm64: selftests: Add hello_nested basic NV selftest
  KVM: arm64: selftests: Enhance hello_nested test
  KVM: arm64: selftests: Add shadow_stage2 test
  KVM: arm64: selftests: shadow_stage2: Allocate L2 stack from dedicated
    pool
  KVM: arm64: selftests: shadow_stage2: Check supported stage-2 granule
    size
  KVM: arm64: selftests: Add infrastructure for using stage-2 in guest
  KVM: arm64: selftests: shadow_stage2: Turn on stage-2 translation for
    the nested guest

 tools/testing/selftests/kvm/Makefile.kvm      |   5 +
 .../selftests/kvm/arm64/hello_nested.c        | 134 +++++++++
 .../selftests/kvm/arm64/shadow_stage2.c       | 165 +++++++++++
 .../selftests/kvm/include/arm64/nested.h      |  85 ++++++
 tools/testing/selftests/kvm/lib/arm64/entry.S | 137 +++++++++
 .../selftests/kvm/lib/arm64/hyp-entry.S       |  77 +++++
 .../testing/selftests/kvm/lib/arm64/nested.c  | 264 ++++++++++++++++++
 7 files changed, 867 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/hello_nested.c
 create mode 100644 tools/testing/selftests/kvm/arm64/shadow_stage2.c
 create mode 100644 tools/testing/selftests/kvm/include/arm64/nested.h
 create mode 100644 tools/testing/selftests/kvm/lib/arm64/entry.S
 create mode 100644 tools/testing/selftests/kvm/lib/arm64/hyp-entry.S
 create mode 100644 tools/testing/selftests/kvm/lib/arm64/nested.c

-- 
2.43.0

