Return-Path: <SRS0=oF2v=BB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 249DFC433E8
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:45:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D022122C9E
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jul 2020 16:45:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="mvQ2D74Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D022122C9E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8900B4B2C5;
	Wed, 22 Jul 2020 12:45:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TU5R7o0RTKdq; Wed, 22 Jul 2020 12:45:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E05A04B2DB;
	Wed, 22 Jul 2020 12:45:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C32A4B2AE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:45:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nBGEKAV3L6uL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jul 2020 12:45:13 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F6184B2B3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 12:45:12 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id a15so2539730wrh.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jul 2020 09:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=bcTngC2Bes9sF1CupaxPgWX3tAw0UoRfYaGJIdlmeeQ=;
 b=mvQ2D74QyUwCzSPTgbT4sWDjrm7UJoVfL3cHenKVZM4lEyQ4kiJMrsWap47ViZ/Wvr
 rZDWLr9NFPdHynImP8k+kUbehz7sK/izWI9taaixH28DDyAQxLDE2IVjI4JHth6sqvMd
 Bm3MyxL4Ev2MPQ719BJsT1suvEsdnYD9LiwdooMdWfuceghQTEMxSuCUAzFCiQNkszgr
 776DU9p9GQmi0hKDgGS6X4PrAU7F1kaKRpoHIctLA3l3w5RGa68JqwP9mYrDKItjiXEp
 YdYfHynQXX5o0Cs0P73flkaXSX7R5VWhnBQrZk7Ew+typZtMNI/jv6YpF1C6khkBO0C0
 nNTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=bcTngC2Bes9sF1CupaxPgWX3tAw0UoRfYaGJIdlmeeQ=;
 b=ApcY3NEjFRIaFUAyjaMWltm+rzCRjT8+tp/zQJ1v9dNjARaCrXQq1w6B+OLtwUj2vX
 lxANRQoM+2Cc3Z4glClAG2JKPEcJCKS7JqghQh0lv7pDwQqcT2P+J3fiUGbVq2dFKcmh
 wYYIcHyKSXv8fyFRVD/km5DbUpgJSO6SUxwrEnqJ0BcHW/c4UkFVs0yZIAJvQXYAyNWt
 /ja87I7VKFwh48+VVMjUPUrswrEioSdjSnyVx26RRZt9HVF4vpuFqF9KM22d+Cq/HOsY
 zx9vfZ/JXBa5bDbnFdbh7B+Lj4u5o5HZrPv1dNv7zQKyOOkO+Uf5Bij3W4dzQ38Cjsba
 pGAg==
X-Gm-Message-State: AOAM5307rVf8VnQkosGbGGPxoMVn06gv3UVSQkfHoonnwhCderrV16gP
 fEcHRkF+/iLAEfuw3G7e2Y1Zqw==
X-Google-Smtp-Source: ABdhPJx2hxeObfvv1sweoqi7kI9BIJM5pRi6WnEDs4mkAmQ3drosmvpJW+pWqVpWlbJoNaizyRi9hA==
X-Received: by 2002:a5d:558a:: with SMTP id i10mr388087wrv.146.1595436311404; 
 Wed, 22 Jul 2020 09:45:11 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:b0ee:900a:e004:b9d0])
 by smtp.gmail.com with ESMTPSA id e5sm631557wrc.37.2020.07.22.09.45.10
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 22 Jul 2020 09:45:10 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 7/9] kvm: arm64: Mark hyp stack pages reserved
Date: Wed, 22 Jul 2020 17:44:22 +0100
Message-Id: <20200722164424.42225-8-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200722164424.42225-1-dbrazdil@google.com>
References: <20200722164424.42225-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

In preparation for unmapping hyp pages from host stage-2, allocate/free hyp
stack using new helpers which automatically mark the pages reserved.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kvm/arm.c | 49 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0700c3d21b23..dc557b380c87 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1451,13 +1451,58 @@ static int init_subsystems(void)
 	return err;
 }
 
+/*
+ * Alloc pages and mark them reserved so the kernel never tries to
+ * take them away from the hypervisor.
+ */
+static unsigned long alloc_hyp_pages(gfp_t flags, unsigned int order)
+{
+	struct page *page;
+	unsigned long i;
+
+	page = alloc_pages(flags, order);
+	if (!page)
+		return 0;
+
+	for (i = 0; i < (1ul << order); ++i)
+		mark_page_reserved(page + i);
+
+	return (unsigned long)page_address(page);
+}
+
+static unsigned long alloc_hyp_page(gfp_t flags)
+{
+	return alloc_hyp_pages(flags, 0);
+}
+
+/*
+ * Free pages which were previously marked reserved for the hypervisor.
+ */
+static void free_hyp_pages(unsigned long addr, unsigned int order)
+{
+	unsigned long i;
+	struct page *page;
+
+	if (!addr)
+		return;
+
+	page = virt_to_page(addr);
+	for (i = 0; i < (1ul << order); ++i)
+		free_reserved_page(page + i);
+}
+
+static void free_hyp_page(unsigned long addr)
+{
+	return free_hyp_pages(addr, 0);
+}
+
 static void teardown_hyp_mode(void)
 {
 	int cpu;
 
 	free_hyp_pgds();
 	for_each_possible_cpu(cpu)
-		free_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
+		free_hyp_page(per_cpu(kvm_arm_hyp_stack_page, cpu));
 }
 
 /**
@@ -1481,7 +1526,7 @@ static int init_hyp_mode(void)
 	for_each_possible_cpu(cpu) {
 		unsigned long stack_page;
 
-		stack_page = __get_free_page(GFP_KERNEL);
+		stack_page = alloc_hyp_page(GFP_KERNEL);
 		if (!stack_page) {
 			err = -ENOMEM;
 			goto out_err;
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
