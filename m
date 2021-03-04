Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB23C433E6
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6EC5464ED4
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EC5464ED4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 182DC4B4DC;
	Thu,  4 Mar 2021 06:55:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UsFnbUzBUiK0; Thu,  4 Mar 2021 06:55:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B82E4B615;
	Thu,  4 Mar 2021 06:55:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A46DE4B2EC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oe3+fEkSqPOW for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 06:55:19 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9EB234B4C8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:19 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id h21so9878717wrc.19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Mar 2021 03:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=K4cZRZezA7JguyGx2ZTlnQ6V/e664IrdL1fpgE6aIpA=;
 b=t8BzH4or3ynjmcVoZZ+Y5BRYlQOFPipFgSZoV/wzzuGY5GG1tbDnAE8V55P/pmKX1H
 HBGQoey9XrlqepxpCJFXlJ7x8WFz9biqN0NvxURurau3OflbJFZ8vi3Z2l2bkgoCt1RQ
 y+I+sPnMlek1oBSo6soLufTSfa8cD8mi5NR8w6pLAQnl5CI+Btz3K4C/hbOKH/RZoDru
 B7TVvPpcA2cDkARRBNsu4ki/szjlHmR5B1he5KFJ7ZIKF06o/HFFnPEcotU6SwIhkhiG
 Oy3Bt88lftAzekvbpUTvkP0U9B8MKMRVTpPcal/ZpLtUpwQ7vJ5gbfGu+LKYtWI1NZGL
 OAaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=K4cZRZezA7JguyGx2ZTlnQ6V/e664IrdL1fpgE6aIpA=;
 b=W0LlyEbGnJ5eF6OVV+19S6ZZ+it5cbuSjTTowXEsNm2gLRJl2AOQDbzQVjCK3AIRMg
 dQppL0wnSQLDhWKB/HGinP7FLeEy7+5JOWG9RarWQwAx95BYnYxBoir5Sur2FD5V6QE+
 +tDBbsUSTxLQAlpLBv9ptvph3CEIj0zu8+Ssj5Viktearj3o1Gyp7ULYBJDztqzG1NHa
 uCUTqvw5doz1XvyjOeDK7RqnuTNWP3c6VKbyXUyUsSrPORC+DJxSVX/BVPh5wO5WcJJl
 PcxrzO5iGsyK27NICb7xqarNGd18HOaUIi5IpFTXrwcdwIPGcdcbpWi6z41zEkXk2iRJ
 UZ6w==
X-Gm-Message-State: AOAM533OfNZAlJgoP9PR6azRz3mNkz6q+DHLxhoEpE7RZjspD7E0DlJR
 a9VbFru6kOhDCXNr2NIc7jd85Nffhe9NbvBwdG/5gZJdZuRyNCM5rXzoFpySa71kkkMt3zdtULR
 1NoiJ00ADkZjuWEqhh7mUAsbhkP4wVMkFQUU90uQeqHaxKMXdMAlcIEumGhmq/NjXaf7/YQ==
X-Google-Smtp-Source: ABdhPJzKSNAzexYjrxi3AS3Cz8f4mW76NeZ9JQYqKiHdbJs2Khy8kDqbItIzfNDSBdv8l8fMVh6I2hcb+Es=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a5d:4fca:: with SMTP id
 h10mr3882875wrw.70.1614858918529; 
 Thu, 04 Mar 2021 03:55:18 -0800 (PST)
Date: Thu,  4 Mar 2021 11:54:46 +0000
In-Reply-To: <20210304115454.3597879-1-ascull@google.com>
Message-Id: <20210304115454.3597879-4-ascull@google.com>
Mime-Version: 1.0
References: <20210304115454.3597879-1-ascull@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 03/10] KVM: arm64: Unmap host task thread flags from hyp
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, Dave.Martin@arm.com
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

Hyp no longer needs access to the host task's thread flags so remove the
corresponding hyp mapping.

Signed-off-by: Andrew Scull <ascull@google.com>
Cc: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 --
 arch/arm64/kvm/fpsimd.c           | 11 +----------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f6a478d3a902..8a559fa2f237 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -26,7 +26,6 @@
 #include <asm/fpsimd.h>
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
-#include <asm/thread_info.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
 
@@ -307,7 +306,6 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch vcpu_debug_state;
 	struct kvm_guest_debug_arch external_debug_state;
 
-	struct thread_info *host_thread_info;	/* hyp VA */
 	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
 
 	struct {
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 0c5e79be34d5..3e5a02137643 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -27,22 +27,13 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
-	struct thread_info *ti = &current->thread_info;
 	struct user_fpsimd_state *fpsimd = &current->thread.uw.fpsimd_state;
 
-	/*
-	 * Make sure the host task thread flags and fpsimd state are
-	 * visible to hyp:
-	 */
-	ret = create_hyp_mappings(ti, ti + 1, PAGE_HYP);
-	if (ret)
-		goto error;
-
+	/* Make sure the host task fpsimd state is visible to hyp: */
 	ret = create_hyp_mappings(fpsimd, fpsimd + 1, PAGE_HYP);
 	if (ret)
 		goto error;
 
-	vcpu->arch.host_thread_info = kern_hyp_va(ti);
 	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
 error:
 	return ret;
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
