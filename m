Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF981338921
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 15:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765813542; cv=none; b=uLfNZAnzsv+rfXsarlGDuaxoCscCmdiIAeK3FRIpaQ1XiRN3Truz6D27dHcyCsopriYkWnxLdwX3suNZmoViULZFtY5iQLzArQgSyo3smAJbFvUsJIpevN1rE2UWouQRy00O2P4hnQAj35HxVPrb5JNvgkSJFub+GYcGVgLNqA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765813542; c=relaxed/simple;
	bh=TWjDxQpMgkVth7jbbSyhOqWrMH5tsBTMps1o8Gffwyo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cQOD6hng4UL5cKYaSbFOqG4u5h5+1393YwPsvQZ4gHZ6BdSN1rDL3Ra7hgsjz9Hr+/oLiVyLKSfD+SwrfTdr7Hq42e8gklhKJgh99OZSbYJpMAdrghJPVkr+TmZgtHUraPYZ+bLI6J6tgBMoBy+e0ild9hVQoGtNtVqD0dRLK6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AEuqdMJB; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AEuqdMJB"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477c49f273fso42289465e9.3
        for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 07:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765813539; x=1766418339; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ugLBh2wdanmYlXG/Hn2z0Lmtzfai0mPG/qbIe+jLCHk=;
        b=AEuqdMJBf+m5wGeZcg76bB3rEydsT3IlfnvxFcLJDl53dCl0e532KMhyLZIdGU8d1Q
         IMQYCg4B/Lwv7YZKgzIDfVjlrQknB0r5hz3tqg411SpXgAserJtb98rMxC+A9+DfUbax
         5SRA1U2A2knV8mzFMLk/PO/oBbMrFhlgdQ04SBtNwC1FYizCOuybEOVaUDJAY3PLrqyH
         8cTJGGlwTxktiVTHWWYB8WkG/uqZ/geCVWUOJIy2S9DdSaE36C8U1dAVwwmHCO8DgNHV
         vrqdW1KkfQ3/dfS9jp9UNi7Qyu8yR7ctBxittgj4HE9du2eDxfdcNTIZXjgTGskKX/8+
         M38Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765813539; x=1766418339;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ugLBh2wdanmYlXG/Hn2z0Lmtzfai0mPG/qbIe+jLCHk=;
        b=bivBzI8FCclzpHKKwekwnW5Q7IMWp7jz0RvFpwbUNz6EBJnHXMaZa6VagscJHF910Y
         sEtgkcdBBgp71i1gSp56vGVYYMXvkYhkhplTm8SDENhdehu5S5vPzJvMUySOfb8bOCao
         7IqScBjtzmhlMoAR+QUmJ+xNF7EoV5xPcn6HQk2+DzM6T/9rW6fVIXDRRO5SpgYcUaAg
         uLvJezqi1lGLK6FnirFV3urSG1fp5cNVd6OXlYU/rGzClVPodccZSKgFd4IaTbFW2H+o
         CRdqW654CtHPotl6P6wbnCwvDCRCQ0l6g9eBy7/sDguMHC5H6IVu+zR3IRqbJ5IBa/qt
         uNrA==
X-Gm-Message-State: AOJu0Yz1dHBLf5IuoTEYzkOvWsFYYS29dMdR3KZR7Hma2BPzAf10JEsp
	hbdJlxmiAf/CLTPEejLo53kpYCMDtnXaE3XQrFRtm9vtV+jxpQN6ZljxdcW/SoDLPJ+2l5sZk/B
	OWrVEVwgVjbuB9Rz7x03njz1ybT/aIeDOku+mzvACuEozgFZe+lf/PwHnObdjuC6p13X8zjbtC4
	1aw9R0gFrvmxHhYyQGFHMubHTsRJYTS7M=
X-Google-Smtp-Source: AGHT+IFJunnbSWICKe5SqT5lO0r65yI8AoUOzlup/Iu59op7JlY08E1k1kCykSYROB9YxPoFwipyMX2vRA==
X-Received: from wmbgx1.prod.google.com ([2002:a05:600c:8581:b0:477:9856:8f53])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b62:b0:477:abea:901c
 with SMTP id 5b1f17b1804b1-47a953da53fmr80716315e9.11.1765813539100; Mon, 15
 Dec 2025 07:45:39 -0800 (PST)
Date: Mon, 15 Dec 2025 15:45:33 +0000
In-Reply-To: <20251215154533.3154405-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251215154533.3154405-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215154533.3154405-6-tabba@google.com>
Subject: [PATCH v1 5/5] KVM: selftests: Fix typos and stale comments in kvm_util
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
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

