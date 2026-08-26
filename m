Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CB33BA239
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 09:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787734931; cv=none; b=NQ+lJ8BwjoCbgxN6P0nTHemFLTqxDURk5vO9Wb+24gS0BhFiu3BtfxJ6zaeW3kgU5KFEb4qc5xw7NJhoR33HXlyxHkquTurgD2EF4UxVvj004GP05FuGVN00dTVqUgdbj8UUiYMuH+sRr4HqcWJ3kNDwPltTepYlBRZKEMFv0qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787734931; c=relaxed/simple;
	bh=M+i2SxvXQ8DSphNQ8ShtoJPE8ttDtKFUtUCnzxjFNwY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KX1ssm8s5foaEr1qPS1m7RyO0zx/Cprbsa4W/pmJY8u7ntH39tLf0pxgaGbM9DwP4Ffc7JXJ5tWtAf2psx5+p7tLkEOM18I/g2KEtGCaLaZT56MP1irIypWW7U8mMAF7pOY0ewWHfRX39z4RU5dLO5VWhEYqunOGS5ni10539TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tIbVnFl8; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tIbVnFl8"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d6fed0652bso11996155ad.2
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 02:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787734926; x=1788339726; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EuS9O11vr193qDv9HWb04MHk5U9f4uvrgo/7abqfaWM=;
        b=tIbVnFl81VJ573l1E3vNUwUUfcfzHeMHIBPzuacmXmMrAT1t+G9YY8a41dHGt6YNRB
         Ww9cy+RhHkVfCqg4TrCrxG980QuAY8jG8bbcYgrHQZNCSGrhH2iX1TmfS1pnIwcO8D4N
         HiM1TKXAJrLoogOMiO6shAoc9/tItUdbnGq8GHSUVZaAep6NS8BIgk5+Ad9eClZXq/ta
         x3tD/HsCYpr0RqQAo7cM3oUPQJ39T5AowqgQZrg9x0DCTA7tdWrWIH/HJwDkzHUuVFz6
         GiYq36KJEBpA/t+kiG7LcUfrQMX+k9hxero6gYcWKuUznK2QMJ3s5+cN42orgYMZFliC
         5XzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787734926; x=1788339726;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EuS9O11vr193qDv9HWb04MHk5U9f4uvrgo/7abqfaWM=;
        b=nRh4od47eBcoao31ooN03Rjbx8kzaEeW7sD24gvDlI5+y79LoYKaLRl+LGuSbnlhgF
         qnU36uAFw1NbSFXXFYY7ZyyaCn3Hsspao3tj0JoP2/q+9j+qZaOnKWWqzTvDpk1EXSXJ
         3OHo9vKc+SoJZedSDdDtkQlB7eiodqg4oCEHNg5LYEQXlIByOzrk8kyDXLsxgV1lwrvl
         knCWt8TE/wwg+rWIU8CMKoPvNNjBCOKQA7pUlMYQ+NbohAOzlcyDxVKFrMyi8+KcDt2D
         h4asVeQcX0rLCXLHadLgQiUS/u3ZpDOMMH/zTbXfAuQmpHghv6NQ5XK5Y71oTzQF8TUx
         eXUA==
X-Forwarded-Encrypted: i=1; AHgh+RrNbHC3NMShh5V/CclozjdhbuK7wuzx0MB/BJNTB2dbd3K/1SErUxscBl7DUCTDgIiZeuifqIU=@lists.linux.dev
X-Gm-Message-State: AFuF++k6RE8htvvP1IbgQQKZ0nZu5gCjEzF4IofcnWFLanH2XDhrNC2t
	4t89GAFJARleR5mEl6Mhn4yi8qegLeXQWGTVYgcy7t38KVhCWXlIaei7AoupT5dZE+HByOGU6Vr
	Hi5QRPgMfaHzB3gnLFtHLCGvycg==
X-Received: from plbmz15.prod.google.com ([2002:a17:903:350f:b0:2cc:6063:a658])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:e70e:b0:38e:524:8797 with SMTP id 98e67ed59e1d1-3966d4503ccmr11876759a91.13.1787734925365;
 Wed, 26 Aug 2026 02:02:05 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:01:47 +0000
In-Reply-To: <20260826-gmem-no-return-page-v4-0-3bb9c1ddb4e3@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826-gmem-no-return-page-v4-0-3bb9c1ddb4e3@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787734920; l=3858;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ifBAzXs8dlmanG/v8Acwb5QccjLKb55JHzRk/esPfm4=; b=kJMdcnrib7/3q/fmH14PIC5RislnUwwDuforS4mPsCFG6U4RlmpkwZgDuAO6oLG+VTfDnsS8p
 VAKOV4a6zA9BcErbmRbTF6QWV2iI5gPuSe8RTZJyLl6TjYx7ftseQ1s
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-no-return-page-v4-2-3bb9c1ddb4e3@google.com>
Subject: [PATCH v4 2/5] KVM: SEV: Drop page refcount early during RMP fault handling
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"

From: Sean Christopherson <seanjc@google.com>

Rework KVM's handling of RMP faults to rely on MMU invalidation logic for
safety, instead of the current approach of holding onto a folio reference
until the RMP operations are complete.  I.e. drop the reference gifted by
guest_memfd immediately after getting the PFN, and instead do RMP updates
under mmu_lock, after checking for relevant MMU invalidations.

This will allow dropping guest_memfd's reference gifting entirely, which is
ideally how KVM would operate for all "follow PFN" operations (GUP has many
more complications, which is why KVM holds a reference across page
faults *on top* of the standard MMU invalidation logic).

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/svm/sev.c | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e198469eb074c..0d027cff734cf 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5019,6 +5019,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = vcpu->kvm;
 	int order, rmp_level, ret;
+	unsigned long mmu_seq;
 	struct page *page;
 	bool assigned;
 	kvm_pfn_t pfn;
@@ -5046,18 +5047,22 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
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
 		pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
 				    gpa, pfn, ret);
-		goto out_no_trace;
+		return;
 	}
 
 	/*
@@ -5085,27 +5090,31 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
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
2.55.0.887.g758fc8c411-goog

