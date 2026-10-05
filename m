Received: from mail-ej2-f41.google.com (mail-ej2-f41.google.com [74.125.228.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CC846C846
	for <kvmarm@lists.linux.dev>; Mon,  5 Oct 2026 09:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194161; cv=none; b=YzhPYKkG9SWYmU1oIXUzLpws/cQl14MBkdCO+AjyKHJZakSWdl+XqwTU7Yowx0No81lJqURJA9OdiNMYelZT9KJ5xApvg419tXXdOQDZGR7YCjGYVDr3x2WtDzwe5tBkNS1ZCPlM1IRFxAeUNk7wpxKxwp09wKRljI/7CR3OGAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194161; c=relaxed/simple;
	bh=6KY4nI5lJymazc3lPp+KJ9NF7mEjLKj0vhtpjRR83Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fD1FBOgsA3JuHYer+josldQzA4ZfVB9Pe/7vFdXaaALEoXAq0OSROwX0FVUcrKX9IT9XiNDvJJBSQt07nrMDCwJOqsPpbHqOzjBbTCV3Thvu0jqiLnmWMQag3rSp7709BaTofTGiYZFX7mRbJRm0dD05r5M1qsV3BbAjhV4DgU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bXuVm3iY; arc=none smtp.client-ip=74.125.228.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bXuVm3iY"
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c2e3f641442so263064866b.0
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 02:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791194155; x=1791798955; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hBckql0s/2nEbii/g+PLtX2a0BnDe1iX6ffCpfRgr1I=;
        b=bXuVm3iYRGSZ3Xnavyg86sIMbKI4eP0VolkLon7L7w9jvSPgNOXxhkCQ5Ao5Tmm/GB
         lgfLmP4loRmjwgxtptmbIu8yiVXXFF8EogzOSsdSRlW3JPOkRRZFlnx4OxjFqY9tVa54
         nIcYpnDlJdG14FQ6yJx9XqzTw7ZvvDPV6XZ3cbTHX6ys2GL8wLLbLXkObIH4pSmk3PCU
         5AAhrC1blSpv7AJUKYu1gbjMgtc1+FwbjSPE+6F6a6Lq0mFF1IzseXHLJPEZVwRgJOFf
         skcSCkknFLzs5CJGhnH9OP2qIRecXAAqEVRxMaYtMMXuoq4HDWIKR7YvmzVowuoO94v/
         AM1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791194155; x=1791798955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hBckql0s/2nEbii/g+PLtX2a0BnDe1iX6ffCpfRgr1I=;
        b=KvkTbPSYZpT006oZlTTpEtCPme9ubGutYXnGH0XYDz+semCYVLYjDSBmHzi1DRaVHG
         AbGCu8TrK0WiFnUbUGQ18RUeCZMisavZ60RzOK+ineUMReK9xZtyjrtY6IuVpnrukMUx
         y6Ntiv/VL9HC2PMV4cWpCdXBw2ziEkQJbNi/MQWBVWHPDdClxxwxgwrB0OnYCEWC57BU
         oMJjrFwNBssalm+YVdGVPqljfZUZx80fioF6RcXuOwqBeGSv2v0B/Xe/+smX7VmiUXfR
         lRINMeitEk8cX97YjO1MkBq4R74O6QfUAykw0/5xiRrnU7LXDQAcr0oMgmWR/2qn4Jk+
         6ydQ==
X-Forwarded-Encrypted: i=1; AKwUvBww4KtTrLzvkbzJHR1RxkzGQOw4SdpBhsml87LKNLiSXOqYiUK2sPK6GJuq8jNwmdZKMxp8YIE=@lists.linux.dev
X-Gm-Message-State: AFuF++n5/KSUJcNuOgIZLEfKhJhuGUp6sWuG15XPf9nMH7Ro3vSU+QQd
	Ucao95zZwHQxdEFk8Pn8f+eoo1+CwZdyZF3lOP3DiHQGn2XgbSXy9q2H
X-Gm-Gg: AYBFou1BYjCeHJXRKwG9fzlIUL5CG2nwb3bt/Th1dcMSy3wF5D4lOTbl3O9nA6YbZLB
	4UIEgk3y6qr0Ffnz7Kl1IJhpTZaRF9lUw3lII4z3vftLahyVsCTw7wcdV1YvPlGJzP2Z1E67IJP
	6VF5Z4tWss6Er10ttOkCCCzjVeyO6/JmVqJRwMvaMYyvXtW880r2D+i1dB/dAskAU8p096i2A7A
	EdR4L6vHUy3bgNzJ++5rdL3dtL+C9wFDULrJ/pHuec6BoNOAD/2Q1Cl95tXRjo7OWGGFNBB3lip
	q9A61Snosl1XDLm1wwPn0MSPjFfK0BIsotnnoNp7n+UHk0A5IWljLO47oESVUMxOjV1cT6PndoM
	UMv8/NftUrNyYZCnkjPe2/DnGAmEuy30WS+q6XWz/GJju0EkhhNW6n93oZ1MeCP6nHbujzDqahk
	XWEzcH6gSCig4BB03V8CCvpRjYDUAiefdvMUQBc7RGI7T/9ZRPbOe3SUb29pQEddgOvmsR1RMh7
	TjhC3f9XH6Cb1HW8V64jdzQXduv6J0zqU1fJ/GphrEuhCUalgQI38ebTWQaM4gtja3oFnCZ730F
	FvWt6JRUR6nJzVk5AXWHevPJ3PhCR0ipNYoCGgeAALAhrgw=
X-Received: by 2002:a05:6938:a090:20b0:c2e:52d6:1fb7 with SMTP id a640c23a62f3a-c2e52d6226amr528492566b.22.1791194155086;
        Mon, 05 Oct 2026 02:55:55 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31562aba16sm50753266b.23.2026.10.05.02.55.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Oct 2026 02:55:54 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex@shazbot.org>,
	Shuah Khan <shuah@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-kselftest@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [RFC PATCH 1/6] KVM: guest_memfd: Add a writable result to get_pfn()
Date: Mon,  5 Oct 2026 09:55:47 +0000
Message-ID: <20261005095552.52748-2-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261005095552.52748-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org>
 <20261005095552.52748-1-griffoul@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fred Griffoul <fgriffo@amazon.co.uk>

A guest_memfd backing has no way to tell KVM that a page must stay
mapped but must not be written by the guest. get_pfn() returns only a
frame, and KVM takes write access from the memslot flags.
KVM_MEM_READONLY is not an option: KVM refuses it on guest_memfd slots,
because it emulates a write to a read-only slot as MMIO, which private
memory cannot support.

Add a writable output to get_pfn(). KVM sets it to true before the
call, and the backing may clear it. When it is false, the x86 and arm64
stage-2 fault paths map the page without write permission. A guest
write to that page then exits to userspace as a memory fault; KVM first
releases any page that the backing returned. Callers that do not map
the page pass NULL.

The result applies to stage-2 mappings only. When KVM writes guest
memory through the memslot's host address, the permissions of the host
mapping apply.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 arch/arm64/kvm/mmu.c        | 13 ++++++++-----
 arch/arm64/kvm/nested.c     | 10 +++++++---
 arch/x86/kvm/mmu/mmu.c      | 18 ++++++++++++++++--
 arch/x86/kvm/svm/sev.c      |  4 ++--
 include/linux/kvm_host.h    | 11 ++++++++---
 samples/kvm/gmem_provider.c |  3 ++-
 virt/kvm/guest_memfd.c      | 13 ++++++++-----
 7 files changed, 51 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6c941aaa10c6..32e591edc69d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1607,7 +1607,7 @@ struct kvm_s2_fault_desc {
 
 static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
-	bool write_fault, exec_fault;
+	bool write_fault, exec_fault, writable;
 	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
@@ -1641,14 +1641,17 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
 	smp_rmb();
 
-	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
-	if (ret) {
+	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL,
+			       &writable);
+	if (ret || (write_fault && !writable)) {
 		kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
 					      write_fault, exec_fault, false);
-		return ret;
+		if (!ret)
+			kvm_release_faultin_page(kvm, page, true, false);
+		return ret ?: -EFAULT;
 	}
 
-	if (!(s2fd->memslot->flags & KVM_MEM_READONLY))
+	if (!(s2fd->memslot->flags & KVM_MEM_READONLY) && writable)
 		prot |= KVM_PGTABLE_PROT_W;
 
 	if (s2fd->nested)
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index fb54f6dad995..9ad1fa029835 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1411,12 +1411,16 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 		if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
 			return -EFAULT;
 	} else {
-		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL);
-		if (ret) {
+		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL,
+				       &writable);
+		if (ret || (write_fault && !writable)) {
 			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
 					      write_fault, false, false);
-			return ret;
+			if (!ret)
+				kvm_release_faultin_page(vcpu->kvm, page, true, false);
+			return ret ?: -EFAULT;
 		}
+		vt->wr.pw &= writable;
 	}
 
 	scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 234d0a95abf5..17ac2bfdc164 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4612,6 +4612,7 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
 				    struct kvm_page_fault *fault)
 {
+	bool writable;
 	int max_order, r;
 
 	if (!kvm_slot_has_gmem(fault->slot)) {
@@ -4620,13 +4621,26 @@ static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
 	}
 
 	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
-			     &fault->refcounted_page, &max_order);
+			     &fault->refcounted_page, &max_order, &writable);
 	if (r) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return r;
 	}
 
-	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
+	/*
+	 * The memory's owner has the final say on writability, on top of the
+	 * memslot flag: a page it reports read-only is mapped read-only, and a
+	 * guest write to it exits to userspace rather than being installed.
+	 */
+	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY) &&
+			      writable;
+	if (fault->write && !fault->map_writable) {
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		kvm_release_faultin_page(vcpu->kvm, fault->refcounted_page,
+				 true, false);
+		fault->refcounted_page = NULL;
+		return -EFAULT;
+	}
 	fault->max_level = kvm_max_level_for_order(max_order);
 
 	return RET_PF_CONTINUE;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 125779c82bc4..983e19f7dbd2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4063,7 +4063,7 @@ static void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 	 * The new VMSA will be private memory guest memory, so retrieve the
 	 * PFN from the gmem backend.
 	 */
-	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, &page, NULL))
+	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, &page, NULL, NULL))
 		return;
 
 	/*
@@ -4996,7 +4996,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 		return;
 	}
 
-	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, &order);
+	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, &order, NULL);
 	if (ret) {
 		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for private GPA 0x%llx\n",
 				    gpa);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 04fa0cb126f6..f84f3ab44acf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -660,9 +660,14 @@ struct kvm_gmem_ops {
 		    struct kvm_memory_slot *slot, loff_t offset);
 	void (*unbind)(struct file *file, struct kvm *kvm,
 		       struct kvm_memory_slot *slot);
+	/*
+	 * @writable: [out] clear to have KVM map the page read-only; a guest
+	 * write then exits as a memory fault.  NULL if the caller does not care.
+	 */
 	int (*get_pfn)(struct file *file, struct kvm *kvm,
 		       struct kvm_memory_slot *slot, gfn_t gfn,
-		       kvm_pfn_t *pfn, struct page **page, int *max_order);
+		       kvm_pfn_t *pfn, struct page **page, int *max_order,
+		       bool *writable);
 	int (*populate)(struct file *file, struct kvm *kvm,
 			struct kvm_memory_slot *slot, gfn_t gfn,
 			kvm_pfn_t *pfn, struct page *src_page, int order);
@@ -2651,12 +2656,12 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #ifdef CONFIG_KVM_GUEST_MEMFD
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
-		     int *max_order);
+		     int *max_order, bool *writable);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
 				   kvm_pfn_t *pfn, struct page **page,
-				   int *max_order)
+				   int *max_order, bool *writable)
 {
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
diff --git a/samples/kvm/gmem_provider.c b/samples/kvm/gmem_provider.c
index 9728f5a8029b..75197c088762 100644
--- a/samples/kvm/gmem_provider.c
+++ b/samples/kvm/gmem_provider.c
@@ -157,7 +157,8 @@ static int gmem_max_order(struct gmem_info *info, gfn_t gfn, unsigned long index
 
 static int gmem_get_pfn(struct file *file, struct kvm *kvm,
 			struct kvm_memory_slot *slot, gfn_t gfn,
-			kvm_pfn_t *pfn, struct page **page, int *max_order)
+			kvm_pfn_t *pfn, struct page **page, int *max_order,
+			bool *writable)
 {
 	struct gmem_info *info = to_gmem_info(file);
 	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index d284bb70fe05..0f4bf2cc5e8e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -624,7 +624,7 @@ static void kvm_gmem_native_unbind(struct file *slot_file, struct kvm *kvm,
 static int  kvm_gmem_native_get_pfn(struct file *file, struct kvm *kvm,
 				    struct kvm_memory_slot *slot, gfn_t gfn,
 				    kvm_pfn_t *pfn, struct page **page,
-				    int *max_order);
+				    int *max_order, bool *writable);
 static void kvm_gmem_native_release(struct file *file);
 static int  kvm_gmem_native_mmap(struct file *file,
 				 struct vm_area_struct *vma);
@@ -988,7 +988,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 static int kvm_gmem_native_get_pfn(struct file *file, struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
 				   kvm_pfn_t *pfn, struct page **page,
-				   int *max_order)
+				   int *max_order, bool *writable)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct folio *folio;
@@ -1016,7 +1016,7 @@ static int kvm_gmem_native_get_pfn(struct file *file, struct kvm *kvm,
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
-		     int *max_order)
+		     int *max_order, bool *writable)
 {
 	const struct kvm_gmem_ops *ops;
 
@@ -1029,7 +1029,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		return -EFAULT;
 
 	*page = NULL;
-	return ops->get_pfn(file, kvm, slot, gfn, pfn, page, max_order);
+	if (writable)
+		*writable = true;
+	return ops->get_pfn(file, kvm, slot, gfn, pfn, page, max_order,
+			    writable);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 
@@ -1093,7 +1096,7 @@ static int kvm_gmem_populate_one(const struct kvm_gmem_ops *ops,
 				    src_page, 0);
 	else
 		ret = ops->get_pfn(file, kvm, slot, gfn, &pfn,
-				   &ignored_page, NULL);
+				   &ignored_page, NULL, NULL);
 	if (ret)
 		return ret;
 
-- 
2.47.3

