Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF0F2C48BDF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F92961477
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F92961477
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A3F14A195;
	Tue, 15 Jun 2021 09:40:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 18SbuAZd9iUB; Tue, 15 Jun 2021 09:40:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DDBB4B0C7;
	Tue, 15 Jun 2021 09:40:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C4054B0DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CmsXgbiE6+Z6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 09:40:20 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB6D34B0E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:18 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 t131-20020a37aa890000b02903a9f6c1e8bfso25651294qke.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 06:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=f7gIb5rbS/9fOLN8dgvWOK7JCBV5aEZAvZ9qj7H9rQE=;
 b=mW9q4ubIKavGOU+Rb7aPnr1hD4mQbtR60amfOLStgdVAzy8G1ZXV0pospZ9jvjhE3P
 ZM6K+Bt7HDuOZq4dbeMHuTGhpfLrIquFHeLX1+dz/TU+bdQm5fUvjEaPt1q4ZpQ0n2eL
 dWZOG+Jo83M+JSERsHd0PSn8UEO8MSFAZMINv8BYrbe9F6IDK1pliRtNkeN4XCAXCrrh
 J18DD94cdm+kNJoqnij5o6QkeogOmDeAqtW8+QKXyf5qo+b30+jFj1fd7WLf8MwND+AI
 L/1YACkCPbMwSz1ymkC1PVqdN9igJDxPbMsBWgYlpiDbO9cG4KFN+wEw95VoReAmUmON
 AJSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=f7gIb5rbS/9fOLN8dgvWOK7JCBV5aEZAvZ9qj7H9rQE=;
 b=DeBBEGQ3sAsNYQI79Pgd7y82fmodVCKHYZK7DyZGLhXl7oa4CV9rLcLgLzczH6Hiay
 LgvViRmMsn8dVNNviJ3J03Rky6iiTLTRoQ+R8V+0c3UZOZIl8ZCaAHlV8m+4SIeL6D75
 W9rkiouOifiRyivr/T5PKccJeJejbzif9sKRNu/Rixo3xvHVdcBpC0MMoKk9omp+bA3c
 jUvZkHZJ30e0wE8o8WKUFm4PycX4WeRddWbR+GK683+qCHGZYLpLaEU05KGv4Su0Px+m
 ryX21KEml/3LJqO2H2n+mlKampM/FB7bH3KW/Pi1QsLF9gf+BIp1thxkb/ipi+ZQ0RwK
 Ajcg==
X-Gm-Message-State: AOAM533B68D+2U1y+ZsnqWt3n1FHwaKt+SBnyzd3Woa6ILe4xZVUxwKz
 ssirR9yIsjFlchX3i0tlWOYOHTY672Cj52OfLew4BtubLwEj8HoNObR8L816BKmqtDXMtHZkbyj
 I1hwHs+GWDDfqphzei4JdZsYClqziLD+SU+JqDtzSMPwvGAbH1wtXCMWmE3DU2o7l3e8=
X-Google-Smtp-Source: ABdhPJwS1qgOTRkDm9mapt/6C5Eyu8aYkJbw3LxewWQRvCB49rvrPnzdxGSqNfaJ1zDu9GfhaXZESn9zRQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:c88:: with SMTP id
 r8mr4489209qvr.58.1623764418202; Tue, 15 Jun 2021 06:40:18 -0700 (PDT)
Date: Tue, 15 Jun 2021 14:39:49 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-13-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 12/13] KVM: arm64: Handle protected guests at 32 bits
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Protected KVM does not support protected AArch32 guests. However,
it is possible for the guest to force run AArch32, potentially
causing problems. Add an extra check so that if the hypervisor
catches the guest doing that, it can prevent the guest from
running again by resetting vcpu->arch.target and returning
ARM_EXCEPTION_IL.

Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
AArch32 systems")

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index d9f087ed6e02..672801f79579 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -447,6 +447,26 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			write_sysreg_el2(read_sysreg_el2(SYS_ELR) - 4, SYS_ELR);
 	}
 
+	/*
+	 * Protected VMs are not allowed to run in AArch32. The check below is
+	 * based on the one in kvm_arch_vcpu_ioctl_run().
+	 * The ARMv8 architecture doesn't give the hypervisor a mechanism to
+	 * prevent a guest from dropping to AArch32 EL0 if implemented by the
+	 * CPU. If the hypervisor spots a guest in such a state ensure it is
+	 * handled, and don't trust the host to spot or fix it.
+	 */
+	if (unlikely(is_nvhe_hyp_code() &&
+		     kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&
+		     vcpu_mode_is_32bit(vcpu))) {
+		/*
+		 * As we have caught the guest red-handed, decide that it isn't
+		 * fit for purpose anymore by making the vcpu invalid.
+		 */
+		vcpu->arch.target = -1;
+		*exit_code = ARM_EXCEPTION_IL;
+		goto exit;
+	}
+
 	/*
 	 * We're using the raw exception code in order to only process
 	 * the trap if no SError is pending. We will come back to the
-- 
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
