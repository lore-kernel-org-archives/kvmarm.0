Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC3A2C4743D
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:12:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A24D96135A
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:12:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A24D96135A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 567814A19A;
	Tue,  8 Jun 2021 10:12:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7yfKKbaG3ben; Tue,  8 Jun 2021 10:12:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A142407ED;
	Tue,  8 Jun 2021 10:12:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F73D4079A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:12:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vDeWmmkilRKa for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 10:12:11 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7EDAB406E0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:12:11 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 t14-20020adfe44e0000b029011851efa802so9454866wrm.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 07:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=k1l2n59g13iNu83bUTxARpOhgMKflgQ04MOsDPUh0Ic=;
 b=HKMRwVfndsrVEdmwwjp+AJfDUAU/7SHKuQu+f50Ph5TxJeikrk3f1yLdxBBbNGalK4
 1OsQdR3D7asjd+1UcEgIGwjwfNFpdR4INjRegFwmCpjoHIFrG4VisTD9D+yw0wOrihMD
 u+jS5KLKNo5J22J7NPibJPCz8HM4C4uXx57pgOf5PT9cJ5hlU5DjgyMov1wcyirmTTfd
 DmnL7lIfo9JWERgn13Mn1FX+q3udhEE6m24+t2J5Y7wWHEcarMFKH81jyvkAkw1iirzX
 ujxnJb0sk3tt2uylf6jCDqe33eE8qI8MQtloA22FQDfL0qlJumIPI3wJ6LXAx0k2kXcR
 LVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=k1l2n59g13iNu83bUTxARpOhgMKflgQ04MOsDPUh0Ic=;
 b=VaYqVsrgbTTZumuW9tYoJFkK/mVbJP6ObXnerc9E8pXUTlSQRIG0YJsqbsNfupiptR
 UX5qUJmlfBvCI08bbNKZCiu4ZR44exCP3ggx07p5c16fx0LUY4Nnn18VI/sLnvaxizOd
 yjkBHYMXz4RzESdCMt+xrxLQYZGbhAoPewzxV9dUSUZYw7cvn3H3tCZu0op95thbU9EA
 GfPVdZ4cizl3GqWYgtWgoZfCOzCUGE2ocdpo51Zv2na6M5PAZ/4xwCDOs3dx87tnAX48
 RA32oyExVawcukCBdoA2aZr/L1VLz6BoZakg9GQ0T3fl9rE4ak/hUmGgRkBH3MMToCPj
 kDpQ==
X-Gm-Message-State: AOAM530Ce19HTHupw/eHLbqQWhR8cga1e7gyl30NB4I/JYW6HQsHgD5Z
 UtbvGzDM/JwOBfdZqN/5ETpFxkT60Tq3AEKpZ3SDkE+sBeBXPTw7q2SiFUpC/QW9bajeRbcq2np
 lf6LgqJYh2oUcN2Cl2rty/SGUUpPaSfJ9gwzvMg7bzC+Owntes56MxduEDm2RcrDzVXM=
X-Google-Smtp-Source: ABdhPJzXIHfxt5tac7kqNaZAg4dHpDxMG83Oc7gi7GtbAhXwc3s7cpEqjJlIIcQ1S8LZ+Ld/XnKDm6HcjA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:4fd0:: with SMTP id
 o16mr4554612wmq.50.1623161530591; Tue, 08 Jun 2021 07:12:10 -0700 (PDT)
Date: Tue,  8 Jun 2021 15:11:41 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-14-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 13/13] KVM: arm64: Check vcpu features at pVM creation
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

Check that a protected VM is not setting any of the unsupported
features when it's created.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pkvm.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index cf624350fb27..5e58d604faec 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -88,10 +88,41 @@ static void pkvm_teardown_firmware_slot(struct kvm *kvm)
 	kvm->arch.pkvm.firmware_slot = NULL;
 }
 
+/*
+ * Check that no unsupported features are enabled for the protected VM's vcpus.
+ *
+ * Return 0 if all features enabled for all vcpus are supported, or -EINVAL if
+ * one or more vcpus has one or more unsupported features.
+ */
+static int pkvm_check_features(struct kvm *kvm)
+{
+	int i;
+	const struct kvm_vcpu *vcpu;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		/*
+		 * No support for:
+		 * - AArch32 state for protected VMs
+		 * - Performance Monitoring
+		 * - Scalable Vectors
+		 */
+		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features) ||
+		    test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features) ||
+		    test_bit(KVM_ARM_VCPU_SVE, vcpu->arch.features))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int pkvm_enable(struct kvm *kvm, u64 slotid)
 {
 	int ret;
 
+	ret = pkvm_check_features(kvm);
+	if (ret)
+		return ret;
+
 	ret = pkvm_init_firmware_slot(kvm, slotid);
 	if (ret)
 		return ret;
-- 
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
