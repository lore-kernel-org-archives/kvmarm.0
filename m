Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD417C07E9B
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 18:50:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7F1496112D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 18:50:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F1496112D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17DBE4B0F4;
	Mon, 19 Jul 2021 14:50:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KEp6id0CGVoA; Mon, 19 Jul 2021 14:50:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DF534B10A;
	Mon, 19 Jul 2021 14:50:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE2E74B0D9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 14:50:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UVlxLTzPCGXB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 14:50:08 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 170D14B0CB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 14:50:07 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 q10-20020a056902150ab02905592911c932so26901353ybu.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 11:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=6oCR3RsSf0sSKA4Gfkr/K6wh2PtHCE6P4q0EDP+cPOQ=;
 b=Rs0E1+bX0JUBjrglpBzuz0teVGHiVpojaup2IZr9QAun13XkfiTisT25GYVX1NoBvR
 UzRc0YoYFejyTD+NvvgfL5FmG9oX3TVhKRUgTwDdBVPtAzS8DGmu6aB9P3s/tvadMZMR
 5m8SxRU8nr0Xejaz/2GkzBI48N0FqHDOFWtnKxQdBCLNBV43jgo9exKLvTaW5+YP5ZJS
 Co9syFELKWorNMnweipBOlkAcub0Zy5XNqGL2lTwRA5NBAGOITkbcPUpdAUXT8DhO9qI
 hEbacZA0GlO5zGuzUC32kZ8IzOlhMu6+b9qzqnfy+yQ08JjjNy0F4itRMmM15clo7efV
 QO9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=6oCR3RsSf0sSKA4Gfkr/K6wh2PtHCE6P4q0EDP+cPOQ=;
 b=KUm1GZTTrumsoTOjUdZGRE3U+aF2DXyONgktcihSIVS75R/P1716Rj+j5NZBL+5689
 b/WA6kfxdxsmiTv0mKt661IBCKoNMySD2o1XEUJkVdWad2SXVKmT4tYZYD38kzoBdub2
 cQh79I66zCOSCrc4RRVwnn0VigjHzba6kgLz6QZfJK4UHC2fuvD3y/Egy2dbFqU34QQq
 DKpt0fBrDJu+zJ7J7j28kjTncrhPx+a56iagNhWf0Gg/LRyZ1C/hycApUjmS3hNFGKdH
 MVg2UATSdgOg3iq5qLNvL5DoUxO+59G+CHMXi1kFJi7oJC4Bs4LLRRUv7WtiBAy6abdK
 YlXg==
X-Gm-Message-State: AOAM531KAi51WGGf5L6Xeoc8Im+YE2TxYay3ObumgtULS/204z+7WEhR
 FB9ZYm7d5Tx8Lr/lsKw0rZynaQqdVR8=
X-Google-Smtp-Source: ABdhPJz6ewTOkVfIXpWSdRPu0+HzbHh30XCUCUOAHHq2aNWnrTQ8xtbDRSs/M/Bhu1h/TrKSK91soYYMv7A=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6902:1507:: with SMTP id
 q7mr34231518ybu.326.1626720606644; Mon, 19 Jul 2021 11:50:06 -0700 (PDT)
Date: Mon, 19 Jul 2021 18:49:43 +0000
In-Reply-To: <20210719184949.1385910-1-oupton@google.com>
Message-Id: <20210719184949.1385910-7-oupton@google.com>
Mime-Version: 1.0
References: <20210719184949.1385910-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 06/12] selftests: KVM: Add helpers for vCPU device
 attributes
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

vCPU file descriptors are abstracted away from test code in KVM
selftests, meaning that tests cannot directly access a vCPU's device
attributes. Add helpers that tests can use to get at vCPU device
attributes.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  9 +++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 38 +++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a8ac5d52e17b..1b3ef5757819 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -240,6 +240,15 @@ int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 		      void *val, bool write);
 
+int _vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			  uint64_t attr);
+int vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			 uint64_t attr);
+int _vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			  uint64_t attr, void *val, bool write);
+int vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			 uint64_t attr, void *val, bool write);
+
 const char *exit_reason_str(unsigned int exit_reason);
 
 void virt_pgd_alloc(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 10a8ed691c66..b595e7dc3fc5 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2040,6 +2040,44 @@ int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 	return ret;
 }
 
+int _vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			  uint64_t attr)
+{
+	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+
+	TEST_ASSERT(vcpu, "nonexistent vcpu id: %d", vcpuid);
+
+	return _kvm_device_check_attr(vcpu->fd, group, attr);
+}
+
+int vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+				 uint64_t attr)
+{
+	int ret = _vcpu_has_device_attr(vm, vcpuid, group, attr);
+
+	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
+	return ret;
+}
+
+int _vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			     uint64_t attr, void *val, bool write)
+{
+	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+
+	TEST_ASSERT(vcpu, "nonexistent vcpu id: %d", vcpuid);
+
+	return _kvm_device_access(vcpu->fd, group, attr, val, write);
+}
+
+int vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			    uint64_t attr, void *val, bool write)
+{
+	int ret = _vcpu_access_device_attr(vm, vcpuid, group, attr, val, write);
+
+	TEST_ASSERT(!ret, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
+	return ret;
+}
+
 /*
  * VM Dump
  *
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
