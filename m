Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94D0C433E6
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 62B7364FC0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62B7364FC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 154CA4B4FD;
	Wed, 10 Mar 2021 12:58:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V6C+3AocjHlH; Wed, 10 Mar 2021 12:58:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CFFE4B620;
	Wed, 10 Mar 2021 12:58:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99E2C4B353
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lM7NyBO3fEHl for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:58:13 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 913404B389
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:12 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id g2so8315572wrx.20
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=FQ7gk+4i0GZUVGgKW9zQ6uuaT/h986N5brkzpgihVQ4=;
 b=l2/JAssrCgiSVNWvv4xKwvbtNAJ4uVkYJ8t6QBmtVRzgoG35risu7QZVUsv1ZVEVVc
 d0cu6c8ao+zRESzgSYR0tOiVun97ubBgTvNljNr07rf0ZaBhRxxm3aeL4YQF0lrAWMd3
 J6EHU6UjAWsuDfgdjF2Xy9kBIiLSqFoO/8/8jY1z0jZEnLVRSGHJdrgiLo4rMCXudmEy
 SmGdNMHEAxYX4BQ0m/Q8CpJ8tyO8EwGVTgfToo90g/wP1g66/b1nh7za3kbk5Dbi1OyZ
 cHdkyNd2U0aCwKGZLb5VJukCs5LMD1M2DzqKbuxUNl5vA15jwSiQVnBxV4noRW0uEN6X
 S3WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=FQ7gk+4i0GZUVGgKW9zQ6uuaT/h986N5brkzpgihVQ4=;
 b=qt3qnYTnkMzOaMgJjf5YZSNl12yYD5XCojbOY3UiZdybATg/ugt51m3uB3gxfx3McV
 I8ewB321ABzJHtXIHneplcT0GZR94KqX/5pIueO/7dRyewkdhaT2Tz7CECskfqcxku71
 GpQ/SWpI03qf5yhFeOVDmmKrPTV7cbu7mCAyxXxZxPo1zltapLo9Atm1BPEqKOmSvEmM
 xZehESZpVfL2yhZ2tmPy/tSUEIqEM7fhn4pSr2HzwFCxLzooiIbX46bisgChT7VZT0GD
 UwrLQDFjK9BbmaT4CViaJIo6SEnRTgZDVVgGqYAE9rO6BOjFAKu2Q7oBAeWm9RoTq4IJ
 b4xQ==
X-Gm-Message-State: AOAM533LiKkjq/mJAjGpGQ9+BLnlubhYiKZzqXXjGsgkhNy71sdWtb/G
 mkixjq7o5jfbk7K8vlIBqrDytvlb8537
X-Google-Smtp-Source: ABdhPJw1jFJ2uambxxtcgPuAbKpIituWx/uYJZ6wnBrvmsU1lXHbtQHSpkrolAxbBPbUyRL7xj955m5ZQfKl
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a7b:c18e:: with SMTP id
 y14mr1333539wmi.1.1615399091555; Wed, 10 Mar 2021 09:58:11 -0800 (PST)
Date: Wed, 10 Mar 2021 17:57:25 +0000
In-Reply-To: <20210310175751.3320106-1-qperret@google.com>
Message-Id: <20210310175751.3320106-9-qperret@google.com>
Mime-Version: 1.0
References: <20210310175751.3320106-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 08/34] KVM: arm64: Make kvm_call_hyp() a function call at
 Hyp
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

kvm_call_hyp() has some logic to issue a function call or a hypercall
depending on the EL at which the kernel is running. However, all the
code compiled under __KVM_NVHE_HYPERVISOR__ is guaranteed to only run
at EL2 which allows us to simplify.

Add ifdefery to kvm_host.h to simplify kvm_call_hyp() in .hyp.text.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3d10e6527f7d..06ca4828005f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -591,6 +591,7 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
+#ifndef __KVM_NVHE_HYPERVISOR__
 #define kvm_call_hyp_nvhe(f, ...)						\
 	({								\
 		struct arm_smccc_res res;				\
@@ -630,6 +631,11 @@ void kvm_arm_resume_guest(struct kvm *kvm);
 									\
 		ret;							\
 	})
+#else /* __KVM_NVHE_HYPERVISOR__ */
+#define kvm_call_hyp(f, ...) f(__VA_ARGS__)
+#define kvm_call_hyp_ret(f, ...) f(__VA_ARGS__)
+#define kvm_call_hyp_nvhe(f, ...) f(__VA_ARGS__)
+#endif /* __KVM_NVHE_HYPERVISOR__ */
 
 void force_vm_exit(const cpumask_t *mask);
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
