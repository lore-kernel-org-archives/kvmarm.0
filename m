Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47E8218AC1
	for <kvmarm@lists.linux.dev>; Thu,  5 Jun 2025 10:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749119828; cv=none; b=A82uLPr5ehVIAUCExgBglmx4gYr59J8iTO75RT1h2eQes3TmbVsuixkGut7cpCUSyc+wTMicftPrxybFuj9GZbhBspu3Fyz2gDLLFQesgR4ttXXca4J5ByAA0yqiHvBv//r8rzcXkjqN7mT+AzGDKIo+N5e3N1MFziuo3DPiwbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749119828; c=relaxed/simple;
	bh=KbwWFQ1kTo+qRw1U/gTjGAckXKWUWt6XmW7dlBGCSqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=EfW7BrOUh853+ULZnrumWWYHk8jFUOYNrW1rdKmP2SC1RMddS+m7jRD6sdX9dpy5EwYIa6NOSRv32m0enIgQ67l8Fm5I8eKviaERSC1/dX6AMpj5Pm7xD9JLxfdU5L/35FwlYyFPfEjRcEOq+BtM2gPnynBVtG4X40tX3Nr2yRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UTymobA/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UTymobA/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749119825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=amWbxwyASZoUP07CpGcLTUSUvzxbgFk3ulFVLl61SIw=;
	b=UTymobA//7uaLtfb6rnDnsv8gwpp5qU2qGzy477UKT0kzJE7DisA37fLpDpj/YlxKLf5W+
	LkEZ0B0tOckpREKLrXvSiyKXQ+P0vuMjsULmQTYBlBfWNO2jN5YH6XtfHbXqj5UA4nl8fg
	36uETqcXLGDChLzqFzT/tBP6vixXbOs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-XsCxcRVhPsyOhqZjHaqRHg-1; Thu, 05 Jun 2025 06:37:04 -0400
X-MC-Unique: XsCxcRVhPsyOhqZjHaqRHg-1
X-Mimecast-MFC-AGG-ID: XsCxcRVhPsyOhqZjHaqRHg_1749119823
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-450d244bfabso6381075e9.0
        for <kvmarm@lists.linux.dev>; Thu, 05 Jun 2025 03:37:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749119823; x=1749724623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=amWbxwyASZoUP07CpGcLTUSUvzxbgFk3ulFVLl61SIw=;
        b=aJZX6zeodwkmu1WDPDRUI51nN3einc49zA9pPkw7heWx+1ri8I6MFkPp081V919rim
         FaUzu3fSLU/i7Fs1QmJ7/wAAM5sP1hOB+3gHUEcAvg08MhpZ10AkFj83+8HaHihLb2pM
         VCgC8JM2rbXmUeOrNw36ukRKz7eFGAnEUomBqFZWcmWutSOfm1yBGnHhHSaZs2fn55HP
         jSfA2xqq2mT8ebs5n7wf/0Q5vMxAutjSaQea1FTaagY1uQAmL/bnaSPcEBcSThBEGjKI
         CPFDA5ynyOzJLNodZveU/Eb+4D2VJj1iuz8fjRSdkqgtzjmhI0Uh9KXlyLGuLIuSTIDU
         ISvw==
X-Forwarded-Encrypted: i=1; AJvYcCVt51QzHQ3zmFVjb7vvWESM8BFeLWvzOweGbMtPnH4wktk0eK39M9EohEAmLeanBEchn4/XE8M=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSkL/deHdRzfBz5W8BS6Rpa5XZwOdE9G54SXfziulBV45qQwix
	dbCowKMlcDgIRCIp1Mk7tZQJ/jQzw7X3pgxJL9ZVXIJ25eL/JwVp+P2c+yNbnYnk7epOjp4F0XR
	aOEtOlv4ATFgn6ikOkm2URG1A5UM/oWvl+xBB7gxrI7G5JSICvDGVoojcsQ==
X-Gm-Gg: ASbGncsEJtamrRV06JTK6sC7I9rhSpPcIGnNoX9kG2gvRk1dtOp3sYa8M060RGh+vml
	JWuisX28h5yV+XEoLoscqLgYZCgJAaQ8SlY0y0AJoooaZ3bIjoSLT0WIbIweWrAfDquOpJStIAO
	5u2oNwBYHpam/RBypdjC5WHgGk+nKDTMBWluWwSg6ATMtEth+ogyMu0pzsBNJRCzHEx9jLYtxG+
	FHjk7sZ7ntE9pAY4LDN2ESKDGKsaD+cLuEEgbOtgNoKaPw1XSypdelTsZs1jwSfIIozPXljwecr
	ajZqVY5sO2veH60fYJnRzN+RhJx0kqT0VupJToyjkuRU9XMv6DX3npof37qFh7d5Kx3cBnpiug=
	=
X-Received: by 2002:a05:600c:3b2a:b0:450:d5c8:29ae with SMTP id 5b1f17b1804b1-451f0a72e7bmr51415205e9.1.1749119823013;
        Thu, 05 Jun 2025 03:37:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmtZcZkRv3ekScQM6gx63V+kNA53R9LzjK0Zl5xkWmfvukrEiqxBs91K876Y3Lvx+XWubrwg==
X-Received: by 2002:a05:600c:3b2a:b0:450:d5c8:29ae with SMTP id 5b1f17b1804b1-451f0a72e7bmr51414985e9.1.1749119822583;
        Thu, 05 Jun 2025 03:37:02 -0700 (PDT)
Received: from rh.fritz.box (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-451f8311ae6sm14105175e9.2.2025.06.05.03.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 03:37:02 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Colton Lewis <coltonlewis@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v3 4/4] KVM: arm64: selftests: arch_timer_edge_cases - determine effective counter width
Date: Thu,  5 Jun 2025 12:36:13 +0200
Message-ID: <20250605103613.14544-5-sebott@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250605103613.14544-1-sebott@redhat.com>
References: <20250605103613.14544-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Q2aV9Nv28sM1z7q8wm-3OBfGXuAWN3xBf1sbO_jKGMg_1749119823
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

arch_timer_edge_cases uses ~0 as the maximum counter value, however there's
no architectural guarantee that this is valid.

Figure out the effective counter width based on the effective frequency
like it's done by the kernel.

This also serves as a workaround for AC03_CPU_14 that led to the
following assertion failure on ampere-one machines:

==== Test Assertion Failure ====
  arm64/arch_timer_edge_cases.c:169: timer_condition == istatus
  pid=11236 tid=11236 errno=4 - Interrupted system call
     1  0x0000000000404ce7: test_run at arch_timer_edge_cases.c:938
     2  0x0000000000401ebb: main at arch_timer_edge_cases.c:1053
     3  0x0000ffff9fa8625b: ?? ??:0
     4  0x0000ffff9fa8633b: ?? ??:0
     5  0x0000000000401fef: _start at ??:?
  0x1 != 0x0 (timer_condition != istatus)

Note that the following subtest only worked since the counter initialized
with CVAL_MAX would instantly overflow (which is no longer the case):

	test_set_cnt_after_cval_no_irq(timer, 0, DEF_CNT, CVAL_MAX, sm);

To fix this we could swap CVAL_MAX for 0 here but since that is already
done by test_move_counters_behind_timers() let's remove that subtest.

Link: https://lore.kernel.org/kvmarm/ac1de1d2-ef2b-d439-dc48-8615e121b07b@redhat.com
Link: https://amperecomputing.com/assets/AmpereOne_Developer_ER_v0_80_20240823_28945022f4.pdf
Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 .../kvm/arm64/arch_timer_edge_cases.c         | 27 ++++++++++++-------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
index be8bbedc933b..b4d22b3ab7cc 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
@@ -22,7 +22,8 @@
 #include "gic.h"
 #include "vgic.h"
 
-static const uint64_t CVAL_MAX = ~0ULL;
+/* Depends on counter width. */
+static uint64_t CVAL_MAX;
 /* tval is a signed 32-bit int. */
 static const int32_t TVAL_MAX = INT32_MAX;
 static const int32_t TVAL_MIN = INT32_MIN;
@@ -30,8 +31,8 @@ static const int32_t TVAL_MIN = INT32_MIN;
 /* After how much time we say there is no IRQ. */
 static const uint32_t TIMEOUT_NO_IRQ_US = 50000;
 
-/* A nice counter value to use as the starting one for most tests. */
-static const uint64_t DEF_CNT = (CVAL_MAX / 2);
+/* Counter value to use as the starting one for most tests. Set to CVAL_MAX/2 */
+static uint64_t DEF_CNT;
 
 /* Number of runs. */
 static const uint32_t NR_TEST_ITERS_DEF = 5;
@@ -732,12 +733,6 @@ static void test_move_counters_ahead_of_timers(enum arch_timer timer)
 		test_set_cnt_after_tval(timer, 0, tval, (uint64_t) tval + 1,
 					wm);
 	}
-
-	for (i = 0; i < ARRAY_SIZE(sleep_method); i++) {
-		sleep_method_t sm = sleep_method[i];
-
-		test_set_cnt_after_cval_no_irq(timer, 0, DEF_CNT, CVAL_MAX, sm);
-	}
 }
 
 /*
@@ -975,6 +970,8 @@ static void test_vm_create(struct kvm_vm **vm, struct kvm_vcpu **vcpu,
 	test_init_timer_irq(*vm, *vcpu);
 	vgic_v3_setup(*vm, 1, 64);
 	sync_global_to_guest(*vm, test_args);
+	sync_global_to_guest(*vm, CVAL_MAX);
+	sync_global_to_guest(*vm, DEF_CNT);
 }
 
 static void test_print_help(char *name)
@@ -1035,6 +1032,17 @@ static bool parse_args(int argc, char *argv[])
 	return false;
 }
 
+static void set_counter_defaults(void)
+{
+	const uint64_t MIN_ROLLOVER_SECS = 40ULL * 365 * 24 * 3600;
+	uint64_t freq = read_sysreg(CNTFRQ_EL0);
+	uint64_t width = ilog2(MIN_ROLLOVER_SECS * freq);
+
+	width = clamp(width, 56, 64);
+	CVAL_MAX = GENMASK_ULL(width - 1, 0);
+	DEF_CNT = CVAL_MAX / 2;
+}
+
 int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
@@ -1047,6 +1055,7 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 
 	sched_getaffinity(0, sizeof(default_cpuset), &default_cpuset);
+	set_counter_defaults();
 
 	if (test_args.test_virtual) {
 		test_vm_create(&vm, &vcpu, VIRTUAL);
-- 
2.49.0

