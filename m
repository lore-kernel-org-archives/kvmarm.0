Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.183
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794213148;
	b=iAXznPD3jrcGJ9QzKEiht/K01kWiPU6tYPKmupY88I0HQ2fFJ0d48QUNwUIShE3ffTOZ
	 4Je3GIug0VbYjKwpQkpyl0HT3zCm3gL/1lH1aSEpLPmSueBUsUqQdxlVlvA/Q7DxI8qJH
	 eiXJDr0Dl6vs/ttstJUT99fpBRYUvR2d7n7THpUGPE7GWf519eK8CAMfGC/84b87jmJvd
	 mPHDAwheYLfikVh/Qqp7Uj2SUhLRIT8gFT5S/aGPYGgGBdxd1F+aElsYWTbA1nFIAdW5f
	 cwHcoVQQHkCEdbMBdO6fYaxVOmpNbipdUTeKlXEEfnHWqpNQRRpzdlxQsXw5cH4PN9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794213148;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZpANXrzYcq9/O8jJB8VjHM2H1WoWmBRtRKM62lXj9eg=;
	b=UUXjR1/MyndSkwfqN65Zd1UVQFahulCU/IV8wif1nnESESPI04okdwfP4hU58br+tLtp
	 wLR/seJI1mqD55aspge1G8WsYHY543pwHeOxREuODHWQwGcvYEmUk5oaN8gLVd8Cmc/iB
	 rmVHGS6MwkdS+CT4JioYd7tz3hJuKCO2JJf6cgkgRFIZ5PIGVMW+AHhMHLXQRvk/I8SgV
	 P0yu7LLq7bHp94KykXOfahkKdMsfW59zngLNKTacxfrCzEGcc4YwcwOumYetdUF1fBjg7
	 uFDLUCJ9L2/WqV4i9nKUWPE5yNhz3M19hPfwpRkAifsQYRzOPSBA/IcgTEtp7ePwGKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nfHftJQx;
	arc=none smtp.remote-ip=91.218.175.183
Received: from mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7037606A322
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:32:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7037606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nfHftJQx
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=GiKRpVPhtPxXBSxxO8gfUr2emmVqiFR0Oyh/Nveq+SY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794213145; v=1; x=1794817945;
 b=nfHftJQxRVyFtsbAQPjPd3czxXstYq10FVnJRkqskInuEfCNDYPPygcNmzfo3ZGH9lOUidEm
 /S/i4QepuAalekU7QPm3h1V0Bw7aTD4mPTF3wvRftp+3VhnwhCdmMnaIahIbw2VjKHNF//rKb9c
 vsSfgfDVrpej8cjyY0Y3nkN4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id cf3918cd7b88d11f;
	Mon, 09 Nov 2026 08:32:25 +0000
X-Mizu-Trace-ID: cf3918cd7b88d11f
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 05/16] KVM: arm64: Allow protected VMs to use SVE
Date: Mon,  9 Nov 2026 08:31:54 +0000
Message-ID: <20261109083205.806619-6-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109083205.806619-1-fuad.tabba@linux.dev>
References: <20261109083205.806619-1-fuad.tabba@linux.dev>
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

Now that EL2 owns a protected vCPU's SVE state and advertises
ID_AA64ZFR0_EL1, allow KVM_CAP_ARM_SVE for a protected VM, which lets
KVM_ARM_VCPU_INIT take KVM_ARM_VCPU_SVE.

A protected guest's SVE access trap injects an UNDEF. An SVE
instruction takes the SVE trap rather than the FP one, so a guest whose
first vector instruction is an SVE one would get an UNDEF instead of
the lazy FP switch. Handle the SVE trap as the FP trap is:
kvm_handle_pvm_fpsimd() switches the state for a vCPU with SVE and
still injects the UNDEF for one without.

Update the documentation to match.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 Documentation/virt/kvm/arm/pkvm.rst | 6 +++---
 arch/arm64/include/asm/kvm_pkvm.h   | 1 +
 arch/arm64/kvm/hyp/nvhe/switch.c    | 1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c  | 2 --
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/arm/pkvm.rst b/Documentation/virt/kvm/arm/pkvm.rst
index b8c8c94cba534..c59e598645b1b 100644
--- a/Documentation/virt/kvm/arm/pkvm.rst
+++ b/Documentation/virt/kvm/arm/pkvm.rst
@@ -134,9 +134,9 @@ A protected VM boots from a single primary vCPU. Before the first
 * Set the primary vCPU's boot state with ``KVM_SET_ONE_REG``: the kernel
   entry address in ``PC`` and the DTB pointer in ``x0``.
 
-``PC`` and ``x0`` are the only registers EL2 takes from the host. Other
-pre-run writes are accepted, but the guest starts from the state the
-hypervisor resets it to.
+``PC``, ``x0`` and the SVE vector lengths (``KVM_REG_ARM64_SVE_VLS``) are
+the only registers EL2 takes from the host. Other pre-run writes are
+accepted, but the guest starts from the state the hypervisor resets it to.
 
 Secondary vCPUs are started by the guest itself through PSCI ``CPU_ON``
 (see `Power state`_), which supplies their entry point and context ID.
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index fd042d2b54624..5f1b3308b42e1 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -40,6 +40,7 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 	case KVM_CAP_MAX_VCPU_ID:
 	case KVM_CAP_MSI_DEVID:
 	case KVM_CAP_ARM_VM_IPA_SIZE:
+	case KVM_CAP_ARM_SVE:
 	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 	case KVM_CAP_ONE_REG:
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 89fb9dd351ad5..0626f4203ba6d 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -230,6 +230,7 @@ static const exit_handler_fn pvm_exit_handlers[] = {
 	[ESR_ELx_EC_WFx]		= kvm_handle_pvm_wfx,
 	[ESR_ELx_EC_HVC64]		= kvm_handle_pvm_hvc64,
 	[ESR_ELx_EC_SYS64]		= kvm_handle_pvm_sys64,
+	[ESR_ELx_EC_SVE]		= kvm_handle_pvm_fpsimd,
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_handle_pvm_fpsimd,
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 8456bb44edd52..78c25da737591 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -713,8 +713,6 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	ID_UNALLOCATED(7,6),
 	ID_UNALLOCATED(7,7),
 
-	/* Scalable Vector Registers are restricted. */
-
 	HOST_HANDLED(SYS_ICC_PMR_EL1),
 
 	RAZ_WI(SYS_ERRIDR_EL1),
-- 
2.47.3

