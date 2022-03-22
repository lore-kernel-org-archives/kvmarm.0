Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8040DC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 17:23:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 317AC4076C;
	Tue, 22 Mar 2022 13:23:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xn9jmRGbdhxF; Tue, 22 Mar 2022 13:23:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2809C49F0A;
	Tue, 22 Mar 2022 13:23:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 753D549F18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 13:23:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id evskbqOTd5uM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 13:23:28 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1BA9040B8D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 13:23:27 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 mw8-20020a17090b4d0800b001c717bb058eso2513746pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 10:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=A2OVfh4jna2fjjys5QzYhnEURgOUCehkINqKA/XnhEE=;
 b=KK7kUh3po8iC/Gm8apsdZvHGwC1JoIeebfUmsd/3SXEXyatzCijqZAmSwSo6wwadQH
 JUKCVydqn3ltAAGTyC80LbVyLW1FzvlGwyIlxEf6cCtgoTXMZIWqAvGZEt/PWFG05BDV
 6N59RPQ2Q4dFqq6szU3GV7VdmcqvLQP/2TW+f8JXDd6D4U4H2kLMbutw3kgNL6jTyUTf
 4UOiHjqC8Qo/CiH3tTGaxh4UcmX6VbQ4gf9SS23L0BRckdawkCrzGuk2Xfy5FTsg9Zz/
 v4a5McWHyEyw3XQFNDidhoJ4MG36QM+fzberYvyLcayIyCdHWe51dJ7Iu1XuF3EpPI9I
 8Hgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=A2OVfh4jna2fjjys5QzYhnEURgOUCehkINqKA/XnhEE=;
 b=ZzQcioknrA310YDUe1LCY6nyznWKI8gvuq2sbzeAVjvQ4PKRCrXMT0M/4eKlHzVk8C
 D2rGQYGZHhrCgENfBzqXhEQVu4hDvkmhA3dIe6DAJOEyst/xpUDnVmi4uZCJQQ5DyYsa
 xyIajxORWGJTo9IkI0w8PcMb9nIcpb2mOOiSbTlZ/AfJxpEi1tQQiF7g/rBR+y9MksaL
 f/56V3Byn7+GLp623PjgaY0LEhNTw3lFoUnO0CfTjb9GLIfEJzuD+JfVfPZk+hooihmL
 kFrNj8DsDI5p/pMadtyKJMSLH/fLJosKTfzrjPTAfCcQ+eR9xLvuDThIKegbJ6LNlq70
 QbUA==
X-Gm-Message-State: AOAM532tdk7rEDYv/mJSDL2Y2SS8x8hK3W0s2KyLvYQqRkMBXUvtJgKI
 MIIDAl3kiA2ddZIU54mTkmMwfAtPiDMdHg==
X-Google-Smtp-Source: ABdhPJxPCzEWdiZmf1k/k9aSVDd11Orxgxmcb/v81+3NychWWnJaU5A7hAIzcW0g2gazih+FM+9T5Lwo3MaotA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:e81:b0:1c6:5a9c:5afa with SMTP id
 fv1-20020a17090b0e8100b001c65a9c5afamr102565pjb.1.1647969805974; Tue, 22 Mar
 2022 10:23:25 -0700 (PDT)
Date: Tue, 22 Mar 2022 10:23:17 -0700
In-Reply-To: <20220322172319.2943101-1-ricarkol@google.com>
Message-Id: <20220322172319.2943101-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220322172319.2943101-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v3 2/4] KVM: selftests: add is_cpu_online() utility function
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

Add is_cpu_online() utility function: a wrapper for
"/sys/devices/system/cpu/cpu%d/online".

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h |  2 ++
 tools/testing/selftests/kvm/lib/test_util.c     | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 99e0dcdc923f..14084dc4e152 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -143,4 +143,6 @@ static inline void *align_ptr_up(void *x, size_t size)
 	return (void *)align_up((unsigned long)x, size);
 }
 
+bool is_cpu_online(int pcpu);
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 6d23878bbfe1..81950e6b6d10 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -334,3 +334,19 @@ long get_run_delay(void)
 
 	return val[1];
 }
+
+bool is_cpu_online(int pcpu)
+{
+	char p[128];
+	FILE *fp;
+	int ret;
+
+	snprintf(p, sizeof(p), "/sys/devices/system/cpu/cpu%d/online", pcpu);
+	fp = fopen(p, "r");
+	if (!fp)
+		return false;
+	assert(fscanf(fp, "%d ", &ret) == 1);
+	fclose(fp);
+
+	return !!ret;
+}
-- 
2.35.1.894.gb6a874cedc-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
