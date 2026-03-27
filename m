Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA1C38E136;
	Fri, 27 Mar 2026 11:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611388; cv=none; b=ATyxgj2UAtsrZvAf+LWL71d7hdsSikFbSDLHIIO7dT6p9xn06G/KQDjbwX7vkUSqwAvK+K7z6WMogmqq8iJriJ19pJlotdlQsRl9uh6fcG1pQPkyCQy1Kc2xvQXj83dqm2Xnv8mN68QpUa40I2htTmerxKzzHjVn4khk9I35GuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611388; c=relaxed/simple;
	bh=0glThNb9QbjDwvXTy2EB6goDvXJ2brPHca8WtXY6vtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSjr8cX8v83ieFkNx/sxgtABNCy/Vj12ceRKurez5qP1wg97vVUHP8F9FILRhZxgabSgxHY3WI8Nyc0yy/qZXZvBzLrSekVC4t++80PRFdE8Zp5ASqUEvoU2gzbva2cs1q/EkORoomIp8S8VclCE4kzFRiJPIrRU0lGNEn/mwS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EouL09t5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EouL09t5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CB3C2BCB8;
	Fri, 27 Mar 2026 11:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611388;
	bh=0glThNb9QbjDwvXTy2EB6goDvXJ2brPHca8WtXY6vtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EouL09t5GpnG6Zp4wSj9iJaPyh7KVPB0O0ptJGxPhc8EZgYAXALIDfW289wvscpFq
	 giwQKCCZZGljIY7PO2zF7D9DKtu82EErbfJIv7bqS+W953ntHOSaWZKv2ruRp3UWXq
	 3Yf3xlEm0ffZMF2OBLYOboT/KpK4zQnBTbVboJBbqlRxIQbHpECaNdeUaOIxOiUnww
	 7oP3qTU1e+rWYau9JTDj+l5ij/hh1qNL8h1iDyZ8I14WX08Jnhuz4Tqob1OvpfTpyP
	 LPTQ3J1WBNrNluf0Dc9gXBMoaOOz7Apx4DYT0cw/hXzRZjp11hlou4NSE4PAfA37C4
	 pyfsa0eOP4ZQg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UI-00000006K4a-2uss;
	Fri, 27 Mar 2026 11:36:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH v2 19/30] KVM: arm64: Kill write_fault from kvm_s2_fault
Date: Fri, 27 Mar 2026 11:36:07 +0000
Message-ID: <20260327113618.4051534-20-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327113618.4051534-1-maz@kernel.org>
References: <20260327113618.4051534-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We already have kvm_is_write_fault() as a predicate indicating
a S2 fault on a write, and we're better off just using that instead
of duplicating the state.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 981c04a74ab7a..7dab0c3faa5bf 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1711,7 +1711,6 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 }
 
 struct kvm_s2_fault {
-	bool write_fault;
 	bool exec_fault;
 	bool writable;
 	bool topup_memcache;
@@ -1799,7 +1798,7 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
 		return ret;
 
 	fault->pfn = __kvm_faultin_pfn(s2fd->memslot, get_canonical_gfn(s2fd, fault),
-				       fault->write_fault ? FOLL_WRITE : 0,
+				       kvm_is_write_fault(s2fd->vcpu) ? FOLL_WRITE : 0,
 				       &fault->writable, &fault->page);
 	if (unlikely(is_error_noslot_pfn(fault->pfn))) {
 		if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
@@ -1850,7 +1849,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 			 */
 			fault->s2_force_noncacheable = true;
 		}
-	} else if (fault->logging_active && !fault->write_fault) {
+	} else if (fault->logging_active && !kvm_is_write_fault(s2fd->vcpu)) {
 		/*
 		 * Only actually map the page as writable if this was a write
 		 * fault.
@@ -1980,21 +1979,17 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
-	bool write_fault = kvm_is_write_fault(s2fd->vcpu);
 	bool logging_active = memslot_is_logging(s2fd->memslot);
 	struct kvm_s2_fault fault = {
 		.logging_active = logging_active,
 		.force_pte = logging_active,
 		.prot = KVM_PGTABLE_PROT_R,
-		.write_fault = write_fault,
 		.exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu),
-		.topup_memcache = !perm_fault || (logging_active && write_fault),
+		.topup_memcache = !perm_fault || (logging_active && kvm_is_write_fault(s2fd->vcpu)),
 	};
 	void *memcache;
 	int ret;
 
-	VM_WARN_ON_ONCE(fault.write_fault && fault.exec_fault);
-
 	/*
 	 * Permission faults just need to update the existing leaf entry,
 	 * and so normally don't require allocations from the memcache. The
-- 
2.47.3

