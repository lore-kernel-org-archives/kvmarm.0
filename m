Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D29126D4D8
	for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 18:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=91.218.175.188
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527789; cv=fail; b=asK3PoSxTB+7gnYzmLdfW0HkZk9HuMQXwtOZMnqdxTbPz0u3etyiXktqkB68+/nu2rRkgtcEHDRnOJRRIvDs1gRxAn/gCFT6bZrgYd9Kv/Bwc6ZScwQyXFGns6SRnW2yvwUrhMcMypQu3Nluh9QR9QXTvN7+LKrmyOu67MBi1QI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527789; c=relaxed/simple;
	bh=I5BQmU9p8aGGRjvkvVTVxwT5IaeoeE59ZDNKDEIgu1g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jJx3+ZD0KOJb2DV07gt6xwWwTxoGbEe6Ypxk4bBZL30t9LI+5Smy1f3pC+y1C8hpBLlsQIKgRA2MM6eB65VJEnKLU0RCSMM4JVmtpvDPzUBWn2BhkItXaHNI8guNfMtKnfDHSVPIW4d37Y4whMuL74cVEl4F/ADPDG2GZh3h+1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ocA44LYO; dkim=fail (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O3bpTdQA reason="signature verification failed"; arc=fail smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ocA44LYO";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O3bpTdQA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757527785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qzn5g8Hw7KzqnqodLNnlFqbmVmAnwg8HpayM5vJro2A=;
	b=ocA44LYOvyLNlB3Bjyuo9BlIL6idrKVGZ5CgvskFZ8zqmiKUH0tTQH1TR9TfD60CSHW5Ia
	KzmcBAf1xMZQZxngCVDg7IuymLYpgFs3fdjyLrYVlcvl0zMjj4+UZYnfb4Z8i92N9vHk3M
	23rIaFKFhe7fqRKjj6bfK/8DB6JZfYc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Subject: [PATCH] bad bad bad
Date: Wed, 10 Sep 2025 11:09:30 -0700
Message-Id: <20250826163335.880047-1-maz@kernel.org>
In-Reply-To: <20250910180930.3679473-1-oliver.upton@linux.dev>
References: <20250910180930.3679473-1-oliver.upton@linux.dev>
X-Envelope-To: oliver.upton@linux.dev
Authentication-Results: aspmx1.migadu.com; dkim=pass header.d=kernel.org header.s=k20201202 header.b=O3bpTdQA; spf=pass (aspmx1.migadu.com: domain of maz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=maz@kernel.org; dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1; t=1756226028; h=from:from:reply-to:subject:subject:date:date:message-id:message-id: to:to:cc:mime-version:mime-version: content-transfer-encoding:content-transfer-encoding:dkim-signature; bh=MaTRZRfvU6ndoc4WGJ/STJiAhpK2Xk0JxSoWS22BpAY=; b=UrdsRtGcQ4J/IeIeAQC1FutLPtdjt2UIyRlbrnurItZToA/joVhSdO1x5CkTsuO9E7K7sp IXcHNExcLMoSNa3SAJWdC/ao8AGyUI5JdGthu28cfz3DcLy8UpcyfY6f5ogpYc95VngVOZ 57JhBOav0R/6w2RUOJUZwH9NSrL72xM=
ARC-Seal: i=1; s=key1; d=linux.dev; t=1756226028; a=rsa-sha256; cv=none; b=DIpQikrXnLzaNJf5kjBC+CQzhWOzf67TPnu0tFaNsN9g+kuiRMIH/7Sc2ObPmZaA5XQ0GF ipuMiC8WFyKBtKePYLyRTaY8/5J8E1DvKGD2SZu+VJs8FgVpnMVAZ/p26QFHdw1jSfHst1 PbNWgnRQofQaxO9bmY5dd58Ol4NucY0=
ARC-Authentication-Results: i=1; aspmx1.migadu.com; dkim=pass header.d=kernel.org header.s=k20201202 header.b=O3bpTdQA; spf=pass (aspmx1.migadu.com: domain of maz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=maz@kernel.org; dmarc=pass (policy=quarantine) header.from=kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202; t=1756226025; bh=dHR65QXGf8w1dBCf5RYqqKU6LKOZgghODBwOoH4O5jY=; h=From:To:Subject:Date:From; b=O3bpTdQALPGadCba5yLFFA2j3HiIkOTvFOiG68kA8oAtBVDgsV/tI0XsFTFS2gFoX 20nJPIFTc69Q11n2gwHbiJG/5C2ZjAOXQLCuf33oajkVxDtRu5OcopWi+mRLT7LZPi lCCb3cbHmKj3b/9OGgoxmZ+r0L4QMBJ3WR2W9xiQ6JxOngRB/olkG5IxvhU8LiL8K9 pmzU41Mm3X33JYxImRg78MOk1iPyaMkPTw6RS4Km8+otHC2IOFvClWUhm56WvEKwmG 6Zal5REOUEuTid/EffFL/0KBUcMk82dci/Xmj5svp5v9OukkSUtdv8x8OHHEVgvYq6 dcMNSudNyr/3g==
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Score: -6.24
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Marc Zyngier <maz@kernel.org>

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../selftests/kvm/arm64/external_aborts.c     | 54 +++++++++++++++++++
 .../selftests/kvm/include/arm64/processor.h   |  1 +
 .../selftests/kvm/lib/arm64/processor.c       | 13 ++++-
 3 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/external_aborts.c b/tools/testing/selftests/kvm/arm64/external_aborts.c
index 062bf84cced13..780e2af1f3b7b 100644
--- a/tools/testing/selftests/kvm/arm64/external_aborts.c
+++ b/tools/testing/selftests/kvm/arm64/external_aborts.c
@@ -11,6 +11,7 @@
 #define EXPECTED_SERROR_ISS	(ESR_ELx_ISV | 0x1d1ed)
 
 static u64 expected_abort_pc;
+static vm_vaddr_t bad_ptw_va;
 
 static void expect_sea_handler(struct ex_regs *regs)
 {
@@ -84,6 +85,9 @@ static void __vcpu_run_expect(struct kvm_vcpu *vcpu, unsigned int cmd)
 	case UCALL_ABORT:
 		REPORT_GUEST_ASSERT(uc);
 		break;
+	case UCALL_PRINTF:
+		printf("%s", uc.buffer);
+		break;
 	default:
 		if (uc.cmd == cmd)
 			return;
@@ -250,6 +254,55 @@ static void test_serror(void)
 	kvm_vm_free(vm);
 }
 
+static void expect_sea_s1ptw_handler(struct ex_regs *regs)
+{
+	u64 esr = read_sysreg(esr_el1);
+
+
+	GUEST_ASSERT_EQ(regs->pc, expected_abort_pc);
+	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_DABT_CUR);
+	__GUEST_ASSERT((esr & ESR_ELx_FSC_TYPE) >= ESR_ELx_FSC_SEA_TTW(-1) &&
+		       (esr & ESR_ELx_FSC_TYPE) <= ESR_ELx_FSC_SEA_TTW(3),
+		       "ESR == %lx\n", esr);
+
+	GUEST_DONE();
+}
+
+static noinline void test_s1ptw_abort_guest(void)
+{
+	void (*fn)(void) = (void*)bad_ptw_va;
+	extern char test_s1ptw_abort_insn;
+
+	WRITE_ONCE(expected_abort_pc, (u64)&test_s1ptw_abort_insn);
+
+	fn();
+	asm volatile("test_s1ptw_abort_insn:\n\t"
+		     "ldr x0, [%0]\n\t"
+		     : : "r" (bad_ptw_va) : "x0", "memory");
+
+	GUEST_FAIL("Load on S1PTW abort should not retire");
+}
+
+static void test_s1ptw_abort(void)
+{
+	struct kvm_vcpu *vcpu;
+	u64 *ptep, bad_pa;
+	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_s1ptw_abort_guest,
+							expect_sea_s1ptw_handler);
+
+	bad_ptw_va = __vm_vaddr_alloc(vm, vm->page_size,
+				      vm->page_size, MEM_REGION_DATA);
+
+	ptep = virt_get_pte_hva_at_level(vm, bad_ptw_va, 2);
+	bad_pa = BIT(vm->pa_bits) - vm->page_size;
+
+	*ptep &= ~GENMASK(47, 12);
+	*ptep |= bad_pa;
+
+	vcpu_run_expect_done(vcpu);
+	kvm_vm_free(vm);
+}
+
 static void test_serror_emulated_guest(void)
 {
 	GUEST_ASSERT(!(read_sysreg(isr_el1) & ISR_EL1_A));
@@ -327,4 +380,5 @@ int main(void)
 	test_serror_masked();
 	test_serror_emulated();
 	test_mmio_ease();
+	test_s1ptw_abort();
 }
diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index 255fed769a8a5..e3e916b1d9c4e 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -175,6 +175,7 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
+uint64_t *virt_get_pte_hva_at_level(struct kvm_vm *vm, vm_vaddr_t gva, int level);
 uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva);
 
 static inline void cpu_relax(void)
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 9d69904cb6084..628c5bc8c4381 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -185,7 +185,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	_virt_pg_map(vm, vaddr, paddr, attr_idx);
 }
 
-uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
+uint64_t *virt_get_pte_hva_at_level(struct kvm_vm *vm, vm_vaddr_t gva, int level)
 {
 	uint64_t *ptep;
 
@@ -195,17 +195,23 @@ uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
 	ptep = addr_gpa2hva(vm, vm->pgd) + pgd_index(vm, gva) * 8;
 	if (!ptep)
 		goto unmapped_gva;
+	if (level == 0)
+		return ptep;
 
 	switch (vm->pgtable_levels) {
 	case 4:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, gva) * 8;
 		if (!ptep)
 			goto unmapped_gva;
+		if (level == 1)
+			return ptep;
 		/* fall through */
 	case 3:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pmd_index(vm, gva) * 8;
 		if (!ptep)
 			goto unmapped_gva;
+		if (level == 2)
+			return ptep;
 		/* fall through */
 	case 2:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, gva) * 8;
@@ -223,6 +229,11 @@ uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
 	exit(EXIT_FAILURE);
 }
 
+uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
+{
+	return virt_get_pte_hva_at_level(vm, gva, 3);
+}
+
 vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	uint64_t *ptep = virt_get_pte_hva(vm, gva);
-- 
2.39.2


