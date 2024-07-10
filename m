Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C491662F1
	for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 23:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654971; cv=none; b=P80rUzAjqJ34AUHzTkgyrzJE66P8nc7uuK3LEI7DdwoYBe1oaKbvtoyUezYVwfx6epyeMUEfMzO/67uDIUGX+cmvAEOOrT2GYL3AnbBWHhOG+kEuQc0OMStNDKY/y/4cjKag73W+0qTHFGNPKHljZSnvDhIM3LlYRogptWCWszE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654971; c=relaxed/simple;
	bh=IjXnmRFVjtDWx5DdntFXxWYNolKMFz9eFCdi9O/NlGk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pt6HzSa9bJDuLt4NMK1nJ86aoSCTeoXAE4Dkm7RcgztFbfQ1S4+FBCVGeZWb4dmNE85+bTIgiO5NucSf/SBHltAjTMEscCSdNHyz/Bpxx/2FWOYVnPiBNITFq/p11L3MnVaoV+nv+R4Auu6VYJoPAwg1GFP/gd7MG/qvZNfkQ1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A89jEG0s; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A89jEG0s"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-650f766a1c6so5556167b3.0
        for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 16:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654969; x=1721259769; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M0Yr0VzVLlHnBy7TTzGiqxJ6wuwWaRwmTmvFlX0dIWg=;
        b=A89jEG0sTqXFfmQ39fibgWUD3huScV2Fg8mc4UNqQBiSoYgnSJBnM80o2/QYjAKoys
         VYZYV/W+xhvy9KINRn7pNZC0whByUbbEsDmpsy64ihG4FRwvSdMaTZFmrN7oFlI95MKC
         Imdy3kH/ZUidQ6R6/JLf8qoORK0+eulI49/gm7kAfmkSPCH9UypW71fwcxjsIcKJqipP
         la26UGsPGmYZiHhWm68pxiLeUuaS/Sfmf4WIwt/a/3vIB0ZZc8+DSA8Ud39r43Peiy4F
         dWfHYfDziMJZ/b5Xjq7JqbxnPcWqT7bndtaCG6t5Z/JFbg/dvZK2aX9OblOHCOCPGrYa
         EbMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654969; x=1721259769;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M0Yr0VzVLlHnBy7TTzGiqxJ6wuwWaRwmTmvFlX0dIWg=;
        b=a4299UNuxbjhETKVtpzjZrNd/hFNqtnZMTW/NC0P56SMnpYu/IRbsNKVAu2HBPM6IM
         yWbfEHaxi722qo3wXLy/w099CvPhn0mgR9SdqeUdHzW4ObeUhrKUgu6F2erTSuHynkEW
         qMhgob1tv2frhGBlUbPPqQS7S2Na75olAXnsUaBQTh+XMJajjkD1dY0bzSbu79rcaWon
         XU2+3i4bvyU1wCxypgwQZTXxUW3NEBipGr0559so9Mtigj6/hs9r+twOSjmIrpuy6exX
         JrTiAU3c7uFPZgHY5MGNWkkKWQjaVHN2d/gB2IwyuX3Ge86uIXGkUYnSNCXCLb/Sq4XV
         TNDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNgMoTbYyY1HtqXf4NqL3ERkF1l9EMlbJHLSKqU6i71scc4i7XRG38ma/A/429dBBU8Q8v6V0FWfDQpY23AoLXqPz1x2Li
X-Gm-Message-State: AOJu0YwO6XAGmB+3ua18gT0G41EPuKlap3VE91e+Zn1H1Gb/ARSKRD0k
	vttqKviKWBS+0EdkxQNDSeiAJwpFZQ6ad24VeEjGKbXtMvFaSP7AeuFRfgSjYH8Fhf7HvKZv6Zd
	6tBPasPwr88opi0P47A==
X-Google-Smtp-Source: AGHT+IEnfc9JNyCNV09EBc2D+TZxXa8AOYJGFkqDSB6HeXipR+uC/GqUScItBcKVfj4YhKzC1lFukBy8dAilrvDh
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:154c:b0:de5:2694:45ba with
 SMTP id 3f1490d57ef6-e041af3e29emr358942276.0.1720654968877; Wed, 10 Jul 2024
 16:42:48 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:15 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-12-jthoughton@google.com>
Subject: [RFC PATCH 11/18] KVM: arm64: Add vCPU memory fault fast-path for Userfault
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Make this optimization for the same reason we make it for x86: because
it necessary for sufficient post-copy performance when scaling up to
hundreds of cores (even though KVM Userfault today doesn't scale very
well).

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/kvm/mmu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ac283e606516..c84633c9ab98 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1488,6 +1488,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
+	if (gfn_has_userfault(memslot->kvm, gfn)) {
+		kvm_prepare_memory_fault_exit(vcpu, gfn << PAGE_SHIFT,
+					      PAGE_SIZE, write_fault,
+					      /*exec=*/false,
+					      /*private=*/false,
+					      /*userfault=*/true);
+		return -EFAULT;
+	}
+
 	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
 				   write_fault, &writable, NULL);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
-- 
2.45.2.993.g49e7a77208-goog

