Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AF619CD16
	for <kvmarm@lists.linux.dev>; Tue, 27 May 2025 14:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748355903; cv=none; b=HJHlQ43L+YgjdiGacRXKQG9EPkqzSCHM9UN5R+XrVJV3cY54fteD7m4KD1kvjcGT9umUSgDtg0eS7oMmmO1HW7ZMUzf5LPkF2PXifur5sLVFzy91YLOUnAATbDoakdZpjlxWfEcaVP6Pe/zaOAcJhUHnFn7EsXz6AZEZ5iTScA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748355903; c=relaxed/simple;
	bh=ocRxSy5EJXKWPp1wtDInyrXbEN2m5DHwoDq0BP3WbmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=bcYbWoklxMuIhekUbqwEetjb6582FspIMM+uVvxtQG5ZyPO2ZnSIZ+4zc0RS+lzTOeBnXf5cS+vrZD9gqKu+XLFTHaJIacOU/Xze5tUkk46VTElDjyG/ibwIN/T00kKJNuwLDD7as/jJ9SQFUV2rsAT+kU2JAVENUj0tGJkxkFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FX378gPA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FX378gPA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748355899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=unMc8iAgdhI+llHDkqJsAFL7ZbF0O8Lqzu9ojtHqeJA=;
	b=FX378gPA4KsKAfOjnB+Q+/Oz54XFo07nH04DzLxBJKmH/AbJ/bjCOolY1rjwo0+xj8RhTP
	MWp7F5C7CdrNmoOQI5TLSFtpLR/HiYynDT6x2rLSSlThL4p9FK28l5AmwmrbvyjOQ/l0E7
	vTItf5n3ZY16aDJZBQuHGLhBmlxc2h8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-yUHiYUIHMDqI6tvyHQXMGg-1; Tue, 27 May 2025 10:24:49 -0400
X-MC-Unique: yUHiYUIHMDqI6tvyHQXMGg-1
X-Mimecast-MFC-AGG-ID: yUHiYUIHMDqI6tvyHQXMGg_1748355888
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4d5e1af1fso1086377f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 27 May 2025 07:24:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748355888; x=1748960688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=unMc8iAgdhI+llHDkqJsAFL7ZbF0O8Lqzu9ojtHqeJA=;
        b=qFAcdWDfR8/IcT2Dvo9hQwu83iVSxMfyimc8nln6fPYxbzwazMlkpLZmZRVM5SMUTh
         wIg4VDAR/lwMCnQKto0X427t5jtle8JmzLZgYKIO5o8736SEa+8XiQSEefzDn02If4Rm
         /ZWEdP2BSl3d9375AsYtCJ87trc/09BHY6FB+akuT4ldbQK8T5ocmiZZ4dec0gz4t5lb
         qcDNK5sOrllfDSomQjw59tJshdz3TUJJu8n2KRWQWTji+cLtyTRYBkiVcd+6bYT0HWjq
         wd6cBCunVNyiDsbXy0bNEG/1E5GY1yk0tzumugHHEPlcXLQFbpXEsMS6jnGwkZnQ6EAD
         QSnw==
X-Forwarded-Encrypted: i=1; AJvYcCWEbgM6/kPgH90r3s/Vshs1V/Fi7UipbbyKuOIRXH6aSesN34JTIlOkQwBaapgWCaSV9KcxTcs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzO/zr8SA8vobgDCqPo6XmhQVs/L9KKEGNDkfDLmPq44wwwcJEd
	msnAz5FSmaGc5GwpWs+ZiExTFukLtQAIzC8rK9Rxqy/o0+1x5f1Het0Te4gFq2VTgeb7IN04BvF
	loF+IzriBK+UUnV/O9Yk3ksMj2Q9QKAboPG4KV0upktNwClpgqZDSGfKGBA==
X-Gm-Gg: ASbGncuL1ZXVC/mILVvpC3lO2w+GNjoqPoKOjAE+A5N1kAQaGp+BgZVius0KRNn78Pb
	hNd6e1nZUqJ5+zjYgA6/e2VyXlsasqB0G2hOMwKyURQ5118JWw2iYSS7brvzUbGjt14d1PPeqQx
	mo7q4miiDvuK4R2r/zp9n0IPjJ+hXTvXY9Tv2UeuS3JryNNesFaPLpVBjNHysjerl/l5Rqx1G7P
	0trm7gPN63pOg2mltWvkauhBHP2DAy/6VWGSaxLxfXoXJeP+eobq7gdwgrcF6abfPWt8h6pvxgd
	wH9izXnGii/aXVWWwRb3NL98aaIXakIKRuIbeQf9son2uBoSdp79ROgF1xA4RrU4JQug1v5AgA=
	=
X-Received: by 2002:a5d:5f55:0:b0:3a4:e1ea:3b38 with SMTP id ffacd0b85a97d-3a4e5e5d241mr1030438f8f.7.1748355887865;
        Tue, 27 May 2025 07:24:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IED6cDk0pjU6x3lxG7ezTVdoW3wzIGaXlNoiosT7cd0gwNQ04WLe8XIloW7vpZA7k37aWMp8g==
X-Received: by 2002:a5d:5f55:0:b0:3a4:e1ea:3b38 with SMTP id ffacd0b85a97d-3a4e5e5d241mr1030399f8f.7.1748355887452;
        Tue, 27 May 2025 07:24:47 -0700 (PDT)
Received: from rh.fritz.box (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f73d3edcsm278766415e9.20.2025.05.27.07.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 07:24:47 -0700 (PDT)
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
Subject: [PATCH v2 3/3] KVM: arm64: selftests: arch_timer_edge_cases - determine effective counter width
Date: Tue, 27 May 2025 16:24:34 +0200
Message-ID: <20250527142434.25209-4-sebott@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527142434.25209-1-sebott@redhat.com>
References: <20250527142434.25209-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bkdJ9KmeU3asVrDQ45fmt361LXG2Xwp5As65bY7KlxE_1748355888
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

arch_timer_edge_cases uses ~0 as the maximum counter value, however there's
no architectural guarantee that this is valid.

Figure out the effective counter width based on the effective frequency
like it's done by the kernel.

Note that the following subtest only worked since the counter initialized
with CVAL_MAX would instantly overflow (which is no longer the case):

	test_set_cnt_after_cval_no_irq(timer, 0, DEF_CNT, CVAL_MAX, sm);

To fix this we could swap CVAL_MAX for 0 here but since that is already
done by test_move_counters_behind_timers() let's remove that subtest.

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

Link: https://lore.kernel.org/kvmarm/ac1de1d2-ef2b-d439-dc48-8615e121b07b@redhat.com
Link: https://amperecomputing.com/assets/AmpereOne_Developer_ER_v0_80_20240823_28945022f4.pdf
Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 .../kvm/arm64/arch_timer_edge_cases.c         | 27 ++++++++++++-------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
index a813b4c6c817..1e3e36d869d4 100644
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

