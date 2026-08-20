Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2265139F16B
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 23:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787268767; cv=none; b=aHopNrcRLgsYR6HKuuzqTWnULcPmaB2K33NtkhGDDKdlP9i7MwPBNDJb5p0ik2HoXScPT/0GFS2r9xGObtr0D43vwDBxs4XbB9JPzyyUtWA/dCHeSK8yghrwrs5WDFkvX2FeCypf9brQcVIfBk0IOudL/aMc0VbJMdd6YEAbKHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787268767; c=relaxed/simple;
	bh=LtICGHiNmjgfsS++ex4KQnpy0xO35NrIf5VSNcMhCjw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mnaC17OFM+QA7b3KnnPnAwvvjB6K7NlqJ+Yb01w9Nlp05xM/bbhJbNCHgGa975PVQhEyqxJFeti/7REEIMljnyKIb6JJ+baiOxOCNIjD/G6TGIRWRfEFWXxLFgIAr2yKA0+xCjp0TI9uwO5BU4SpsdVsYAPWD819ykojr9w50YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PXgWNrJd; arc=none smtp.client-ip=209.85.215.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PXgWNrJd"
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cbedf6e8a42so552504a12.1
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 16:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787268763; x=1787873563; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZIY2AhPPQzV0SpGVac6m1vEhtgYyPU90RiUZoPMOP+0=;
        b=PXgWNrJdT+rbT8KHaor8NfahhSX+13KZF4SzwcJCnp6XsS+gNzX14mveJSRbV/Z+8G
         qn9MWsFBXf8UVa4wQTKQ64/vIRzuICzAbiAs8R6s20/fWRqnAJnaXpVLld+12MopYYO4
         DB6vC85pr9DCoaw2vnIXoK1ODhbFHw41B00JdIoZTkrsYMxwWmMrqUJqKdp5a7fSHYO3
         esHqKJ0NOn+lRjLxRaIcci+LcrgG+uqPBQ4lR3WBpovEFeYGV6nC7TkDK1fCDDY9FyPe
         pRZt5rTzve6bjK8A+V3qdM8EWDrWXPqAcP8ueZJKsMKbxh6RbVtmdChh+DP0dka/U/FU
         Kg8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787268763; x=1787873563;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZIY2AhPPQzV0SpGVac6m1vEhtgYyPU90RiUZoPMOP+0=;
        b=ZCUMo/t/6B9+Nij6GdeqNDGAIJtECRKhoJmKoVl66OPNkyHJIgzoNrPgnDlzE+iTVa
         1ozDrPWh5Q/P4mQi6k0vsLFX+jgo12yjigOR6xkSmLPxsF2iMYXRdF0XQogH7vFr5BFh
         Lzh418oTDlqczuKH4gAUIkODTLxU5+iWW5S5Tv+Urkeay6XAG4xT1CfyP8uT+BlYkrna
         TCRGr8U9+3ax/F+Nw959ZX7P1E3fCtdm5UnDutsz954PzdaI4C1i4iIyQQ2/xfLsgGi6
         e9UXt4nB8LhZ6PIwA2WjtwySB0OilpnT3yPXnGbkNNWnoBP3ZFrMQ+i39GUPa6wk9UBH
         jJ3w==
X-Forwarded-Encrypted: i=1; AHgh+RrtSi4vU1z0MxmRXqdUe/H/W23NnHyAPPJsCFj+8W6ESm+16KCyv/N43R92t8QUM2q2RuTr0pI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5vxm0GLp25jMzUrgyUeL/QHO3/834jciTUUMKeeLwa6xA9EKb
	efwpY5l2aq9XvBBx/x6yDo8CJY+nrHe2BsrP7jLOVXETDZBHvl/eSHQE8uaK/SPWmuVPC7la3ui
	7HcLRezKWlc17xbCDsLT38hAv/Q==
X-Received: from pgbdn2.prod.google.com ([2002:a05:6a02:e02:b0:cc1:577a:be35])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3511:b0:3bf:6acf:2940 with SMTP id adf61e73a8af0-3cd30060d76mr4159740637.11.1787268763335;
 Thu, 20 Aug 2026 16:32:43 -0700 (PDT)
Date: Thu, 20 Aug 2026 23:32:35 +0000
In-Reply-To: <20260820-gmem-no-return-page-v3-0-3bf8f80a7b4d@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260820-gmem-no-return-page-v3-0-3bf8f80a7b4d@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787268758; l=4467;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=gmGK5vSp2T3AX5rxyH8TZSoWy4Yohm1Gq2bGrUFDfX0=; b=uZp0bfS9zqFoFKgb9NG/wM0fl/ZiJb3zgvRPUCdq8MfxfHKHAx6mFHPHhfUBhuv0P/o7ih6Az
 Be0oeIuNnL1BRBWOzUneSjBWLU2ui04EGXoIzvLkwmam2EaiBS3N1/F
X-Mailer: b4 0.16.0
Message-ID: <20260820-gmem-no-return-page-v3-2-3bf8f80a7b4d@google.com>
Subject: [PATCH v3 2/4] KVM: SEV: Drop page refcount early during RMP fault handling
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"

From: Sean Christopherson <seanjc@google.com>

When handling an RMP fault, KVM retrieves the PFN for a private GPA from
guest_memfd.

Drop the page reference immediately after retrieving the PFN instead of
holding it across the entire handler, and adopt the KVM MMU invalidation
protocol.

To avoid wrongly warning about not finding an assigned RMP entry if an
invalidation had taken place, check for invalidations before warning.

When the RMP level is 4K, the function exits. That doesn't need checking
for invalidations, since if it is 4K and there was an invalidation, not
psmashing and not zapping is the right thing to do.

If the RMP level is 2M (the only other option), use the invalidation
protocol before attempting to psmash. This ensures that if the page is
truncated and freed, and then re-allocated to another SNP VM (the RMP entry
is now assigned, but to another SNP VM), psmashing would be correctly
skipped.

A later patch will follow up with completely not returning refcounted pages
from kvm_gmem_get_pfn().

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/svm/sev.c | 47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b2738362a928b..563870342a2ba 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5003,6 +5003,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = vcpu->kvm;
 	int order, rmp_level, ret;
+	unsigned long mmu_seq;
 	struct page *page;
 	bool assigned;
 	kvm_pfn_t pfn;
@@ -5030,18 +5031,26 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 		return;
 	}
 
+	mmu_seq = kvm->mmu_invalidate_seq;
+	smp_rmb();
+
 	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, &order);
 	if (ret) {
 		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for private GPA 0x%llx\n",
 				    gpa);
 		return;
 	}
+	kvm_release_page_unused(page);
 
 	ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
 	if (ret || !assigned) {
-		pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
-				    gpa, pfn, ret);
-		goto out_no_trace;
+		guard(read_lock)(&kvm->mmu_lock);
+
+		if (!mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))
+			pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
+					    gpa, pfn, ret);
+
+		return;
 	}
 
 	/*
@@ -5069,27 +5078,31 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	if (rmp_level == PG_LEVEL_4K)
 		goto out;
 
-	ret = snp_rmptable_psmash(pfn);
-	if (ret) {
-		/*
-		 * Look it up again. If it's 4K now then the PSMASH may have
-		 * raced with another process and the issue has already resolved
-		 * itself. If it's not assigned, then this must have raced with
-		 * another process that made this page shared.
-		 */
-		if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
-		    ((assigned && rmp_level == PG_LEVEL_4K) || !assigned))
+	scoped_guard(read_lock, &kvm->mmu_lock) {
+		if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))
 			goto out;
 
-		pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
-				    gpa, pfn, ret);
+		ret = snp_rmptable_psmash(pfn);
+		if (ret) {
+			/*
+			 * Look it up again. If it's 4K now then the PSMASH may
+			 * have raced with another process and the issue has
+			 * already resolved itself. If it's not assigned, then
+			 * this must have raced with another process that made
+			 * this page shared.
+			 */
+			if (!snp_lookup_rmpentry(pfn, &assigned, &rmp_level) &&
+			    ((assigned && rmp_level == PG_LEVEL_4K) || !assigned))
+				goto out;
+
+			pr_warn_ratelimited("SEV: Unable to split RMP entry for GPA 0x%llx PFN 0x%llx ret %d\n",
+					    gpa, pfn, ret);
+		}
 	}
 
 	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
 out:
 	trace_kvm_rmp_fault(vcpu, gpa, pfn, error_code, rmp_level, ret);
-out_no_trace:
-	kvm_release_page_unused(page);
 }
 
 static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)

-- 
2.55.0.766.g2966f0265a-goog

