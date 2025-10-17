Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE2129A9CD
	for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 00:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661199; cv=none; b=tnlNCyb9GJbxHTEHVNaIUeELr67ac0pjKkE2rs85r9iUtsN+LCBGdX2uk6u82bnOrwslhxjUFDjQasAD9vVxhVQzNry7KOR8N3BjbPOw0cJFQfpLaAg/wWhROHi2wz4B2YfHz7F5MTwQZvqXJ64TIzeHe0X068BGHblmhSQMDGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661199; c=relaxed/simple;
	bh=NWFHLZ0jbzvVfPfe8vtwcPHvovnjfevJyNbSF69oZ6Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IhGkN9C9qlwh+oLA9hMm/7n76o+fIxgqNn1bx3iatoqX1tZDMp4vSePHgEtL3aFbRUh2wM+bCiF9VWAb3D4nbZL3Ki49FazMosHewv5vaZLvJC/GpDjnLZTTBZYJltC7st+2+Vw/dthI6/K3wPf/qfkQaYkv6LYU/LIcVcwdVG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ucRgVAIf; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ucRgVAIf"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33bdd0479a9so102966a91.2
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661196; x=1761265996; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WBWRMN6X3w3vTrUF8QjNUM8q/tVPNzKCX5eXLQ+Uu38=;
        b=ucRgVAIft7m3v0mGFhPXkoXY5ED39RlMQaHUSIfm7TJxjGU3OAJ0i7srCc9TtNNdTP
         0vTOuZLXxlwb5xS6rikh8edfev9f0YbZMAp+wu+tj1a5HVk6L/Sr7iDSYKNbuEZ9GgBz
         Y15yg69irdh9qljdOaxWPiMikyyCmIe3Abj4GsTsI5aTVUEKF+8ZIzbhdVufeSDTv4Vc
         aRruniZsYblpA2IwL0rZ3gcE9hortScYA5JlK6v31XipseToL8xMMIDPU8akQ9955O9S
         SImh2jSwj8w64psq5V01ykjdh0pnzwuDtNb4HvOtCMmoHQjA3I8QEQM79hwclNqEwIQF
         hOEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661196; x=1761265996;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WBWRMN6X3w3vTrUF8QjNUM8q/tVPNzKCX5eXLQ+Uu38=;
        b=gsLKfCuu/T0NKqoJpJDhDMnva4aOUUxxNYZJnDNtoyZgCv++T5XQi6v4bSrgQvk9Xc
         YWiilizIWDdHQKvwsLgcADvOGYu5Irveo3dF8ntup/AdqkRm6EwYbKwnJMxDFoImObPI
         pMN4MSexdBk+XeVM46sNe2/2aD7JSTfHf1Xguw0Bb+voANkJLXxle37TbiNhKkPRr6Nn
         dJlmMt2Y9Po4mMzk4KSmHVVVHBKmTwOWqIV/yHAQPT0PQgPgtUlNT6w1Ebjtp/Nj2T+r
         BuknoIV+nnEJxcfaTdsqpyIoVmYX9BsX/CHJDBshrXaUo8igQAm1HVjnWyQI7lYHMu7X
         pnGg==
X-Forwarded-Encrypted: i=1; AJvYcCUKy3DOdvM8kQF6TRvO9DG1s2iaUI4Y+Ia/+YyQy53uham2/evWXg+0WL5D8f8Mr3bCK2i3ruM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxb30guLk4Kh6d4ABHH0c/ISWXWNZrxFDEI4Y3fD2mD+c5RQLoN
	ITwSwgNTdethJXH10DM97No5t7JKwGdjwC0twfbr5Ngl8YGPmwTMcpxn8GOWOTwShn4+hKFHbTZ
	l7z4rSQ==
X-Google-Smtp-Source: AGHT+IH07aQeXAQe/gpM4oI6RLK2u3p52mKtLGzZsiMbsodE1gcNl3/aTBVcK7Ae83foyLaxFhiKihoxiME=
X-Received: from pjbpt2.prod.google.com ([2002:a17:90b:3d02:b0:329:e84e:1c50])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c2c3:b0:32e:4924:6902
 with SMTP id 98e67ed59e1d1-33bcf85a829mr1565388a91.3.1760661196491; Thu, 16
 Oct 2025 17:33:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:34 -0700
In-Reply-To: <20251017003244.186495-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-17-seanjc@google.com>
Subject: [PATCH v3 16/25] KVM: TDX: Fold tdx_sept_zap_private_spte() into tdx_sept_remove_private_spte()
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
	Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Do TDH_MEM_RANGE_BLOCK directly in tdx_sept_remove_private_spte() instead
of using a one-off helper now that the nr_premapped tracking is gone.

Opportunistically drop the WARN on hugepages, which was dead code (see the
KVM_BUG_ON() in tdx_sept_remove_private_spte()).

No functional change intended.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 41 +++++++++++------------------------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 76030461c8f7..d77b2de6db8a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1679,33 +1679,6 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
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
@@ -1786,7 +1759,6 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
-	int ret;
 
 	/*
 	 * HKID is released after all private pages have been removed, and set
@@ -1800,9 +1772,18 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
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
2.51.0.858.gf9c4a03a3a-goog

