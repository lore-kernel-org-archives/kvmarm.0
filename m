Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244491EB9E8
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 17:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734458163; cv=none; b=Wyx7hT9GflPCc2zITrJRYQyezID7JKlv3uI8yNlPVqJmbLyuu/PSE/SWlnKSP4HIuHPlqBxwlyNrGoowrJXrkRcPvuXn4QrkGgbqD1UULoHgI5KzMVt8VHNgIrO9MiqkZ6BBbzQTloAzN9RI4q4JctyFom3TedQL7wyPMDuSnxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734458163; c=relaxed/simple;
	bh=FOIHciXozTi2Q9MOVbZiynuyVg8lOn6RN4ASE3Et+uU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DvqyJFFmT+K90duV6LiaR0ItzfVehJQaEpKCqYwZKv1VJmpGSC7mQrR9ZJJ/LSXC0PvHU3ZMKjWkLHlxRPqNY8qfW+JJIx46W80U6GARnXikFwt8Jis6OP9y1GldIJYnLjUp4/vyUgOHFpdkmBDGzocQOGc4w0j3+R/uB31EYco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=keeYDn88; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="keeYDn88"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734458160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iDc2GNru3KC9FE1VZE6S/9RVzT2UkIuUC3Ho/X5pGOU=;
	b=keeYDn886Onn1w6UxX/rWCXPM6x5wBaB9crxHV9cxjWvu4mLCzofFWwA2Rs3uQ6eMRYPnE
	3ikRJTt7mPz/CjrJCwkHAvNhdMHsMMNVR/itgFarnEJWmx/z0PHH3gT9WFbrTTd/e4n19q
	ShQS0WhSjoP+wowIdH5077HZwfMzc7I=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 3/4] KVM: arm64: nv: Reload PMU events upon MDCR_EL2.HPME change
Date: Tue, 17 Dec 2024 09:55:50 -0800
Message-Id: <20241217175550.3658212-1-oliver.upton@linux.dev>
In-Reply-To: <20241217175336.3657966-1-oliver.upton@linux.dev>
References: <20241217175336.3657966-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

MDCR_EL2.HPME is the 'global' enable bit for event counters reserved for
EL2. Give the PMU a kick when it's changed to ensure events are
reprogrammed before returning to the guest.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6ef8641d9833..634ff18a59a1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2448,6 +2448,26 @@ static unsigned int s1pie_el2_visibility(const struct kvm_vcpu *vcpu,
 	return __el2_visibility(vcpu, rd, s1pie_visibility);
 }
 
+static bool access_mdcr(struct kvm_vcpu *vcpu,
+			struct sys_reg_params *p,
+			const struct sys_reg_desc *r)
+{
+	u64 old = __vcpu_sys_reg(vcpu, MDCR_EL2);
+
+	if (!access_rw(vcpu, p, r))
+		return false;
+
+	/*
+	 * Request a reload of the PMU to enable/disable the counters affected
+	 * by HPME.
+	 */
+	if ((old ^ __vcpu_sys_reg(vcpu, MDCR_EL2)) & MDCR_EL2_HPME)
+		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+
+	return true;
+}
+
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2981,7 +3001,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(SCTLR_EL2, access_rw, reset_val, SCTLR_EL2_RES1),
 	EL2_REG(ACTLR_EL2, access_rw, reset_val, 0),
 	EL2_REG_VNCR(HCR_EL2, reset_hcr, 0),
-	EL2_REG(MDCR_EL2, access_rw, reset_val, 0),
+	EL2_REG(MDCR_EL2, access_mdcr, reset_val, 0),
 	EL2_REG(CPTR_EL2, access_rw, reset_val, CPTR_NVHE_EL2_RES1),
 	EL2_REG_VNCR(HSTR_EL2, reset_val, 0),
 	EL2_REG_VNCR(HFGRTR_EL2, reset_val, 0),
-- 
2.39.5

