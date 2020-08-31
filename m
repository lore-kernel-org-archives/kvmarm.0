Return-Path: <SRS0=Zhuu=CJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86500C433E6
	for <kvmarm@archiver.kernel.org>; Mon, 31 Aug 2020 19:34:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D29920FC3
	for <kvmarm@archiver.kernel.org>; Mon, 31 Aug 2020 19:34:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U7oBMwBK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D29920FC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1B494B373;
	Mon, 31 Aug 2020 15:34:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9gKO1KY+uIU7; Mon, 31 Aug 2020 15:34:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0A694B27E;
	Mon, 31 Aug 2020 15:34:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DE194B24C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Aug 2020 15:34:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ggZGtKf3+nEZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Aug 2020 15:34:28 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA7764B24D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Aug 2020 15:34:28 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1598902468;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=vtLyg6lCGileigLzG/AbjWIpEiRqxpxwtXfCaWYW4BQ=;
 b=U7oBMwBKi/nWOdGKZvrkV7XX4PfAnMUu2HJR02rUY0rjtng5Ghxq3Q5NkUwqghVvW395nA
 vXTcFBvnYhmeNtQUzGSiVdGcLDydsmH4yuRNtBtyJhnQzl0+EEDZ8J2v336W1lD+NOyFrc
 +JI1Ysvl9oKsnGIzMYEUirdUmc/jXNU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-IZETdFkBPgyuFjCOujLmHQ-1; Mon, 31 Aug 2020 15:34:27 -0400
X-MC-Unique: IZETdFkBPgyuFjCOujLmHQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FF6A802B49;
 Mon, 31 Aug 2020 19:34:25 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-112.ams2.redhat.com [10.36.112.112])
 by smtp.corp.redhat.com (Postfix) with ESMTP id DB7637EB7D;
 Mon, 31 Aug 2020 19:34:22 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, drjones@redhat.com,
 andrew.murray@arm.com, sudeep.holla@arm.com, maz@kernel.org,
 will@kernel.org, haibo.xu@linaro.org
Subject: [kvm-unit-tests RFC 1/4] arm64: Move get_id_aa64dfr0() in processor.h
Date: Mon, 31 Aug 2020 21:34:11 +0200
Message-Id: <20200831193414.6951-2-eric.auger@redhat.com>
In-Reply-To: <20200831193414.6951-1-eric.auger@redhat.com>
References: <20200831193414.6951-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

We plan to use get_id_aa64dfr0() for SPE tests.
So let's move this latter in processor.h header.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c                 | 1 -
 lib/arm64/asm/processor.h | 5 +++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index cece53e..e2cb51e 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -167,7 +167,6 @@ static void test_overflow_interrupt(void) {}
 #define ID_DFR0_PMU_V3_8_5	0b0110
 #define ID_DFR0_PMU_IMPDEF	0b1111
 
-static inline uint32_t get_id_aa64dfr0(void) { return read_sysreg(id_aa64dfr0_el1); }
 static inline uint32_t get_pmcr(void) { return read_sysreg(pmcr_el0); }
 static inline void set_pmcr(uint32_t v) { write_sysreg(v, pmcr_el0); }
 static inline uint64_t get_pmccntr(void) { return read_sysreg(pmccntr_el0); }
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 02665b8..11b7564 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -88,6 +88,11 @@ static inline uint64_t get_mpidr(void)
 	return read_sysreg(mpidr_el1);
 }
 
+static inline uint64_t get_id_aa64dfr0(void)
+{
+	return read_sysreg(id_aa64dfr0_el1);
+}
+
 #define MPIDR_HWID_BITMASK 0xff00ffffff
 extern int mpidr_to_cpu(uint64_t mpidr);
 
-- 
2.21.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
