Received: from mta1.migadu.com (out-110.mta1.migadu.com [95.215.58.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80DC415B7E
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 07:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791359053; cv=none; b=Myi8p+wqokDk+vP46PdfORsWizl1v2REOTs/wBTHrnYVOTWtDSuqVuWjQ107Q+dDql9Taj+YBS3f7W95LGSKLGm2GB7Djpta39pkY9DoShetB+ImgZQa0Ixrj5YGLietSfmyCDnDefq/bd3zGupFJOOfwWEyIo0TcKSjYeXx0lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791359053; c=relaxed/simple;
	bh=bjOOpGQalIV2u3GzuAco4r3khbtIp5Sk4WKZwpv659A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fwF6xDi77lJwPOASy7e5n9YoJ7X7TcbG+aLHneU/hlN6aMEY3NMiijU7YFFFeTbHzZxmmxUBMvQldrdgtDw7vG1gPKYTmwxqXajO8TJWadegPeGL1U2hAyAFVF5FypnuuJ5CZY0GRJJY9HJGRH3PHhvl9yTRxAQiIq0QlMl5rl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EAb2NEU4; arc=none smtp.client-ip=95.215.58.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EAb2NEU4"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=bjOOpGQalIV2u3GzuAco4r3khbtIp5Sk4WKZwpv659A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791359041; v=1; x=1791963841;
 b=EAb2NEU4kcntnF0HNhYzons5qDfod7RZ4elFnlzWpnZRc5vUNtW3yeHPBYqPBaFNmOc2vVFc
 avPPq532zD/r0QtF2jOmiSNO+yxJch+m94n8JL+btsTkROAee4ti0aNqBQYniuQv/eWfn7rZtNC
 3QiOYsTHuQuTsVdvv+/GVqns=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c64450ccc961372e;
	Wed, 07 Oct 2026 07:44:01 +0000
X-Mizu-Trace-ID: c64450ccc961372e
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 3/3] KVM: arm64: selftests: Test a timer set past the counter's wrap
Date: Wed,  7 Oct 2026 08:43:43 +0100
Message-Id: <20261007074343.324269-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261007074343.324269-1-fuad.tabba@linux.dev>
References: <20261007074343.324269-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Program an unmasked timer whose cval sits within long_wait_ms of the
counter's wrap while the guest's counter is at wait_ms, and expect no
interrupt. The guest's counter can't reach it, but a host that applies
the timer's offset by adding it to cval wraps the sum into the past,
and the timer fires at once. The one existing case with a cval past the
wrap, in the sanity checks, runs with the timer masked, so it gets no
interrupt either way.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 .../kvm/arm64/arch_timer_edge_cases.c         | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
index d9c9377a63256..d46799ff91dc1 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
@@ -787,6 +787,30 @@ static void test_timers_in_the_past(enum arch_timer timer)
 	}
 }
 
+/*
+ * A cval within long_wait_ms of the counter's wrap while the counter sits at
+ * wait_ms: a deadline further away than the counter can reach. Unmasked, so
+ * an early ISTATUS shows up as an IRQ.
+ */
+static void test_timers_past_counter_wrap(enum arch_timer timer)
+{
+	u64 cval = -msec_to_cycles(test_args.long_wait_ms);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sleep_method); i++) {
+		sleep_method_t sm = sleep_method[i];
+
+		local_irq_disable();
+		set_counter(timer, msec_to_cycles(test_args.wait_ms));
+		set_cval_irq(timer, cval, CTL_ENABLE);
+		sm(timer, msecs_to_usecs(test_args.wait_ms) + TIMEOUT_NO_IRQ_US);
+		local_irq_enable();
+		isb();
+		assert_irqs_handled(0);
+		timer_set_ctl(timer, CTL_IMASK);
+	}
+}
+
 static void test_long_timer_delays(enum arch_timer timer)
 {
 	s32 tval = (s32)msec_to_cycles(test_args.long_wait_ms);
@@ -806,6 +830,7 @@ static void guest_run_iteration(enum arch_timer timer)
 	test_basic_functionality(timer);
 	test_timers_sanity_checks(timer);
 
+	test_timers_past_counter_wrap(timer);
 	test_timers_above_tval_max(timer);
 	test_timers_in_the_past(timer);
 
-- 
2.39.5

