Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F25941A571
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 08:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787040782; cv=none; b=mkKKhh0kzC1xzGCxCnKjlg72JN1TIjoZl3ABnvPIQTo0cKl8rigqRTTSJn0p117rYLGRRt/B+FxNK/hFZdKVbJo3TgLdnBd156P7lOblvdG9aJgCC31EnT45m/3O9eTwlJS12ccI2/+Wa0nVs1LChQqpmvMEzBij1tFI6x0QFLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787040782; c=relaxed/simple;
	bh=7i6cqBtbFkQctrI98iz0J10uujeLpSmIIWcG5kUAid8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F0tRwA1MFxS7v7+0dFlCc+FeMYC3VBrsPsv8caTxGklQmfiHGVKdQzsNxkOlBHmlG4N9Yv4WGhpD3f9f/eWiAwQOmqnd5K+bkoAtjAJUZ9xjsCK7nXc7HQyMijDf8EGps8LFX8tYTsAi7zfSIjUrKE6VMX3SaGnfDYxD3wVjefE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bsgxtITd; arc=none smtp.client-ip=209.85.210.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bsgxtITd"
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8488ac68185so8516300b3a.2
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 01:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787040778; x=1787645578; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k3ULsNgYxwRhZwue5bCy+g9EswRkhCGynb1/tmXwwp8=;
        b=bsgxtITdEJKt1WNGT+eBNmpl6sSL6aDDL0Y17zpp9B9Nw/qzIuWD8tvfu2tNc7i0WU
         o5N8XV5CmeBQQ1xRHS7aAOgG8rkU7W95PPW5zrllaf/n6uy5yB34tYNl//zYVXuI0/L4
         xdRXJYo80viWnLSxLgGHjXZpxtmbTcE6FkJVwO6MxfUEipdLgqSR25VZyk49pnYyVCHi
         zrvxk/5sXBb4GTxc2CXMj8/za+VKJk7W7O1a+FlMXEwVEFpbliZmfKHKY0V9ugrIz+GL
         p+gprRUh4i+VLdRwoGVpGZHxVJy2iuXLJLTfnMN/ze/Fe7kbWhv2mUW23sj0GhdpLUb6
         qqfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787040778; x=1787645578;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k3ULsNgYxwRhZwue5bCy+g9EswRkhCGynb1/tmXwwp8=;
        b=XtUlZkQxwI+nms5h9s3nYCVT5fRsIgqdponZAvg2WTov81T6VkZD0QdjwXLcMeqy1/
         Lp+pt8kKmfpR0996kxxY9pdeM6+S215L08hwC7C1R0ccAj5HOh7A+rMtZXbaok7r8a+1
         i2S08PRcj0UxZk5330yne74DDN39tZgEyxnDuLkJXr9XKBAMy95iP6rdf20PDj2m2i2p
         j+/YLqKUs8jd84FAZ1l74Uex2XcaAXT9qpzzmAGVvYtdYCq3+9+xyiIVKUxmO1YsKU/t
         WODMbv+EzNLBzIG9EKKNqmHZ/DZY96xzRFMm8dl1L6I9AdduWc92GqdSDnbJvWVMLYbm
         lzwg==
X-Forwarded-Encrypted: i=1; AHgh+RqEGQqbSTZMJyBe87YZqgWaPkrQkpx5aXRztDzSGTbmZ/1ni+gGO9rz5G3U1EofQ9FJPsdPcwU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFxQqEa9dztBCyoY3/Lj90FHu9+LGGfaLiw0/H81M+gC8RLl0W
	eny08yPvsiNUHBJxguJSxf8QskyPt//R1cImTrak9mWMR+dOcib0Pj80XFbKNf1LHa5TR9cKr/X
	PxipaqFGflmGDImD/YT2Z7eP/jg==
X-Received: from pglf19.prod.google.com ([2002:a63:1013:0:b0:c96:da8a:c09c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:10a:b0:3cb:853e:850e with SMTP id adf61e73a8af0-3cc71b7acbamr41629166637.13.1787040777693;
 Tue, 18 Aug 2026 01:12:57 -0700 (PDT)
Date: Tue, 18 Aug 2026 08:12:36 +0000
In-Reply-To: <20260818-gmem-no-return-page-v1-0-4f8d939efdbc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260818-gmem-no-return-page-v1-0-4f8d939efdbc@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787040773; l=1697;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=7i6cqBtbFkQctrI98iz0J10uujeLpSmIIWcG5kUAid8=; b=ekVPncMmVUriS84Zt3+p8nRYXWSGEYGwwUVXJK5NXlHtz70OGF8spprSioZ5xfncCfU5EKAue
 7ocjFnw2d/JCgGzlgbUnq1q4Jp4Sgvc0ggqydJcjSIEBFCCyy17BUEN
X-Mailer: b4 0.16.0
Message-ID: <20260818-gmem-no-return-page-v1-2-4f8d939efdbc@google.com>
Subject: [PATCH 2/4] KVM: SEV: Drop page refcount early during RMP fault handling
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

When handling an RMP fault, KVM retrieves the PFN for a private GPA from
guest_memfd. The page reference taken during PFN lookup is not needed for
the remainder of the handler, as checking the RMP entry, splitting the
2MB page via PSMASH, and zapping shadow page tables only operate on PFNs.

Drop the page reference immediately after retrieving the PFN instead of
holding it across the entire handler.

A later patch will follow up with completely not returning refcounted pages
from kvm_gmem_get_pfn().

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/svm/sev.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b2738362a928b..19c31fa944e34 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5036,12 +5036,13 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
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
@@ -5088,8 +5089,6 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
 out:
 	trace_kvm_rmp_fault(vcpu, gpa, pfn, error_code, rmp_level, ret);
-out_no_trace:
-	kvm_release_page_unused(page);
 }
 
 static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)

-- 
2.55.0.699.gb54405d56f-goog

