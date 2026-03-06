Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1933ACA53
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805765; cv=none; b=SxOzJtXl1LHOfHdfCCg/mUS9ooUBECg6hkKhsyYCHnIOB702sIuoYOPWSXTI83nvXSqvzh//hOkhwkLoO/rxyT0XQ/BftRJxVGjFc9AkrJZHP1OJr42fPwO7+TqkuFvF+ohH4dZfADNnsX9DIs9AkDpq+R9+9XIzxUSfDIsuRyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805765; c=relaxed/simple;
	bh=wU7LY+l8eziTdyiYMOjRIU0DPbURQ3YWdDdcLC7ERsg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y382tWQ9uekDL2TCx6v6FM1DkJ3yN5wNmn3YVhhp0kBRAPbrZO22BhxP/mm8z8Z2j+OKm9mzTr8LXwXMTVNJCeuEtjqddtuuUPZAjuJ8l0m1S4nutElKYSqa85+sCJ77xw7rvgv1yw/oThGP08MoRCLHXyGgM1PlQqjxsietJxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B8OZ4BvD; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B8OZ4BvD"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4830e7c6131so96798495e9.2
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805759; x=1773410559; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sHiziDrbrII1tYwtdt9uLufHtIuF7NAMU9T1cNEOC3I=;
        b=B8OZ4BvD2nfyq1gBnPLcyw2xQQxmcKKT4YJdmUn5CvtPtWPodBgCFm1UVfELmLqLYN
         mZB6J/u0bxSLrIjk7c9MkXM3fUcxMGb+5+3N5Wtho5GlNdJQji659hstNEwu6wi5vU14
         gEY/bzA2UcnWT6grCc4NwP4civR1HsqJSdE2qLig40SGW2OIMKcMcIBY27DekSEu3fqK
         n6FNsPr/ID5zaGyCXDB2W1HSAHxsSGe/8wi2SZMuCaTwkqgXqQQZybB5lnmNBPr8iPbC
         0AnjZkBYMvFCfPPOdBef3omQOrbBkpd6/KnmeCJ/nioe3YfMi/2NXrLTOjEA56cha6wS
         4YJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805759; x=1773410559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sHiziDrbrII1tYwtdt9uLufHtIuF7NAMU9T1cNEOC3I=;
        b=OcTtvdCQP6AO1jtu+DabOjdHNizUFFek4b88LvD53fP10p/khxgDvuZKh/V8yEFT2B
         z9XbFztDlLyHG3QHueCUmkhl3QSs37szJ6JiV2d0LITaduSDd4qp4f0YI3Yq3Ep5ypLH
         D03p+3/6WjyJ+2/tpiaQBeUCpGKTWM9Bf1DVzQSS2RXNEhA3WWiI1F/mCx7M4ZBd6CV7
         BVqp6NZhXl7+bwSPNznDVTbDENnTO/eITzD7HVL8DJe5rX5UX/mXF3Q/j3ydAUXP8WxQ
         bH8KCJUiagzzRX/R0jooNvOhYl/4ym/Vhimu4VRPwPAXcrVaI6vfBG5fQv4BYjdVyLXF
         VZ8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWE+6Cntkmq9J3IL8VCt0tz3d/JbHWOSA0JtggCEKC7A7nocsewVpMRZ+26LLDWY4zptFc7ik0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2xFiYtrWAk6AVRyuVbmYrDkLoKBV7mi5PvvlOVwmwOR5gSjM/
	wuKe0N4ChPImmUtvXnqfEza5sFYVw4ndFROYWkVvox7bHjg2lsMCkdIa9axS2qAQw7NNWEnwCED
	JqA==
X-Received: from wmjk6.prod.google.com ([2002:a7b:c306:0:b0:483:7b48:cd99])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a0d:b0:485:1878:7b8c
 with SMTP id 5b1f17b1804b1-4852695b6fcmr34660805e9.18.1772805758953; Fri, 06
 Mar 2026 06:02:38 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:23 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-5-tabba@google.com>
Subject: [PATCH v1 04/13] KVM: arm64: Isolate mmap_read_lock inside new
 kvm_s2_fault_get_vma_info() helper
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Extract the VMA lookup and metadata snapshotting logic from
kvm_s2_fault_pin_pfn() into a tightly-scoped sub-helper.

This refactoring structurally fixes a TOCTOU (Time-Of-Check to
Time-Of-Use) vulnerability and Use-After-Free risk involving the vma
pointer. In the previous layout, the mmap_read_lock is taken, the vma is
looked up, and then the lock is dropped before the function continues to
map the PFN. While an explicit vma = NULL safeguard was present, the vma
variable was still lexically in scope for the remainder of the function.

By isolating the locked region into kvm_s2_fault_get_vma_info(), the vma
pointer becomes a local variable strictly confined to that sub-helper.
Because the pointer's scope literally ends when the sub-helper returns,
it is not possible for the subsequent page fault logic in
kvm_s2_fault_pin_pfn() to accidentally access the vanished VMA,
eliminating this bug class by design.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d56c6422ca5f..344a477e1bff 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1740,7 +1740,7 @@ struct kvm_s2_fault {
 	vm_flags_t vm_flags;
 };
 
-static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
+static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
 {
 	struct vm_area_struct *vma;
 	struct kvm *kvm = fault->vcpu->kvm;
@@ -1774,9 +1774,6 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
 
 	fault->is_vma_cacheable = kvm_vma_is_cacheable(vma);
 
-	/* Don't use the VMA after the unlock -- it may have vanished */
-	vma = NULL;
-
 	/*
 	 * Read mmu_invalidate_seq so that KVM can detect if the results of
 	 * vma_lookup() or __kvm_faultin_pfn() become stale prior to
@@ -1788,6 +1785,17 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
 	fault->mmu_seq = kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
+	return 0;
+}
+
+static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
+{
+	int ret;
+
+	ret = kvm_s2_fault_get_vma_info(fault);
+	if (ret)
+		return ret;
+
 	fault->pfn = __kvm_faultin_pfn(fault->memslot, fault->gfn,
 				       fault->write_fault ? FOLL_WRITE : 0,
 				       &fault->writable, &fault->page);
-- 
2.53.0.473.g4a7958ca14-goog

