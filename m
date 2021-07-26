Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FEDC432BE
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2EF7260F4C
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2EF7260F4C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7B1A4B091;
	Mon, 26 Jul 2021 05:29:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SyqEnvP4Q2fn; Mon, 26 Jul 2021 05:29:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE1A14A483;
	Mon, 26 Jul 2021 05:29:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AED7406E0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iPntkYfHBB+u for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 05:29:38 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A41974A483
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:36 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 o8-20020a5d4a880000b029013a10564614so4478517wrq.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 02:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=fyCHOW6maJF9L7guSoQxIXFDKYajZ5tEfL0M1nzcu3g=;
 b=b6cEmvJ0vdEy2FGe8oxQq0HlmnKC08AOEIcGg2mj6fy+SSGskiuESRrYptCgJBbUZu
 mt0BDG+nEREOBOG2gON7kzVvLlgj83N/3hY4W0c6StPuMfpFjuKVeuGnNBubwob1lg/y
 noakRpnUfRpGOAidTPg/rki9g0KqzEwYypxs4M7HTnvPXf7iFxu/B6GlMaKalYBVBH14
 YkQii/9BBIPj6M2rqhx9TIywxni7ift1Cnpcz6Om6njwYOV6G8R2RL+mltGn89rqQd3x
 lPyubLT/kp4B80c1Rt5WC3DkG7lsQlG7ga2RipuW01KExo0V3PSpKTM1DAMcXKZlw0ft
 7ibg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=fyCHOW6maJF9L7guSoQxIXFDKYajZ5tEfL0M1nzcu3g=;
 b=P3zjDBjSQ+rmLBm9q7nqMvCYMh13fCBiGtdRS070MzmpkAzNhIqpS19KwqhLopPxad
 gCxXPoD5L+zqSNa8MfvIZVA30ioSy1+IhuGNCQ4JystSbL5HWoOdNxJ7EBXi0FNvKrEK
 68gau2AyJ+bymzwYVwYNeO/M/GsC4YasGi30Vh5Q2omYxfrH/O9W9nWACbCS9PySj96+
 pEWt3MRItioVu/a+lgqUIbslJ3jP+BqBaxT6WjHIwkX9c+WS/KktNJuho42ZrqOcHlPp
 BTYhI2VjAA5PEBf2QZd2NJX58OqyxdCcucWXJpouNggz2RtROCqu9hEDIZUiKq/qK0W8
 9V5w==
X-Gm-Message-State: AOAM532iRfSFKL2E0kVr9AldCbgx1LP4yYqz180mNd3kaKfRIkZ1i6d0
 STJmfLnaI2zi3lQtZS08gxZrB01N+c2l
X-Google-Smtp-Source: ABdhPJwpwF4hCeEcD8WP2F52FmGpoCMVmSoE2R/VRCPmMc5vvMGS4yzbAZ1WyJM7j6+dONr435cj4ZE0ccVT
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:23a0:2f14:433:e6cb])
 (user=qperret job=sendgmr) by 2002:a7b:cb4d:: with SMTP id
 v13mr14985934wmj.68.1627291775721; Mon, 26 Jul 2021 02:29:35 -0700 (PDT)
Date: Mon, 26 Jul 2021 10:29:00 +0100
In-Reply-To: <20210726092905.2198501-1-qperret@google.com>
Message-Id: <20210726092905.2198501-12-qperret@google.com>
Mime-Version: 1.0
References: <20210726092905.2198501-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 11/16] KVM: arm64: Introduce and export
 host_stage2_idmap_locked()
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Cc: qwandor@google.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
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

We will need to manipulate the host stage-2 page-table from outside
mem_protect.c soon. Introduce a function wrapping the host_stage2_try()
call and make it usable to users of mem_protect.h.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index facbd9a7ab99..8e5725d032b2 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -50,6 +50,7 @@ extern struct host_kvm host_kvm;
 int __pkvm_prot_finalize(void);
 int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end);
 
+int host_stage2_idmap_locked(u64 start, u64 end, enum kvm_pgtable_prot prot);
 int kvm_host_prepare_stage2(void *pgt_pool_base);
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2d41d4fa8901..223c541a7051 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -266,6 +266,11 @@ static int host_stage2_find_range(u64 addr, struct kvm_mem_range *range)
 	return 0;
 }
 
+int host_stage2_idmap_locked(u64 start, u64 end, enum kvm_pgtable_prot prot)
+{
+	return host_stage2_try(__host_stage2_idmap, start, end, prot);
+}
+
 static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
 {
 	/*
@@ -303,7 +308,7 @@ static int host_stage2_idmap(u64 addr)
 	if (ret)
 		goto unlock;
 
-	ret = host_stage2_try(__host_stage2_idmap, range.start, range.end, prot);
+	ret = host_stage2_idmap_locked(range.start, range.end, prot);
 unlock:
 	hyp_spin_unlock(&host_kvm.lock);
 
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
