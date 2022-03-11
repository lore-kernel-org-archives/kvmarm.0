Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB8EC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 06:02:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2481B40C10;
	Fri, 11 Mar 2022 01:02:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O3Fz3JCHRtaT; Fri, 11 Mar 2022 01:02:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2018149ED7;
	Fri, 11 Mar 2022 01:02:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C85D40C02
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 01:02:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WuIDvKZTEm+p for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 01:02:22 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 58CFF49EDF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 01:02:21 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 g2-20020a5b0242000000b0062892750241so6511519ybp.23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Mar 2022 22:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=VT9WintL5Ym+JFx3Nrk1+phRO6aH7MpQMfJGQNhWh1Y=;
 b=bFwfK4JfAVkqt1tf1xHmAoL0M7Njs7QuwGIqTRa8PLO4taBTNEwTDqtWBKaJCOyJ0P
 xpAFdOW1mJU3zu63xQ/Ce81U/7FRPYtPABCVYBFNt732Ok7zamOgqU/kxAchk2YSGZ28
 U52+TD4btpOnoXkni3xSFcbRoBaKJ7OmnSBSsHRtPi9QWtXbhRXUOYaCTvcb9dMYCkSm
 uVFv2zzrTHuKlS6VhQy/eJNk92FikqybqbOH9wlUQTTnZn64djBqiSm/4SIGlm/jLOuF
 2raR5vAQfu2pHjnyAQ/4ezZibVDeMuC9YGNK1whVK8cZMDswLjiQh4EYKJ5qamovBqLi
 e0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=VT9WintL5Ym+JFx3Nrk1+phRO6aH7MpQMfJGQNhWh1Y=;
 b=6R4yPnU2UU+93rVYejDaCdC8vfQRsC6ZSGPjqsYsMziSy1OhIkalYqtpzERH+hehSn
 eSuz7PPjxOPAKopstVfLCRmBxkiv0vTRvHMqmNe0ciS42k0Mhgyqw1NS1cHlPK1LprNW
 2JwHqtAFGGr9V2kbPZWpCrDnHYDW010HDz/Vty+fuX6fHzLqpUO7XYaKVvlqA2n5EYGg
 H21xoQa0mMpVLZtXYN/eJ7m9SVT+AN9FvxG6LBYiR6IMZHuqgu5C1tm0Gs0CjtBTrYGF
 F4XtNHADnE2kRkJ52KptHZnUZRyFiYu9R3bFV6rS5YOFtPzKfZ5xsaBh5gBKk5P2V6b6
 u6gA==
X-Gm-Message-State: AOAM5316Nr0koGMmMlfuWbA0KfWfAgWzi2AqLY5SCwW04ubwQgYstr0T
 nMuTITZEqE4rV6lD2R2iDpcN0RKxNsrqVw==
X-Google-Smtp-Source: ABdhPJyYTefolyTnht2/9c+t/yVvGC6aP5qIxASi1iZ8EPO20HO7P4WKmQotUQLTiX7IG4nmmi9g4mmhuDGEcA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:be8b:0:b0:628:bf04:f8d9 with SMTP id
 i11-20020a25be8b000000b00628bf04f8d9mr6695328ybk.472.1646978540808; Thu, 10
 Mar 2022 22:02:20 -0800 (PST)
Date: Thu, 10 Mar 2022 22:02:02 -0800
In-Reply-To: <20220311060207.2438667-1-ricarkol@google.com>
Message-Id: <20220311060207.2438667-7-ricarkol@google.com>
Mime-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 06/11] KVM: selftests: Add missing close and munmap in
 __vm_mem_region_delete
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, bgardon@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com
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

Deleting a memslot (when freeing a VM) is not closing the backing fd,
nor it's unmapping the alias mapping. Fix by adding the missing close
and munmap.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ae21564241c8..c25c79f97695 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -702,6 +702,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	sparsebit_free(&region->unused_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
+	if (region->fd >= 0) {
+	/* There's an extra map if shared memory. */
+		ret = munmap(region->mmap_alias, region->mmap_size);
+		TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
+		close(region->fd);
+	}
 
 	free(region);
 }
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
