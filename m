Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D5A92F747C
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 10:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759228323; cv=none; b=rXtoZtOznQPnQyQR3BCNUceK1Qkk4m0gPvXjsB89hOXrNqk3kx3g7NTNf5AznVRlqsHswI/BZ6A5RH5Y4w/Q4s2VdJ+pXLWo+ezDTcXRhWdjf7j562bqkPBKjqKTzTweCAS8Q9iMjGEd4n4QZgLIYJw+7S9uaT5XHw/CDT3JS/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759228323; c=relaxed/simple;
	bh=cNOojZNTDfNff1cYoVV9T3yoSM39FVuA322b8IlHOC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4kjL6QxOk7AWKCyOIh8vfFxJImswecrbgCEslOtqebUsYrkr8GXSEtA0W85W+luVKSJOmLVVnBSnl8Mf4bo7PI2nqKUQ1c3JGT3vU1eB7aEOqh5VhATVWZYrStoJvW3frHQo2SHuRy7Vgtp2fyUqpM6gWXiA3jXQS8+5G087bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2735202C;
	Tue, 30 Sep 2025 03:31:52 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 751093F66E;
	Tue, 30 Sep 2025 03:31:59 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	will@kernel.org,
	oliver.upton@linux.dev,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	aneesh.kumar@kernel.org,
	steven.price@arm.com,
	tabba@google.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH kvmtool v4 01/15] Allow pausing the VM from vcpu thread
Date: Tue, 30 Sep 2025 11:31:15 +0100
Message-ID: <20250930103130.197534-2-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930103130.197534-1-suzuki.poulose@arm.com>
References: <20250930103130.197534-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pausing the VM from a vCPU thread doesn't work today, as it waits indefinitely
for a signal that never comes. By using the "current_kvm_cpu", enlighten the
kvm__pause() to skip the current CPU and do it inline. This also brings in a
restriction that a following kvm__continue() must be called from the same vCPU
thread.

Cc: Will Deacon <will@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/all/20230918104028.GA17744@willie-the-truck/
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 kvm.c | 35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/kvm.c b/kvm.c
index 07089cf1..cc25ecdb 100644
--- a/kvm.c
+++ b/kvm.c
@@ -59,6 +59,8 @@ const char *kvm_exit_reasons[] = {
 
 static int pause_event;
 static DEFINE_MUTEX(pause_lock);
+static struct kvm_cpu *pause_req_cpu;
+
 extern struct kvm_ext kvm_req_ext[];
 
 static char kvm_dir[PATH_MAX];
@@ -573,9 +575,25 @@ void kvm__reboot(struct kvm *kvm)
 
 void kvm__continue(struct kvm *kvm)
 {
+	/*
+	 * We must ensure that the resume request comes from the same context
+	 * as the one requested the pause, especially if it was issued from a
+	 * vCPU thread.
+	 */
+	if (current_kvm_cpu) {
+		if (pause_req_cpu != current_kvm_cpu ||
+		    !current_kvm_cpu->paused)
+			die("Trying to resume VM from invalid context");
+		current_kvm_cpu->paused = 0;
+	}
 	mutex_unlock(&pause_lock);
 }
 
+/*
+ * Mark all active CPUs as paused, until kvm__continue() is issued.
+ * NOTE: If this is called from a cpu thread, kvm__continue() must
+ * be called from the same thread.
+ */
 void kvm__pause(struct kvm *kvm)
 {
 	int i, paused_vcpus = 0;
@@ -590,10 +608,17 @@ void kvm__pause(struct kvm *kvm)
 	if (pause_event < 0)
 		die("Failed creating pause notification event");
 	for (i = 0; i < kvm->nrcpus; i++) {
-		if (kvm->cpus[i]->is_running && kvm->cpus[i]->paused == 0)
-			pthread_kill(kvm->cpus[i]->thread, SIGKVMPAUSE);
-		else
-			paused_vcpus++;
+		if (kvm->cpus[i]->is_running && kvm->cpus[i]->paused == 0) {
+			if (current_kvm_cpu != kvm->cpus[i]) {
+				pthread_kill(kvm->cpus[i]->thread, SIGKVMPAUSE);
+				continue;
+			} else if (current_kvm_cpu) {
+				current_kvm_cpu->paused = 1;
+				pause_req_cpu = current_kvm_cpu;
+				/* fall through to update our count */
+			}
+		}
+		paused_vcpus++;
 	}
 
 	while (paused_vcpus < kvm->nrcpus) {
@@ -604,6 +629,8 @@ void kvm__pause(struct kvm *kvm)
 		paused_vcpus += cur_read;
 	}
 	close(pause_event);
+	/* Remember the context requesting pause */
+	pause_req_cpu = current_kvm_cpu;
 }
 
 void kvm__notify_paused(void)
-- 
2.43.0

