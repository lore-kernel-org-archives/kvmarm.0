Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68F0CC432BE
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 00:10:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 16EF661042
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 00:10:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 16EF661042
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1DB84B0A3;
	Wed, 28 Jul 2021 20:10:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rDYpOJ6QR739; Wed, 28 Jul 2021 20:10:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E6DC4B0CC;
	Wed, 28 Jul 2021 20:10:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04EE14B0A1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 20:10:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tGm3U4e-yH8s for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jul 2021 20:10:28 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F7DC4B09C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 20:10:28 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b9-20020a5b07890000b0290558245b7eabso4903842ybq.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 17:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=gwBBXRuZJgGMnUfzRY6x/WPrbKiPq9hqFSq9KLAopho=;
 b=GRCbwCl8PRjXYJurNPHDvXlZjCsUWllU9vvI6WATIb0mSUd/TdccQava+A9dQ45Pl8
 PuoLb2SoHlHEms7T5ReImxkTSR08wqqKtvlC13zh7MDjRq9X6YhXEPgbQZ38xz1dpMog
 KTvCTQMpCoB/dJGQ3mkUHgS/iP1Gxc6L1jKRRwtoKT/ediSCO2xRalEfAk3eOG6uRDPC
 DIhKENGw6tKBpiJ62jTRce8kvWq5b4hK5ogpZkd1eeYm0gmRNJX5Jng+exV8KIHMrtIq
 kFupb+p4BmcY4OCiTBJcYZFe2sREJ2xGpsidyU88ooBd0/X4kYtBIlKnr08IO+RzUI2j
 0hMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=gwBBXRuZJgGMnUfzRY6x/WPrbKiPq9hqFSq9KLAopho=;
 b=R2Ar2d2VRaTDkAsiD6gffE7yPzMsL7Wnh8rOp01sNvY/ySzA9RGVgvpHa8Ngk79eav
 ywV7xQ3wH+A05Y7rRRyd+JRLvhMOvRGQmwTtBeWq3GrGgbnN6lNjDmf8UrGT/sGj2BkT
 v0TCK/OLwejaK0RobPTn6zgdx4uFPH7DSbLRsqt172c2ga3XRlEh46/aJHqTkTgaM3uY
 yHS+zfsuZYWKFAAC3ymukP1dLLqdNBUeReEguxX5hszyAAcGtsqgFUfVBJNI5tuPyA0Y
 SjDEo3COzuhC3i0wuomPCFseeAPkhGw9eHs9X9XRDnS7JCnV83oXPRPupGMjZU6F/s6K
 dFHQ==
X-Gm-Message-State: AOAM531+yA4jFjR82csoalw1CB37r4CFLuDztPL3k7h5lO17dnxtj3Ac
 ndu7+C2defwE6Q07jipWJ60NgTFshK0=
X-Google-Smtp-Source: ABdhPJyIry5dp830kQgdFAcw+/eO64Lwl1/0Oz/NR1ZKHIXmlq6VO06PUalR1WRBDiNnr+E7NteCfG8rS08=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:ba41:: with SMTP id
 z1mr3010352ybj.169.1627517427848; 
 Wed, 28 Jul 2021 17:10:27 -0700 (PDT)
Date: Thu, 29 Jul 2021 00:10:05 +0000
In-Reply-To: <20210729001012.70394-1-oupton@google.com>
Message-Id: <20210729001012.70394-7-oupton@google.com>
Mime-Version: 1.0
References: <20210729001012.70394-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v4 06/13] selftests: KVM: Fix kvm device helper ioctl
 assertions
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

The KVM_CREATE_DEVICE and KVM_{GET,SET}_DEVICE_ATTR ioctls are defined
to return a value of zero on success. As such, tighten the assertions in
the helper functions to only pass if the return code is zero.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 10a8ed691c66..0ffc2d39c80d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1984,7 +1984,7 @@ int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr)
 {
 	int ret = _kvm_device_check_attr(dev_fd, group, attr);
 
-	TEST_ASSERT(ret >= 0, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
+	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
 	return ret;
 }
 
@@ -2008,7 +2008,7 @@ int kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test)
 	ret = _kvm_create_device(vm, type, test, &fd);
 
 	if (!test) {
-		TEST_ASSERT(ret >= 0,
+		TEST_ASSERT(!ret,
 			    "KVM_CREATE_DEVICE IOCTL failed, rc: %i errno: %i", ret, errno);
 		return fd;
 	}
@@ -2036,7 +2036,7 @@ int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 {
 	int ret = _kvm_device_access(dev_fd, group, attr, val, write);
 
-	TEST_ASSERT(ret >= 0, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
+	TEST_ASSERT(!ret, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
 	return ret;
 }
 
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
