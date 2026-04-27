Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970F4371063;
	Mon, 27 Apr 2026 08:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280124; cv=none; b=agVZMe9JHfoYsbZz2TEXQzbN6EJLwqfOqPEtvzXbtEDJbxnEOWVSI79MdFcyfPnq2HDbfxrgYk7a6AoSKXGV0dJG8C3Q4ZyzGAXUa4jY2GYDQZbeRczqA5rIn5t2VOMhSvsuwvym7aLiakzr4BoshpMXzWWoKRQC0n+yVXZhJYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280124; c=relaxed/simple;
	bh=2LonPFnM9BahaLo9ZBu9rOu/lx6xKzGRSDuTtO9DK+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LxkuR+Gma32cH6MrDhphGXnZR6vhRuQWPSl42Y5OleCZ+7d7bqbMnRCxwi1O4WMJKm5XbeD6xIiDptW+L8rC6vEsRTlr4RJUjr4JaDSEciF1eGCXz1YEl9fbVu49cgUW2J9x7zB9egs6Gov5D+fuSbjvZNGkSi7jLVmyazxMjHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JZkS4Y0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZkS4Y0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B972EC2BCC4;
	Mon, 27 Apr 2026 08:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777280124;
	bh=2LonPFnM9BahaLo9ZBu9rOu/lx6xKzGRSDuTtO9DK+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZkS4Y0liJD6jbo1TIJm/zncvNe+Md28WWWWsFd4QpeGdRMnTI2z3ak9e07DG77+B
	 +medIBpT7BrfFrwB8yefpTxphuDPm3HyZryQ8RYF/+bBF7atI87NDamUvWQ/sQQpz1
	 TjQIZN+GkAEOmfsksthZiQCCo+ywT7QEgAY9wCpAnBJp5QQG1BikuGRqyEQ01qFKIi
	 bltzBkrGseN4oR3BePHayKG/8X6GACT9EdsjybjunznpuCwjVXwMGLTOu4TvpNEgBE
	 qEwOiXcL+/YVBBgQLpRLTwqVT+mdAOm8AgUZB9onfM5kOnhEI6vc0V6Xk7GnsVU7Ex
	 CAq8qrOrxe6Dw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [RFC PATCH v4 14/16] KVM: arm64: Unmap device mappings when a private granule is destroyed
Date: Mon, 27 Apr 2026 14:23:42 +0530
Message-ID: <20260427085344.941627-15-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427085344.941627-1-aneesh.kumar@kernel.org>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Ensure tearing down a private granule also tears down any RMM device
mapping by reading the RTT entry, invoking the new RMI_VDEV_MEM_UNMAP,
and remembering the entry’s RIPAS so we only free RAM pages.

Drive the device-unmap path when RIPAS transitions to EMPTY. Also roll
back partially built device maps when errors occur.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/rmi_smc.h |  1 +
 arch/arm64/kvm/rmi.c             | 87 ++++++++++++++++++++++++++++++--
 2 files changed, 83 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index 6bbabcd853bd..f3ad545d68b7 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -199,6 +199,7 @@ enum rmi_ripas {
 	RMI_EMPTY = 0,
 	RMI_RAM = 1,
 	RMI_DESTROYED = 2,
+	RMI_DEV = 3,
 };
 
 #define RMI_NO_MEASURE_CONTENT	0
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 3a549dc87906..cc9e045dcae9 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -720,6 +720,11 @@ static int realm_create_rd(struct kvm *kvm)
 	return r;
 }
 
+static int rmi_rtt_dev_unmap(unsigned long rd_phys,
+		unsigned long base, unsigned long top,
+		unsigned long *out_ipa, unsigned long *out_desc,
+		unsigned long *rmi_ret);
+
 static void realm_unmap_private_range(struct kvm *kvm,
 				      unsigned long start,
 				      unsigned long end,
@@ -728,16 +733,33 @@ static void realm_unmap_private_range(struct kvm *kvm,
 	struct realm *realm = &kvm->arch.realm;
 	unsigned long rd = virt_to_phys(realm->rd);
 	unsigned long next_addr, addr;
+	struct rtt_entry rtt_entry;
 	int ret;
 
+	/* Called with mmu_lock held, so RTT entry can't change. */
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	/* An unmap request won't mix different RIPAS ranges. */
+	if (rmi_rtt_read_entry(rd, start, RMM_RTT_MAX_LEVEL, &rtt_entry))
+		return;
+
 	for (addr = start; addr < end; addr = next_addr) {
+		unsigned long rmi_ret;
 		unsigned long out_range;
 		unsigned long flags = RMI_ADDR_TYPE_SINGLE;
 		/* TODO: Optimise using RMI_ADDR_TYPE_LIST */
 
 retry:
-		ret = rmi_rtt_data_unmap(rd, addr, end, flags, 0,
-					 &next_addr, &out_range, NULL);
+		if (rtt_entry.ripas == RMI_DEV)
+			ret = rmi_rtt_dev_unmap(rd, addr, end,
+						&next_addr, &out_range,
+						&rmi_ret);
+		else
+			ret = rmi_rtt_data_unmap(rd, addr, end, flags, 0,
+						 &next_addr, &out_range, NULL);
+
+		if (!ret && rtt_entry.ripas == RMI_DEV)
+			ret = rmi_ret;
 
 		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
 			phys_addr_t rtt;
@@ -763,6 +785,7 @@ static void realm_unmap_private_range(struct kvm *kvm,
 		if (WARN_ON(ret))
 			break;
 
+		//FIXME!! where are we freeing the private page?
 		if (may_block)
 			cond_resched_rwlock_write(&kvm->mmu_lock);
 	}
@@ -1152,10 +1175,27 @@ static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
 			       unsigned long *top_ipa)
 {
 	struct kvm *kvm = vcpu->kvm;
-	int ret = ripas_change(kvm, vcpu, start, end, RIPAS_SET, top_ipa);
+	int ret;
 
-	if (ripas == RMI_EMPTY && *top_ipa != start)
-		realm_unmap_private_range(kvm, start, *top_ipa, false);
+	/*
+	 * We use the RIPAS value to decide between a data_destroy or a
+	 * dev_mem_unmap. Hence call realm_unmap_private_range() before
+	 * ripas_change().
+	 *
+	 * Technically, for private RAM, we don't need to call
+	 * realm_unmap_private_range(), because any RIPAS change via RSI would
+	 * trigger a memory fault exit. That would, in turn, invalidate the
+	 * guest's memfd range, which then triggers realm_unmap_private_range()
+	 * automatically.
+	 *
+	 * However, this doesn’t apply to RIPAS_DEV, because we currently
+	 * lack a user-space API to call realm_dev_mem_unmap() in response to a
+	 * memory fault exit. Therefore, the unmap must happen explicitly before
+	 * the RIPAS change.
+	 */
+	if (ripas == RMI_EMPTY)
+		realm_unmap_private_range(kvm, start, end, false);
+	ret = ripas_change(kvm, vcpu, start, end, RIPAS_SET, top_ipa);
 
 	return ret;
 }
@@ -1301,6 +1341,27 @@ static int rmi_rtt_dev_map(unsigned long rd_phys, unsigned long vdev_phys,
 	return 0;
 }
 
+static int rmi_rtt_dev_unmap(unsigned long rd_phys,
+		unsigned long base, unsigned long top,
+		unsigned long *out_ipa, unsigned long *out_desc,
+		unsigned long *rmi_ret)
+{
+	unsigned long flags = RMI_ADDR_TYPE_SINGLE;
+	struct rmi_sro_state *sro __free(sro) =
+		rmi_sro_init(SMC_RMI_RTT_DEV_UNMAP, rd_phys, base, top, flags, NULL);
+	if (!sro)
+		return -ENOMEM;
+
+	*rmi_ret = rmi_sro_execute(sro);
+	if (*rmi_ret)
+		return 0;
+
+	*out_ipa = sro->regs.a1;
+	*out_desc = sro->regs.a2;
+
+	return 0;
+}
+
 static int rmi_rtt_dev_validate(unsigned long rd_phys, unsigned long rec_phys,
 		unsigned long base, unsigned long top, unsigned long *out_top,
 		unsigned long *rmi_ret)
@@ -1401,9 +1462,12 @@ int realm_dev_mem_map(struct kvm *kvm, unsigned long pdev_phys,
 		unsigned long end_ipa, unsigned long start_pa)
 {
 	int ret;
+	unsigned long rmi_ret;
 	unsigned long top_ipa;
 	unsigned long base_ipa = start_ipa;
+	struct realm *realm = &kvm->arch.realm;
 	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
+	phys_addr_t rd_phys = virt_to_phys(realm->rd);
 	struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
 
 	do {
@@ -1431,6 +1495,19 @@ int realm_dev_mem_map(struct kvm *kvm, unsigned long pdev_phys,
 		for (start_ipa = ALIGN(base_ipa, RMM_L2_BLOCK_SIZE);
 		     ((start_ipa + RMM_L2_BLOCK_SIZE) < end_ipa); start_ipa += RMM_L2_BLOCK_SIZE)
 			fold_rtt(&kvm->arch.realm, start_ipa, RMM_RTT_BLOCK_LEVEL);
+	} else {
+		/* unmap the partial mapping. [base_ipa, start_ipa) */
+		while (start_ipa > base_ipa) {
+			unsigned long out_ipa;
+			unsigned long out_range;
+
+			ret = rmi_rtt_dev_unmap(rd_phys, base_ipa, start_ipa,
+					&out_ipa, &out_range, &rmi_ret);
+			if (ret || (rmi_ret != RMI_SUCCESS))
+				break;
+			WARN_ON(undelegate_range_desc(out_range));
+			base_ipa = out_ipa;
+		}
 	}
 
 	return ret;
-- 
2.43.0

