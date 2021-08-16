Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C99F0C4320E
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:13:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7B263613A4
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:13:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7B263613A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3026D4B0FD;
	Sun, 15 Aug 2021 20:13:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jRj+SpWJpG1h; Sun, 15 Aug 2021 20:12:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A5964B125;
	Sun, 15 Aug 2021 20:12:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15E5E4B10A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EOSgNS4T7nKy for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Aug 2021 20:12:56 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78DCA4B101
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:55 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 o3-20020a2541030000b0290557cf3415f8so15203064yba.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 17:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=QYCRxSU6hzRxEScdPZjEavlvSGqLDqGY95R82nilknU=;
 b=nPrPgAfdfNekGbCmGN2vEq+MyvMfwzlUHjKLDCtKxgS8K2/fHTzB2r4moPCptUD6eg
 5WWLr9m6Y5nHElPsYh4I+p/6d1611nEo0QJGGr+PRdF8iTApIzLk4fA1+UHlvxMtjfkE
 PpVnPyjufYcn1I11QAs6aaPOnKNa9rRFlfIhFu3yAIATOYzl3BSkOSqNnGdLNr3nH7Hw
 YOZGu29M8HAWwFl8SS3MavUWgxnyF7GuGmy+RyZ7ihZlSHfq8BDMqyI6mlBxCj1Wjskz
 pBU4/XcfXM84/5LFENjJjdg3s+rA7FLTgrAzw7OrpUjZDQH7wU+vpqsDYzuYfjxWOkmP
 GjHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=QYCRxSU6hzRxEScdPZjEavlvSGqLDqGY95R82nilknU=;
 b=YtRsLm0I9LHMrrFUQ21L0IFMTMby8pyMPXTYvih3IAIZhHhnFYwsIvQGQfV9qcZCbX
 6SWLxSjg3DjVgfj3hk19jAqvzT3Pm9FGYrlvw27FL6qRCR5c832t49cLQKEY9MIbotcQ
 nc1EIiNNWVBni0Y8T1hCgGmumcJ/tLJGSrf0f0Gze741+b2sYCNGUY1yXdAYue19BNIS
 nwjT2OT221t14lP2gq6q1Vh0TNq+SEm8LdA0zQHaUq7cSt+SuINcKxQ3cbIQp1Y/8GX7
 De6W6keaJUjCC/tgvVNX/rer9lIgelpbZHbW520mp+R9htZWUxqYg2VctnfMU65MLn50
 YLuw==
X-Gm-Message-State: AOAM531ed9SvN55FE5NnfRPnCOa/5LyzjVOzfEyB4Ho4PmWZ7h7Cx7X8
 7hTLHCO7gAZ6bfTnjfg/0HCDAhIgSEM=
X-Google-Smtp-Source: ABdhPJyFSNI5zwQDtft85GbhMjZlrSiGF5KmrBvQv4f2CVXAK7KuRny2Z8kdgnXXItSvoMx7C3nhgmhqLYg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6902:102f:: with SMTP id
 x15mr17251492ybt.30.1629072775027; Sun, 15 Aug 2021 17:12:55 -0700 (PDT)
Date: Mon, 16 Aug 2021 00:12:40 +0000
In-Reply-To: <20210816001246.3067312-1-oupton@google.com>
Message-Id: <20210816001246.3067312-4-oupton@google.com>
Mime-Version: 1.0
References: <20210816001246.3067312-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 3/9] selftests: KVM: Fix kvm device helper ioctl assertions
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
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
Reviewed-by: Andrew Jones <drjones@redhat.com>
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
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
