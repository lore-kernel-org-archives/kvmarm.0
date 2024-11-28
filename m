Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3F2E56A
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 00:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755354; cv=none; b=ck3utMLIm7Z30DPqKIPIuOV18T4St1v4yVERoHkVuob/atDE9IGWnd30y8pN5r0saCw6XHV+OcMD3Lx/bhSO8Zo716OqYVzl7SeeO6qWGZEdJjFadv7aDteK22akP3TNUonwSvM1hLXgVv4FZ4a6Q7fVxZkUf1rJtwiHBffKyGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755354; c=relaxed/simple;
	bh=jpG2Z0wLkJo4m6LTchsXKdavjrJbj2n+h3dPpHrcu5s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QnBMEEPvBU9QvHNNzAVv8bm/4bI2OUKPDD9DD0ow9WwEa59TSSwijsXYyEXm+o4dRNTGKaZCfNSIad4kkO4WB5PfEaG04R8bFD1LiC+h+DkdksGXRYeIJo7KA+cyQ/Nj+EqnYHGeBvgbdghPE9Wp3fAF+/mFJnCZnBUBQEWwgSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EitDcZTc; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EitDcZTc"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-72530f542a8so291118b3a.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 16:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755352; x=1733360152; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ziTWoMDGGemt4FbzSlGzzl5MJ7+5E+c66t+aoBco/o8=;
        b=EitDcZTcFLVJgIliev/C3Fvb5AnO9RN5e6LivYotkpIAYOtubVNLwTfwoCPwFVvy9O
         aOGG1QrAOLPkmjo0bi3eZy0Q2S/8HbzNJZNCYyk6rJc8Hvz/K3ZcCu1FNMPKXdD0yzKk
         TvrAxXHIuOXmFj0FWZ2+lQSN2/m2SMIhid5nzz8OTSH8Tv7+0xN5plV1mFUCIM3OsNwV
         Xq6chQ65KQ13lbTj0h562smWSyW6pIeW1xr7LeoDj19OhVmvcI7Eh/pmji3IPZ9wbADj
         A/UXabSAp94odQbpARgFl4cZAsM4Zt6wAIX+BaNzkQk0gfrxHtW0JtdcjjuVEdjVRYKZ
         C3iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755352; x=1733360152;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ziTWoMDGGemt4FbzSlGzzl5MJ7+5E+c66t+aoBco/o8=;
        b=pfnirC992xGsJ0s2Z1QAk+y5h+ZNVJynQ7o3TL2I5RWNCuR0Wge+woatftWvU1rxoQ
         TyNIvjDuJfqwiBt9A53jdpn+auEIzpi0vvCINaE+l0QZEotIVRJlUB5Nhe8OT0Hpv9ET
         ykTNBghJvWZ9pGVhmSSUJ8GqCcE4wVrOXVYBAaiFcuoGPVow4Ef2KM4I/7urBm0CtvNX
         Q+PepRwRRylMQ/vHq8FVj9A6afCQBQJwrYwOwagXaFQKzflQkEy+atol28qeB9DMVGzO
         P1jZyMIlhSFmELJF8kHcJw/OXqWq0RKPyxt2TzPm64qZ6+obSQ4oaIBcK++8uc8kR7Jy
         GaXQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8Kb676ShG46DhJJEOfe7IPWk/SRoLIYFqz5Qqr2LeBUK1ejwRsns7EqwavZv5UXOK55I7nsk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5W+BY2lXJeL7z+be9RnFzVyyQY7JdcqTWiMlvGg47VKsH0Ifn
	J4Aw+1KNOtl+RmtsFKKCkGU1I0G5JtB0mPsx5Ip3AQDFSp4ACnRbey/ZVAagu1Q/Rwqam2v6Zi9
	LAw==
X-Google-Smtp-Source: AGHT+IGFU4JhoxY8Wl9h7ACp8Vt7EFu0qd1J8Nu7Xlwl+xjZW64YiOpSApDQOPp2K//2LZM+CyuzFG/tlB0=
X-Received: from pjbnc6.prod.google.com ([2002:a17:90b:37c6:b0:2e2:93e2:fe46])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2252:b0:2ea:8b06:ffcb
 with SMTP id 98e67ed59e1d1-2ee08eb2b91mr6443403a91.14.1732755351961; Wed, 27
 Nov 2024 16:55:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:32 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-2-seanjc@google.com>
Subject: [PATCH v4 01/16] KVM: Move KVM_REG_SIZE() definition to common uAPI header
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"

Define KVM_REG_SIZE() in the common kvm.h header, and delete the arm64 and
RISC-V versions.  As evidenced by the surrounding definitions, all aspects
of the register size encoding are generic, i.e. RISC-V should have moved
arm64's definition to common code instead of copy+pasting.

Acked-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/uapi/asm/kvm.h | 3 ---
 arch/riscv/include/uapi/asm/kvm.h | 3 ---
 include/uapi/linux/kvm.h          | 4 ++++
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 66736ff04011..568bf858f319 100644
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
index 3482c9a73d1b..9f60d6185077 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -211,9 +211,6 @@ struct kvm_riscv_sbi_sta {
 #define KVM_RISCV_TIMER_STATE_OFF	0
 #define KVM_RISCV_TIMER_STATE_ON	1
 
-#define KVM_REG_SIZE(id)		\
-	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
-
 /* If you need to interpret the index values, here is the key: */
 #define KVM_REG_RISCV_TYPE_MASK		0x00000000FF000000
 #define KVM_REG_RISCV_TYPE_SHIFT	24
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 502ea63b5d2e..343de0a51797 100644
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
2.47.0.338.g60cca15819-goog

