Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B3F94E324C
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 15:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660216; cv=none; b=HblxDsxYIc+q56axZ7CMtFJDwZ7pyq+9TJt4SayOZz/xQWr5yu1RSz2oT0FqAtRi7DLGOe6dfMRisUVvQmDusYSGRJOsLmyJ/6QXA652ZmkIStonWzJzi5yKkmIwFZFE2edIdgvx/bqNfRe+2s1TpQiJ6V4dpK3BmVAZX9tJ0Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660216; c=relaxed/simple;
	bh=cHsGbWLCLxXBI4lUtqUmuQxwVcmNT7ZyqT4IRSi2tiE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsTDgkUDImGUnCeqEMyGUwqwZbiuBYwKxZn1smhfLhIHRZ0+yDww8I+ZlSxa5jCHHcfGC3ziGvk+FsrYiaZUuM1MET8Fov8ozaqmIdw6/G2MxE1EvXzbUcDdaZuz3SpZHX8Ko2mR5UuimtS5y04BC1BJlHszRGWgYU4BVAR45OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=r3OvUjxL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="r3OvUjxL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BEB01476;
	Thu, 17 Sep 2026 08:50:01 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 843423FAF5;
	Thu, 17 Sep 2026 08:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789660205; bh=cHsGbWLCLxXBI4lUtqUmuQxwVcmNT7ZyqT4IRSi2tiE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=r3OvUjxLq4CfRvuueg+rGjG5kpnwf2lfALvWD7a1eVpboIgHqK04/GMdNVKNUvjVr
	 mtEVm79IjfkjZ7UewRBSJhs8KK9Iv/4/fG+1hG9PKIDycozpUI7UNlYKOg0UkQHWGr
	 NdIYPGWY5euvvJdgOVmpul5ZFvNFzu9SzBet5sqA=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	kvm@vger.kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [RFC PATCH kvmtool 7/7] Don't apply --vcpu-affinity to threads spawned from VCPUs
Date: Thu, 17 Sep 2026 16:49:32 +0100
Message-ID: <20260917154932.193943-8-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917154932.193943-1-alexandru.elisei@arm.com>
References: <20260917154932.193943-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Threads spawned with pthread_create() inherit the parent's affinity. For
kvmtool, threads spawned from the VCPU threads, like the virtio threads,
will inherit the affinity specified with --vcpu-affinity, instead of
inheriting the main process' affinity. Make kvm_create_thread() use the
main thread's affinity when spawning new threads.

A command like this:

$ taskset -c 0-5 ./lkvm run .. --vcpu-affinity 6-11

will work as expected and all kvmtool threads will be pinned to CPUs 0-5,
instead of some of them being pinned on the same CPUs as the VCPUs.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm64/pmu.c       | 19 +++----------------
 include/kvm/kvm.h |  1 +
 kvm.c             | 15 +++++++++++++++
 util/util.c       | 33 +++++++++++++++++----------------
 4 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/arm64/pmu.c b/arm64/pmu.c
index bd3f225842be..10d1641b42cc 100644
--- a/arm64/pmu.c
+++ b/arm64/pmu.c
@@ -200,20 +200,10 @@ static int find_pmu(struct kvm *kvm)
 
 	setsize = CPU_ALLOC_SIZE(NR_CPUS);
 
-	if (kvm->vcpu_affinity) {
+	if (kvm->vcpu_affinity)
 		affinity = kvm->vcpu_affinity;
-	} else {
-		affinity = CPU_ALLOC(NR_CPUS);
-		if (!affinity)
-			die_perror("CPU_ALLOC");
-		CPU_ZERO_S(setsize, affinity);
-
-		ret = sched_getaffinity(0, setsize, affinity);
-		if (ret < 0) {
-			ret = -errno;
-			goto out_free;
-		}
-	}
+	else
+		affinity = kvm->main_affinity;
 
 	for (i = 0; i < NR_CPUS; i ++) {
 		if (CPU_ISSET_S(i, setsize, affinity))
@@ -222,10 +212,7 @@ static int find_pmu(struct kvm *kvm)
 
 	ret = find_pmu_cpumask(kvm, cpumask);
 
-out_free:
 	free(cpumask);
-	if (!kvm->vcpu_affinity)
-		CPU_FREE(affinity);
 	return ret;
 }
 
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 01c4f5fa952d..91a30bbbbfd0 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -102,6 +102,7 @@ struct kvm {
 	int                     nr_disks;
 
 	int			vm_state;
+	cpu_set_t		*main_affinity;
 	cpu_set_t		*vcpu_affinity;
 
 #ifdef KVM_BRLOCK_DEBUG
diff --git a/kvm.c b/kvm.c
index e29b73d27f33..7bc91cce97b0 100644
--- a/kvm.c
+++ b/kvm.c
@@ -156,6 +156,9 @@ static int kvm__check_extensions(struct kvm *kvm)
 struct kvm *kvm__new(void)
 {
 	struct kvm *kvm = calloc(1, sizeof(*kvm));
+	size_t setsize;
+	int ret;
+
 	if (!kvm)
 		return ERR_PTR(-ENOMEM);
 
@@ -168,6 +171,17 @@ struct kvm *kvm__new(void)
 	kvm->brlock_sem = (pthread_rwlock_t) PTHREAD_RWLOCK_INITIALIZER;
 #endif
 
+	kvm->main_affinity = CPU_ALLOC(NR_CPUS);
+	if (!kvm->main_affinity)
+		die_perror("CPU_ALLOC");
+
+	setsize = CPU_ALLOC_SIZE(NR_CPUS);
+	CPU_ZERO_S(setsize, kvm->main_affinity);
+
+	ret = sched_getaffinity(0, setsize, kvm->main_affinity);
+	if (ret)
+		die_perror("sched_getaffinity");
+
 	return kvm;
 }
 
@@ -182,6 +196,7 @@ int kvm__exit(struct kvm *kvm)
 		free(bank);
 	}
 
+	CPU_FREE(kvm->main_affinity);
 	if (kvm->vcpu_affinity)
 		CPU_FREE(kvm->vcpu_affinity);
 
diff --git a/util/util.c b/util/util.c
index 7238fe57bace..a779eb59817c 100644
--- a/util/util.c
+++ b/util/util.c
@@ -207,28 +207,15 @@ void *mmap_guest_memfd(struct kvm *kvm, u64 size)
 	return addr;
 }
 
-int kvm_create_thread(struct kvm *kvm, pthread_t *thread,
-		      void *(*start_routine)(void *), void *arg)
-{
-	int ret;
-
-	ret = pthread_create(thread, NULL, start_routine, arg);
-	if (ret)
-		errno = ret;
-
-	return -ret;
-}
-
-int kvm_create_vcpu_thread(struct kvm *kvm, pthread_t *thread,
-			   void *(*start_routine)(void *), void *arg)
+static int __kvm_create_thread(struct kvm *kvm, cpu_set_t *affinity,
+			       pthread_t *thread, void *(*start_routine)(void *),
+			       void *arg)
 {
 	pthread_attr_t attr;
-	cpu_set_t *affinity;
 	int ret;
 
 	pthread_attr_init(&attr);
 
-	affinity = kvm->vcpu_affinity;
 	if (affinity) {
 		ret = pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), affinity);
 		if (ret) {
@@ -247,3 +234,17 @@ int kvm_create_vcpu_thread(struct kvm *kvm, pthread_t *thread,
 
 	return -ret;
 }
+
+int kvm_create_thread(struct kvm *kvm, pthread_t *thread,
+		      void *(*start_routine)(void *), void *arg)
+{
+	return __kvm_create_thread(kvm, kvm->main_affinity, thread,
+				   start_routine, arg);
+}
+
+int kvm_create_vcpu_thread(struct kvm *kvm, pthread_t *thread,
+			   void *(*start_routine)(void *), void *arg)
+{
+	return __kvm_create_thread(kvm, kvm->vcpu_affinity, thread,
+				   start_routine, arg);
+}
-- 
2.55.0

