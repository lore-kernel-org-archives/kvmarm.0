Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8389C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 18 May 2022 17:59:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DC184B329;
	Wed, 18 May 2022 13:59:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FM8fyBOif3iP; Wed, 18 May 2022 13:59:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FBD04B322;
	Wed, 18 May 2022 13:59:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F90A4B31F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 13:59:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xkA853rPikqI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2022 13:59:13 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15F884B322
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 13:59:13 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 jg18-20020a17090326d200b0016178ae1c69so1250891plb.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 10:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ngCuMiQQu2crWaF3N2+jr0MQPsojQwzxANrtvFLoUs0=;
 b=gEFnGQRvL1SNUeweZldlNB86h9cbsmE4kfueDxykeLC/dgnbC0SW+2zdJwA8PwDw3d
 nJcI92lhr0cTAkYC081GdamU0nFn4qz63tbJnUHAWZZM7p0i5OC3efWKdPGxiDYYSOvn
 US1kgaHZgh0AJrTlTCqeqJ0KWTTu5Vg5Zm/3+VdiiecTxvK+6Mc8P74ANC43GhnciX3l
 klYm8L1zxexX5JH4E0wKhLTh05FhuSJb/RCh8FZMMnl2aduowRZrqhMoO3eQFiOXDC+E
 5xQtRe/6bAGUTFBmBJ/8cVelvh0swyS46siJSC75IlQtQyz52F8D0yN3qSHhIOJuvU7o
 r2kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ngCuMiQQu2crWaF3N2+jr0MQPsojQwzxANrtvFLoUs0=;
 b=4E4a+jzsWUFkr8+5TcxmwRT5fveTtimHUszW09oN/DfbIuUCT0f/64FtHq44PG0b/t
 woiESIVdqPO/voKv1o005yZKQUOQF9167UvgoDypDqdgL1e/j6ShQKiP6DME4x5R7MT9
 Gl3bL4qKA+E2PIYbRLN4nUHsdYsRXZejK/djeaA/Qh5eqAPw1bYBQqRk777vBDz5BcYy
 zKiWRuahWrEidWnbnp5KL1g4VnTu12AQk+g11JT9s4LK7Ai8OQgzdbp53Ud9+YfS1ynw
 9BHMNz5jCGlgq7vdyv3w/+o6fxtsh7Jh+yrfugUk51zwcdnL2jSEVoZY/UwkK8/IfrPS
 TdYg==
X-Gm-Message-State: AOAM530a/vgxfBnUGbrq5qvrKGhQ5ImPjc+6/nQUXfCk3AZpDTT2tan2
 X2jmrAIrVGh/708N1mef6OoXrkuWIvU=
X-Google-Smtp-Source: ABdhPJyBeXg2Aa9RwjM1V9d2ErVROM4+cPUe/IbabCLnLVoPOu/rW/D34Dh5ELw+xdfdzqlCet6MBrjc+sk=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:90a:2a8a:b0:1df:26ba:6333 with SMTP id
 j10-20020a17090a2a8a00b001df26ba6333mr350472pjd.0.1652896751753; Wed, 18 May
 2022 10:59:11 -0700 (PDT)
Date: Wed, 18 May 2022 17:58:08 +0000
In-Reply-To: <20220518175811.2758661-1-oupton@google.com>
Message-Id: <20220518175811.2758661-3-oupton@google.com>
Mime-Version: 1.0
References: <20220518175811.2758661-1-oupton@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v2 2/5] KVM: Shove vcpu stats_id init into kvm_vcpu_init()
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu
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

Initialize the field alongside other kvm_vcpu fields. No functional
change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 36dc9271d039..778151333ac0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -440,6 +440,10 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->ready = false;
 	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
 	vcpu->last_used_slot = NULL;
+
+	/* Fill the stats id string for the vcpu */
+	snprintf(vcpu->stats_id, sizeof(vcpu->stats_id), "kvm-%d/vcpu-%d",
+		 task_pid_nr(current), id);
 }
 
 static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
@@ -3807,10 +3811,6 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	if (r)
 		goto unlock_vcpu_destroy;
 
-	/* Fill the stats id string for the vcpu */
-	snprintf(vcpu->stats_id, sizeof(vcpu->stats_id), "kvm-%d/vcpu-%d",
-		 task_pid_nr(current), id);
-
 	/* Now it's all set up, let userspace reach it */
 	kvm_get_kvm(kvm);
 	r = create_vcpu_fd(vcpu);
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
