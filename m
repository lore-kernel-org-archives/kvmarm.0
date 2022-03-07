Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D85E3C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  7 Mar 2022 14:43:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EA374B288;
	Mon,  7 Mar 2022 09:43:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D5sr0w5b33G0; Mon,  7 Mar 2022 09:43:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CB194B1B6;
	Mon,  7 Mar 2022 09:43:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E0A449B08
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 09:43:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z2e8UZeCRS6J for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Mar 2022 09:43:20 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A92D540D0B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 09:43:20 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 d8-20020a05600c34c800b0037e3cd6225eso5307504wmq.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Mar 2022 06:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=AEhqnN4KTy6FPofpGdBFugJSZ01sGgYi75EWboeVOHI=;
 b=IMVmV+H3PofMHB9PeFURsxfc4TH7mzyYcd98ZUSMfuYOiYSjRH4meT+9velODpceJD
 S0jUQmw+3bT8vH38ey/2yBwYe/n1+GOlvQs36/wi8WTOis0loDS63VxQOqf32hui/Eh7
 q+Qf3sbJ07M6VUBg89BwnzCFOCCJlGLdqsDc6Yu7id4LxsPgRTZ/Az6zRV0eEXz+Pb7O
 V9Hkg2IqDG0hYOMAgpmJEmhhpQgDfo6PByKbISRMC39d51e1sfYJUBL7ykbniNrjhlHQ
 gd0w7DYO/rZx1uF9BgiWDBfqosfLW9pbZk9FshKi5jLTBgWdHKsQpu/qhTlsz9Oy3/SL
 uJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=AEhqnN4KTy6FPofpGdBFugJSZ01sGgYi75EWboeVOHI=;
 b=QJS8Dtzxc83R9iluayXQu+pdF68E6MMMifbJl8a6Ju0pGUcRehwXsr6y1zKBxHXCv8
 j6zxn7xbEP+QPwLecJ5nkgZA4SSvD7ikh9tBPiUEXoM8w/mJ8LkZpI7pf/5Y5KOOOyd1
 cyITclyLInx1z75EVOrKLtCBwvvzCgaCkUlYGljKbCVPMWUYWPMvx/E15fuK8ol4WWrk
 xKBKmFPdjHVnD1RokVTnFnWVsKyB0YATlr0ST9oK23rKE8POn7slEaZXEi3dc06m3FxU
 Y/PlMvK8eCboPeZ5Fzsc7tixcN9qWXurMCaEugcTc5N1Sa/iLPCUTtmXkSvoqGYZ1auy
 1r5Q==
X-Gm-Message-State: AOAM5312mYEIfSPEQQUKXQ5JpwJ+vdnOQ27Ik+JB6uJQ2qlTGQyDQyJH
 aXCoB3Rte9kUbjoCg3RIYQ5UUT3JsBcPgxTPrfI=
X-Google-Smtp-Source: ABdhPJziMiHw6LmCbzxXV7rrB75EYFeYsMaeJXlW9zCnK7xxglGhARbFJvFR7paXFSKWoYnDg8dRy/b745R2JaCg8wg=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a7b:c759:0:b0:389:82c6:ac44 with SMTP
 id w25-20020a7bc759000000b0038982c6ac44mr12407217wmk.168.1646664199739; Mon,
 07 Mar 2022 06:43:19 -0800 (PST)
Date: Mon,  7 Mar 2022 14:42:42 +0000
In-Reply-To: <20220307144243.2039409-1-sebastianene@google.com>
Message-Id: <20220307144243.2039409-2-sebastianene@google.com>
Mime-Version: 1.0
References: <20220307144243.2039409-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v8 1/3] aarch64: Populate the vCPU struct before
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
2.35.1.616.g0bdcbb4464-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
