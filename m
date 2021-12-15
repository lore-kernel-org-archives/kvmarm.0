Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E552C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 15 Dec 2021 16:12:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED6134B192;
	Wed, 15 Dec 2021 11:12:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SwV+1-lA-9+7; Wed, 15 Dec 2021 11:12:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E208B4B1DB;
	Wed, 15 Dec 2021 11:12:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C5E14B1CF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 11:12:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GzjaLzUjXg9n for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Dec 2021 11:12:41 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8C854B1E1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 11:12:40 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id
 f3-20020a5d50c3000000b00183ce1379feso6041426wrt.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 08:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=fvU+rTfQGDk/gMHRwZZK2xJ4BmIbr82Ki0zdjrAMtH4=;
 b=AxcI0U50LP9UI1+U6aOTK66BaZ96AYCpHcns6c3HEWlsvGT1zuytPudhyifTcoMOiq
 DPjRsJ8EPAtn3WqwwehTKtW49jhvWcmbWpMjuhj4lChFaY+4eHGWGF+msFaGFQDcpey5
 Owg7nJu4brk8wWyQ/BEFnhUQ90S3+rhrmvsZKXEpRU+8ZMgJwh95rH+r4vl2LygP2nhg
 m6201P1jNhZDkNAPtqCCFxk+w1/E3EDmIKqw397DawYopi8bxuv0nQi7GzuYgxrsQBHL
 zyS7w8OBi4L761ZlPheYjDM/ecN8KlHjek8Q1doEoaGdBdB1ImjjD3szz4rf60dtzjbX
 X0fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=fvU+rTfQGDk/gMHRwZZK2xJ4BmIbr82Ki0zdjrAMtH4=;
 b=kQHnmGwLl7AXLhTlvr7xGnB6xiaNqGD7hPN+InkLzPSavPj0f6eBgGRKrX3d+8+09z
 /BJiMcD82KdxIq84ohKLuwbqT7TzbrkbYRtyJVzztPyHbLZQ94D0OQQ1ueI1yd/8yWei
 xEcHkFM02RePPdA5fBMyCwP+w0I4sXhIQng+YTjc5gJSTx9WeDjOXHJNsQFIRGkTXdij
 U4p3+VLNcPawHV6pXTnh830e/Bz4KgY4Q6ugE+UUiWrc86TW9n1SqQA7hc+DappSPzbs
 XsqIP+Vz/xFTFWA1o0PiVWKRJ4bBPqMRsP53cp82WOebnHYcLCvuu4wFa6NnqvQ+C0g3
 yizA==
X-Gm-Message-State: AOAM531tPtiH7Z53bxIrkJCdIlj6mBPXuWh8A/G1Pzk5FFqf9p1zUiIp
 aLqA/6tbhJrPzb0iVi0DxaJDtkvJ5V8Y
X-Google-Smtp-Source: ABdhPJz9PeDSGMeEeP45N6lCRrahlctgvXx61iiSgCOtuaYTTEOCxJ3rRff8XyoyZ6cRaw8FkQLTvH91J/YB
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:fc03:4f5b:4e9b:3ec1])
 (user=qperret job=sendgmr) by 2002:a05:600c:4104:: with SMTP id
 j4mr535325wmi.178.1639584759689; Wed, 15 Dec 2021 08:12:39 -0800 (PST)
Date: Wed, 15 Dec 2021 16:12:18 +0000
In-Reply-To: <20211215161232.1480836-1-qperret@google.com>
Message-Id: <20211215161232.1480836-2-qperret@google.com>
Mime-Version: 1.0
References: <20211215161232.1480836-1-qperret@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v4 01/14] KVM: arm64: Provide {get, put}_page() stubs for early
 hyp allocator
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: qwandor@google.com, linux-kernel@vger.kernel.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Acked-by: Will Deacon <will@kernel.org>
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
2.34.1.173.g76aa8bc2d0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
