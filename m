Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4CCC43461
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB7AF20B1F
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:47:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="AdjWjTtN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB7AF20B1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85F974B311;
	Tue, 15 Sep 2020 06:47:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HEP-siHginJw; Tue, 15 Sep 2020 06:47:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 373CD4B387;
	Tue, 15 Sep 2020 06:47:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 604DD4B1FC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XCcDMVq58wQX for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 06:47:23 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5FBA34B266
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:47:23 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id x81so750604wmg.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 03:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=DjugrIsIo9NbgpMIze2IlMKd7M0s+FgSEpJQc959sAg=;
 b=AdjWjTtNqBEu8XC0qrI2Doumfnl1u/98nHUb8yV+hWCu2eMCWIXa0Sycs5RDmB6ZQG
 p63y3SVsXh09J2ZzfrkDW7GbCe0DWwhGxAw+4jI8GC4r6Gv7jGJXaN6tPn7lfYaXdJ3E
 4xy9EucREiUvB9BGFWTLbzVMXI1k9+hw3zCjbUHCCsMJT4ldACsbid77iin+lsWQ4/qn
 mAM60wQraTK6W3utVHMRHlcxDlwj5pwfLeKshZBp2Fut1k+543AShKYpZRfkCEXqErRT
 xItjbRtfQBG/aSTVEDsmma563zqL9ALiM2w5lQcEXB1Ssm6rPXA6Xzn6VfESMYCZOLty
 N48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=DjugrIsIo9NbgpMIze2IlMKd7M0s+FgSEpJQc959sAg=;
 b=EhKiXQrPZfFS2Wv4NMadTR1gZRjAKWltfn6ced/lF6PWcH6KO1KknZRzhv8LhaRZX1
 xA6sD2Rq4JXiWf397hRLKSKITNPWtskkvMIoefPzzvmn1DVArTHVQn0agG2TimUsIOa4
 ukl7R0HLjpCmKWYu4ofeC6YS8QCzu/43kTMdGTa2EM52w9ciSIwexjydHtEs3dEBVIjP
 OKG778/2/o+8tqq1scP+Nq86/pI1CDCDBaKzgHLMAJUfNS61cvGmlN3TkUuXgkfZ+Y51
 9eQYI2XQQRo28tarp3Ji1xJUDi5CXjs7uL5qQyqrknKUCKXeZxtw65UEyMXK2Mq+qrqz
 fx0g==
X-Gm-Message-State: AOAM5331nD7wiORnUXiwqbwAs+fG/3F6DE78qlwlcvP+F38YLRFIhuUh
 VXbRk6ZAsgKqrI19GNKaFOE+VQaNhQiBQTzuZjXyP+/o+x9AGBsbQz8rF7o8LEZI7CnSMHMxpoG
 d5XTqx+hH46ho0igze5xH52U608M4OogXKOL8I5s+H8dfhmHQa5CvThY0j+Bo4STyrpugJg==
X-Google-Smtp-Source: ABdhPJw8Q7MpHg3xLyRxGPztMJutjDk1DHb2qJ0mm/5d8A9JnUnE9yS13L5VwxR6dx04+UuJJkg1drM3GDw=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:adf:db52:: with SMTP id
 f18mr20571197wrj.397.1600166842477; 
 Tue, 15 Sep 2020 03:47:22 -0700 (PDT)
Date: Tue, 15 Sep 2020 11:46:39 +0100
In-Reply-To: <20200915104643.2543892-1-ascull@google.com>
Message-Id: <20200915104643.2543892-16-ascull@google.com>
Mime-Version: 1.0
References: <20200915104643.2543892-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v4 15/19] smccc: Define vendor hyp owned service call region
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

Vendor specific hypervisor services have their own region of function
identifiers reserved by SMCCC. Extend the list of owners to include this
case.

Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Scull <ascull@google.com>
---
 include/linux/arm-smccc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 15c706fb0a37..ee286f5de239 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -49,6 +49,7 @@
 #define ARM_SMCCC_OWNER_OEM		3
 #define ARM_SMCCC_OWNER_STANDARD	4
 #define ARM_SMCCC_OWNER_STANDARD_HYP	5
+#define ARM_SMCCC_OWNER_VENDOR_HYP	6
 #define ARM_SMCCC_OWNER_TRUSTED_APP	48
 #define ARM_SMCCC_OWNER_TRUSTED_APP_END	49
 #define ARM_SMCCC_OWNER_TRUSTED_OS	50
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
