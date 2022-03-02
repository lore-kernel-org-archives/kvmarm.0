Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779E6C4332F
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 17:21:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EEF249EBA;
	Wed,  2 Mar 2022 12:21:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id izR6wP754Xrf; Wed,  2 Mar 2022 12:21:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04BA149EF6;
	Wed,  2 Mar 2022 12:21:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD17F49EED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 12:21:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k4zSXp11wGF0 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 12:21:50 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E50740D26
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 12:21:50 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 p5-20020a17090a748500b001bee6752974so1525010pjk.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Mar 2022 09:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=oSxJZdPqBmTb0v45xyGXjRQvnkzVXUBcU5Q8keBTlIw=;
 b=Y7ps/54eC/0QA3ldUb8EKnBlECJIsXK8QHT8pMevwQ09ueCFk5C9ccYoNSdU7XcEew
 ViEDOXicHKjz+H4fnuKYAYB78gRMqWxFOtAto/ppQLmGFpu4XhILCDGVc5SuzrLkAobn
 w/WvGLrpiNSD58tnMGaAOxfGOmXmKFCPQ5IquJoJumjqCfx67Z/YUefIBIC6D94hTYkr
 cXER52zKa/CTCzdAW8nPcOA3UdS3lBBwQO9WXJhzAlExe2SveVMVR4NGFFLCKLKuRtlE
 +Loiw2cJANf+b16FYRteXLwsNVj0FcWB0PxweSdbtCC15DhrnKRk+xzt6xHXoeDkRNbC
 wfJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=oSxJZdPqBmTb0v45xyGXjRQvnkzVXUBcU5Q8keBTlIw=;
 b=2v4U9T1EqhcUpc4lv+Ngi0VteXBwB/xEzX+XrpMBgACu/BtZ3eU4RjI0xb2Dn5ZGPR
 R798K3vmG68NlKWxC76WeNjmHJUmrfsIZpbgAcZloYbl6ahf/OoQpyXqMfH4tzmR2Cvr
 wTP4Qwi750dQDBUxr5oU02XKCWCHRfUhE3WZv/fSbxE7nDYQX4OIpH/UpH3bRQT9pI/3
 HeHoL5QV1echRe4VSgTsIKOKeTAXeui/HfeKyspGMiWq1U24Pi3BZ76NasxC+20cstzA
 YaZgzifMILxchVfmJhhmp7lDKVa14tGzWbBty296aXDAWUcG+vRSHSrSfUZj7uMWGWtc
 hs/A==
X-Gm-Message-State: AOAM531oREDAbcpnJZHh58ZJvllivoTwfZj4/r0wsMfyVW6GnAjkn3af
 zETjxxBbhyeAxrzFXoYX6ov5Fz+bYjw4eQ==
X-Google-Smtp-Source: ABdhPJxa86h9ycOOhd+6pnQ3kRI6Am1texhgSG+wImUc8MVyXQMzuu0pRRJkDxa4oX0fEsBIFeLKVjtQvn5H5Q==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:9292:b0:1bd:1bf0:30e6 with SMTP
 id n18-20020a17090a929200b001bd1bf030e6mr831494pjo.73.1646241709583; Wed, 02
 Mar 2022 09:21:49 -0800 (PST)
Date: Wed,  2 Mar 2022 09:21:42 -0800
In-Reply-To: <20220302172144.2734258-1-ricarkol@google.com>
Message-Id: <20220302172144.2734258-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220302172144.2734258-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH 1/3] KVM: arm64: selftests: add timer_get_tval() lib function
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
2.35.1.574.g5d30c73bfb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
