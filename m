Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33044C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:58:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D1E98611AE
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:58:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D1E98611AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 847914B12F;
	Wed, 13 Oct 2021 11:58:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GcGV3x3m4DJQ; Wed, 13 Oct 2021 11:58:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BD484B0B9;
	Wed, 13 Oct 2021 11:58:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 213854B092
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:58:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KtgtWhqEJayX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 11:58:49 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 29FFA4025B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:58:49 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 j19-20020adfb313000000b00160a9de13b3so2359655wrd.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=geKOuDyapRPU6is2PIHNocmWi3CmDJ2JnpgjpVKS/bU=;
 b=VN++2S+k4KN11UpNmg8AFQd0V1g+GIwPCw0Aq+JGPbUyihxnFmzsQSjAQWJFFjtaNm
 YYyApUmsmPcCpglJBS0OcaxZiObaBCtCRWdAcMluLCbf9XZeWJNDLP+/YN4gnsmUw/f7
 xZoAHQ0KIU3Z9WWrkwvKBpCF+1Aaxuw+GPZHCqSAmBBFKgOICUlNmDE9bQXcKoPjsW5j
 qdrcCUUxcrJnn6YKO7/p/oFhIV5I4JFfwjL4N46KjxY96Z+o1Y9z1MCRtDQ1cIV2V2ST
 svmcIQV2XP3IGVQgY4dBe1Q0RNlIo0cD+KFGU4K6IAmRkQQkkco+HEFX3nhr9v6m70zt
 BFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=geKOuDyapRPU6is2PIHNocmWi3CmDJ2JnpgjpVKS/bU=;
 b=2Q17BI+MC3UW2c8et9EkyXS+5ET9ALyaQ00roO8dPSy+8ezJdY2I3nbcZuo844mM0M
 XAvND1ryWxKsiFilYL+zDIv98MnLwW1Y3/i7Le8Nl3l19yREI3CJpY8V0gSNVOVDqFGB
 Y3jy3tBajuYm7MU3qbVTXiDIV2vVk2Jwvk57567wKTncG8OaNe3E17gFbPufAuAZul/N
 Ga5jJe7tq4kCJzjP9LA0B0pv+2NEbtspMOm6Fza6+nIPhedQYnFhlQYrAb9DqiaUD8rC
 uzbDmF4Dtd93OcM5jPXmnBvurvGEjA5ToGYaqwzqJGG/27LGou+llplzoxXtuTpJaMUz
 hGJg==
X-Gm-Message-State: AOAM532CDBD9QAeYp9+t0/dIzMJ4moIIa3gvfWnNmuBDNpXWp/CG7r2o
 g+MAFoPE+kzNgT/5k4xtZqTK9uMehUde
X-Google-Smtp-Source: ABdhPJz0XCfJeYia0X1UAzFkedYN1KhyaiIYXjxhsEH0zsNp+ml8wu+2Vv+dlUCbDB1lFLK95GPgHM0lsljj
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:65b5:73d3:1558:b9ae])
 (user=qperret job=sendgmr) by 2002:a05:600c:4fcd:: with SMTP id
 o13mr14107564wmq.158.1634140728272; Wed, 13 Oct 2021 08:58:48 -0700 (PDT)
Date: Wed, 13 Oct 2021 16:58:21 +0100
In-Reply-To: <20211013155831.943476-1-qperret@google.com>
Message-Id: <20211013155831.943476-7-qperret@google.com>
Mime-Version: 1.0
References: <20211013155831.943476-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 06/16] KVM: arm64: Provide {get,put}_page() stubs for early
 hyp allocator
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, David Brazdil <dbrazdil@google.com>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

In nVHE protected mode, the EL2 code uses a temporary allocator during
boot while re-creating its stage-1 page-table. Unfortunately, the
hyp_vmmemap is not ready to use at this stage, so refcounting pages
is not possible. That is not currently a problem because hyp stage-1
mappings are never removed, which implies refcounting of page-table
pages is unnecessary.

In preparation for allowing hypervisor stage-1 mappings to be removed,
provide stub implementations for {get,put}_page() in the early allocator.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/early_alloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/early_alloc.c b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
index 1306c430ab87..00de04153cc6 100644
--- a/arch/arm64/kvm/hyp/nvhe/early_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
@@ -43,6 +43,9 @@ void *hyp_early_alloc_page(void *arg)
 	return hyp_early_alloc_contig(1);
 }
 
+static void hyp_early_alloc_get_page(void *addr) { }
+static void hyp_early_alloc_put_page(void *addr) { }
+
 void hyp_early_alloc_init(void *virt, unsigned long size)
 {
 	base = cur = (unsigned long)virt;
@@ -51,4 +54,6 @@ void hyp_early_alloc_init(void *virt, unsigned long size)
 	hyp_early_alloc_mm_ops.zalloc_page = hyp_early_alloc_page;
 	hyp_early_alloc_mm_ops.phys_to_virt = hyp_phys_to_virt;
 	hyp_early_alloc_mm_ops.virt_to_phys = hyp_virt_to_phys;
+	hyp_early_alloc_mm_ops.get_page = hyp_early_alloc_get_page;
+	hyp_early_alloc_mm_ops.put_page = hyp_early_alloc_put_page;
 }
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
