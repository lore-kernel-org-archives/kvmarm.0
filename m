Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF0F313295
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 09:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767691478; cv=none; b=mAoGj5TeXcsfiJOcTv+KtgQZmoN4Kzoui3zIhgzsg80dSJ2jdPbGu3mGAiv6GQoID7WsxTfq7Kdqu14a0YmvYMBgHxpSjs+zumiikxG9jxPuC3MMMo22TzQ8/6JK6t1p6iark+Ay2l/e4/rtfoFyJ3TshlYe09PSXDLFsPHNRbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767691478; c=relaxed/simple;
	bh=Zkyr2U5TIQLa0eYA/VB8e1CqJ2IJkIo9zqfz9opS2DM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IRTewZVpapuU3RQQExuBoTZk2LciIM+9AlZd/iRhdGsYgqbTud/1z3VtIJm8lG3uV8Cdu+DRCBZfjULbcbasBeWoBrgAu0U6ePDkXgJsgDblyPF/wDzMfJa1gmO6LFjS7qdN7lQ1VGx3eq/HjQ+O4RuUYRqlqG7SABAzaFr5IQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hbws5FYj; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hbws5FYj"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477563a0c75so4165435e9.1
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 01:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767691471; x=1768296271; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CY0nmexOazthmZ5H6pdtIqZB8AItwvhQd/s34gISyww=;
        b=hbws5FYj4VABrzybRUdSIfHNMsp+qiF8RZ6qBSwjtTpf70yV7dJJQ05moUF39LuKPC
         /q0fb7wESNx5g7ry8Y0GvyxtdsiJu9e2qPfkZmSxOeDwrnBASpFvJqIJi5+Do/5KcVwS
         3G2bFJtfvpz8CLdMMZr5sM12MoW2A+mWxY6ffFmaz+y2JtB4A15XRRn+cFbLZThGgUHE
         bawjXzH1DSDT1taj6tpP942OFunwQstRKAtZz/QRrDkHdRXi3FAKvHIX4zNjv1rcBFSB
         9huG4iPJ3AKZizkc8dySBqQHTgzyyOcWr7wVBZQQf1C+psCEUgoqknVIQglQTM2b1lC1
         lQLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767691471; x=1768296271;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CY0nmexOazthmZ5H6pdtIqZB8AItwvhQd/s34gISyww=;
        b=RODMNw3qvksdHkZWY/y+G5EMkuoS/3qBI896RW6UALbcR6kJixEglEjRKQ09XoX+Qe
         paIKtAaAOkfSHgBS/Z9HyoOn9BIrBmoGXje4xXJeuYQataP6BwURd5jCQGv+uv0u+XIO
         4sYtS2RMPTHnuJFRerZOisTxy5QGXLxXfVMxcY/nFp18ggbk72gT0gmw/R1asGCUofrr
         1bzmssZL5A2wpzoQrUxotU5iXru0dKpKTQS2NSLSsnYJ6wV86i2XF7GmJYKYIAQ5HUlQ
         lwvLZ3zfGTX4v3+Dv1inPmwgc2Mhfpr5Y48kRXF0nDN2P42ekWXsESVQ+nrwj+MfqGIX
         F/yw==
X-Forwarded-Encrypted: i=1; AJvYcCVt21nzTn9Y6a67qWelyaZQPw6iofxO3LOZQQWrbNqKRGW2Uehfl/RSBfNKC+j6U/oilIWgffw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxnsbxIEsgl9ddYUzg4cG982eQIyVcX5GH2DSmq9Gu+gbNJJlIC
	A1sA9ifKXiFelpZ5Hhep9WNvpPGdLrZcElf98j3iDZjFnxif+UT1Md2Dus69qRX4A0EtvA7mXMo
	9OA==
X-Google-Smtp-Source: AGHT+IH4a3WanlofrHZQi1TFDZ2kdHhieJiwoT4O4SCA7gXcrGwc3UiWaYl27kXqMWKHd9vR2euGSEKV6g==
X-Received: from wmsm16.prod.google.com ([2002:a05:600c:3b10:b0:479:3624:3472])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3155:b0:47b:deb9:f8a
 with SMTP id 5b1f17b1804b1-47d7f09b87cmr27122825e9.30.1767691471353; Tue, 06
 Jan 2026 01:24:31 -0800 (PST)
Date: Tue,  6 Jan 2026 09:24:25 +0000
In-Reply-To: <20260106092425.1529428-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260106092425.1529428-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106092425.1529428-6-tabba@google.com>
Subject: [PATCH v3 5/5] KVM: selftests: Fix typos and stale comments in kvm_util
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, tabba@google.com
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

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
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
2.52.0.351.gbe84eed79e-goog

