Return-Path: <SRS0=7ri5=BA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F1B6C433F4
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jul 2020 13:31:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4513D21702
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jul 2020 13:31:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J9kQIHBi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4513D21702
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA22B4B1C7;
	Tue, 21 Jul 2020 09:31:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vw9s0Y2jM0IM; Tue, 21 Jul 2020 09:31:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D3114B1EE;
	Tue, 21 Jul 2020 09:31:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A43514B13A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 00:18:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SrcNq8sNiebw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jul 2020 00:18:18 -0400 (EDT)
Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com
 [209.85.216.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94AA24B23A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 00:18:18 -0400 (EDT)
Received: by mail-pj1-f67.google.com with SMTP id gc15so854446pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 21:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=HdrgiDjwQi3OXxJsXUESa6n0z/319Mf+JqDHrOU66kg=;
 b=J9kQIHBiFR2cBCKxhL+j9PrgKpcG/r5Le8QseNCHRtjcterReYFiv7fvrhsU4CcS00
 C357fOgCmIvXpjMyqWX9aLfF2IYPjDTz8jRD7icKJCrsELYfzDqy43kknkJLNIDeIEVW
 WQCG4iOa5n/ZacA/O3S1XnrsihQqfsz9hzsfKmTpv8WWHlIZ3MqgeKtOUECEe2W2TyUN
 hR+l3HUDsNFWs/M9YBUrI1wOGIpfZNoN/q4qAat105HU7y8ZQtOPfbQh3BzkiZL+FMT7
 1GUBAZ0smgg07lgbKHTGCvrEqFBXkEDa//CkdpMhiPkD+VvyDEpu2lk+MxRfXdlCeAGl
 2qKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=HdrgiDjwQi3OXxJsXUESa6n0z/319Mf+JqDHrOU66kg=;
 b=PHWhElADxWLIvcnIK+tVHKILUdKWT+Zspcbk0NjCopoYsbaAQKjW4h/wXNIht9LHiO
 XP+bFZzUOgutMt7WECu+rnofqHnPYrUy4oWL+1cKCTiy8VaK9e1NYQfRvMZ1eMoGPZzA
 48Hd6wIhyi2pH4l5xLLDaCOXqynHbdasIc4CvXvPMw7fY0HKEFVZkmhAGkyuOV7w6kIw
 R+zElFsqmI5N/PsTHUKazfqVfX4J2UV2peURS4qjRqn+FgTbwOjSlkncYKVjLukht7vX
 pF9jSjupkZlWqeOhLeXEGPbfHYohkaElVF7Ngac8Ak2989DTpKJkjx8FQFLC7mmlPsg2
 naag==
X-Gm-Message-State: AOAM530YsFp2ctRu4B01M8HCPMedpijUmJe/7oYhTleQUUtlrtREIuFt
 9XFObyYVai7D1e9RXuK3z6U=
X-Google-Smtp-Source: ABdhPJyue+HTI0GPUR9dn0lDQER+qd43Q72CqYIHp9HX2nZ8SZRkDJx0a1ktEgktFA2ACThVp6s6CA==
X-Received: by 2002:a17:902:ed02:: with SMTP id
 b2mr21034822pld.121.1595305097820; 
 Mon, 20 Jul 2020 21:18:17 -0700 (PDT)
Received: from localhost.localdomain ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
 by smtp.gmail.com with ESMTPSA id
 e28sm18467270pfm.177.2020.07.20.21.18.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Jul 2020 21:18:17 -0700 (PDT)
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [RFC][PATCH 4/4] arm64: do not use dummy vcpu_is_preempted() anymore
Date: Tue, 21 Jul 2020 13:17:42 +0900
Message-Id: <20200721041742.197354-5-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
References: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Tue, 21 Jul 2020 09:31:48 -0400
Cc: joelaf@google.com, linux-kernel@vger.kernel.org,
 Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, suleiman@google.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

vcpu_is_preempted() now can represent the actual state of
the VCPU, so the scheduler can make better decisions when
it picks the idle CPU to enqueue a task on. I executed a
whole bunch of scheduler tests [0]. One particular test
that shows the importance of vcpu_is_preempted() is AIO
stress-ng test:

x Disabled vcpu_is_preempted()
stress-ng: info:  [100] stressor       bogo ops real time  usr time  sys time   bogo ops/s   bogo ops/s
stress-ng: info:  [100]                           (secs)    (secs)    (secs)   (real time) (usr+sys time)
stress-ng: info:  [100] aio              222927     10.01      0.89     27.61     22262.04      7822.00
stress-ng: info:  [139] aio              217043     10.01      1.00     26.80     21685.46      7807.30
stress-ng: info:  [178] aio              217261     10.01      1.08     26.79     21709.36      7795.51

+ Enabled vcpu_is_preempted()
stress-ng: info:  [100] aio              432750     10.00      1.14     19.03     43264.33     21455.13
stress-ng: info:  [139] aio              426771     10.01      1.09     18.67     42629.13     21597.72
stress-ng: info:  [179] aio              533039     10.00      1.42     20.39     53281.70     24440.12

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 arch/arm64/include/asm/spinlock.h | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/spinlock.h b/arch/arm64/include/asm/spinlock.h
index 9083d6992603..6a390eeabe82 100644
--- a/arch/arm64/include/asm/spinlock.h
+++ b/arch/arm64/include/asm/spinlock.h
@@ -11,17 +11,20 @@
 /* See include/linux/spinlock.h */
 #define smp_mb__after_spinlock()	smp_mb()
 
-/*
- * Changing this will break osq_lock() thanks to the call inside
- * smp_cond_load_relaxed().
- *
- * See:
- * https://lore.kernel.org/lkml/20200110100612.GC2827@hirez.programming.kicks-ass.net
- */
 #define vcpu_is_preempted vcpu_is_preempted
+
+#ifdef CONFIG_PARAVIRT
+extern bool paravirt_vcpu_is_preempted(int cpu);
+
+static inline bool vcpu_is_preempted(int cpu)
+{
+	return paravirt_vcpu_is_preempted(cpu);
+}
+#else
 static inline bool vcpu_is_preempted(int cpu)
 {
 	return false;
 }
+#endif /* CONFIG_PARAVIRT */
 
 #endif /* __ASM_SPINLOCK_H */
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
