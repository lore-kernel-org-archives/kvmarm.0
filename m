Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D463E485
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513621; cv=none; b=a3Any1O8PdizdJfQoqR9bREwCkaVbJffW2/QvydUW+nGaXzml/Gq6B0E33eIDPqZ+ypey2esCsCr+yMRzh490+VQichWt/ekCeheqoS8PgBIlQJPwNhI3P7TU0dJnddbDXqHyb7pgHpKvtr/OxdOfJEjEWdJcLdLgCuMoiKdN3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513621; c=relaxed/simple;
	bh=lL5ivNzGsmCFZQPicxbuUaXD3JD/SjZBOuKC1z84Piw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pACW5/lWvl8zIdBLp0ymglzg/MDTZogJxNv+JhAANCpA4xZiVpvS9UL22H+ERLbRyHeSyKU5r3o7g8gdYaqXJqd4UY2nDfirxvWGE0sydx3R0+f8cgnfDfb17ifqSfrq4PbblN13fAaM1Csiwsk+4/CDyxV4hf1dZFaVkK5ey2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dG88BNaX; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dG88BNaX"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-343e46df264so1015382f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513618; x=1714118418; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WblxPp5az5b0wtAKeeI+5wWf7aFCb0ZwuISOSLYsVcw=;
        b=dG88BNaXV7iZXsXBkSXMRIdY1OdhSxq07TjF9Q/D1djVTG2t2tkqvd5AyjqZTnKmFE
         gfQPrJ+L5eMJlMF7OHJprze+6kBDvloMPZbDyJCmBwVw70vu8hw14YYeYm/HQIPy80C5
         zNhA7WQW/hlzq6V5PQ14hFBZW5EVbjD2DtUSgMvirEDGnEA3QVjRWka1BqII7/mNG9I3
         6/0OI3QbsJofKD1hvQ08Ls0jnjif0t6CmsQzWAz4A84OVGe92Uowy/Tw9Xc7AASuiNMc
         nr3G0aC4BC6P2AbH3xVgSLg6Vpg92U4C7c52RojrRLdEf5VIo9YZxH3pk5ddGLXYp3Ub
         gtCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513618; x=1714118418;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WblxPp5az5b0wtAKeeI+5wWf7aFCb0ZwuISOSLYsVcw=;
        b=S8HPc0/Wild/IoD2vqkb2yck/RK5c+pybzAnrNMHCHuMtc+/OS8oZ5V7O2lPPyNvJD
         5bwOk0+LbsCoImEaJpequdnxlJoJn337qMY0csNjh0trnJSLoEoKXSlZMnAs96rXC/hV
         cnZZdlwvAASryzyGaJoBq7LAsymMIRQ7KJ4VE5d1X3she5tz6FwurVGTmmqylufCZeC8
         MUMBnN499YwhSkwlv3Zh+pwNmZ9UL2aQeZ/9y43d/Kupj+T7wXGnZXjshZkabvXWaXzY
         A6oZf5s+rlVymS50hMtuGdHnxPPlQ/CH5MHTq7HAOf8HkH56eTOzQEMlgyK+9wtdsMlQ
         5g1g==
X-Gm-Message-State: AOJu0YzjwtmviqiejVfXKZIoSKbpBIUUOww9mV/pUK98gg4rdYFQTy8c
	Fonre2E6SiwjNm27pY3QuEJdcTDvhfOcx7haLOwvZ5Z0QIVKrbt+8LySGKSZoZFyl6f7utE8NrW
	rBUdmJBm0JStkQ8m+CKK1Nr0P1Fog0sHvmcJ5h0XTug513xc85H1QFVIPI/6VCfZITU7c88136v
	VMLYsbbMlZTwayQT2X9VBwHYJcEjM=
X-Google-Smtp-Source: AGHT+IFr8uCrHNvl5yGmtdgB614KXTbWWg6RYMhR6nCiTBOzEx1KY9NFWkm5WYC9KtK1vGVLGKgEqworIg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:e985:0:b0:346:bb11:1fe9 with SMTP id
 h5-20020adfe985000000b00346bb111fe9mr3702wrm.2.1713513617619; Fri, 19 Apr
 2024 01:00:17 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:25 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-16-tabba@google.com>
Subject: [PATCH v3 15/31] KVM: arm64: Move setting the page as dirty out of
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

