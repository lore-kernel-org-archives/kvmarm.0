Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 051E9C48BCD
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 10:22:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A901261181
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 10:21:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A901261181
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5943E4A003;
	Wed,  9 Jun 2021 06:21:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kv2bOUsK67Yx; Wed,  9 Jun 2021 06:21:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69C844A4CD;
	Wed,  9 Jun 2021 06:21:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAF2B405A9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 17:48:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8S7w9qmBPoRP for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 17:48:41 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1E5540291
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 17:48:41 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 b20-20020ac87fd40000b02901e1370c5e12so10151170qtk.17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 14:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=67DO9q/Kcpbvyzcr1mvzFYjXWQVENF8Dem27uU+5fps=;
 b=QRW0mdlazXmqwpTtBWy7gVO2Vsqzm0otOCoz8nuttjFrKwU3ub0Iu5e1zlq3zfhm47
 kr/+jX+ynlTMJpj9DSXjzfaGXc1LPOGlTQo9pGayczFTLEFXJIhXNukAq9GRVvrtuPGo
 AfSqLIZMes0c/emJ+lFgjrAdAqb+4+9OKXMHn7gpXK3/gnJQRjCRb+7ysIivX6tx64jN
 IN2WmWEXpAQs9SpbLHd4Yqdey4MDGBMRiXtWAZZciVWk9YrRMhk8PZjlnBWeCQnxoeZi
 tJq6j6DbTuOySOcAvcOcgyGFruy5fiBQtOu8l7qfv4mg3UgD+JEz1yeJ6oyHfCsa1eyR
 uHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=67DO9q/Kcpbvyzcr1mvzFYjXWQVENF8Dem27uU+5fps=;
 b=chG9L4wUNPTH8CRKokW1tP2zNCnRmmUcKOOd4DKA3YHGcLfjVnShLHeN58rYubFvUk
 0aiviL2aWIG94ey6/lhGQJz+A0h3lvQulcuIgR1SKdcgNb5+PIQ90/Sxcp/iC4P4yF93
 K9NZZgJsS6uzftNdSJj+cobx5of5apdGNNyNtC1fyyBqMSVWGrEgGwJCQUWb1pYHDLCE
 nofwI+knCyk+1TEUXoxPEnxjh8HJhHqZpQDi2bGCiHhoYZuM4H9qbgBs0RECv77m6bVn
 FJ35YUIyRYSjD1pkiS2FosGMcJb8NB3JMVxvVpIHSbSj9PcMPN9z0USVap9FCh7dKKaq
 8n7g==
X-Gm-Message-State: AOAM531IZw98CDvEUdYbyex3DEuQn1YyuLlL1McA5uG/iDc3hGElqU4W
 2HwAC3ZS1mPeG7nMuD3lhtf4k2aBXPo=
X-Google-Smtp-Source: ABdhPJyg1Wey+rmDumCpN1DSiKtE3tz1DCSq/H8NM9+D8wklMqy8ucTb5VDFwusjuwissOIoFQe/WoKO0aI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:ad4:4863:: with SMTP id
 u3mr2132928qvy.7.1623188921468; 
 Tue, 08 Jun 2021 14:48:41 -0700 (PDT)
Date: Tue,  8 Jun 2021 21:47:41 +0000
In-Reply-To: <20210608214742.1897483-1-oupton@google.com>
Message-Id: <20210608214742.1897483-10-oupton@google.com>
Mime-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 09/10] selftests: KVM: Add support for x86 to
 system_counter_state_test
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Wed, 09 Jun 2021 06:21:47 -0400
Cc: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>
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

Test that userspace manipulation of the tsc offset (via
KVM_{GET,SET}_SYSTEM_COUNTER_STATE) results in the expected guest view
of the TSC.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/system_counter_state_test.c | 32 +++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c2e5a7d877b1..28207474c79c 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -76,6 +76,7 @@ TEST_GEN_PROGS_x86_64 += kvm_page_table_test
 TEST_GEN_PROGS_x86_64 += memslot_modification_stress_test
 TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
+TEST_GEN_PROGS_x86_64 += system_counter_state_test
 
 TEST_GEN_PROGS_aarch64 += aarch64/counter_emulation_benchmark
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
diff --git a/tools/testing/selftests/kvm/system_counter_state_test.c b/tools/testing/selftests/kvm/system_counter_state_test.c
index f537eb7b928c..9dcbc95bba3f 100644
--- a/tools/testing/selftests/kvm/system_counter_state_test.c
+++ b/tools/testing/selftests/kvm/system_counter_state_test.c
@@ -138,6 +138,38 @@ static uint64_t host_read_guest_counter(struct system_counter_state_test *test)
 	return r;
 }
 
+#elif __x86_64__
+
+/* no additional information required beyond the counter state. */
+#define system_counter_state_test kvm_system_counter_state
+
+static struct system_counter_state_test test_cases[] = {
+	{ .tsc_offset = 0 },
+	{ .tsc_offset = 1000000 },
+	{ .tsc_offset = -1 },
+};
+
+static void pr_test(struct system_counter_state_test *test)
+{
+	printf("tsc_offset: %lld\n", test->tsc_offset);
+}
+
+static struct kvm_system_counter_state *
+get_system_counter_state(struct system_counter_state_test *test)
+{
+	return test;
+}
+
+static uint64_t guest_read_counter(struct system_counter_state_test *test)
+{
+	return rdtsc();
+}
+
+static uint64_t host_read_guest_counter(struct system_counter_state_test *test)
+{
+	return rdtsc() + test->tsc_offset;
+}
+
 #else
 #error test not implemented for architecture being built!
 #endif
-- 
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
