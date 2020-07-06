Return-Path: <SRS0=KDMR=AR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 425A0C433DF
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 09:53:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B9484206F5
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 09:53:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="CvUDgUnC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9484206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E4F34B3F8;
	Mon,  6 Jul 2020 05:53:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XwdBF46Ce8t3; Mon,  6 Jul 2020 05:53:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C6DB4B3BF;
	Mon,  6 Jul 2020 05:53:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC7804B3B5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 05:53:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9fYq-23KR7AI for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2020 05:53:13 -0400 (EDT)
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com
 [209.85.208.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ACFC74B3AC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 05:53:13 -0400 (EDT)
Received: by mail-ed1-f73.google.com with SMTP id k25so11222286edx.23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jul 2020 02:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=GMbTkIlriWmgCKnERLHBzG2c3YxOxHPYO20AK09Pd34=;
 b=CvUDgUnC7SIyRVqPcczQ/xYLrS+lIFy84DT1V953Cs83DkxkQHf7OkO96L8FF58tZ5
 3Q/9lP47uVtNu90rnXKqHHq5HJXo+fJtLTJS9V8yTJwQpe2ICcBb1Wrq/wjMMcX9wXkE
 vCtlgMVR0d3y02690DIif7sCaPxwmPpr7b/8/Oa0tTl4tO62KDUmqkRg9fSPLGO1P8it
 GGjg2ERXzF8YOLbFfhXpqJ8QKZABFfEzgpOL5iSBI2poXXnnUdiXN+lDkAvIUlrD97DH
 zPIUZYAxY48/VM/pcF7KPKZ2yQxqV9Ox+xYXYDElUcCjTdcdK2HocABFpxzxQ24Igsem
 WxZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=GMbTkIlriWmgCKnERLHBzG2c3YxOxHPYO20AK09Pd34=;
 b=EuS7Xnp4yV1pWnwBtfu5Mb5nVowXUjiRjcVbEPb1S1KLI25GxAm7YEUwuyeyKXbjvU
 nfinZ/Vt7+j/wliFW5ViMujRyC15nLz4/gnE2ux6TqJp15a38C5t76ihh+NRQrCBFFs9
 nEOy6KMETqTQcAtfhUslil0cIQ4YwqrKMC6dTbTbmbhjjRShyUtcSXgy+tA2/cFf21Ke
 VbVs44u08ZvIN/Yp938GTJruF/VKGbNhTY5yTzr+KQJPhkvI/AcL0KV0AsPJcxls7Z74
 IbeHcIvAB0FpYlgLBQB9qFdFFb/6B2lb3VciZsIQc09mWpKGA2+bArywFRDD5ipDN3G8
 R3aA==
X-Gm-Message-State: AOAM532YF6HUEDcSsXJk4KFCUBLbdl+WkdOlhLp2MVVlV0Re6jUS1Gk/
 ZMg1CaM8UcUiyZge4NikvRNrJgqFtZ7RjoYB4bc1FDvsim2rJyt9LHSE4sqm3gAFk7wpsKLL4Pa
 YlK6T6vLTzPWqEtn9RJR/tE7wPajIZxPszqoaut86OTajQ9+eTd3J10S+krkXeRMOv4uuEw==
X-Google-Smtp-Source: ABdhPJxVw6cZatP6MjfwwfFaNdeO1eMTinEBCRRbAigqjFWdD+4R5e7Bnl/m4DpPyMDOLbIBKuEJt5SrpSo=
X-Received: by 2002:a05:6402:94f:: with SMTP id
 h15mr55736617edz.313.1594029192258; 
 Mon, 06 Jul 2020 02:53:12 -0700 (PDT)
Date: Mon,  6 Jul 2020 10:52:59 +0100
Message-Id: <20200706095259.1338221-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH] arm64: kvm: Stop clobbering x0 for HVC_SOFT_RESTART
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com
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

HVC_SOFT_RESTART is given values for x0-2 that it should installed
before exiting to the new address so should not set x0 to stub HVC
success or failure code.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp-init.S | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 6e6ed5581eed..e76c0e89d48e 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -136,11 +136,15 @@ SYM_CODE_START(__kvm_handle_stub_hvc)
 
 1:	cmp	x0, #HVC_RESET_VECTORS
 	b.ne	1f
-reset:
+
 	/*
-	 * Reset kvm back to the hyp stub. Do not clobber x0-x4 in
-	 * case we coming via HVC_SOFT_RESTART.
+	 * Set the HVC_RESET_VECTORS return code before entering the common
+	 * path so that we do not clobber x0-x2 in case we are coming via
+	 * HVC_SOFT_RESTART.
 	 */
+	mov	x0, xzr
+reset:
+	/* Reset kvm back to the hyp stub. */
 	mrs	x5, sctlr_el2
 	mov_q	x6, SCTLR_ELx_FLAGS
 	bic	x5, x5, x6		// Clear SCTL_M and etc
@@ -151,7 +155,6 @@ reset:
 	/* Install stub vectors */
 	adr_l	x5, __hyp_stub_vectors
 	msr	vbar_el2, x5
-	mov	x0, xzr
 	eret
 
 1:	/* Bad stub call */
-- 
2.27.0.383.g050319c2ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
