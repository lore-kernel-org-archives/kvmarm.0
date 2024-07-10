Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC9D159565
	for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 23:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654963; cv=none; b=UkAULC0OS2LhP5eNy/AyY7XYdvgQ2HsvpSgW9rmk5pTwFrWMR8VRboZ2Kjwbr0VGahIiTV97uvl0/WSaVkUSp/oaL8GSmx5Z49U2HQ2Ix55tGMptmNY1+vMH038qunRGpFbsMDBrDzFpH4ZVZQSoZ4aRQ7Uwbk/ESqQvY1AXKzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654963; c=relaxed/simple;
	bh=IdpdyzI/6CbiUVqWLoyfJDrAPLlE8GztB50eBsdtlK8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nB5PUJ4jny1zf1a5VyFpXzYC6ihFeoZIJ+H0mfPycqionFezcOTZN17xubokQWFnJJqAK31FGmcop3b3N+tb1IvLQgMyohBlAd231qOISbxAngFSMaqeXQTiCz1ULG5aqsA1vyCJpSWjSSFHG5+PugBOmuGQafpKWykClOVd7Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=StEHRlYJ; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="StEHRlYJ"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0561513c21so1392351276.0
        for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 16:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654961; x=1721259761; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jsFdXvbgPwi63ncubEeloKTN1KDlxflVjQmCEhWWdzo=;
        b=StEHRlYJm6IN73kMzIUTnbXHSMCaSkh65PmhaMF2ebcN9Q5wsgFeVrWa9vhluVzqrz
         F0ZuDy/zNrw8tCHsJwjTqt8qcs8CBHCxrzbgsuABsqqnhiJpn3+vFgFp1NP01lZK82wf
         0afZzoN1fyVIC7hT9xVHYGQL1Y26XJhJnSfdePVuDzA2tkLsoeFYwtLNwGlml8c1IL/g
         h5eNo4THLUa5mmWuWD8DoVE9ZPI1gS0vNIcvD8JRvN4YFk1vZeEFzZeP8tv3QPflVu1R
         oycWVvYRAZXOzVD2L+KVki+a+IqY/nrW8etMTdDb+znx65FlO9kmmmXA0TH7fI4bFn2i
         1b6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654961; x=1721259761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jsFdXvbgPwi63ncubEeloKTN1KDlxflVjQmCEhWWdzo=;
        b=gTENDLp2xNyp5UPwbYCXN5q4bPoPEODdTFHFu2XYZBObRICqQHQzjFHukDetB3mHo/
         W/GFYd329U9x6iK9ApRnsJtgKhKet3RYpJSD4GbmYVIKmPFuXhXy3SbOOWeR4jnMWV6m
         xJmuJ+Y6PgnnJLP/K6ov7yRDBSlfE2J5HyAR4T6zX1UoHVbcuQU2azDSC/IvFDGSwfaK
         P/pLQvvtnMlDrewpQ4y+DtD+IhnHVVXf/v31cOWlN7ZAjW9snx786nghsr/vbl+WkbjD
         8t9L0nCxotyHnQ4IgW0EaVkqgkZp3pF0oss/0gDC9wTyW3m9iegxoZSIPgxaE3tp8oPk
         91Lw==
X-Forwarded-Encrypted: i=1; AJvYcCUauq6kIdcsR6mCj5CP6s5w5jUfvgyykOWsqz0Etq3gp4LG9C+8K7ELlUzJA5GyMWQztJdZe+TXLmPtki4V1lONn7Rv+lcA
X-Gm-Message-State: AOJu0YzYRLjkFU333nqxGZbr2jFttRwb3wsPy+F1ltilpuu693o0q8lp
	D+Xwc3+KYaYPghUIy3QtkGT92eZE+vGVSeJD5tDlm+8EoF1un78WhV1zX9t2l8Uf644z3PQEhiP
	eK2EPR1iOJbqGwD+GgQ==
X-Google-Smtp-Source: AGHT+IG3Vk6X5wTdtR4KaDZB2edBlrlcDT80/rqBxWjm1e2N+7Y128jb+W0Gi/uqye/vInLab8G3pghPeGswAEHn
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:2309:b0:e05:6532:aa4b with
 SMTP id 3f1490d57ef6-e05780396ccmr53350276.2.1720654960837; Wed, 10 Jul 2024
 16:42:40 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:07 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-4-jthoughton@google.com>
Subject: [RFC PATCH 03/18] KVM: Put struct kvm pointer in memslot
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

Because a gfn having userfault enabled is tied to a struct kvm, we need
a pointer to it. We could pass the kvm pointer around in the routines we
need it, but that is a lot of churn, and there isn't much of a downside
to simply storing the pointer in the memslot.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/kvm_host.h | 2 ++
 virt/kvm/kvm_main.c      | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f0d4db2d64af..c1eb59a3141b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -596,6 +596,8 @@ struct kvm_memory_slot {
 		pgoff_t pgoff;
 	} gmem;
 #endif
+
+	struct kvm *kvm;
 };
 
 static inline bool kvm_slot_can_be_private(const struct kvm_memory_slot *slot)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fb7972e61439..ffa452a13672 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1769,6 +1769,7 @@ static void kvm_copy_memslot(struct kvm_memory_slot *dest,
 	dest->flags = src->flags;
 	dest->id = src->id;
 	dest->as_id = src->as_id;
+	dest->kvm = src->kvm;
 }
 
 static void kvm_invalidate_memslot(struct kvm *kvm,
@@ -2078,6 +2079,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	new->npages = npages;
 	new->flags = mem->flags;
 	new->userspace_addr = mem->userspace_addr;
+	new->kvm = kvm;
 	if (mem->flags & KVM_MEM_GUEST_MEMFD) {
 		r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
 		if (r)
-- 
2.45.2.993.g49e7a77208-goog

