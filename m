Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E949A158D6C
	for <kvmarm@lists.linux.dev>; Fri,  3 May 2024 18:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714760264; cv=none; b=hT64JBOzJ9xzPc+4Q3DZVnDSz9sJK1krWjJ3/DhrHmqJYR5cflJaURXFoOqlJP/D5g2lt5Fk4/n0WXKqueKqVTv4Gd+H/QvjMvhsE6NmgJu4z5VNRzCOoHEm+0Leu3vUMI+K7W0Tuz7t2hRUzzo9ns0x3mhGcADSybsue8BWEVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714760264; c=relaxed/simple;
	bh=mXEp7/JVq5ahA3gE3cHKv/B7qtsS8wcRgKa4iiw3GNs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uJHq7vLQ+aAQJQti6NdfysGYTYmVBBysMktXvNHj8wLCtbRx7eLZ8k/zE+/NjK8nDS8XY6d8dYjAlhJsv78jsCHlTYtfDnx5ETKkqsMdTN7JuR868tnVZR1fb4z3smAOJmKqRroXS/x5gkJ616Bf81YpjU8m3kl9eqpwZuNx/4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=taadWppe; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="taadWppe"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de0b4063e59so8368355276.3
        for <kvmarm@lists.linux.dev>; Fri, 03 May 2024 11:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714760262; x=1715365062; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QHXu+3wMl1x8qNonydytLIV6nGk0zgXCPmBNIKdSDOU=;
        b=taadWppe5K618/G05fypvVIr4XYJfkRIkKOXECSQHygqDbykoyTzu2W7uHzpsFqtqK
         7uVsn+70kf0xMBXpGxAQFacUYNbi5gFPw5THKlNHPb/T83y9fSURY3CsMkI0EMo8ZXQZ
         aRZ3P/oOdYKwUn93lYRLxzVqLYNY5yWNnLEX49EPIjZ3R4OfSIJTyMUu5V/25mjHTdQu
         7oTpOD4LLgVvnw58vuRt/GBgtMSKsvxPFq6n+ceifg4oNtwjqMSHySXNrEttchdFOxYv
         QZ3+1FOMjfFYVzk/VtHrnol/alNV/euE+wnZRBzA0+OFenVXWb+3+/yC8TYvzFG9d/S+
         c2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714760262; x=1715365062;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QHXu+3wMl1x8qNonydytLIV6nGk0zgXCPmBNIKdSDOU=;
        b=G8vss2uR4nDi/aoXh5OoUWkAPKCFc12BHZbS8jQj2exNDPEIszN4NZRpNqkZQLvTBZ
         U2SA09yKNjeo/Q18xIlyO7WWHq21SbUzlAyN9+tuHvCVT4DEZ0VKceaIGyXw9cw0XdvK
         6MgrHSjS1Y4N6f4rY6U2znVYULh5TFzpQXJ0KklOEisPT6TlGXDRyBJ+YVyGAVaDGw6Z
         /FRGJmcJ1UYQtXKp0n0gCQdUXp4krqlkkjLptWN+jWoywmtUMkPuAvceNh943sOkrfml
         TZ5L0i5M7XXnJ27AljASk6EHItYQzSFzZWLhJfCWUvJfGCVy8eVm+0lAr//fuAkRN7dt
         S5cQ==
X-Forwarded-Encrypted: i=1; AJvYcCUY0YG4j5raiBxhb7MnmFT3rWRxquliNuU0iykbJHjNSdcnQ9+v/JIyVN69Gx+zdbBxBWi5ul+qsF9IvbXRcU70L6dEFp1V
X-Gm-Message-State: AOJu0YzT3zD+HKYBjKhcDRQHBb06zyRlbRrgP2ai9wWY2ZQ396t6PfEs
	pRkyNY4ks/w/diRV5wyN50XlTpIEKC96s5o1GlqgWowbvR4KiIVgy8hKppVCCatRK4kmQz2m8nd
	4og7y/6qSwA==
X-Google-Smtp-Source: AGHT+IH9qLn6o/uHe9WEM8VyAqFxWSMZ3MFnxC1YcYZ+IPtGArmXDrrlLFlgmBP/HenuKUWhjozjdfJl16Pvww==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:26cc:0:b0:de4:e042:eee9 with SMTP id
 m195-20020a2526cc000000b00de4e042eee9mr1003169ybm.6.1714760262024; Fri, 03
 May 2024 11:17:42 -0700 (PDT)
Date: Fri,  3 May 2024 11:17:33 -0700
In-Reply-To: <20240503181734.1467938-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240503181734.1467938-1-dmatlack@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240503181734.1467938-3-dmatlack@google.com>
Subject: [PATCH v3 2/3] KVM: Ensure new code that references immediate_exit
 gets extra scrutiny
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Ensure that any new KVM code that references immediate_exit gets extra
scrutiny by renaming it to immediate_exit__unsafe in kernel code.

All fields in struct kvm_run are subject to TOCTOU races since they are
mapped into userspace, which may be malicious or buggy. To protect KVM,
this commit introduces a new macro that appends __unsafe to field names
in struct kvm_run, hinting to developers and reviewers that accessing
this field must be done carefully.

Apply the new macro to immediate_exit, since userspace can make
immediate_exit inconsistent with vcpu->wants_to_run, i.e. accessing
immediate_exit directly could lead to unexpected bugs in the future.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/uapi/linux/kvm.h | 15 ++++++++++++++-
 virt/kvm/kvm_main.c      |  2 +-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2190adbe3002..3611ad3b9c2a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -192,11 +192,24 @@ struct kvm_xen_exit {
 /* Flags that describe what fields in emulation_failure hold valid data. */
 #define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
 
+/*
+ * struct kvm_run can be modified by userspace at any time, so KVM must be
+ * careful to avoid TOCTOU bugs. In order to protect KVM, HINT_UNSAFE_IN_KVM()
+ * renames fields in struct kvm_run from <symbol> to <symbol>__unsafe when
+ * compiled into the kernel, ensuring that any use within KVM is obvious and
+ * gets extra scrutiny.
+ */
+#ifdef __KERNEL__
+#define HINT_UNSAFE_IN_KVM(_symbol) _symbol##__unsafe
+#else
+#define HINT_UNSAFE_IN_KVM(_symbol) _symbol
+#endif
+
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
 	/* in */
 	__u8 request_interrupt_window;
-	__u8 immediate_exit;
+	__u8 HINT_UNSAFE_IN_KVM(immediate_exit);
 	__u8 padding1[6];
 
 	/* out */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bdea5b978f80..2b29851a90bd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4425,7 +4425,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 				synchronize_rcu();
 			put_pid(oldpid);
 		}
-		vcpu->wants_to_run = !READ_ONCE(vcpu->run->immediate_exit);
+		vcpu->wants_to_run = !READ_ONCE(vcpu->run->immediate_exit__unsafe);
 		r = kvm_arch_vcpu_ioctl_run(vcpu);
 		vcpu->wants_to_run = false;
 
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

