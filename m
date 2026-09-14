Received: from mta0.migadu.com (out-213.mta0.migadu.com [91.218.175.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BCA43CECB
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 11:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385740; cv=none; b=IhWAyKXdq2XPBpaJfQSxtLHXjOcXKlDwLtxy/o1k3JBvDIBWn/FWuWKtxtVEev/fRxf3lBUFfgsxEN4Nv42rAfQw9hiO07286eBbpN1V1HiPeoDFh8hnBiMosqE0Ht2iME0aLVD9bSTpp8CGeDdY8h9WYmiAzofSKWxAGQaxw6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385740; c=relaxed/simple;
	bh=UrkAa/Ibk4oC0D29/DNAsgafr0M8SDNie/XH9u/vDGg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ai3ZA/8GbBL1YSMX0/8pjMNTa9NKx38+AfvTy3WPXdvbZMiZXsTkopQAdgqTVyljjot9k5EyQ2W4nnyazYLf8P3P/rvvShXYGahVr3nx8XlXrJfx2waQFsthCx//RcaHVjQTiICIE/s//cp5EKfgvuI5emZR/4Pm6obATi3/jTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Xrt1+l2c; arc=none smtp.client-ip=91.218.175.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Xrt1+l2c"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=UrkAa/Ibk4oC0D29/DNAsgafr0M8SDNie/XH9u/vDGg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789385735; v=1; x=1789990535;
 b=Xrt1+l2cMryOTsYAykFifDE0FAX2ytDX/PTjnOjwFaykSWeaCHPfibwbHUmneeqy4dtBwedO
 EP/Myj+MpUWhn+W0sC+cs5yD3EHyA+kceOtxsa3LppApvulg69lLUpPAHOhGrxtQgrl7LT9RfzA
 iUzCTCDYFiCM//kLL1YeOol4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9fe719e5f9392432;
	Mon, 14 Sep 2026 11:35:35 +0000
X-Mizu-Trace-ID: 9fe719e5f9392432
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	steven.price@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	tabba@google.com
Subject: [PATCH v3 13/18] KVM: arm64: Inject an UNDEF at EL2 for unhandled protected guest exits
Date: Mon, 14 Sep 2026 12:33:33 +0100
Message-Id: <20260914113338.159227-14-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260914113338.159227-1-fuad.tabba@linux.dev>
References: <20260914113338.159227-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make pvm_exit_handlers[] an allow-list: a protected guest's exit class
is handled at EL2, forwarded where the host emulates it, or results in
an UNDEF at EL2. Any other class, once forwarded, would re-execute
forever. The host resolves such an exit by injecting an exception or
incrementing the PC. The marshalling that follows allows neither: a
protected vCPU takes only the UNDEF on a SYS64 trap and the external
abort on a forwarded IABT or DABT that EL2 builds for it.

WFxT takes the UNDEF, as it isn't advertised to protected guests.
FP/SIMD keeps the lazy switch, and the watchpoint entry is dropped: a
protected vCPU runs with TDE clear.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 7318e3e6a5f36..afddcf14f366e 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -203,15 +203,36 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_MOPS]		= kvm_hyp_handle_mops,
 };
 
+/* WFI/WFE exit to the host, which emulates them. WFxT is not offered. */
+static bool kvm_handle_pvm_wfx(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_WFx_ISS_WFxT)
+		return kvm_handle_pvm_restricted(vcpu, exit_code);
+
+	return false;
+}
+
+/* Lazy FP/SIMD switch, or the UNDEF the host would otherwise be asked for. */
+static bool kvm_handle_pvm_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	if (kvm_hyp_handle_fpsimd(vcpu, exit_code))
+		return true;
+
+	return kvm_handle_pvm_restricted(vcpu, exit_code);
+}
+
+/*
+ * A class not listed takes an UNDEF at EL2: the host has no way to
+ * inject one into a protected vCPU.
+ */
 static const exit_handler_fn pvm_exit_handlers[] = {
-	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[0 ... ESR_ELx_EC_MAX]		= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_WFx]		= kvm_handle_pvm_wfx,
 	[ESR_ELx_EC_HVC64]		= kvm_handle_pvm_hvc64,
 	[ESR_ELx_EC_SYS64]		= kvm_handle_pvm_sys64,
-	[ESR_ELx_EC_SVE]		= kvm_handle_pvm_restricted,
-	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
+	[ESR_ELx_EC_FP_ASIMD]		= kvm_handle_pvm_fpsimd,
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
-	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_hyp_handle_watchpt_low,
 	[ESR_ELx_EC_MOPS]		= kvm_hyp_handle_mops,
 };
 
-- 
2.39.5

