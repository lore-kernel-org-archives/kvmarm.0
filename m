Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FEC78C60
	for <kvmarm@lists.linux.dev>; Fri,  2 Aug 2024 20:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722628906; cv=none; b=b0e1nBVDd/IuvAKPi7lyBQRSQjX0GitPxrqwxhuvOS9rPle9ILAznhf/+h4FrMhPX8lA4hqB2QK9sLFjxLWVT1CR9DEq6Uaw3UnTgYIOB8WfaniApMeemkNkk3Qu6s2u9FqgXCN7V+g/WdCqCNeWYusQpZ7y9i8kpbsCWbYSm6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722628906; c=relaxed/simple;
	bh=YXcCG8Han6oPFZMVR5EJq3rsCuUTs8798czh5TGgT6g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J+T8DPfsUbUOzAC6z64Su1H2Erb4qVWegzUl86U2rTYbhwZij/nSKN3OsZZ1CO5d2ZBs27UeUBmtYeigR8+AnBaJGy29vQNnrXZGN+XGK0gBSD9o1Z/vAJL/yzdrNIelewfe8NWZLEzQtVDHU8EkeXhqRVO/aca2yPuwv8vhW9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nE375lCW; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nE375lCW"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-664916e5b40so58526457b3.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Aug 2024 13:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722628904; x=1723233704; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ykfKcxdUa9fLrTb96clu+XLU5WSDBheRMe8+PcsjFjM=;
        b=nE375lCWPm1V7h18Os6imGRlw9KBmPzrEMGAyTNXNH4thtB8DkWW7n6TM0RIigje7q
         LQco1+JK12jxBaaH3BYyPVO1i43GMRoCnw5DEddiAPGA74JNkpRc+JBj9Dvxe69zgdQZ
         ECsbKWAfasnzw+ZHC05a1BAgromcjE2Uz2xLBwxxdWReMnqbiN4yfzxoxxCjWZgtyh6t
         S8Eu2U4Gr0XQyrwBsagfthL7y9HnbiNaIgELyXpZxt5NgmWgri1xVNElK7ZY+afzjV8f
         GoAuqEuO8hQ7zA/+vbnDWJ/F+026MMigmJvW6j6GowFHtnk//oY0HLGBcMO6IzsHW1x9
         NqKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722628904; x=1723233704;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ykfKcxdUa9fLrTb96clu+XLU5WSDBheRMe8+PcsjFjM=;
        b=WZ4c8ABZZvDdWA4u2Tnur+zirr0TAxh5pmDkj3gaSVHwbA8LMKwaM+Keluk/jeZhCC
         PgKjgCmtXmrg5a6NVa4d4d2u5/ZiCal5AY5e+y/kBA3UJxsMOpaLn6xybDQYvvuJorhY
         ICyIsyGPB4QjgzMQfOB85nZAS3ZuNh5WT8ZHrTSbSIRF0r8/bT13dKOU6xzttFG6GgZb
         v4+XbtfKzSghtLm/ToBY+wm/VRnJrjlGBm7ZFA73y1Gqw3dOtCwPQvjZoCGZ1IOPUC/L
         ETdNldDkQSCWsTe37JYZf3q3woT4kPJNrX+8PCFw4B6lEjKk8v7aVULuwidWK9J7SMLv
         srUA==
X-Forwarded-Encrypted: i=1; AJvYcCWoGMJs3k1Tz82EJEA6uNsoq4ARPKn+f058QeU8G3LWGD6XTRgyh/MXqAOOVn7coS48q/g2gr0suQm4q78dMZknjNMBmdTz
X-Gm-Message-State: AOJu0YzbLrV5Ek62UA8FLSlMpTtir14Tb8fwCkUixPynGLUrbvI4xish
	8PgMU4Fm1iN9Try6rOFu8Ktjoi/kY9/wdjW4ewVCS193NE8J+dPob8mKINxKjQUKyZz6YAfUpLW
	tCw==
X-Google-Smtp-Source: AGHT+IGvtD2k+Z8XEDfN/3DgERyf+vS3FmJyCb7y6ktKFZouZ8vRLWbcTwmFsQsX8ntvC2Xbw1LZ/rv2S6Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2901:b0:644:c4d6:add0 with SMTP id
 00721157ae682-6884f7ffdfcmr402097b3.1.1722628903604; Fri, 02 Aug 2024
 13:01:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 13:01:36 -0700
In-Reply-To: <20240802200136.329973-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240802200136.329973-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802200136.329973-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: Protect vCPU's "last run PID" with rwlock, not RCU
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Steve Rutherford <srutherford@google.com>
Content-Type: text/plain; charset="UTF-8"

To avoid jitter on KVM_RUN due to synchronize_rcu(), use a rwlock instead
of RCU to protect vcpu->pid, a.k.a. the pid of the task last used to a
vCPU.  When userspace is doing M:N scheduling of tasks to vCPUs, e.g. to
run SEV migration helper vCPUs during post-copy, the synchronize_rcu()
needed to change the PID associated with the vCPU can stall for hundreds
of milliseconds, which is problematic for latency sensitive post-copy
operations.

In the directed yield path, do not acquire the lock if it's contended,
i.e. if the associated PID is changing, as that means the vCPU's task is
already running.

Reported-by: Steve Rutherford <srutherford@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 include/linux/kvm_host.h          |  3 ++-
 virt/kvm/kvm_main.c               | 32 +++++++++++++++++--------------
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a33f5996ca9f..7199cb014806 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1115,7 +1115,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
-#define vcpu_has_run_once(vcpu)	!!rcu_access_pointer((vcpu)->pid)
+#define vcpu_has_run_once(vcpu)	(!!READ_ONCE((vcpu)->pid))
 
 #ifndef __KVM_NVHE_HYPERVISOR__
 #define kvm_call_hyp_nvhe(f, ...)						\
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 689e8be873a7..d6f4e8b2b44c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -342,7 +342,8 @@ struct kvm_vcpu {
 #ifndef __KVM_HAVE_ARCH_WQP
 	struct rcuwait wait;
 #endif
-	struct pid __rcu *pid;
+	struct pid *pid;
+	rwlock_t pid_lock;
 	int sigset_active;
 	sigset_t sigset;
 	unsigned int halt_poll_ns;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 91048a7ad3be..fabffd85fa34 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -486,6 +486,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->kvm = kvm;
 	vcpu->vcpu_id = id;
 	vcpu->pid = NULL;
+	rwlock_init(&vcpu->pid_lock);
 #ifndef __KVM_HAVE_ARCH_WQP
 	rcuwait_init(&vcpu->wait);
 #endif
@@ -513,7 +514,7 @@ static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	 * the vcpu->pid pointer, and at destruction time all file descriptors
 	 * are already gone.
 	 */
-	put_pid(rcu_dereference_protected(vcpu->pid, 1));
+	put_pid(vcpu->pid);
 
 	free_page((unsigned long)vcpu->run);
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
@@ -3930,15 +3931,17 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
 
 int kvm_vcpu_yield_to(struct kvm_vcpu *target)
 {
-	struct pid *pid;
 	struct task_struct *task = NULL;
 	int ret;
 
-	rcu_read_lock();
-	pid = rcu_dereference(target->pid);
-	if (pid)
-		task = get_pid_task(pid, PIDTYPE_PID);
-	rcu_read_unlock();
+	if (!read_trylock(&target->pid_lock))
+		return 0;
+
+	if (target->pid)
+		task = get_pid_task(target->pid, PIDTYPE_PID);
+
+	read_unlock(&target->pid_lock);
+
 	if (!task)
 		return 0;
 	ret = yield_to(task, 1);
@@ -4178,9 +4181,9 @@ static int vcpu_get_pid(void *data, u64 *val)
 {
 	struct kvm_vcpu *vcpu = data;
 
-	rcu_read_lock();
-	*val = pid_nr(rcu_dereference(vcpu->pid));
-	rcu_read_unlock();
+	read_lock(&vcpu->pid_lock);
+	*val = pid_nr(vcpu->pid);
+	read_unlock(&vcpu->pid_lock);
 	return 0;
 }
 
@@ -4466,7 +4469,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		r = -EINVAL;
 		if (arg)
 			goto out;
-		oldpid = rcu_access_pointer(vcpu->pid);
+		oldpid = vcpu->pid;
 		if (unlikely(oldpid != task_pid(current))) {
 			/* The thread running this VCPU changed. */
 			struct pid *newpid;
@@ -4476,9 +4479,10 @@ static long kvm_vcpu_ioctl(struct file *filp,
 				break;
 
 			newpid = get_task_pid(current, PIDTYPE_PID);
-			rcu_assign_pointer(vcpu->pid, newpid);
-			if (oldpid)
-				synchronize_rcu();
+			write_lock(&vcpu->pid_lock);
+			vcpu->pid = newpid;
+			write_unlock(&vcpu->pid_lock);
+
 			put_pid(oldpid);
 		}
 		vcpu->wants_to_run = !READ_ONCE(vcpu->run->immediate_exit__unsafe);
-- 
2.46.0.rc2.264.g509ed76dc8-goog

