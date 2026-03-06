Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7EB3AEF3A
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805773; cv=none; b=GeK2YnYgIrVohzADmizg+28K7oHVd+OZNoJ1uHfBeGoG/rMG58ACe2OCWB7rqz2YjIJyS+qOzAINEqVhake2DMnxFlLZLblu+mi7wFxJZaN8KqDt2+/r2K9oFAldkr9/KHhVpJRhAO/sVe4kJxLzKupIVAim54LV0hkG27Gfj5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805773; c=relaxed/simple;
	bh=3OQfV3w/2qk9lemOSyqAInJWfA1kcX3/Dpbr8AywQL8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fx22aVxF82X8vbofesPwPXCCX1z0iQPOCTCcQUm6J2067HYZEMd9SW6+wHg7Nvl7wLa1undyjtDnA7tGip8KqueXXu95KqAZCbMuP9fd4HqloFGCPBSOiI1gHzGP5t3K571m7H9gvFKWoZ7LHV4lE6SkHX6XCrcNCAMDn2mFRyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bw96xhFR; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bw96xhFR"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-661aae3a881so1286284a12.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805769; x=1773410569; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CtHGmGW+kuNXfpqkwV8R0QzbahP6BhHBAQuRE9dnG2k=;
        b=bw96xhFR9gQNYi9r/HVp15X5ctZoW2fDJU3/p6vZIwoKnG41t40XTIGJwcG49kgxpZ
         i3vusuOMz6rhzWAe3N6JoeMiLjKq5EDR29GTo8/hOj9LeySxKDI0w9mj98w55Oozy4pb
         I+ugz6hJnuBNR6dpCeQo0fHBW7TTNrj1tMSkW8+gr0mlbpw6fuzRwSOHAVijDEzfPCZC
         4UFKL89MMK/oGs2/o7d1e2ZGxieapmNWJOqwIPdSUj/uHFzrzT5gkmd8/Cj2t5Hd+ytc
         EkvvqI0g8gCQxWJYNk94yMJEnApttabmGtPRDnZNK9dL6YvqaUrniycuaqOSC+wX3eop
         DF7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805769; x=1773410569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CtHGmGW+kuNXfpqkwV8R0QzbahP6BhHBAQuRE9dnG2k=;
        b=SqwenC0McRPGwoPU4Wp9tFgX5dv9qbLumKCxbXSuMGe5/4r2NfDi8NdkxmAgrEhFzb
         mDlp2qLspHvCVyR7XKnu6h/tUDqO9d7jlKJZdLr1y4qqBDeYSQzo0KQoqZ5TLQmqmktF
         ok0OK4nWv+t4sR2cV/f+zAsWPwjt8hlsleAc4iCzj09naqxzCLxP/0fjCGWcbkU9CY26
         vZso9SM8DwBv+QV5/lQ9rgCgaE+ykt5fJ1IpxH/gYl493I0O2owRVdxjNrg20o1MJzwb
         QEcZPhdZZita/LoEZJvWs8pTnNSQYaPAbUuixjbaQizodf4eY5Y4SyGc4MVl3LPaWmGK
         ddCg==
X-Forwarded-Encrypted: i=1; AJvYcCVyGzsBZ84Y/EdQejO6N05MhG0uazFJNR+r1B50jNbR0i6BT2u3tvjZJLCEYUdzkzsXggVg6qg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyAK9YtN8F9X1Uh8ND0IDAI7X86gkQ3TbLRNFpL4Ey+OtiG+E+Q
	wn1ERMJjO1m4qN3bzvzhEbhXHF8n8LxLGGcpP1cdpQxXSaNl0Sc9P8fqPoGOBJfNxtU0D4M2piw
	EUA==
X-Received: from edoy18.prod.google.com ([2002:aa7:c252:0:b0:660:e9bd:31af])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:2807:b0:658:1304:b699
 with SMTP id 4fb4d7f45d1cf-6619d50626dmr1271444a12.31.1772805768583; Fri, 06
 Mar 2026 06:02:48 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:31 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-13-tabba@google.com>
Subject: [PATCH v1 12/13] KVM: arm64: Hoist MTE validation check out of MMU
 lock path
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Simplify the non-cacheable attributes assignment by using a ternary
operator. Additionally, hoist the MTE validation check (mte_allowed) out
of kvm_s2_fault_map() and into kvm_s2_fault_compute_prot(). This allows
us to fail faster and avoid acquiring the KVM MMU lock unnecessarily
when the VMM introduces a disallowed VMA for an MTE-enabled guest.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9265a7fc43f7..cc6b35efcee5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1870,18 +1870,21 @@ static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
 	if (fault->exec_fault)
 		fault->prot |= KVM_PGTABLE_PROT_X;
 
-	if (fault->s2_force_noncacheable) {
-		if (fault->vm_flags & VM_ALLOW_ANY_UNCACHED)
-			fault->prot |= KVM_PGTABLE_PROT_NORMAL_NC;
-		else
-			fault->prot |= KVM_PGTABLE_PROT_DEVICE;
-	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC)) {
+	if (fault->s2_force_noncacheable)
+		fault->prot |= (fault->vm_flags & VM_ALLOW_ANY_UNCACHED) ?
+			       KVM_PGTABLE_PROT_NORMAL_NC : KVM_PGTABLE_PROT_DEVICE;
+	else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
 		fault->prot |= KVM_PGTABLE_PROT_X;
-	}
 
 	if (fault->nested)
 		adjust_nested_exec_perms(kvm, fault->nested, &fault->prot);
 
+	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
+		/* Check the VMM hasn't introduced a new disallowed VMA */
+		if (!fault->mte_allowed)
+			return -EFAULT;
+	}
+
 	return 0;
 }
 
@@ -1918,15 +1921,8 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
 		}
 	}
 
-	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
-		/* Check the VMM hasn't introduced a new disallowed VMA */
-		if (fault->mte_allowed) {
-			sanitise_mte_tags(kvm, fault->pfn, fault->vma_pagesize);
-		} else {
-			ret = -EFAULT;
-			goto out_unlock;
-		}
-	}
+	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
+		sanitise_mte_tags(kvm, fault->pfn, fault->vma_pagesize);
 
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
-- 
2.53.0.473.g4a7958ca14-goog

