Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EB0C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 16:55:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CF434BAA0;
	Thu, 24 Feb 2022 11:55:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9aQtkfv4U9wE; Thu, 24 Feb 2022 11:55:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B6FB74BA36;
	Thu, 24 Feb 2022 11:55:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E0884B995
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 11:55:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VvAA12FcZo+4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 11:55:42 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3AB304BA36
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 11:55:42 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id
 i131-20020a1c3b89000000b0037bb9f6feeeso108007wma.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 08:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=jRWeKy2DF55SrlhxS1tpavQsfSfBDLtoM+yorrperzg=;
 b=eepCKKpstRrUT4TBeh0EwpjpdU4YhLWO4IRwZnr7/fOmHogjdbclficzyLr6hJNQN1
 eFqBdJCnfOaqmK02W1/Ih60n+RDQvvZpLPM61MkpuwJFvkryVlYe39JN9lDjoCDb+QkY
 tc0Ex4WSb4XBXO2nUN2nislHw0Lb3NsdqnI3ZOv0uKXf6RAhLD+zxV4Spi798xi2jsTE
 bNNibvS/X/0vslpeHVWIg5GPKuYUw/yGfePWEm9paBVo5JjI2jU3mbBesmcejE91HG15
 2P/lvS82SHwhUV4/fV+T6WDWDSnru2Oj3ZrOVjH6ZV2RugWsvFwmAkrwoa2IGkYl2EO+
 G+KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=jRWeKy2DF55SrlhxS1tpavQsfSfBDLtoM+yorrperzg=;
 b=Rj4Oh2GTMiRhKyNqX/HFweZdWv85MREbxpQ/upurIm+lGgFMYvL56vLp63Udimlu5w
 ADtnL6dxaCAp8aUkKFQ+R7jJDTflYD0XFUf4S4xbnAn2+w7RzGwibucWAfGfOQi8Z8vA
 PA36A3wbSQSmLuwAj4S/H72f981l3xEn0FZ+i2CQ7mUv58d4UFJwA9654fSopCMY7j20
 COiIgAez7V6qHC9kMrmq6LN+POJvBN0WHBJX11XNghEE2NeKJcmRMLqre9rzO4MOlCva
 7quClXCXT1inWWVANl6UWf6f4sBBlJu+BMm2UcPU//8uENzNsagF+gRsa96tveGEd+oF
 JcwA==
X-Gm-Message-State: AOAM532S7xkUx31+BubqKCLsaECQ6GsOHFxF5uGB6uNa+roKHcBVRcxD
 iXcQG5h/rsDs62AfEKsP6gywFpfLhENeGJx7Ob4=
X-Google-Smtp-Source: ABdhPJy8VNK2No603tfy4Digp9AM+zjrddzxLevnc+p8D96pwuTl1GNWQqjDY04BtWPC3KSa4IAfV25Wtc9kaTnZfrI=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a5d:560b:0:b0:1ed:af2b:d41e with SMTP
 id l11-20020a5d560b000000b001edaf2bd41emr2873710wrv.499.1645721741480; Thu,
 24 Feb 2022 08:55:41 -0800 (PST)
Date: Thu, 24 Feb 2022 16:51:04 +0000
In-Reply-To: <20220224165103.1157358-1-sebastianene@google.com>
Message-Id: <20220224165103.1157358-3-sebastianene@google.com>
Mime-Version: 1.0
References: <20220224165103.1157358-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH kvmtool v4 2/3] aarch64: Populate the vCPU struct before
 target->init()
From: Sebastian Ene <sebastianene@google.com>
To: kvm@vger.kernel.org
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Move the vCPU structure initialisation before the target->init() call to
 keep a reference to the kvm structure during init().
This is required by the pvtime peripheral to reserve a memory region
while the vCPU is beeing initialised.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arm/kvm-cpu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 6a2408c..84ac1e9 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -116,6 +116,13 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 			die("Unable to find matching target");
 	}
 
+	/* Populate the vcpu structure. */
+	vcpu->kvm		= kvm;
+	vcpu->cpu_id		= cpu_id;
+	vcpu->cpu_type		= vcpu_init.target;
+	vcpu->cpu_compatible	= target->compatible;
+	vcpu->is_running	= true;
+
 	if (err || target->init(vcpu))
 		die("Unable to initialise vcpu");
 
@@ -125,13 +132,6 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 		vcpu->ring = (void *)vcpu->kvm_run +
 			     (coalesced_offset * PAGE_SIZE);
 
-	/* Populate the vcpu structure. */
-	vcpu->kvm		= kvm;
-	vcpu->cpu_id		= cpu_id;
-	vcpu->cpu_type		= vcpu_init.target;
-	vcpu->cpu_compatible	= target->compatible;
-	vcpu->is_running	= true;
-
 	if (kvm_cpu__configure_features(vcpu))
 		die("Unable to configure requested vcpu features");
 
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
