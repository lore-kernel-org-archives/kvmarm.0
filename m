Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089FE29A305
	for <kvmarm@lists.linux.dev>; Mon, 12 May 2025 18:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073080; cv=none; b=IVsjKO73sZ3xGQxOEhc8z1cUG0yJ3tIXXkR2dxARuXe2rOsVlDqf2nKBBdDRtexeb1nqbrxkLqZPZDUvDcvBbXgGfL3DrGGzmL2suyr1B9RVayVVIjBBaYaDJE5Lq9Cwo1wmOOVgECrrg4JDcw7wH4DziTIPO1wOPjw5DPRbrtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073080; c=relaxed/simple;
	bh=oBzmlHt0HTJa1iYabb2/WVIvO0yzC8VwyaNi+DS7efQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRhGy5aaadHh698xm062l6YRKKegpBJpktwTMkH26OK33WL0+ZSzpwv2cdPfH5ZjVHqKaCsSFSbbJ4dg7vFcefCloThDeOYqKBDlk27ffZrKQKrb3T+qPvk4KMS/DFYLsgTFzmAEsbril7r3pOnMdvsDBeeWFJXaVepixPIvwLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cdOvs6sn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cdOvs6sn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747073078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z2T7ycCKwqZIMsv2I6XJvuhGXIY81vCrox7I0j0GM+0=;
	b=cdOvs6sn9uEzNzywegXP6shEo8ZBbZEgnXwfw6xyqEQCZcNO7sk3p/15wOaaG0fGxi/aqV
	Kju2g6g1dLo6X3jKXzMsQAEWBymdQ4+BKlusM7Ah+ANVD/fnSv/kWn5aQEFjsXAQLIsesl
	oBTa6QwdAMLHPuktw3X21NJUm40Ayl8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-418-bCO2M7_lMsCo5R7BHCagxQ-1; Mon,
 12 May 2025 14:04:36 -0400
X-MC-Unique: bCO2M7_lMsCo5R7BHCagxQ-1
X-Mimecast-MFC-AGG-ID: bCO2M7_lMsCo5R7BHCagxQ_1747073066
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 987FE1955D4A;
	Mon, 12 May 2025 18:04:25 +0000 (UTC)
Received: from intellaptop.lan (unknown [10.22.80.5])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B654930001A1;
	Mon, 12 May 2025 18:04:17 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sebastian Ott <sebott@redhat.com>,
	Shusen Li <lishusen2@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Anup Patel <anup@brainfault.org>,
	Will Deacon <will@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexander Potapenko <glider@google.com>,
	kvmarm@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Atish Patra <atishp@atishpatra.org>,
	Joey Gouly <joey.gouly@arm.com>,
	x86@kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	linux-riscv@lists.infradead.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	kvm-riscv@lists.infradead.org,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH v5 1/6] locking/mutex: implement mutex_trylock_nested
Date: Mon, 12 May 2025 14:04:02 -0400
Message-ID: <20250512180407.659015-2-mlevitsk@redhat.com>
In-Reply-To: <20250512180407.659015-1-mlevitsk@redhat.com>
References: <20250512180407.659015-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Despite the fact that several lockdep-related checks are skipped when
calling trylock* versions of the locking primitives, for example
mutex_trylock, each time the mutex is acquired, a held_lock is still
placed onto the lockdep stack by __lock_acquire() which is called
regardless of whether the trylock* or regular locking API was used.

This means that if the caller successfully acquires more than
MAX_LOCK_DEPTH locks of the same class, even when using mutex_trylock,
lockdep will still complain that the maximum depth of the held lock stack
has been reached and disable itself.

For example, the following error currently occurs in the ARM version
of KVM, once the code tries to lock all vCPUs of a VM configured with more
than MAX_LOCK_DEPTH vCPUs, a situation that can easily happen on modern
systems, where having more than 48 CPUs is common, and it's also common to
run VMs that have vCPU counts approaching that number:

[  328.171264] BUG: MAX_LOCK_DEPTH too low!
[  328.175227] turning off the locking correctness validator.
[  328.180726] Please attach the output of /proc/lock_stat to the bug report
[  328.187531] depth: 48  max: 48!
[  328.190678] 48 locks held by qemu-kvm/11664:
[  328.194957]  #0: ffff800086de5ba0 (&kvm->lock){+.+.}-{3:3}, at: kvm_ioctl_create_device+0x174/0x5b0
[  328.204048]  #1: ffff0800e78800b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.212521]  #2: ffff07ffeee51e98 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.220991]  #3: ffff0800dc7d80b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.229463]  #4: ffff07ffe0c980b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.237934]  #5: ffff0800a3883c78 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
[  328.246405]  #6: ffff07fffbe480b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0

Luckily, in all instances that require locking all vCPUs, the
'kvm->lock' is taken a priori, and that fact makes it possible to use
the little known feature of lockdep, called a 'nest_lock', to avoid this
warning and subsequent lockdep self-disablement.

The action of 'nested lock' being provided to lockdep's lock_acquire(),
causes the lockdep to detect that the top of the held lock stack contains
a lock of the same class and then increment its reference counter instead
of pushing a new held_lock item onto that stack.

See __lock_acquire for more information.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 include/linux/mutex.h  | 15 +++++++++++++++
 kernel/locking/mutex.c | 14 +++++++++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 2143d05116be..da4518cfd59c 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -193,7 +193,22 @@ extern void mutex_lock_io(struct mutex *lock);
  *
  * Returns 1 if the mutex has been acquired successfully, and 0 on contention.
  */
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+extern int _mutex_trylock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock);
+
+#define mutex_trylock_nest_lock(lock, nest_lock)		\
+(								\
+	typecheck(struct lockdep_map *, &(nest_lock)->dep_map),	\
+	_mutex_trylock_nest_lock(lock, &(nest_lock)->dep_map)	\
+)
+
+#define mutex_trylock(lock) _mutex_trylock_nest_lock(lock, NULL)
+#else
 extern int mutex_trylock(struct mutex *lock);
+#define mutex_trylock_nest_lock(lock, nest_lock) mutex_trylock(lock)
+#endif
+
 extern void mutex_unlock(struct mutex *lock);
 
 extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 555e2b3a665a..c75a838d3bae 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -1062,6 +1062,7 @@ __ww_mutex_lock_interruptible_slowpath(struct ww_mutex *lock,
 
 #endif
 
+#ifndef CONFIG_DEBUG_LOCK_ALLOC
 /**
  * mutex_trylock - try to acquire the mutex, without waiting
  * @lock: the mutex to be acquired
@@ -1077,18 +1078,25 @@ __ww_mutex_lock_interruptible_slowpath(struct ww_mutex *lock,
  * mutex must be released by the same task that acquired it.
  */
 int __sched mutex_trylock(struct mutex *lock)
+{
+	MUTEX_WARN_ON(lock->magic != lock);
+	return __mutex_trylock(lock);
+}
+EXPORT_SYMBOL(mutex_trylock);
+#else
+int __sched _mutex_trylock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock)
 {
 	bool locked;
 
 	MUTEX_WARN_ON(lock->magic != lock);
-
 	locked = __mutex_trylock(lock);
 	if (locked)
-		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		mutex_acquire_nest(&lock->dep_map, 0, 1, nest_lock, _RET_IP_);
 
 	return locked;
 }
-EXPORT_SYMBOL(mutex_trylock);
+EXPORT_SYMBOL(_mutex_trylock_nest_lock);
+#endif
 
 #ifndef CONFIG_DEBUG_LOCK_ALLOC
 int __sched
-- 
2.46.0

