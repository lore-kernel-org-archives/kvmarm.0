Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 280AEC49EA2
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E2C1461477
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E2C1461477
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FF044B117;
	Tue, 15 Jun 2021 09:40:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AQPNqGLSQbgJ; Tue, 15 Jun 2021 09:40:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E8B64B102;
	Tue, 15 Jun 2021 09:40:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 991C14B0DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r20PitmAjkpm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 09:40:20 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C03D74B0E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:20 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 v134-20020a37618c0000b02902fa5329f2b4so7596161qkb.18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 06:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=MzTuqOfSLXkQXPIBooH4fP63ZLmEi4w/w9F0qFeyLuI=;
 b=b7HMusMXDb/BxYrxekRaLBxg6+8Di6dNYMsHoZDx91Rw74oEQIqQpEq4tZYgXlM9Bq
 vBq9n+In91lMzAjJUtBV2Qu2CPHCKbd9illCEiWAlYwAgEaftP0NYm7BNePEToWqmCCn
 7pVSLwwRKSPKsT64YEkG5/LzzS+jWXFoy+P6Inh6ochfcO7ZoZuX0kLF/J7TNi9BHi96
 5VDUuCwqtxO3gINwdOreBNN5T2Yir3rmT17+JqIg3gxAsrmpqEyfo9AT2MUfC3dBApjL
 jYoPAG42lxBJXkEvBK8FjZwPr8Bf5LH/9q+VgPrdh0UubiS6CyOU9vemBBgXNldhL5zL
 mWgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=MzTuqOfSLXkQXPIBooH4fP63ZLmEi4w/w9F0qFeyLuI=;
 b=dJNs515yf7qflowUwwe1/yfkaR7PHMfLDAMT/yf4+exeg4RIGSRBbgSWCzk0J1Zzi7
 OUQxl/7IFNezUB0ophdQIjY7NA/DkkDzvwn624oCb4gzp7NtTSZ/aaXKzvKpm/yRwaS1
 aDhMyn3NWRFX49xnJxsBgWxy5m3maWzcmlThgQzgWp4taUfMw0DNgA3JvZ9T+tCoBOM3
 scjNW/aw2LqicHa2wCVs+sAGAn0PmIBSVJ0TwGcc1JpmYXN/v1R/2XKp6cFdzqOSWm5y
 OVMBjpMLh8tp4YEE2bscwvkGwf+W4GEpCKCtpyV/0dlWGxOgleYJOOageoMrkRhVrqdA
 gYWw==
X-Gm-Message-State: AOAM533knKzQt0+E0r9bt/V9XqhaLwPtap9Hr3jtjmS9am1AXnpYVWi9
 GREg+1dgNp2/JB9RMnqZYTN8hpYSqyIMsze5HxtJtRWYVomqGVsg4OTwbTniGz24sl/YVb0rhLS
 6oueaeRLTZcAzUX0w1+pJwbciztHlRmT6pXdXjxz8JZmhFIMB1JqZy3RKyrWSEl+Rbbs=
X-Google-Smtp-Source: ABdhPJwvkJ1Cqi1cwhQ8+25SscFqILXhxSW+c+DE3yisa7Q5WIyh+leztx9V8c334RDLLSz46bw6zNHG1g==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:5309:: with SMTP id
 y9mr5312176qvr.31.1623764420268; 
 Tue, 15 Jun 2021 06:40:20 -0700 (PDT)
Date: Tue, 15 Jun 2021 14:39:50 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-14-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 13/13] KVM: arm64: Check vcpu features at pVM creation
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

Check that a protected VM enabled only supported features when
created.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pkvm.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index cf624350fb27..15a92f3fdd44 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -88,10 +88,53 @@ static void pkvm_teardown_firmware_slot(struct kvm *kvm)
 	kvm->arch.pkvm.firmware_slot = NULL;
 }
 
+/*
+ * Check that only supported features are enabled for the protected VM's vcpus.
+ *
+ * Return 0 if all features enabled for all vcpus are supported, or -EINVAL if
+ * one or more vcpus has one or more unsupported features.
+ */
+static int pkvm_check_features(struct kvm *kvm)
+{
+	int i;
+	const struct kvm_vcpu *vcpu;
+	DECLARE_BITMAP(allowed_features, KVM_VCPU_MAX_FEATURES);
+
+	bitmap_zero(allowed_features, KVM_VCPU_MAX_FEATURES);
+
+	/*
+	 * Support for:
+	 * - CPU starting in poweroff state
+	 * - PSCI v0.2
+	 * - Pointer authentication: address or generic
+	 *
+	 * No support for remaining features, i.e.,:
+	 * - AArch32 state
+	 * - Performance Monitoring
+	 * - Scalable Vectors
+	 */
+	set_bit(KVM_ARM_VCPU_POWER_OFF, allowed_features);
+	set_bit(KVM_ARM_VCPU_PSCI_0_2, allowed_features);
+	set_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, allowed_features);
+	set_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, allowed_features);
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!bitmap_subset(vcpu->arch.features, allowed_features,
+				   KVM_VCPU_MAX_FEATURES))
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
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
