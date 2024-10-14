Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C37156676
	for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 10:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728901463; cv=none; b=SXIN+DL3zQe9/Xxnps+7GUZv6xzyu6MV5GFqQ6Mm7GzGo7uDodsF/S7b8H7o76584vuH1korocf2YTDa2/TArZ6LhjvRZExLPuBSM9EhACRFEhFbyVMCBFKKdUzstEFyXqy/+qxK7rJmRWUOYTtfVhqDPSLgTxQZcFUP4zTmnis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728901463; c=relaxed/simple;
	bh=Vck8cq3zCt7pXIKRoJLT7kwecGWLBED0RBJGOMQKGPo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HKHlpzxD6xCbU4wcdnYMG7PPOwpSVz7yUDOVi8Vj0NQHo5K0JDkW0MqeQPP2TjMUT/CYjL65yF5QIjXeBGTISgnfwRECKsYSfNUx4J/U1oZybKzfLUZ1s3gCtVZr4KbihvDBpuH9kt9pBvKb/d2SToyddCnSwa/CP0W1Hq3ckmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hDLPJ2HS; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hDLPJ2HS"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-431186841c1so22102915e9.3
        for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 03:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728901460; x=1729506260; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i87FExk+Kcaf4e4cjmhuQVj4Z5srtO4tuZ/PkrXIF4w=;
        b=hDLPJ2HSeRMNGQRvQszBttPZ3Gs2+W4B+lljMUsw0xmmFtVTVNuGzdjoAQFytalYJL
         sao4ICXz/uhKapdsIz6fqneL2nfvzFj9xjmU/O+10RzflQJ5WhOIYJRvfr8Yp2kEXc0f
         Bp8TgB9pM2hLJEzkFPBo+1VoDfMha2ow8Z6YrbQ2wrbNJLAHYLIhDZAizPgVc0cyF9WY
         GF5va16TYCHJjKcGgdjsBZzxk8i9QJsePE6BCNXLsUzPzVDtgDBRXsae5FKXY4shxU/e
         iKKqOh4GDpHw27qOPzOZwaQmb+FBJL9IXA14pUxj+bi5AmgRFSkrAvWDL/BA5DmsPfja
         j+mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728901460; x=1729506260;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i87FExk+Kcaf4e4cjmhuQVj4Z5srtO4tuZ/PkrXIF4w=;
        b=QO2Y9UYBOxf2yRUjoDZhm3CvHpVMlVkeGDXC+vWd2TkBZaWdbAs4cCqcDszBXlQYo8
         sygKc2WqWRKfDg3q5G50CpcAPBmngukBStXQLD7YOnfIT6YLsnOvZAP12IHOFE5LgRYK
         BK8odtUkW3yMLerQq7SydV+6mPGQ+jLFhxmuuZcBQ+wJJloozm/LpbZMgX6sAFAQ2ZqZ
         /tq676tFeb49envsRa2b7U+vP4j01L1naDubOopRIZd4QtiLXN6hAFLAGYGuJJToOXka
         PiOnlbs6z5wvRYu66Mwq/rQE+JbDa+SUVDN0JTgpyIE42YeCd7lF29B7xrC2pFoQOxxx
         M/MA==
X-Gm-Message-State: AOJu0YzeLf1cbMinn7l5kZ8ArQ7/0E4R7NzwqbiDFm4tbQUFvQtQFASP
	pow9cTVDx8D57CK/gm0nihEVlsbcSbFEX/jXHy8G4rvsjSOjw0BcdOmhD3TrjDDVUqhS4hI6Iev
	fe0FJeWg0c8JcfQtqUciCuTTA8+CHqJTxgs/XPl0124pJISkmD58jQQIpENYz+Hk78431y2Nrli
	6JBj2Pq/xcA80oUDwU+clAQNLymAM=
X-Google-Smtp-Source: AGHT+IEa7BbQEc68d0k4io0oYvMDWb/wvrjSCTr2L8qzK5jrfUf2gb8v8thpzWho03u8r+0oquGiMRV8Sw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:22c1:b0:42b:af5c:618d with SMTP id
 5b1f17b1804b1-4311df8d81bmr1315455e9.7.1728901460117; Mon, 14 Oct 2024
 03:24:20 -0700 (PDT)
Date: Mon, 14 Oct 2024 11:24:10 +0100
In-Reply-To: <20241014102413.4092725-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241014102413.4092725-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241014102413.4092725-3-tabba@google.com>
Subject: [PATCH v1 2/4] KVM: arm64: Refactor kvm_vcpu_enable_ptrauth() for hyp use
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

