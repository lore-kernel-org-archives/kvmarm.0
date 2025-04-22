Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6AE1FDA94
	for <kvmarm@lists.linux.dev>; Tue, 22 Apr 2025 12:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745324788; cv=none; b=difike7QuUUYjux6jIr4bYH7/OdrLLzuUSHjVlZM1PDSyuyapcXGSV6ADHaxgj7lSHoPSU19kKXwq0L07X988G5uYpZ6xV3iAHs+/O9pkjVJh7H2M29GMTpHd2otOO4YLwamlPrZQ8fsvzn14f6oI86k4WaGZeGLjVYJiqlITtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745324788; c=relaxed/simple;
	bh=wY1pGmEk41P8ERn6RnhMrtuLDN2i9gyWAg14bjK0G4w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KKTzjca4qS/6N6QCkfrcIhsiu8DDLxu8JrsnVTZScjaID/A4FnPlSg7XZ4tcTV+c+Te4bPSKk+RVYNwbdzGVxU/2Ictib8WDqxgGEkhmiZ7nblpmQJQwwkwqmSrYrXUhwdZO5no5fur2B9DKZNMYCOLxqp6M6Bu43aXQ/VlpfTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AQMgXwsE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AQMgXwsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEE4C4CEEC;
	Tue, 22 Apr 2025 12:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745324788;
	bh=wY1pGmEk41P8ERn6RnhMrtuLDN2i9gyWAg14bjK0G4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQMgXwsEQa3tCCFWU3VPAcmosl2GfWQlh4Mz+bRyp3JuVgFBuzklw4TeT9FCq1aYc
	 WE5sIYe3g+yoCEJwiSIR/PFu7dM5rn0Q/UxW577JrKY1Zn3qolpBhJY+CbpjZt4UOl
	 fjBYEsPV5xfrkvj83z73CvcrjB516afWLYkBs7iYnTTNTJmLULP+pQjwLxT2aCVKnO
	 DU/SMiAlzRBnncYnGjBZRxr0RVismh/hIDNIBu9Zv+p1iJPB9qdQREAfMacZztUzWa
	 osFCLzwDqgM4GixYy4lMTev9omJkErfjWl7hEp0lUJaa+d1icC09rC/VwW39W+Qtpr
	 WbVMhYnXf1oAg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u7Chm-007c9q-2w;
	Tue, 22 Apr 2025 13:26:26 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	D Scott Phillips <scott@os.amperecomputing.com>
Subject: [PATCH 2/3] KVM: arm64: Teach address translation about access faults
Date: Tue, 22 Apr 2025 13:26:11 +0100
Message-Id: <20250422122612.2675672-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250422122612.2675672-1-maz@kernel.org>
References: <20250422122612.2675672-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, scott@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It appears that our S1 PTW is completely oblivious of access faults.
Teach the S1 translation code about it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 3a4568e2de910..c40583edebc4f 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -456,6 +456,11 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	if (check_output_size(desc & GENMASK(47, va_bottom), wi))
 		goto addrsz;
 
+	if (!(desc & PTE_AF)) {
+		fail_s1_walk(wr, ESR_ELx_FSC_ACCESS_L(level), false);
+		return -EACCES;
+	}
+
 	va_bottom += contiguous_bit_shift(desc, wi, level);
 
 	wr->failed = false;
@@ -1209,7 +1214,8 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
  * If the translation is unsuccessful, the value may only contain
  * PAR_EL1.F, and cannot be taken at face value. It isn't an
  * indication of the translation having failed, only that the fast
- * path did not succeed, *unless* it indicates a S1 permission fault.
+ * path did not succeed, *unless* it indicates a S1 permission or
+ * access fault.
  */
 static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 {
@@ -1312,19 +1318,29 @@ static bool par_check_s1_perm_fault(u64 par)
 		 !(par & SYS_PAR_EL1_S));
 }
 
+static bool par_check_s1_access_fault(u64 par)
+{
+	u8 fst = FIELD_GET(SYS_PAR_EL1_FST, par);
+
+	return  ((fst & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_ACCESS &&
+		 !(par & SYS_PAR_EL1_S));
+}
+
 void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 {
 	u64 par = __kvm_at_s1e01_fast(vcpu, op, vaddr);
 
 	/*
-	 * If PAR_EL1 reports that AT failed on a S1 permission fault, we
-	 * know for sure that the PTW was able to walk the S1 tables and
-	 * there's nothing else to do.
+	 * If PAR_EL1 reports that AT failed on a S1 permission or access
+	 * fault, we know for sure that the PTW was able to walk the S1
+	 * tables and there's nothing else to do.
 	 *
 	 * If AT failed for any other reason, then we must walk the guest S1
 	 * to emulate the instruction.
 	 */
-	if ((par & SYS_PAR_EL1_F) && !par_check_s1_perm_fault(par))
+	if ((par & SYS_PAR_EL1_F) &&
+	    !par_check_s1_perm_fault(par) &&
+	    !par_check_s1_access_fault(par))
 		par = handle_at_slow(vcpu, op, vaddr);
 
 	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
-- 
2.39.2

