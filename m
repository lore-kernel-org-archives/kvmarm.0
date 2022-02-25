Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424BFC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 13:38:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8AB84086D;
	Fri, 25 Feb 2022 08:38:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jgx1i4dUdoKR; Fri, 25 Feb 2022 08:38:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37DB949E48;
	Fri, 25 Feb 2022 08:38:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E5194B9EB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 08:38:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rx5JDplrxsxG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 08:38:09 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F82849E48
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 08:38:09 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id
 f14-20020adfc98e000000b001e8593b40b0so900341wrh.14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 05:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=gRdzjUKFCpuFZPsm9KFd7MbCyuJUNKRJi1HCnRctsnI=;
 b=RuDcsnt0uDnCOh8so476d0bhJurV/3dHZ5KFaJ1hIMbrrIATRHzrzKZxeVHSbTv/vq
 t+agQU3Mli8ws6rwqEQ96jpewsAYn2uUwyv22c+lxe8k0+3Mu/xzTn8T4l/f5/d7iqPo
 EbdBUI0q3xtxYQ//nRYgONAmsL8l19EhIif/cnK/fPwVnpm9G538XZFalCf1MlkVOt3m
 x+ruq27O45lfgu0sPDZf1OeehkhK7OpY+/BeYRPu7Ln8xqdJtds/S/+zu3SUfwRqhzdV
 yH/WCE2Qn/PYF0ukj/pmuL3oB1adE6Y3+auPbgwanJ5WtGRV8wUpv/s2Zsz0SbgfOabb
 HcPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=gRdzjUKFCpuFZPsm9KFd7MbCyuJUNKRJi1HCnRctsnI=;
 b=QKU3QeqWkXchRqXbaGI8+ooot0gmwczTZA09gIjN0P+fBZf3Qo4YbQ5aKMPbhLGxed
 F4H6UgrIzeAzuRIyDYxfMd/lb1rx5EAqhDv7GXBSkQkVlg24uQeyXtEqxOVPxfQVgAYg
 Hxp9ihGM0QdTscNpWQscbj3Ud8Ykdf701s1/SgCigG1WGD9cC2GUfUIiDQMkkdvqobpq
 yeidN0oOfrkP4kJdMUtH0+C8JJJkiQtbk36QYoLnNnzFhCmJ988lPY96Mw+DVppMi1OV
 b3a3WC+Qjc98/jYE/Hd5AtfGnRlXNpU/i1l7oxRCbWREXQhrXkFoeAFprrQjqPS4d/o3
 tjJQ==
X-Gm-Message-State: AOAM531ivcSa4jJjwkAbgcUzL6vkUKnbYbfucPUngKWTXP9A2xRZezop
 CexwUoLNmR0n1fXjITnoutSsqGnQ8IzVYlA2Nvw=
X-Google-Smtp-Source: ABdhPJw/i+j9Y9lT4oP3rSx/EBeqAbXyVKnNIqSLOXDR7vSaDHI/+31HbErczIS6hHQ79O9YPY4Ur0JqAAxCdDnZCVg=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a05:600c:3c98:b0:37f:2f14:7be7 with
 SMTP id bg24-20020a05600c3c9800b0037f2f147be7mr2834952wmb.180.1645796288177;
 Fri, 25 Feb 2022 05:38:08 -0800 (PST)
Date: Fri, 25 Feb 2022 13:37:43 +0000
In-Reply-To: <20220225133743.41207-1-sebastianene@google.com>
Message-Id: <20220225133743.41207-2-sebastianene@google.com>
Mime-Version: 1.0
References: <20220225133743.41207-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v5 1/3] aarch64: Populate the vCPU struct before
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
2.35.1.574.g5d30c73bfb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
