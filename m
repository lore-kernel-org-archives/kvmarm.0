Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA859316902
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 08:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767946955; cv=none; b=M+iyyu6MM4thkadTYgRIqLu28fYUPcU0XtNQeiNeM7D0RiJhPPlIDwSIkQPShw07p0cE8hW/bvFyxTJqHYHcDP8j/xZKeBgwmEosxDW82PQ1iXjMzlSBFh+sa4I0CKlFg7t3TxQ/n3HIC7uokBJ3uz81vW1AgAw2dMMv7pAeqH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767946955; c=relaxed/simple;
	bh=mo9GXML61XGn4VK/rkKAhV/8Z1SqfPf2w6zAttWNXms=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sKpuCL5of6aGblznuVbBY9VEEFbfndIUmoQ+ILEqf1vAkrJCSs+NwDtqvq4u3dJN6lzp3djEov8aym2D6jLEJwNpfZxGH5Vs1XFrqI/c7f1Dr5X2ZFkaQa4y5+V2WGvBiAM/zo+hUp/XTqsTWb6d21ALl31YVcS7YbHNEBeb+j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l5z2T35o; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l5z2T35o"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47d3c9b8c56so41203495e9.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Jan 2026 00:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767946944; x=1768551744; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Aoza9Haxbx5GFTKXR2e7jJHN2DZHptcSpiNA0k5YVqc=;
        b=l5z2T35otcpkRpVoOe/7WrfXWmOnRXFXqS9KBgvKpDzbyiGamyJw5LyxPULBFnRQbB
         4Jk8dxay+i4q0mYzzkrpA+9nf6EpVq2Wz7htsmkwZbp7W72+ICnRoZVW8VZ4vCJOiE3W
         FGUTOZXTUdBt6cOySn2SQ604iwEi/eOTK1ZAgcLxELkbC7Y7lX7EmmWOPchsfgiOp1iP
         sepJW8Bf17tcDciJMZr37Bwcp+hVerth9EE9OCzO8UiQzZ2mO00du2hU0Wqju5PAdaMJ
         PfyN1O6YoYcEMB3lES9nOfFwridX9/ZFpNk3CVtbNsBe0R/v+8pbLBu4DoXKzLxi7ToL
         Zfrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767946944; x=1768551744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aoza9Haxbx5GFTKXR2e7jJHN2DZHptcSpiNA0k5YVqc=;
        b=hzWsb/yBpVEXWBN4utOcFEkZbMmu8h4EfYxoKrfkUKbl5HmVty0MCBSCVlzauhdhrh
         dCxEWY1hnfuAUW9Xx5PihooDMIuGxREeyDrnKt5mUUikOKatviXdKQEy5ma6dz38tji+
         d/PJSnmoUrcUZKjPW5FAufgSrcRGwEyG4J2lF8kaxU24OKoUMB9J4m00jaZ8ZRVqQRYv
         q2G6UCMlwzQM8LRs3UdWbJdhGVyTnNWVKYjg4WlQgCIgz0VdyoG0jyrY1OwA/z/1fiNd
         4HTVgDkhxQbf+RD83QHajD1388AofzNLE8JhlpNwm/fnEZqr029xEenpYGWfxPtPWz+3
         Sryw==
X-Forwarded-Encrypted: i=1; AJvYcCUmsf1WTnOicnH/eR48OG3rFo5hF7e/mcSmnjcGXe4Yy3PepFYPF2+Aupv2Q6PpRINexrCI0rk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1IlWYtj8NzbRDiSXDQJdioinPNT+ALplnrHRakd2dDVSg/7to
	l+BUbcQrudhcOAITH7e2Rr8ak/HWJ9grds+NlqDjQ8qRjj7hehX7Qzi6/fZ0Q6Bc6Y9bnGSkjW1
	Zcg==
X-Google-Smtp-Source: AGHT+IHW9z0RPtuJdgNq8q1u7Cdds1c5PfbSHvpUeu/W5K7Hz57K1sxTcMubWIfqET+Z4aJyqUaOS37UlQ==
X-Received: from wmpj3.prod.google.com ([2002:a05:600c:4883:b0:477:7949:c534])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c3cd:20b0:477:af07:dd21
 with SMTP id 5b1f17b1804b1-47d8a17124bmr45924505e9.25.1767946944632; Fri, 09
 Jan 2026 00:22:24 -0800 (PST)
Date: Fri,  9 Jan 2026 08:22:18 +0000
In-Reply-To: <20260109082218.3236580-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260109082218.3236580-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109082218.3236580-6-tabba@google.com>
Subject: [PATCH v4 5/5] KVM: selftests: Fix typos and stale comments in kvm_util
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	atish.patra@linux.dev, itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, 
	seanjc@google.com, tabba@google.com
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
index 747effa614f1..97f9251eb073 100644
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
@@ -1264,7 +1264,7 @@ static inline uint64_t vm_page_align(struct kvm_vm *vm, uint64_t v)
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
2.52.0.457.g6b5491de43-goog

