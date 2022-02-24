Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C262C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 17:26:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 361BB4BE39;
	Thu, 24 Feb 2022 12:26:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qr+N6EfINmcA; Thu, 24 Feb 2022 12:26:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1728A4BD8D;
	Thu, 24 Feb 2022 12:26:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAD904BD9B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:26:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FbCJm+Da2rtR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 12:26:16 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 453754BE45
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 12:26:16 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 f33-20020a17090a702400b001bc822ccbacso3956499pjk.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 09:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=OsZB1WQ6lcTDQc8TII8Z2w2H891AEk6o7uXrnU60Sz4=;
 b=n/F4ja1wwLJBW/ijXvomC0vFaa1Gbh0XTIQ72X/rtTtlaWrnWJVjVDVQnw0Chugj0j
 s8eGLxLruJTXlJ3udhRPkErT9dlaCCvq+4Pc/4AyP6fslw5wApjjMzXxR5JolWEo3Uhn
 /xF8xB+oMyZoF8zM+m9Y3UAvlg9Q5fezULZ3Z37nGxzJzBcGlg2zHbru5rcSqCNNtg96
 iSGxIhYOowJ4KOjg8isnidQLFfTqDemO76gaoctt3D7t2fR4oP7+MifAHi8KKPk6R9uU
 ke+J+3OxaxPspS1mFy6prNU6GZzF3ophbL5sU3A7T9zPgk19vFCo7IozP+KWOWWnuJ5v
 YFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=OsZB1WQ6lcTDQc8TII8Z2w2H891AEk6o7uXrnU60Sz4=;
 b=Dbct0Mb0ONFPZAtmOGVxFFvxWb33ENQNxgalqnSp5+03rBYb0oPP1pSTH7iE+4WA0K
 k9MJoKyLBxyZFY15hblCOBmSEb+RtJpp1KGsd4k7HXq7rwgIosx94r3nayxw9GWBx1N7
 dqog3iMnQhrME61HMnb7KkRdTGkVVIGW+qnpJmNT8xXE83fv42VumNxZ+84PJaLNOQzR
 Bw98O1bRf+QRD4Z/uZ25sqQehQWXnuG7gkLIwEvmciJZxIqoO58hpnSuzVDNDi6Cx0I2
 AY5A7OrvKEhgy1yL3gmCAjbs/HKGnmQmZtQ0WVAjKFsprmYVMcB56UBAJ3AqAKk0qoPV
 cOoA==
X-Gm-Message-State: AOAM532WiFo6vh/hosDxLgNUHf4AcU8Aql7lRZaTS3ujDdlJ6HOAOnnl
 nu0qvRt/x5VB8f4Y+2RPxMzqfweTydUT
X-Google-Smtp-Source: ABdhPJwNVZA2Yo1/QQAgM2dA9o//8LsSbVv/DS6uJksGu0XtYEWfniXtgFLtkwUsjMzINEE1xgsyTvGjlEWP
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:2c0c:b0:1b9:fa47:1caf with SMTP id
 m12-20020a17090a2c0c00b001b9fa471cafmr3880202pjd.34.1645723575490; Thu, 24
 Feb 2022 09:26:15 -0800 (PST)
Date: Thu, 24 Feb 2022 17:25:50 +0000
In-Reply-To: <20220224172559.4170192-1-rananta@google.com>
Message-Id: <20220224172559.4170192-5-rananta@google.com>
Mime-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 04/13] KVM: arm64: Capture VM's first run
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Capture the first run of the KVM VM, which is basically the
first KVM_RUN issued for any vCPU. This state of the VM is
helpful in the upcoming patches to prevent user-space from
configuring certain VM features, such as the feature bitmap
exposed by the psuedo-firmware registers, after the VM has
started running.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 9 +++++++++
 arch/arm64/kvm/arm.c              | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 657733554d98..e823571e50cc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -139,6 +139,9 @@ struct kvm_arch {
 
 	/* Register scoping enabled for KVM registers */
 	bool reg_scope_enabled;
+
+	/* Capture first run of the VM */
+	bool has_run_once;
 };
 
 struct kvm_vcpu_fault_info {
@@ -796,6 +799,12 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 int kvm_trng_call(struct kvm_vcpu *vcpu);
 int kvm_arm_reg_id_encode_scope(struct kvm_vcpu *vcpu, u64 *reg_id);
 void kvm_arm_reg_id_clear_scope(struct kvm_vcpu *vcpu, u64 *reg_id);
+
+static inline bool kvm_arm_vm_has_run_once(struct kvm_arch *kvm_arch)
+{
+	return kvm_arch->has_run_once;
+}
+
 #ifdef CONFIG_KVM
 extern phys_addr_t hyp_mem_base;
 extern phys_addr_t hyp_mem_size;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 107977c82c6c..f61cd8d57eae 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -635,6 +635,8 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (kvm_vm_is_protected(kvm))
 		kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
 
+	kvm->arch.has_run_once = true;
+
 	return ret;
 }
 
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
