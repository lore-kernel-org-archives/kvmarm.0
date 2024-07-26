Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38EB187843
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038081; cv=none; b=oZwRLdJjB1iMsM+u5qSN+n1aX28uU2ounNdtxW6gQjPe/3v0Lm3Hp0QnD5AJxxhTPncbDHA54VviHDlJEajWsS/6+yby7RNCwnTSj1Bciy0IPqRQ+TRfY/GXQRwrnOJpHMzwnzxKi6lxvnP3lLXqFgxq63QteEVLCizVRw+t2GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038081; c=relaxed/simple;
	bh=QKdqSeDurXwkoaj80ZjKrbgXs0BzbdNHTlCFTKbvwVA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mdoGEeaEJlJuQ7DbT7vY32SdLshPJRf4zHLPpSzYn9WClh9/pqRwXKv8uJmo/0j5GGltHFrJIMa8+ldQ7i3j8hXIZFjuZAM6KVSe6YcFqumN6ccKmTCg3PA1JW2OwrTP3OFDMYW+BXSZ8CDRbBJle+OSN1uL3wYISqCVVESdrqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pTre/yDn; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pTre/yDn"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-66c0f57549fso7716077b3.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038079; x=1722642879; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lKpu7mXAQaRbYxbEDOwpqeV9V2sn6fCg4Pm2+RclqqE=;
        b=pTre/yDnrcv3K8BNSy2BCrR5h4HudzyGAoFW82UdPSLh7PCGDLSYEf6J+B4agveiaN
         HkMnO8/4pFiwvEJHvyVEF4YgL06eh/3X8ex8avpDJJuX2rLJ7RUDgAs0vNFQJ/qhxmIW
         eVv2VEU/az+BNSVdhLFHSS+y5WsvpmgCn8s4iJjAxayx6m8lygtaXTA6q8KEQ+yWMjvB
         vPyLVJfza+tYvQyC0vXB4+yAI0OiZFarFnZ5tt93pNPf/BAFdu5OOjYPR2FcS/r+mEG3
         D4K1pJ23kCz9QONYiCknHWu2wWsAXkCcAffo6XBuanvHoKno5XmPZ9XkkJhtb/G3sde9
         cT2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038079; x=1722642879;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lKpu7mXAQaRbYxbEDOwpqeV9V2sn6fCg4Pm2+RclqqE=;
        b=fiAuBUiz4vwLlt8oH02ZtJxXMs2GhPfdS5POydOsC1bKPMVYTT9BrOhjhUI6UYP3IO
         PobQUC5ZZPvKEWwM8ACmOntnNj7y3QwajcnMKyMWT+N8E8VES+rWfklRrIqgp3+KL+/I
         VVMxRsKJau31O5zk1y2TX6v28gk5AtjyesrUuW2aM62gmW+JXd9fcoNKTWSToOHxFfHe
         8DraUZ9wK3Uk+fveav0miw2OLzuqbpmuVtjU7IGJS1CytikDDOM0LD8SntvGrkC62Qm2
         qulXbw5xMpNINVWG8HK6BuLxuPhWDsD+NUGKekUTfehi8cJPaS5k3pOYUu/xL897nnQ4
         sHfw==
X-Forwarded-Encrypted: i=1; AJvYcCUD5XBOvIC6dwemK9h4n45wV9yRR/zAjqA5d4s6woKAwtNjciY88FembobODdqO/yMJiPEyOWj3ipm8k2xag0WwyyO4H6Mg
X-Gm-Message-State: AOJu0YxICxyjDjhZ7TbmuhzP+oFEWllOndjyciXAWp23nP4PCMih0FtO
	De6uvRFRMStwWJuhTCojtSA5qBkVChLf0QVvew8wqxcangDanaFQbHA7XdabWf8yc/6brZuNtLS
	K9w==
X-Google-Smtp-Source: AGHT+IHhzhjU3Z65Ec9zcL96WqENi83QMIcwPrprR++iZTSrPH87Hnrc6/v3lgb0Tgsr4AkAwll8yu22uIk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:ec3:b0:663:ddc1:eab8 with SMTP id
 00721157ae682-67a088f07bfmr790257b3.4.1722038078515; Fri, 26 Jul 2024
 16:54:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:07 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-59-seanjc@google.com>
Subject: [PATCH v12 58/84] KVM: RISC-V: Use kvm_faultin_pfn() when mapping
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
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Convert RISC-V to __kvm_faultin_pfn()+kvm_release_faultin_page(), which
are new APIs to consolidate arch code and provide consistent behavior
across all KVM architectures.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/riscv/kvm/mmu.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 806f68e70642..f73d6a79a78c 100644
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
+	 * vma_lookup() or __kvm_faultin_pfn() become stale priort to acquiring
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
-		kvm_set_pfn_dirty(hfn);
-	else
-		kvm_release_pfn_clean(hfn);
-
+	kvm_release_faultin_page(kvm, page, ret && ret != -EEXIST, writable);
 	spin_unlock(&kvm->mmu_lock);
 	return ret;
 }
-- 
2.46.0.rc1.232.g9752f9e123-goog

