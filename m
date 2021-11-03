Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F0EAC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:27:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DDEF060F70
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:27:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DDEF060F70
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C32849E57;
	Wed,  3 Nov 2021 02:27:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZRlFqNexT6jb; Wed,  3 Nov 2021 02:27:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C07C4B101;
	Wed,  3 Nov 2021 02:27:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FD274A19F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:27:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id biZ6zJuARa1t for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:27:18 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 461A249E57
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:27:18 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 w13-20020a63934d000000b002a2935891daso997591pgm.15
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=eVXFsIu2A0jcHNwkwUYO+pTUIoPZ1YXwb8zzymW3agQ=;
 b=XD1dMhNRonxvZZ9i2UCcZCoIvIEj9v7vxdtIWeG0WTFpcrY4lN/dj+JeBCeRGtUs+b
 TKOC+JBs+wHF9sqEOE+NK+uX7MR7JGXuZ/97c2qmTC9prsj9gzFwFDUkQBwwEwaW3KMx
 /CPyyLPCvdbnsY8rtKtXzgvMrI6FOl0KEcIi7a+KusBwBBGfCdZrwuakzoKxbGaE1Hpe
 kEWU+ZfLgmoWcFVw+9lQjr5zGO6EGaJfXCH2ifB88gJk2oENMhuChuVILNxWj087Pa6l
 3gO5JSvtCAnNz2AFkvgeb9oDEv+Cg2swChDGNWLQMmmXx65F2wRetqzAntKGaBGB/5bM
 /G1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=eVXFsIu2A0jcHNwkwUYO+pTUIoPZ1YXwb8zzymW3agQ=;
 b=tZQHcntl0Zq6/mJYjjoM+shvjCgXWqbLXVnPSvToEd4IUEAxDIEFJdjM0F1+RStJC7
 2e0b4EIzJCanFjI5K8YZQTozDU2syo1mY7EtImiq/yACp9eMhLYeHn3/FStffPOFNo2K
 glCISgJoxpEiRKBKsLPvXsup98JNJSQfq65V/krnrPoGITp7G6aCMAmo0S3odcDMCO24
 eEK9fdYhyC+08+SD0dow3+0qdERdp8ds9tyBvc7mb8qXDVeL6l5CjGVF2Qmf4W7VgvNY
 ezBM8qB9dXztt5k9TbW3y7pv+MEC9IIe7belVlkuJu5fUDNlqYyeOaF1YY/qQY31FKex
 9orw==
X-Gm-Message-State: AOAM531etC5xhEP2JA2UcAJMQHuWNn20f3vHN50BoWZDTUU2sYW/R20O
 O3QgTw3Y+itoU0SnaKU0u25U6l3c29E=
X-Google-Smtp-Source: ABdhPJwf4BoucPOZITph2SZD/P4CzLQM8u6ddsbijqFxfHoaATosOtV5geGGgyUp899HzSt2uQ0f+XQH+PU=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:dacb:b0:141:e931:3aff with SMTP id
 q11-20020a170902dacb00b00141e9313affmr17384890plx.50.1635920837395; Tue, 02
 Nov 2021 23:27:17 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:24:53 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-2-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 01/28] KVM: arm64: Add has_reset_once flag for vcpu
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Introduce 'has_reset_once' flag in kvm_vcpu_arch, which indicates
if the vCPU reset has been done once, for later use.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/reset.c            | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f8be56d5342b..9b5e7a3b6011 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -384,6 +384,7 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		gpa_t base;
 	} steal;
+	bool has_reset_once;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
@@ -449,6 +450,7 @@ struct kvm_vcpu_arch {
 
 #define vcpu_has_sve(vcpu) (system_supports_sve() &&			\
 			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
+#define	vcpu_has_reset_once(vcpu) ((vcpu)->arch.has_reset_once)
 
 #ifdef CONFIG_ARM64_PTR_AUTH
 #define vcpu_has_ptrauth(vcpu)						\
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 5ce36b0a3343..4d34e5c1586c 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -305,6 +305,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	if (loaded)
 		kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
+
+	if (!ret && !vcpu->arch.has_reset_once)
+		vcpu->arch.has_reset_once = true;
+
 	return ret;
 }
 
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
