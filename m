Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F7DC433EA
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CFF93207BC
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ShyoY1k1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFF93207BC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88C684B381;
	Wed, 15 Jul 2020 14:45:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id feS0SIRwNSn9; Wed, 15 Jul 2020 14:45:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 784114B3DE;
	Wed, 15 Jul 2020 14:45:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF73F4B3C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mtHv6ko0zA5w for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:27 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E6F494B3DF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:26 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id g6so1755330wmk.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=VT2yUZAMgbSbYqRqxmiodXt9JjJ+rlB+A9pxnjrPrQk=;
 b=ShyoY1k1CxIgGwlU2mJ6DkzDMb1WhXXMFB4P5zlQDrUGUiA4etlRbLPlZNPM+QAnGS
 yq/vYkbKnOQnHWrM0n/3JZTzYqAxTCxPPtK+ywYhsuZ5JSiDgINnmrOptzFQvtZWB6zv
 rSk6dzrA20IAotyfhTxkPu7smPV7C7oRDHbgCvqNMUAeKfWMf4/D8nhXIy1C1itShT9S
 tOFhLQb2WR7IkjelCOsDeJ5Yv1S5HJWDMahy78QRbcT7ihnvbHyuvA3mp7H4CAsj2xg5
 RsAar6cqBd1hCMZM5KluX9Avo3v8/4qK+0gdYeSs4VzOSbcH8wD/v47w3UEo+6TtI9oj
 8Rpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=VT2yUZAMgbSbYqRqxmiodXt9JjJ+rlB+A9pxnjrPrQk=;
 b=qawrVWA4uxZhPzK7VYfngRa5LTTGr2agQ7LnEwdHX6vP48F0Dz//l73VzdcYgoWuhJ
 llmSp+fLtrl/v6gvKry6txvaBjcLMY67oickfsBE6H3G7RoOppc7GKSLQVhQ5HnuDDg9
 2AyUWCa/BpwB3Rqw0FgGPO42Z0qiGaILOwgoqaKpgxVsFaMVhMiEZuXqh+gQ+z0xDtZG
 AsxXKZzgrLwNHKJiFUR8XTbL5Tja7cBWq4FMd4UnP+NY9cBFZGWWI5ARire3KTqRBsTH
 8HuY4AS7hbC7/7GIWeeauiGC2BRn/yB2xe5RzHQqZPqf1pAW3/9com1zBeO3eCrUB8XU
 4y3g==
X-Gm-Message-State: AOAM533u/mPibVinWwdfcqCkejKmwFSmlnNOtrpaoLCoVtZg2Lndw/d1
 mA/a6eo+jALDvoFZAjdPXEt3UrIJOauw8x0CLkCjlRpokLGChAPzmYwuKXR9bP+u86vkogXJcZH
 hMyG9TyYaKatI41JeXt6X6Buz37URxMVKDH4/mAR8dLZpM3QfYJ9mHcsXMXBSgp5cA/Q4XA==
X-Google-Smtp-Source: ABdhPJzFf2fg/dcjQBH4Krs8WYYhzlpTbXX31A/UgsdstDQl4XMweYemyKzl2o1zAtVZDhC3RbLTsiq7d+s=
X-Received: by 2002:a05:6000:1283:: with SMTP id
 f3mr758075wrx.106.1594838726059; 
 Wed, 15 Jul 2020 11:45:26 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:18 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-18-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 17/37] KVM: arm64: nVHE: Store host sysregs in host vcpu
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com
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

These registers were previously being stored in kvm_host_data, however,
there is a vcpu specifically for the host state waiting to be used.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 36140686e1d8..ac19f98bdb60 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -153,6 +153,7 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 }
 
 static void __kvm_vcpu_switch_to_guest(struct kvm_cpu_context *host_ctxt,
+				       struct kvm_vcpu *host_vcpu,
 				       struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
@@ -170,7 +171,7 @@ static void __kvm_vcpu_switch_to_guest(struct kvm_cpu_context *host_ctxt,
 
 	__pmu_switch_to_guest(host_ctxt);
 
-	__sysreg_save_state_nvhe(host_ctxt);
+	__sysreg_save_state_nvhe(&host_vcpu->arch.ctxt);
 
 	/*
 	 * We must restore the 32-bit state before the sysregs, thanks
@@ -206,7 +207,7 @@ static void __kvm_vcpu_switch_to_host(struct kvm_cpu_context *host_ctxt,
 	__deactivate_traps(vcpu);
 	__deactivate_vm(vcpu);
 
-	__sysreg_restore_state_nvhe(host_ctxt);
+	__sysreg_restore_state_nvhe(&host_vcpu->arch.ctxt);
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
@@ -239,7 +240,7 @@ static void __vcpu_switch_to(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.ctxt.is_host)
 		__kvm_vcpu_switch_to_host(host_ctxt, vcpu, running_vcpu);
 	else
-		__kvm_vcpu_switch_to_guest(host_ctxt, vcpu);
+		__kvm_vcpu_switch_to_guest(host_ctxt, running_vcpu, vcpu);
 
 	*__hyp_this_cpu_ptr(kvm_hyp_running_vcpu) = vcpu;
 }
@@ -288,14 +289,15 @@ void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg(par_el1);
+	struct kvm_vcpu *host_vcpu = __hyp_this_cpu_ptr(kvm_host_vcpu);
 	struct kvm_vcpu *vcpu = __hyp_this_cpu_read(kvm_hyp_running_vcpu);
 	unsigned long str_va;
 
-	if (read_sysreg(vttbr_el2)) {
+	if (vcpu != host_vcpu) {
 		__timer_disable_traps(vcpu);
 		__deactivate_traps(vcpu);
 		__deactivate_vm(vcpu);
-		__sysreg_restore_state_nvhe(host_ctxt);
+		__sysreg_restore_state_nvhe(&host_vcpu->arch.ctxt);
 	}
 
 	/*
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
