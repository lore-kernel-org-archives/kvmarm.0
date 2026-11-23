Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446607;
	b=dRpN9WsKqkkOi1Pu9U04VEa93cUj7x54avZjBIFYSiLLK7qE9AITpgC4LRYfOvv6EX8+
	 lyJNXGbaTy4ni8fTR9cCNTjRdTHRCFtugaXo++18S3O0Dq4YFN/XeFIH3zt6r/ZXuovoC
	 UlBE/P9FRiU9XwEwezeMknNrgsXDgwYIt8IUNdw6QES2p/zCZ1Yx9lrwqIG0BQ6516bdu
	 wQcT4LVFa5KMfQBZOj4vu+axRG0/fGp1Z374nM5FIsfy1xBeIO1jXvAiKQptT6LPjCUMC
	 TTSvOR7rMiQUP0pA4ueXlsmUBKtX2GS8jsQfc1a3yEStSA4ccKFYCS8XhheabOK+6GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446607;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=DjXxkJO09Tc2aC2/WFAZoPPM/xCjKbBvMJqJr4rhthQ=;
	b=ICJ4QUgyg2UDjgXI4pxQlo48OegvpozFs4KhBaEfMo4gYGPxViGPZoQGYkMZXmttWLXu
	 Rft1TB5i5vUs9OcgIfhGArev8J/aKo2u5JwySSFD0fXarX4gj1iTIF1LGBvm1kuGu9nqW
	 MVl6N5dhaRxECY/8tsRpMdYb3sLJENpd7WS57UishVSyUmu7hTxxycd1oHFwRofZx3AfM
	 efVpsDvnXdelCF0e/VNSZrg2x/6Wjx6TycKCNiEg0IdEb0VkY/yPCLMMtjySsQoLyOwep
	 5ZaH+l/6ta0zUDL+0HkXM5oAmRvKlJvhH+S/oWS1KRjLCE7EER2jdYzN7MN4BW4fSxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=UAmNmUqH;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D6EC606A31F
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 15:10:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D6EC606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=UAmNmUqH
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 69FCC143D;
	Mon, 23 Nov 2026 07:10:02 -0800 (PST)
Received: from entos-yitian-01.Arm.com (unknown [10.168.196.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 203273F632;
	Mon, 23 Nov 2026 07:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795446605; bh=CoKGKHf3X6ePMybvJ0+rBCrZ9GSS1W96TB5Eff/LIWs=;
	h=From:To:Cc:Subject:Date:From;
	b=UAmNmUqHY/Vl2F24ON3PyeqyELFzQxo9KglHjT7r0aOexNfnPrReUWA2lq2aORq+g
	 IwAjGM1CL3qCrV3R5kaMhzRauDjZqgWx8vIzXJgRqyIgaM/8FJLKo/Shiymg53Qnln
	 J0lwHZDL78emthTkO6XsSH6TFciD8PvGcxwXexgQ=
From: Jia He <justin.he@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Jia He <justin.he@arm.com>
Subject: [PATCH 0/3] KVM: arm64: Fix pre-first-run KVM_PRE_FAULT_MEMORY vcpu_load() issues
Date: Mon, 23 Nov 2026 15:09:14 +0000
Message-Id: <20261123150917.2679600-1-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
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

KVM_PRE_FAULT_MEMORY calls vcpu_load() as soon as KVM_ARM_VCPU_INIT has
completed. On arm64, VM and vCPU state such as kvm->arch.sysreg_masks,
trap controls, vncr_tlb and nested vGIC setup is only initialised on the
first KVM_RUN in kvm_arch_vcpu_run_pid_change().

Running the full arch vcpu_load() path before then reads unsanitised
guest sysregs and touches uninitialised nested state. In particular, if
a VMM creates an EL2 vCPU with ID_AA64MMFR4_EL1.NV_frac cleared to 0,
sets HCR_EL2.NV=1 and an EL1 PSTATE, and calls KVM_PRE_FAULT_MEMORY,
kvm_vcpu_load_hw_mmu() queues KVM_REQ_MAP_L1_VNCR_EL2 without a
vncr_tlb. The next KVM_RUN then dereferences NULL in kvm_map_l1_vncr()
with preemption disabled and kvm->mmu_lock held for read.

Patch 1 skips the arch vcpu_load()/vcpu_put() callbacks until
vcpu_has_run_once() is true, and adjusts VHE enter_vmid_context() and
vgic_maintenance_handler() accordingly. Generic vcpu_load() still sets
kvm_running_vcpu for dirty-ring tracking, and pre-faulting only populates
&kvm->arch.mmu.

Patch 2 checks that vncr_tlb is allocated before setting
KVM_REQ_MAP_L1_VNCR_EL2 and adds a WARN_ON_ONCE(!vt) check in
kvm_map_l1_vncr().

Patch 3 extends nv_pre_fault_memory_test to cover pre-first-run
pre-faulting. The cases that do not need EL2 run on all hosts. On an
unfixed kernel, the staged nested context case triggers the "Separate
virtual IRQ/FIQ settings not supported" WARN while the test still
passes, so the kernel log must be checked as well.

Jia He (3):
  KVM: arm64: Don't load hardware vCPU state before first run
  KVM: arm64: nv: Don't request or attempt L1 VNCR mapping without
    vncr_tlb
  KVM: selftests: arm64: Test KVM_PRE_FAULT_MEMORY before first KVM_RUN

 arch/arm64/kvm/arm.c                          |  17 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                  |   3 +-
 arch/arm64/kvm/nested.c                       |   6 +-
 arch/arm64/kvm/vgic/vgic-init.c               |   2 +-
 .../kvm/arm64/nv_pre_fault_memory_test.c      | 335 ++++++++++++++++--
 5 files changed, 321 insertions(+), 42 deletions(-)


base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.34.1

