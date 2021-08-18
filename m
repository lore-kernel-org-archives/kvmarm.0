Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE015C4320A
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:00:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6ABCE610FF
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 20:00:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6ABCE610FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AB1C4B08D;
	Wed, 18 Aug 2021 16:00:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JD-IyxteKF7g; Wed, 18 Aug 2021 16:00:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A8F94B0F9;
	Wed, 18 Aug 2021 15:59:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBFD0407A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:43:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g6qxbU+3+frh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 14:43:23 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC8774B0AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:43:23 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 t101-20020a25aaee0000b0290578c0c455b2so3824385ybi.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 11:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=i0gC3YpOlYGFveSBqO/xZNra4rgAWDR79DWIZ6oDj6o=;
 b=c8xHVk4s6hSd+6Y9GryOeLTGVMmzfkiq1hv7+jFyRnpW6EH3IA6vmLaWc7VfrEEA9H
 BC5PDnWCLJQYD9/0Xt+U8dv1Hz1sD/0zc/41uJi38os0mU+Gy01KpPSwhnyRj/Gr1yBA
 GO0AuLPq9dgBbgik2aFUjbnvbKt/xem2y4uC8HTF6LEJ0/1IX9Us5a3LLtfBjdVOiMU+
 YosbEo5C7+oG7IxmbUBFFHTDPskrCRAsnrhO2XGtZsFSmNugOGf3h4yFHVuLFyX+B8Vg
 THIDBL5JM6sHOxo6jAk1l1wrkOmBjDxa2oo74PYYstjOagpBtrnx3g4Gi7UHSKp9/9xe
 4t4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=i0gC3YpOlYGFveSBqO/xZNra4rgAWDR79DWIZ6oDj6o=;
 b=L7LAFte9n3GlBT8tlwF6UF5/pC2OSSaAEK5kmM0+uss34G2PxXb96u4TXeIeKpL3ij
 +oLjrFmjyrrzKzvQlEaNgZPhrHva7+OqRk2CaQ35viXkXDtHlCvQs4XOo9dtACTx9G5m
 3o3HzhN4HsPtLITW/CXjaN20HSyTYjweyQAOGh8jJGVAaI8xFDxnBS1VW35kiGBr6jvO
 TFXOn3yHRvCiBv7ed9Umul7gEb69QkcDGtGHx9xknSGbj9e4hcfO2ltaMGBMdWWlWqZF
 qXoPPhABx1IeL84gQ54+/OC+0RqFbsmxjKdwlGXd+Ewk2nNX0/nyYQCReTwkBU4qdYjL
 E2Bw==
X-Gm-Message-State: AOAM530UoNgeuwfN1fHBaRmfrrjY1SKXQoyKYy6WitH8FKo7I1vi7djB
 Bwne3TC6vjvn3JtN5XAZVI22yWu/9Vv5
X-Google-Smtp-Source: ABdhPJwB6PS63y9NDjqeatAE1xaf+AJcpA2bji3PMSZ/4YD/r9FU49atLPRhaO9PZI8UBkHhanFmIb7u3Kje
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:f803:: with SMTP id
 u3mr12689796ybd.515.1629312203430; Wed, 18 Aug 2021 11:43:23 -0700 (PDT)
Date: Wed, 18 Aug 2021 18:43:04 +0000
In-Reply-To: <20210818184311.517295-1-rananta@google.com>
Message-Id: <20210818184311.517295-4-rananta@google.com>
Mime-Version: 1.0
References: <20210818184311.517295-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 03/10] KVM: arm64: selftests: Add support for cpu_relax
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Wed, 18 Aug 2021 15:59:47 -0400
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, kvmarm@lists.cs.columbia.edu
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

Implement the guest helper routine, cpu_relax(), to yield
the processor to other tasks.

The function was derived from
arch/arm64/include/asm/vdso/processor.h.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/include/aarch64/processor.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index b4bbce837288..c83ff99282ed 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -188,6 +188,11 @@ asm(
 	val;								  \
 })
 
+static inline void cpu_relax(void)
+{
+	asm volatile("yield" ::: "memory");
+}
+
 #define isb()		asm volatile("isb" : : : "memory")
 #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
 #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
