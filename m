Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEC814F13E
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 20:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087344; cv=none; b=WeK2ftGQtnRQspFFl2BrqG6qeOCMHpSBojaTZvS+dvDnrBahHIBYJuQsvDTsJxUahMfo/2oElnpUBs575Fh2nFPE3yH7CdNIW9EKphF8T1C/rtkPjXiHULOD5XxIXFxVnezygmxAOSjDcOAIQYPd/RdEccYvBIuNdQHoqY/s6LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087344; c=relaxed/simple;
	bh=+2F9I1POxGoi/9M/7fMvRXE2RmZfeCTY9lrmE922td0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CkQPL3ogsuZBYZpWGV+E/CD9dl2ucRPFnH9PSnoLb3F3362AoqYdt7sjt+dn9EdudhUYJB31tqJ+0B8lIVOPa28Fy8p/u8gM9kcy+B4PN9Ispu1q6KCD8aEybzBtLXovvOOhyp5HjwZIVJ6QakUsLtGX2d+DGmwqqyDdmUghSVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OgAvb810; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OgAvb810"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2052918b4f4so4644545ad.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 13:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087342; x=1726692142; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+KcQL/bdCq18fS3rSOcZm5DU7Hi8Axoom7HVevkC6r4=;
        b=OgAvb810dbeBJTsUaSvjzcxXpUBSbo7m3LkGvXpHMAhVcg0lvAC8Y7TwskpFr6B3O2
         7TjXBt6g6tTvdT/5ztYBgRXyT8cMRg7GfzVC7LOS5aN7PG8eYqQ2E7QNtD/OPlgpoVOE
         FBt+DC+ROK/msl036UBKaQPDK0nqAn4BqTqDVU4B5qg/xouEUyz+HAKn5cnfT8fgG9XG
         G3+JhL/2yD1h69wPP9YOWLq+2yc7FZ/dM9rA95HXxys0IOYzO3x8yPsN+EEJOZxcrxD+
         eQOErz38FoebojkWMUu7iNBNzPzyCT6cp4k2FyoASC3/XgjreIM3lkJHOEZChJAcSJhz
         5MCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087342; x=1726692142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+KcQL/bdCq18fS3rSOcZm5DU7Hi8Axoom7HVevkC6r4=;
        b=kl5BVVVXT7lU00ZAp9UmbQTZNp5paRzUki+qksC0yKT+lmAuG0ZSWx8FMaaJ7oRvi/
         hctCy4BUz3o8/e9XZ+e2keozJEon31vCsPHe0nk1NMwu7xxtqQ6JPdfEejh5VcPpHW6e
         boEK7yndDnmzQZfr6btG8XiG24fF/gyLo/gW2UqUb5+RsxhkIkPz1nJMjSs6iPOOoL+e
         x0k8+SJnPBIbNGmHhYs0hLFCPlkeyEvpKwQuNHX16i1kc/twbpR0lAlmWDQZp9q7iJML
         9AyP5BpgIyocK0SvxvKv8Or0bhFhV2NnI/7bGxQyYRuWGqJMz5hJtKicYKFriwjqfd0U
         NDYg==
X-Forwarded-Encrypted: i=1; AJvYcCWwNCjBu8axpDXHZFYQhmgpJSS8nkTyIN4bdqPjDhcDc2n9M8goqpcZOalGiRlYShvVzpp3eGo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0+8AVO9YkKFI0XBLYleFpRk4tC0q/0E3/K78HDXZh1RqoGUpB
	D8U6k+Qg+MzCzLc1GZa2BVqOcJ6YsBrXBzhvuqzLCVjt20lCy2hkovLhs8rKAvIUECqlcshRoS3
	Gyg==
X-Google-Smtp-Source: AGHT+IEO5NwWx0FrDp8QKSLHZru3Ive0KlYcZGHHsB7iPFbn3vSIzuOoVV6CHwgKSaGOFRDtrL7V2ub0u3g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f682:b0:202:4712:e84c with SMTP id
 d9443c01a7336-2076e3f784bmr227705ad.6.1726087342373; Wed, 11 Sep 2024
 13:42:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:46 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-2-seanjc@google.com>
Subject: [PATCH v2 01/13] KVM: Move KVM_REG_SIZE() definition to common uAPI header
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>
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
2.46.0.598.g6f2099f65c-goog

