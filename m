Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652440;
	b=pH4Zx1begxCMuAi9HEJNtYJaMYTnNLGwHak6YHNVPqH9MwrZQeJVirLybjfxCSzDLQd/
	 lKL649YLjz7+V7b8MR5n8tRn2cMWC9Rc17FYSOVNX023Zh6ehQEEJWM7qxjHCd+w2eY12
	 EahjfuLWVJdy7zuOL6EQonPoQE0y3EWuVyZ2YFIXTHlHEBO1552GqkFAebesFYQRhaYXO
	 32SQOrKxYm9xSwV+nCv+l3IC1gDBq4Dn170j98AB40jl0VUtzDPG9wqzpQ4UthxKeAhWb
	 G7q1epuhomx+DkKbJX5utrn72hlaQSlI/AkDZqCBuZJ4g+fnAZpgH+mBzIcPqWjuHJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652440;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=DFKfYvpudmZ0Kylu+HLBtCK3RdHVQLNBhCCTs8AyHF0=;
	b=w/i44kPdfwJhTdgUpvlqmaeS0E1BA1XPNQn+6kw//RQnqnbj2jPNFbU9NTQgv4YYbO5w
	 +wDhB7da8dnvC0zeS61D7ysI4CsMBKJaV+GtQMCAWY6VdcMsTq2Lqm8BY+TzARKbK9VNR
	 +uyNP/xdL+ARrQM4ExMmylk+XJiviBVfPERR+pXjMPWW0fL57qw7xsxVvLns1+9AYnDol
	 B+dYC45dVIpPKWcR4lU5mSCH9xi++6sgSdLf6/XLqET2oUXJhgS46UQbn5O8mS3J31949
	 dFxx1Z+24CurAUzTv45pFlH7fLFXkbSsudctesPC9UBDQ+ThZDV3bwv+Gz3j3Jc1V5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NHXaIQky;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6985F606A329
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6985F606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=NHXaIQky
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a16dc2323cso29286955e9.3
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652438; x=1794257238; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DFKfYvpudmZ0Kylu+HLBtCK3RdHVQLNBhCCTs8AyHF0=;
        b=NHXaIQkyLfaWCJl/+7aPtuhK1FLOUBKDoZIEpbj/S64yYkUCacTDlm1o2bMATV4gsK
         6hBdh55ConVBEGclv8cad6nh0AQksJ8Ea7x6ziL8wwnsM2K+lUZE9DRAspAOZYnnr2Pv
         kpkpdes6ENLcKxfrHQskK/+P225mvHRTL4eoAntNleJ40f0K+J+PABA8RZy8H88PFaVv
         Su9awnscRd3tRon3w+9tYLi9WSGPi/1+JmT1mQ1kdmxB/VLHiJGcaIyEMpAk3ndC+EfW
         VwusORJO4A6rggvi/4q/i4tKR1bJhSNPDLfrkVz08dCgn00qXmGx6XTzxKvVBKFuKv+6
         WSAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652438; x=1794257238;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DFKfYvpudmZ0Kylu+HLBtCK3RdHVQLNBhCCTs8AyHF0=;
        b=GY1Z/7gJ07xnBNWv7f4KUsGXTe+rpA61U+yvJxyyeYhz0YL+LEDDs+9iBIDCA/xooi
         zmI2fx/fKYW7vk1FVxsDWeQp+PpKQSO0ydAwwv1f7zPmoDMs3vUfo4X+envnDVIVst57
         mXxRF7lWD/hj8oDkPeP1E5tIdXAlBFxUf0pAOd1UQeFe/YkcRE8T1ZlhfUe+MBIJaPo/
         GBwJ1z5XSKK7M5O8Wy4glfmZSHKceUmZSrJP9sCMN1CMqTpiiWKMVJ6JJhmUorcecAHl
         mxM/eC/R63AKQ/BTgJy3nLs3tPlAuMKWCSrNdIsDYBdflGuQSWa4psYVjAAwB0wBMRK2
         Q4Rw==
X-Forwarded-Encrypted: i=1; AKwUvBymX4oDo0sHQHe88g9AipB3Gn4LVY2fHXlwjTxQHhVxbmwUUMPeBsrVZo+Ir06FbgExb3u2OQw=@lists.linux.dev
X-Gm-Message-State: AFq9FYLen9/i/EyEkRDQD/QSFhD2sYgc8DVyUg3MIVk9yDnqMif5Ld3B
	tK4qDHKhoxLWML7SgSfJmAzAZb+ot7LQiekFwdtLKFZuj1V+OEGVmDofnItvQ7vy9SLqOABG0zp
	4VTb9+t/DCqnk0Wgt6f/TXQ==
X-Received: from wmpf27.prod.google.com ([2002:a05:600c:491b:b0:4a2:c25:d91a])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1990:b0:4a7:462c:6b9e with SMTP id 5b1f17b1804b1-4ac1923581cmr245331475e9.32.1793652437751;
 Mon, 02 Nov 2026 12:47:17 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:20 +0000
In-Reply-To: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261102204628.401871-16-vdonnefort@google.com>
Subject: [PATCH v3 15/23] KVM: arm64: Add a range to pKVM ownership selftest
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
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
2.56.0.385.gac671c819a-goog

