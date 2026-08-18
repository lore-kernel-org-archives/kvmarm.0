Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D420741D628
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 08:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787040783; cv=none; b=f9xFiCMGUMYrKSOHOKiaMtyGQKtEuZNOl+CgrUyRkSO+KE7VgWiOZhR8tCzcDkftly97+2BNO6r9VrpAmiZlu8OVwFtRQjXDtPwtEtKc7ZGFuY1FbgMGv/7j7dRwt8wge2zgMFwe/xWpCzBThSuqMTyZzPPj4Qyy4s0xBF9oowo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787040783; c=relaxed/simple;
	bh=HBAMvv39sFk8+6D6cJKyVCd7nwzLeY+DW3CPjKwbem4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CCmG5xG3xw85YHcGh+sIfJ+k3D3qY1FyT33HL8rUX5VG5+ceizHC7MWyCvKYbL0xBYXlzcdoR8CacVosfT1mBsrIgcF6r3so4YTzHcjYPQE0SEX+hfPFIDpLsWQD0P6fdOy9cbsBvsQAZHdRz9doWk4cyFobAyn6/xlAinq4E34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OKBZUkEP; arc=none smtp.client-ip=209.85.214.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OKBZUkEP"
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cf7dd9fd91so50058855ad.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 01:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787040779; x=1787645579; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=py9oGM3siJXhjPmyy5yHILORKpTNDQOmPG7vid7oKT4=;
        b=OKBZUkEPsKTDU9SNZgVwJ7DeQyzdQ4Ah/4wP8Qf7xQ2nlYOIZH1arhnHVmV+69Ca/K
         cclJiMIzfzRedSBB2LnHCSaI7yyuoIbsRYOGxSDkTZfOFokhZhlZfwZkYZ+uHwnYT0Ng
         XKcrY+siX0uW1o4vcfWwweZup1QvP1diaEXwo/vREGMmMXmjartgX6UxHObCB/OMI8Wg
         ZOBvPrbNxftv2KuJ7JDi7AgVzLXMXIW1Mlpty412632jL1mae8dz9B6KML42fJrJI7XF
         QjvGBs9nKmrI9R6GXwL9WBgBkptFZquNnSobPPYLAnrqgSWN1yJKSMANU8dJArNnrtwt
         j/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787040779; x=1787645579;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=py9oGM3siJXhjPmyy5yHILORKpTNDQOmPG7vid7oKT4=;
        b=VvlxCSdIBfk0Cegd9QoOiYcLfIvtvih6ltf+K+sxFXVXpCwSJ2ijuxCX/LyMWAZd9W
         pZFZEqKvB73itCNrEL2kDs8eoFkEMYXTMyM/Rl+HcfILX4qZf44x1RvCLCtGFcmAs1Ft
         bhWpdxkic5bWW4CdHzsWm06RPNQVq1VzUGVH1dDe/aODUulpdKME5lNL7/c6kWGAGye2
         qE6usT8TbHX3lOwAWinvabX8lQUzilgupgBWu9GnuHqU1pS4N4gK0ll/mbcNNaUhMVuL
         iN580NhL2T+LTfsCVy2EUiDNSlNM8t1u1ZLjPiiJRmqQ8k9vWDDli18VZ3CwK/GMelib
         wfIg==
X-Forwarded-Encrypted: i=1; AHgh+RpD3JGKSLzWji4ynOXDbLOQjJ9yEUKGGr5BLk+2IW4mnYwP8p7SCvWLtln+0L4GH8xMjYm3f5w=@lists.linux.dev
X-Gm-Message-State: AOJu0YyasFaQYkf5Xe5RJ+/9jEA6fQAbZBY4ZnSbueoINt1WQK6u3u3/
	/MTKQUZ/IKBcPwRESshbHGAAzKzhdQDkYUSuxCmzk+xcTYUlznn7HOqBn//oDKLsSGnAuIvm8X6
	zRXAL0GyfSKMqXyoDR+QKbdDm+w==
X-Received: from plpw11.prod.google.com ([2002:a17:902:9a8b:b0:2cf:2ac5:9098])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ce04:b0:2c8:2808:3ec9 with SMTP id d9443c01a7336-2d3b0d5e658mr384056035ad.12.1787040779293;
 Tue, 18 Aug 2026 01:12:59 -0700 (PDT)
Date: Tue, 18 Aug 2026 08:12:37 +0000
In-Reply-To: <20260818-gmem-no-return-page-v1-0-4f8d939efdbc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260818-gmem-no-return-page-v1-0-4f8d939efdbc@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787040773; l=1303;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=HBAMvv39sFk8+6D6cJKyVCd7nwzLeY+DW3CPjKwbem4=; b=mOyqx2L3EUevN+HReTiR9BLbQbbIVJKA9Szdy3xkBVDx5LW4GH0t8FRgmGB1JMIT6leK1f26j
 KObbm72z9rQACvWlEFb2sbi6pWXRCUOdCOO3xSedy+PeOf8JyXHnclA
X-Mailer: b4 0.16.0
Message-ID: <20260818-gmem-no-return-page-v1-3-4f8d939efdbc@google.com>
Subject: [PATCH 3/4] KVM: SEV: Drop page refcount early in VMSA reload
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

When reloading the guest VMSA for an SEV-SNP vCPU, KVM retrieves the PFN
from guest_memfd.

Drop the page reference immediately after retrieving the PFN instead of
holding it across MMU lock acquisition in preparation for a follow-up patch
to stop returning page pointers from guest_memfd PFN lookups.

This is safe because the page's validity and presence are governed by KVM's
MMU invalidation protocol rather than the page reference.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/svm/sev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 19c31fa944e34..3fc582fa343cc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4062,6 +4062,7 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	 */
 	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, &page, NULL))
 		return;
+	kvm_release_page_clean(page);
 
 	read_lock(&kvm->mmu_lock);
 	/*
@@ -4076,8 +4077,6 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	else
 		svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
 	read_unlock(&kvm->mmu_lock);
-
-	kvm_release_page_clean(page);
 }
 
 /*

-- 
2.55.0.699.gb54405d56f-goog

