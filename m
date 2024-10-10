Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98441209672
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584820; cv=none; b=YDeI77TqnRTn+WTVlspWAeI7nrip6NnTWLtz0eS9omqqMYHlvsAYS30AHkoQQaZYmI6fun0oEMzO5plsQeHlaNLetgCuG0oTDUrgIk1f9CJ7xs1MMrCn01KTVHTnZvsHorLmIBMbSAd+C7yZd2VT0IVPqU9aunLYaM1HLA4q5fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584820; c=relaxed/simple;
	bh=h8Ty3DwV1uJmCoppjwTeaFXY32gukNMrofdCY+cnYhk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t1Odvhv7V3WbwTIy1+1XLEE8+CK8b6rEmqVxDrGKjn4oHbUF3OQwfU7UdEak6XUBhq77tUzTtaySTtH/Cv5CASNL+VCCsPcQtckHgc0y1LU4MmpZWtUTA8J/DNbUfdYoPlTnrsagnImqeT5gEoeKyd36cV2anGUoU931Ma3HW4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T6Io9c6D; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T6Io9c6D"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-70ac9630e3aso1196104a12.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584818; x=1729189618; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OPPvMTYiUGb6pAXW02Q14XiUF2+KvArosM2sRK6VjAA=;
        b=T6Io9c6DoKcIyjUrCZaL119ZCJwXQ1GVepJvIrk8I0EhtmRv628uvq3RgHi6NOBQDr
         Qrjvo69nPWF/JaW7BotlR745f+sw4YyGJyXTSbT1pJzukHxgkvO74AtajcXRwOCRUhdw
         F3Wp4e05MW+h6BH8MtriQW03xEWIhYZb05MvnMt8Eo0jDOAWd/6xAKfC8qCYXxmykjvj
         5sBkIOaJiJW7fj/13LoQegSArOjeaFaU7IpqbPUiI6KUvZgMCPVSqXU31WXQpbYjazLj
         VtqWJ5o51KuIBweSdcA/Bv/W/XnpriPzd9cmeRpdlIIUej2zS40voDQJmuUfVZXh5z13
         CB9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584818; x=1729189618;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OPPvMTYiUGb6pAXW02Q14XiUF2+KvArosM2sRK6VjAA=;
        b=CeZVqXY5pATGT0cyc2lMZ1mvvj5NppY4zkV9MFdhiD3crv8a0LpiWQ/Ed5PRwwBtrP
         Y/12UKPy35En74Z9gLUvbRX6PgWZpew6bYgwFzfBOefXfduM2tGHL5cok6wv8KIbqXYH
         fRHB4rotnLkqeXVn85Wrt0pXoBfsZbnw3gFYWehml/rg7nW7yMXkd7CatfmhxZApyl3r
         0p3sA8agKNfz5aDmx558/7kCzhb6i7QEXbtrcVH9PX1l22xdgWnTiRJDtuXPHoXExwxX
         ulMttzeoy/r3t/u6jhRjQSfNJsBW3C9fjiVLa1jiX2I7QzYA2kHa0+63+1dpnxiT8CfH
         qyjw==
X-Forwarded-Encrypted: i=1; AJvYcCV12g9/um95ET44+zKSDcGN8HVXtWXDpheftKOwj5N8pbgdJM8jO9GlvxOOk5npKsrUJtR96EA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyiFnSqYs3/HHyXzvPhjBvppJCcMPnMPLP+9crx83gHgnFkI6b9
	OQhCXoFgMaKt8eeWptihOT8dJSoGxf0GfPg8fR3IIqb7DaS+ezD6or1E+e77LTsHdiUfQsLYHfu
	OUQ==
X-Google-Smtp-Source: AGHT+IHVZkXcNH8eDb3GIQubykYaXKWHdrpGe/zHTLQHIjPMwQpAN0ra/QncFunLfkL/hgYZuPxk0qgLkH8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:903:2343:b0:20c:747d:ec15 with SMTP id
 d9443c01a7336-20c747df618mr290175ad.1.1728584817934; Thu, 10 Oct 2024
 11:26:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:01 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-60-seanjc@google.com>
Subject: [PATCH v13 59/85] KVM: RISC-V: Use kvm_faultin_pfn() when mapping
 pfns into the guest
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"

Convert RISC-V to __kvm_faultin_pfn()+kvm_release_faultin_page(), which
are new APIs to consolidate arch code and provide consistent behavior
across all KVM architectures.

Opportunisticaly fix a s/priort/prior typo in the related comment.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Acked-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/riscv/kvm/mmu.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 2e9aee518142..e11ad1b616f3 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -601,6 +601,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 	bool logging = (memslot->dirty_bitmap &&
 			!(memslot->flags & KVM_MEM_READONLY)) ? true : false;
 	unsigned long vma_pagesize, mmu_seq;
+	struct page *page;
 
 	/* We need minimum second+third level pages */
 	ret = kvm_mmu_topup_memory_cache(pcache, gstage_pgd_levels);
@@ -631,7 +632,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 
 	/*
 	 * Read mmu_invalidate_seq so that KVM can detect if the results of
-	 * vma_lookup() or gfn_to_pfn_prot() become stale priort to acquiring
+	 * vma_lookup() or __kvm_faultin_pfn() become stale prior to acquiring
 	 * kvm->mmu_lock.
 	 *
 	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
@@ -647,7 +648,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 		return -EFAULT;
 	}
 
-	hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writable);
+	hfn = kvm_faultin_pfn(vcpu, gfn, is_write, &writable, &page);
 	if (hfn == KVM_PFN_ERR_HWPOISON) {
 		send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
 				vma_pageshift, current);
@@ -681,11 +682,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 		kvm_err("Failed to map in G-stage\n");
 
 out_unlock:
-	if ((!ret || ret == -EEXIST) && writable)
-		kvm_release_pfn_dirty(hfn);
-	else
-		kvm_release_pfn_clean(hfn);
-
+	kvm_release_faultin_page(kvm, page, ret && ret != -EEXIST, writable);
 	spin_unlock(&kvm->mmu_lock);
 	return ret;
 }
-- 
2.47.0.rc1.288.g06298d1525-goog

