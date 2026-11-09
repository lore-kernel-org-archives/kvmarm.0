Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794214138;
	b=FKXa00jc4mCZRcjPStmo1r9gXYV1f8lA9o7WiizO1CqRZb6TF4B5VQwJlEonYsnLprHj
	 mIxQ8wy2DWpe0mXm8bvdEUXVlmp6Q8wXbllykLWisWkzt00Zb1Hpnmlq77nlGUYpBvWj/
	 YpOOU52Y/N2QN0V9MY/Jqtc0ypu/MQdqFjGd7w4o66Mq45FXAmMVPxCDTehtjZyuZjpNU
	 zCogrQh3BgU6Fhv+xkmh3tW7CXWL/q7q8RPaV82wNMGhoQzvr1KXpdPLkUQktgncNYnEB
	 F7MGvdYC8FwgB+WA+EhFQnDT7cOjKkEgd5hsI/lr0WQIK3E3T9tGvqTip9ymXiwKThQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794214138;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=fBfm9dsEkwLJa3RQILFcp1NS9oIiSGmRdrDoGcyXcLU=;
	b=vrOnaKNf3aHSRJJERqY5Y6AHDzksnitZmLP0/lTFpVIiJiiclpOFdy0Uc56gH1NqEC5M
	 BZ6sC90HuRhRk3+WCw488TZtwzPUzjTzi0Z3QSDufw23M0TwLTtn+pPosBzYZ/jy9Y2ot
	 u0bJ3TaEs33N8fHJATHb6i7wdOQo/qo8J8++QDLgbm4luOA+e1HV+nlK9ilcbVX77VJV/
	 yrlYusv6aP2fJgoR/MU41rjl9cT/BCn17ym6zeCIQ2YpQ86kPMjzfCfdnilxGpp1Oyvtt
	 LnH0HNTlUybv1r3q1p7J+Cfc9WJ+28vzjltR0KZcwuBaKUq45QRzOMmtNzH/1kzVpWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AO9X86Hc;
	arc=none smtp.remote-ip=91.218.175.232
Received: from mta0.migadu.com (out-232.mta0.migadu.com [91.218.175.232])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D62E606A31C
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:48:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D62E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AO9X86Hc
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=1sOzaznMmJOHy+e+QiztzCqMUj8wOs6qA6WdAtqbHAA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794214135; v=1; x=1794818935;
 b=AO9X86HcTL0K+CGNnuBPjfjNLE4+VlvxSRRM58BvIX2mWYXf3ukrfXySEoc8qb2e9zLW7Q1H
 Hf8qEdzgN+FpuZ885LhNtC0c4Rig/HvT/lepYeYotNoH4ESpR+UhO6ucuCjKlr3+/qGFUR9ehHf
 zopKudzN3+xXVCFXQDvgNAIU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 6d1e8b5ddadfa23a;
	Mon, 09 Nov 2026 08:48:54 +0000
X-Mizu-Trace-ID: 6d1e8b5ddadfa23a
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/19] KVM: arm64: selftests: Tests for protected VMs
Date: Mon,  9 Nov 2026 08:48:35 +0000
Message-ID: <20261109084854.840576-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Changes since v1 [1]:
  - New patch 1, which hides generic PtrAuth from a protected VM
    without PtrAuth. The pkvm_id_regs test checks for it.
  - New pkvm_sve test, and MOPS, PIE, POE and FPMR checks in
    pkvm_id_regs.
  - Use the selftest syscall wrappers and vm_check_cap().
  - Marked pkvm_hvc() as called from the guest. (Joey)
  - Collected Reviewed-by from Joey on patches 3, 6 and 7. (thanks!)

This series adds selftests for protected VMs. A test skips on a host
without pKVM, and so does any case where the host doesn't have the
required feature, e.g., PtrAuth, SVE or hugetlb pages.

A couple of points:

- Patch 1 is a fix, included here so that pkvm_id_regs can check the
  correct behaviour. Without it, generic PtrAuth is advertised to a
  protected VM without PtrAuth.

- Each area gets its own test rather than cases folded into existing
  tests such as psci_test, hypercalls, set_id_regs, etc. A protected
  guest requires its own boot path, and has to share the ucall pool
  before its first ucall. On top of that, a protected guest gets the
  opposite result for many of those tests' checks.

- Cases for a feature a protected VM may not have follow what the VM
  is given, so they pass with or without the series that adds it [2],
  and run once it lands. The debug cases follow
  ID_AA64DFR0_EL1.DebugVer, the SVE cases KVM_CAP_ARM_SVE on a
  protected VM's fd, and the MOPS, PIE, POE and FPMR checks their ID
  register fields.

The series is structured as follows:

  01:     Hide generic PtrAuth from protected VMs without PtrAuth.
  02:     external_aborts: an abort injected before a vCPU's first run.
  03-05:  Generic selftest changes: creating a protected VM, the pKVM
          function IDs and the ucall pool's address.
  06-07:  Protected-VM library: boot trampoline and helpers.
  08-18:  The tests, one per area.
  19:     MOPS, PIE, POE and FPMR checks in pkvm_id_regs.

Based on Linux 7.4-rc1 (6628e7d4c6b25; also applies to 7.4-rc2 7475ea8b58616).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261104084842.132944-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/20261109083205.806619-1-fuad.tabba@linux.dev/

Fuad Tabba (18):
  KVM: arm64: Hide generic ptrauth from protected VMs without ptrauth
  KVM: arm64: selftests: Inject an abort before a vCPU's first run
  KVM: selftests: Allow arm64 tests to create protected VMs
  tools: arm-smccc: Add the pKVM memory sharing function IDs
  KVM: selftests: Export the ucall pool's guest physical address
  KVM: arm64: selftests: Add protected-VM library helpers
  KVM: arm64: selftests: Add pkvm_host_abi host-interface test
  KVM: arm64: selftests: Add pkvm_psci multi-vCPU PSCI test
  KVM: arm64: selftests: Add pkvm_mem_share hypercall test
  KVM: arm64: selftests: Add pkvm_smccc hypercall test
  KVM: arm64: selftests: Add pkvm_id_regs register and trap test
  KVM: arm64: selftests: Add pkvm_vcpu_regs register-state test
  KVM: arm64: selftests: Add pkvm_irq interrupt test
  KVM: arm64: selftests: Add pkvm_isolation host-access test
  KVM: arm64: selftests: Add pkvm_lifecycle teardown test
  KVM: arm64: selftests: Add pkvm_exceptions debug and SError test
  KVM: arm64: selftests: Add pkvm_sve vector-length test
  KVM: arm64: selftests: Check MOPS, PIE, POE and FPMR in a protected VM

Will Deacon (1):
  KVM: arm64: selftests: Add protected-VM boot trampoline

 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |   4 +-
 tools/include/linux/arm-smccc.h               |  22 +
 tools/testing/selftests/kvm/Makefile.kvm      |  13 +
 .../selftests/kvm/arm64/external_aborts.c     |  21 +
 .../selftests/kvm/arm64/pkvm_exceptions.c     | 261 ++++++++
 .../selftests/kvm/arm64/pkvm_host_abi.c       | 435 ++++++++++++
 .../selftests/kvm/arm64/pkvm_id_regs.c        | 394 +++++++++++
 tools/testing/selftests/kvm/arm64/pkvm_irq.c  | 268 ++++++++
 .../selftests/kvm/arm64/pkvm_isolation.c      | 225 +++++++
 .../selftests/kvm/arm64/pkvm_lifecycle.c      | 110 +++
 .../selftests/kvm/arm64/pkvm_mem_share.c      | 394 +++++++++++
 tools/testing/selftests/kvm/arm64/pkvm_psci.c | 632 ++++++++++++++++++
 .../testing/selftests/kvm/arm64/pkvm_smccc.c  | 117 ++++
 tools/testing/selftests/kvm/arm64/pkvm_sve.c  | 357 ++++++++++
 .../selftests/kvm/arm64/pkvm_vcpu_regs.c      | 218 ++++++
 .../selftests/kvm/include/arm64/pkvm.h        |  75 +++
 .../selftests/kvm/include/ucall_common.h      |   1 +
 tools/testing/selftests/kvm/lib/arm64/pkvm.c  | 255 +++++++
 .../selftests/kvm/lib/arm64/pvm-entry.S       |  57 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    |   5 +-
 .../testing/selftests/kvm/lib/ucall_common.c  |   9 +-
 21 files changed, 3868 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_exceptions.c
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_host_abi.c
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_id_regs.c
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_irq.c
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_isolation.c
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_lifecycle.c
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_mem_share.c
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_psci.c
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_smccc.c
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_sve.c
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_vcpu_regs.c
 create mode 100644 tools/testing/selftests/kvm/include/arm64/pkvm.h
 create mode 100644 tools/testing/selftests/kvm/lib/arm64/pkvm.c
 create mode 100644 tools/testing/selftests/kvm/lib/arm64/pvm-entry.S

-- 
2.47.3

