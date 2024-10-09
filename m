Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07621FF7C4
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 15:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489000; cv=none; b=D6ushoRqH0ndovhwan7OQm6t560ctP9T8MRP1INn/WU1MqhXINrU1HMCCRsrM6o4FFHFtY45k7rltXRmCtuLKRwCW/gNTNppUclmnQPc0eIqi0qaYsgrlxxLM9IPQb76TQ8vnxd52+g7pI0ksBNBquHtSlnVHscPAcw6LUzGuAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489000; c=relaxed/simple;
	bh=LPFOToixC43DMJpxxdLhELluVDI5pW/ki1X7rgFZYA4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O6IK7JrUlrFK0nnubwwEWMBKb1Rnsyx3fmPY+3sm14oQHyL4HDRBPjUX29+YgkKt9iLX2pUKDHfkxh8L81ldp7BsA9zmVTraaIYiTnC0PxckKCAO1u4Pqm1/fO+xLEkxCMxCwdqValMrDbfQur4Fep+OJ89SaxgU3uxp+j1KFZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LKlg6oQh; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LKlg6oQh"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e26ba37314so376217b3.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Oct 2024 08:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728488998; x=1729093798; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+3zZkwU+2EpnRGguJhn2Ww+Ghmvy6uOMqwsBdHy8Row=;
        b=LKlg6oQhRM6u1wWZnk1rV0mI8napHBbFrU1Q46svI0DdUBecIOyJ9cnrSD7lkibsZw
         bKE8LA1T7PaM0a0PiZeQFOJvDZezqDFA8NK0CROuMs0fZws4TAulH7GdlbNO4YhbsEHP
         KYloGp2sNTdxoov5n4QRfGumt2wV6mC8F6bCIu936KsdB2jpeKc5bF4SUapgXMyCG92r
         CZ1MNL1Ee/tSFZrtik2KYNW6ojNbA8QbENz9Wd7/anBS5m76Muv7cwlWQy1R9Tw4rI3y
         L0w/GmkEDWoTwFAbhYEWfJwbNCA4jssU8GkBLKC0A9inyP9TZFLpgZofjfunG0kw0uZO
         +dyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728488998; x=1729093798;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+3zZkwU+2EpnRGguJhn2Ww+Ghmvy6uOMqwsBdHy8Row=;
        b=prKjtYOzQNVsgdMmcnsqG2NVrow+FymvfcMTLTcRxjbcIKpXSKwIRN/jUil8+PBMZl
         6tbvpRWl/zkb0AMdlM29KkkqvRRwus3FecGtaxwK+ELNPZWNLs4Kqb8aWHPiU0OuxjU4
         6W7siUFUeEhAjBylkzS8M5k/qC67harRzYqAK+dATi5bp8MfNvxnbwLtSsO2AXorudlh
         7EK1O2/IaKPlFYHKj592Ia2iSoiKKGoA3yaBGtlneIN8opLRyhDJBmbVxy0plxmvRCgc
         0uFWfJWau3FO+okHaJUApLBHm9HUPaksuDx5lOIK/A/7lP9Ufrvj+Uy83sruAKzp/wbA
         VB5Q==
X-Forwarded-Encrypted: i=1; AJvYcCX92oYG2u2XZ2bqNJQAaFezg6XuwaLuwPAkNlx7XxFyV0/ImRO+V4gljdJlb/lT2pLc9Gb2ssM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+LC+PxBlXD02mqeeiUCX5e/HGD4wbEaP3Q1T7F3irqCf5L+hi
	I0RCNkOs//R1/oTDCvDdBcMeV6gRpd81C2bLMhElOyocQ3QaHIYcVe2crqD6TM8TYXhDui7d2r7
	1og==
X-Google-Smtp-Source: AGHT+IGq8S+cJ3hbYyw4prFkdU6bbiVB3Ddo6czJU4p6VUDHrgM9P6PS5yQttOYl+xpjVaNBwpEpnchtMNk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:460d:b0:6db:89f0:b897 with SMTP id
 00721157ae682-6e3221683d8mr69407b3.4.1728488997664; Wed, 09 Oct 2024 08:49:57
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:40 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-2-seanjc@google.com>
Subject: [PATCH v3 01/14] KVM: Move KVM_REG_SIZE() definition to common uAPI header
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Define KVM_REG_SIZE() in the common kvm.h header, and delete the arm64 and
RISC-V versions.  As evidenced by the surrounding definitions, all aspects
of the register size encoding are generic, i.e. RISC-V should have moved
arm64's definition to common code instead of copy+pasting.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/uapi/asm/kvm.h | 3 ---
 arch/riscv/include/uapi/asm/kvm.h | 3 ---
 include/uapi/linux/kvm.h          | 4 ++++
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 964df31da975..80b26134e59e 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -43,9 +43,6 @@
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 #define KVM_DIRTY_LOG_PAGE_OFFSET 64
 
-#define KVM_REG_SIZE(id)						\
-	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
-
 struct kvm_regs {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
 
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index e97db3296456..4f8d0c04a47b 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -207,9 +207,6 @@ struct kvm_riscv_sbi_sta {
 #define KVM_RISCV_TIMER_STATE_OFF	0
 #define KVM_RISCV_TIMER_STATE_ON	1
 
-#define KVM_REG_SIZE(id)		\
-	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
-
 /* If you need to interpret the index values, here is the key: */
 #define KVM_REG_RISCV_TYPE_MASK		0x00000000FF000000
 #define KVM_REG_RISCV_TYPE_SHIFT	24
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 637efc055145..9deeb13e3e01 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1070,6 +1070,10 @@ struct kvm_dirty_tlb {
 
 #define KVM_REG_SIZE_SHIFT	52
 #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL
+
+#define KVM_REG_SIZE(id)		\
+	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
+
 #define KVM_REG_SIZE_U8		0x0000000000000000ULL
 #define KVM_REG_SIZE_U16	0x0010000000000000ULL
 #define KVM_REG_SIZE_U32	0x0020000000000000ULL
-- 
2.47.0.rc0.187.ge670bccf7e-goog

