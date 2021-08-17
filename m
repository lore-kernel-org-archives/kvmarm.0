Return-Path: <SRS0=6VsV=NI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3053DC4320A
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB9B461008
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DB9B461008
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E64C4B148;
	Tue, 17 Aug 2021 04:12:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YyKNBr5gQsOW; Tue, 17 Aug 2021 04:12:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E45464B160;
	Tue, 17 Aug 2021 04:11:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F5B84B149
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:11:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OsoXDKpP+0NM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Aug 2021 04:11:51 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C1364B13F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:11:51 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 d20-20020a05620a1414b02903d24f3e6540so1632544qkj.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 01:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=aHCf3CwNNBrmIRx2wJpLYl7QdQEwhZAoOTdqtlemKNA=;
 b=nmj5YInKovfYpQ7u2gu+Y7J66loXt+NDQNemJ7HGUcKXj0fC7wwCSMymCEi4G21L3p
 IArJSFzNsytGyM9Aj+pPYXesA9Vm/c7zfGQmeaSoLhwVGjTFnvS9R+lIcvVEM8C1k/YR
 vWzurZ7ebNzykXtZc9niVn9GYk9PSDHnApssgQ253v3a0E1TACnW+kba/jsCf/OUQST1
 lRY+I29CFT8E6+v1g/A8yjDZEgGVBkXRxQmXua664ZpNGjHjWAh/aYXWpdE3sTpV5KSC
 4F2hbJOwiqlbmgpuhHpxBsZ8LyTztDaiQNI7jgWINBi0Cz59uNMk+MX/4294lx7erU0g
 aByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=aHCf3CwNNBrmIRx2wJpLYl7QdQEwhZAoOTdqtlemKNA=;
 b=N3LICuNO7KJEne0OcROWPuOHk6N+WFK0hJPK8M4ZhmpPCFX+3uz2nSv3ylE+WQE+2E
 xje/ot3AEu7hEomy9qKHEHwj3Jt6mWyAAFZ1IFPnjSfJeBB9E/Z3WGPS61CzV1cSUDSR
 3TvRChP12nDPpyrWZ161/w6hoIzcpRVDHrTY5PakSGtuXJjo4mVmzaLYCN1cOqOrjjt/
 ep42/s1BmWAq17jU/lDuXvnF29h6CN4jhOJLbG7lJobpBkRKzdslss50XtEtlxod8ylw
 6JDKw3grbaBo9tWZaCvOyr/T3GpDDq2f0XwU4LcuBj+loGcJxcRe6I/4OX0EfNZ8VDsB
 ryaA==
X-Gm-Message-State: AOAM530FYlZliAyuwXP2xeCPThymYVxNhzqNaC9hc5ro0NdfMsDY/UpQ
 Z8r+XPH7RPPpCGcAFCTXvtSRZypypiBRvUaRWef0kMyyHhORjtAUtS4uMqtiiZPEtMAdMEqhusR
 bAFvfi5/lO4DkSWxLvN11d79TsRieJ1+GWOAvCTZUdmdVWIlWV8oJBduAP5FRIcqpr2s=
X-Google-Smtp-Source: ABdhPJwo9+n3O7kUXlMfd9UmZiDXQnjQGGvtzSb/qI8QL6++MTL6aNWs0u51HkTG4jUJ6+mkEPCkxCl2mw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:1933:: with SMTP id
 es19mr2165343qvb.42.1629187910879; Tue, 17 Aug 2021 01:11:50 -0700 (PDT)
Date: Tue, 17 Aug 2021 09:11:26 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-8-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 07/15] KVM: arm64: Keep mdcr_el2's value as set by
 __init_el2_debug
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

__init_el2_debug configures mdcr_el2 at initialization based on,
among other things, available hardware support. Trap deactivation
doesn't check that, so keep the initial value.

No functional change intended. However, the value of mdcr_el2
might be different after deactivating traps than it was before
this patch.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 4 ----
 arch/arm64/kvm/hyp/vhe/switch.c  | 4 ----
 2 files changed, 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 2ea764a48958..1778593a08a9 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -90,10 +90,6 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 		isb();
 	}
 
-	vcpu->arch.mdcr_el2_host &= MDCR_EL2_HPMN_MASK |
-				    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
-				    MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
-
 	__deactivate_traps_common(vcpu);
 
 	write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index ec158fa41ae6..0d0c9550fb08 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -93,10 +93,6 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
 
 void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.mdcr_el2_host &= MDCR_EL2_HPMN_MASK |
-				    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
-				    MDCR_EL2_TPMS;
-
 	__deactivate_traps_common(vcpu);
 }
 
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
