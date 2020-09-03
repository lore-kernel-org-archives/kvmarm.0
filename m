Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD8DBC433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A2B1208C7
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 13:53:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="PAUNe6ZH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A2B1208C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 064124B2BE;
	Thu,  3 Sep 2020 09:53:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eMrzCW1iTWhg; Thu,  3 Sep 2020 09:53:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A78D4B2C2;
	Thu,  3 Sep 2020 09:53:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83F344B223
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PG4P3x2oNXd6 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 09:53:20 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B89BE4B260
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 09:53:20 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id e14so2180999qtm.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2020 06:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=UCgMQtwX3W3s8ZDyYBjL9JKgT6RYNGesqggnsfm1pPY=;
 b=PAUNe6ZHeo3hRsdcTZWSpeBSRbH9UHrnYw77zuM9pXkY2QL/BTlvmt4uLbBJw3WY+X
 aHAMALaAqmRNWwZs8NgwBiUrF4Y3kbM13j6siVVYyf2qXXu5eTYie9xaJSs/7xxb+KVo
 uxXuIcm5u1Qy81221xjWZoO9k61nGc0aBSERv9N3rIuzvdgbmoGtLES4GugM6SCDVYQo
 U4b4MBCxxC41F0Y/2KLYV6MzY6LfCZ+qwqwAQ+t+Jn6nqKe5HAaHnrSpss6FxYFC4fIN
 IDQx/bX3WfWcn+afn09jyGeRNWQzkkBHSmwJ0gnNNeE0TLRTPW8pfaaq5TEp9aUv6eq2
 zDCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=UCgMQtwX3W3s8ZDyYBjL9JKgT6RYNGesqggnsfm1pPY=;
 b=F1LKNTZ5AgBrBITqDn2Ox4k41xwC7n/bauoT2vRN00aRbyKIGIOxbLRLTu9tFhnnKH
 31XhBOba1X8Z1+fQMhkf8xnUTZiOixB8tAgnF6CU1GVARoaRl30uPdNshE231FjUTq1g
 QyZHlWNMTrxJli64vK6qILJ5FzvgZ+sWFy/vci7H89fpkkYmMXp8Y/hbIYf3O7mSs4E3
 JrV7fAU2i14MrmymMs52FcCCfKqQLwQCu8/QrHEQzrDlL0iStx55EyYb/1q6+DvadlX6
 dcYGL3a1p3Plv/LdlW8ydn6taH8u+cxW516zWqiwh2ZzJbofkTNwZ3U+EXBxwDb5CVLd
 KAKw==
X-Gm-Message-State: AOAM532O8T76Alf/4hIFcSwx7Kb6/beW9/SCKaNek0Anq2DEkPL1bsLw
 L24itQAUZuyBNsFfrm8/l+66R8F2GPG0avzaewBx/xaTklG0HSQD0lBEe4Qw4tM7lnWCfEQ+IZX
 nOd6MD/0awzJSzj0SQzmMybbdOVceqkww/QkfntYDPHuYjqKWEakFjQDXQsLGieL/FjyI8A==
X-Google-Smtp-Source: ABdhPJzvdQvQC5eozCMSqpzTnaknMz+pyQKrd0Ty0gYIWMOMo5HKn5gvmDJPPbLZ54TXF5K660HziphkR28=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a0c:f48e:: with SMTP id
 i14mr1948535qvm.5.1599141200162; 
 Thu, 03 Sep 2020 06:53:20 -0700 (PDT)
Date: Thu,  3 Sep 2020 14:52:53 +0100
In-Reply-To: <20200903135307.251331-1-ascull@google.com>
Message-Id: <20200903135307.251331-5-ascull@google.com>
Mime-Version: 1.0
References: <20200903135307.251331-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH v3 04/18] KVM: arm64: Restrict symbol aliasing to outside nVHE
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
 will@kernel.org
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

nVHE symbols are prefixed but this is sometimes hidden from the host by
aliasing the non-prefixed symbol to the prefixed version with a macro.
This runs into problems if nVHE tries to use the symbol as it becomes
doubly prefixed. Avoid this by omitting the aliasing macro for nVHE.

Cc: David Brazdil <dbrazdil@google.com>
Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_asm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 6f98fbd0ac81..6f9c4162a764 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -99,8 +99,11 @@ struct kvm_s2_mmu;
 
 DECLARE_KVM_NVHE_SYM(__kvm_hyp_init);
 DECLARE_KVM_HYP_SYM(__kvm_hyp_vector);
+
+#ifndef __KVM_NVHE_HYPERVISOR__
 #define __kvm_hyp_init		CHOOSE_NVHE_SYM(__kvm_hyp_init)
 #define __kvm_hyp_vector	CHOOSE_HYP_SYM(__kvm_hyp_vector)
+#endif
 
 #ifdef CONFIG_KVM_INDIRECT_VECTORS
 extern atomic_t arm64_el2_vector_last_slot;
-- 
2.28.0.402.g5ffc5be6b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
