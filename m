Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC1BC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  7 Mar 2022 14:43:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7506749B08;
	Mon,  7 Mar 2022 09:43:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vlMHfMFOao96; Mon,  7 Mar 2022 09:43:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D9814B223;
	Mon,  7 Mar 2022 09:43:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F28949B08
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 09:43:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D6py1U2OcgEQ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Mar 2022 09:43:33 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 556134B201
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 09:43:33 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 l13-20020a7bcf0d000000b0038982c6bf8fso4792714wmg.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Mar 2022 06:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=8vfdxo7n+Gbh4TlZhji4JKiUvRF4h9GSw6jba/4cxHI=;
 b=O5JID2lGDVqJ0hq37t1pp/7me2ZaJQCqPi1Od9E+QVst7wj+smEABDuPqGndDdTtgK
 WKZ7dDwQoM31mOd7EKHoI4SXQv3xAtfoiNwvnOx567z2jOHPXY0V6ZBfAm/lwRVN+ane
 EDiirXPlDTtPK/JqIKAdjd11DKAtfYwdh6nxL3z3EG6nvj3OX5J4TdKwAT6z/uLsFrTL
 ib2ovM2wSyaa7Fj9IZU0DSHSGnuFn+VmAAEmsS8zdpDNcjKPk2KWx4i1cLBUhQwA0j7x
 T9hSoIvK4nFCOPLDXsMRyISbTiyRnhyJXHHLZtNeYgksPJRwXMZVBQDtc8kE4pyKwvmI
 geWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=8vfdxo7n+Gbh4TlZhji4JKiUvRF4h9GSw6jba/4cxHI=;
 b=Hg+SVc1+wzyAAH3fOiErRkbdu8gpY+rlo8IUI/d+mDJz60w9ypS2TrukYeoyDyZvSM
 UMsmDI4qOoO0Bq9VHU12gHnMIg+jXwrazEWWyL3XJRzHjV2Dy2tf6bl0k342r3SZfo+l
 YFvonQ0sUdLkOYBgUKdViUGmm0HcZ205zCs+srjUdQ25iDZSaUyEStD3cKyKJ+3jJBE8
 JsKvl9ESRlxGoI7LCNGf8+/sc3mIJ8GPDWKRFImGsDZjxiOs0tweIeaovmqL/T7jcCqa
 7RtB39AWIR6514O6KdtcpAnTRHNNfb1v1rqq0GME3ALIvaA0DKnTUvpulbN/DTik/cHf
 SVsw==
X-Gm-Message-State: AOAM531TOfHMs1k3bZvEJq3Qa01YkmN754ZrSt70qNlNG6b3JV1gSWp7
 64v5Fk9olxxYfaPRXfXqUI8nAPANNUiVIYbfLR0=
X-Google-Smtp-Source: ABdhPJzIqsNDChPGDDa8s233hYyYPgCOXIktSSMRNy/1R7UCheDRSRvylPuiXhyQ0e34swtPtAiVK1YpY4nFvVLrTLg=
X-Received: from sene.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:27c4])
 (user=sebastianene job=sendgmr) by
 2002:a1c:e908:0:b0:37c:3d08:e0d3 with SMTP
 id q8-20020a1ce908000000b0037c3d08e0d3mr9308531wmc.97.1646664212579; Mon, 07
 Mar 2022 06:43:32 -0800 (PST)
Date: Mon,  7 Mar 2022 14:42:44 +0000
In-Reply-To: <20220307144243.2039409-1-sebastianene@google.com>
Message-Id: <20220307144243.2039409-4-sebastianene@google.com>
Mime-Version: 1.0
References: <20220307144243.2039409-1-sebastianene@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH kvmtool v8 3/3] Add --no-pvtime command line argument
From: Sebastian Ene <sebastianene@google.com>
To: kvm@vger.kernel.org
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

The command line argument disables the stolen time functionality when is
specified.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 builtin-run.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/builtin-run.c b/builtin-run.c
index 9a1a0c1..7c8be9d 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -128,6 +128,8 @@ void kvm_run_set_wrapper_sandbox(void)
 			" rootfs"),					\
 	OPT_STRING('\0', "hugetlbfs", &(cfg)->hugetlbfs_path, "path",	\
 			"Hugetlbfs path"),				\
+	OPT_BOOLEAN('\0', "no-pvtime", &(cfg)->no_pvtime, "Disable"	\
+			" stolen time"),				\
 									\
 	OPT_GROUP("Kernel options:"),					\
 	OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",	\
-- 
2.35.1.616.g0bdcbb4464-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
