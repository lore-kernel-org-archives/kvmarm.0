Return-Path: <SRS0=mXZs=LT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79DC8C49EB7
	for <kvmarm@archiver.kernel.org>; Fri, 25 Jun 2021 10:11:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 16E4861436
	for <kvmarm@archiver.kernel.org>; Fri, 25 Jun 2021 10:11:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16E4861436
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A833B4B196;
	Fri, 25 Jun 2021 06:11:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d84Onj6T1hsH; Fri, 25 Jun 2021 06:11:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31D5D4B1A2;
	Fri, 25 Jun 2021 06:11:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B41F64B158
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jun 2021 03:37:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9w2bEDcNjpQD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jun 2021 03:37:24 -0400 (EDT)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA95F4B14D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jun 2021 03:37:24 -0400 (EDT)
Received: by mail-pj1-f51.google.com with SMTP id
 b5-20020a17090a9905b029016fc06f6c5bso5021886pjp.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jun 2021 00:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=LzgP6h2D/QFeac1VzX61noEzAJ/USmwi4gQaHInAahw=;
 b=LXB8g40vStNBwD+4feBv7G1sswWg7tKXE2UuAUSDoyq52hfi4irDQ/yiXu8Ug+ZDws
 xIzft/b25MjWvtHFPnJ6SklO93ihyo0nBxWHm/9AZX/s3potEvqVSuo/FGmincAfc25Y
 X1yk5o0729qjIfPuIaA+V96KO60J3W+vXFDLY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=LzgP6h2D/QFeac1VzX61noEzAJ/USmwi4gQaHInAahw=;
 b=RqKCbgB068mQNnlCD/6x9GYYHqGVCiEdPlk2J/FCVsAPyZTcx3n99mRQ4m/1wtObJF
 KgjyJwgUe7CnqoVWuAdBVxgo97O0+pruQJat6TAX+XkwL9OXzclX4Ih+ZE6UzWQwWg2v
 C4fSGAW8N1SV0IgAt9HfpQEg9VqJTy7nJ9ZsbyqAVob6BkoGqsEfDdsv2Uga9T+aQ5xn
 A48xxjD2GqTrgUFUz43vWb5QWsOu3aS4hjyKvmzdrkn9F6f3hBfuG97bIUxGwJtMq+Cw
 AVg5reuYjWqUvrLIvq5I8SZ8WqVWcZHcbWiB++G6Oy49GiQRLqgFI6roXeMRdTrbAZ+v
 VAgQ==
X-Gm-Message-State: AOAM533N++6J0o9TVmmmcES7tMTz+Uj7DfaWHx5m1sEHb9Z0auPuUw+L
 p4Er8MVxQHFr9/wraEBSWW0juQ==
X-Google-Smtp-Source: ABdhPJzquQUc1a7oAEf0YGdzW5/tdcjfbVYUNDDWR+jVqhrRl2C1S/KaYW68U6E8tZbflFTo+iOEfA==
X-Received: by 2002:a17:902:e843:b029:109:4dbc:d4ed with SMTP id
 t3-20020a170902e843b02901094dbcd4edmr7948926plg.74.1624606643957; 
 Fri, 25 Jun 2021 00:37:23 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:1492:9d4f:19fa:df61])
 by smtp.gmail.com with UTF8SMTPSA id r4sm4766830pja.41.2021.06.25.00.37.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 25 Jun 2021 00:37:23 -0700 (PDT)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@ozlabs.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Nick Piggin <npiggin@gmail.com>
Subject: [PATCH v2 1/5] KVM: do not allow mapping valid but non-refcounted
 pages
Date: Fri, 25 Jun 2021 16:36:12 +0900
Message-Id: <20210625073616.2184426-2-stevensd@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
In-Reply-To: <20210625073616.2184426-1-stevensd@google.com>
References: <20210625073616.2184426-1-stevensd@google.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Fri, 25 Jun 2021 06:11:50 -0400
Cc: kvm-ppc@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
 Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Joerg Roedel <joro@8bytes.org>, linuxppc-dev@lists.ozlabs.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 Zhenyu Wang <zhenyuw@linux.intel.com>, linux-mips@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, intel-gfx@lists.freedesktop.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Zhi Wang <zhi.a.wang@intel.com>, Jim Mattson <jmattson@google.com>
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

From: Nicholas Piggin <npiggin@gmail.com>

It's possible to create a region which maps valid but non-refcounted
pages (e.g., tail pages of non-compound higher order allocations). These
host pages can then be returned by gfn_to_page, gfn_to_pfn, etc., family
of APIs, which take a reference to the page, which takes it from 0 to 1.
When the reference is dropped, this will free the page incorrectly.

Fix this by only taking a reference on the page if it was non-zero,
which indicates it is participating in normal refcounting (and can be
released with put_page).

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 virt/kvm/kvm_main.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3dcc2abbfc60..f7445c3bcd90 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2175,6 +2175,13 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
 	return true;
 }
 
+static int kvm_try_get_pfn(kvm_pfn_t pfn)
+{
+	if (kvm_is_reserved_pfn(pfn))
+		return 1;
+	return get_page_unless_zero(pfn_to_page(pfn));
+}
+
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       unsigned long addr, bool *async,
 			       bool write_fault, bool *writable,
@@ -2224,13 +2231,21 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	 * Whoever called remap_pfn_range is also going to call e.g.
 	 * unmap_mapping_range before the underlying pages are freed,
 	 * causing a call to our MMU notifier.
+	 *
+	 * Certain IO or PFNMAP mappings can be backed with valid
+	 * struct pages, but be allocated without refcounting e.g.,
+	 * tail pages of non-compound higher order allocations, which
+	 * would then underflow the refcount when the caller does the
+	 * required put_page. Don't allow those pages here.
 	 */ 
-	kvm_get_pfn(pfn);
+	if (!kvm_try_get_pfn(pfn))
+		r = -EFAULT;
 
 out:
 	pte_unmap_unlock(ptep, ptl);
 	*p_pfn = pfn;
-	return 0;
+
+	return r;
 }
 
 /*
-- 
2.32.0.93.g670b81a890-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
