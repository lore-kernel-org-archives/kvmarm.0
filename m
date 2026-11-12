Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794483467;
	b=wxQQnOaSUuorRAFVUCUlJr4Qt5i/m3ct63i4CVz7i+tOF39oDuk44nIv2f4hixxanYaL
	 gRAuMh1EsGjt3T316Rhfe8cS9pcTZ4rTQEhmGHIVhB/Wj/WkeE/qpnABFjDuzSr9s0bhd
	 yAwxeAWMyMGn1AXyFjvHnKlhobu9C6yMorv21/IfTMX7hOhmbt+rU/WRVpa06bkrNPmN4
	 S7rvYb6e4zgzUGjovhrGNnA+Bo8h0z8qAaEvYrw+/No57IzeiTvIzch1Mb/dZpx1jq8NL
	 OpMvJC0oeiLSe2oDWNVoh7O4qHaSDnKQAOEYA3cKq3Q4KKJ/1uCW7UF/8ZYMlbnztRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794483467;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=Hj1fn4YijWukXcrgsrpSbQ0BagEFJZMcHse/ByJWp3c=;
	b=w6ChCjE1Fr02HYnrVhkQ/iPjWZ+cZ5MAahGOPi2dThVnHf4a897k4FZbr3tVfQyELz7x
	 bagCcCXU5rfKhyZjGfoWom4DKx2GFpSzt5PiY7eN9iHN7gvstqbCYkQfFYSpLawSJ9191
	 C/wF+HmS/czyKKFMc+rMHD2QrDS4YpiwDA9VG3B6nvy07cgUvAM3nLS+bNBMmK7WofHTQ
	 qZbldy5soxs7ognNNpifTy687kP3lCyDLovFthn7lbr7i56oEj5qSuMEGFWOQs/E8r0eM
	 bULkpidIlr6SHUElonn2Xx/JoeI+xmWKK5X4+TyeeIRbHO7l2y0ILXmR+QJw8W35qNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=D1nyltr6;
	arc=none smtp.remote-ip=209.85.221.69
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4EB606A323
	for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 11:37:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C4EB606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=D1nyltr6
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4901562b819so3708357f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 03:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794483465; x=1795088265; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hj1fn4YijWukXcrgsrpSbQ0BagEFJZMcHse/ByJWp3c=;
        b=D1nyltr6sVdOmZWnSdEg1n9HGUZ8ofvAX5yf/4nR0XjHUTycxgFpLFMgHe/K/g/+vG
         lvsbYz2JSSgAAs571WSOF6yoMBpguQzxylnxW2Oy1oipFnhDpsoWx77A/QOmbwFbS6P0
         9RrXgiQKP9p14Tu60jYzq9q+UPodhWH2bNesKZ36NsxoQsV3t4hbUAzZIdBWcCgcW3qK
         5ouEaiV4XhVLj+UIjLbrZC6gm7ioLuocrdi0foWvz8i4YtlphSewVi+foRCh8ofWshWi
         lKfhkhYFbrnASL34p3FhkHMLqhqyAYb+RPGgW4l2TnewgbTc48RcSmdtxCcmLUVXVUTc
         FU7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794483465; x=1795088265;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hj1fn4YijWukXcrgsrpSbQ0BagEFJZMcHse/ByJWp3c=;
        b=O1ruZI8URH8D7QzWeg2+am3rv79IdKlaHboY4/ssAJkY4uGGZK+VoUzVGYtyVHYiPg
         2PHhFBC0fIziREg/Lv5DkLXk8HFwh0y7/t4YPc3GSwf8ViYNUJuKUMbD5XFaNuSbj23t
         Vhz84u6G8TvcMcGGRxgXqIxa0QuqssYAmE5ppmP2o4mbIqwd1ufrH8IRaOXdYu0t36qd
         HXHRUK/ZKMdnQxCbvqYfny6JYYt6mFkXIyG1s9su4bP28E1tljZLEpUfJ9UHDONraGZx
         VHhWAtmCVK8MUKrHGnSpr7t3ncHhJwO2K3LsXOOmyJMPO5OGQJuWpwiHIyVZCjrX2AOv
         S+Xg==
X-Forwarded-Encrypted: i=1; AL+hErGNb8cLh8muOfSknikK3JgnQihEzpSKTlBDG6S8tqVaGA41rR8EURGa4CfQxbq+6Lmes4w5iKM=@lists.linux.dev
X-Gm-Message-State: APuU4Z8juT1q7joFWUATQ5JvvdlxB9yugxg3KQ76OcCd8bmkD8+4IsAJ
	fUXUNV/lz4nWffMHEKKYx/XE4erq0DttHr+ZN1C3CJLB28BrqOSDnFXMEYVjoaj5NhYJqIaR5mC
	7GQnN5gR/bpqYsUZGW7Hnzw==
X-Received: from wrwc2.prod.google.com ([2002:a5d:63c2:0:b0:48e:a11:b240])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6095:b0:4a2:10f9:37ce with SMTP id 5b1f17b1804b1-4ba09381439mr100508465e9.15.1794483464714;
 Thu, 12 Nov 2026 03:37:44 -0800 (PST)
Date: Thu, 12 Nov 2026 11:37:29 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.567.gdb80ae8cd5-goog
Message-ID: <20261112113729.2858513-1-vdonnefort@google.com>
Subject: [PATCH v2] KVM: arm64: Fast fail transparent_hugepage_adjust() for
 non-PMD folios
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

transparent_hugepage_adjust() must walk the userspace stage-1 to detect
if a PMD-level mapping is installed and whether a stage-2 block mapping
can be used. Even though this stage-1 walk is most likely cache hot
(in most cases, the mapping has just been installed), walking a
page-table is still costly.

While we can't be sure by solely looking at the folio if the stage-1 is
a block mapping as userspace has multiple ways to split it, we can infer
from its size if the stage-1 mapping is smaller than PMD_SIZE. Anonymous
memory or memfd faults allocate a big enough folio, as do khugepaged or
MADV_COLLAPSE.

Add a fast fail based on the folio size: whenever a struct page is
present and its folio is not PMD-mappable, bail out early and do not
walk stage-1. This helps when THPs are disabled or under memory
pressure, while adding a folio check on the PMD-hit path.

To measure this walk on 100% PMD misses, function_graph traced
user_mem_abort() and get_user_mapping_size() with THP disabled while a
guest faulted PAGE_SIZE anonymous pages:

  Platform            Setup                get_user_mapping_size()
  ------------------  -------------------  -----------------------
  Apple M2 (big CPU)  nested L1->L2, perf  mean  5.25%, med  2.70%
  Ampere Altra        non-NV, VHE          mean 13.69%, med 12.28%

On non-NV VHE Ampere Altra, get_user_mapping_size() takes 0.26 us mean
(0.24 us median) out of 2.32 us in user_mem_abort(). On nested L1->L2
Apple M2, longer L1 user_mem_abort() handling shrinks the relative
share.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---

Notes:
    v2:
      - Reword commit message as a fast fail, describe the function_graph
        setup, and include both nested Apple M2 and non-NV Ampere Altra
        numbers (Marc)
    
    v1: https://lore.kernel.org/all/20261102211900.504192-1-vdonnefort@google.com/

 arch/arm64/kvm/mmu.c | 42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1db10d8d6db7..9d81d908e230 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1553,36 +1553,42 @@ static bool fault_supports_stage2_huge_mapping(const struct kvm_s2_fault_desc *s
  * Returns the size of the mapping.
  */
 static long
-transparent_hugepage_adjust(const struct kvm_s2_fault_desc *s2fd, kvm_pfn_t *pfnp, gfn_t *gfnp)
+transparent_hugepage_adjust(const struct kvm_s2_fault_desc *s2fd,
+			    const struct kvm_s2_fault_vma_info *s2vi, kvm_pfn_t *pfnp, gfn_t *gfnp)
 {
 	struct kvm *kvm = s2fd->vcpu->kvm;
-	kvm_pfn_t pfn = *pfnp;
-	gfn_t gfn = *gfnp;
+	int sz;
 
 	/*
 	 * Make sure the adjustment is done only for THP pages. Also make
 	 * sure that the HVA and IPA are sufficiently aligned and that the
 	 * block map is contained within the memslot.
 	 */
-	if (fault_supports_stage2_huge_mapping(s2fd, PMD_SIZE)) {
-		int sz = get_user_mapping_size(kvm, s2fd->hva);
+	if (!fault_supports_stage2_huge_mapping(s2fd, PMD_SIZE))
+		return PAGE_SIZE;
 
-		if (sz < 0)
-			return sz;
+	/*
+	 * If the allocated folio isn't at least PMD_SIZE, there is no way a
+	 * stage-1 PMD level was installed.
+	 */
+	if (s2vi->page && !folio_test_pmd_mappable(page_folio(s2vi->page)))
+		return PAGE_SIZE;
 
-		if (sz < PMD_SIZE)
-			return PAGE_SIZE;
+	/*
+	 * Even though the folio size is big enough, the stage-1 mapping might
+	 * have been split. Verify it.
+	 */
+	sz = get_user_mapping_size(kvm, s2fd->hva);
+	if (sz < 0)
+		return sz;
 
-		gfn &= ~(PTRS_PER_PMD - 1);
-		*gfnp = gfn;
-		pfn &= ~(PTRS_PER_PMD - 1);
-		*pfnp = pfn;
+	if (sz < PMD_SIZE)
+		return PAGE_SIZE;
 
-		return PMD_SIZE;
-	}
+	*gfnp &= ~(PTRS_PER_PMD - 1);
+	*pfnp &= ~(PTRS_PER_PMD - 1);
 
-	/* Use page mapping if we cannot use block mapping. */
-	return PAGE_SIZE;
+	return PMD_SIZE;
 }
 
 static int get_vma_page_shift(struct vm_area_struct *vma)
@@ -2186,7 +2192,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 		if (perm_fault_granule > PAGE_SIZE) {
 			mapping_size = perm_fault_granule;
 		} else {
-			mapping_size = transparent_hugepage_adjust(s2fd, &pfn, &gfn);
+			mapping_size = transparent_hugepage_adjust(s2fd, s2vi, &pfn, &gfn);
 			if (mapping_size < 0) {
 				ret = mapping_size;
 				goto out_unlock;

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.0.567.gdb80ae8cd5-goog

