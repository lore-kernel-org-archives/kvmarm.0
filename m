Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85656341AB0
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 16:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765817524; cv=none; b=SLnvKHFs3uX+I7wUsdcpodbDwtUWL1SxTEjRJUVsOt4ra3/V0nlz4AQBXpKh6/lEvmxdztPsegtFMrMJIsycBxa/oPua/fPe7lQkz/kxeintyCQEis/cUkoEwUdS66r7gzIzW6gwQTvRgASZaibet9RArs4zlZz4YL5P6BVgBss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765817524; c=relaxed/simple;
	bh=TWjDxQpMgkVth7jbbSyhOqWrMH5tsBTMps1o8Gffwyo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eQILQ38Wddl3O6Wx5c/YVJIQSgEgZJA/yHgRZneVifgkbLLDPLOuYIoytAa4hroPfbdPpTeYuwtMAfvwo6yMzurIjC561xwBl1/fWyTt6bIfcYs22jL7hMHaipzc2E67daVsbyjEXpWOKyMijzdbTdkZBwrF6+d2TO/l4pwzo+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jagsLQLM; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jagsLQLM"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-430fcb6b2ebso736300f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 08:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765817521; x=1766422321; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ugLBh2wdanmYlXG/Hn2z0Lmtzfai0mPG/qbIe+jLCHk=;
        b=jagsLQLMFZViJnBB7uU3a3H234bBw+dGwyomNzx4n++yK+8uwJ6sK819jDCN7SBM7S
         /zJU5IodcnYznaL7UdIbEZ7qEJqY0qUgtVhgfXDMxAFHPZFj7cISmFfvIqpoXe0XcQZc
         V4o83O3PBIaFjJy69m7rw9tPBOZIW6nDESKZQU4nHG4MoR7Yc0ZT7rnkxK2I54uEY7XE
         qt7TSXrFMhNZ7NFgklmsixe4KOlarlDqjs8s6NQsm5DTy16818eyNqylaS+8O8PQCiQR
         BuoXlZtZ0FX6q998ubYrTCJBi6F9GFcfoI2Wvdrs3dasKm39imcoYO2p/19yTLQFTkPC
         nnEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765817521; x=1766422321;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ugLBh2wdanmYlXG/Hn2z0Lmtzfai0mPG/qbIe+jLCHk=;
        b=ug3YMPxWzXWUkEjXHArB8IiOPMu43aW/PRMHOAGOKuRmdZ4kLDZkOs87VK6V4ljdIb
         8Q3jjfLCf85dWs5KIFNAR6mzBtQunbUIN9UCa8XhTL71apHBAI+bxnbvaleIjDyO1r2G
         ENVKVlCsPnBmR/KmV1RZZLXM4XplpVD0Ov8x68WJWcPopgLPdA/j3icY2xzmsIJniSwU
         pSz2qd6PW19yXt4JWNxpSlfc+7kMtB1OgQuAd2nijGWGJA1/TEDpYM3JMuTLK3gy/cHZ
         01rjyxlSusUBadFn0u4i4Vhznh2Y2/M8Ig0OshPKcWCBkOFcnHxZ7TZsONlH4opGdS76
         Lj6A==
X-Forwarded-Encrypted: i=1; AJvYcCUYXMKEkXndJ7CCUj/JFBCLHL8C9sdjea9p3+PEwHvqt2T1kkawaqSNlTubxljs9QIEYb0YTsE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyjl57+Q5hu2VwdvYD+IFZ6ZvJJrTwSb16pRHEwCWt095UyvWFm
	74GJlrlhlFcNMYEy6Mu1Pwv3/uGvn0tHHMHrz3QM6XUmm+qeQ4Z6W6HEQ6MD2s326uzQCkuIMi4
	0QQ==
X-Google-Smtp-Source: AGHT+IEtLqdqM2TCcz8tE6+Rp1QAj2pRxjGKZNUndLMFxKWF31WsAS2y+R/nz+ivNRonRnxHnhbxUpbtug==
X-Received: from wmxb4-n1.prod.google.com ([2002:a05:600d:8444:10b0:477:9bcb:dd8b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8288:b0:477:a1a2:d829
 with SMTP id 5b1f17b1804b1-47a8f8c0caamr110913215e9.13.1765817520904; Mon, 15
 Dec 2025 08:52:00 -0800 (PST)
Date: Mon, 15 Dec 2025 16:51:55 +0000
In-Reply-To: <20251215165155.3451819-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251215165155.3451819-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215165155.3451819-6-tabba@google.com>
Subject: [PATCH v2 5/5] KVM: selftests: Fix typos and stale comments in kvm_util
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fix minor documentation errors in `kvm_util.h` and `kvm_util.c`.

- Correct the argument description for `vcpu_args_set` in `kvm_util.h`,
  which incorrectly listed `vm` instead of `vcpu`.
- Fix a typo in the comment for `kvm_selftest_arch_init` ("exeucting" ->
  "executing").
- Correct the return value description for `vm_vaddr_unused_gap` in
  `kvm_util.c` to match the implementation, which returns an address "at
  or above" `vaddr_min`, not "at or below".

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 4 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index dabbe4c3b93f..e29b2cbcb82b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -939,7 +939,7 @@ void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu);
  * VM VCPU Args Set
  *
  * Input Args:
- *   vm - Virtual Machine
+ *   vcpu - vCPU
  *   num - number of arguments
  *   ... - arguments, each of type uint64_t
  *
@@ -1264,7 +1264,7 @@ static inline uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 }
 
 /*
- * Arch hook that is invoked via a constructor, i.e. before exeucting main(),
+ * Arch hook that is invoked via a constructor, i.e. before executing main(),
  * to allow for arch-specific setup that is common to all tests, e.g. computing
  * the default guest "mode".
  */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8279b6ced8d2..fab6b62d7810 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1351,7 +1351,7 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
  * Output Args: None
  *
  * Return:
- *   Lowest virtual address at or below vaddr_min, with at least
+ *   Lowest virtual address at or above vaddr_min, with at least
  *   sz unused bytes.  TEST_ASSERT failure if no area of at least
  *   size sz is available.
  *
-- 
2.52.0.239.gd5f0c6e74e-goog

