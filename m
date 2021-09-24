Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B610FC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4478F61407
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4478F61407
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDA334B16F;
	Fri, 24 Sep 2021 08:54:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O+fezCfhmz1s; Fri, 24 Sep 2021 08:54:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEF3D4B12C;
	Fri, 24 Sep 2021 08:54:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C1014B13D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jro5DKmaIcP6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:04 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ACBF84B12C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:04 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 j19-20020a05620a411300b0045dc3262e59so6653670qko.22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=+LaJv4Ut995m+xStn+CJit8kroqDB8BrAul4VeyUpto=;
 b=WJfhJpBhFcx1yU6q2A5dq5o7v7/qoJ76LzW3bnFH/OqCKw8Y4BBx7H1VMcJ4tZ7Q84
 ycy5/fqgEuZ65y0fbocguVBTBdv8nbPd9ycSN1MZ/ZAy6kKPqAOs9K4UgY4nk42W8VDA
 jvZpEP6TxuYQ0tLZJycyC0xa/yoyJRa/NGylRXWjBBIUJSwBl6H90fh73Dket8vr+QbB
 RlBOGE1MBPLxUDMmPF6uPJF2HxT5qdB3y0sJhY2yBAnQRIjroQ1eZj05uFdc4MjgZAGX
 VAbsty9cYie2RSCLZF24ZKZDUxnrL0oCE+b2BWloYYD1AWXMRq+QxF3CHa+gXfriviqy
 qWfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=+LaJv4Ut995m+xStn+CJit8kroqDB8BrAul4VeyUpto=;
 b=i9RVlldxWacsS543hvLgQHVAPetc5gTlHZz6RecsPtaFvUZqnNXk70oLQXl2HRucdo
 +I3fyTHn9n9Epp0MfiAyNwwjAcVJxK9mSqO8WLW05QxfVgqZorT5OrpqnH2GxNGVpeJq
 2wAyIkGjtBPgxSv+ECNsiQvbJiQvt2gWnGtPO4lyWNTr/SshKN9DH0TVhFwNRBM1x6b4
 qgHg9H9KtnMWoW1atDCxkdr0jgnDVWHvtRnG9SsLIFnPx9IZYC9SYp3xUALLFEZx9eRE
 2dXBa+HwXHwUllDLriTRse5hy4iNxfpTPf2aVVXhfzvVcCzve6JL7XTwwjQ95NhptZyc
 K1zw==
X-Gm-Message-State: AOAM5333828/y1UHfr6osRKqiE9xk31Th2mVpDNfuOhEA6EGxQM8Xf5O
 IEjcYVqz8yi7RZQnqFzvMhAVYqhCVAwt0Q+yFVt/2nOsFMQ1RowNoUzLk30vPflAYwzqFwfm2BE
 bE9xDrgVvfZBp7kNRvL2BQk4rPWiDHKdj4qPu80ZeyuGbuD9nEhd4tBbdJkRWKJ6gZFw=
X-Google-Smtp-Source: ABdhPJz8XJjf9DmrCXNeHJp2ahBQOSArt9tPtY1bK5GAiDObokO9lS6nGswDDTChpYk6XAR7Ybe+AHcL3Q==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:1372:: with SMTP id
 c18mr9505426qvw.28.1632488043829; Fri, 24 Sep 2021 05:54:03 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:30 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-2-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 01/30] KVM: arm64: placeholder to check if VM is
 protected
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Add a function to check whether a VM is protected (under pKVM).
Since the creation of protected VMs isn't enabled yet, this is a
placeholder that always returns false. The intention is for this
to become a check for protected VMs in the future (see Will's RFC).

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>

Link: https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/
---
 arch/arm64/include/asm/kvm_host.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cd7d5c8c4bc..adb21a7f0891 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -763,6 +763,11 @@ void kvm_arch_free_vm(struct kvm *kvm);
 
 int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type);
 
+static inline bool kvm_vm_is_protected(struct kvm *kvm)
+{
+	return false;
+}
+
 int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
 bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
