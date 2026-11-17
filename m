Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937475;
	b=ZdvY3OVpv6+cvcL6Ca2lYLvYYNPhB4ZPSCUuJ9DEUa7bqSfgIXOx76Zz1Qx2xg31fQpg
	 avPbaPNaGQqyyw8egQC8qjLLplv5sgA825/K4witsZRmecw7ZWc2bmYYRnZmTjOjI66q8
	 JCT5Z1YPFWK1zPjCC2uzFJvRy3K3n6nHqQzriqFTeLfAs/Luq0/09qh2uVc6PBWA4hm7Q
	 ybmKxQ3HxqvYvkXe8WD3gNgP3TyxQZk1rtoEX44qzTbgD7Ov/rSsUG14woU5Wx6Y6Ka44
	 7BRoQcx826q5gCNvgNsnlx9dCjgHbl05hF9xEUX4Z342SaaBbrfjn7L/Ze2Mx5jqkEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937475;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=q6t84Pka6sjdVDTSiJiZNZc5e4fjMt3grSTxqNeIf7Y=;
	b=nn3L9J7aoyCf3+S+ONBsfIbFhiQiP0MvCCcuYGMhKkxVZsD9fehGp8efSq7+TcmzsT8w
	 CNDC53/NZ/72ds4STeUzihjFUQrTgxoOw6MWNPYBUB5glBVwAo4vlkoL6B9J+9zZDsKs+
	 0bFBrJCn2ZcEbe/Ga9uBhcaLzMVvSUvjJIozE19SP+0EJJfQydP6JCwCFb4xGqXYXVMIx
	 OKYDbt8gBdiFM2TwfURRO+uwxiJG4WRPxiNLfa4EpLQe3EvgDcYQVuHx2oPLLa0nLjH/T
	 4xYr6WiJfJOyhG0ju+GHguwt3bbNmx060rWsh/YRBe6Rvq/xgzyQyzQNpnIeHv59v1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=GLOpy8er;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30609606A32C
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30609606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=GLOpy8er
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a204f135ffso612325e9.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937473; x=1795542273; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q6t84Pka6sjdVDTSiJiZNZc5e4fjMt3grSTxqNeIf7Y=;
        b=GLOpy8erYX5NqCA8SGzSvb9izmEp8D/PUR/LwxVRaHVoS5AMan+zNv0vT4mgnPjDZG
         mS6vY2njDyh1+mE5qSdPWlZJMvB15Oa6jsIa3Bvi9XgWd6+2C2RLq8R5e2br8d3mD1pK
         01Mb+AFRNs1/na1kSHG5J0e8TOCPpk5F5vjaeJoGRrV7gQKxrzxHhjYTWAOthYx8DVTx
         gWBcWRbwIdqaMwgjziDQo3lT1AfdSG4SquaHSA5C4CKLQ1VnCvzHNBVixcMCM08+liB3
         PnaXaVnwAsEpvT3r5I34puM5ENDi/2VrOK5SMVBmOCLWEA9Ery//64BsfLsaUBsGoFwo
         HiZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937473; x=1795542273;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q6t84Pka6sjdVDTSiJiZNZc5e4fjMt3grSTxqNeIf7Y=;
        b=ra59+hIkq8rUG6gPpEXfie2Su+bzfnohb2DD89S7jPn7TdT0ibL06hfkoqHtnA8nbk
         U4lquLdgJkTHQrlhaH+eKlaj7mlGhbNv4WfRm4ZhleVBogvedUOC3ZOeZhW3Mr2O7d9m
         IPvGaFdpgLdpsEEl04GTGRHGTBcA+NEwx4/9xNtIQb7Y3q+4OTt1qcGU57t2Oa27OMJQ
         nlkNWoIuLbAwyn8Cu3N9Is8D5rvyD8Xm/js6OCbzWauuPStKTjcMB4CjznZrYlaHwibX
         Ob1stciPoFThEdqlhDrRSeX6Hwc1QIYoLyyM9NrgsCA/gQCHyFigsBFee2QJFbvh5v9I
         hfGQ==
X-Forwarded-Encrypted: i=1; AL+hErFbWU3hlVgIZPecJ8Lg7Z60KFQM7G4JUndKRdrTYjhFsY6qxLMamtpYDVt0HFbFkysqI6BlD/o=@lists.linux.dev
X-Gm-Message-State: APuU4Z9iVEpvFBRxtTscCZdotq5k/EMbLWsdpyihlDpknwtFxYagzK9D
	KpqAAa1cfrit9HK+Cz1oJAznagFgNPkYEYLo51DDzH2EYH1QHssVkEm/v70SOA5HhUqOy8LU67z
	ZWtlSmoPTkvkXruAUoNj6mg==
X-Received: from wmbid15.prod.google.com ([2002:a05:600c:a18f:b0:4a2:966:8982])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b4c:b0:4b7:6b96:e431 with SMTP id 5b1f17b1804b1-4bb55ab56ffmr317113965e9.28.1794937473114;
 Tue, 17 Nov 2026 09:44:33 -0800 (PST)
Date: Tue, 17 Nov 2026 17:43:54 +0000
In-Reply-To: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261117174403.58762-16-vdonnefort@google.com>
Subject: [PATCH v4 15/23] KVM: arm64: Add a range to pKVM ownership selftest
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
 arch/arm64/include/asm/kvm_hcall.h            |   2 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   9 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   4 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 214 ++++++++++--------
 arch/arm64/kvm/pkvm.c                         |  37 +--
 5 files changed, 148 insertions(+), 118 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hcall.h b/arch/arm64/include/asm/kvm_hcall.h
index 201d58907109..e54a4631a378 100644
--- a/arch/arm64/include/asm/kvm_hcall.h
+++ b/arch/arm64/include/asm/kvm_hcall.h
@@ -157,7 +157,7 @@ DECLARE_KVM_HOST_HCALL0(void, __vgic_v3_init_lrs)
 DECLARE_KVM_HOST_HCALL0(u64, __vgic_v3_get_gic_config)
 DECLARE_KVM_HOST_HCALL0(int, __pkvm_hyp_alloc_selftest)
 DECLARE_KVM_HOST_HCALL(int, __pkvm_ownership_selftest,
-	u64, pfn, u64, pgtable_pfn, unsigned long, pgtable_nr_pages)
+	u64, pfn, u64, nr_pages, u64, pgtable_pfn, unsigned long, pgtable_nr_pages)
 
 DECLARE_KVM_HOST_HCALL0(int, __pkvm_prot_finalize)
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 3fb55899be6b..a991be3d4c9a 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -76,9 +76,14 @@ static __always_inline void __load_host_stage2(void)
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
index 2621a4ef7e1e..c322ef4432c9 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -1314,9 +1314,9 @@ DEFINE_KVM_HOST_HCALL(ulong, __pkvm_create_private_mapping,
 }
 
 DEFINE_KVM_HOST_HCALL(int, __pkvm_ownership_selftest,
-	u64, pfn, u64, pgtable_pfn, unsigned long, pgtable_nr_pages)
+	u64, pfn, u64, nr_pages, u64, pgtable_pfn, unsigned long, pgtable_nr_pages)
 {
-	return __pkvm_ownership_selftest(pfn, pgtable_pfn, pgtable_nr_pages);
+	return __pkvm_ownership_selftest(pfn, nr_pages, pgtable_pfn, pgtable_nr_pages);
 }
 
 DEFINE_KVM_HOST_HCALL0(int, __pkvm_prot_finalize)
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index b9b591533b30..751f76d3ec39 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1787,14 +1787,19 @@ static u64 selftest_ipa(void)
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
 
@@ -1818,7 +1823,8 @@ static void assert_page_state(void)
 		assert_page_state();			\
 	} while (0)
 
-int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr_pages)
+int __pkvm_ownership_selftest(u64 pfn, u64 nr_pages, u64 pgtable_pfn,
+			      unsigned long pgtable_nr_pages)
 {
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_RWX;
 	struct pkvm_hyp_vcpu *vcpu;
@@ -1831,7 +1837,7 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 	if (ret)
 		return ret;
 
-	ret = __pkvm_host_donate_hyp(pfn, 1);
+	ret = __pkvm_host_donate_hyp(pfn, nr_pages);
 	if (ret) {
 		WARN_ON(__pkvm_hyp_donate_host(pgtable_pfn, pgtable_nr_pages));
 		return ret;
@@ -1841,10 +1847,11 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
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
@@ -1853,48 +1860,48 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
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
@@ -1902,116 +1909,125 @@ int __pkvm_ownership_selftest(u64 pfn, u64 pgtable_pfn, unsigned long pgtable_nr
 
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
index 4c80e0960154..ae53c701206a 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -333,31 +333,40 @@ static int __init pkvm_drop_host_privileges(void)
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
+		kvm_err("pKVM ownership selftest (order=%ld) failed (%d)\n", page_order, ret);
+
+	free_pages(page, page_order);
+}
+
 static void __init pkvm_ownership_selftest(void)
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
-		kvm_err("pKVM ownership selftest failed (%ld)\n", ret);
+	__pkvm_ownership_selftest(0, pgtable, pgtable_order);
+	__pkvm_ownership_selftest(PMD_ORDER, pgtable, pgtable_order);
 
 	free_pages(pgtable, pgtable_order);
-	free_page(page);
 }
 
 static void __init pkvm_hyp_alloc_selftest(void)
-- 
2.56.1.708.g77570a6a1d-goog

