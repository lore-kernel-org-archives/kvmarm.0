Return-Path: <SRS0=uZLN=NX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5095BC4320A
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 21:14:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E4DC3610C9
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 21:14:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E4DC3610C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 877E84B1A5;
	Wed,  1 Sep 2021 17:14:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jwrpEp2Kee-1; Wed,  1 Sep 2021 17:14:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5D3A4B1D8;
	Wed,  1 Sep 2021 17:14:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 116734B19A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 17:14:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XZBCo-J6XDPC for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Sep 2021 17:14:28 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A5314B19D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 17:14:28 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 ib9-20020a0562141c8900b003671c3a1243so959812qvb.21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Sep 2021 14:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Isvx4DjIyZ95UhyLPtghW+KyLIgzd4+t6VBStaNZel4=;
 b=qyxdd1Im2YrMFUu2970w/b6BrYgp0K2RtFaSPBbFajB/Z4ILFmH5RtNIhZahtm5Owk
 aezBt9A1JRyOWIRSYlCyfnap0LuVFZ7p20vC3ErhfaylqfBt3hKgkpE6HkPGooQtsfS2
 DI8qbreTIGfFkQ04tVXq7jD6kr9SV0BoxM5RCoRCzxeNpi21SrJ2DUoVDXg/xrRkEeJ0
 bXprxLBdvjeVfEFi6WQvG3MoEvTutHilR+thPeWgioFEqV+DY0IcuYzJuK95PjuHGUAR
 CyVYsF8IsaDRkVxuM2uo4sczHkZ4yguHAb1PkC10Tdr6G6RJxMBQY+tGevXPPcPsVhK5
 OlWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Isvx4DjIyZ95UhyLPtghW+KyLIgzd4+t6VBStaNZel4=;
 b=Zlr29EkVV+ciOG6GU/on4Xg4ABYGAtTV6nY7dBAfZ82nzSSYZDPLIfOh2kUfotUGuH
 rxaMOes654GErM+xSABIT9l65rpczLOYOyVVU9vzYR6omlJFfe1w75sd9Et1QneG40JP
 CBy+jMLcK/6eqKQmY3zAqA+jFNQFu1/tpzGxKTa3fcSCHtsm3Bo21TxkKboQu5fvSC3T
 Iaczq9ycplR327EAE8L0L/+fUj7zeYVGo6uQPPbHSu4TI9MNOKNtdrrOAAmxVp8J7f7M
 JHTBPzYbnu5FzmAX+FybEB94+iqKvc3pv7iGksg2dGwP3IMI5UsKQBCjRQgbTbuXuNuo
 iG5w==
X-Gm-Message-State: AOAM531T7AZubYMjLjapbVe5Kl/rOgQ5t8BxZ5tSRAgRPtHUbH4cAnO4
 JzaQmIapk40HDyw74BeDP1Mhi5plHfN3
X-Google-Smtp-Source: ABdhPJwlth2Eo5IAldYMKFCB7G6X17abdCy5ScWqLZRgKQwhrRMlUTBR9716k8Lrh7gJV88fgE5xC5aFUA+J
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a0c:9c4d:: with SMTP id
 w13mr1802546qve.43.1630530867766; Wed, 01 Sep 2021 14:14:27 -0700 (PDT)
Date: Wed,  1 Sep 2021 21:14:03 +0000
In-Reply-To: <20210901211412.4171835-1-rananta@google.com>
Message-Id: <20210901211412.4171835-4-rananta@google.com>
Mime-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v3 03/12] KVM: arm64: selftests: Add support for cpu_relax
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
index 082cc97ad8d3..78df059dc974 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -191,6 +191,11 @@ asm(
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
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
