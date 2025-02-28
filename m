Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E4B26138F
	for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 10:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740738365; cv=none; b=PGjvF+TsGiEHl3etOiDEeQmNtxZHYV7/EJYUh9/iwpHBi13G8cOOoLoZvrL9TajaUPH9gzQtswTTQvgJij4ATBNfppyJnbK2m83Nm/WWMtN0NYz0Yt69/edGpvuVga5BNxOR8Uj/saGkUnuvVeJf4WjZH4fi8aUENHuCOtTjhlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740738365; c=relaxed/simple;
	bh=wBKVapIrznQwAOlM6sIqN9ynrRTg73Po2MAdoOcT1v0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RDSHMrITE9/vDUuC8ecX95LBqe3ozjzDCcziMWOjnFCu67R5gWP8pSG7dxufH9lPB/pDz+FkH6rP5huQ4EH/jHTWYqnNqKyBT99O7Zf+f5SsAIPxXgBTrBoJBYAlUSeWFPCh++EV9CrTYtvuON7pA1LbwKvUQWceC8/37CekBBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JY3p8Y8d; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JY3p8Y8d"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-38f4e3e9c5bso832216f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 28 Feb 2025 02:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740738362; x=1741343162; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kBFHvME4v7wAoT7habVFSIRXDLX0Fgacd+7YWwIrSSE=;
        b=JY3p8Y8dw2UgJxUmSJjlWMS/aKSTqLalMbuWwwRj8IN9xN+8JifHnSac6k5N6PnBa1
         zoAw//IITlUu9+MPsSS76Jsb0q34Rp1SsMYJQ3MdJRAFFjyFuNt1ZZ0mahqzXiw/XWR/
         Gy0D1TfGb2678AiZRQyquXkk6MyN5z07NpXYjKJGrOIe3rIp9l093VZqWFWPYbZyFGSt
         MZGurfh1CkYCBwTThH8rzc8IF+4KUGtm0+OxqJ6OhyfDtDIdAIJmzjhb1m2n/PCA6BGe
         keEyzjJv6oICy2EfLWsfY2K/H/jngban7QyWXQZHQ45xi8A/rOU3BJmeS3N2vCcCFzMr
         W1hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740738362; x=1741343162;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kBFHvME4v7wAoT7habVFSIRXDLX0Fgacd+7YWwIrSSE=;
        b=EhDcmBb8q7pDKgH0ktYmJo0W1HpNj360sLzl/JtEGGjw1NKW2uAs7ljTj5bQdJfhj2
         Qn1IbrDzLcXIDC1Nf4hLhFtzgsatz+g+bQx7ukk9b8TOSzlj1seqJUQBBtj6c16/tkH6
         oMxBKjL2SPx1rPEmhEh8BJFWLg0i59Gw18F9QaLPBQdftiNep96OT2lmfBA3WC996AmV
         Bnwxzwm8kpFGe04XwqFdc2H3Wun6rfHKB/4Km0qsmqcFsCgzoKZUiXUR9gB3orx2vM2c
         8LW2RoP1YrzRGNQtVlbookuNKMoYMEXV6IUuGBStU1fI7YgIh45ZycpJr+rjVucbEPIT
         XJwQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9ggR5+o2rksQvnwTiuKmoLpEJ7GfwLpjGSaXOf29cQs5wJRJhu1h6MsDjAL+ZD3EQcglNM2g=@lists.linux.dev
X-Gm-Message-State: AOJu0YzUdgbVmRHBiW95zfM4f5KvN24bMy3N7a0xJP5LRHx9CcsyEcKs
	z7Q5/7+fFqt64vwjldQoBi8gT5rudY2ihVX2DQc1sVLtJOoogh/lmTxzYmS86Gf88zWitFaQwaO
	nQc+vVmuP3gPcdt1Z7A==
X-Google-Smtp-Source: AGHT+IEwHls1BLgdvt5KFxyshaKSutUV2RLW38Q+fbEdSBaFOyihQeFxU0qCKw+zxyowZaUN4jkoWQg3AuWNfSEu
X-Received: from wrbce9.prod.google.com ([2002:a5d:5e09:0:b0:390:e493:b594])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1a8d:b0:38d:d0ca:fbd5 with SMTP id ffacd0b85a97d-390ec9bbc4cmr2282409f8f.22.1740738362092;
 Fri, 28 Feb 2025 02:26:02 -0800 (PST)
Date: Fri, 28 Feb 2025 10:25:24 +0000
In-Reply-To: <20250228102530.1229089-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250228102530.1229089-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250228102530.1229089-9-vdonnefort@google.com>
Subject: [PATCH 5/9] KVM: arm64: Add a range to __pkvm_host_test_clear_young_guest()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

In preparation for supporting stage-2 huge mappings for np-guest. Add a
nr_pages argument to the __pkvm_host_test_clear_young_guest hypercall.
This range supports only two values: 1 or PMD_SIZE / PAGE_SIZE (that is
512 on a 4K-pages system).

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index ad6131033114..0c88c92fc3a2 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -43,8 +43,8 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu
 			    enum kvm_pgtable_prot prot);
 int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
-int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm);
 int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
+int __pkvm_host_test_clear_young_guest(u64 gfn, u64 nr_pages, bool mkold, struct pkvm_hyp_vm *vm);
 int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu);
 
 bool addr_is_memory(phys_addr_t phys);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e13771a67827..a6353aacc36c 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -335,7 +335,8 @@ static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *ho
 {
 	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
 	DECLARE_REG(u64, gfn, host_ctxt, 2);
-	DECLARE_REG(bool, mkold, host_ctxt, 3);
+	DECLARE_REG(u64, nr_pages, host_ctxt, 3);
+	DECLARE_REG(bool, mkold, host_ctxt, 4);
 	struct pkvm_hyp_vm *hyp_vm;
 	int ret = -EINVAL;
 
@@ -346,7 +347,7 @@ static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *ho
 	if (!hyp_vm)
 		goto out;
 
-	ret = __pkvm_host_test_clear_young_guest(gfn, mkold, hyp_vm);
+	ret = __pkvm_host_test_clear_young_guest(gfn, nr_pages, mkold, hyp_vm);
 	put_pkvm_hyp_vm(hyp_vm);
 out:
 	cpu_reg(host_ctxt, 1) = ret;
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index c273b9c46e11..25944d3f8203 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1110,17 +1110,21 @@ int __pkvm_host_wrprotect_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *vm)
 	return ret;
 }
 
-int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm)
+int __pkvm_host_test_clear_young_guest(u64 gfn, u64 nr_pages, bool mkold, struct pkvm_hyp_vm *vm)
 {
-	u64 ipa = hyp_pfn_to_phys(gfn);
+	u64 size, ipa = hyp_pfn_to_phys(gfn);
 	int ret;
 
 	if (pkvm_hyp_vm_is_protected(vm))
 		return -EPERM;
 
-	assert_host_shared_guest(vm, ipa, PAGE_SIZE);
+	ret = __guest_check_transition_size(0, ipa, nr_pages, &size);
+	if (ret)
+		return ret;
+
+	assert_host_shared_guest(vm, ipa, size);
 	guest_lock_component(vm);
-	ret = kvm_pgtable_stage2_test_clear_young(&vm->pgt, ipa, PAGE_SIZE, mkold);
+	ret = kvm_pgtable_stage2_test_clear_young(&vm->pgt, ipa, size, mkold);
 	guest_unlock_component(vm);
 
 	return ret;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 3ea92bb79e8c..2eb1cc30124e 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -434,7 +434,7 @@ bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
 		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
-					   mkold);
+					   1, mkold);
 
 	return young;
 }
-- 
2.48.1.711.g2feabab25a-goog

