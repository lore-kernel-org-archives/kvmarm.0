Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B97CAC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 20 Jan 2022 17:39:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2141749EB3;
	Thu, 20 Jan 2022 12:39:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HYipvuU5Lg9A; Thu, 20 Jan 2022 12:39:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A35C49E43;
	Thu, 20 Jan 2022 12:39:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52C8049E3C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Jan 2022 12:39:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8cdZH3+NcWdl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Jan 2022 12:39:11 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2952E49E37
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Jan 2022 12:39:11 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 v21-20020a17090331d500b0014a5895b639so1143557ple.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Jan 2022 09:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=y8xiYhpGFxFKO0m5kKEQAv7sJcYQ8XNaG5VWu+Ph1Do=;
 b=cxVEz/H8VmQKRFKyBX9M5zJfWSbMQF/9OYmwT3emggmM5vHdPkxOzmFJ/7E1fw9s4I
 skfzh+KiXt6JilmOaf4TRbQ8gThLlMirAnJ20zcwe1v983odsxUGySnflgtdBXa0rj/e
 yX1+pk2cj7MPKaB/+3a4I6iZRZU5UYbh5yZSyzx/MQOHNH6RwJEri4iEiY/YIXCeye/+
 785WAZWGYiljM+NKeMh6QaQurHDmcwaUuuzokGrQauOsmdOJxF7wylWixNDcZZwrPsdg
 4bmg1SAJX8PwQ8Sp6mkyEBlqZ2eYlP0U4isT0ToH/trq3Rpi9ieUsOWXS5iT4lXdzjk7
 qmPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=y8xiYhpGFxFKO0m5kKEQAv7sJcYQ8XNaG5VWu+Ph1Do=;
 b=0bYDxyfXY45ZhNPLjLYefIbu1PR3i4eS8t1iBm3ETCkW6jn5RbZ1VUkg7LeAsdEl+Q
 P7zLvetYIBFAnZHXcMUxTKHV9BxxZNnqOmJzYFNKS2WgapH3xkZF0x+wfAF+awuddwEp
 ++/a5LGaer/HhMVlsKHsXxE7i8qHoU8jYKHJsmfr7wmj1O3RzxF1zjfFBIp7CRX1E1g6
 LtAhri7/GLLwdbg9xcTE9RHbiZVM7ytSso9MvH32KQ40TMvosDkS++1GnGwTvzV9BdZl
 gXyfmsOn/n2PaqI4XZmKvH5IyYltlMdWOtwLobr6CdOB/sQVjmqBSZN5dZ4I08n3Ga+4
 iSIw==
X-Gm-Message-State: AOAM532W0CTVmuDzrmiBa9mEX9n/SWHfnbKF3UAblnvx2aGy7Xn9s56v
 0dfjWV08FB0h5dB8dolfgdPIGb44IW1CEw==
X-Google-Smtp-Source: ABdhPJzC9BYvVT5ASp9sIiU7EiVvDcMTqU9YuxgO9saDyOy0sn9U/9+7qbwuVqwSHnzd7o0FcQeLF6JwoZs67A==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:33cb:: with SMTP id
 lk11mr11871701pjb.246.1642700350242; Thu, 20 Jan 2022 09:39:10 -0800 (PST)
Date: Thu, 20 Jan 2022 09:39:04 -0800
In-Reply-To: <20220120173905.1047015-1-ricarkol@google.com>
Message-Id: <20220120173905.1047015-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220120173905.1047015-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 1/2] kvm: selftests: aarch64: fix assert in gicv3_access_reg
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
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

The val argument in gicv3_access_reg can have any value when used for a
read, not necessarily 0.  Fix the assert by checking val only for
writes.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
index 00f613c0583c..e4945fe66620 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
@@ -159,7 +159,7 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
 	uint32_t cpu_or_dist;
 
 	GUEST_ASSERT(bits_per_field <= reg_bits);
-	GUEST_ASSERT(*val < (1U << bits_per_field));
+	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
 	/* Some registers like IROUTER are 64 bit long. Those are currently not
 	 * supported by readl nor writel, so just asserting here until then.
 	 */
-- 
2.35.0.rc0.227.g00780c9af4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
