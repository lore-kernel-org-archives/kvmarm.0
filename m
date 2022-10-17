Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D767F
	for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 11:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB68C433D6;
	Mon, 17 Oct 2022 11:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666007570;
	bh=VxPja3d2GHqoIhuBEgJwpkqFA2a5hFZGKu7/PjMAaYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qp0WdwQQRsqAmA01Sjb3WrTNM85uukSDjCLBxj3CiXfSLquqlJzNIgmEvNP/kEs5O
	 lu86ygN/TIC+Oylx/CpYSJi7nngToQwSWIoaTTXDwushaQZ6538l0+SfTrgG+ow2VX
	 3Mq6xllimzJmB8Piej2z/7pseRUz/OscZgCVSOsyqKjNgUvTtc8Cj1j0U/Y1v/KZLX
	 lahjTGsLgwhmsgk2hanytH0Q/guAmeSfHda9Xb6YhYZAykzMQUh2hNoHDFwDEyMhLE
	 Za6xVN3s/NBs4ZT1db+iHdpDDBJdwvP9MSDwIn9PCwwI7hJzTK+Lo0VXMsA0e5k5MY
	 kIezNor4QgEIw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Will Deacon <will@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Quentin Perret <qperret@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	kernel-team@android.com,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 08/25] KVM: arm64: Add helpers to pin memory shared with the hypervisor at EL2
Date: Mon, 17 Oct 2022 12:51:52 +0100
Message-Id: <20221017115209.2099-9-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221017115209.2099-1-will@kernel.org>
References: <20221017115209.2099-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Quentin Perret <qperret@google.com>

Add helpers allowing the hypervisor to check whether a range of pages
are currently shared by the host, and 'pin' them if so by blocking host
unshare operations until the memory has been unpinned.

This will allow the hypervisor to take references on host-provided
data-structures (e.g. 'struct kvm') with the guarantee that these pages
will remain in a stable state until the hypervisor decides to release
them, for example during guest teardown.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  3 ++
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  7 ++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 48 +++++++++++++++++++
 3 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index c87b19b2d468..998bf165af71 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -69,6 +69,9 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id);
 int kvm_host_prepare_stage2(void *pgt_pool_base);
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 
+int hyp_pin_shared_mem(void *from, void *to);
+void hyp_unpin_shared_mem(void *from, void *to);
+
 static __always_inline void __load_host_stage2(void)
 {
 	if (static_branch_likely(&kvm_protected_mode_initialized))
diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 9422900e5c6a..ab205c4d6774 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -55,10 +55,15 @@ static inline void hyp_page_ref_inc(struct hyp_page *p)
 	p->refcount++;
 }
 
-static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
+static inline void hyp_page_ref_dec(struct hyp_page *p)
 {
 	BUG_ON(!p->refcount);
 	p->refcount--;
+}
+
+static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
+{
+	hyp_page_ref_dec(p);
 	return (p->refcount == 0);
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index a7156fd13bc8..1262dbae7f06 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -625,6 +625,9 @@ static int hyp_ack_unshare(u64 addr, const struct pkvm_mem_transition *tx)
 {
 	u64 size = tx->nr_pages * PAGE_SIZE;
 
+	if (tx->initiator.id == PKVM_ID_HOST && hyp_page_count((void *)addr))
+		return -EBUSY;
+
 	if (__hyp_ack_skip_pgtable_check(tx))
 		return 0;
 
@@ -1038,3 +1041,48 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 
 	return ret;
 }
+
+int hyp_pin_shared_mem(void *from, void *to)
+{
+	u64 cur, start = ALIGN_DOWN((u64)from, PAGE_SIZE);
+	u64 end = PAGE_ALIGN((u64)to);
+	u64 size = end - start;
+	int ret;
+
+	host_lock_component();
+	hyp_lock_component();
+
+	ret = __host_check_page_state_range(__hyp_pa(start), size,
+					    PKVM_PAGE_SHARED_OWNED);
+	if (ret)
+		goto unlock;
+
+	ret = __hyp_check_page_state_range(start, size,
+					   PKVM_PAGE_SHARED_BORROWED);
+	if (ret)
+		goto unlock;
+
+	for (cur = start; cur < end; cur += PAGE_SIZE)
+		hyp_page_ref_inc(hyp_virt_to_page(cur));
+
+unlock:
+	hyp_unlock_component();
+	host_unlock_component();
+
+	return ret;
+}
+
+void hyp_unpin_shared_mem(void *from, void *to)
+{
+	u64 cur, start = ALIGN_DOWN((u64)from, PAGE_SIZE);
+	u64 end = PAGE_ALIGN((u64)to);
+
+	host_lock_component();
+	hyp_lock_component();
+
+	for (cur = start; cur < end; cur += PAGE_SIZE)
+		hyp_page_ref_dec(hyp_virt_to_page(cur));
+
+	hyp_unlock_component();
+	host_unlock_component();
+}
-- 
2.38.0.413.g74048e4d9e-goog

