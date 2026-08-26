Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F7336A03F
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 09:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787734931; cv=none; b=EUbnjomGAjT0kdWeSt7+2PFDGJ8+GZHjnolP80PpkoSWWc47rtG+JdpM8JfWGVBqXefR8tjM4FA8FsgIfqvC8q1YROPj3jf8fzAVO6zh3LNdmAvIpJUiLE4C5fP1az+wbfuEb7lRVusi6+yqCjxtqH1QVEiiuhj0eMcuoZlxVYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787734931; c=relaxed/simple;
	bh=wJOyfULGjQ7JJwE+0qiErJO6uCXLldGcRp+nAP+aV5k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tdbSiJ3AEoszIPjhvOksCcjdyQMTbVXmwvZiwbvEOdHa+Ju20+o53hAgNi7wClJBm9KI0t7eaj70Ao+lwQwrQx+b/Zf6s0+GqTU2EhNq6wjJfycVCSGUWDrIFftYiNTlXg30EdLQHbI+rjKEX63ZqbQhijtPMxFU6W3AfSo+eQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EtNnxnFY; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EtNnxnFY"
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4ab4f652f9bso713502b6e.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 02:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787734929; x=1788339729; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TNaAio5F1cBCNtxlrEFoP4xklnbz677Jx5ey+mk7fOE=;
        b=EtNnxnFYIIoNQsK0Z6OWyaf09EM7mqqzkBncpfR/N3S0GjB41axmWv8WC+dbNq+TZz
         KPwns+a5MJdDhhQYITsNdM0X5XHNnC1tD2B1bttglVrBfXvURJy66gVEnfpQZHlu/D53
         tBz7HgZRPOxj1OYK6oBjHizPZBbNyC6yrivqCCDikg4hyiR0JFrCMGIvgx0ev6IiHpww
         J+9kvFFfh95VyZBol9jrRHmb0BpH4WH6zXTb5I3lE3MtCKDM86uQA+bQWjY7UI+SAruR
         xXf6Ycn8m+FdVdmCqR9lZIBOo6AkFtkgZnJrQ3P8ddnYhS3WzeTuE2/FjhSrMpcmpohv
         +Exg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787734929; x=1788339729;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TNaAio5F1cBCNtxlrEFoP4xklnbz677Jx5ey+mk7fOE=;
        b=ossD0YLUk/tK8yxCun1/p1vuilx88i62loMqijaWFZHHf4zwrtlcoRUiYu9MQ4Hs4E
         mq/eallMAYvdu4SK2TfoBAprskIoGg3PeeRRIuIHMK7kH+jlNwgpnGJ2kKQlWjWG9HJM
         q77hms7Tzr2MfPxAd27fAp8RBP3zSegWlM+cVxVz9ZbHBTMUy4mYd8E6Cz8XLQjjkk69
         uUL6/D9TDtP4xo52Zn8JCLtnQ53tYQuMA88koQ+kttb0a07dE/1yVGSiaju3of/dDuxI
         clBGcQ2vjZOYfppZ02RQS7U4IHIt8PU2pM4cnsC4OXeVEnbb0vj+VQ7LHcKkIZ4QAKbT
         l62w==
X-Forwarded-Encrypted: i=1; AHgh+Rqq7C4FkgINMIKSEmuTwFmElZ9dI9d6ugYYYlfkhrIEWQmqnjJw6DWPerBTysfmVE9MCLTF9W4=@lists.linux.dev
X-Gm-Message-State: AFuF++lE7HkI3O0qG2t9VOoAg1UlDt5XqB9p9PwyiXTqcpRHDZt/tcEF
	wRrxif+GXjx/w9F2aLUNZtU7m0Sv6HbBoplzK+krupskRFQ1/zJue36kHElrPbfryGP27sMOykm
	AH6n0EeSn28JsnhT7Kc5IMXAXew==
X-Received: from pgnm16.prod.google.com ([2002:a63:7d50:0:b0:c88:90c8:13c5])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:2f18:b0:496:11f1:f2b5 with SMTP id 5614622812f47-4b366a4fac4mr6019140b6e.10.1787734928803;
 Wed, 26 Aug 2026 02:02:08 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:01:49 +0000
In-Reply-To: <20260826-gmem-no-return-page-v4-0-3bb9c1ddb4e3@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826-gmem-no-return-page-v4-0-3bb9c1ddb4e3@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787734920; l=1353;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=wJOyfULGjQ7JJwE+0qiErJO6uCXLldGcRp+nAP+aV5k=; b=z/jEqpUrNgcyUxL/Z8M0h+X83m4nMTDrvNZG71fmUEG3iFGsl8CB+iONKXlWeTPtqJt/DJfsA
 fXBzpO0jrAZBZvXSyzkSiu1twbOvJ+XRsMxmMGFlpjbWacNRwyM4Zwe
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-no-return-page-v4-4-3bb9c1ddb4e3@google.com>
Subject: [PATCH v4 4/5] KVM: SEV: Drop page refcount early in VMSA reload
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

When reloading the guest VMSA for an SEV-SNP vCPU, KVM retrieves the PFN
from guest_memfd.

Drop the page reference immediately after retrieving the PFN instead of
holding it across MMU lock acquisition in preparation for a follow-up patch
to stop returning page pointers from guest_memfd PFN lookups.

This is safe because the page's validity and presence are governed by KVM's
MMU invalidation protocol rather than the page reference.

No functional change intended.

Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/svm/sev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f9dce8acac8eb..f094b19226b92 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4078,6 +4078,7 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	 */
 	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, &page, NULL))
 		return;
+	kvm_release_page_clean(page);
 
 	read_lock(&kvm->mmu_lock);
 	/*
@@ -4092,8 +4093,6 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	else
 		svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
 	read_unlock(&kvm->mmu_lock);
-
-	kvm_release_page_clean(page);
 }
 
 /*

-- 
2.55.0.887.g758fc8c411-goog

