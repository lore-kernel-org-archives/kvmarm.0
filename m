Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F55AC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 04:51:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFDAB49F1F;
	Thu, 17 Mar 2022 00:51:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MsASsSH0qUZR; Thu, 17 Mar 2022 00:51:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF80C49F21;
	Thu, 17 Mar 2022 00:51:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CECB49EF6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 00:51:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8alRhsQIe-LO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Mar 2022 00:51:33 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C89A49ECB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 00:51:33 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 z194-20020a627ecb000000b004f6db380a59so2870577pfc.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 21:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=orPz1N9sb4VObY0DVEB/1SEaT7xLNh+eUph/PNeO4nQ=;
 b=GHFh4+29HUaAFUYRfJ/jHI3C57so7rNewE6Lv/OXEhhyIgXMWs4LbD5tSqnSmzryUO
 BCU9Ke3HGeM/aIr7AemTs7+60ktbBDcDgmuhFV5Ss+8TuPogYofszjB+VsbF30hI35ii
 ApkgwVKn92b7jtL1cOY68PJUQSaEn+0hy3CifabQ4zAi7OQyzhubSfOkWgR+94WnoMlO
 QNxLLqAuXNY3mFjkJXnxZxfY3dO6aPZnl/wC5iShn224fcJc7GKXNU7Jepa05issM7PT
 zpq86zdo8RU15t9QLETux0eo7zaa/4+o7LYxG67/nOs0b1jEDAM+8Oqp5ZqAOyvvWlj/
 OsAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=orPz1N9sb4VObY0DVEB/1SEaT7xLNh+eUph/PNeO4nQ=;
 b=vGpptY5XIZQ+JDTNOhQt3zDAZRse2NuFyjgNZm/1NZ02ODCumYvfEC5HWUBJL0gP/u
 nCpfW6vOzM8BFfJOvufqYRp874HZ4CKBU9XsOGePYWBx7MaSulZ0HhT8oHy95V2tV6br
 JFbPhNSvPTFF0bDYKhrmWkmZUQ150NoMq3oGgAeNqNHsHZbndLEVuH64Sow5nsvCk1+p
 u+IHucHoRh0me7pKIFwRtR1quhAb20OVGhhV8u61HCKv8H09NOiR2kbuFebiF3+eZSh2
 2Jc8mmR94La7DQo5GUJ6uUbWVLGEf2hRJLfbedAZaM92jPA04pidzpKyGTVOXAIELnCD
 h3/g==
X-Gm-Message-State: AOAM5314irtRMLFiqa1lmK4gDFOhWLhHPBd9SrECk0I1SrQ3pUU3pr//
 WF5bmsOmMSPgb6vl9GewuoWfsHJjHZ9OeQ==
X-Google-Smtp-Source: ABdhPJzMNVszd9N8c+vlCGkv5DBuw+V048hOo2NeEOnk9aZLyf/NK51yu1+AdrmZzfTiIaeLEeS0t9jWO0FI8A==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:10cb:b0:4f7:942:6a22 with SMTP
 id d11-20020a056a0010cb00b004f709426a22mr3258065pfu.84.1647492692552; Wed, 16
 Mar 2022 21:51:32 -0700 (PDT)
Date: Wed, 16 Mar 2022 21:51:25 -0700
In-Reply-To: <20220317045127.124602-1-ricarkol@google.com>
Message-Id: <20220317045127.124602-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220317045127.124602-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 1/3] KVM: arm64: selftests: add timer_get_tval() lib
 function
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, pbonzini@redhat.com
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

Add timer_get_tval() into the arch timer library functions in
selftests/kvm. Bonus: change the set_tval function to get an int32_t
(tval is signed).

Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/arch_timer.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
index cb7c03de3a21..93f35a4fc1aa 100644
--- a/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
+++ b/tools/testing/selftests/kvm/include/aarch64/arch_timer.h
@@ -79,7 +79,7 @@ static inline uint64_t timer_get_cval(enum arch_timer timer)
 	return 0;
 }
 
-static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
+static inline void timer_set_tval(enum arch_timer timer, int32_t tval)
 {
 	switch (timer) {
 	case VIRTUAL:
@@ -95,6 +95,22 @@ static inline void timer_set_tval(enum arch_timer timer, uint32_t tval)
 	isb();
 }
 
+static inline int32_t timer_get_tval(enum arch_timer timer)
+{
+	isb();
+	switch (timer) {
+	case VIRTUAL:
+		return (int32_t)read_sysreg(cntv_tval_el0);
+	case PHYSICAL:
+		return (int32_t)read_sysreg(cntp_tval_el0);
+	default:
+		GUEST_ASSERT_1(0, timer);
+	}
+
+	/* We should not reach here */
+	return 0;
+}
+
 static inline void timer_set_ctl(enum arch_timer timer, uint32_t ctl)
 {
 	switch (timer) {
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
