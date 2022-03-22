Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 439A9C43217
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 18:35:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF80D49F1C;
	Tue, 22 Mar 2022 14:35:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xM4FESAfVZV0; Tue, 22 Mar 2022 14:35:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEE9249F55;
	Tue, 22 Mar 2022 14:35:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A49049F14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:35:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1LixLq5k4Xld for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 14:35:47 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BCCDD49EE8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:35:46 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 s4-20020a92c5c4000000b002c7884b8608so9649971ilt.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 11:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=tnmr6FcY2JLhce32y9oAbKJR7f3jp9JaOpVAL3BoK3A=;
 b=GxSnt/O3uM4E7Ryuar3lRQb3ZogNtuTF21itlU478JfimK/CQKTWdC9abGJl5jGsFh
 vsCpeMIIxraZrqRAwjKKOTB0V//WU8dg4cRVKC5Q0oAggoKE61LbaN2rbGZvkGP8/uOI
 j74qp5vzLIA/wwHG8BgfrxsjGVbP6uB+Zf/aYbxfEVInJprXmyWl37BtVnmB2T3XX6u1
 1rCCQ1bgNVvEq9m2lW4tSlCy3pGPNhFI7/hNOXDvATOYcr4EOtfhnIbMlmth4ZA3l6pq
 8WyopLOxPV6FWc3VIk5u2CKXW37WMVKpQ+2nVJy6NA9Y65KSYa++PFSfzbm7x68qpJ47
 G89g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=tnmr6FcY2JLhce32y9oAbKJR7f3jp9JaOpVAL3BoK3A=;
 b=pfb7nJprfrx6emY/uCS4owf0NeK98H7R4c2JDfZapqEWwcXaiQp42gROJyWsyaZay8
 6YNI+32abLPo6JWfdwtBPZ5kzLmXR9OzWk6aEXyc6QMcOik2Xu2EnqM6EWrZYRgmA8sZ
 0DLLLvjOzONeQUStTw3/T8p/jQIzAbRP+ouoNFLaF0Af1oQws50/3WLH32M45bCZB8LN
 OxBRZpysxPbqigTyxEimyh51xZn6KkWiWZmT5b8DA6V8qnp6213AmTunEyjC2s9WucXC
 DRowdzGdmMazIoVVQDZyZDZ+NFnFHxiT1fesF+Kjq/V5wgz72uSyLAwaiTsesS/LYm+N
 5m0A==
X-Gm-Message-State: AOAM530JrwfGaY2IS7M9tKdRj5K7RvcfqWDxy6xGgkhlFQ2wIwTq9Fdn
 c9pjfMb3B3h1D0fzHCl86IDZbUdgVes5AcedV36oLZ8938I6LJkP8xAv2tIXcBS0FZ9bypd4mtb
 re7UnXJqalXgapwWAp0jLby5ky9uOMQayrp9tXAFpfolZnfDmQAD4j45Talq7hDu7vaAw2w==
X-Google-Smtp-Source: ABdhPJyqOQMpygQKbMQI+YxY6NGJvNzmxA9fxDwQQ/eBULRiqPtajRMzQcxcfqJ1BaMG0pno7t9pgoH7orM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:3e13:b0:321:446d:2977
 with SMTP id
 co19-20020a0566383e1300b00321446d2977mr5465994jab.178.1647974146089; Tue, 22
 Mar 2022 11:35:46 -0700 (PDT)
Date: Tue, 22 Mar 2022 18:35:37 +0000
In-Reply-To: <20220322183538.2757758-1-oupton@google.com>
Message-Id: <20220322183538.2757758-3-oupton@google.com>
Mime-Version: 1.0
References: <20220322183538.2757758-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 2/3] KVM: arm64: Actually prevent SMC64 SYSTEM_RESET2 from
 AArch32
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
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

The SMCCC does not allow the SMC64 calling convention to be used from
AArch32. While KVM checks to see if the calling convention is allowed in
PSCI_1_0_FN_PSCI_FEATURES, it does not actually prevent calls to
unadvertised PSCI v1.0+ functions.

Hoist the check to see if the requested function is allowed into
kvm_psci_call(), thereby preventing SMC64 calls from AArch32 for all
PSCI versions.

Fixes: d43583b890e7 ("KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest")
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index cd3ee947485f..d24ccc77500b 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -232,10 +232,6 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 	unsigned long val;
 	int ret = 1;
 
-	val = kvm_psci_check_allowed_function(vcpu, psci_fn);
-	if (val)
-		goto out;
-
 	switch (psci_fn) {
 	case PSCI_0_2_FN_PSCI_VERSION:
 		/*
@@ -303,7 +299,6 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 		break;
 	}
 
-out:
 	smccc_set_retval(vcpu, val, 0, 0, 0);
 	return ret;
 }
@@ -423,6 +418,15 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
  */
 int kvm_psci_call(struct kvm_vcpu *vcpu)
 {
+	u32 psci_fn = smccc_get_function(vcpu);
+	unsigned long val;
+
+	val = kvm_psci_check_allowed_function(vcpu, psci_fn);
+	if (val) {
+		smccc_set_retval(vcpu, val, 0, 0, 0);
+		return 1;
+	}
+
 	switch (kvm_psci_version(vcpu)) {
 	case KVM_ARM_PSCI_1_1:
 		return kvm_psci_1_x_call(vcpu, 1);
-- 
2.35.1.894.gb6a874cedc-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
