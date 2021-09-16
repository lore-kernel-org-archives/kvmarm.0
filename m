Return-Path: <SRS0=sbHD=OG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E223BC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:16:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 93AE261246
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:16:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 93AE261246
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 463414B174;
	Thu, 16 Sep 2021 14:16:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tChwSLiykLOi; Thu, 16 Sep 2021 14:16:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC5534B177;
	Thu, 16 Sep 2021 14:16:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64BC34B0CB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:16:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ESQnh4JfyrPd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Sep 2021 14:16:02 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C86FC4B107
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:16:01 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 h25-20020a0cab19000000b0037a49d15c93so62847937qvb.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 11:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=JJZ190EFBdoAROgHmhQViRGxGG559ZmU5Q/9tQKxLoY=;
 b=VXFxleX8XZbxaXGsk52pqIxNLQlkPnbly3aXNjlVihcthPwkd7vAB2Ak2ReYQFp9Gz
 XNRC4NG00zHZWIHAqSy8Xe5QfHf2iqo04aBflACa0wBiSyaXPe41s9VLzvd0ze9jnmsk
 RDVfUZcyLzHoCDoidFIb1uEDOnlAcaLO7ll4PjIsWhMEwsl2NyGzWZj+GqNsRmgV9cyQ
 x24xui9+LrpOpWh2dLRRwg3b/yJbwu8oKo1k943MMDbWls0v3XpScoPeIvfAD0kuf4WM
 V8zsVGw4LFa0PpNqKVVgKta63ymqxpGPok4eoZB5FbmvmYMNpIrxqU4VMtlRfzAamFPi
 QU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=JJZ190EFBdoAROgHmhQViRGxGG559ZmU5Q/9tQKxLoY=;
 b=crogXsdQ8wKYgjdwY7hedrtBGl/xCszCPVrLjzx4b+j+zAZwApMFP0u36jLWsOd7fv
 BT63xdlsjoP59jwlsKPySJsS2aNcNQE5xVAAHygYYvk/VfVfMMwGE6/zBtiO8fYy++65
 2SQtHofNY5430+72GBXz9CH74nmqn409dKmfResilINln8pbxvNv+wUyc09xUXXcK9mT
 pDEPiXA+tJOfT06GCuIwiHj0dEZHVvOowJ4ckyZqBjp4gYog5olpDaa8r+g3mN4rNK/e
 J4Z5vwnnaky8cBNLrhIVdX54e84FehYw5dUk3MxH+WH5oOaglADNzpcVvyIavgLgFtfH
 EkNQ==
X-Gm-Message-State: AOAM533Hq2NR4Oy3A8O5Oo7RRe9+gMFuwWSDkDdtYbG5K2shHeI9fUt1
 AfYajRubORpMos36rcGSraGTs2t0K0s=
X-Google-Smtp-Source: ABdhPJwltYXH4Kr/7Jd29on+c2F3YNghXUrtcqQSctncJpRrq17F9VQCTldOwtteX8HrCI551yoAzX3DyD4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:146d:: with SMTP id
 c13mr6829626qvy.46.1631816161461; Thu, 16 Sep 2021 11:16:01 -0700 (PDT)
Date: Thu, 16 Sep 2021 18:15:49 +0000
In-Reply-To: <20210916181555.973085-1-oupton@google.com>
Message-Id: <20210916181555.973085-4-oupton@google.com>
Mime-Version: 1.0
References: <20210916181555.973085-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 3/9] selftests: KVM: Fix kvm device helper ioctl assertions
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
