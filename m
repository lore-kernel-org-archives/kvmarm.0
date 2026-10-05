Received: from mta1.migadu.com (out-237.mta1.migadu.com [95.215.58.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A842BDC0E
	for <kvmarm@lists.linux.dev>; Mon,  5 Oct 2026 05:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791176640; cv=none; b=h2j7NaTsXMpVhAXEDWfQOL+4bcWtewpGjdqNnHWK7o+mQg4aSPDp/cDyRJPAhrCQTwXmMPxnXO37wTUF9Z1fG3ycB7Zxo5DF7tYvgLXPoFOqCl3q53QVVSQs9Uoe/02IqtYZhjfjMA0vny7p1ZP8J0CvYRAb8YkzNfNAW+85iI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791176640; c=relaxed/simple;
	bh=X2NngjtUK3UIGZuKRsaGbM1Nn8I+pzP8pxoF8AGn/sk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Dgp8fV6/vU2shXEUugGqojSnGosVhlW8+BobizPy12FYUSc297BHX3RhKReDNMNn40w1H42n3jbMl8kxpZ75AR6i+UYZAGOoSQcLRDfUvd2MFts9xpd304JNEWJ4B2KVmsiJ6Aubnmo7UBRb07ILy8UaWe3Zgwtf4xNY8v7IcGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YgGTHIl4; arc=none smtp.client-ip=95.215.58.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YgGTHIl4"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=X2NngjtUK3UIGZuKRsaGbM1Nn8I+pzP8pxoF8AGn/sk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791176636; v=1; x=1791781436;
 b=YgGTHIl4h42GtXWpwWVzwnO0+3KLoSTk8HvVmhlxI5ku1kPGwKuqwYpAQBx6pwQjUujdZInA
 5gNcSXvsPDlig0ReaaO2gqyvqBj4JYDUD2/yw5t5iTSHIifLINA5gElwjrkblH3whvw+gWjYDRu
 tGa2RVG1zdsN8Mj8TsiqdnNI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2334147f9724cdcb;
	Mon, 05 Oct 2026 05:03:56 +0000
X-Mizu-Trace-ID: 2334147f9724cdcb
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
	vdonnefort@google.com,
	qperret@google.com,
	tabba@google.com,
	mark.rutland@arm.com
Subject: [PATCH] KVM: arm64: Pend host SErrors for protected vCPUs through HCR_EL2.VSE
Date: Mon,  5 Oct 2026 06:03:52 +0100
Message-Id: <20261005050352.836980-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_inject_serror_esr() reads PSTATE.A and SCTLR2_EL1.NMEA to decide
whether to emulate the SError's exception entry or pend it through
HCR_EL2.VSE. For a protected vCPU, the host's copy of those is stale,
and when it reads as unmasked KVM emulates the entry on that copy. EL2
never delivers it as an SError: its entry handler turns the pending
exception into an external abort on the trapped access, and an MMIO
completion still pending trips WARN_ON(INCREMENT_PC).

Always pend through HCR_EL2.VSE for a protected vCPU. EL2 forwards it,
and the guest's own masking decides when the SError is taken.

Fixes: 872383bd12e11 ("KVM: arm64: Add per-EC entry/exit state marshalling for protected guests")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20261001142109.794CA1F000FF@smtp.kernel.org/
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
Applies on kvmarm/next. A follow-up to "KVM: arm64: Confine protected VM
vCPU state to EL2" [1], from Sashiko's review of its v4 patch 12.

[1] https://lore.kernel.org/all/20261001135711.1640520-1-fuad.tabba@linux.dev/

 arch/arm64/kvm/inject_fault.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index d6c4fc16f8795..49a342b078365 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -378,8 +378,11 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
 	 *
 	 * As we're emulating the SError injection we need to explicitly populate
 	 * ESR_ELx.EC because hardware will not do it on our behalf.
+	 *
+	 * A protected vCPU's PSTATE and SCTLR2_EL1 live at EL2, so pend through
+	 * HCR_EL2.VSE and let the guest's own masking apply.
 	 */
-	if (!serror_is_masked(vcpu)) {
+	if (!vcpu_is_protected(vcpu) && !serror_is_masked(vcpu)) {
 		pend_serror_exception(vcpu);
 		esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR) | ESR_ELx_IL;
 		vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));

base-commit: fa22cd9947fc245d71bc40482f7f78eb0d5a4af0
-- 
2.39.5

