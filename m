Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA6EC433E0
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E0E7864F37
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0E7864F37
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 928824B663;
	Tue,  2 Mar 2021 10:00:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eZC4FiBCdZty; Tue,  2 Mar 2021 10:00:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A204E4B65B;
	Tue,  2 Mar 2021 10:00:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C2624B645
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B65I+x0oTkPZ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 10:00:25 -0500 (EST)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 10FFB4B658
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:25 -0500 (EST)
Received: by mail-qk1-f201.google.com with SMTP id i188so27540qkd.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Mar 2021 07:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=FQ7gk+4i0GZUVGgKW9zQ6uuaT/h986N5brkzpgihVQ4=;
 b=X/OUs9SG1r0jdb49+8nVXln6PO8Zu5SI0ZdYl8tCmxLjvl2MV2hgALRZh3zow++nD5
 LfYOTe7jubKzAq/fe+4mCbvp1kF7X4I3lzigk2zpB6/taDq/VfhukisnZJlcHe6Cw4or
 Z2DAVqnLaMStLxV/sg78xIsCcf06CcFYlUZgrbGmAtabdpSBs7a/fthy26V76rPX+XbO
 vfOPmxuoz0iynn8DGaZuNQ8aFdVjHcjEpkeI56RfdvgEMwpiAyJrKCIXlq6vGBTzLF1f
 QEby0P939iHyfOgGvqBORuYNyZn81dn4C75IXu/p+aWEWyofsIx6RlVZOzkWwW6/g//M
 vpSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=FQ7gk+4i0GZUVGgKW9zQ6uuaT/h986N5brkzpgihVQ4=;
 b=qSKdoeEaeZXtycoY82bqnvXvJrkKUSkSj6LYmrdmm4Gg4ENNl6ToIAxD01ze9IMrmF
 FeE9pZVr6EuXTgK+Ap7s5pJUJN9zl6sKq9ytWPPW+99JBbGQLMgp9C4E/wXA80YSuVgR
 S5abzopsTwYzTDO/V2WPf1jPZQPgUlu94g/zoH6On2JV7Q2f7Yjhlvm4OkbEyEdtie2w
 lecPRyFjn9G+PdaWnsFi567CCjfvOBkQuVGCkEST4F3i3A+kOja+XC9zDBBkNtOR3BNs
 4Bv0eNAfpZtpH/g0FvsScKufRyNBljB4tZEZZr9FjOgjvSAHA4EclZV98YAyMPEKJw0v
 eoOA==
X-Gm-Message-State: AOAM532fMSrMSgioA+LjIsUYfmlgt1QRsBwigYUI2Y8qNfNJiAuJrEci
 jvs3TlT9+6aIOFRcwgsTgIP3MizSKpl0
X-Google-Smtp-Source: ABdhPJzhqT1MCWJ5omfxYXzYFsXFvD1UddN55tmUgOSTPj1CkCQRYxZaBVCibdke5an4rJD9Wh3ODO7o5zyX
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:6214:76f:: with SMTP id
 f15mr3892367qvz.56.1614697224470; Tue, 02 Mar 2021 07:00:24 -0800 (PST)
Date: Tue,  2 Mar 2021 14:59:38 +0000
In-Reply-To: <20210302150002.3685113-1-qperret@google.com>
Message-Id: <20210302150002.3685113-9-qperret@google.com>
Mime-Version: 1.0
References: <20210302150002.3685113-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v3 08/32] KVM: arm64: Make kvm_call_hyp() a function call at
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
