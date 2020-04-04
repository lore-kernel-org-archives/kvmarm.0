Return-Path: <SRS0=dc8k=5U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB11AC2BA1A
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 658FF206F5
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gez8s6Od"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 658FF206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FA614B1A9;
	Sat,  4 Apr 2020 10:38:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h41vJqdahNDs; Sat,  4 Apr 2020 10:38:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DD8C4B1DB;
	Sat,  4 Apr 2020 10:38:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3177B4B10A
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:38:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4P0wMXTUb57s for <kvmarm@lists.cs.columbia.edu>;
 Sat,  4 Apr 2020 10:38:19 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 671414B16A
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:38:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586011099;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=X/FnkgGUsHKu76b7rfSyf9V2vp8FmKEyZRkIYQEnR7c=;
 b=gez8s6OdzI565C6GjPp3CXFQGyMzc1IEk4xYdKIviMqnwZfh+tm9BnNtiDu2M582/HRVYM
 NRqhhbVFuESOuKhYjCpjIKJc4O/yU7cHRWcCko+rHqhsv7BJ32/Yyl7HK2coa8Ttf6w8gE
 pryVcNiIJXC1drjqQYG04K6ojMXKIV4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-kRr9Vb7zPLuZE7cheQwSxg-1; Sat, 04 Apr 2020 10:38:12 -0400
X-MC-Unique: kRr9Vb7zPLuZE7cheQwSxg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C8261005509;
 Sat,  4 Apr 2020 14:38:11 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 142B29B912;
 Sat,  4 Apr 2020 14:38:09 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: pbonzini@redhat.com
Subject: [PULL kvm-unit-tests 13/39] arm64: timer: Use existing helpers to
 access counter/timers
Date: Sat,  4 Apr 2020 16:37:05 +0200
Message-Id: <20200404143731.208138-14-drjones@redhat.com>
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

From: Zenghui Yu <yuzenghui@huawei.com>

We already have some good helpers to access the counter and timer
registers.  Use them to avoid open coding the accessors again.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index 10a88f3f1d19..f5cf775ce50f 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -331,7 +331,7 @@ static void test_init(void)
 	vtimer_info.irq_flags = fdt32_to_cpu(data[8]);
 
 	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, ptimer_unsupported_handler);
-	read_sysreg(cntp_ctl_el0);
+	ptimer_info.read_ctl();
 	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, NULL);
 
 	if (ptimer_unsupported && !ERRATA(7b6b46311a85)) {
@@ -366,15 +366,15 @@ static void print_timer_info(void)
 {
 	printf("CNTFRQ_EL0   : 0x%016lx\n", read_sysreg(cntfrq_el0));
 
-	if (!ptimer_unsupported){
-		printf("CNTPCT_EL0   : 0x%016lx\n", read_sysreg(cntpct_el0));
-		printf("CNTP_CTL_EL0 : 0x%016lx\n", read_sysreg(cntp_ctl_el0));
-		printf("CNTP_CVAL_EL0: 0x%016lx\n", read_sysreg(cntp_cval_el0));
+	if (!ptimer_unsupported) {
+		printf("CNTPCT_EL0   : 0x%016lx\n", ptimer_info.read_counter());
+		printf("CNTP_CTL_EL0 : 0x%016lx\n", ptimer_info.read_ctl());
+		printf("CNTP_CVAL_EL0: 0x%016lx\n", ptimer_info.read_cval());
 	}
 
-	printf("CNTVCT_EL0   : 0x%016lx\n", read_sysreg(cntvct_el0));
-	printf("CNTV_CTL_EL0 : 0x%016lx\n", read_sysreg(cntv_ctl_el0));
-	printf("CNTV_CVAL_EL0: 0x%016lx\n", read_sysreg(cntv_cval_el0));
+	printf("CNTVCT_EL0   : 0x%016lx\n", vtimer_info.read_counter());
+	printf("CNTV_CTL_EL0 : 0x%016lx\n", vtimer_info.read_ctl());
+	printf("CNTV_CVAL_EL0: 0x%016lx\n", vtimer_info.read_cval());
 }
 
 int main(int argc, char **argv)
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
