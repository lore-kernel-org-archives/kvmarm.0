Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A134E380855
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 20:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855023; cv=none; b=uw1YoqqPOZ1DMN4PBRXfsMsMtOf8TICD7S+i/2Rx3HKR+ZNNLMRW6t+AHIBatjrtPJbnsNSGt40eGdmi16zKCqvN1zDWcFiZPmuUVU+NOOSZKM3zcBMdKFK8BOyyMiP10UV3I4a4InUioqW0IcIK1p42lIyWoKiB8R3dOFJ6FSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855023; c=relaxed/simple;
	bh=87HTkxfpH+H+Satg8RfgeECqCHrMVmRmSND+z9d7i14=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nS3r+bANYq9QMfpRjn+1I4hFlWyNbfdfHvRTFIKiT4/ZEzkbUm+QNg9K8G2lOrsIWByaGCUtMoh8GC7oSgNvat5wxDakYsYUV/c0w9KH/ggFcfPe179fgaynLByrilpTlixzLK70Vb5O/XnqBe1NDYpS6j0QmJF+gMrAXW2sN24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3DsFTT9V; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3DsFTT9V"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b522037281bso968743a12.3
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 13:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855021; x=1762459821; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=l9YJv18Ob5fRSYpWoHOBPRjxzgmHk89rOMKnw0Dkb6I=;
        b=3DsFTT9VLSGGttUgHU8BRkAWl4d3IiHc9BVMxJPpFL3wEPYptVMUx45pgC9x6hBr4p
         XM61EvqMb5X8IMSeNaGAZ+I/ICEiRf8msfd0sFTzZ9E00c6ISwnv5VUVD0Y8BYs8MpIC
         z3UHMd8KbaBiByqQ1aQLhdbehE+mbru52sKoFKbcZ89l5Fgjbam0/PkuhmUpqljNctzV
         eJFwi4fzE3ku8ypENOsBVLxB7XjUTqO8P7bgF9vDOMgFTnpoZ8CODlZLjNabW+ki1dd8
         ftufI8qmCxtSGwbf0SjqBR7uIHQfFRvSSmHIOO75/OonL7sMpB7SYwG77D85ezzCA3yY
         CZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855021; x=1762459821;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l9YJv18Ob5fRSYpWoHOBPRjxzgmHk89rOMKnw0Dkb6I=;
        b=wy6jnUhINbJHAHbeTjWJ0XhfAph92YSus8s1d/S0GrAd5MwRWSccm9zihSC8Te9cHF
         de3Sc1EK/DvRyWMTFiwFeQwwp7ZR+ctXkTb1nNERtc2VITOworinJobMerthl1slnVVQ
         7UfUQgXy9ApsCcTyVfW7wrq7MKCp8nPIZFUpD+DZWZkHVmA2tEGUOQKD6gnLc1Uu+4fK
         5SCyTSN5VJw9AOttw74VPYAOHik2XwpnpjNQN/pB59s+ykm2i+JkehE0Ytx1fnF4cRUB
         XnPNESt6KEv5kOi/ItxKH9M91LG/Kbl6cKaa/isQBISz8QEdsNV0pmzU6/x1EdA6RkCJ
         MwPQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+lX2JdF5hxhE/VLRS2b2ukCNTeLe49nFODdkhHuIp/L8kqHioKQPZtAyQo88uIgJA6rWQimo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxalzIrCaTc6pSJ7k9r8Iv1rJXrQ3V5M8LpZfkmyyYalX4K6oAv
	BSz2H8QZy5i0YE+kommdFGkauQ72j8boWvZ6JDY/PS0VuGzx53NgBq4eExV2VNunlvsGI3rDdJV
	Kpyw6BA==
X-Google-Smtp-Source: AGHT+IG+gFwz9Ni5D6YjNM4YmwfrZ1OxqSQdFqNs3bWhzX+cRsNM16o/ggLOmTawQXyQElnAsV5VYAZIDy0=
X-Received: from pjvp23.prod.google.com ([2002:a17:90a:df97:b0:339:e59f:e26])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4e83:b0:33b:c5de:6a4e
 with SMTP id 98e67ed59e1d1-34082fa592cmr1221665a91.5.1761855021014; Thu, 30
 Oct 2025 13:10:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:32 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-10-seanjc@google.com>
Subject: [PATCH v4 09/28] KVM: TDX: Return -EIO, not -EINVAL, on a
 KVM_BUG_ON() condition
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

Return -EIO when a KVM_BUG_ON() is tripped, as KVM's ABI is to return -EIO
when a VM has been killed due to a KVM bug, not -EINVAL.  Note, many (all?)
of the affected paths never propagate the error code to userspace, i.e.
this is about internal consistency more than anything else.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c3bae6b96dc4..c242d73b6a7b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1621,7 +1621,7 @@ static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 
 	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
-		return -EINVAL;
+		return -EIO;
 
 	/* nr_premapped will be decreased when tdh_mem_page_add() is called. */
 	atomic64_inc(&kvm_tdx->nr_premapped);
@@ -1635,7 +1635,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 
 	/* TODO: handle large pages. */
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return -EINVAL;
+		return -EIO;
 
 	/*
 	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
@@ -1658,10 +1658,10 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 
 	/* TODO: handle large pages. */
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return -EINVAL;
+		return -EIO;
 
 	if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
-		return -EINVAL;
+		return -EIO;
 
 	/*
 	 * When zapping private page, write lock is held. So no race condition
@@ -1846,7 +1846,7 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	 * and slot move/deletion.
 	 */
 	if (KVM_BUG_ON(is_hkid_assigned(kvm_tdx), kvm))
-		return -EINVAL;
+		return -EIO;
 
 	/*
 	 * The HKID assigned to this TD was already freed and cache was
@@ -1867,7 +1867,7 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * there can't be anything populated in the private EPT.
 	 */
 	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
-		return -EINVAL;
+		return -EIO;
 
 	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
 	if (ret <= 0)
-- 
2.51.1.930.gacf6e81ea2-goog

