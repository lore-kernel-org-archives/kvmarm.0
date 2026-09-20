Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81C4485CEC
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933208; cv=none; b=Y1ez9GB3bvoth4zhlzkgRcBpNYBrxOLoKOzSZYEUCC8LOs0CE8Wmm5xWOg5HXL+aALFOgO1pdysWnGeZ+YoAGeIQJ7J/gdxiHJ8GvIoCxPTkpk/BWL8RlTlAzmfUgC4qhTFGHtYHvfwczWliNf2wHqNKdFYgbczS0YiTqsfmTrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933208; c=relaxed/simple;
	bh=8XX+vhh2r6nDjCyL0q7Hw9+dII/UGrET28Tgyv/hoY4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBo5EXkPKlNHIRTI31CiWvOiu6wxobHh0fYSkD/FH7QAQO332nAEajVAfh1i4ejQrTvbKkGCRMxjiUsLZRT+gZ+GYHzIuDb36G852Z+EjWUUl8BizsjKUCgGBiDaXkZcImIIsw9/IkUqx/KHWanX5XYVFqfeG2obczcW2BQIVdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=iRdSMDAb; arc=none smtp.client-ip=74.125.224.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="iRdSMDAb"
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-895eaf31683so18042247b3.0
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933205; x=1790538005; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+xCjTdloxc6nkdYmhJBIoS65cvexU8uxkyprCbgscSQ=;
        b=iRdSMDAbGj11BF24fDbVlXmyPVbZptF+1j3ubCZn/5D/lXxrQLpU6xLkunMhmUF23s
         Q2IFV0z3AGckpF0hrsPjHAqB0/krjkYOo5HfBchxUsG7t/2y/EA1KItG3YZ8uLpI1fVL
         u6hk2rzjCEenPwMB/q4Ad11dfZCp9An+eCGYC2H782c3xHIpkTXA5tOm5eQ8SqCW5Yre
         lP1qCyLAmltHzXGN/sk6XxVKKFHbx7MR2esJi3TzJoR+pl5ehAzUaAwrZps7qPGJSXAc
         J9FypKP0qKLu8dsz9Fkv50jGjzuehA55oKw+04PgfGN4gPafi0rOykEF7rrK7CQmQflU
         scPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933205; x=1790538005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+xCjTdloxc6nkdYmhJBIoS65cvexU8uxkyprCbgscSQ=;
        b=Pm1alZXwjDWanlXhSKr6/AC4Zl37SGT+LALpzqKGGQMA9ehhKoN4wdkoD3LAvOD5YI
         4GJ7zuw3MXbNxSJPV4zO02jyst3EU7iHvkjWo8XvxLrecxqJ2C/SFIVWAIAzcu7bPelc
         pI/PT/a0N82Qov7kDl4DEkB4wHCc4HCH0P/hy0KzRc9Hl6ROmw1KWoo0yvpOPmHd+2uU
         FdqWpxrRpGPh4Nq8obehehgyzGHdUe1ajN75YxaeS4OyP9IDwSeL8ioOJAE7GzmwD3Ak
         f4Jdq6fSAns7W/qDShh2NuoTK9zNVQLODdhIMvcssN/6Om5VnAhRGDBBQ+iu1OO587ea
         ZEPQ==
X-Forwarded-Encrypted: i=1; AKwUvBxKpk3jtBoTqZ6K9ivl0u+KgVq8speLMKe442nLqN4F8YI9dhoabqOU00zN0EerTmdOgJNGJtg=@lists.linux.dev
X-Gm-Message-State: AFuF++nLjORaWgjkui3/xyYI/0O8qNBMptFTjVZnqiy+AbguWXXnw/GP
	KUD0/ZHixs6D8S16TuavddiPXpu8ecNFxpnECX4RC25wty2i9gCW+0/TvH1JMp+CveY=
X-Gm-Gg: AYBFou0Dc50tOGTMVfVfTSQiDThKYBF2QlLgRixTg2ufZVkQREQtHxj1ylF5he5XHDb
	xgHSVC0EJQ0mfYeKc4ujlunxysNXBpLjbfFyRoYhuTMcYmhjU5enacz+zRfpsLBxKOJ7rr16E3T
	NPTsRzXNlYn88G10aF+nTXcXTX2GNdBhsa4QZMJg0O+0T3RStTwokVbEs8xwHk7tneG39VEkt1W
	rPY+a2WwZonjsbkmd42Rr2usAL3vypPGtq3MZDWNwvwFmSKu+jpFLnS67xLC4+UjinwN+5Rm+eF
	+SaJJL7u9yF5+4HaBvTwW83guMmwrSb2LGxuYZZ3A4ik0CwaELUwZ80ztrCkF/a+Y/PU+SH+Dbo
	gpET8kjnJjX0Curtze9OcML1S4udBtXFpAustV0T1Ug3MMElArOpP6P1haieO+FebWQy3wAHbh6
	hGt+ASrCO9Cjdj+u5iUVy8GNBGJ9Wdilpo1HCC562UqDjS5MbGn7vM/LSFyrzPr/GYs03HpaKLN
	l4RNNwCSxj4pHzfb/tIN5dhoKIKw5J94vOAdF9uwU14MI6ln7DyXGMZEPnNjA09TyA8MNUEF6XA
	mGXqjJHrCjySwRyeJgU=
X-Received: by 2002:a05:690c:d8b:b0:873:5c6b:a2ff with SMTP id 00721157ae682-89736f266a6mr23324237b3.45.1789933204717;
        Sun, 20 Sep 2026 12:40:04 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a45d8de3fsm18926787b3.8.2026.09.20.12.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:40:04 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 32/46] KVM: x86: Add TDP MMU KHO preservation helpers
Date: Sun, 20 Sep 2026 15:36:36 -0400
Message-ID: <20260920193650.3373435-33-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add arch/x86/kvm/mmu/kho.c to preserve and adopt TDP MMU EPT/NPT
root page tables across Kexec Handover (KHO) live updates.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kvm/mmu.h     |   7 ++
 arch/x86/kvm/mmu/kho.c | 193 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 200 insertions(+)
 create mode 100644 arch/x86/kvm/mmu/kho.c

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 2ae7f9ed4cf8..f35948f0906c 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -410,4 +410,11 @@ static inline bool kvm_is_gfn_alias(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn & kvm_gfn_direct_bits(kvm);
 }
+
+/*
+ * Declared here rather than in asm/kvm_host.h: it is internal to
+ * arch/x86/kvm and has no callers outside it.  Defined in mmu/kho.c.
+ */
+int kvm_mmu_preserve_kho(struct kvm *kvm);
+
 #endif
diff --git a/arch/x86/kvm/mmu/kho.c b/arch/x86/kvm/mmu/kho.c
new file mode 100644
index 000000000000..a04600f0c3e0
--- /dev/null
+++ b/arch/x86/kvm/mmu/kho.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * KHO preservation of the x86 KVM MMU page tables.
+ *
+ * An orphaned vCPU keeps running its guest out of the shadow/TDP page tables
+ * while the VM is detached, so every page those tables are built from has to
+ * survive the kexec.
+ */
+
+#include <linux/kexec_handover.h>
+#include <linux/kvm_host.h>
+
+#include "mmu.h"
+#include "mmu_internal.h"
+#include "spte.h"
+#include "tdp_iter.h"
+#include "tdp_mmu.h"
+
+/*
+ * Page-pointer accumulator.
+ *
+ * kho_preserve_pages() cannot be called while holding kvm->mmu_lock: it is a
+ * rwlock_t, so the section is atomic, whereas kho_radix_add_key() below it
+ * calls might_sleep(), takes a mutex and allocates with GFP_KERNEL.  So the
+ * walk runs in two phases -- collect the pages under the lock, preserve them
+ * after dropping it.
+ *
+ * A NULL @pages simply counts, which is how the caller sizes the array.
+ */
+struct kvm_mmu_kho_pages {
+	struct page **pages;
+	unsigned long nr;
+	unsigned long capacity;
+	bool overflow;
+};
+
+static void kvm_mmu_kho_add(struct kvm_mmu_kho_pages *acc, struct page *page)
+{
+	if (!acc->pages) {
+		acc->nr++;
+		return;
+	}
+
+	if (acc->nr >= acc->capacity) {
+		acc->overflow = true;
+		return;
+	}
+
+	acc->pages[acc->nr++] = page;
+}
+
+static void kvm_tdp_mmu_collect(struct kvm *kvm,
+				struct kvm_mmu_kho_pages *acc)
+{
+	gfn_t end = kvm_mmu_max_gfn() + 1;
+	struct kvm_mmu_page *root;
+	struct tdp_iter iter;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(root, &kvm->arch.tdp_mmu_roots, link) {
+		if (root->spt)
+			kvm_mmu_kho_add(acc, virt_to_page(root->spt));
+
+		for_each_tdp_pte(iter, kvm, root, 0, end) {
+			struct page *page;
+
+			if (!is_shadow_present_pte(iter.old_spte) ||
+			    is_last_spte(iter.old_spte, iter.level))
+				continue;
+
+			page = pfn_to_page(spte_to_pfn(iter.old_spte));
+			kvm_mmu_kho_add(acc, page);
+		}
+	}
+	rcu_read_unlock();
+}
+
+/*
+ * The per-vCPU root page tables are not linked into active_mmu_pages, so they
+ * have to be walked separately.  pae_root, pml4_root and pml5_root are each
+ * NULL unless the corresponding paging mode is in use.
+ */
+static void kvm_mmu_collect_roots(struct kvm_mmu *mmu,
+				  struct kvm_mmu_kho_pages *acc)
+{
+	void *const roots[] = { mmu->pae_root, mmu->pml4_root, mmu->pml5_root };
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(roots); i++) {
+		if (roots[i])
+			kvm_mmu_kho_add(acc, virt_to_page(roots[i]));
+	}
+}
+
+/* Collect every page backing this VM's MMU.  Must be called under mmu_lock. */
+static void kvm_mmu_collect_all(struct kvm *kvm,
+				struct kvm_mmu_kho_pages *acc)
+{
+	struct kvm_mmu_page *sp;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	acc->nr = 0;
+	acc->overflow = false;
+
+	if (tdp_mmu_enabled)
+		kvm_tdp_mmu_collect(kvm, acc);
+
+	list_for_each_entry(sp, &kvm->arch.active_mmu_pages, link) {
+		if (sp->spt)
+			kvm_mmu_kho_add(acc, virt_to_page(sp->spt));
+	}
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu->arch.mmu)
+			kvm_mmu_collect_roots(vcpu->arch.mmu, acc);
+		kvm_mmu_collect_roots(&vcpu->arch.guest_mmu, acc);
+	}
+}
+
+int kvm_mmu_preserve_kho(struct kvm *kvm)
+{
+	struct kvm_mmu_kho_pages acc = {};
+	struct kvm_kho_folios_ser *kp;
+	unsigned long i;
+	int ret = 0;
+	int attempt;
+
+	/*
+	 * Size the array, then fill it.  The guest can fault in new page
+	 * tables between the two passes, so re-check for overflow and retry
+	 * with a larger array; the slack makes repeated growth unlikely.
+	 */
+	for (attempt = 0; attempt < 5; attempt++) {
+		write_lock(&kvm->mmu_lock);
+		kvm_mmu_collect_all(kvm, &acc);
+		write_unlock(&kvm->mmu_lock);
+
+		if (acc.pages && !acc.overflow)
+			break;
+
+		acc.capacity = acc.nr + (acc.nr >> 2) + 16;
+		kvfree(acc.pages);
+		acc.pages = kvmalloc_array(acc.capacity, sizeof(*acc.pages),
+					   GFP_KERNEL);
+		if (!acc.pages)
+			return -ENOMEM;
+	}
+
+	if (acc.overflow) {
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	if (!acc.nr)
+		goto out;
+
+	kp = kvm_kho_folios_alloc(acc.nr);
+	if (IS_ERR(kp)) {
+		ret = PTR_ERR(kp);
+		goto out;
+	}
+
+	for (i = 0; i < acc.nr; i++) {
+		ret = kho_preserve_folio(page_folio(acc.pages[i]));
+		if (ret) {
+			/*
+			 * Undo the partial preservation: leaving pages marked
+			 * would pin them in the incoming kernel forever with
+			 * nothing owning them.
+			 */
+			while (i--)
+				kho_unpreserve_folio(page_folio(acc.pages[i]));
+			kho_unpreserve_free(kp);
+			goto out;
+		}
+		kp->folios_pa[i] = page_to_phys(acc.pages[i]);
+	}
+
+	kp->nr_folios = acc.nr;
+	kvm->kho_folios = kp;
+
+out:
+	kvfree(acc.pages);
+	return ret;
+}
-- 
2.55.0.1082.g2b9226bbc0-goog

