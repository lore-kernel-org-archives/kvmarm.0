Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 675F1C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  9 Mar 2022 13:35:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1908B49E1A;
	Wed,  9 Mar 2022 08:35:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NjbZ8pC9+eW0; Wed,  9 Mar 2022 08:34:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 245A449EFD;
	Wed,  9 Mar 2022 08:34:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3114449E48
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 08:34:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dxveFTD2H2x2 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2022 08:34:56 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EDB449E22
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 08:34:56 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 x5-20020a1c7c05000000b00389bcc8df46so995875wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Mar 2022 05:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=oKAagiS3UYpwunP7Sy4zMqHeUF02cL/iWA5aLyx3lIw=;
 b=MXdznXMrTKgJapa66ALe2iN+O4g+c09cCPDfsR3Hsd8bZFctAWDhWUAbOU6v66A39H
 9EGViijeHT+7U9/QUwWjXo7Oi5nPBaspi8F+nn1OVmTsZlUy/oakFJaXUNvDuHLeyHMY
 /lZ/U3d5qm6ycg4aVZDKpHK3vO7eH53CKtA9W2dur7JlYERL+eY2KuxcHlFbHDOYV/8u
 xK9eqgr+J505+NGiMqrErDXFWI0PL25qr/q86m4nT+WVHzL/LQDZhjcVFkFg1EABa5rM
 Fe/tL2uViXOLpQxDM5XgoZJTKM7tcF8LHj+aFapV7GNduttrAxZCDnd5vrus+eybqWvJ
 KorA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=oKAagiS3UYpwunP7Sy4zMqHeUF02cL/iWA5aLyx3lIw=;
 b=ki87CbLObourAyRtnxtsknBft6cnmJ0rQQCozljedGhjbAyTur5vWnrd3qly5iiLk2
 YefUOw9FDT4LfG6UCTs7zQhUR4MaMpdqRE0AyMemDDoznrBRPUBzGApX5ymKb1UKjxrx
 gucZClw6RRvA8MjZYJyxp5an9CGI6JEpPmWX8nWc+BDXBeXWLLV4pAbvMgj30Ho5hOr7
 LoR1BLhpBC7E5qk9WegISnDjtdnDNVHpceNsVxBjis+fRoyLDwYW89fBZy0v6smz47VX
 15xlZrRccBsQ3e76dQCX35UdeIrHjMgqRlSoULD9agHAis8vAF/Wjw4gWjw1g9KL287q
 Wtyw==
X-Gm-Message-State: AOAM533vJJ6P9nzAmfppCbkxzZXQieyh3xxbnTQ5EMR0H7hrT6hZI4X+
 QlX/bvQ5JkAj3zGsBRFXGbDEpn/guqwfFQNRYsk=
X-Google-Smtp-Source: ABdhPJxsh5zoNB+VgfKe4CI6uoxwNzwsaENxHsbYTeb6/niL81/XMRFtTFhMIaYaQiyHPw6vaLPz1xHSTbLmhYbpmsg=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a05:600c:a06:b0:37b:fdd8:4f8 with
 SMTP id z6-20020a05600c0a0600b0037bfdd804f8mr7715217wmp.41.1646832895295;
 Wed, 09 Mar 2022 05:34:55 -0800 (PST)
Date: Wed,  9 Mar 2022 13:34:22 +0000
In-Reply-To: <20220309133422.2432649-1-sebastianene@google.com>
Message-Id: <20220309133422.2432649-2-sebastianene@google.com>
Mime-Version: 1.0
References: <20220309133422.2432649-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v10 1/3] aarch64: Populate the vCPU struct before
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

Reviewed-by: Marc Zyngier <maz@kernel.org>
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
2.35.1.616.g0bdcbb4464-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
