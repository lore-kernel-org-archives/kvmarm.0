Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D9B46A600
	for <kvmarm@lists.linux.dev>; Sat, 12 Sep 2026 10:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210127; cv=none; b=HUx0iG/yEwMNbDph66ct2K6pmD8cYQUBwqrq6SR5jpBIEFe//MdZYJ1MrNa9lfVxCpPNvW0Cbd1aQyBBdQDfRkUHeqIASYJZsaJGKS3Z1ZCG6MaUzMPWgFM3SWAL6YreMqXWdmJzytenEh1kHhrF4Gj5SHZm2pt3vUbuQJ1tTXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210127; c=relaxed/simple;
	bh=b74vU1nJLP467oXw+kXIksRqSlbVsPjtfhJKPOUIZJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJXogGlDEn3ya8PHKLUSeg/lci6mFWKQT0fMiaQcgkMFo2YPfVvKr3KdxKFkib4PCvgxEeMGQRxdFMM77uOflihaGvQf+4F0UENFLDDtRq+W8rrVaZIJamfqoQP4oPbYc64rfuXkdwLbAx4Wlg4Ys9XxrBXrBy9F+bRlDAxbi+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B9TY/W/0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B9TY/W/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8C81F0089E;
	Sat, 12 Sep 2026 10:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789210122;
	bh=uPsS2T1yv9TxZ62g74tWsPG1tgtql7lQ5uggCY+tQEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B9TY/W/0OP8qWw2t6DM+wQ8UFUdvSqe9ASPSPQnmRKY44ylNK2HS0rkKDJSkVzIN8
	 Zr7PhT5iDmkyJGeIWFUy1tVAHetvMOBAqXGJahsiJASSpE5G/unf/0gIagfAoF632B
	 1UzyDjE/0bFgVih2M4UqC+ka3uADtwH8vTMQ4l1xnCKO3uTWbywGyuK0bStTiJ5eQu
	 cUJSUcZYHujVmIu2Gfw+okU7pILxDEvoF/WmDnr7iaDV5plawYS5SydaFBeHOBMy6R
	 UkCPya5xjGCqpJCIwlTENMqSVj9uId8vb6+eG/wfafSHomsUjkCMzQRP8I3bVsZCZA
	 jKhY4dY/O7Dog==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x5LHk-000000084hK-1hgD;
	Sat, 12 Sep 2026 10:48:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Wei-Lin Chang <weilin.chang@arm.com>,
	Wang Han <wanghan@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH 4/4] KVM: arm64: nv: Move TLBI VMALLS12E1* emulation over to kvm_stage2_unmap_all()
Date: Sat, 12 Sep 2026 11:48:34 +0100
Message-ID: <20260912104834.3093878-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912104834.3093878-1-maz@kernel.org>
References: <20260912104834.3093878-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, weilin.chang@arm.com, wanghan@linux.alibaba.com, xueshuai@linux.alibaba.com, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Instead of emulating TLBI VMALLS12E1* with a range invalidation, use
kvm_stage2_unmap_all() which is more efficient, specially in deeply
nested cases.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 44aae52c473d7..2c90e185c6e8e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4124,26 +4124,24 @@ static void s2_mmu_unmap_range(struct kvm_s2_mmu *mmu,
 	kvm_stage2_unmap_range(mmu, info->range.start, info->range.size, true);
 }
 
+static void s2_mmu_unmap_all(struct kvm_s2_mmu *mmu,
+			     const union tlbi_info *info)
+{
+	kvm_stage2_unmap_all(mmu, true);
+}
+
 static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 				const struct sys_reg_desc *r)
 {
 	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
-	u64 limit, vttbr;
+	u64 vttbr;
 
 	if (!kvm_supported_tlbi_s12_op(vcpu, sys_encoding))
 		return undef_access(vcpu, p, r);
 
 	vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
-	limit = BIT_ULL(kvm_get_pa_bits(vcpu->kvm));
 
-	kvm_s2_mmu_iterate_by_vmid(vcpu->kvm, get_vmid(vttbr),
-				   &(union tlbi_info) {
-					   .range = {
-						   .start = 0,
-						   .size = limit,
-					   },
-				   },
-				   s2_mmu_unmap_range);
+	kvm_s2_mmu_iterate_by_vmid(vcpu->kvm, get_vmid(vttbr), NULL, s2_mmu_unmap_all);
 
 	return true;
 }
-- 
2.47.3

