Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF17C37CD41
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 19:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785527793; cv=none; b=BuxXn0tElREXs3id9cjqM2oborGZjs9HFyVOvIe3u3kqEgWhF5f6Ku/AIOJv4tUqL06yEolg3aBbwI/NOkhxK4mN+5j/t/tzgY4eZmVFxDGBnttnx8JzRjS4Ua4q8HbY8YmYoW4JXD3cp6vmy6QgP50oAhfA7Y0rjiA9D9ioOg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785527793; c=relaxed/simple;
	bh=eFedP1FKrSCUz33LyUYB/hbFk56NqWKwZqQkDaFxLJ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Yav/3CQOORrfD7OYrFDwiDytamY9M7maTADUkBKHrLacCfu+ktFhj6YIJn6rMvlfCQ56WUvVz3RvAzP0WWdj6LvZNXcfgapGHlHh7obcgQZWd9kcDkbjVWjfI+43LoeeTeZw4MbpIEVHYKgB2uCD13GfI4B25CqLzCEV7bkNNwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VfBfcKMV; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VfBfcKMV"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cca5e0a0c9so22627175ad.1
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 12:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785527788; x=1786132588; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=t+9CTldHkmPcTJwS5mSWfk0XaYsDahSdFAriIqs5uQo=;
        b=VfBfcKMVgCqK17tWQ7d18d6a7HL/VJ0wayeEXKobwTqn0UKmPRKQRQQQzbu8s+frto
         NVLQ2BBdS78ERMeipyWXln+5rY6qlg+GMIEUGQzsczK386rBTBiPqgqDmiagjzXkBluI
         qZix3FG48klmzeCWcIYjX2w1jrQvlw3QMESJKacdQQzsLgQrN3EEwTHZ5nqbKCKWfigz
         HiwAfDZghTbVBC1NcuYoporSOs5qwgr9M0IksYcBFoR0eAiiSsRSoJvylqkd4UlZprgI
         qRv4U7WQ6SsIQGzBt5iOaUoaG0A9nVoP8AUG5QWyDIMvIT6hadgEBNipvGIZH4y5hET4
         OKkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785527788; x=1786132588;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t+9CTldHkmPcTJwS5mSWfk0XaYsDahSdFAriIqs5uQo=;
        b=Jg9zU4kxBRobVlhB8CN+DuUPIGWXlHBUGpEWZWEemtyB0OwWBisBc11TzZoRwvVcCi
         DBjFOLI6yZ6EW1EzVYQkjopbiZQ0MVejM9vI57r0sna6Wa/N4Ry/PPga4XRPIYFgFpo2
         5aNSIsXxcAXEa5W1xI/fymHZFcP41sLuB9xchSuJvp9dQ27IQuoBjgqqOjzwGb/IRIWo
         juLr0qkKp+TQslMRwrl8r9WpSlyMrSDp8OAimU897h4qlPyH/y5E7HGPiE1XUmyxwgcs
         X9Vb/k8bPUaw1w6Ndz2QoRxDkWCrGbVCJIbnBmn7JWcQSApi+XPSxj6JEFuqr/A0bI/L
         CQ3g==
X-Forwarded-Encrypted: i=1; AHgh+Rqj9sDWgKj27u78MXFUntZDQfoQVhFtuWN4rI/whbhDGkPN98BWi+7lydky28+CONHqhd9T3DU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyuP/kG/HspNh4bRwAmXs8an4h/A1yUneb/8Kvq/O0RbUMk4xhc
	USFWrb/I97YrfAiitIRzX+2vD6imGScUzz3eqM76Pc06tW71aCyJqSx7X/qFa/F5XJnSvuEQlIC
	JIWxVUg==
X-Received: from plbj20.prod.google.com ([2002:a17:903:4654:b0:2c6:be9a:d6c2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:26cd:b0:2cf:82e6:a5
 with SMTP id d9443c01a7336-2d0521bbfddmr11886345ad.13.1785527787901; Fri, 31
 Jul 2026 12:56:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 12:56:10 -0700
In-Reply-To: <20260731195612.2697986-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731195612.2697986-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731195612.2697986-11-seanjc@google.com>
Subject: [PATCH v3 10/12] KVM: selftests: Add helper APIs to cancel+join pthreads
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	David Hildenbrand <david@kernel.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Deduplicate test code that does cancel()+join() on pthreads by adding a
collection of syscall wrappers.  The tests that asynchronously cancel
pthreads, i.e. use PTHREAD_CANCEL_ASYNCHRONOUS, are particularly ugly,
especially since it's not immediately obvious why those tests assert on
the thread being CANCELED, whereas others do not.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_syscalls.h      | 24 +++++++++++++++++++
 tools/testing/selftests/kvm/x86/hyperv_ipi.c  | 15 ++----------
 .../selftests/kvm/x86/hyperv_tlb_flush.c      | 15 ++----------
 .../selftests/kvm/x86/recalc_apic_map_test.c  |  3 +--
 .../selftests/kvm/x86/sync_regs_test.c        |  3 +--
 .../selftests/kvm/x86/xapic_ipi_test.c        | 15 ++----------
 .../selftests/kvm/x86/xen_shinfo_test.c       |  3 +--
 7 files changed, 33 insertions(+), 45 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_syscalls.h b/tools/testing/selftests/kvm/include/kvm_syscalls.h
index d6c18e13b9c8..c0657e54aee5 100644
--- a/tools/testing/selftests/kvm/include/kvm_syscalls.h
+++ b/tools/testing/selftests/kvm/include/kvm_syscalls.h
@@ -104,6 +104,30 @@ __KVM_SYSCALL_DEFINE(pthread_create, 4, pthread_t *, thread,
 __KVM_SYSCALL_DEFINE(pthread_join, 2, pthread_t, thread, void **, thread_return);
 __KVM_SYSCALL_DEFINE(pthread_cancel, 1, pthread_t, thread);
 
+static inline void __kvm_pthread_cancel_join(pthread_t thread, void **r)
+{
+	kvm_pthread_cancel(thread);
+	kvm_pthread_join(thread, r);
+}
+
+static inline void kvm_pthread_cancel_join(pthread_t thread)
+{
+	__kvm_pthread_cancel_join(thread, NULL);
+}
+
+/*
+ * Cancel+Join a pthread that was configured with PTHREAD_CANCEL_ASYNCHRONOUS
+ * and is expected to exit only in response to cancellation.
+ */
+static inline void kvm_pthread_cancel_join_async(pthread_t thread)
+{
+	void *r;
+
+	__kvm_pthread_cancel_join(thread, &r);
+	TEST_ASSERT(r == PTHREAD_CANCELED,
+		    "expected retval=%p, got %p", PTHREAD_CANCELED, r);
+}
+
 #define kvm_free_fd(fd)		\
 do {				\
 	kvm_close(fd);		\
diff --git a/tools/testing/selftests/kvm/x86/hyperv_ipi.c b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
index d2efb1043534..a2fc0bca8011 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_ipi.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_ipi.c
@@ -222,17 +222,6 @@ static void *vcpu_thread(void *arg)
 	return NULL;
 }
 
-static void cancel_join_vcpu_thread(pthread_t thread, struct kvm_vcpu *vcpu)
-{
-	void *retval;
-
-	kvm_pthread_cancel(thread);
-	kvm_pthread_join(thread, &retval);
-	TEST_ASSERT(retval == PTHREAD_CANCELED,
-		    "expected retval=%p, got %p", PTHREAD_CANCELED,
-		    retval);
-}
-
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
@@ -293,8 +282,8 @@ int main(int argc, char *argv[])
 	}
 
 done:
-	cancel_join_vcpu_thread(threads[0], vcpu[1]);
-	cancel_join_vcpu_thread(threads[1], vcpu[2]);
+	kvm_pthread_cancel_join_async(threads[0]);
+	kvm_pthread_cancel_join_async(threads[1]);
 	kvm_vm_free(vm);
 
 	return 0;
diff --git a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
index e4fc9bb6f329..dc9d40830a7f 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
@@ -548,17 +548,6 @@ static void *vcpu_thread(void *arg)
 	return NULL;
 }
 
-static void cancel_join_vcpu_thread(pthread_t thread, struct kvm_vcpu *vcpu)
-{
-	void *retval;
-
-	kvm_pthread_cancel(thread);
-	kvm_pthread_join(thread, &retval);
-	TEST_ASSERT(retval == PTHREAD_CANCELED,
-		    "expected retval=%p, got %p", PTHREAD_CANCELED,
-		    retval);
-}
-
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
@@ -652,8 +641,8 @@ int main(int argc, char *argv[])
 	}
 
 done:
-	cancel_join_vcpu_thread(threads[0], vcpu[1]);
-	cancel_join_vcpu_thread(threads[1], vcpu[2]);
+	kvm_pthread_cancel_join_async(threads[0]);
+	kvm_pthread_cancel_join_async(threads[1]);
 	kvm_vm_free(vm);
 
 	return 0;
diff --git a/tools/testing/selftests/kvm/x86/recalc_apic_map_test.c b/tools/testing/selftests/kvm/x86/recalc_apic_map_test.c
index e3e397f32bff..6252a96320ee 100644
--- a/tools/testing/selftests/kvm/x86/recalc_apic_map_test.c
+++ b/tools/testing/selftests/kvm/x86/recalc_apic_map_test.c
@@ -65,8 +65,7 @@ int main(void)
 		vcpu_set_msr(vcpuN, MSR_IA32_APICBASE, LAPIC_DISABLED);
 	}
 
-	kvm_pthread_cancel(thread);
-	kvm_pthread_join(thread, NULL);
+	kvm_pthread_cancel_join(thread);
 
 	kvm_vm_free(vm);
 
diff --git a/tools/testing/selftests/kvm/x86/sync_regs_test.c b/tools/testing/selftests/kvm/x86/sync_regs_test.c
index 99a5bbeffc5d..ed0c21b427c9 100644
--- a/tools/testing/selftests/kvm/x86/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/x86/sync_regs_test.c
@@ -199,8 +199,7 @@ static void race_sync_regs(struct kvm_vcpu *vcpu, void *racer)
 		}
 	}
 
-	kvm_pthread_cancel(thread);
-	kvm_pthread_join(thread, NULL);
+	kvm_pthread_cancel_join(thread);
 
 	kvm_x86_state_cleanup(state);
 }
diff --git a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
index 33e78b284c67..469e3ab16460 100644
--- a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
@@ -228,17 +228,6 @@ static void *vcpu_thread(void *arg)
 	return NULL;
 }
 
-static void cancel_join_vcpu_thread(pthread_t thread, struct kvm_vcpu *vcpu)
-{
-	void *retval;
-
-	kvm_pthread_cancel(thread);
-	kvm_pthread_join(thread, &retval);
-	TEST_ASSERT(retval == PTHREAD_CANCELED,
-		    "expected retval=%p, got %p", PTHREAD_CANCELED,
-		    retval);
-}
-
 void do_migrations(struct test_data_page *data, int run_secs, int delay_usecs,
 		   u64 *pipis_rcvd)
 {
@@ -450,8 +439,8 @@ int main(int argc, char *argv[])
 	/*
 	 * Cancel threads and wait for them to stop.
 	 */
-	cancel_join_vcpu_thread(threads[0], params[0].vcpu);
-	cancel_join_vcpu_thread(threads[1], params[1].vcpu);
+	kvm_pthread_cancel_join_async(threads[0]);
+	kvm_pthread_cancel_join_async(threads[1]);
 
 	/*
 	 * If the host support Idle HLT, i.e. KVM *might* be using Idle HLT,
diff --git a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
index 3ec5e67b21ef..aaa414c677ad 100644
--- a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
@@ -947,8 +947,7 @@ int main(int argc, char *argv[])
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 
-				kvm_pthread_cancel(thread);
-				kvm_pthread_join(thread, 0);
+				kvm_pthread_cancel_join(thread);
 				goto done;
 
 			case TEST_GUEST_SAW_IRQ:
-- 
2.55.0.508.g3f0d502094-goog

