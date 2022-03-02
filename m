Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3732BC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 14:08:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C318749EEE;
	Wed,  2 Mar 2022 09:08:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qzg3tDEOnm+j; Wed,  2 Mar 2022 09:08:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CB7049EE7;
	Wed,  2 Mar 2022 09:08:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CED649B0C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 09:08:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RcS8GVrTL-eZ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 09:08:50 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52C8649E43
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 09:08:50 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id
 v67-20020a1cac46000000b00383e71bb26fso446257wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Mar 2022 06:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=gRdzjUKFCpuFZPsm9KFd7MbCyuJUNKRJi1HCnRctsnI=;
 b=bBhuDLfF3Fy5j0yM+Nt52Pqwz1QANqHLfDVW1j5XwFAV2/QtrO+qH0ZuTlmBrJ+jWs
 D3Zq73lOUSa/o02QHpCnBnCGNGo0REXtD8aInMWgtlzth2EWAZCn3ab0SvUE0iPsO3ey
 aduBOOq0agqpOgYWuCYKmRpg66VwMavhIu+f+deKupFIdldP64aLXyLaiHi+pas6UCg1
 mCETxmxR+/v7xWQSKU54vd+ywURSu4/a+Y3dBo1MQqIP/+3gx8Mp1T93jgpxANDSDYVj
 LkJuFGJh4rqH9ahtIG1WKdfgwghS6P/7UIdTjilSEOoerJUm/e3uphHAIN06quyF4TWt
 8ofA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=gRdzjUKFCpuFZPsm9KFd7MbCyuJUNKRJi1HCnRctsnI=;
 b=29+hjhsxsh558eKW5n0ITcoooKtuUcOB68kdWxX9bW4UegQzh47WqZFrqXG4/O5uR6
 FlMceeXZVruwtenSW2b4ySwMIOCLVX7eZPAOFXYU1zZ8i8OsV4RpjkY/td4JY44n+IZr
 SHd/RTHK3I+d0lUjkntDyJfiY0pq0YX2J28gEbBxs/adSj6PlvO1UA3FW9gdzj6bc5c6
 C12r8uwA6aMxPg0hO4YUhy7GUb8QZF30amlX4ROqqQTYHOjSmijm7a7c9MHY33NDR/e2
 ifz05pB9cDIjuimlcIYR79EJJ/JoL2Fn6ddDvvHC8fZimYYOWBIzdAewxgEN7VjcrvfP
 iNUw==
X-Gm-Message-State: AOAM533IA2iWuF7cxMtpPkxDhTiiGHQ5JWhO/b2cvAf/HEGQtSG8tXZN
 6iutC9zXDi7kCu8mWB2pSp9syGo+ghjQ+D7wHrI=
X-Google-Smtp-Source: ABdhPJzyiYNBOHbqdOVZBET/2I0nv8F5wQOX74+gM57vzAENtbjkBqPkJKoP8LQZ9yIgaOP5R4Z0MYccjEAv11o0v6M=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a05:600c:3c89:b0:37f:aacb:cac7 with
 SMTP id bg9-20020a05600c3c8900b0037faacbcac7mr294123wmb.1.1646230128931; Wed,
 02 Mar 2022 06:08:48 -0800 (PST)
Date: Wed,  2 Mar 2022 14:07:33 +0000
In-Reply-To: <20220302140734.1015958-1-sebastianene@google.com>
Message-Id: <20220302140734.1015958-2-sebastianene@google.com>
Mime-Version: 1.0
References: <20220302140734.1015958-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v7 1/3] aarch64: Populate the vCPU struct before
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
