Received: from mta0.migadu.com (out-249.mta0.migadu.com [91.218.175.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B12364EAB
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 19:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788204252; cv=none; b=LexyWHqdLZDUDEec+qfK7trrgToF+GOd5YvkjsgYfayIb0f1NN6iUz4Ep8vtRtl1LAglQQZNWKwKJtss0k3ydeJV75M3M29GTJm0E8+hIFrRk8MwiBV/ca6y/r00gMvKX0dEzi1eqmqI8RjJyX72PRrenj/V2fkl+i1prHDwihc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788204252; c=relaxed/simple;
	bh=0AmK8CNakoQAqZwHRn5zlOSNLYaCkQZbqWhEYUXEYnc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TBuv7FFPkOFFobpfwvQ9K2cEKEoG3rDAKLZ0qwFx9Z8gGljEd5uxWUFpeNdx/W1OqpGgzCI3+penOvqWZVJT4Mvw4Nx7ZUvW5N4G8QX+ozq7cTuFS7qcv9G78KzCxe6ShvsPtGaQDXqb/KH33qIrnkqXk5uo+odMA7ucn+94xwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c4goKm5h; arc=none smtp.client-ip=91.218.175.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c4goKm5h"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=0AmK8CNakoQAqZwHRn5zlOSNLYaCkQZbqWhEYUXEYnc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788204248; v=1; x=1788809048;
 b=c4goKm5hwIobNm+NRd9oTaMQhVbigG7yH7wrX9vTTuJ3xKcuZrKDc+Ai6ohYAryZb/h4nerU
 3ewy0IjyYn5ecIGrIjaK6AqgCjiL2NA5yQ2K+N4cErr9YRK9Vbs7lf6xh1CJGu/f062DwcqOjod
 FDvcPa5mTszFAiasZID4Ghcg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5755b3b025ed58c5;
	Mon, 31 Aug 2026 19:24:08 +0000
X-Mizu-Trace-ID: 5755b3b025ed58c5
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH kvmtool 2/5] kvm: Bound-check the exit-reason string lookup
Date: Mon, 31 Aug 2026 20:24:03 +0100
Message-Id: <20260831192406.1341841-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260831192406.1341841-1-fuad.tabba@linux.dev>
References: <20260831192406.1341841-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_cpu_thread()'s panic path uses the kernel's exit_reason to index
kvm_exit_reasons[] without checking it against the array's size. The
table does not cover every exit reason KVM can return, so a reason past
its last entry reads out of bounds. KVM_EXIT_SYSTEM_EVENT and
KVM_EXIT_ARM_NISV are both past it.

Move the table behind kvm__exit_reason_str(), which checks the index
first. The array now has a single caller inside kvm.c, so make it
static const.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 builtin-run.c     |  2 +-
 include/kvm/kvm.h |  2 +-
 kvm.c             | 10 +++++++++-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index 81f255f..f36d3e2 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -298,7 +298,7 @@ static void *kvm_cpu_thread(void *arg)
 panic_kvm:
 	pr_err("KVM exit reason: %u (\"%s\")",
 		current_kvm_cpu->kvm_run->exit_reason,
-		kvm_exit_reasons[current_kvm_cpu->kvm_run->exit_reason]);
+		kvm__exit_reason_str(current_kvm_cpu->kvm_run->exit_reason));
 
 	if (current_kvm_cpu->kvm_run->exit_reason == KVM_EXIT_UNKNOWN) {
 		pr_err("KVM exit code: %llu",
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index a9376b6..8619070 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -255,7 +255,7 @@ int kvm__for_each_mem_bank(struct kvm *kvm, enum kvm_mem_type type,
  */
 void kvm__dump_mem(struct kvm *kvm, unsigned long addr, unsigned long size, int debug_fd);
 
-extern const char *kvm_exit_reasons[];
+const char *kvm__exit_reason_str(__u32 exit_reason);
 
 static inline bool host_ptr_in_ram(struct kvm *kvm, void *p)
 {
diff --git a/kvm.c b/kvm.c
index 96583f9..b416f6f 100644
--- a/kvm.c
+++ b/kvm.c
@@ -33,7 +33,7 @@
 
 #define DEFINE_KVM_EXIT_REASON(reason) [reason] = #reason
 
-const char *kvm_exit_reasons[] = {
+static const char * const kvm_exit_reasons[] = {
 	DEFINE_KVM_EXIT_REASON(KVM_EXIT_UNKNOWN),
 	DEFINE_KVM_EXIT_REASON(KVM_EXIT_EXCEPTION),
 	DEFINE_KVM_EXIT_REASON(KVM_EXIT_IO),
@@ -57,6 +57,14 @@ const char *kvm_exit_reasons[] = {
 #endif
 };
 
+const char *kvm__exit_reason_str(__u32 exit_reason)
+{
+	if (exit_reason >= ARRAY_SIZE(kvm_exit_reasons))
+		return "UNKNOWN";
+
+	return kvm_exit_reasons[exit_reason];
+}
+
 static int pause_event;
 static DEFINE_MUTEX(pause_lock);
 static struct kvm_cpu *pause_req_cpu;
-- 
2.39.5

