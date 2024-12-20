Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C651D540
	for <kvmarm@lists.linux.dev>; Fri, 20 Dec 2024 01:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734658754; cv=none; b=MHtZ9WHa+x8S43qw3WW+vMHVLZGwgRrf4WtqV5ktkecR0SoZz2yHHvZIN0fjNCbGQw9NwSr6hCHf2ls979otEHE+vMvYPqpunbVQ9Y1bOSkN66JYwLnIIh9sxDXqeDZ7UwB+8JE8lMaEblQ5D46NrnhLCGLxFqijALBTHMweO1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734658754; c=relaxed/simple;
	bh=x+G/SKe65zYqmcjfUDWiwO99pE05MNdhz6X9PomzPYg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jPynmLQSpecoNVLLj8MSQZWXB8OXuZrY+Lj2wJIGhm4hEMDD+SSodGa0fxph4z3vg0U0+g9+jjJdWnK68eesrVcBGwbQ+NNOcdFQ5F/g5LLsXYLHBb4ibjG4ZSNz7y4JIzAoZXPI2Bt+cv0KNIps4ds4+HqWNgrt/oGC3Hs0qJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GXrfEasN; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GXrfEasN"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21631cbf87dso11515025ad.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 17:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734658752; x=1735263552; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VJst1sRt7o765YHKTsyCLHu+qBA9pewJkWtnndgMLN0=;
        b=GXrfEasNyyE4WjkwXWrarXLHgcHMpclJyO5qBidJSUJVIHTIi61jhLyWOvlpXyqrft
         w4JMG+q8ShdqPbxxJSFfrAaByBWp+tMJwuItmmUwHNFYwOU758xA/TYD93/dB6qNq2JW
         RgJ+Z3i7fpzkKGJ4OMko3CEldfgoxViKFpJGlYNDQRkG9IA+qNZUVgSxTKIeDNZXk8wD
         hbphTF4ZBD1vxcIiXj9Q2nYuTfTqe6cJYMVy0EJN+KklZYEQUdKAEwaG02jyf7+q8iuB
         j1zoJwBZCpQckvoWElJ4Q7wH+Wbidwnre8Pxy2bFUYu9yCx5cZx3o93V36mTdECTFchG
         JhaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734658752; x=1735263552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VJst1sRt7o765YHKTsyCLHu+qBA9pewJkWtnndgMLN0=;
        b=TzJRUmxnh4+c2KV4swAX3EkLEiqbhw15AgCHhRjm/UWODkpgjZ9RBOP+DuYkCct28m
         lTd80TlaxsU+/3mnCtGPtytf203w1Lmz0Bj252hnf8dJT769XeymBJ/Edy2BQzgZ6aMe
         D5PduGa9AMB29I7n1MhmDKanZq7lcwm6+G2da1PVQcQZGW4T7skuCBhzFbWAhv7yWGfM
         IX0f1hkptiYG6Bu2Gg8CNCS3jL2/3XO7gnqDHg3XD3x6i66+cG4IeavMs6SjHyduRoy1
         3KX5smC5OsHg3d4L7RM6n+8E1L66j0oxKyGCRtz+y2w27XFi5uOIFQfyvz1ZHEnFOFO8
         F8Ag==
X-Forwarded-Encrypted: i=1; AJvYcCURrbUeiJI9GJci5whZRM6ABaNm4ACTnzRqB/He3SzLs1aUxvDsrIxAxUBv/ZuMW4mOQ55bbX0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxg+RFF7YLmBZzZ/HV0vsH2HhGQnPs5CEyhgYiDl+muZnY4jcWx
	OyBliRc1zkUqvttDwA+x4IP0ujiRUURXRlHo2xDeInyi+KjFZ9pWa6yumw1NuATcAfLLsfHEfWt
	LGw==
X-Google-Smtp-Source: AGHT+IGsWQbkvzY4Nq8NW+TxgBWjNbfzrSia5xRKbrBdsJJ8VjsmNkZOW2nxKqNkxRXVufnLriMmB7/RPeQ=
X-Received: from plbkw12.prod.google.com ([2002:a17:902:f90c:b0:216:3e9d:6bc4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c406:b0:215:854c:a71a
 with SMTP id d9443c01a7336-219e6ebb68dmr11030635ad.34.1734658751894; Thu, 19
 Dec 2024 17:39:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 19 Dec 2024 17:39:00 -0800
In-Reply-To: <20241220013906.3518334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241220013906.3518334-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241220013906.3518334-3-seanjc@google.com>
Subject: [PATCH 2/8] KVM: selftests: Close VM's binary stats FD when releasing VM
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Close/free a VM's binary stats cache when the VM is released, not when the
VM is fully freed.  When a VM is re-created, e.g. for state save/restore
tests, the stats FD and descriptor points at the old, defunct VM.  The FD
is still valid, in that the underlying stats file won't be freed until the
FD is closed, but reading stats will always pull information from the old
VM.

Note, this is a benign bug in the current code base as none of the tests
that recreate VMs use binary stats.

Fixes: 83f6e109f562 ("KVM: selftests: Cache binary stats metadata for duration of test")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 91d295ef5d02..9138801ecb60 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -709,6 +709,15 @@ void kvm_vm_release(struct kvm_vm *vmp)
 
 	ret = close(vmp->kvm_fd);
 	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
+
+	/* Free cached stats metadata and close FD */
+	if (vmp->stats_desc) {
+		free(vmp->stats_desc);
+		vmp->stats_desc = NULL;
+
+		ret = close(vmp->stats_fd);
+		TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
+	}
 }
 
 static void __vm_mem_region_delete(struct kvm_vm *vm,
@@ -748,12 +757,6 @@ void kvm_vm_free(struct kvm_vm *vmp)
 	if (vmp == NULL)
 		return;
 
-	/* Free cached stats metadata and close FD */
-	if (vmp->stats_desc) {
-		free(vmp->stats_desc);
-		close(vmp->stats_fd);
-	}
-
 	/* Free userspace_mem_regions. */
 	hash_for_each_safe(vmp->regions.slot_hash, ctr, node, region, slot_node)
 		__vm_mem_region_delete(vmp, region);
-- 
2.47.1.613.gc27f4b7a9f-goog

