Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903C6F4E2
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560943; cv=none; b=ncGZvmLCW5wI1ITAG6BYQUv0taZC5PO7hIpdcPscFmPVnTUVqTiRpwSGnMfieoP2ah72mSESKciE+MJ+xs55Z6C7592CmjB7fLgjayv2dNURApFESLku/jlppMl6b8bI0uH7XyGLNeG3JrK1gYXaTKrvpu+87KWbmArzX8J++ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560943; c=relaxed/simple;
	bh=4Ymmtjoojb1QAY0LNWRi72DAdBNQV2ORGdwEpCNcYMg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i1Vv99xPkBm9jvgO58mRZ7N0aMYFBW2teY8Md5h1yghHq5/GcPr7OVFgJMay0JLr/U+q+5SP6jzDIZTUxBiYsqZuBy85mVoDFhfbWCtCFo44VkizzgtPPc1KVzQQYPsth+MD1vZfInkZwX+qK8GzFk4rN+dBAxJabEUhXy0q8fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qloMOwm9; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qloMOwm9"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc746178515so47793276.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560940; x=1712165740; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y7loAMCX5pjbp6Hb6CYPv3LRzLItnBOCiY1g2k8wkn0=;
        b=qloMOwm92vH4uxgDHxzn+/g51otY/r4DD+enG7XzEZSPt0WuhbSC8/d5KJ5TSps/Ie
         J8Ecu9xD+19S7FwtuzU8gB2c/LVrytAgIW43Rzfv3lB7XraONpKF7SUGzjhIkj1mqpEU
         UwS7vo/l86LelQmb2yDrzpJTv1/molFjoLyC/LFvVWbeQdZGobSBBUjtkvAeliTpT6TM
         kQKzTXhftouwF1itvz8drdnjEIBbZMlhZXMjN/3y0qvIgEzNLAhhIcCXlsvrS/uieeuJ
         z32uOqwJP3+aAtneo5ow4vXxzMS7pR29GkmGcE6u+dMw3qiuwM7mx8dpsZU2yV0l0z19
         jSSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560940; x=1712165740;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y7loAMCX5pjbp6Hb6CYPv3LRzLItnBOCiY1g2k8wkn0=;
        b=aEBvlBaSQ//kH3Mgpp5fJsg55pa1uE5F34mQAsHhEUZyjcBRnOI+dg9KQuaCGisbMB
         ywtqyqgEo+gXAnTTo1g7YRB9hzGE/mMjlhnQinLLak2iWiRHSVlsX9R+KPgEZXARNDsv
         q+9zjzUbjalI7IzbyIDZGaEzxyawkwIXt38Q7CFPtRKROFaAAKMBVQQxnHrMHzOoDHt+
         d9UPiTbne4bbNZr0nS3HxJwHmnvX7HQmrNHqinG9HeFWTGEArM1L8VPogZ+HMCVtOXx0
         RfnwWGDCoJAqiKhxjyXxFRcRH9vW/C1clXdz+PHn8/HrhLIYHI7Jl4V6/DJcZ9HsO0Tt
         qinQ==
X-Gm-Message-State: AOJu0YznXrDCChlXzejKVthUak8yrYyoMRFKwNsUDYppQMZ5sOWeMUHu
	bgk8YErmKZsI28C9CMJPn7whAkqsq576P2RY3r7EbKxfnk32JHk4N+rcxttb+kSV8Fs9Pm5Fg3Q
	l96xuWAITHiJbG9bpsVd1mHOh8R/pcDoIeM1zpoR/nRcmticR2h9BKavo7ezZfkggkJoT66h7d0
	LU+d2DhvapGyO6tx6VLZvn1EUPaWY=
X-Google-Smtp-Source: AGHT+IF0Bo2vFBObMMkjE8fZmzmDiVzJAhWkFQR/K1BPeHuJpV1qyrKFZVhlMNprIO2KiHDwFQCt3BaBTg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:230b:b0:dc6:f877:ea7b with SMTP id
 do11-20020a056902230b00b00dc6f877ea7bmr141163ybb.9.1711560940515; Wed, 27 Mar
 2024 10:35:40 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:34:50 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-4-tabba@google.com>
Subject: [PATCH v1 03/44] KVM: arm64: Move setting the page as dirty out of
 the critical section
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Move the unlock earlier in user_mem_abort() to shorten the
critical section. This also helps for future refactoring and
reuse of similar code.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 18680771cdb0..3afc42d8833e 100644
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
2.44.0.478.gd926399ef9-goog

