Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24F5C405C57
	for <kvmarm@lists.linux.dev>; Sat, 16 May 2026 18:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778956282; cv=none; b=iSQ1czoHivlhYyNZt5CBjSDpr03FH1OUk6MfTzODM0/rU5B+8jr/r86priqJw0zJYH+M0K/Pg0KxYdDeimRFf8EybaglzpNUCN7a4WS2vc4JORyDSlKlqUq7uSjKeEyzr5RWA880e0Kx/W8IygzvB0+2/6O1HGSWS1rjXtklhMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778956282; c=relaxed/simple;
	bh=/1t/CERV4WJKmLTkfx/AdC8xUY2k0LviAytjvvkIoEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skHy8ALdNqkpIInKbWZPs+34Df9I+RCnicoNnPg0aL/gokCXM2jiY8xSMY1j2SVAJI96DapMBkmxaoy2lqiqNyvLK7Mh/pMdc1xMefA/RIxo3waPj/NgaUrybvNS31IEkCWxG4BKHqeaa6itWfduKYwYqEs+lKjNxADsficTRr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qpRjr816; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qpRjr816"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 951041BF3;
	Sat, 16 May 2026 11:31:10 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 24C233F85F;
	Sat, 16 May 2026 11:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778956275; bh=/1t/CERV4WJKmLTkfx/AdC8xUY2k0LviAytjvvkIoEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpRjr816bPDh6feC6wJMq4ZIT5RzIoLJmWRlzCn5rCnXmoTiF3bHGGE1C5XSnJc7Q
	 VjYxy9b7Uts/utZxVgpD6SKJNwAU6vibvirdlm9ieO0R71PaivSFzOxTjBQeAyOv0i
	 RLlH90CDHQA/7p5jNQ6H7s9GkpJ+9Z12pLK0DLbo=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 9/9] KVM: arm64: selftests: shadow_stage2: Turn on stage-2 translation for the nested guest
Date: Sat, 16 May 2026 19:30:03 +0100
Message-ID: <20260516183003.799058-10-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260516183003.799058-1-weilin.chang@arm.com>
References: <20260516183003.799058-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Utilize the stage-2 library functions to initialize a s2_mmu, build a
stage-2 page table, and turn on stage-2 translation for the nested
guest. This better tests out the shadow page table code in KVM.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 .../selftests/kvm/arm64/shadow_stage2.c       | 23 ++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/shadow_stage2.c b/tools/testing/selftests/kvm/arm64/shadow_stage2.c
index 2b274b810dcf..5bce55abdea7 100644
--- a/tools/testing/selftests/kvm/arm64/shadow_stage2.c
+++ b/tools/testing/selftests/kvm/arm64/shadow_stage2.c
@@ -51,9 +51,11 @@ static void l2_guest_code(void)
 static void guest_code(void)
 {
 	struct vcpu vcpu;
+	struct s2_mmu mmu;
 	struct hyp_data hyp_data;
 	int ret, i = 0;
-	gpa_t l2_pc, l2_stack_top;
+	gpa_t l2_pc, l2_stack_start, l2_stack_top, s2_pgd;
+	gpa_t do_hvc_gpa;
 	struct page_pool pp;
 	u64 mmfr0 = read_sysreg(id_aa64mmfr0_el1);
 
@@ -68,11 +70,20 @@ static void guest_code(void)
 	if (!has_tgran_2(mmfr0, pp.page_size))
 		GUEST_SYNC1(TGRAN2NOSUP);
 
-	l2_stack_top = alloc_page(&pp) + pp.page_size;
+	l2_stack_start = alloc_page(&pp);
+	l2_stack_top = l2_stack_start + pp.page_size;
 	l2_pc = ucall_translate_to_gpa(l2_guest_code);
+	do_hvc_gpa = ucall_translate_to_gpa(do_hvc);
+
+	s2_pgd = alloc_page(&pp);
 
 	init_vcpu(&vcpu, l2_pc, l2_stack_top);
-	prepare_hyp_no_s2();
+	init_s2_mmu(&mmu, 0, s2_pgd, pp.page_size, 40);
+	create_s2_mapping(&mmu, l2_pc, l2_pc, pp.page_size * 2, &pp);
+	create_s2_mapping(&mmu, do_hvc_gpa, do_hvc_gpa, pp.page_size, &pp);
+	create_s2_mapping(&mmu, l2_stack_start, l2_stack_start, pp.page_size, &pp);
+
+	prepare_hyp(&mmu);
 
 	while (true) {
 		GUEST_PRINTF("L2 enter\n");
@@ -113,6 +124,12 @@ int main(void)
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
 				    L2_PAGE_POOL_ADDR, L2_PAGE_POOL_MEMSLOT,
 				    L2_PAGE_POOL_NPAGES, 0);
+	/*
+	 * This idmap allows L1 to traverse and build its guest stage-2, where
+	 * it must do a PA to VA conversion in order to descend to the next
+	 * level.
+	 */
+	virt_map(vm, L2_PAGE_POOL_ADDR, L2_PAGE_POOL_ADDR, L2_PAGE_POOL_NPAGES);
 
 	while (true) {
 		vcpu_run(vcpu);
-- 
2.43.0

