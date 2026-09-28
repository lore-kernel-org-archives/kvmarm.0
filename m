Received: from mta0.migadu.com (out-231.mta0.migadu.com [91.218.175.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBDF43991C
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 06:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790578008; cv=none; b=WeXDbWAelEnlmPhYudMvkfyyVzNTlXd9KiWt85UkW/x3xBQkI14AQv9XEf8pdOxg3EPtq5rzQP4WLCTj5hRfTQF+V3ZPFlk+36ZLX1fWg+g0/8plqhL/4cgXmQQeH6u/gNSVBU4/WuXePuoHn5H4tO87j2iDB3L2Q2k6ug/+uMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790578008; c=relaxed/simple;
	bh=ytdKApU5ydc5tgMMhT0OgPOrlWOEu72eXq+ptWF2rq8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RpaJ5KBMpj0jD0DTu+Du+wl/dSb8GpUvUHsfYxOxfwvtngRt20fz0KOgqIe+p/fpmKdHsE6t4YZsBiLOq16UKZQuDOxkMuAsTiopbFz8Ho/5JLUEieRRwbZKWQZmkwZIh92cdxNYwmMEwxOAxF2LzaqOPiEoyLbMPHoIwnDoOiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IigTPIOn; arc=none smtp.client-ip=91.218.175.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IigTPIOn"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ytdKApU5ydc5tgMMhT0OgPOrlWOEu72eXq+ptWF2rq8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790578005; v=1; x=1791182805;
 b=IigTPIOn6hYFsxJMrgRBRJhD6ZJuR8vcHF/t/WjEo9pL5WSjE97g15HU0N66rX8lg+lIKT6c
 EJzBuqGnCh7dwfFvzyQ3ZHOKf5YK7P3KM7vIVYpaHoCq0MM6s3SkSWC5G1K/Dl3xXWhfeTUw0Ut
 EriVZfRYslyyUSd2Rg9FabZM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 44dc0649da117e22;
	Mon, 28 Sep 2026 06:46:45 +0000
X-Mizu-Trace-ID: 44dc0649da117e22
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
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] KVM: arm64: Don't WARN on an unsupported TLBI OS from vEL1
Date: Mon, 28 Sep 2026 07:46:40 +0100
Message-Id: <20260928064643.3265087-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260928064643.3265087-1-fuad.tabba@linux.dev>
References: <20260928064643.3265087-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM hides TLBI OS from a guest whose ID registers don't advertise it by
trapping the instructions: through the fine-grained traps on a CPU with
FGT, and through HCR_EL2.TTLBOS on one with FEAT_EVT2. With FGT,
triage_sysreg_trap() makes a trapped TLBI OS UNDEFINED. Without it, the
instruction reaches handle_tlbi_el1(), which assumes an EL1 TLBI only
traps from a guest at vEL2 and WARNs before checking whether the guest
supports it. The guest still gets its UNDEF after the WARN. A VMM can
trigger the WARN by hiding TLBI OS and having the guest execute one.

Check support before the WARN.

Fixes: 0cb8aae226768 ("KVM: arm64: nv: Add handling of outer-shareable TLBI operations")
Cc: stable@vger.kernel.org
Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 44aae52c473d7..0ce29ce678b08 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4257,6 +4257,10 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
 
+	/* Without FGT, HCR_EL2.TTLBOS also traps a hidden TLBI OS from vEL1 */
+	if (!kvm_supported_tlbi_s1e1_op(vcpu, sys_encoding))
+		return undef_access(vcpu, p, r);
+
 	/*
 	 * If we're here, this is because we've trapped on a EL1 TLBI
 	 * instruction that affects the EL1 translation regime while
@@ -4279,9 +4283,6 @@ static bool handle_tlbi_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	WARN_ON(!vcpu_is_el2(vcpu));
 
-	if (!kvm_supported_tlbi_s1e1_op(vcpu, sys_encoding))
-		return undef_access(vcpu, p, r);
-
 	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)) {
 		kvm_handle_s1e2_tlbi(vcpu, sys_encoding, p->regval);
 		return true;
-- 
2.39.5

