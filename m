Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE670C433F5
	for <kvmarm@archiver.kernel.org>; Sat, 30 Apr 2022 15:48:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C98A4B278;
	Sat, 30 Apr 2022 11:48:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 89wOg76pEUg6; Sat, 30 Apr 2022 11:48:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F6524B295;
	Sat, 30 Apr 2022 11:48:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14BCD4B091
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 16:11:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xwZ6QBLTpT5U for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Apr 2022 16:11:49 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EE0C40BE7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 16:11:49 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 bj12-20020a056a02018c00b003a9eebaad34so4208345pgb.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 13:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=HQRALrLqPLOKdX3/Qrvlj2304W4cY881g6B2XTfjhjE=;
 b=e1Gj1cFIx7qA9DjuG4CERdhHtwjjaMyqc0jE42K6DIa/HcAF7kLYbOh7A4zE3CfdpC
 MXLc5TLYF/85xAw4JqYk5Z+4VaQG+kEY5rcUmOxE6tic9A7AB/r3soW+wIKvxsx6s6sb
 dwf/GudGOtBTMTSquKo6sp/pI7w4IG3EJ9Ed+c2JR8p72budxuezZoM2UOclpII5lS61
 jLjhhkg61TxTY5Ps6VReS8PPdn/lF7OSnXOocjCyRcBRNrRTP7mhwtpcGmbPstkKa1Z3
 UjsKnboQEBlCrWAyY27GIJsYPsHmlwb5DzS1Loav7ERt/ViNzQEWA6OAJ7ojRdb9jzbP
 ysnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=HQRALrLqPLOKdX3/Qrvlj2304W4cY881g6B2XTfjhjE=;
 b=l4UuYWG01NdhK59R1JKnhX8YEkp54KM78+k4rlPOUMZLCJExSFWyqZoQqyJMXIkgbj
 YHdR2/hwAxBL+VS7tqwz5CU0yHjCQJb03As9ZetT/fsV31KhutpcagV/augVVKKJXPky
 hc4BvVP1p0rxg6sCd9VFpS2EwuVVVfqZ9/Tg64iB5qanCZflWxEWRRfj8V4skHvafFiD
 Mz3t2iXEy7WC7EnX+ryqOaFRTPMQ8xcmP7FxKAElC5769UCcEcIKM2RaP8ha0V/Hhtvc
 GoVS1BCD2wrBmKP/ZqgH3OgNjfKmQll4+YPuAIOuZ4zkr65a6wJ31wenXpTy2rgm/E/3
 bvTg==
X-Gm-Message-State: AOAM530N96uhn8TT5h1qef2PKToBN5jx1++a4Isi8B8rE5mo81sGwc3m
 cOm+gpRStg2KswTjPYOKyLsrVyYCZDQ0oEPx
X-Google-Smtp-Source: ABdhPJyFiTvIOFIZYo+38It2ytGBtkvfsnlq74KMff/yRu6trFEODoofBTp8U5qgZN1B+vJQKJMiROSbmndcmE1m
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a62:87cd:0:b0:50d:bf61:3de9
 with SMTP
 id i196-20020a6287cd000000b0050dbf613de9mr906362pfe.16.1651263107958; Fri, 29
 Apr 2022 13:11:47 -0700 (PDT)
Date: Fri, 29 Apr 2022 20:11:29 +0000
In-Reply-To: <20220429201131.3397875-1-yosryahmed@google.com>
Message-Id: <20220429201131.3397875-3-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220429201131.3397875-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v4 2/4] KVM: mmu: add a helper to account memory used by KVM
 mmu.
From: Yosry Ahmed <yosryahmed@google.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zefan Li <lizefan.x@bytedance.com>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>
X-Mailman-Approved-At: Sat, 30 Apr 2022 11:48:22 -0400
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yosry Ahmed <yosryahmed@google.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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

Add a helper to account pages used by KVM for page tables in secondary
pagetable stats. This function will be used by subsequent patches in
different archs.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 include/linux/kvm_host.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 252ee4a61b58..54cc4634053c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2221,6 +2221,15 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+/*
+ * If nr > 1, we assume virt is the address of the first page of a block of
+ * pages that were allocated together (i.e accounted together).
+ */
+static inline void kvm_account_pgtable_pages(void *virt, int nr)
+{
+	mod_lruvec_page_state(virt_to_page(virt), NR_SECONDARY_PAGETABLE, nr);
+}
+
 /*
  * This defines how many reserved entries we want to keep before we
  * kick the vcpu to the userspace to avoid dirty ring full.  This
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
