Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4852B26ED5A
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136521; cv=none; b=Ku/XoGXDqZfoc/tLeLF5He28wDqgIDuE5DqZ/h0r6KN8Rshz4TS+AKiLaPR4IgVtvH/LwDUhGVFzss8W6L6l7Wmr5Y1yvvlf1aENWvWQsNUpBeCX37SnK78Gcdg73hCPIdbNmJSEUf+An5+xGG03NnLfYz02JUZyXKF9gBzrQis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136521; c=relaxed/simple;
	bh=cVt2KZ6QTD9zFENrQxCdgV0o7HFCcrDgxMD1ox/v0wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzepnTiQs3z2K8cRZsHFtUsg49MpUNu78C+JZlr2zceqCr+Y3gQEzWNBCTaovg/A4RNHVBteessYZta/cyuEM/CupcHsutEHVNfKCMIixvekVhS9lMnOC/wmKomoudW+Y+PESO06p2CeexL9duXPCvHTK/YA+MDJO8LBqfa5iu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A9FD1BCA;
	Fri, 14 Nov 2025 08:08:32 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BFD5D3F5A1;
	Fri, 14 Nov 2025 08:08:37 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 26/35] KVM: arm64: Add comment to explain how trapped SPE registers are handled
Date: Fri, 14 Nov 2025 16:07:07 +0000
Message-ID: <20251114160717.163230-27-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SPE buffer registers are trapped, while the sampling control registers
are directly accessed by the guest. The in-memory value of PMBSR_EL1 can be
modified by both the guest, following a direct write, and the hardware,
following a hardware maintenence interrupt. The in-memory value is never
written to the hardware.

The rest of the buffer register are written to the hardware at different
times in the VCPU run loop.

Add a comment explaining all of this.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/spe.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
index 6e8e0068e7e4..b138b564413b 100644
--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ -126,6 +126,46 @@ u8 kvm_spe_get_pmsver_limit(void)
 	return min(pmsver, ID_AA64DFR0_EL1_PMSVer_V1P5);
 }
 
+/*
+ * Note on register handling:
+ *
+ * - Only the buffer registers (this includes PMBIDR_EL1) and PMSIDR_EL1 are
+ *   trapped, the rest of the registers the guest can access directly.
+ *
+ *  - PMBIDR_EL1 is trapped so KVM can advertise to the guest the maximum buffer
+ *  size set by userspace.
+ *
+ *  - PMSIDR_EL1 is trapped to hide the presence of features which the VM does
+ *  not have, but the hardware implements.
+ *
+ * - PMBLIMITR_EL1:
+ *   * Guest value is written to hardware only when
+ *   kvm_spe_profiling_buffer_enabled() is true. This is done after KVM enables
+ *   stage 2.
+ *   * KVM always disables the buffer (PMBLIMITR_EL1.E=0) when exiting the
+ *   guest. This is done before stage 2 is disabled.
+ *   * In-memory value of the register is updated following a direct write to
+ *   the register by the guest.
+ *
+ * - PMBSR_EL1:
+ *   * In-memory value of the register is never written to hardware.
+ *   * The hardware value of the register is cleared on guest exit if KVM
+ *   detects that the service bit is set.
+ *   * In-memory value of the register is updated in the following situations:
+ *     - Following a direct write to the register by the guest.
+ *     - When the buffer has been misprogrammed.
+ *     - When the hardware asserts the management event interrupt.
+ *
+ * - PMBPTR_EL1:
+ *   * Guest value is written to hardware:
+ *     - Before entering the guest, if kvm_spe_profiling_buffer_enabled() is
+ *     true.
+ *   * In-memory value of the register is updated:
+ *     - Following a direct write to the register by the guest.
+ *     - On each exit from the guest, if kvm_spe_profiling_buffer_enabled() was
+ *     true when the guest was entered.
+ */
+
 /* Implements OtherSPEManagementEvent() from ARM DDI0487L.b */
 static void kvm_spe_inject_other_event(struct kvm_vcpu *vcpu, u8 bsc)
 {
-- 
2.51.2

