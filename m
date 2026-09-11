Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3C84756D5
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134683; cv=none; b=S+3hjFfK/YEgCIAnjZFdazkfWRi0OrdNwULOUlQ0gCDyW+YlPX8EvjXzAy4aRDrGAFoVyjx27cu7a3PmuS9GAE7oHSDUGgO1kNICn3k5BMSCP149BXYV5+U6bInG4Paojqjd0Gb6sl66LRqlw0GPoQ5UVcHl6oG24PVbUdzudK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134683; c=relaxed/simple;
	bh=81I9LGqafDHFfwWOMphPGQ6zHJMr83ldT6DVh5OmqGU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZJyT/FVKguBPA6WCyGqr25Ypz7m4ANQxO96AJPAG8W5MRk99xcpNp26PYrgJTuWdSVff0cuiLsZvrq/DP/S1hgZMrwOiGK4B2JN1tV7bgThIV3BbRJ1r1kOK0y+zb/wU6MAMs1i/Y7cflopH8nvOzogu8NoWuM8DIeq0bvJuXt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Box6dL7A; arc=none smtp.client-ip=209.85.218.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Box6dL7A"
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c2945f5e851so83341466b.1
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134679; x=1789739479; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sKehzCq358BLP2dV3ZoGoH+WsNMJgwockYdcdxx5cpc=;
        b=Box6dL7ApOC+KGEHK7zF+1nDjaRtJkgcBT/9hZ4N3+9GBIBY8cW5NieSaxfNEyio3A
         yAyx0zQO3V13k+B1WT+pvPxe8NsITZCnKmbMyYSOr3YA0G5NzYKtmYNl2HGIjBAD53fO
         9DJq30FKscNoP980o/AqjrBSeFasjgsKHLW0rrten9cV0yepg4wQr9PB7nG+7CGzW2jq
         1gifetFDV4fzXYi7xSJKoZUq1qqa6Ml2XKVU3pzI1RCTPhSn5XNSZadgWrzSVQcVvMiO
         2869ZwKH/6NR946m8DGYKN17AoGcF9cBuRvhoEWH+Nu9pxwXE04C0dlwF7Al6GFRw5dK
         +1ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134679; x=1789739479;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sKehzCq358BLP2dV3ZoGoH+WsNMJgwockYdcdxx5cpc=;
        b=WU5o8fXSYW6TMPBFu1njSBhR+YOtX1Plq/pCZNF4tOFqDhc9o9USRywmDzpfwH2a+x
         wvkISPVqWUe81SzbdBWfP1IEw5GWjbDxUIFsj8Kh6q9KsnEcpE+ISpkk//+7+eX+v2Qh
         PN7WZZ5EnAZJhPMC/wLEb2IqEakhNYgR4Y46OA0881JwlSaRas0r8jq1qq+cR2fEMJa+
         pSpUBu3NL5yd1LqLM12rK1u5eIcx/B/fzuvN8A5WJUbhMjmUJSXJkvFJlSMvL+NZak6V
         /mCJ4gxgsdk8IrzY9jE/N/ULlsOBj83Y0/YLhJmSaYTECfWsnu67KInPcNEw0GffInVg
         8mIw==
X-Forwarded-Encrypted: i=1; AKwUvBxeLboXPksFLtLHknEVW3pSYz3FD5A71DCoon8vz1owStvKa5S1egfULyuhSUSHiCWR5AAH/hM=@lists.linux.dev
X-Gm-Message-State: AFuF++nrPGYjunkodYiv14BK8fjgA8VA79vxovW+HCUkcYDZZGfGjH9L
	fef2c4iSmIfEpQaOmGPjDCPPI6m25FY1MBzrkk+eHyytYoKf+QXEfdOune92wtXOfHCPSZaTvze
	A5mTSizpzhGHkno1pudXNuw==
X-Received: from ejfc17.prod.google.com ([2002:a17:906:18b1:b0:c26:1e78:802f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:1c9e:b0:c20:3402:bd35 with SMTP id a640c23a62f3a-c29665948a2mr210088866b.12.1789134678439;
 Fri, 11 Sep 2026 06:51:18 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:50:45 +0100
In-Reply-To: <20260911135053.146435-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260911135053.146435-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911135053.146435-15-vdonnefort@google.com>
Subject: [PATCH v2 14/22] KVM: arm64: Add a range to pKVM ownership selftest
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Extend pkvm_ownership_selftest() with a nr_pages argument so that state
transitions can be tested with both page-granular (1) and block-granular
(PMD_SIZE / PAGE_SIZE) ranges.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   9 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   8 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 214 ++++++++++--------
 arch/arm64/kvm/pkvm.c                         |  37 +--
 4 files changed, 150 insertions(+), 118 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 33f2d1824614..7904a95ab8ac 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -74,9 +74,14 @@ static __always_inline void __load_host_stage2(void)
 }
 
 #ifdef CONFIG_NVHE_EL2_DEBUG
-int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr_pages);
+int __pkvm_ownership_selftest(u64 pfn, u64 nr_pages, u64 pgtable_pfn,
+			      unsigned long pgtable_nr_pages);
 #else
 static inline int
-__pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr_pages) { return 0; }
+__pkvm_ownership_selftest(u64 pfn, u64 nr_pages, u64 pgtable_pfn,
+			  unsigned long pgtable_nr_pages)
+{
+	return 0;
+}
 #endif
 #endif /* __KVM_NVHE_MEM_PROTECT__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index ce816f01ab4f..7ef7da69f48b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -755,10 +755,12 @@ static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ct
 static void handle___pkvm_ownership_selftest(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(u64, pfn, host_ctxt, 1);
-	DECLARE_REG(u64, pgtable_pfn, host_ctxt, 2);
-	DECLARE_REG(unsigned long, pgtable_nr_pages, host_ctxt, 3);
+	DECLARE_REG(u64, nr_pages, host_ctxt, 2);
+	DECLARE_REG(u64, pgtable_pfn, host_ctxt, 3);
+	DECLARE_REG(unsigned long, pgtable_nr_pages, host_ctxt, 4);
 
-	cpu_reg(host_ctxt, 1) = __pkvm_ownership_selftest(pfn, pgtable_pfn, pgtable_nr_pages);
+	cpu_reg(host_ctxt, 1) = __pkvm_ownership_selftest(pfn, nr_pages, pgtable_pfn,
+							  pgtable_nr_pages);
 }
 
 static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index cfcdf187cbc3..2893183c2056 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1764,14 +1764,19 @@ static u64 selftest_ipa(void)
 	return BIT(selftest_vcpu->vcpu.arch.hw_mmu->pgt->ia_bits - 1);
 }
 
+static unsigned long selftest_nr_pages;
+
 static void assert_page_state(void)
 {
 	void *virt = hyp_page_to_virt(selftest_page);
-	u64 size = PAGE_SIZE << selftest_page->order;
 	struct pkvm_hyp_vcpu *vcpu = selftest_vcpu;
+	u64 size = selftest_nr_pages * PAGE_SIZE;
 	u64 phys = hyp_virt_to_phys(virt);
-	u64 ipa[2] = { selftest_ipa(), selftest_ipa() + PAGE_SIZE };
 	struct pkvm_hyp_vm *vm;
+	u64 ipa[2] = {
+		selftest_ipa(),
+		selftest_ipa() + size
+	};
 
 	vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
 
@@ -1795,7 +1800,8 @@ static void assert_page_state(void)
 		assert_page_state();			\
 	} while (0)
 
-int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr_pages)
+int __pkvm_ownership_selftest(u64 pfn, u64 nr_pages, u64 pgtable_pfn,
+			      unsigned long pgtable_nr_pages)
 {
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_RWX;
 	struct pkvm_hyp_vcpu *vcpu;
@@ -1808,7 +1814,7 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	if (ret)
 		return ret;
 
-	ret = __pkvm_host_donate_hyp(pfn, 1);
+	ret = __pkvm_host_donate_hyp(pfn, nr_pages);
 	if (ret) {
 		WARN_ON(__pkvm_hyp_donate_host(pgtable_pfn, pgtable_nr_pages));
 		return ret;
@@ -1818,10 +1824,11 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 						pgtable_nr_pages);
 	vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
 
+	selftest_nr_pages = nr_pages;
 	phys = hyp_pfn_to_phys(pfn);
 	virt = hyp_phys_to_virt(phys);
 	gfn = hyp_phys_to_pfn(selftest_ipa());
-	size = PAGE_SIZE;
+	size = nr_pages * PAGE_SIZE;
 
 	selftest_page = hyp_virt_to_page(virt);
 	selftest_page->refcount = 0;
@@ -1830,48 +1837,48 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	selftest_state.hyp = PKVM_PAGE_OWNED;
 	selftest_state.guest[0] = selftest_state.guest[1] = PKVM_NOPAGE;
 	assert_page_state();
-	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, nr_pages);
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
-	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
-	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
-	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, nr_pages, vcpu, prot);
+	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, nr_pages, vm);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
 
 	selftest_state.host = PKVM_PAGE_OWNED;
 	selftest_state.hyp = PKVM_NOPAGE;
-	assert_transition_res(0,	__pkvm_hyp_donate_host, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, 1);
-	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
+	assert_transition_res(0,	__pkvm_hyp_donate_host, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, nr_pages);
+	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, nr_pages, vm);
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
 
 	selftest_state.host = PKVM_PAGE_SHARED_OWNED;
 	selftest_state.hyp = PKVM_PAGE_SHARED_BORROWED;
-	assert_transition_res(0,	__pkvm_host_share_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
-	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
-	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
+	assert_transition_res(0,	__pkvm_host_share_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, nr_pages, vcpu, prot);
+	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, nr_pages, vm);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
 
 	assert_transition_res(0,	hyp_pin_shared_mem, virt, virt + size);
 	assert_transition_res(0,	hyp_pin_shared_mem, virt, virt + size);
 	hyp_unpin_shared_mem(virt, virt + size);
 	WARN_ON(hyp_page_count(virt) != 1);
-	assert_transition_res(-EBUSY,	__pkvm_host_unshare_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
-	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
-	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
+	assert_transition_res(-EBUSY,	__pkvm_host_unshare_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, nr_pages, vcpu, prot);
+	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, nr_pages, vm);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
 
 	hyp_unpin_shared_mem(virt, virt + size);
 	assert_page_state();
@@ -1879,116 +1886,125 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 
 	selftest_state.host = PKVM_PAGE_OWNED;
 	selftest_state.hyp = PKVM_NOPAGE;
-	assert_transition_res(0,	__pkvm_host_unshare_hyp, pfn, 1);
+	assert_transition_res(0,	__pkvm_host_unshare_hyp, pfn, nr_pages);
 
 	selftest_state.host = PKVM_PAGE_SHARED_OWNED;
 	selftest_state.hyp = PKVM_NOPAGE;
-	assert_transition_res(0,	__pkvm_host_share_ffa, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
-	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, 1, vm);
-	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
+	assert_transition_res(0,	__pkvm_host_share_ffa, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, nr_pages, vcpu, prot);
+	assert_transition_res(-ENOENT,	__pkvm_host_unshare_guest, gfn, nr_pages, vm);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
 
 	selftest_state.host = PKVM_PAGE_OWNED;
 	selftest_state.hyp = PKVM_NOPAGE;
-	assert_transition_res(0,	__pkvm_host_unshare_ffa, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, 1);
+	assert_transition_res(0,	__pkvm_host_unshare_ffa, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, nr_pages);
 
 	selftest_state.host = PKVM_PAGE_SHARED_OWNED;
 	selftest_state.guest[0] = PKVM_PAGE_SHARED_BORROWED;
-	assert_transition_res(0,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
-	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
-	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
-	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
+	assert_transition_res(0,	__pkvm_host_share_guest, pfn, gfn, nr_pages, vcpu, prot);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, nr_pages, vcpu, prot);
+	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, nr_pages);
+	assert_transition_res(-EPERM,   __pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
 	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
 
 	selftest_state.guest[1] = PKVM_PAGE_SHARED_BORROWED;
-	assert_transition_res(0,	__pkvm_host_share_guest, pfn, gfn + 1, 1, vcpu, prot);
+	assert_transition_res(0,	__pkvm_host_share_guest, pfn, gfn + nr_pages, nr_pages,
+								 vcpu, prot);
 	WARN_ON(hyp_virt_to_page(virt)->host_share_guest_count != 2);
 
 	selftest_state.guest[0] = PKVM_NOPAGE;
-	assert_transition_res(0,	__pkvm_host_unshare_guest, gfn, 1, vm);
+	assert_transition_res(0,	__pkvm_host_unshare_guest, gfn, nr_pages, vm);
 
 	selftest_state.guest[1] = PKVM_NOPAGE;
 	selftest_state.host = PKVM_PAGE_OWNED;
-	assert_transition_res(0,	__pkvm_host_unshare_guest, gfn + 1, 1, vm);
+	assert_transition_res(0,	__pkvm_host_unshare_guest, gfn + nr_pages, nr_pages, vm);
 
 	selftest_state.host = PKVM_NOPAGE;
 	selftest_state.guest[0] = PKVM_PAGE_OWNED;
-	assert_transition_res(0,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn + 1, 1, vcpu);
-	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
-	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn + 1, 1, vcpu, prot);
-	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
+	assert_transition_res(0,	__pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn + nr_pages, nr_pages,
+								  vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, nr_pages, vcpu, prot);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn + nr_pages, nr_pages,
+								 vcpu, prot);
+	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, nr_pages);
 
 	selftest_state.host = PKVM_PAGE_SHARED_BORROWED;
 	selftest_state.guest[0] = PKVM_PAGE_SHARED_OWNED;
-	assert_transition_res(0,	__pkvm_guest_share_host, vcpu, gfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_guest_share_host, vcpu, gfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn + 1, 1, vcpu);
-	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
-	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn + 1, 1, vcpu, prot);
-	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
+	assert_transition_res(0,	__pkvm_guest_share_host, vcpu, gfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_guest_share_host, vcpu, gfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn + nr_pages, nr_pages,
+								  vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, nr_pages, vcpu, prot);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn + nr_pages, nr_pages,
+								 vcpu, prot);
+	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, nr_pages);
 
 	selftest_state.host = PKVM_NOPAGE;
 	selftest_state.guest[0] = PKVM_PAGE_OWNED;
-	assert_transition_res(0,	__pkvm_guest_unshare_host, vcpu, gfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_guest_unshare_host, vcpu, gfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn + 1, 1, vcpu);
-	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
-	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn + 1, 1, vcpu, prot);
-	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, 1);
-	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
+	assert_transition_res(0,	__pkvm_guest_unshare_host, vcpu, gfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_guest_unshare_host, vcpu, gfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn + nr_pages, nr_pages,
+								  vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, nr_pages, vcpu, prot);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn + nr_pages, nr_pages,
+								 vcpu, prot);
+	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn, nr_pages);
+	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, nr_pages);
 
 	selftest_state.host = PKVM_PAGE_OWNED;
 	selftest_state.guest[0] = PKVM_POISON;
 	assert_transition_res(0,	__pkvm_host_force_reclaim_page_guest, phys);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
-	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
-	assert_transition_res(-EHWPOISON, __pkvm_guest_share_host, vcpu, gfn, 1);
-	assert_transition_res(-EHWPOISON, __pkvm_guest_unshare_host, vcpu, gfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, nr_pages, vcpu, prot);
+	assert_transition_res(-EHWPOISON, __pkvm_guest_share_host, vcpu, gfn, nr_pages);
+	assert_transition_res(-EHWPOISON, __pkvm_guest_unshare_host, vcpu, gfn, nr_pages);
 
 	selftest_state.host = PKVM_NOPAGE;
 	selftest_state.guest[1] = PKVM_PAGE_OWNED;
-	assert_transition_res(0,	__pkvm_host_donate_guest, pfn, gfn + 1, 1, vcpu);
+	assert_transition_res(0,	__pkvm_host_donate_guest, pfn, gfn + nr_pages, nr_pages,
+								  vcpu);
 
 	selftest_state.host = PKVM_PAGE_OWNED;
 	selftest_state.guest[1] = PKVM_NOPAGE;
-	assert_transition_res(0,	__pkvm_host_reclaim_guest, gfn + 1, 1, vm);
-	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, 1, vcpu);
-	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, 1, vcpu, prot);
+	assert_transition_res(0,	__pkvm_host_reclaim_guest, gfn + nr_pages, nr_pages,
+									vm);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_guest, pfn, gfn, nr_pages, vcpu);
+	assert_transition_res(-EPERM,	__pkvm_host_share_guest, pfn, gfn, nr_pages, vcpu, prot);
 
 	selftest_state.host = PKVM_NOPAGE;
 	selftest_state.hyp = PKVM_PAGE_OWNED;
-	assert_transition_res(0,	__pkvm_host_donate_hyp, pfn, 1);
+	assert_transition_res(0,	__pkvm_host_donate_hyp, pfn, nr_pages);
 
 	/* This also gives back the ownership to the host */
 	teardown_selftest_vm();
 
-	WARN_ON(__pkvm_hyp_donate_host(pfn, 1));
+	WARN_ON(__pkvm_hyp_donate_host(pfn, nr_pages));
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 5b4256b19507..ae434f806455 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -257,31 +257,40 @@ static void __init _kvm_host_prot_finalize(void *arg)
 }
 
 #ifdef CONFIG_NVHE_EL2_DEBUG
+static void __init __pkvm_ownership_selftest(unsigned long page_order,
+					     unsigned long pgtable,
+					     unsigned long pgtable_order)
+{
+	unsigned long nr_pages = 1UL << page_order;
+	unsigned long page;
+	int ret = -ENOMEM;
+
+	/* Page whose ownership will be tested */
+	page = __get_free_pages(GFP_KERNEL, page_order);
+	if (page)
+		ret = kvm_call_hyp_nvhe(__pkvm_ownership_selftest,
+					virt_to_pfn((void *)page), nr_pages,
+					virt_to_pfn((void *)pgtable), 1 << pgtable_order);
+	if (ret)
+		kvm_err("%s(order=%ld) failed (%d)\n", __func__, page_order, ret);
+
+	free_pages(page, page_order);
+}
+
 void __init pkvm_ownership_selftest(void)
 {
 	unsigned long pgtable_order = 5;
 	unsigned long pgtable = 0;
-	unsigned long page = 0;
-	long ret = -ENOMEM;
 
 	/* Memory for the VM page-table */
 	pgtable = __get_free_pages(GFP_KERNEL, pgtable_order);
 	if (!pgtable)
-		goto out;
+		return;
 
-	/* Page whose ownership will be tested */
-	page = __get_free_page(GFP_KERNEL);
-	if (!page)
-		goto out;
-
-	ret = kvm_call_hyp_nvhe(__pkvm_ownership_selftest, virt_to_pfn((void *)page),
-				virt_to_pfn((void *)pgtable), 1 << pgtable_order);
-out:
-	if (ret)
-		kvm_err("Failed to run %s (%ld)\n", __func__, ret);
+	__pkvm_ownership_selftest(0, pgtable, pgtable_order);
+	__pkvm_ownership_selftest(PMD_ORDER, pgtable, pgtable_order);
 
 	free_pages(pgtable, pgtable_order);
-	free_page(page);
 }
 #endif
 
-- 
2.55.0.1007.g17ff1f9808-goog

