Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67366C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 14:04:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18B9849E43;
	Wed,  2 Mar 2022 09:04:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AzT70D9cJGth; Wed,  2 Mar 2022 09:04:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1F9649EEE;
	Wed,  2 Mar 2022 09:04:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF212408F4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 09:04:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5QbAjlJ30dOK for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 09:04:08 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6520B49B07
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 09:04:08 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id
 z16-20020adff1d0000000b001ef7dc78b23so672231wro.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Mar 2022 06:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=gRdzjUKFCpuFZPsm9KFd7MbCyuJUNKRJi1HCnRctsnI=;
 b=WTotb9A2RoMjWhLf8XQUpZG4gHzu04COfESZrJ2a44gmpP1C7bzxTp4V+wYsbobq2d
 oM4XNvAcO59R2iaj1uUVp0BVW8AxY6KH02LsRB4vsmF+VnsbQxkgcJVPJ1payyezIsss
 uOmdEBuw5N5IyvOXXVCgTT7HgOqRTSg4LvlbSkAFSs8cd3Oln1vDLjugTlHQV0aaXazM
 RHUTKMJw2+zYZbjOhaHXkG975ZYbcCOMl2wDx0lJ0pg2fRITICknNVE1b6HD9QGD2hEl
 24U303CG2KsvtiJDhBJFsX89sSIcN+VP/SFH8x8O9pTa20fjnmas3MRKb8lHM0RVFoGO
 8PCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=gRdzjUKFCpuFZPsm9KFd7MbCyuJUNKRJi1HCnRctsnI=;
 b=JXDQyXuf3ZQcOxMTgu3l04KfvRPoVm0LQapADsy6WXtNAEiFucMdNGNrTAmm76isgk
 ncQJ1hhihPg6KWphOyiiYXAKY5mScEd5/yNGAhBVVDjNKwrF3Gxfrg0nAz+hQvlwpNid
 iXToCeMrfGhK6GV7fywcS4rbInJ+RQMIxBebhIG1BRBvRJVSmXIzjQ8AqL2B5TCgpI4Y
 fxAsBN5FaIiKI95O1d5/vhXuHTYB4Z8grnOks9d6tcILFIAX38goyNdMYCdulw488Uxm
 Qb472NRmF8qN0y3pn3YpbXnWXi5JXY0pm1Dn9Ab+azCob3Ozj3sR0holSFoh6eFNV6PM
 0kdA==
X-Gm-Message-State: AOAM532+2Nluw1fNIKPvqKTca6BxSYXbOiySd8LEFd9ZJBu2OMeO5Tbi
 FZQWJ0Cjzt6mjTD4o6Yl8fpex4jscGNeTHtIMe0=
X-Google-Smtp-Source: ABdhPJwz6/e0yNgNPotGI5uubbcL5r6LQ9YMOmlDj1hWLk7K/P/c94xIA9Yx4p1Z7fucZntamCmKMkMSP/Kpu97RqA8=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a05:600c:3787:b0:386:aa15:7117 with
 SMTP id o7-20020a05600c378700b00386aa157117mr135669wmr.113.1646229847624;
 Wed, 02 Mar 2022 06:04:07 -0800 (PST)
Date: Wed,  2 Mar 2022 14:03:23 +0000
In-Reply-To: <20220302140324.1010891-1-sebastianene@google.com>
Message-Id: <20220302140324.1010891-2-sebastianene@google.com>
Mime-Version: 1.0
References: <20220302140324.1010891-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH kvmtool v6 1/3] aarch64: Populate the vCPU struct before
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
