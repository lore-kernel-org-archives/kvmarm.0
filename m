Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD64B2FC010
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 21:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810070; cv=none; b=FgNLtbefDggetAXLBej//PDOPLunrzrbczYK2zwnjVCEN+M0n8wGDancf+Env1G5nbz1gIayegBR5gYMVSu5O+smwPwYyZRneDIwCDt4q5y6XpyjO30oXs0kggWoerWDfcIZ2ZMqHBJPuyNt9emii0MRg5RL6HO7oslS+HUxG+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810070; c=relaxed/simple;
	bh=/rGauErIcEbTihd1kj9EqXKbfxEybfai2HJzASnlsiA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XsNqPojaDLsDa3fRWG3fXtFSqV+vI10+iJY4LFnFOYWumPm/LLcH6ZphywE0IMOZ5cupwdX+nqqTsawFsh9GJ2pRTxeeOtAvGPRgD0HIxQJ/raTMal/EVb6EqUDfnMtJSBCp6gc4mHQ43GIeSvZ/WlXEMCJ95f54kznn28iPvpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nOBat8do; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nOBat8do"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2430c5d4d73so30800325ad.1
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 14:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755810068; x=1756414868; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=icfTHb8SQC6RmkA9MWOb7kih1+f1PvZwwwoiEq7I/xQ=;
        b=nOBat8doCB8RjmVw/FCPsiviykc3YwTrHne7zT3zAyFqB4SLUlbpZXnq5WqanaQQvc
         PqN99s23cqBp+WMus37MQt+BxXmL9iPOhI9yLQ4/ZQ4COPD6vQVLI0wmu+pq+hzUzRxk
         Ei6tMA3+QJDtpKm5+Y9+DbRtwTxEhZbOLsFJHzR7T5s+gC7xhmk3w+vqMnT2JBEsUVI0
         KSfK9CdDFA7d6t9k2yoq9zHMjjjG1TXB2P7xxZLOp6cQbIRfHErRpb6K0r6CNaIov5PN
         JQfdqT4jqaLOnzRhTZdyF04Ovt92VmJgZmyFpaZxGyFEph7HNEEh5XwR9ejJpzxiQRMy
         XPNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810068; x=1756414868;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=icfTHb8SQC6RmkA9MWOb7kih1+f1PvZwwwoiEq7I/xQ=;
        b=vN1InE16bL5U6y35cBaivcLwuaPZSO8/eajQ7gYDQZCKuFmSherzphlnfiaLhKLY9Y
         Heci0flE8nxG44dZwJzWXyHspVR9kqj1j0hmq6PiqdNlkngRkWKtnLHA29qgP71M2TFx
         nM18Y8vIAiR4n7v74yaDnsJixE0MHnYroRZFcekJvpcUGQFoTeok+xQhS7CKJzHG1Vv6
         kKgoVKoZhZ9x6J+RLslC7L7R65s/myjQz8mI0zvyMheYDjYWicBKQ2G6GjINFdPsFdiN
         EdKAyAlRD7OgZ+3rhfTB010TzF69mc9Bs520RwsQkhWLojtM9VWko1ooTIe1LspO7PBJ
         bcVg==
X-Forwarded-Encrypted: i=1; AJvYcCVZsAhCq5OxrLjJhRxxoxf3VdQARUt+ZQCEFi5J4j683gDFR3DRtPOIsvjFTk82LoVtdhbWndg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3tFsNWf3WKMkdMC/2VdktKjp1xLoUdpcZuchp/rU/VSr6b/nG
	PuaoMJddL1VZzOXU5+IHH91HhG/h49nRmSZ3xJOC9dWgA15Yc+ZNjQ2NetXjE6YwAe91v9UqIMF
	WIG2hZA==
X-Google-Smtp-Source: AGHT+IGG1PqwX+83Kz6lqMiL38vZquJagXjtigRLo1tbtN6yx1WhHPa1mZrTLmDFk+AuwMqOxdw4+SZNGP8=
X-Received: from pjx7.prod.google.com ([2002:a17:90b:5687:b0:311:ef56:7694])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a68:b0:233:d3e7:6fd6
 with SMTP id d9443c01a7336-2460248450emr47706545ad.19.1755810068184; Thu, 21
 Aug 2025 14:01:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:00:39 -0700
In-Reply-To: <20250821210042.3451147-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821210042.3451147-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821210042.3451147-14-seanjc@google.com>
Subject: [RFC PATCH 13/16] KVM: arm64: Stash "mmu_seq" in "struct kvm_page_fault"
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Track the MMU notifier sequence count snapshot in "struct kvm_page_fault"
in anticipation of moving the mmap_lock-protected code to a separate
helper.  Attaching mmu_seq to the fault could also prove useful in the
future, e.g. for additional refactorings.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/mmu.c              | 5 ++---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4d131be08d8d..6a99f7fa065d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -430,6 +430,7 @@ struct kvm_page_fault {
 	unsigned long hva;
 	kvm_pfn_t pfn;
 	struct page *page;
+	unsigned long mmu_seq;
 
 	struct {
 		vm_flags_t vm_flags;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index aa6ee72bef51..575a4f9f2583 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1471,7 +1471,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	int ret = 0;
 	bool writable, force_pte = false;
 	bool s2_force_noncacheable = false;
-	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
 	struct vm_area_struct *vma;
 	void *memcache;
@@ -1612,7 +1611,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
 	 * with the smp_wmb() in kvm_mmu_invalidate_end().
 	 */
-	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
+	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
 	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn,
@@ -1691,7 +1690,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	kvm_fault_lock(kvm);
 	pgt = vcpu->arch.hw_mmu->pgt;
-	if (mmu_invalidate_retry(kvm, mmu_seq)) {
+	if (mmu_invalidate_retry(kvm, fault->mmu_seq)) {
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
-- 
2.51.0.261.g7ce5a0a67e-goog

