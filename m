Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 159FD612FE
	for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 10:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708423869; cv=none; b=G2ed8gDyV0VLzbmUWPUCgoj13xkGkt/QJKZpZEyI/OE/5joowMhWVW4xeNb5l/sJl0TCsjFOL73VK4TfDNtZ/6ByzbMKBPthTA5fXi1VDylxemZplR+DmKPl9t5p+8eJbx9LubpvC4zbL1eRhdE55WcVEvsCxoBp2lgXbbYyibE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708423869; c=relaxed/simple;
	bh=cbxfJgCAmVL5Spatj5+lcM+mVBl+lKDc+gUzzsinU6E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Nmk76zzSw8dCi03lex82vwQKyi3Js8RzkecGZDhkwddM2Zcnd1vo4rYG4C7SoqazRMjcf0C1o1JNALr2s6ltMPJvPs3XPBqJmacm/vjhIWXXmXgkOi3oTxJdQxzMGVulp4Or6SUG6G1vdS4T5UOPN4Z1XxHjQ69OyQ5d9kE/U2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 858DE1007;
	Tue, 20 Feb 2024 02:11:46 -0800 (PST)
Received: from e127643.broadband (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7BD703F762;
	Tue, 20 Feb 2024 02:11:01 -0800 (PST)
From: James Clark <james.clark@arm.com>
To: coresight@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	maz@kernel.org,
	suzuki.poulose@arm.com,
	acme@kernel.org,
	oliver.upton@linux.dev,
	broonie@kernel.org
Cc: James Clark <james.clark@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Miguel Luis <miguel.luis@oracle.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Helge Deller <deller@gmx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 6/7] arm64: KVM: Write TRFCR value on guest switch with nVHE
Date: Tue, 20 Feb 2024 10:09:16 +0000
Message-Id: <20240220100924.2761706-7-james.clark@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240220100924.2761706-1-james.clark@arm.com>
References: <20240220100924.2761706-1-james.clark@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The guest value for TRFCR requested by the Coresight driver is saved in
kvm_guest_trfcr. On guest switch this value needs to be written to
the register. Currently TRFCR is only modified when we want to disable
trace completely in guests due to an issue with TRBE. Expand the
__debug_save_trace() function to always write to the register if a
different value for guests is required, but also keep the existing TRBE
disable behavior if that's required.

In pKVM, the kvm_guest_trfcr can't be read and the host isn't trusted,
so always disable trace.

__debug_restore_trace() now has to restore unconditionally, because even
a value of 0 needs to be written to overwrite whatever was set for the
guest.

Signed-off-by: James Clark <james.clark@arm.com>
---
 arch/arm64/kvm/hyp/nvhe/debug-sr.c | 53 +++++++++++++++++-------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 4558c02eb352..3adac2e01908 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -51,30 +51,39 @@ static void __debug_restore_spe(u64 pmscr_el1)
 	write_sysreg_s(pmscr_el1, SYS_PMSCR_EL1);
 }
 
-static void __debug_save_trace(u64 *trfcr_el1)
+static void __debug_save_trace(struct kvm_vcpu *vcpu)
 {
-	*trfcr_el1 = 0;
-
-	/* Check if the TRBE is enabled */
-	if (!(read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E))
-		return;
-	/*
-	 * Prohibit trace generation while we are in guest.
-	 * Since access to TRFCR_EL1 is trapped, the guest can't
-	 * modify the filtering set by the host.
-	 */
-	*trfcr_el1 = read_sysreg_s(SYS_TRFCR_EL1);
-	write_sysreg_s(0, SYS_TRFCR_EL1);
-	isb();
-	/* Drain the trace buffer to memory */
-	tsb_csync();
+	u64 host_trfcr_el1 = read_sysreg_s(SYS_TRFCR_EL1);
+	u64 guest_trfcr_el1;
+
+	vcpu->arch.host_debug_state.trfcr_el1 = host_trfcr_el1;
+
+	/* Check if the TRBE buffer or pKVM is enabled */
+	if (is_protected_kvm_enabled() ||
+	    (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRBE) &&
+	     read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E)) {
+		/*
+		 * Prohibit trace generation while we are in guest. Since access
+		 * to TRFCR_EL1 is trapped, the guest can't modify the filtering
+		 * set by the host.
+		 */
+		write_sysreg_s(0, SYS_TRFCR_EL1);
+		isb();
+		/* Drain the trace buffer to memory */
+		tsb_csync();
+	} else {
+		/*
+		 * Tracing is allowed, apply the filters provided by the
+		 * Coresight driver.
+		 */
+		guest_trfcr_el1 = kvm_guest_trfcr[vcpu->cpu];
+		if (host_trfcr_el1 != guest_trfcr_el1)
+			write_sysreg_s(guest_trfcr_el1, SYS_TRFCR_EL1);
+	}
 }
 
 static void __debug_restore_trace(u64 trfcr_el1)
 {
-	if (!trfcr_el1)
-		return;
-
 	/* Restore trace filter controls */
 	write_sysreg_s(trfcr_el1, SYS_TRFCR_EL1);
 }
@@ -85,8 +94,8 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_SPE))
 		__debug_save_spe(&vcpu->arch.host_debug_state.pmscr_el1);
 	/* Disable and flush Self-Hosted Trace generation */
-	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRBE))
-		__debug_save_trace(&vcpu->arch.host_debug_state.trfcr_el1);
+	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRFCR))
+		__debug_save_trace(vcpu);
 }
 
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
@@ -98,7 +107,7 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_SPE))
 		__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
-	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRBE))
+	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRFCR))
 		__debug_restore_trace(vcpu->arch.host_debug_state.trfcr_el1);
 }
 
-- 
2.34.1

