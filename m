Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B0B3264EF
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882164; cv=none; b=U+FUhqwHEsm3EmHAsDfF9keO4HhLn+t+elHqd30QqCGV5X4d8hvYeF6XGpce26EVEGUWVgU0O25YvL3pccjf2Q0/qjtcdSIYjL5A5YF0uji+L3xaoejQD/8zlA+MaOhF/5U6U3zM/JrKc6LgZ1Np86K9Da9bPYXpBCR3FCO849o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882164; c=relaxed/simple;
	bh=kupY+rUTW2UPV/U5cwqqP9hhXbxo6oWLqyy18kOdLqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u64OarmSL3wmirrPspRZ7b7KmHZWAGIQh6gM1dvxG9DkdHq2wpNl1tEf5sn0YB9WPrpKNYdrdCp4HxuKojzp0mAIKeaudnGx3daSWuCBSnyaCQ3RR9cAHYVSikLu4dY7uK4b615Vqht+SilCAWCa43vLX+iifXj7VYpXzFAuA50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PaU3wEqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PaU3wEqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD6AC4CEF7;
	Mon, 30 Mar 2026 14:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882164;
	bh=kupY+rUTW2UPV/U5cwqqP9hhXbxo6oWLqyy18kOdLqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PaU3wEqcUCRAhv1+1jIXQ1xovdIHMPnSQLXpYHLkXiFtgzFVMTYYQTXJ/1VK9rHhj
	 lPtXW3MtGBM2I9hvClmBhrRGHPz/VrbarbLUUzGEbDt9jtuGggznNO+uwGsX6t3Kt1
	 D0/XMs7lCHRkuw/0ocJH/SJEPZQ6/jtohHQxfzz/LvAu4z+yh8PyW2QrZpw0eJ5Xkf
	 o11L/yLkIsvs3o7YHyd3YgWqNKRuPI4SebdXFqEzxqS/XJnwMajL4Mm2y9FZ4G2XsX
	 9slyRC7SiLtOknPCaiN5Yh1MFMjMqYn6xgRf52mdevRe15IW7Rzdu8zZN2e0HFPSrl
	 z9WDuTTAHQEQw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v5 10/38] KVM: arm64: Ignore -EAGAIN when mapping in pages for the pKVM host
Date: Mon, 30 Mar 2026 15:48:11 +0100
Message-ID: <20260330144841.26181-11-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330144841.26181-1-will@kernel.org>
References: <20260330144841.26181-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the host takes a stage-2 translation fault on two CPUs at the same
time, one of them will get back -EAGAIN from the page-table mapping code
when it runs into the mapping installed by the other.

Rather than handle this explicitly in handle_host_mem_abort(), pass the
new KVM_PGTABLE_WALK_IGNORE_EAGAIN flag to kvm_pgtable_stage2_map() from
__host_stage2_idmap() and return -EEXIST if host_stage2_adjust_range()
finds a valid pte. This will avoid having to test for -EAGAIN on the
reclaim path in subsequent patches.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d815265bd374..7d22893ab1dc 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -461,8 +461,15 @@ static bool range_is_memory(u64 start, u64 end)
 static inline int __host_stage2_idmap(u64 start, u64 end,
 				      enum kvm_pgtable_prot prot)
 {
+	/*
+	 * We don't make permission changes to the host idmap after
+	 * initialisation, so we can squash -EAGAIN to save callers
+	 * having to treat it like success in the case that they try to
+	 * map something that is already mapped.
+	 */
 	return kvm_pgtable_stage2_map(&host_mmu.pgt, start, end - start, start,
-				      prot, &host_s2_pool, 0);
+				      prot, &host_s2_pool,
+				      KVM_PGTABLE_WALK_IGNORE_EAGAIN);
 }
 
 /*
@@ -504,7 +511,7 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 		return ret;
 
 	if (kvm_pte_valid(pte))
-		return -EAGAIN;
+		return -EEXIST;
 
 	if (pte) {
 		WARN_ON(addr_is_memory(addr) &&
@@ -609,7 +616,6 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_vcpu_fault_info fault;
 	u64 esr, addr;
-	int ret = 0;
 
 	esr = read_sysreg_el2(SYS_ESR);
 	if (!__get_fault_info(esr, &fault)) {
@@ -628,8 +634,13 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	BUG_ON(!(fault.hpfar_el2 & HPFAR_EL2_NS));
 	addr = FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
 
-	ret = host_stage2_idmap(addr);
-	BUG_ON(ret && ret != -EAGAIN);
+	switch (host_stage2_idmap(addr)) {
+	case -EEXIST:
+	case 0:
+		break;
+	default:
+		BUG();
+	}
 }
 
 struct check_walk_data {
-- 
2.53.0.1018.g2bb0e51243-goog

