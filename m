Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98636C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:44:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D5794B211;
	Thu, 19 May 2022 09:44:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dtPuYgP7b-bV; Thu, 19 May 2022 09:44:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1F524B33E;
	Thu, 19 May 2022 09:44:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB8B64B37B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:44:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wztYXoJb2q5I for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:44:17 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C2BA4B211
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:44:17 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 13B63CE2440;
 Thu, 19 May 2022 13:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2348C34100;
 Thu, 19 May 2022 13:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967852;
 bh=3RiCLx91vvFl1eY7jTdmSanbOyZssF2WI8MnbolxOp4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=tVjz539inNrid512QIfuKXH8AgCnxGbY4bE+QRsfW30XUSmNgTTNGortoeqc7Z0bv
 owdABQKqQWhZ8ijGi6dMzjCaNADYiil1TVlW/++fgyqGa/BrkUuxh0zMWrzUaDxFqS
 kCSVqhtNuwUG6gsN2ipKCJ//+gai7qOy2R3KfmR2oMTGN1yDMVMZ3NryZv6DVxXcI2
 A3gChDgh6VLMeJhy4A2LWrvU+gJIDksmKpyHA2a25Omdz/vJrwJh5fCS0byIuRFWxc
 NgUrbxUbV3Eg5bzChzEbLzlKYpg/XppikPgSsfd7cdtM7stREYHTg7Uyq9986xt36r
 zDuAweUiltMnA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 27/89] KVM: arm64: Extend memory sharing to allow
 host-to-guest transitions
Date: Thu, 19 May 2022 14:41:02 +0100
Message-Id: <20220519134204.5379-28-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

In preparation for handling guest stage-2 mappings at EL2, extend our
memory protection mechanisms to support sharing of pages from the host
to a specific guest.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h             |   8 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 100 ++++++++++++++++++
 3 files changed, 108 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 32ac88e60e6b..264b1d2c4eb6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -421,8 +421,12 @@ struct kvm_vcpu_arch {
 	/* Don't run the guest (internal implementation need) */
 	bool pause;
 
-	/* Cache some mmu pages needed inside spinlock regions */
-	struct kvm_mmu_memory_cache mmu_page_cache;
+	union {
+		/* Cache some mmu pages needed inside spinlock regions */
+		struct kvm_mmu_memory_cache mmu_page_cache;
+		/* Pages to be donated to pkvm/EL2 if it runs out */
+		struct kvm_hyp_memcache pkvm_memcache;
+	};
 
 	/* Target CPU and feature flags */
 	int target;
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index ecedc545e608..364432276fe0 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -57,6 +57,7 @@ extern struct host_kvm host_kvm;
 enum pkvm_component_id {
 	PKVM_ID_HOST,
 	PKVM_ID_HYP,
+	PKVM_ID_GUEST,
 };
 
 extern unsigned long hyp_nr_cpus;
@@ -67,6 +68,7 @@ int __pkvm_host_unshare_hyp(u64 pfn);
 int __pkvm_host_reclaim_page(u64 pfn);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
+int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct kvm_vcpu *vcpu);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index adb6a880c684..2e92be8bb463 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -579,11 +579,21 @@ struct pkvm_mem_transition {
 			struct {
 				u64	completer_addr;
 			} hyp;
+			struct {
+				struct kvm_vcpu *vcpu;
+			} guest;
 		};
 	} initiator;
 
 	struct {
 		enum pkvm_component_id	id;
+
+		union {
+			struct {
+				struct kvm_vcpu *vcpu;
+				phys_addr_t phys;
+			} guest;
+		};
 	} completer;
 };
 
@@ -847,6 +857,52 @@ static int hyp_complete_donation(u64 addr,
 	return pkvm_create_mappings_locked(start, end, prot);
 }
 
+static enum pkvm_page_state guest_get_page_state(kvm_pte_t pte)
+{
+	if (!kvm_pte_valid(pte))
+		return PKVM_NOPAGE;
+
+	return pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte));
+}
+
+static int __guest_check_page_state_range(struct kvm_vcpu *vcpu, u64 addr,
+					  u64 size, enum pkvm_page_state state)
+{
+	struct kvm_shadow_vm *vm = get_shadow_vm(vcpu);
+	struct check_walk_data d = {
+		.desired	= state,
+		.get_page_state	= guest_get_page_state,
+	};
+
+	hyp_assert_lock_held(&vm->lock);
+	return check_page_state_range(&vm->pgt, addr, size, &d);
+}
+
+static int guest_ack_share(u64 addr, const struct pkvm_mem_transition *tx,
+			   enum kvm_pgtable_prot perms)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+
+	if (perms != KVM_PGTABLE_PROT_RWX)
+		return -EPERM;
+
+	return __guest_check_page_state_range(tx->completer.guest.vcpu, addr,
+					      size, PKVM_NOPAGE);
+}
+
+static int guest_complete_share(u64 addr, const struct pkvm_mem_transition *tx,
+				enum kvm_pgtable_prot perms)
+{
+	struct kvm_vcpu *vcpu = tx->completer.guest.vcpu;
+	struct kvm_shadow_vm *vm = get_shadow_vm(vcpu);
+	u64 size = tx->nr_pages * PAGE_SIZE;
+	enum kvm_pgtable_prot prot;
+
+	prot = pkvm_mkstate(perms, PKVM_PAGE_SHARED_BORROWED);
+	return kvm_pgtable_stage2_map(&vm->pgt, addr, size, tx->completer.guest.phys,
+				      prot, &vcpu->arch.pkvm_memcache);
+}
+
 static int check_share(struct pkvm_mem_share *share)
 {
 	const struct pkvm_mem_transition *tx = &share->tx;
@@ -868,6 +924,9 @@ static int check_share(struct pkvm_mem_share *share)
 	case PKVM_ID_HYP:
 		ret = hyp_ack_share(completer_addr, tx, share->completer_prot);
 		break;
+	case PKVM_ID_GUEST:
+		ret = guest_ack_share(completer_addr, tx, share->completer_prot);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -896,6 +955,9 @@ static int __do_share(struct pkvm_mem_share *share)
 	case PKVM_ID_HYP:
 		ret = hyp_complete_share(completer_addr, tx, share->completer_prot);
 		break;
+	case PKVM_ID_GUEST:
+		ret = guest_complete_share(completer_addr, tx, share->completer_prot);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1262,6 +1324,44 @@ void hyp_unpin_shared_mem(void *from, void *to)
 	host_unlock_component();
 }
 
+int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct kvm_vcpu *vcpu)
+{
+	int ret;
+	u64 host_addr = hyp_pfn_to_phys(pfn);
+	u64 guest_addr = hyp_pfn_to_phys(gfn);
+	struct kvm_shadow_vm *vm = get_shadow_vm(vcpu);
+	struct pkvm_mem_share share = {
+		.tx	= {
+			.nr_pages	= 1,
+			.initiator	= {
+				.id	= PKVM_ID_HOST,
+				.addr	= host_addr,
+				.host	= {
+					.completer_addr = guest_addr,
+				},
+			},
+			.completer	= {
+				.id	= PKVM_ID_GUEST,
+				.guest	= {
+					.vcpu = vcpu,
+					.phys = host_addr,
+				},
+			},
+		},
+		.completer_prot	= KVM_PGTABLE_PROT_RWX,
+	};
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = do_share(&share);
+
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
+
 static int hyp_zero_page(phys_addr_t phys)
 {
 	void *addr;
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
