Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED14C43216
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:58:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0ADD960FC3
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:58:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0ADD960FC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5F7B4B08B;
	Wed,  4 Aug 2021 04:58:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sFw3tfyGzw+H; Wed,  4 Aug 2021 04:58:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5240F4A3A3;
	Wed,  4 Aug 2021 04:58:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25B734A49C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DCEHPGuy5ZLc for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 04:58:46 -0400 (EDT)
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com
 [209.85.210.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 21EA84A524
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:44 -0400 (EDT)
Received: by mail-ot1-f74.google.com with SMTP id
 a91-20020a9d26640000b02904f073e6bc1dso513281otb.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 01:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=gCg0AznWgA4f1SrJgUwp//MIUEfrq8bP1cnOz9mraho=;
 b=MTCyPCTw0RZ+dPZ2ozrA+5wli9Ay+UMDLegw4vajpPfpUxDPSiKLc0KjPDr4t1VbV+
 J5VC+2D7LilUe7K9hJUgzZnIgERsJnXnBOOJYtyh6k6G9qjp7rB8PeWklTOaYdZpRZBf
 Adib//0K6WdMcr9nPQKZ/DWsF8taEaq+gazsww/VYX1ooxIuECdYs3LHF/RsUdd5IJOD
 XsBqzD2xkkZt2+J8vZhLXIt8kNwajcSPkONGtG2CEIG2seo6FgP/ztuUH/GpEm5NJjZA
 C8Buw2XEUbP1aCptyDiqWmQAmJ9h3TUzJU2weTZs6VSF8YzfckKutAH1jJXm2v8olilU
 PR3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=gCg0AznWgA4f1SrJgUwp//MIUEfrq8bP1cnOz9mraho=;
 b=Bw1aw5+PU4iI4+AQuN2ljUH2jycZg4jBudi0MQr78klRxQCD/bAuGsHIlxYT0D/yxs
 5YLpJcTNKWNp3JY8V2rO1SwWwU5RYKXMWxMGbIPHw5OO1JPIw5XnTaf18BrHAQF/JrSe
 4Eq/ajVg0CrKKZUL+kTIw+Tpsx7CApXNgTZmBWTtcgyzqVyxzuaxTGIt3xz5TlytQVLk
 K8vLePfI/WtB/B8gSQIR3VeloQ70zZM3lEL8rN2psE83Jr18Y5wWUlt+Ny9/spq6lXUt
 CewpsYg7TDOHekXRH7ycJ2P9gnmcc0tI+Q0Idvu45nk7km4aNk8tbDrjgkqviCPD/T9c
 sP+A==
X-Gm-Message-State: AOAM532L5QwsSyhI8s8D8TxmDS0a4J+VzK4d8zNCdtj/ZlOxb7DT+aot
 i+xWqBObVwyVUhCUBWjhDJBSJjwhjVo=
X-Google-Smtp-Source: ABdhPJyrF6Z/oAvVMCwq6Zwnl1O8bPPs3vKcjVomi62Qv2JKaBWWKXDpL2ITIDF27NgJQLbzg5F4wv4SoZ4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6808:68d:: with SMTP id
 k13mr17591632oig.83.1628067523355; Wed, 04 Aug 2021 01:58:43 -0700 (PDT)
Date: Wed,  4 Aug 2021 08:58:06 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-9-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 08/21] selftests: KVM: Fix kvm device helper ioctl
 assertions
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
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
