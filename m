Received: from mta0.migadu.com (out-203.mta0.migadu.com [91.218.175.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14FA392821
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 08:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791360530; cv=none; b=j/wzn2RATqTQxwCt0aCm/6UmqxckbvbyMSMk+vivRW/oXDOkWU4DJX4JYAx6ErsKBQ7k/zFKU4d7J68Ew9tgzKD5qqZKeP9Riae0A4oqcSf1N8KpoXZ5sFCSa7qymyfSh5jrLZKPMQ44TPaThZeetQm/WdyhVILF7Av2R76ursM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791360530; c=relaxed/simple;
	bh=xUcojllf6XEfIPzebipORABSIXaK1iQh2wjor1f1tws=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Q/+IC7fbIIHXzTdX51WJNsL7CQxixqUvY7BF1vmwfqHkKx+tCxvMGsseZb+okq5VJh2OhVze+svctt+HhXVO6l2eQ7NXG6WyDCkEZEBlc+hYWdZoXqdWgmEJjS5lOkXfIUPx9FZDu8MM2tTHgMHdtToPLic89PU6dFTLBgKI3NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EvtZ4Def; arc=none smtp.client-ip=91.218.175.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EvtZ4Def"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=xUcojllf6XEfIPzebipORABSIXaK1iQh2wjor1f1tws=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791360517; v=1; x=1791965317;
 b=EvtZ4DefdNIgLykCHLkYDu6bDAZ9KkfI08J7Gle3GeTU1W3ckS/f2P5WdIGz4KIiPu0pDzFt
 jDwQAS9SViUC053eXD1h9kbsNbzSDJD8Ja9wtSBecty9tuTafPDFrSQv1Ol3fu2zOQriG9WtgaJ
 RwZDiCK1U9XahP0bvnJEr4xs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 6d6ae5aa49d7ea56;
	Wed, 07 Oct 2026 08:08:37 +0000
X-Mizu-Trace-ID: 6d6ae5aa49d7ea56
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v3] KVM: arm64: Only emulate an SError's entry for vCPUs with NV
Date: Wed,  7 Oct 2026 09:08:33 +0100
Message-Id: <20261007080833.371899-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_inject_serror_esr() emulates an SError's exception entry when the
host's copy of PSTATE says SErrors are unmasked, although only NV needs
this, for a nested context whose guest hypervisor owns the vSError. A
protected vCPU's PSTATE lives at EL2, and the VMM can unmask SErrors in
the host's copy before the first run, so KVM emulates the entry on that
copy and the guest never takes the SError.

Emulate the entry only for a vCPU with NV, which protected VMs don't
support, and otherwise pend the SError through HCR_EL2.VSE, as KVM did
before commit ce66109cec867 ("KVM: arm64: nv: Take "masked" aborts to
EL2 when HCRX_EL2.TMEA is set").

Fixes: 872383bd12e11 ("KVM: arm64: Add per-EC entry/exit state marshalling for protected guests")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20261001142109.794CA1F000FF@smtp.kernel.org/
Suggested-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
v3:
 - Gate the emulated entry in kvm_inject_serror_esr() on vcpu_has_nv(),
   instead of masking SErrors in the host copy at first run (Oliver).

v2:
 - Set PSTATE.A and clear SCTLR2_EL1.NMEA in the host copy when the hyp
   vCPU is created, instead of testing vcpu_is_protected() in
   kvm_inject_serror_esr() (Marc).

Applies on kvmarm/next. A follow-up to "KVM: arm64: Confine protected VM
vCPU state to EL2" [1], from Sashiko's review of its v4 patch 12.

v2: https://lore.kernel.org/r/20261006092826.2201763-1-fuad.tabba@linux.dev/
v1: https://lore.kernel.org/r/20261005050352.836980-1-fuad.tabba@linux.dev/
[1] https://lore.kernel.org/all/20261001135711.1640520-1-fuad.tabba@linux.dev/

 arch/arm64/kvm/inject_fault.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index d6c4fc16f8795..96bf926ca520e 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -371,15 +371,15 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
 	}
 
 	/*
-	 * Emulate the exception entry if SErrors are unmasked. This is useful if
-	 * the vCPU is in a nested context w/ vSErrors enabled then we've already
-	 * delegated he hardware vSError context (i.e. HCR_EL2.VSE, VSESR_EL2,
-	 * VDISR_EL2) to the guest hypervisor.
+	 * With NV, emulate the exception entry if SErrors are unmasked: in a
+	 * nested context with vSErrors enabled, the hardware vSError context
+	 * (i.e. HCR_EL2.VSE, VSESR_EL2, VDISR_EL2) is delegated to the guest
+	 * hypervisor. Otherwise, HCR_EL2.VSE delivers it once it is unmasked.
 	 *
 	 * As we're emulating the SError injection we need to explicitly populate
 	 * ESR_ELx.EC because hardware will not do it on our behalf.
 	 */
-	if (!serror_is_masked(vcpu)) {
+	if (vcpu_has_nv(vcpu) && !serror_is_masked(vcpu)) {
 		pend_serror_exception(vcpu);
 		esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR) | ESR_ELx_IL;
 		vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
-- 
2.39.5

