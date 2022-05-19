Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 693FAC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:45:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24E274B3FF;
	Thu, 19 May 2022 09:45:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2j+9YLi8LRiC; Thu, 19 May 2022 09:45:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C19534B408;
	Thu, 19 May 2022 09:45:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91E464B360
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:45:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P8amDH90OQpz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:45:02 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 444AB4B28D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:45:02 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 36706B824AF;
 Thu, 19 May 2022 13:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9DBC36AE5;
 Thu, 19 May 2022 13:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967900;
 bh=SxLFdfnMnEkcdrJsQkkeO75KQ4eQ7yY1tbJ5lT5ChX8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=XPqQc4zFWaMfABPQw5/dfWp2s/7zHYM4gze5jPW/dQaRUBPmocGR+TcexDTEnwGMM
 WJvO3tIobJKM1MzgXouAiiYjA6CHFTaOdjqSOS7lvHtFc1O+EfmIX3u5EgX2Z+2OUM
 rmB9N6bKE5jmxc9UB4Uz85VqPcUA9C2pduwt5TbVOmXPD9dt+ZCNk+XaHvw391dfX7
 bkGM4ItJ/0wz5rTkUnSMJDbIKUL3Ofi3USzyfEbSkeyh8W6b5rgCg5PK+vS17guiNl
 fbt/1HMMOHa6ZTqaEkpF/0aqIgAskIulImvKfGdF2DHv6grWpZrwdvlssJWnyolUGG
 A4MDzh0YrL17Q==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 39/89] KVM: arm64: Extend memory donation to allow
 host-to-guest transitions
Date: Thu, 19 May 2022 14:41:14 +0100
Message-Id: <20220519134204.5379-40-will@kernel.org>
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

In preparation for supporting protected guests, where guest memory
defaults to being inaccessible to the host, extend our memory protection
mechanisms to support donation of pages from the host to a specific
guest.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 62 +++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c                  |  2 +-
 3 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 364432276fe0..b01b5cdb38de 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -69,6 +69,7 @@ int __pkvm_host_reclaim_page(u64 pfn);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct kvm_vcpu *vcpu);
+int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct kvm_vcpu *vcpu);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2e92be8bb463..d0544259eb01 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -890,6 +890,14 @@ static int guest_ack_share(u64 addr, const struct pkvm_mem_transition *tx,
 					      size, PKVM_NOPAGE);
 }
 
+static int guest_ack_donation(u64 addr, const struct pkvm_mem_transition *tx)
+{
+	u64 size = tx->nr_pages * PAGE_SIZE;
+
+	return __guest_check_page_state_range(tx->completer.guest.vcpu, addr,
+					      size, PKVM_NOPAGE);
+}
+
 static int guest_complete_share(u64 addr, const struct pkvm_mem_transition *tx,
 				enum kvm_pgtable_prot perms)
 {
@@ -903,6 +911,17 @@ static int guest_complete_share(u64 addr, const struct pkvm_mem_transition *tx,
 				      prot, &vcpu->arch.pkvm_memcache);
 }
 
+static int guest_complete_donation(u64 addr, const struct pkvm_mem_transition *tx)
+{
+	enum kvm_pgtable_prot prot = pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_OWNED);
+	struct kvm_vcpu *vcpu = tx->completer.guest.vcpu;
+	struct kvm_shadow_vm *vm = get_shadow_vm(vcpu);
+	u64 size = tx->nr_pages * PAGE_SIZE;
+
+	return kvm_pgtable_stage2_map(&vm->pgt, addr, size, tx->completer.guest.phys,
+				      prot, &vcpu->arch.pkvm_memcache);
+}
+
 static int check_share(struct pkvm_mem_share *share)
 {
 	const struct pkvm_mem_transition *tx = &share->tx;
@@ -1088,6 +1107,9 @@ static int check_donation(struct pkvm_mem_donation *donation)
 	case PKVM_ID_HYP:
 		ret = hyp_ack_donation(completer_addr, tx);
 		break;
+	case PKVM_ID_GUEST:
+		ret = guest_ack_donation(completer_addr, tx);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1122,6 +1144,9 @@ static int __do_donate(struct pkvm_mem_donation *donation)
 	case PKVM_ID_HYP:
 		ret = hyp_complete_donation(completer_addr, tx);
 		break;
+	case PKVM_ID_GUEST:
+		ret = guest_complete_donation(completer_addr, tx);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1362,6 +1387,43 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct kvm_vcpu *vcpu)
+{
+	int ret;
+	u64 host_addr = hyp_pfn_to_phys(pfn);
+	u64 guest_addr = hyp_pfn_to_phys(gfn);
+	struct kvm_shadow_vm *vm = get_shadow_vm(vcpu);
+	struct pkvm_mem_donation donation = {
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
+	};
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = do_donate(&donation);
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
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index a6676fd14cf9..2069e6833831 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -47,7 +47,7 @@
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
 #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
-#define KVM_MAX_OWNER_ID		1
+#define KVM_MAX_OWNER_ID		FIELD_MAX(KVM_INVALID_PTE_OWNER_MASK)
 
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable		*pgt;
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
