Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1478FC4320A
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 17:01:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B57C061221
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 17:01:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B57C061221
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65D484B116;
	Sun, 15 Aug 2021 13:01:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ahH23MYWaQDY; Sun, 15 Aug 2021 13:01:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F96E4B139;
	Sun, 15 Aug 2021 13:01:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD7DA49FE6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 17:12:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uik3VAP+-fYM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Aug 2021 17:12:34 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D36024AC78
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 17:12:34 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 c196-20020ae9edcd0000b02903c9e325c3b2so8287587qkg.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Aug 2021 14:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=i0gC3YpOlYGFveSBqO/xZNra4rgAWDR79DWIZ6oDj6o=;
 b=s5Ktat8XOcezUVnJb1WS/qHIUWUy9yBdjTN5bhE6i0fMGjZYCkwSbxqDUwud+MdaqI
 dk+Zn+RkrsOIY2CeFggqpVheqoDLAYFUIkYmtjScPsc+VSl0awgPlkE9cbjjaN2c74Hb
 0N7En1twzTQQ1D2vqEPO2tnAa2zH8LuA94yv19XCVKzmow5wCaAPjo8h1A8Jm415QD0B
 wy/JG7ZSJxXDmVOsUfPqOMNZeL9lV5d/drVQKTfkSNvDOPB9GDBwbboSwEvZPwbV6/12
 4hsuaOo8hX7Kr3txQkKfPNAO7cudiUrRu5z8/2U73CwmgqnsNFfYUc0u9ZBUwZGVIWeu
 oCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=i0gC3YpOlYGFveSBqO/xZNra4rgAWDR79DWIZ6oDj6o=;
 b=b3ipWNveKsGqCPcr0EKDYdxyFGIKsGXhwb0fcYGbJX+d3dKKVqx3L0jc0mzLiSazbL
 3R4YLWxcJgiXyfOte8Zl6xDFVpFBT4kPRGDgk4wmPDjqrHr/HQXz/GReeXOJ8AoAGzU+
 G0sIbTD1w1wnL/iMCBVDD0g2HPV+kaC0Ofq03fx+4kFr5beCtWQ6SAzR2NvO7m4GGT/2
 st8zKTyS4tlaAHfjYvhuKLs8m9PlrTRZ7t1L2GXvD72Lzuc8hG3+UYXJ+CY8bi/yFrUv
 whKdLAN59BY+nGfViMICeZn5JFEQ+hOgGqOEsABQ/tpxP57rjjHha3IK4eM9hQRXmJT8
 BAvA==
X-Gm-Message-State: AOAM533oOSJeYpjO1F66O3wivkAT0xRjiDO3DpiBhv79YhBRXrZqOd16
 yiLKlDGHxQUnt8OK76I2ux235EVtjxvG
X-Google-Smtp-Source: ABdhPJypOuxC0xiAvWzRKcX6FUG1sO4EVFhTLrKIh/dzhKC+66Hb60+6xtglfO5h44/z9YkcWOomkfrGI10A
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6214:62c:: with SMTP id
 a12mr4731968qvx.49.1628889154400; Fri, 13 Aug 2021 14:12:34 -0700 (PDT)
Date: Fri, 13 Aug 2021 21:12:04 +0000
In-Reply-To: <20210813211211.2983293-1-rananta@google.com>
Message-Id: <20210813211211.2983293-4-rananta@google.com>
Mime-Version: 1.0
References: <20210813211211.2983293-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 03/10] KVM: arm64: selftests: Add support for cpu_relax
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Sun, 15 Aug 2021 13:01:04 -0400
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, kvmarm@lists.cs.columbia.edu
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

Implement the guest helper routine, cpu_relax(), to yield
the processor to other tasks.

The function was derived from
arch/arm64/include/asm/vdso/processor.h.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/include/aarch64/processor.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index b4bbce837288..c83ff99282ed 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -188,6 +188,11 @@ asm(
 	val;								  \
 })
 
+static inline void cpu_relax(void)
+{
+	asm volatile("yield" ::: "memory");
+}
+
 #define isb()		asm volatile("isb" : : : "memory")
 #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
 #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
