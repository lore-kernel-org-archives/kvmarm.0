Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0AAFC4332F
	for <kvmarm@archiver.kernel.org>; Sun, 13 Mar 2022 16:20:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FB4549E3A;
	Sun, 13 Mar 2022 12:20:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1S0ozZ7Lu6An; Sun, 13 Mar 2022 12:20:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3043940C02;
	Sun, 13 Mar 2022 12:20:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A58C040BC2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2022 12:20:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RBfJ2zpJjEMk for <kvmarm@lists.cs.columbia.edu>;
 Sun, 13 Mar 2022 12:20:51 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78AA04086C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2022 12:20:51 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 o21-20020a05600c511500b003818c4b98b5so4620831wms.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2022 09:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=SeD4Qzgh/sHfvC8bjBiziK/e63h3+qRRDuOCSxAtRyU=;
 b=PnyhGUpo0WrgazIr8uDW4N3gs0xJHwKFIZiYrlq9Hc3T9feIf7NQrM/a9nuc+gKFw8
 vGUCw9bNsPCrfwJ2Y/+raF+mJG09gugnXcsuaQhyZXTCFkafMYfayL3qAzE+mOHgwyHj
 xc8PaChyGJw/RcwtolTaPvj4B4zCSr6RMKJQk/h2Rde/lHmlqa4RwaqYhn5j58orluzG
 KKPnHCQ9fIUiePG7+gOM7IwXZ7/BrHygGdtC0fFabVvdWO+hlRRhFeuSgwF2aMzxtJqs
 TgSOG14klT1oE8Q4NDLZUK/j4qEsOkWS8BzKBJzMoL1b0jEhOoB/uLqCP7LrKk+K3pzK
 dyJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=SeD4Qzgh/sHfvC8bjBiziK/e63h3+qRRDuOCSxAtRyU=;
 b=BLNqvcGbefPYOyzDgQzHWYcBUGVwGGBHHeXZX6YzPhXB61rQx7+IAjrhDlvEOf5Y7w
 UKYPrhi9ug5RLJVojq7arg4ckfwbQgqlyfXuOXkAWRmcWKlstaLbcvhUv3jB3Iuuy/z6
 iO6OwVtPhNEglvqLg/SitRYKtRk9qVMaTMGb3R4v66vYfZCyI32MGSSmElVYjt6NcBEn
 o6qCeowdtwJmeVqmOdNMx/QAFuvH+3qV+CHP8CM4w+YiLjfVUhJEp5+aND2BMRR7Hfnp
 NXb1N6Lw7kJzNGPdvOteOcYpMOb7PxAwu6C6bS3/1Pyft5kAcs2rUwrT8/wouLHg4YlR
 SAzg==
X-Gm-Message-State: AOAM533086IclJguvZQbJ30UxiJODtZ2NlFF1YlR1r68Bcksk0337XRE
 t3OoCL7HkcGaAaeXnA5TFVtGot7S1N0u3UuxZVs=
X-Google-Smtp-Source: ABdhPJzqcbVtACj62ep3LZlqhTo9GesJQnwZ8D/9dKWe+MvvBQWPqLqZQ6BD33SYazsTGRfTx+fE62r7Mddnm08si14=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a05:600c:ac5:b0:389:a170:c34 with
 SMTP id c5-20020a05600c0ac500b00389a1700c34mr22917340wmr.100.1647188450683;
 Sun, 13 Mar 2022 09:20:50 -0700 (PDT)
Date: Sun, 13 Mar 2022 16:19:48 +0000
In-Reply-To: <20220313161949.3565171-1-sebastianene@google.com>
Message-Id: <20220313161949.3565171-2-sebastianene@google.com>
Mime-Version: 1.0
References: <20220313161949.3565171-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH kvmtool v11 1/3] aarch64: Populate the vCPU struct before
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
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
