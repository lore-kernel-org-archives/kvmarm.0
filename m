Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12609C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 06:11:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF7EC4BC20;
	Fri, 15 Jul 2022 02:11:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4EQvA+K9Qpwx; Fri, 15 Jul 2022 02:11:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A1E24BDD9;
	Fri, 15 Jul 2022 02:11:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1E034BA92
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h4QO6zX-UbU6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 02:11:24 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC2AC4BC5A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 02:11:24 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 m123-20020a253f81000000b0066ff6484995so64522yba.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 23:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=3a/b4pln92HS2a1AnnvuOdac8xZP1xDPa4SrMkGLjR0=;
 b=q4C1JK+RQNNz76sRdeaP39mUzrBswZ6WynqoMQ6MKDm8YuAxyRhzVsfEvCXanehao4
 k08Pi42tfwzVKaJ/csOoB8UeWhtI7W1QCy9bY+R8OOq/Tmlbkj6AM8hN1G8VVfDH9g6J
 PjQhLyB7sX4Nw2ShhZyWeWNS6Ke+I9KTVSozUpiBpss5tuOGiAPO+ZobMPwBDxLrFxE7
 zigNiQz1lT/DdliNuWo2n7LVM1Hm0B6jAbBGylJ1zabLyv9YuXpFLMj1nc5SWdqRFE0C
 kUmZ3mPGCWamcUSLxEpDiVl7ylw4U2x4CdiGJoYyQ38S/H18B/rPV+u0xLmXPa5tDHtV
 ZGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=3a/b4pln92HS2a1AnnvuOdac8xZP1xDPa4SrMkGLjR0=;
 b=cMPEPjnQ8moMZDFcJT7pFIhqyUAUI42z8KJgUHbzf//8lU2Zi8TBAKuRi7OgzpSuXO
 xDA2zBdPzxrtFO9g9TpeJNPWTX5N2c2ZkPL89MfLNBIObDxI+zBFO80nFgZH96Y3LQ0Q
 8bqLxKEP9k8gQGPgCE3DZl8zCacczAjSE0yKdwD/zH0UjFOboUl1vHfiVbvelDaQD5Jf
 PVSMhxahAZw3djAR1Bsqs88hAfBydPMEid7e/cUzJDvOUILjngkRjQHTGRfX7VxWP2Gn
 Pir3t1848k/NgaUsACuBEZeCBlb2DQB1ql9GCRKSTlEEQOHBch6DBeNfUI45tW+kQou8
 ZLfA==
X-Gm-Message-State: AJIora8YkYJu14Zoo+GlE+LUhSqJ+t+Jw0ov3uLEqhDaAKYcSM4GFxQ7
 u9K9gzv/WeCRftAT7E5AyX20ZpouAXg7wpKjbg==
X-Google-Smtp-Source: AGRyM1sPOtLVKeDmWy879CSPJRglmjW5aqZxQkCzJXmhwSfCnvkLDVoRYFusSgov/9niuUM5cImhZ1ZTKOCqCOKMnQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f010:455b:62ce:19e])
 (user=kaleshsingh job=sendgmr) by 2002:a81:17ca:0:b0:31c:9a75:1f2b with SMTP
 id 193-20020a8117ca000000b0031c9a751f2bmr14665610ywx.83.1657865484575; Thu,
 14 Jul 2022 23:11:24 -0700 (PDT)
Date: Thu, 14 Jul 2022 23:10:17 -0700
In-Reply-To: <20220715061027.1612149-1-kaleshsingh@google.com>
Message-Id: <20220715061027.1612149-9-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v4 08/18] KVM: arm64: Add PROTECTED_NVHE_STACKTRACE Kconfig
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com
Cc: wangkefeng.wang@huawei.com, elver@google.com, catalin.marinas@arm.com,
 ast@kernel.org, vincenzo.frascino@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, android-mm@google.com, andreyknvl@gmail.com,
 kernel-team@android.com, drjones@redhat.com,
 linux-arm-kernel@lists.infradead.org, russell.king@oracle.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

This can be used to disable stacktrace for the protected KVM
nVHE hypervisor, in order to save on the associated memory usage.

This option is disabled by default, since protected KVM is not widely
used on platforms other than Android currently.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 arch/arm64/kvm/Kconfig | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 8a5fbbf084df..1edab6f8a3b8 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -46,6 +46,21 @@ menuconfig KVM
 
 	  If unsure, say N.
 
+config PROTECTED_NVHE_STACKTRACE
+	bool "Protected KVM hypervisor stacktraces"
+	depends on KVM
+	default n
+	help
+	  Say Y here to enable pKVM hypervisor stacktraces on hyp_panic()
+
+	  If you are not using protected nVHE (pKVM), say N.
+
+	  If using protected nVHE mode, but cannot afford the associated
+	  memory cost (less than 0.75 page per CPU) of pKVM stacktraces,
+	  say N.
+
+	  If unsure, say N.
+
 config NVHE_EL2_DEBUG
 	bool "Debug mode for non-VHE EL2 object"
 	depends on KVM
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
