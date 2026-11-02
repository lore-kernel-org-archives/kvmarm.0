Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793654355;
	b=vP5LosRw9i6cQiqUGYWmzX/iQs9msiSchiWmmP08/3tS26XVCwHkkVofGRtc5PhWoFaY
	 2vmKaKkQtntBGAoTC9P1y8pJq77Pjck0G+y9P632kTBoMEQuZDzyUMRzJXvvcmkHDwhqu
	 B9AVl+VsDn5ww0FduUDIHboQHLSLuWN3rcw0n9vReowHHuZ3QGRu/WCQv0tPh5ZI5mEBd
	 GR3TDGVzd51OIXfyQe3JLmk4595mps+BTe9pV2rr18MvRI7iPK7FhSU58HcgaCHGbOrU/
	 LFZ3JxmqI7UHEMqJ3KZXidSdn7OUJLyixZZ5JTMHPbwjm3AqWzM7vyi4rUzu5P9EAkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793654355;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=9tpbLF7GvKR1dLCFLZZGmAAGLb/lQXCuuwOBoPq3W7Q=;
	b=zQctjOTNzAH5DomBtpaw9748xVIdoF97Bm4vUamewdknG3+sa19r5n2wIGpyF7tRrmcT
	 TmKAyQ8TggcPh0+F7ERmo51DK8fVIw4vXnWf9mUFWKncAT0MEbV+zTe6ReCb22zNyULq7
	 t7Th/COgQIWG0xMxGGUtHV7H5NxRmUzgbElYt3F81r9/cyAxh08GxkdxYr9wDOaSTrOEG
	 mXweVD+EFkMv10x4rEtkERGwMh5NDBsyqsXr81SMubhWQpt5djCmW2T3vG4L4ntoAih2X
	 54pCujlgqu5avmF0lZfx8S2MbHkqyL+eIYoYdd/F1wc5FVCsvcYb5sN7zB/PNuaqrFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cBTW0+OQ;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBC6606A32F
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:19:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EBBC6606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cBTW0+OQ
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4afef353dd2so17848865e9.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 13:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793654353; x=1794259153; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9tpbLF7GvKR1dLCFLZZGmAAGLb/lQXCuuwOBoPq3W7Q=;
        b=cBTW0+OQJfa1Ee9rEoFqABgORT7kSS1hg5ULZiOm6YnUMcvNYn+yqK2vPqz1dRFMni
         7RrIXMkvroREJh4rt5QghSNc4henLHa16n1ymNK4bviyNjasy5JcTyhcdT949GbcPfHY
         s1uwjqlUHU8v5ftbWQQESe+LVzZPq+mnxVa9eD0idlg7WffjATAn9rsCoJJmIdZ4HrCJ
         Hkd4yev4mLsrNVKvXSa0OVgL6RfAkBma7zPa2reTL453G/Z6j4FHFEprswl2NK6wgq5W
         ohAnbZBh5FE537PVbreEG4nJiuwbymi+7GEiNLA/HXtzgmyIWRXW3oicAsV7QSaFjJr7
         fIng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793654353; x=1794259153;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9tpbLF7GvKR1dLCFLZZGmAAGLb/lQXCuuwOBoPq3W7Q=;
        b=BTpyA+Wz4wV4y7X7fi0n2KRUUxzSHMwzpqhetlshD95KQ+bXsGUxyYvUqFZXjMf4fe
         PMAeZVV/MJ5vINc/R/qEv+rx9qMGOVchBUwdwdFd250JFeKk7qfW0K2TRus6W5eSJvGj
         WmZoYLmkTOZzN5qfrEtEms7CZ4/kkzJB3GqFiaKppQ5Dbf66yAfeN3asNLUR5HMDxa7I
         9+ZHeFgw2kxmAu1n72WqMKdN/WaqbfzHmqihYN3Yp7SkZ/EFzREZ2qAYWzfdNN1lgsaC
         CXDXNTixBfMSGYsWEWHBkDPk50QMT6Hbw8D8b8CMfbWurlxM87spUdWxyeNfH9VUP0gu
         mWKw==
X-Forwarded-Encrypted: i=1; AKwUvBwFDrU7od9+Z+snNaBqPBT1ZJOzFtR16VKHA2k9hyng+IjnJB13PNjIiPyC4qV25SsJyKIonRo=@lists.linux.dev
X-Gm-Message-State: AFq9FYJivQRaLHvsOJ0m4Yqjtrp4T1gHQ3kWCP9qjmFm4joJCSLhFDmI
	/8/UcyS2YWdssfeswJgESgdiLUYgGIzzJEQij2jxTDg4jGPTNd8IgWr7N1E8N+MiVyf9NXR1CX5
	rIoXyoYPsddS1cv5zIkh6zQ==
X-Received: from wmcn23.prod.google.com ([2002:a05:600c:c0d7:b0:4a1:dfb3:2e66])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b66:b0:4a3:5a91:5f61 with SMTP id 5b1f17b1804b1-4ac1793f8ddmr270441685e9.14.1793654353111;
 Mon, 02 Nov 2026 13:19:13 -0800 (PST)
Date: Mon,  2 Nov 2026 21:19:00 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261102211900.504192-1-vdonnefort@google.com>
Subject: [PATCH v1] KVM: arm64: Fast path transparent_hugepage_adjust() for
 non-PMD folios
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, ljs@kernel.org, 
	ryan.roberts@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

transparent_hugepage_adjust() must walk the userspace stage-1 to detect
if a PMD-level mapping is installed. If it is, then a stage-2 block
mapping can be installed. Even though this stage-1 walk is most likely
cache hot (in most cases, the mapping has just been installed), walking
a page-table is still costly. This walks accounts for ~5% of the
user_mem_abort() execution time on an Apple M2 big core. This makes a
fast path interesting.

While we can't be sure by solely looking at the folio if the stage-1 is
a block mapping as userspace has multiple ways to split it, we however
can infer from its size if the stage-1 mapping is __smaller__ than
PMD_SIZE. Anonymous memory or memfd faults will always allocate a folio
big enough for the mapping. The same applies when collapsing into a
block mapping with khugepaged or MADV_COLLAPSE.

Add a fast path based on the folio size. Whenever it is too small for a
PMD_SIZE mapping, bail out early and do not walk the stage-1. This is
interesting for systems where PMD_SIZE THPs are disabled either at
build, or at runtime. Systems under heavy memory pressure will also
benefit from the fast path.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
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
2.56.0.385.gac671c819a-goog

