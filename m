Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCD8153509
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618298; cv=none; b=GMBtT+u84tGSTpuQ0J2vYObXUvsPl5Y0Y03I0OiZRFjxeUSDPYKPQtDyDNuNx/jw4pvDUW9RQaPRS3ELRiq7uD+srmFRuK2/2jjZTOQWEbaAfPVgXI7WuJD1Bd4bxsdP1BvJL8t8amPGYLbzo944mv0TIhcPG0vyVbxN3eRqAJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618298; c=relaxed/simple;
	bh=nTT451MK9nqQ4YWzBZVTCbpcJQT1VtoD4cFMq+pB9Fo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QXF1IN+sbwVP+r7FdQK16fYXZ3e08Qz62j5LsyHmtVU8wZcLgodF0wbEsmo2j8zOPsTFatphHqQe6lY3izlA6pU/AX8hKv9GnrLNRHxPc70sbPNJmY8ikyLQtreYBquUbm3On71RR+riD7G6Ax+Yy7mHnCxHSjbOZBcyPOuqIkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CorxFnfu; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CorxFnfu"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-608ac8c5781so5536767b3.3
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618296; x=1709223096; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=44YDOyWwKyAbTtZNyJPOfML3d7OrKnTF2BVZ5qdD/Y4=;
        b=CorxFnfuZiLqc+2E3Kq45FtA8oc4GbkuQSQ0LtgmwRqjnjfarnqqIJo1O9BFgblUfb
         C0LTK5Qmj1NbkJAAhKpgCRr3ecDcVf4CNKCuv5avCIYhSBGInvXV3WurcjNGj9JDAw5A
         FKkk5Plaly0T4sG8WXB/szGrT9ZUrdY4Up6BP2xVQEU63EYLm/wd1QVs8cLVPLS0+vBH
         tV6j9VoWB91yT2YBLO84wz8LUnx4eUZXDQmSDmPw2gY5GVwrvGLQ95ED4vJQqBj9/r6X
         Qb58mJ/q6e2VSbyjBJbFGKgG5x8I1NuHpKo4Ed5Oe8619GujNwI2x0m6gRBfkUUMGcoz
         lWaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618296; x=1709223096;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=44YDOyWwKyAbTtZNyJPOfML3d7OrKnTF2BVZ5qdD/Y4=;
        b=GrgaGNENELkgsZkFD695+V1xTJZl3PNl9C9SyKZ+t+XZ1uPLH0A+Z0x45fpQvVJ66O
         +ia5MlzfqpfMTJORkjQHcXJrA3IooYAznvwAACjYpMdaxBNRxHLfY0niLDzNV2btY3kd
         I4zMWoSuveK4Z3ByU1ALNmiBOpnZMbUAmgJWsPX3KuY9zRsNW+tFUJ3eIvEzeskB/3YI
         OqSt/BpebSreZVgssaE0N97NozjsDCYPned2OuEXf17BdagEoSpF3i5BwbcfmtO8DEGf
         /ncsfpZqiG9oyby/dDeypyF743aft8P61UZBxwiGg22MRGTgN3QXK0wb01cdrAR6hSkF
         R5hg==
X-Forwarded-Encrypted: i=1; AJvYcCUswmZLdUIhqhP1HO4PJmcINI4qcEcCWWflIp1coObZMORVs0+h2m+RDzf++wf7f0FUUn9ukw8iSBv+Fi28tef7EfPog6YA
X-Gm-Message-State: AOJu0YzNLyEI3h17xTVQ290ufCda20EQWH2XDrbzypdmgmYT8c4FHl2M
	95CfXBF4hHnc84xxZkoD9ohfSBx4IUQuwh9KvsYhdhimQDnKmFW78WRChlNRjYRk2QmH4Mc5Yw=
	=
X-Google-Smtp-Source: AGHT+IGSVaKOipuo5nEuK2BFQGFWFHzZjQM3r5na2j2eYUT9prmtDvr4Dcs0caaHYzVHBv7VuCNQ4diSag==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:f101:0:b0:608:9758:e8b with SMTP id
 h1-20020a81f101000000b0060897580e8bmr613308ywm.8.1708618295659; Thu, 22 Feb
 2024 08:11:35 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:40 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-20-tabba@google.com>
Subject: [RFC PATCH v1 19/26] KVM: arm64: Handle guest_memfd()-backed guest
 page faults
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Introduce a new fault handler which responds to guest faults for
guestmem pages.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 75 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 72 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6ad79390b15c..570b14da16b1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1438,6 +1438,70 @@ static int insert_ppage(struct kvm *kvm, struct kvm_guest_page *ppage)
 	return 0;
 }
 
+static int guestmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+			  struct kvm_memory_slot *memslot)
+{
+	struct kvm_hyp_memcache *hyp_memcache = &vcpu->arch.pkvm_memcache;
+	struct kvm_guest_page *guest_page;
+	struct mm_struct *mm = current->mm;
+	gfn_t gfn = gpa_to_gfn(fault_ipa);
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_s2_mmu *mmu =  &kvm->arch.mmu;
+	struct page *page = NULL;
+	kvm_pfn_t pfn;
+	int ret;
+
+	ret = topup_hyp_memcache(hyp_memcache, kvm_mmu_cache_min_pages(mmu));
+	if (ret)
+		return ret;
+
+	/*
+	 * Acquire the page lock to avoid racing with kvm_gmem_fault() when
+	 * checking the page_mapcount later on.
+	 */
+	ret = kvm_gmem_get_pfn_locked(kvm, memslot, gfn, &pfn, NULL);
+	if (ret)
+		return ret;
+
+	page = pfn_to_page(pfn);
+
+	if (!kvm_gmem_is_mappable(kvm, gfn) && page_mapcount(page)) {
+		ret = -EPERM;
+		goto rel_page;
+	}
+
+	guest_page = kmalloc(sizeof(*guest_page), GFP_KERNEL_ACCOUNT);
+	if (!guest_page) {
+		ret = -ENOMEM;
+		goto rel_page;
+	}
+
+	guest_page->page = page;
+	guest_page->ipa = fault_ipa;
+	guest_page->is_pinned = false;
+
+	ret = account_locked_vm(mm, 1, true);
+	if (ret)
+		goto free_gp;
+
+	write_lock(&kvm->mmu_lock);
+	ret = pkvm_host_map_guest(pfn, gfn);
+	if (!ret)
+		WARN_ON(insert_ppage(kvm, guest_page));
+	write_unlock(&kvm->mmu_lock);
+
+	if (ret)
+		account_locked_vm(mm, 1, false);
+free_gp:
+	if (ret)
+		kfree(guest_page);
+rel_page:
+	unlock_page(page);
+	put_page(page);
+
+	return ret != -EAGAIN ? ret : 0;
+}
+
 static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot)
 {
@@ -1887,11 +1951,16 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 	}
 
-	if (is_protected_kvm_enabled())
-		ret = pkvm_mem_abort(vcpu, fault_ipa, memslot);
-	else
+	if (is_protected_kvm_enabled()) {
+		if ((kvm_slot_can_be_private(memslot)))
+			ret = guestmem_abort(vcpu, fault_ipa, memslot);
+		else
+			ret = pkvm_mem_abort(vcpu, fault_ipa, memslot);
+	} else {
 		ret = user_mem_abort(vcpu, fault_ipa, memslot,
 				     esr_fsc_is_permission_fault(esr));
+	}
+
 
 	if (ret == 0)
 		ret = 1;
-- 
2.44.0.rc1.240.g4c46232300-goog

