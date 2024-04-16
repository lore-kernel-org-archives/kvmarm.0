Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21422907
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261420; cv=none; b=XjcuyNSxqgtWdsNrYp/2MuZzF5A9PA7kMdhXFoyojoggit2+p7w/vwxz8CiL2FgLOGrS2hq0ASrSPqqtniilz6PkXKN6oCYJNDa4U8C6QwwkiwUQ4rrTTjzAK4CZEbI2DNbVf0y3iQqMzxaUWsyRgZ2vV7fUpR2s380k0LcLBu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261420; c=relaxed/simple;
	bh=+2qT6hFfDpHAPO7waMYK7nVCgX2sSJA9uZNX4PucbcA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d4ZMtE7DVdrKwx1oxLuNbUoYvhJHXqjE6kWTMfH8QiH1jn+BHAnsYdZbw20Zv/cLni/XRxiam5lv93i0wWjbVipiCYYJLoKPN4zlpIhMGLnYqEyitxDHDZCmthji6HgiJqiecDdiyA9jzJCMMlKaboGxlODNIUfcFaX/5yBBY9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ie+f6xqc; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ie+f6xqc"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-416ac21981dso21908395e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261417; x=1713866217; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JvJZfHyPOB9ldYUqhMcsEC3kwEy/fk07HeyVYr7a5cM=;
        b=ie+f6xqcl4OdIoPF83vN9pXxJeYaeKJxXI6s6O7pf2ZCgyXFY/Pg1ol9sC1JYXTuGH
         u4GGgL9iDYrmbXvA/TY3L8VUnN+6CwB1gTHNAZdLcrPI0XbT1R7JDUIU/F6au5OIFMSJ
         RsLcHcjJLBOwjvoXcdNch/DljUv0IwbQYtLIH1O3DoPxtwqd/u9uAUwtsiCGQln5YSc9
         i4+7xzNK9z/OC6H8ZfvJRUB9baQWuKvZFMmFHXtD2SVZfa5La4KmxrEemY8Jv7SAc4y0
         m9QSTg7e320d/kxx34VQaRqjqgx1gZM/llXGp/C079jOjwH1lMk4ahF4wytFLTegTehy
         1sHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261417; x=1713866217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JvJZfHyPOB9ldYUqhMcsEC3kwEy/fk07HeyVYr7a5cM=;
        b=wD08dVKmnIjVIxj8D9/DE2hak8NPX9bEgzBQftsD2nJEtGk02vUJvGmVDST0YH3PwT
         olULntOqmP3iKO60e8e012vx6TIBU5wIsqkfVa0vHR/FhZAj+d/WP6mX8KsKtdiJeGMF
         njsVi5rGFStWyp1z9lbzH0UeVTip1AR2xrTq/FxRScePVfYtZKW1ZXo+i44Xeqkjiswd
         CNmnGX6eetPhPzhJvqfxOZzGlxqR5gMN4GQxCxghKVrp410QeiJqezlMEPiC7hhzXyWv
         10+r0rmUfB7vwhLTPARWfcGQMqBmsCh8yc5wTp1e3OSOBiW48kr2/ukzmPxaNfZ2h+DA
         BTRQ==
X-Gm-Message-State: AOJu0Yz++JK14MOwB6cfpAAcQuRZG08MHF6pub8JMDVzMAf5gvMboMGt
	jp9PoEVGHZYCNw7Gkcf9AzlF+Ndn7dFP9AXCryfzSeimoZXTZixHbXLwf1lJp2WR71KYzW9UrWZ
	PGHcjNRUi6Ddwnc0dyjdDyN+/i6tT3aHA6zpnspwtk4Hr6oAB53CAYeUXs9n4igNI/92aOozgkt
	BRljIjyAisTmm5ZjKIcRnXPCETptc=
X-Google-Smtp-Source: AGHT+IHdHXbFhLv3+RBugUBc/47+EvNZhFxhms57tXYOt7oMPgUGDU+3EuLBDhaGSBecXBjtSnXcNXF1/g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1c8f:b0:418:d6e:945e with SMTP id
 k15-20020a05600c1c8f00b004180d6e945emr98518wms.4.1713261417146; Tue, 16 Apr
 2024 02:56:57 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:55:58 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-8-tabba@google.com>
Subject: [PATCH v2 07/47] KVM: arm64: Move setting the page as dirty out of
 the critical section
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Move the unlock earlier in user_mem_abort() to shorten the
critical section. This also helps for future refactoring and
reuse of similar code.

This moves out marking the page as dirty outside of the critical
section. That code does not interact with the stage-2 page
tables, which the read lock in the critical section protects.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index dc04bc767865..03cf0a473458 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1522,8 +1522,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	read_lock(&kvm->mmu_lock);
 	pgt = vcpu->arch.hw_mmu->pgt;
-	if (mmu_invalidate_retry(kvm, mmu_seq))
+	if (mmu_invalidate_retry(kvm, mmu_seq)) {
+		ret = -EAGAIN;
 		goto out_unlock;
+	}
 
 	/*
 	 * If we are not forced to use page mapping, check if we are
@@ -1581,6 +1583,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 					     memcache,
 					     KVM_PGTABLE_WALK_HANDLE_FAULT |
 					     KVM_PGTABLE_WALK_SHARED);
+out_unlock:
+	read_unlock(&kvm->mmu_lock);
 
 	/* Mark the page dirty only if the fault is handled successfully */
 	if (writable && !ret) {
@@ -1588,8 +1592,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
 	}
 
-out_unlock:
-	read_unlock(&kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
 	return ret != -EAGAIN ? ret : 0;
 }
-- 
2.44.0.683.g7961c838ac-goog

