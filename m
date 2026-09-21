Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF11497B6B
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 09:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982923; cv=none; b=lhs1bTfelrGrAh8w8SA4JSJpVknM+vCXHU+pYjjtkJEkp2feX3wAgVAqUCsM46JGeVU0ZEN6D9sScGkd4GqWY/mVRS/EwUx2hytJsJdwyVGMjxF9pk16eZZnSV+886bhIUdn3DB5AZOPsi+P1Z1Y+O3zBTigGjGLpG5Z/609bog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982923; c=relaxed/simple;
	bh=phUmEey2KTaFFCHe3tz5iY5i7uUrJ8JToLD52Kf/15k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=HUHC4WLMI/3Kz1IOMbzBc60DHb2/59b8k/fOqZ06uJmQCA1jw8cuaLJnd8Hpo9zom5edetZZi+MuiSZc6ilHJR0jrQ4GdwSiENmaz+w0C61pUMmn3UKxFxNlwn1qVulB5Ih8RPijO52l10/VHhmzlkpRkFopUDhS1RPSo945+IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Px9FDAq9; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Px9FDAq9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Message-ID:MIME-Version:
	Content-Type; bh=zdLl1CStt/w3jatHVQVxNNngXmh7u7s/kl0WhZ6jI6s=;
	b=Px9FDAq9aHUPNZAcGIHD3M2+04zjMbPX2xcpooeX0uzL9Z9oiwpyOyQIyxi4AE
	w8zogl/TyayWrO2YvfaIrwCkntVNDA9chgzvw+UhJtXg3bOFUxIHwVlh0zFukwgI
	YoIuFMUs2G5/2kaVguiF9+1hnESu/+owNS73oE5Bgkhzc=
Received: from localhost (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDXRr2V+LBqZlMwAg--.3777S2;
	Mon, 21 Sep 2026 17:27:50 +0800 (CST)
Date: Mon, 21 Sep 2026 17:27:47 +0800
From: Hao Zhang <hao_zhang_kdev@163.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: selftests: Test arm64 stolen time after failed
 updates
Message-ID: <arD4k4RqkTetKtvi@192.168.1.215>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <arD24ru13owcE1Ms@192.168.1.215>
X-CM-TRANSID:PSgvCgDXRr2V+LBqZlMwAg--.3777S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXryDtr43JryktF13uw43trb_yoWrGFy8pa
	92kF1jgr4UK3ZFkr1Syr1DZFs8Gw4kJr42qr97u34rArs8KFsxtrs7KFy0qF1xArZ3XFn3
	ZFWrKr9FgrWDXF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jUjjgUUUUU=
X-CM-SenderInfo: pkdrs65kdqwshngh4qqrwthudrp/xtbC3hYqHWqw+JZDYgAA3q

From: Hao Zhang <zhanghao1@kylinos.cn>

Use mprotect() to keep the stolen-time page readable while removing
write access.  This allows kvm_get_guest() to succeed and forces the
subsequent kvm_put_guest() to fail.

Accumulate vCPU run delay, trigger the failed update, restore write
access, and run the vCPU again.  Verify that the successful retry
includes the delay that could not be reported by the failed update.

Without the fix, KVM advances last_steal on the failed write and the
test observes that the accumulated delay is lost.

Signed-off-by: Hao Zhang <zhanghao1@kylinos.cn>
---
 tools/testing/selftests/kvm/steal_time.c | 58 +++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index bc3c62b72c58..fbdd55fa5ab6 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -8,6 +8,8 @@
 #include <time.h>
 #include <sched.h>
 #include <pthread.h>
+#include <sys/mman.h>
+#include <unistd.h>
 #include <linux/kernel.h>
 #include <asm/kvm.h>
 #ifdef __riscv
@@ -162,6 +164,15 @@ static void guest_code(int cpu)
 
 	check_status(st);
 	WRITE_ONCE(guest_stolen_time[cpu], st->st_time);
+	if (!cpu) {
+		/*
+		 * Let userspace trigger a failed stolen-time update, then retry
+		 * the update after restoring write access.
+		 */
+		GUEST_SYNC(2);
+		GUEST_SYNC(3);
+		WRITE_ONCE(guest_stolen_time[cpu], st->st_time);
+	}
 	GUEST_DONE();
 }
 
@@ -469,9 +480,10 @@ static void check_steal_time_uapi(void)
 static void *do_steal_time(void *arg)
 {
 	struct timespec ts, stop;
+	unsigned long duration = arg ? *(unsigned long *)arg : MIN_RUN_DELAY_NS;
 
 	clock_gettime(CLOCK_MONOTONIC, &ts);
-	stop = timespec_add_ns(ts, MIN_RUN_DELAY_NS);
+	stop = timespec_add_ns(ts, duration);
 
 	while (1) {
 		clock_gettime(CLOCK_MONOTONIC, &ts);
@@ -500,6 +512,45 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
 	}
 }
 
+#ifdef __aarch64__
+static void test_failed_stolen_time_update(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vm *vm = vcpu->vm;
+	struct st_time *st = addr_gva2hva(vm, ST_GPA_BASE);
+	unsigned long duration = 100 * 1000 * 1000UL;
+	u64 stolen_time = st->st_time;
+	long run_delay;
+	pthread_t thread;
+
+	/*
+	 * Keep the page readable so that kvm_get_guest() succeeds, but make
+	 * kvm_put_guest() fail when KVM attempts to update stolen time.
+	 */
+	TEST_ASSERT(!mprotect(st, getpagesize(), PROT_READ),
+		    "Failed to make stolen time page read-only");
+
+	run_delay = get_run_delay();
+	kvm_pthread_create(&thread, NULL, do_steal_time, &duration);
+	do
+		sched_yield();
+	while (get_run_delay() - run_delay < duration / 5);
+	kvm_pthread_join(thread, NULL);
+	run_delay = get_run_delay() - run_delay;
+
+	/* The update fails, but the guest must still be able to run. */
+	run_vcpu(vcpu);
+	TEST_ASSERT(st->st_time == stolen_time,
+		    "Stolen time changed on a read-only page");
+
+	TEST_ASSERT(!mprotect(st, getpagesize(), PROT_READ | PROT_WRITE),
+		    "Failed to restore stolen time page write access");
+	run_vcpu(vcpu);
+	TEST_ASSERT(st->st_time - stolen_time >= run_delay,
+		    "Lost stolen time after a failed update: expected >= %ld, got %lu",
+		    run_delay, (unsigned long)(st->st_time - stolen_time));
+}
+#endif
+
 int main(int ac, char **av)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
@@ -569,6 +620,11 @@ int main(int ac, char **av)
 			    "Expected stolen time >= %ld, got %ld",
 			    run_delay, stolen_time);
 
+#ifdef __aarch64__
+		if (!i)
+			test_failed_stolen_time_update(vcpus[i]);
+#endif
+
 		if (verbose) {
 			ksft_print_msg("VCPU%d: total-stolen-time=%ld test-stolen-time=%ld%s\n",
 				       i, guest_stolen_time[i], stolen_time,
-- 
2.15.0

