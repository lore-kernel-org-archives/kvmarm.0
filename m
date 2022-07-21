Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 610D0C43334
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 05:57:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BA2F4DA5C;
	Thu, 21 Jul 2022 01:57:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fleSCz0SZGp1; Thu, 21 Jul 2022 01:57:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFA424D6F0;
	Thu, 21 Jul 2022 01:57:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E97154DA57
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:57:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CKnyp3H7jTUR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 01:57:53 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BCF2E4DA37
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 01:57:53 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-31e559f6840so6706657b3.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 22:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=innDUxJqwACKwxXV5MqFrMuXYhJfRcgn5/z66I4MfpY=;
 b=j93Q+9vCOMIlrd8JUKeoSlEgKUhZAN3jSK2XP3BhOFfL5yOpWBENrI60zOwAPbO91x
 N6XQSWNcmzIhWj8QkGWW07DP7EeyA/mqAvAChzhCELfCbJeCF8pigRfOnmDEu/LFP7Wc
 gU926Sr383UjK2SWUbwqn7Qb7r0pBoMdXlpP9SU6nVu+aodOUXYuu8NsDoDaW2y+puqr
 s0UynAbnY7+79mAByXBhH4o/jDbNBk4CrLATYNetHf6lfi1CJ5b3j0Nelut1331YvmyO
 iMtm0q/sWDjIGFky7wv3hVEEFfWt3aspQ2gQmPPLX6M4E8bxwwznpbjEnbAXpy8kgXog
 rVIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=innDUxJqwACKwxXV5MqFrMuXYhJfRcgn5/z66I4MfpY=;
 b=XydhRZvWQoxs8Wral9VWlxLscPef+3vewrjAljTLM4GG12iUuBpWPlB1cmtmSyMx6+
 kVbCvAEn7I99uGRyF9UTQxQNJIcWrmGXdoW7MwvPT5h6w/fxZCZRj3GB/rTUVT6F4wHJ
 he34XvV04DWSI+DlCmjaxU6+caFj9jWsjfvo3ZpPou0r3S+kFTN/kuxufxtzuaq+N0C9
 fwUQL5Py4oHZEutpi03Fg1CFBWJ8QxRIlzc22mLDUb/xihRgzbyIAW8d1OceALwedT3Q
 jW1bXyuhM/AuhLow9GKiDH3YadOylnAgPRKcgBpw2AHARn3Vt2gvgEzARiPzaHQvS86C
 gG8g==
X-Gm-Message-State: AJIora+7HSRBujSvnRjpf29cQYu0ut2bhqpav5UkcMGhF0YMtsB8cn2v
 vctlBSrp6GorQOFRxRgE9VP0A4J11uRFpgpd9Q==
X-Google-Smtp-Source: AGRyM1sfor76YmofP6IuFGP7/vlKV7Yykd8ZozDRP+vyvW6PfvuolIS6g+LFmS4sH9UnTfXd9e/iHAUsYmoQeAReYg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:5a87:b61e:76b5:d1e0])
 (user=kaleshsingh job=sendgmr) by 2002:a81:1a52:0:b0:31e:8774:6e9b with SMTP
 id a79-20020a811a52000000b0031e87746e9bmr369844ywa.78.1658383073351; Wed, 20
 Jul 2022 22:57:53 -0700 (PDT)
Date: Wed, 20 Jul 2022 22:57:19 -0700
In-Reply-To: <20220721055728.718573-1-kaleshsingh@google.com>
Message-Id: <20220721055728.718573-9-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v5 08/17] KVM: arm64: Add PROTECTED_NVHE_STACKTRACE Kconfig
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com, tabba@google.com
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, elver@google.com,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 android-mm@google.com, kernel-team@android.com, drjones@redhat.com,
 ast@kernel.org, linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
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

Changes in v5:
  - Make PROTECTED_NVHE_STACKTRACE depend on NVHE_EL2_DEBUG, per Marc

 arch/arm64/kvm/Kconfig | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 8a5fbbf084df..09c995869916 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -46,6 +46,21 @@ menuconfig KVM
 
 	  If unsure, say N.
 
+config PROTECTED_NVHE_STACKTRACE
+	bool "Protected KVM hypervisor stacktraces"
+	depends on NVHE_EL2_DEBUG
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
