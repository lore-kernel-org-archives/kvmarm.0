Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0E018BC3B
	for <kvmarm@lists.linux.dev>; Fri, 18 Oct 2024 07:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729237722; cv=none; b=mTBvnptgdZrtKeOVEpjzqBl+R/+O+HUPhrtqM7pRnHeCuKYoSYMJ97CHbrvnus7Lm+WCGN2Po1sMFly1/wEs5jCcz5C+wgoztGKas36PPAA+hVT0cE5ecITYkzVojYMzkmvA2k1bVdIP8x9VXFdg+pS67eJFIg5nITo7pz07eKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729237722; c=relaxed/simple;
	bh=Vck8cq3zCt7pXIKRoJLT7kwecGWLBED0RBJGOMQKGPo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RQx/seMUd+UaLSiVwwCKqVfP7VJvz5k/hB+TxU8HqQM6H8Dj/iGzNvpEcnjMCG6pj3OAjXSrcwq2SDOlK9Wz64xJaoup5FcIY6ZPph4Do6fVccdBUnCTzHjfth0bhXDwB0lIQGXqcnxNCvrbFUye7EAyDTiPIfz5TcVFaj5REsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UcqOQ27J; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UcqOQ27J"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e1fbe2a6b1so32267547b3.2
        for <kvmarm@lists.linux.dev>; Fri, 18 Oct 2024 00:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729237720; x=1729842520; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i87FExk+Kcaf4e4cjmhuQVj4Z5srtO4tuZ/PkrXIF4w=;
        b=UcqOQ27JBHSjIPeG7PvblDwxw4c269ZiJSJwsqf/cRB+8Qihw+5i1Ufpb7l2Gtiv+d
         rMsvjTH6mHZWJfKmqOkszgBV0AZzOJvDbufLsiYfuEeGjQTvMVAjboBTVjUke2IAYomA
         Qr0fjwwFMn2v06pPS7n6iBJV1m1oeCM/RY88RgSOPHyJFzK+J8NGg1lzLG2Iy70gkkXU
         62QBBdwCo5ZY40rM6CyQ/gSbNywWY0lpI/GBIicPS6inBgdbtQP5Nb0QPKeEgP2Akq5z
         g0uujr9eF/5J1V8ia7/m14TQdjUCXpupS6vjLF7zObSMScguhY5Ps6z6cv5V4BFY4hBV
         Sr2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729237720; x=1729842520;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i87FExk+Kcaf4e4cjmhuQVj4Z5srtO4tuZ/PkrXIF4w=;
        b=os3eQ/scw1PAM9/WWLyFEH9OBE7gapwuADo9pLMMqcRuTLMieUuqqvcxdvw6VRaNzK
         awDGtXeBkkvVH2kH8gKlHL5moIqimHFPxO76+uvEmo9AHQzf2hs0vn9DhE6UYYNnXftd
         TRAk2XluiYxP99K9V4q1XfE4mVeAHm/gtdy73m1MpFREeu9JpAGeuIuMNdesC7Jk0oi8
         n7ADGaMiiQpifRgxTMLynCIzJJFp9egglo3Pmijyq29Cqmsrbd30oEyg/oZtHd7xa/8F
         e4ilCoEOWD7J+DbnSuowXw+QYwHKkCl/z6t3pdM/nU6wK9i6CksOuL9dpfoiHbOXm+l7
         EHMQ==
X-Gm-Message-State: AOJu0Yy3+dYXGKVVf1kLOt3KfJP0B3h5aZ+df9cgtJmnHF/VSO9j83Hu
	uKOhf3jFNUkG6yYy8KnC2m+KZ6SQ6q8uHKsrB3mX8EAHcDDoCPAXpgvHyqURQZ4Go8T09FNitA6
	cXCCGMqxbY1Z4vikZxMJz5o76aQSR0gpKU05/6J0tOdmAa9ASUWtTP61JBqrkgE92OQy21nrUIt
	6cIQNJkdoA5UytrIVfUCwX+rkIT4o=
X-Google-Smtp-Source: AGHT+IHwCFzZczJClzNjk8bfTA9dTHFtmashTXFjLYR+q6pZgJlnPEffBk/6Axr/zYxo8BuIo1iMjGeDqA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:fc2:b0:6e2:70e:e82e with SMTP id
 00721157ae682-6e5bfc0c757mr247577b3.6.1729237719910; Fri, 18 Oct 2024
 00:48:39 -0700 (PDT)
Date: Fri, 18 Oct 2024 08:48:30 +0100
In-Reply-To: <20241018074833.2563674-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241018074833.2563674-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241018074833.2563674-3-tabba@google.com>
Subject: [PATCH v2 2/4] KVM: arm64: Refactor kvm_vcpu_enable_ptrauth() for hyp use
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Move kvm_vcpu_enable_ptrauth() to a shared header to be used by
hypervisor code in protected mode.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 4 ++++
 arch/arm64/kvm/reset.c               | 5 -----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index a601a9305b10..9a68befbeecf 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -693,4 +693,8 @@ static inline bool guest_hyp_sve_traps_enabled(const struct kvm_vcpu *vcpu)
 	return __guest_hyp_cptr_xen_trap_enabled(vcpu, ZEN);
 }
 
+static inline void kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
+{
+	vcpu_set_flag(vcpu, GUEST_HAS_PTRAUTH);
+}
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 0b0ae5ae7bc2..470524b31951 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -167,11 +167,6 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
 		memset(vcpu->arch.sve_state, 0, vcpu_sve_state_size(vcpu));
 }
 
-static void kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
-{
-	vcpu_set_flag(vcpu, GUEST_HAS_PTRAUTH);
-}
-
 /**
  * kvm_reset_vcpu - sets core registers and sys_regs to reset value
  * @vcpu: The VCPU pointer
-- 
2.47.0.rc1.288.g06298d1525-goog

