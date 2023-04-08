Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A8F1FB3
	for <kvmarm@lists.linux.dev>; Sat,  8 Apr 2023 16:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A3FC4339C;
	Sat,  8 Apr 2023 16:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680969891;
	bh=KDMzZnxGApiibVRs6k92CdWB6ULcQmnVKHVOc063tfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRvWeQWO7gL2yAXqSzOcY7kFQS9LVysNXSBEXDYA6idP/yUhdlUL/kQflwieh3VUj
	 m83JdMFiVf8j3HLKJcta1Wg7ofnq/zE/rQcGpOA5Znf2LQud0aN5hmUx1EZVWObiiP
	 pZPf2mM0VizVsa+37PusAUbUjDyCJPvrIUIed+GLQJU3Q2uFJirkJv/iVcoYw1/Zeo
	 lM69vVY0IERzvukEJza7VRc76+rrUs+i4OkUbNceJ0wBJYdZ8gIxfhv88gXt4DrhFY
	 0OF/n8GOeP8BNEbhvDF0Qo2auafZKxiNqndFKeTCkWmTnnyVoYmqUdHrGSAHyavAfJ
	 +MuRXwTcpSLXA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1plB3Z-006wc5-3z;
	Sat, 08 Apr 2023 17:04:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 2/5] KVM: arm64: nvhe: Synchronise with page table walker on TLBI
Date: Sat,  8 Apr 2023 17:04:24 +0100
Message-Id: <20230408160427.10672-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230408160427.10672-1-maz@kernel.org>
References: <20230408160427.10672-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

A TLBI from EL2 impacting EL1 involves messing with the EL1&0
translation regime, and the page table walker may still be
performing speculative walks.

Piggyback on the existing DSBs to always have a DSB ISH that
will synchronise all load/store operations that the PTW may
still have.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/tlb.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index d296d617f589..e86dd04d49ff 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -17,6 +17,23 @@ struct tlb_inv_context {
 static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
 				  struct tlb_inv_context *cxt)
 {
+	/*
+	 * We have two requirements:
+	 *
+	 * - ensure that the page table updates are visible to all
+         *   CPUs, for which a dsb(ishst) is what we need
+	 *
+	 * - complete any speculative page table walk started before
+         *   we trapped to EL2 so that we can mess with the MM
+         *   registers out of context, for which dsb(nsh) is enough
+	 *
+	 * The composition of these two barriers is a dsb(ish). This
+	 * might be slightly over the top for non-shareable TLBIs, but
+	 * they are so vanishingly rare that it isn't worth the
+	 * complexity.
+	 */
+	dsb(ish);
+
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		u64 val;
 
@@ -60,8 +77,6 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 {
 	struct tlb_inv_context cxt;
 
-	dsb(ishst);
-
 	/* Switch to requested VMID */
 	__tlb_switch_to_guest(mmu, &cxt);
 
@@ -113,8 +128,6 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
 
-	dsb(ishst);
-
 	/* Switch to requested VMID */
 	__tlb_switch_to_guest(mmu, &cxt);
 
@@ -142,7 +155,8 @@ void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 
 void __kvm_flush_vm_context(void)
 {
-	dsb(ishst);
+	/* Same remark as in __tblb_switch_to_guest() */
+	dsb(ish);
 	__tlbi(alle1is);
 
 	/*
-- 
2.34.1

