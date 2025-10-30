Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBF638558F
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 20:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855045; cv=none; b=CiiGhhDbIThoOp+R9JwJ9sHOsm3mdLjGv208jwQPMGjUGi7hsqhgKvAKGWL/o1Ndr/piGVKAB0uI+5B9wBUyU/YPkztjNE+yb2JqED9aQ9bL4ILFFAsl5bYTadiM1QE22l4SFC6LaXBqLZM64vNcJU02Axc/cGOI+qdO7gl8hn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855045; c=relaxed/simple;
	bh=chQz73w4sDaVm3u9kl7kGYcKIA2cugXbhH5x61ROvUY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BA8bmB637VhVIAG98Q/ZkiTQy03qbrDi0Y6uTtbk2eMLD3A7hdk4hcU6euQEMyfR5YOEn7n8GSzCThTEhMrTFrQQgDthVRXRSSbseE8yHIstpUYT5Rq/U9bb6GUQNngPonuX8+YMc6Y/cxLpeL/vZbOf8T9/rmRlPnCKEkFhD2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cTrswdSe; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cTrswdSe"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b6cf50cbd2cso1630755a12.3
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 13:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855043; x=1762459843; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NXaPi3MoPrN4063cnb5uQMVDinJuo4gq6tPJoc7Otx0=;
        b=cTrswdSettzgvD3HkJrl+kJ+yGaDWfIosd6JGohnGmDSjGoMZmfR8VfssVfiZEaMgI
         6Emms3V/sM2qId+HR/IQ2lXdrDXayKlchoAwv33pMA8AjMS93aH/INBADclZ9HNkwNGe
         S+VX3IhWVwXiakIwxYnRVFp+MgDs3tLFwHr2BHl/F/udHo02qSmV34YSZTnBHvJbGSSk
         2ILcBVOj0lvyA9JBKjtFCjmYwAwljrE2bamxmOvKQyGNn8/AMI7VzZg+LpgnchVa/LFe
         WcYMbpgp98OkEXmnpVN5eH7aYPKWtVMnmUWVbI6SKXlesDyJ3SlEKaIIikifBFNAf//x
         sv4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855043; x=1762459843;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NXaPi3MoPrN4063cnb5uQMVDinJuo4gq6tPJoc7Otx0=;
        b=d5Q8+CgIaAxDUFEqXpRkg8fZ17Z8/mV9826ZFkYdFky0TytirdkhJeK+Eo2j7zCeOM
         JNCfHXEZmS8pML/HYIAAYXPjFt320Mjllj9p1lYgM28Xg1Vpk/WUsJpM2D8iECzUWInz
         /ZIEq0/jDeJkMWJ/nojilibiNUT/jUXpcyEtQ5gECYZE5h8Suc0INBGN1umGQqt/rL2f
         dinnj8g07O2EmUUHolgm+eziMr65ekt8PL5itFdxMGauMd9eY75wJ5bqpc3w6ZV+ra7g
         oNAiXfO1N8gZhRmneu8AA0k8PVog83wMI0tYYQU+M+MU6N8ihln+712zWIVHKnH+PSVm
         Nv+A==
X-Forwarded-Encrypted: i=1; AJvYcCWnqrEMxpffUfLmMYc+piUBPzdlVK2odWzrOzGfD2nJGXa2rrp1OXz1OLV9rm3sybcVUGJsdR0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCNtKx1i8ORNWBLpmDsjOvEE2ZOJkpg4asuX/ouXcGJLy3q22a
	LAQl9rgWJ+kOq49AewmXFzWKpii3Goz85OZsj9rMm3KQAUB7qvckcAig0yTlcUpOEPSBOkwDA8N
	mZv7FXw==
X-Google-Smtp-Source: AGHT+IEb/219Cf+wyRyoeh6pXELuzrJXroky0oVjoU6kkNSExiZe/MRoYQlDKXB9iGMeGWIkzSQ16EMgROI=
X-Received: from plrs24.prod.google.com ([2002:a17:902:b198:b0:269:b6ad:8899])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e5cf:b0:293:b97:c30b
 with SMTP id d9443c01a7336-2951a3a6519mr12248475ad.9.1761855043356; Thu, 30
 Oct 2025 13:10:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:40 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-18-seanjc@google.com>
Subject: [PATCH v4 17/28] KVM: TDX: Fold tdx_sept_zap_private_spte() into tdx_sept_remove_private_spte()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Do TDH_MEM_RANGE_BLOCK directly in tdx_sept_remove_private_spte() instead
of using a one-off helper now that the nr_premapped tracking is gone.

Opportunistically drop the WARN on hugepages, which was dead code (see the
KVM_BUG_ON() in tdx_sept_remove_private_spte()).

No functional change intended.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 41 +++++++++++------------------------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index cfdf8d262756..260b569309cf 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1683,33 +1683,6 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
-static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
-				     enum pg_level level, struct page *page)
-{
-	int tdx_level = pg_level_to_tdx_sept_level(level);
-	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
-	u64 err, entry, level_state;
-
-	/* For now large page isn't supported yet. */
-	WARN_ON_ONCE(level != PG_LEVEL_4K);
-
-	err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
-
-	if (unlikely(tdx_operand_busy(err))) {
-		/* After no vCPUs enter, the second retry is expected to succeed */
-		tdx_no_vcpus_enter_start(kvm);
-		err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
-		tdx_no_vcpus_enter_stop(kvm);
-	}
-
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
-		return -EIO;
-	}
-	return 1;
-}
-
 /*
  * Ensure shared and private EPTs to be flushed on all vCPUs.
  * tdh_mem_track() is the only caller that increases TD epoch. An increase in
@@ -1790,7 +1763,6 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
-	int ret;
 
 	/*
 	 * HKID is released after all private pages have been removed, and set
@@ -1804,9 +1776,18 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
 		return;
 
-	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
-	if (ret <= 0)
+	err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
+	if (unlikely(tdx_operand_busy(err))) {
+		/* After no vCPUs enter, the second retry is expected to succeed */
+		tdx_no_vcpus_enter_start(kvm);
+		err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
+		tdx_no_vcpus_enter_stop(kvm);
+	}
+
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
 		return;
+	}
 
 	/*
 	 * TDX requires TLB tracking before dropping private page.  Do
-- 
2.51.1.930.gacf6e81ea2-goog

