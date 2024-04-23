Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BD013BAF6
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884777; cv=none; b=eWKu0Lhb8JJfujMg6sQqSj5IdBqYAPfuTh9Pk7gqxkbtGTY49JU7DIvSBs8GAbsm04L5MPoR+kWREv+Xs/ti0VcnGu1yvcJ4MsLJEP/R4nrcQABcoYzJ9tm206Lzc69WN7Mp/zTR3kvYmByFFHu6nNuLYWifWtKb6zPhTepQvgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884777; c=relaxed/simple;
	bh=lL5ivNzGsmCFZQPicxbuUaXD3JD/SjZBOuKC1z84Piw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JtIXeQmo1nNhbp20TBdUSoi2oBr2J3uFwktMGA8qzVFTtXsriUTZo6l76O31Vz/oeQ4NnX0f1Q9mdwCMu5krCRlFBAidQjvjRZdJk2AIaLctB/PVeTiln5eLOPyBXPI/yQHivnr6d45tCMMuHEOqdCGdT+fjh4mkUvZ77emVods=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bu0KsJtH; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bu0KsJtH"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6150dcdf83fso122146197b3.2
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884775; x=1714489575; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WblxPp5az5b0wtAKeeI+5wWf7aFCb0ZwuISOSLYsVcw=;
        b=bu0KsJtHg1AEODx33SK6a/qt4VL35+TNM4Mt+m+I6xUxWYWKn+lQWnl2uiQoqEDaed
         yLp6I2NstLqBco2VnuGYPv7SKXqy7do8XfprEf/OlytMSRPKT0H7TW//zTIR4WF/XsCQ
         aN/d1i7qVG5lXDiIBwhz13FJoDC9zPAw9KobBDMbXweSxKuUbG4Lg90oXcC83HRFH7/d
         Vq/GVw7JCIZ0gJjYo6FQjgQS6GJbk2aOTKhL+h64ItvoIPwIzs1eL7PjO3g2SAH/yqFn
         wR8jMzEA75BH3TjP/EC2UUmfX7DBfiy6uT4aJrJS891nzhaDFM766WKeGUvKNsThx5Xo
         R5aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884775; x=1714489575;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WblxPp5az5b0wtAKeeI+5wWf7aFCb0ZwuISOSLYsVcw=;
        b=I3hl69jD40JC2fEWZ1GVj2tM40sfWg20w8t1Q84FiGhJJ8613tt5AqMJtzaw5UiODr
         JzFQsUtK0XXVz04UigJ9XBlc3RiH8hnM1wT131e+7s6Li4J8j/6a3lkbycjFLc6DwO5j
         Vi/abi8piiQzsLeGwoP6ztI8fbbr4MRLahJqwgqJvWpBXZg0c0bDxtpl7/ncf4NTUN4+
         wSQ6MXkFJJeyLxvMkpeSVGEEMfkS4sI1i+e3laDRslfgTSiQnL1X+lBjWXE6GHmzFGmw
         wf7kSZe2OSYp6zMjpxablM393Z09kkIAPSvPB+GkC3ayZ45XuhZzThgAmsxm6P1secL3
         leaA==
X-Gm-Message-State: AOJu0Yxyyh0MaSS0oOSuYsj7enmfeREHHMHS0vrZr+2F7UpBZ2jqIGIZ
	nPIOJaVtdMyaZoDHo1GCEdeeghenEIxLB11Ev1J+BNd5YJzP12KyX6cFjArHtvXcf/s4xyo0dlj
	BvreNRIuls2xgqlrHc8rCP9F797SVJlgIGgSFgXZlsln+/bdkqQR+Kd7hGnNcnZ194O1KUeHaa9
	OF/hgqeiQ1EjT7BFGi4z0TzasJwa4=
X-Google-Smtp-Source: AGHT+IEJznH/JDcxrQ+ZFZE5xGHgfI3FI+IpqZw0VvbTfJtx8/4c5h/IJHNhECtZKad83etWPYsrKaIDog==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:4e04:0:b0:618:92c6:64b1 with SMTP id
 c4-20020a814e04000000b0061892c664b1mr3210656ywb.3.1713884775391; Tue, 23 Apr
 2024 08:06:15 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:23 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-16-tabba@google.com>
Subject: [PATCH v4 15/30] KVM: arm64: Move setting the page as dirty out of
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
2.44.0.769.g3c40516874-goog

