Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2116D2BD59A
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 13:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648844; cv=none; b=pRccVrGcHAVnrrNbAnfmXvbuPsn+R7HL7aYGJAVn7Uo+RuMweaRIGWsYPW5ItUU0O5MCeJ29wznbJVhAmRFCaX+leSWwDae3KYhP/9I4Pi4BN4erStolF91Vy0F3ybe/iOvbBpe9683bL4eZOPQTniGm6vdKC/2eelQR9arE4T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648844; c=relaxed/simple;
	bh=hLE89x3YTQ4DTY5U2WYbKmaFGiAV0EEuWKrUIRjgeDA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=el4VE/JrrcV+PHB4L81Iup7PAGlZujnuBovDcNTusxucJZ0dpTo1V8A1k5PcJQ/tKP2H4+blvJXO8/U8SSSsUMeDSw3t31L5Sx4IwxL2UvtABQF7oKTCwFmi55vW39MW57UgD8kIqtVr2wjoN5bcI1eKvadmocW+h6vrPZUJ68g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I3ZclZn/; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I3ZclZn/"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45311704cdbso18689005e9.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 06:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648841; x=1750253641; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=29LxTesP+esrl3s+kJyR+R34EjmdYlvjhl4IkCQVBdM=;
        b=I3ZclZn/vkUGyUtbLfHx3L2IWh82zpS+k8hIZ5ue/5QZQmMTA3486W2k6gi0+aGUGc
         qoLEKoXIq0Cj0i/oWcIR8SKxPiXrTQN7VNWWaUuWQ2d9UfGqUJvdLI3LcGhWb5SXrmFM
         jSXaeF5NonyHMcwocNihm4RW2J+0UeZgTP4Cy3YQJIicGBaU6rc79UOT+bqg6Ja5Jc6K
         gLJpIhN0tVcG3l2DYo2/HgEfdJt689zoq/JMV3UyaYtjPdegIo4f7c2LQfe6asMRxgjz
         o7HXkD7Jf6+fRPR6zERZEOLJb3fov5KIneJWeLL2K6Yb5qD8yFcwWG5RbJtfJ/+caE1h
         ryYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648841; x=1750253641;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=29LxTesP+esrl3s+kJyR+R34EjmdYlvjhl4IkCQVBdM=;
        b=UgR2WcW8tcPEuPORj2Jcvv8lkMh7WkMfil5njZGAS+Z1jJYd0eWCO9edb1mwkmzDnx
         dq5DgdrJkK1x0ZAIESo/j1qEjXQqYXafTbnDSQ6EZuQfLOWMSZ/IZDNKlTgLTXV8vRzR
         Lzr8+d1M/FE+xxd01McrKh2Xccg6sZ0gClN4lAox1SAPG5nm+S1nnH+qHqr+brbhjv2M
         +RpXWZsyEvpfAWwVRka1NB6RE9j1VJ34YtOkCDw5teL/VJDWA42d7ZSk38S46E4Krks2
         CsCJ5Rbv8bArcEqq3Digqk80hAPHSAUtBhTy893v/rvRtQ/+cd0j7xVU38vY1SwTCNnJ
         IicQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZPR2c7zxRXwnYfr2ndW1WJn6rjIARGjVQQi2A+sPrx7vXkf95kBjUI+ygOTC1Gy2uRI4kBhE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwMI1OfdOqdPzZsvNQhi2Lq4ZlrqHgHNCEvtn4GctXnbcQsBnjj
	ROXRMkdp/7GdJm9udtYN2OroMShm4TfhqrD0P48axLH/+19NsrruF0zOtfWkO4XqZ7tMk/cfxtJ
	ezQ==
X-Google-Smtp-Source: AGHT+IHGBYLvYqL0QA4258S7dEzkQ3lLJOuhLe7Oixu/fDL5tnHuJueVLFJw+pESXsx9Yw1BzHfTKh4YYA==
X-Received: from wmrm7.prod.google.com ([2002:a05:600c:37c7:b0:451:f443:5948])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1a8f:b0:3a4:cfbf:519b
 with SMTP id ffacd0b85a97d-3a558a31311mr2924191f8f.44.1749648841359; Wed, 11
 Jun 2025 06:34:01 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:26 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-15-tabba@google.com>
Subject: [PATCH v12 14/18] KVM: arm64: Handle guest_memfd-backed guest page faults
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Add arm64 support for handling guest page faults on guest_memfd backed
memslots. Until guest_memfd supports huge pages, the fault granule is
restricted to PAGE_SIZE.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 82 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 79 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 58662e0ef13e..71f8b53683e7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1512,6 +1512,78 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
 	*prot |= kvm_encode_nested_level(nested);
 }
 
+#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
+
+static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+		      struct kvm_s2_trans *nested,
+		      struct kvm_memory_slot *memslot, bool is_perm)
+{
+	bool write_fault, exec_fault, writable;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
+	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
+	struct page *page;
+	struct kvm *kvm = vcpu->kvm;
+	void *memcache;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+	int ret;
+
+	ret = prepare_mmu_memcache(vcpu, true, &memcache);
+	if (ret)
+		return ret;
+
+	if (nested)
+		gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
+	else
+		gfn = fault_ipa >> PAGE_SHIFT;
+
+	write_fault = kvm_is_write_fault(vcpu);
+	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
+
+	if (write_fault && exec_fault) {
+		kvm_err("Simultaneous write and execution fault\n");
+		return -EFAULT;
+	}
+
+	if (is_perm && !write_fault && !exec_fault) {
+		kvm_err("Unexpected L2 read permission error\n");
+		return -EFAULT;
+	}
+
+	ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
+	if (ret) {
+		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
+					      write_fault, exec_fault, false);
+		return ret;
+	}
+
+	writable = !(memslot->flags & KVM_MEM_READONLY);
+
+	if (nested)
+		adjust_nested_fault_perms(nested, &prot, &writable);
+
+	if (writable)
+		prot |= KVM_PGTABLE_PROT_W;
+
+	if (exec_fault ||
+	    (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
+	     (!nested || kvm_s2_trans_executable(nested))))
+		prot |= KVM_PGTABLE_PROT_X;
+
+	kvm_fault_lock(kvm);
+	ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
+						 __pfn_to_phys(pfn), prot,
+						 memcache, flags);
+	kvm_release_faultin_page(kvm, page, !!ret, writable);
+	kvm_fault_unlock(kvm);
+
+	if (writable && !ret)
+		mark_page_dirty_in_slot(kvm, memslot, gfn);
+
+	return ret != -EAGAIN ? ret : 0;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1536,7 +1608,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 	struct page *page;
-	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
 
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
@@ -1963,8 +2035,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
-	ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
-			     esr_fsc_is_permission_fault(esr));
+	if (kvm_slot_has_gmem(memslot))
+		ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
+				 esr_fsc_is_permission_fault(esr));
+	else
+		ret = user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
+				     esr_fsc_is_permission_fault(esr));
 	if (ret == 0)
 		ret = 1;
 out:
-- 
2.50.0.rc0.642.g800a2b2222-goog

