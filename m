Return-Path: <SRS0=13S2=NC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C4FC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 12:23:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F0DEE6101E
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 12:23:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F0DEE6101E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55FFF4064F;
	Wed, 11 Aug 2021 08:23:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oNMk9za1SO0j; Wed, 11 Aug 2021 08:23:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E661F49F5F;
	Wed, 11 Aug 2021 08:23:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1490940856
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 08:23:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XuUhsAgAt98c for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Aug 2021 08:23:31 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E09A4064F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 08:23:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628684610;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=y+vIRCIEBNPiZxd3aPkEVCtJRnECofb6ATzwMF02AG0=;
 b=gsY35lGL3fPESoBPKYwc7nZHg06E2fFJOJKELNc4ylVOvUNXjDkDAevxLTgBXtFcwO/MvD
 nxBdDzhL8ffruvApuKaNnSIXECFAqPwx6K0PjxEYoPX1HhDA7B9/KmbZGh2vQKkb9MT3/J
 8f2FNzgegi6oPmrlOErDpL4jkZN0gVk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-6-2i18E5OHq8-Eltc8Cx7Q-1; Wed, 11 Aug 2021 08:23:29 -0400
X-MC-Unique: 6-2i18E5OHq8-Eltc8Cx7Q-1
Received: by mail-ej1-f71.google.com with SMTP id
 ja25-20020a1709079899b02905b2a2bf1a62so617242ejc.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 05:23:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=y+vIRCIEBNPiZxd3aPkEVCtJRnECofb6ATzwMF02AG0=;
 b=DXk4GJgg+9PPwawuSJzQL/DTcli+PCJ7JkOB+fgRyhYuuNBbVRopMOKGDhWCg6Nj3l
 3ngrjetjd0xnXDDSMO9QSX4unQ1lBUI75RpRI03F6d4gph6M8r8xb1gs9nLSJ8/5/USY
 qwwCSJXf/Og0JfBRkpLxIl9Bw1payi1itdSpQgWUXY9IryWSBkd8h50GROHptY3tVOVp
 q2E2tP7AR3JJaQYwAcENxPk/5Fp9c+g9Vb3qaeRc54UDuX4RHeprRbI0yr3vxkIclcbn
 k7+2dsQlNgVf8TwxS01n2qPc6knrzplSqJo3b7rRyWMRaxs4lQvzOpUY9pKR3d58gypV
 dwjw==
X-Gm-Message-State: AOAM5319VAsb57NOqBwPehpF5eOBPnyY3rIviH3wu8zJyk11aEnyUspQ
 WmkiR8hC2IQ5474MlzxxapP4orfV6bM98+9F//Fcj7qgB9oJLfQG8TYmkhR/cbK8eWjLQN4CZLQ
 zvxTNHvzbqHkze71f7xoygDyf
X-Received: by 2002:a05:6402:5210:: with SMTP id
 s16mr11207369edd.343.1628684608345; 
 Wed, 11 Aug 2021 05:23:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9izQQ4pSzCAywJGWwpUx4uStMGwprYlBWkpymRc1hMb3MBsGF2Qkfwg/Vq+iaMHLB9z8VvA==
X-Received: by 2002:a05:6402:5210:: with SMTP id
 s16mr11207330edd.343.1628684608110; 
 Wed, 11 Aug 2021 05:23:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045?
 ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
 by smtp.gmail.com with ESMTPSA id c6sm11062504ede.48.2021.08.11.05.23.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 11 Aug 2021 05:23:26 -0700 (PDT)
To: Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-2-oupton@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v6 01/21] KVM: x86: Fix potential race in KVM_GET_CLOCK
Message-ID: <78eeaf83-2bfa-8452-1301-a607fba7fa0c@redhat.com>
Date: Wed, 11 Aug 2021 14:23:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210804085819.846610-2-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Sean Christopherson <seanjc@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 04/08/21 10:57, Oliver Upton wrote:
> Sean noticed that KVM_GET_CLOCK was checking kvm_arch.use_master_clock
> outside of the pvclock sync lock. This is problematic, as the clock
> value written to the user may or may not actually correspond to a stable
> TSC.
> 
> Fix the race by populating the entire kvm_clock_data structure behind
> the pvclock_gtod_sync_lock.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>   arch/x86/kvm/x86.c | 39 ++++++++++++++++++++++++++++-----------
>   1 file changed, 28 insertions(+), 11 deletions(-)

I had a completely independent patch that fixed the same race.  It unifies
the read sides of tsc_write_lock and pvclock_gtod_sync_lock into a seqcount
(and replaces pvclock_gtod_sync_lock with kvm->lock on the write side).

I attach it now (based on https://lore.kernel.org/kvm/20210811102356.3406687-1-pbonzini@redhat.com/T/#t),
but the testing was extremely light so I'm not sure I will be able to include
it in 5.15.

Paolo

-------------- 8< -------------
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 8 Apr 2021 05:03:44 -0400
Subject: [PATCH] kvm: x86: protect masterclock with a seqcount

Protect the reference point for kvmclock with a seqcount, so that
kvmclock updates for all vCPUs can proceed in parallel.  Xen runstate
updates will also run in parallel and not bounce the kvmclock cacheline.

This also makes it possible to use KVM_REQ_CLOCK_UPDATE (which will
block on the seqcount) to prevent entering in the guests until
pvclock_update_vm_gtod_copy is complete, and thus to get rid of
KVM_REQ_MCLOCK_INPROGRESS.

nr_vcpus_matched_tsc is updated outside pvclock_update_vm_gtod_copy
though, so a spinlock must be kept for that one.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 8138201efb09..ed41da172e02 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -29,6 +29,8 @@ The acquisition orders for mutexes are as follows:
  
  On x86:
  
+- the seqcount kvm->arch.pvclock_sc is written under kvm->lock.
+
  - vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock
  
  - kvm->arch.mmu_lock is an rwlock.  kvm->arch.tdp_mmu_pages_lock is
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 20daaf67a5bf..6889aab92362 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -68,8 +68,7 @@
  #define KVM_REQ_PMI			KVM_ARCH_REQ(11)
  #define KVM_REQ_SMI			KVM_ARCH_REQ(12)
  #define KVM_REQ_MASTERCLOCK_UPDATE	KVM_ARCH_REQ(13)
-#define KVM_REQ_MCLOCK_INPROGRESS \
-	KVM_ARCH_REQ_FLAGS(14, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+/* 14 unused */
  #define KVM_REQ_SCAN_IOAPIC \
  	KVM_ARCH_REQ_FLAGS(15, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
  #define KVM_REQ_GLOBAL_CLOCK_UPDATE	KVM_ARCH_REQ(16)
@@ -1067,6 +1066,11 @@ struct kvm_arch {
  
  	unsigned long irq_sources_bitmap;
  	s64 kvmclock_offset;
+
+	/*
+	 * This also protects nr_vcpus_matched_tsc which is read from a
+	 * preemption-disabled region, so it must be a raw spinlock.
+	 */
  	raw_spinlock_t tsc_write_lock;
  	u64 last_tsc_nsec;
  	u64 last_tsc_write;
@@ -1077,7 +1081,7 @@ struct kvm_arch {
  	u64 cur_tsc_generation;
  	int nr_vcpus_matched_tsc;
  
-	spinlock_t pvclock_gtod_sync_lock;
+	seqcount_mutex_t pvclock_sc;
  	bool use_master_clock;
  	u64 master_kernel_ns;
  	u64 master_cycle_now;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 74145a3fd4f2..7d73c5560260 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2533,9 +2533,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
  	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
  
  	kvm_vcpu_write_tsc_offset(vcpu, offset);
-	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
  
-	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
  	if (!matched) {
  		kvm->arch.nr_vcpus_matched_tsc = 0;
  	} else if (!already_matched) {
@@ -2543,7 +2541,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
  	}
  
  	kvm_track_tsc_matching(vcpu);
-	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
+	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
  }
  
  static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
@@ -2730,9 +2728,7 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
  	struct kvm_arch *ka = &kvm->arch;
  	int vclock_mode;
  	bool host_tsc_clocksource, vcpus_matched;
-
-	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
-			atomic_read(&kvm->online_vcpus));
+	unsigned long flags;
  
  	/*
  	 * If the host uses TSC clock, then passthrough TSC as stable
@@ -2742,9 +2738,14 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
  					&ka->master_kernel_ns,
  					&ka->master_cycle_now);
  
+	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
+	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
+			atomic_read(&kvm->online_vcpus));
+
  	ka->use_master_clock = host_tsc_clocksource && vcpus_matched
  				&& !ka->backwards_tsc_observed
  				&& !ka->boot_vcpu_runs_old_kvmclock;
+	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
  
  	if (ka->use_master_clock)
  		atomic_set(&kvm_guest_has_master_clock, 1);
@@ -2758,25 +2759,26 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
  static void kvm_start_pvclock_update(struct kvm *kvm)
  {
  	struct kvm_arch *ka = &kvm->arch;
-	kvm_make_all_cpus_request(kvm, KVM_REQ_MCLOCK_INPROGRESS);
  
-	/* no guest entries from this point */
-	spin_lock_irq(&ka->pvclock_gtod_sync_lock);
+	mutex_lock(&kvm->lock);
+	/*
+	 * write_seqcount_begin disables preemption.  This is needed not just
+	 * to avoid livelock, but also because the preempt notifier is a reader
+	 * for ka->pvclock_sc.
+	 */
+	write_seqcount_begin(&ka->pvclock_sc);
+	kvm_make_all_cpus_request(kvm,
+		KVM_REQ_CLOCK_UPDATE | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP);
+
+	/* no guest entries from this point until write_seqcount_end */
  }
  
  static void kvm_end_pvclock_update(struct kvm *kvm)
  {
  	struct kvm_arch *ka = &kvm->arch;
-	struct kvm_vcpu *vcpu;
-	int i;
  
-	spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
-
-	/* guest entries allowed */
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_clear_request(KVM_REQ_MCLOCK_INPROGRESS, vcpu);
+	write_seqcount_end(&ka->pvclock_sc);
+	mutex_unlock(&kvm->lock);
  }
  
  static void kvm_update_masterclock(struct kvm *kvm)
@@ -2787,27 +2789,21 @@ static void kvm_update_masterclock(struct kvm *kvm)
  	kvm_end_pvclock_update(kvm);
  }
  
-u64 get_kvmclock_ns(struct kvm *kvm)
+static u64 __get_kvmclock_ns(struct kvm *kvm)
  {
  	struct kvm_arch *ka = &kvm->arch;
  	struct pvclock_vcpu_time_info hv_clock;
-	unsigned long flags;
  	u64 ret;
  
-	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
-	if (!ka->use_master_clock) {
-		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
+	if (!ka->use_master_clock)
  		return get_kvmclock_base_ns() + ka->kvmclock_offset;
-	}
-
-	hv_clock.tsc_timestamp = ka->master_cycle_now;
-	hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
-	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
  
  	/* both __this_cpu_read() and rdtsc() should be on the same cpu */
  	get_cpu();
  
  	if (__this_cpu_read(cpu_tsc_khz)) {
+		hv_clock.tsc_timestamp = ka->master_cycle_now;
+		hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
  		kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
  				   &hv_clock.tsc_shift,
  				   &hv_clock.tsc_to_system_mul);
@@ -2816,6 +2812,19 @@ u64 get_kvmclock_ns(struct kvm *kvm)
  		ret = get_kvmclock_base_ns() + ka->kvmclock_offset;
  
  	put_cpu();
+	return ret;
+}
+
+u64 get_kvmclock_ns(struct kvm *kvm)
+{
+	struct kvm_arch *ka = &kvm->arch;
+	unsigned seq;
+	u64 ret;
+
+	do {
+		seq = read_seqcount_begin(&ka->pvclock_sc);
+		ret = __get_kvmclock_ns(kvm);
+	} while (read_seqcount_retry(&ka->pvclock_sc, seq));
  
  	return ret;
  }
@@ -2882,6 +2891,7 @@ static void kvm_setup_pvclock_page(struct kvm_vcpu *v,
  static int kvm_guest_time_update(struct kvm_vcpu *v)
  {
  	unsigned long flags, tgt_tsc_khz;
+	unsigned seq;
  	struct kvm_vcpu_arch *vcpu = &v->arch;
  	struct kvm_arch *ka = &v->kvm->arch;
  	s64 kernel_ns;
@@ -2896,13 +2906,14 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
  	 * If the host uses TSC clock, then passthrough TSC as stable
  	 * to the guest.
  	 */
-	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
-	use_master_clock = ka->use_master_clock;
-	if (use_master_clock) {
-		host_tsc = ka->master_cycle_now;
-		kernel_ns = ka->master_kernel_ns;
-	}
-	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
+	seq = read_seqcount_begin(&ka->pvclock_sc);
+	do {
+		use_master_clock = ka->use_master_clock;
+		if (use_master_clock) {
+			host_tsc = ka->master_cycle_now;
+			kernel_ns = ka->master_kernel_ns;
+		}
+	} while (read_seqcount_retry(&ka->pvclock_sc, seq));
  
  	/* Keep irq disabled to prevent changes to the clock */
  	local_irq_save(flags);
@@ -6098,11 +6109,13 @@ long kvm_arch_vm_ioctl(struct file *filp,
  	}
  	case KVM_GET_CLOCK: {
  		struct kvm_clock_data user_ns;
-		u64 now_ns;
+		unsigned seq;
  
-		now_ns = get_kvmclock_ns(kvm);
-		user_ns.clock = now_ns;
-		user_ns.flags = kvm->arch.use_master_clock ? KVM_CLOCK_TSC_STABLE : 0;
+		do {
+			seq = read_seqcount_begin(&kvm->arch.pvclock_sc);
+			user_ns.clock = __get_kvmclock_ns(kvm);
+			user_ns.flags = kvm->arch.use_master_clock ? KVM_CLOCK_TSC_STABLE : 0;
+		} while (read_seqcount_retry(&kvm->arch.pvclock_sc, seq));
  		memset(&user_ns.pad, 0, sizeof(user_ns.pad));
  
  		r = -EFAULT;
@@ -11144,8 +11157,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
  
  	raw_spin_lock_init(&kvm->arch.tsc_write_lock);
  	mutex_init(&kvm->arch.apic_map_lock);
-	spin_lock_init(&kvm->arch.pvclock_gtod_sync_lock);
-
+	seqcount_mutex_init(&kvm->arch.pvclock_sc, &kvm->lock);
  	kvm->arch.kvmclock_offset = -get_kvmclock_base_ns();
  	pvclock_update_vm_gtod_copy(kvm);
  

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
