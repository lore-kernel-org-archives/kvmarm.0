Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.82
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621192;
	b=Mq2pSXs65Cjbm48YTR90jZAevFquP3hYK1BekgiuWRm99EOGowickXedmPrR3Bps+p/s
	 WRU9TY5YpqOgEy08DAQrNqf9bLaszD8/6b5XODS+RLjVIEmhzjMzc/Jj2Ppqa5CiPRUcX
	 fbD6Zeu8kVgCaPsaqBp4w8swJ+dPr9gBTzBLnJGWSxKWPEtM0id1hPZ+6nX1dGJAHiua4
	 MO4RqZTPc+t4aEOa+KWMMQW15xK2eHdi0okxh1VAc1iW4COzWin8CpXCVdMRSZrO1ssM1
	 NU8wtmq1mI6LKqUKoNLUn8lP1tl4SjHe04Shh7pXcQk736FykOTcPbPlV++bsSiGfgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621192;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=g8Y+VjlhAuPJi/mSdE+SsemjmM6ohHErbBXjp4HQBX8=;
	b=1NRYY86Etx5PKOR3Ko7f38M138gJgBlfGc3UpuTBTlt0mV02Vr5g8/+Xj++Hv9oC8XAH
	 olitzpNT1AiCaWP60xUFcyPB/e+coAOhcJbx1yTs963mx/5WpQFEiUBK8kYbjHSYkkkPq
	 24AAHRPdQpQKMQC9NEIH5iN2NppYCcV+r7Z0ToHBFaCn99gsXyfl4L3RDuZ17FpAz1btX
	 dMOIoHgEfiY0F4sbou7ET1Q0eL94/vSaY5Xam8hJNi3W9tF/I1MXWD7Cc889uZ5Ypxh9s
	 2LqxLgn9qD5N0LloMOnyXYeS563e32gm8RPBbfjGVhMd0DwG6QBbpo2vGGmABxw15Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LimZQkx0;
	arc=none smtp.remote-ip=95.215.58.82
Received: from mta1.migadu.com (out-82.mta1.migadu.com [95.215.58.82])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93516606A335
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:39:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93516606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LimZQkx0
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=z0MdkXXkhI4FyI4pRvxVmInAnq+lBk663TaLC9etFxs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795621189; v=1; x=1796225989;
 b=LimZQkx0qgZqlp2OTs9fxIRVylICj1WT03q+IlqtnvRRyZ9iMMUqsjDC59VCqU2B/t0BRi3F
 JJ5u0Ad+pilX2sMnPddCyfCE1jCUVlH4ee7sG/Q20wd/I2eO8j2uldl+0XxTb0NvkeVfI2XZ78D
 wfbESd2cKi8Sjb26KCh5oqqk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b2b04a39099f7a6d;
	Wed, 25 Nov 2026 15:39:49 +0000
X-Mizu-Trace-ID: b2b04a39099f7a6d
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
Subject: [PATCH v2 07/20] KVM: arm64: Allow protected VMs to use SVE
Date: Wed, 25 Nov 2026 15:38:58 +0000
Message-ID: <20261125153911.106793-8-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261125153911.106793-1-fuad.tabba@linux.dev>
References: <20261125153911.106793-1-fuad.tabba@linux.dev>
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
index 155ac35069245..9350caed1e8e7 100644
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
index 352998a07512a..0a536b237a7c9 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -712,8 +712,6 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	ID_UNALLOCATED(7,6),
 	ID_UNALLOCATED(7,7),
 
-	/* Scalable Vector Registers are restricted. */
-
 	HOST_HANDLED(SYS_ICC_PMR_EL1),
 
 	RAZ_WI(SYS_ERRIDR_EL1),
-- 
2.47.3

