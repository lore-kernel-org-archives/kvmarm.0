Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47695C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 09:57:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02AF54B226;
	Tue, 10 May 2022 05:57:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6GNAknH7Tqhq; Tue, 10 May 2022 05:57:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACF364B1DD;
	Tue, 10 May 2022 05:57:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DA8B49EEE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 05:57:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9h3fbiEwNBik for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 May 2022 05:57:21 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2FB534B099
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 05:57:21 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 k5-20020a05600c0b4500b003941ca130f9so5086623wmr.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 02:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=mKMNvyZBuuA9SLayUryCuhjhpUdoCiXuRmOyn6vDo4I=;
 b=T/9pE2m91NoXAenAIeFnB7RnZeuYl5qJg/+rpiIScDWS4RmtOIFi9MbPy32BAJeqoW
 RwcnK57L7upiL7QOz/V5hMywhWMYCQCTbll1Z4T3RPXHP+d1Ojpd2o6+L1S586UQjYJK
 JT6j+mzFnm41weM8A9dBJRdsS5EtuS0FDEmmtwpTCGCgc5ASwhKeYIUsKnsATbNeWCL6
 SBhYzzw0qie0weuXxrZtYDPvAo0qFsNJ3YrNmUUuBYQ3PatAiVMT/OFPaJpG8epyYeOY
 dDQc8D1bND0SL9afGXin4WqivexrrfLhqe8ejOaw48vlsctcrl9B50jC6zq01ePYjrNr
 ry2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=mKMNvyZBuuA9SLayUryCuhjhpUdoCiXuRmOyn6vDo4I=;
 b=Wv+Wd8dvTPI3KNrJFHtdpxbAN2nYDSTLcZTDRM+YDQcEWd1Vah9l+49DMYpW8Qq6Dq
 HThoP28MIdh0MP07RsFHzjUlGdP3C+P9rYHsNLUsNuZ9yMnSgWBJnKmXUDd1TCipXQ/H
 Mk9BfeH0sC2pCkevU2x8c6e2pLdPe7RpEXBEzrKU1XX8/Ax5CjNBrK+uoFdAmOLk9Ro9
 2yQlnXMXzL2zO60A/qHYji4mm0/Ye1vPbRI7Qp7jOe73/u+QqWfWJLeoy04T94ZZsLSh
 CtlF6WbdVQhXMXPu5WMVcqOdPldebqMOJb8fkVgXTlg/kKT7db4fBhfPypyUBf+SjU/O
 7bdg==
X-Gm-Message-State: AOAM530LzBEl8J0W1BVt++E5wUMGZLg2aNoM1Ghex0HFaA/Qkz5oTHy5
 147Q/fDqC8xYxhMm0VERC3cllA9ZLLZ8O4228PGLKmxBwlIf72qEfTdnZGTo7+DXhnebYNI8VEV
 DB88kCG9sgVKk3uQJ0DfkfJPj0oCNvuo65wjLRVF6dZ54NfPjw6eOZAoCcDX4BgsYNvQ=
X-Google-Smtp-Source: ABdhPJxgxLziV5lD00E3d70FP+JsDRwBhJjSHtA0R3ZtNY/VGd2q0FAYdR9UTgDYUJOb/BpOuW//Rhvhug==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a1c:4e0b:0:b0:393:fd8f:e340 with
 SMTP id
 g11-20020a1c4e0b000000b00393fd8fe340mr26699159wmh.136.1652176640085; Tue, 10
 May 2022 02:57:20 -0700 (PDT)
Date: Tue, 10 May 2022 09:57:10 +0000
In-Reply-To: <20220510095710.148178-1-tabba@google.com>
Message-Id: <20220510095710.148178-5-tabba@google.com>
Mime-Version: 1.0
References: <20220510095710.148178-1-tabba@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v4 4/4] KVM: arm64: Reenable pmu in Protected Mode
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
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

Now that the pmu code does not access hyp data, reenable it in
protected mode.

Once fully supported, protected VMs will not have pmu support,
since that could leak information. However, non-protected VMs in
protected mode should have pmu support if available.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 3dc990ac4f44..11c43bed5f97 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -774,8 +774,7 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 {
 	struct arm_pmu_entry *entry;
 
-	if (pmu->pmuver == 0 || pmu->pmuver == ID_AA64DFR0_PMUVER_IMP_DEF ||
-	    is_protected_kvm_enabled())
+	if (pmu->pmuver == 0 || pmu->pmuver == ID_AA64DFR0_PMUVER_IMP_DEF)
 		return;
 
 	mutex_lock(&arm_pmus_lock);
-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
