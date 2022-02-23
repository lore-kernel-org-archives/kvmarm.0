Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB7BC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 04:20:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 738B24C3DB;
	Tue, 22 Feb 2022 23:20:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XsB+CqThgODl; Tue, 22 Feb 2022 23:19:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E5A24C3F0;
	Tue, 22 Feb 2022 23:19:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2F294C3EE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kudgseE9wvVn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 23:19:54 -0500 (EST)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 457C24C3E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:53 -0500 (EST)
Received: by mail-il1-f202.google.com with SMTP id
 r16-20020a92ac10000000b002c1ec9fa8edso7303053ilh.23
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 20:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ru51C74AZClZTzPkMtbBN26J3qvHNHAk8kt/SSSWmMQ=;
 b=OS4XgJOpwQ05rzV5Y5XKlGE2N+cY/5pMwS7SY66NR3hjMy7v66RbANk33sAOYp3tiS
 uCs9VBj0u8cL8xzE6/np9O45YnWpkoBtIuvo9DPB8lV4+sUVXugYFhMxiHheAWKyavY+
 LQe2HXwYwDxYT/sfaw+Iv85yF/mrky88GSev4VX3cSbyUbJ2+A209oMf6eHR7Kt+Reh4
 tYDZXGRHMlIWMUia4ZMzVO1+e+mB5rhGTNW0tAWNydhRLHuYA8+ZvA1/zxGmVYtudzKD
 ua960kB7y9v14niOJmF+16P6prZ6RH70x5D8CY5rfVMgMi3/qtfKzeA/daPo9phkD6cY
 sXDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ru51C74AZClZTzPkMtbBN26J3qvHNHAk8kt/SSSWmMQ=;
 b=waSuCq3rsO8hJbY3SvKSsSebDM9Lg5FW8wcXiPOpt1hNUGqc6GNnta780Slvw8aTsT
 V0W5rpsXO/OBAD2mKyQxFYGK8dlXBfXklQ2Qqwru6h3vJuYV4ZB8ceEir3SoRQ5+Zkji
 U3aRGDja/Og3WNWYtc9XW8kuj7TTSXbc4nj+mnlAiLHvJ5jsQ/Vnuc42thJqJMRFuBjj
 ykg8doMNejOf/tUa6Lo6hiwNT2IVgHg3UyQ8xPfy2++9+Lk7WiDnadMQP7mVVEJWoavB
 fXBMhB/F085bdsKtkiAOXsRyCPAJt6abopEWdqKiwZnhMPrlEOpaK+bv9CEuYDuSFtJQ
 /lzQ==
X-Gm-Message-State: AOAM531oSAGDTi3m3fA55iJSCBORF4cldPR5qb+JpJ4HTUgCIT72c52c
 NxEgYKXcFpwxZrGwdDRcvpllI5O9RkGzSH7E2HEFBSbZ38lKonnt78jKGZ0GDpMODld91Ikteyg
 EHV9RmjFBxukJ9WsArsC7VZZhOiSaexnnLuxO+4/OUlzw9g/rCwws2cLM4lbEk5IiTKmLkw==
X-Google-Smtp-Source: ABdhPJxmdauL4bzLhsL5MB3LD8Tti0M1urQAR6rftDmZcqGoRvQzbf3gZpqJRycih4QHhKRBBiVuqbvRidE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:b109:0:b0:314:ba3a:51ef with
 SMTP id
 r9-20020a02b109000000b00314ba3a51efmr16826519jah.61.1645589992709; Tue, 22
 Feb 2022 20:19:52 -0800 (PST)
Date: Wed, 23 Feb 2022 04:18:39 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-15-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 14/19] KVM: arm64: Raise default PSCI version to v1.1
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Atish Patra <atishp@atishpatra.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>
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

As it turns out, KVM already implements the requirements of PSCI v1.1.
Raise the default PSCI version to v1.1 to actually advertise as such.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c  | 4 +++-
 include/kvm/arm_psci.h | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index a7de84cec2e4..0b8a603c471b 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -370,7 +370,7 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
 
 	switch(psci_fn) {
 	case PSCI_0_2_FN_PSCI_VERSION:
-		val = KVM_ARM_PSCI_1_0;
+		val = kvm_psci_version(vcpu);
 		break;
 	case PSCI_1_0_FN_PSCI_FEATURES:
 		feature = smccc_get_arg1(vcpu);
@@ -456,6 +456,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 int kvm_psci_call(struct kvm_vcpu *vcpu)
 {
 	switch (kvm_psci_version(vcpu)) {
+	case KVM_ARM_PSCI_1_1:
 	case KVM_ARM_PSCI_1_0:
 		return kvm_psci_1_0_call(vcpu);
 	case KVM_ARM_PSCI_0_2:
@@ -574,6 +575,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 			return 0;
 		case KVM_ARM_PSCI_0_2:
 		case KVM_ARM_PSCI_1_0:
+		case KVM_ARM_PSCI_1_1:
 			if (!wants_02)
 				return -EINVAL;
 			vcpu->kvm->arch.psci_version = val;
diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
index 297645edcaff..68b96c3826c3 100644
--- a/include/kvm/arm_psci.h
+++ b/include/kvm/arm_psci.h
@@ -13,8 +13,9 @@
 #define KVM_ARM_PSCI_0_1	PSCI_VERSION(0, 1)
 #define KVM_ARM_PSCI_0_2	PSCI_VERSION(0, 2)
 #define KVM_ARM_PSCI_1_0	PSCI_VERSION(1, 0)
+#define KVM_ARM_PSCI_1_1	PSCI_VERSION(1, 1)
 
-#define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_0
+#define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_1
 
 static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
 {
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
