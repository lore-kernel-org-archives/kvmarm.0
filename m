Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE6F18C2C
	for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 13:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771247467; cv=none; b=g0qr2HgEkLoQPM5WZplnAd8c9k0B2/AikJgkjVnb2Y1zrgTdCAerXVVggbuKhbUs6/yR+BesgPBZ4YgIoGcSwbTGLPECPH/l0X09GoOi8rtYleJoLRuDgh2c4GXXHGcvBP4o1GsTnFE/6BkPc5xbJG8TWCD6U6VLC32rwwprc2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771247467; c=relaxed/simple;
	bh=TSD9/IFEepdxC1gVVp1H4jqkySJsKvLuQD0t8ridnm4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mwGKs7RGAiQXgMGASbRUJeBMgwi6wrkDia3/sI61BtM26MDxqFQRb+N5IXkPXTpYnS0Fy3BBETCiPLqhkga8QU2d+rUbhPVtWWt2isNYrk+LDuXsL0DQmVFzNUrLulYqqua6ZHnNd/Ethu6LpLjfWhidtWxlHBynw2CiKYP6+kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H8ESrVCL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H8ESrVCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF42C116C6;
	Mon, 16 Feb 2026 13:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771247467;
	bh=TSD9/IFEepdxC1gVVp1H4jqkySJsKvLuQD0t8ridnm4=;
	h=From:To:Cc:Subject:Date:From;
	b=H8ESrVCLCCPeV0Fk5/tlkfiYcrIoZBbLux+546Yt0t2KRWvljgKFUO1+fTx5ekGFW
	 o0q4hB9z6VpW1HaAJ/8SfvAoNkAbUQ8/4Vt9q2NzSTtc3n1pzR20W3UrUGt9L2LXcP
	 ELnajc70ct1mh2FjnH7kk0J5Ca/eDCP33jpd2NsCvlBO5MFKDdn0MaBu/+sqOOxQNp
	 +PoEbA8PQi32cBl9qDCoUI14JCaGpK1yXjVPKxiKdBtHdnJc5ABoU+tqEbxe3tETIG
	 F/0Pzh7UInE9QfRRBF0Msdam87jH1ESWc9sRk1+iyBfIyZFzYNycKWHCr91XymyHNE
	 v7jBWG/bDaHUg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH] KVM: arm64: Disable TRBE Trace Buffer Unit when running in guest context
Date: Mon, 16 Feb 2026 13:09:59 +0000
Message-ID: <20260216130959.19317-1-will@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nVHE world-switch code relies on zeroing TRFCR_EL1 to disable trace
generation in guest context when self-hosted TRBE is in use by the host.

Per D3.2.1 ("Controls to prohibit trace at Exception levels"), clearing
TRFCR_EL1 means that trace generation is prohibited at EL1 and EL0 but
per R_YCHKJ the Trace Buffer Unit will still be enabled if
TRBLIMITR_EL1.E is set. R_SJFRQ goes on to state that, when enabled, the
Trace Buffer Unit can perform address translation for the "owning
exception level" even when it is out of context.

Consequently, we can end up in a state where TRBE performs speculative
page-table walks for a host VA/IPA in guest/hypervisor context depending
on the value of MDCR_EL2.E2TB, which changes over world-switch. The
result appears to be a heady mixture of data corruption and hardware
lockups.

Extend the TRBE world-switch code to clear TRBLIMITR_EL1.E after
draining the buffer, restoring the register on return to the host.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: James Clark <james.clark@linaro.org>
Cc: Leo Yan <leo.yan@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Fixes: a1319260bf62 ("arm64: KVM: Enable access to TRBE support for host")
Signed-off-by: Will Deacon <will@kernel.org>
---

NOTE: This is *untested* as I don't have a TRBE-capable device that can
run upstream but I noticed this by inspection when triaging occasional
hardware lockups on systems using a 6.12-based kernel with TRBE running
at the same time as a vCPU is loaded. This code has changed quite a bit
over time, so stable backports are not entirely straightforward.
Hopefully James/Leo/Suzuki can help us test if folks agree with the
general approach taken here.

 arch/arm64/include/asm/kvm_host.h  |  1 +
 arch/arm64/kvm/hyp/nvhe/debug-sr.c | 36 ++++++++++++++++++++++--------
 2 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ac7f970c7883..a932cf043b83 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -746,6 +746,7 @@ struct kvm_host_data {
 		u64 pmscr_el1;
 		/* Self-hosted trace */
 		u64 trfcr_el1;
+		u64 trblimitr_el1;
 		/* Values of trap registers for the host before guest entry. */
 		u64 mdcr_el2;
 		u64 brbcr_el1;
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 2a1c0f49792b..fd389a26bc59 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -57,12 +57,27 @@ static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
 	write_sysreg_el1(new_trfcr, SYS_TRFCR);
 }
 
-static bool __trace_needs_drain(void)
+static void __trace_drain_and_disable(void)
 {
-	if (is_protected_kvm_enabled() && host_data_test_flag(HAS_TRBE))
-		return read_sysreg_s(SYS_TRBLIMITR_EL1) & TRBLIMITR_EL1_E;
+	u64 *trblimitr_el1 = host_data_ptr(host_debug_state.trblimitr_el1);
 
-	return host_data_test_flag(TRBE_ENABLED);
+	*trblimitr_el1 = 0;
+
+	if (is_protected_kvm_enabled()) {
+		if (!host_data_test_flag(HAS_TRBE))
+			return;
+	} else {
+		if (!host_data_test_flag(TRBE_ENABLED))
+			return;
+	}
+
+	*trblimitr_el1 = read_sysreg_s(SYS_TRBLIMITR_EL1);
+	if (*trblimitr_el1 & TRBLIMITR_EL1_E) {
+		isb();
+		tsb_csync();
+		write_sysreg_s(0, SYS_TRBLIMITR_EL1);
+		isb();
+	}
 }
 
 static bool __trace_needs_switch(void)
@@ -79,15 +94,18 @@ static void __trace_switch_to_guest(void)
 
 	__trace_do_switch(host_data_ptr(host_debug_state.trfcr_el1),
 			  *host_data_ptr(trfcr_while_in_guest));
-
-	if (__trace_needs_drain()) {
-		isb();
-		tsb_csync();
-	}
+	__trace_drain_and_disable();
 }
 
 static void __trace_switch_to_host(void)
 {
+	u64 trblimitr_el1 = *host_data_ptr(host_debug_state.trblimitr_el1);
+
+	if (trblimitr_el1 & TRBLIMITR_EL1_E) {
+		write_sysreg_s(trblimitr_el1, SYS_TRBLIMITR_EL1);
+		isb();
+	}
+
 	__trace_do_switch(host_data_ptr(trfcr_while_in_guest),
 			  *host_data_ptr(host_debug_state.trfcr_el1));
 }
-- 
2.53.0.273.g2a3d683680-goog

