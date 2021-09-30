Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB342C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 19:23:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69BE361A38
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 19:23:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 69BE361A38
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AB854B0DD;
	Thu, 30 Sep 2021 15:23:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WuRgwBzUPZ08; Thu, 30 Sep 2021 15:23:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBEB24B0D7;
	Thu, 30 Sep 2021 15:23:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E812C4B08A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 15:23:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XBiJR7ZLwPFs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 15:23:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AAA54B0D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 15:23:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633029821;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=69/2vnynzrwmO+C/hMNu41y0Mcok+R2//sJsybWafFQ=;
 b=MZKJXP1uGpkn881/ZOMK7xkGZV0z2PXwuo2Ue4jIe91t7vPE91SahmyquBGXR4XtokY0vT
 GblMMPiQumG+RxEo4LFemXUkyB7e90+Ge621UNAcD4+FW9NNuQcarvvjRGnfG0jgX4ziiN
 I1oiiTiw0shC1QL7Mr0Agvr6I+pGkR8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-_87xpljDPliji9Qtl4v77g-1; Thu, 30 Sep 2021 15:23:37 -0400
X-MC-Unique: _87xpljDPliji9Qtl4v77g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A72E5101872F;
 Thu, 30 Sep 2021 19:23:35 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C752C76C1F;
 Thu, 30 Sep 2021 19:23:34 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
 id A57B1416CE5D; Thu, 30 Sep 2021 14:51:07 -0300 (-03)
Date: Thu, 30 Sep 2021 14:51:07 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v8 5/7] kvm: x86: protect masterclock with a seqcount
Message-ID: <20210930175107.GA15071@fuller.cnet>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-6-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210916181538.968978-6-oupton@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Sep 16, 2021 at 06:15:36PM +0000, Oliver Upton wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> Protect the reference point for kvmclock with a seqcount, so that
> kvmclock updates for all vCPUs can proceed in parallel.  Xen runstate
> updates will also run in parallel and not bounce the kvmclock cacheline.
> 
> nr_vcpus_matched_tsc is updated outside pvclock_update_vm_gtod_copy
> though, so a spinlock must be kept for that one.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [Oliver - drop unused locals, don't double acquire tsc_write_lock]
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  7 ++-
>  arch/x86/kvm/x86.c              | 83 +++++++++++++++++----------------
>  2 files changed, 49 insertions(+), 41 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9c34b5b63e39..5accfe7246ce 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1087,6 +1087,11 @@ struct kvm_arch {
>  
>  	unsigned long irq_sources_bitmap;
>  	s64 kvmclock_offset;
> +
> +	/*
> +	 * This also protects nr_vcpus_matched_tsc which is read from a
> +	 * preemption-disabled region, so it must be a raw spinlock.
> +	 */
>  	raw_spinlock_t tsc_write_lock;
>  	u64 last_tsc_nsec;
>  	u64 last_tsc_write;
> @@ -1097,7 +1102,7 @@ struct kvm_arch {
>  	u64 cur_tsc_generation;
>  	int nr_vcpus_matched_tsc;
>  
> -	spinlock_t pvclock_gtod_sync_lock;
> +	seqcount_raw_spinlock_t pvclock_sc;
>  	bool use_master_clock;
>  	u64 master_kernel_ns;
>  	u64 master_cycle_now;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cb5d5cad5124..29156c49cd11 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2533,9 +2533,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>  	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
>  
>  	kvm_vcpu_write_tsc_offset(vcpu, offset);
> -	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
>  
> -	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
>  	if (!matched) {
>  		kvm->arch.nr_vcpus_matched_tsc = 0;
>  	} else if (!already_matched) {
> @@ -2543,7 +2541,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>  	}
>  
>  	kvm_track_tsc_matching(vcpu);
> -	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
> +	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
>  }
>  
>  static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
> @@ -2731,9 +2729,6 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
>  	int vclock_mode;
>  	bool host_tsc_clocksource, vcpus_matched;
>  
> -	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
> -			atomic_read(&kvm->online_vcpus));
> -
>  	/*
>  	 * If the host uses TSC clock, then passthrough TSC as stable
>  	 * to the guest.
> @@ -2742,6 +2737,10 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
>  					&ka->master_kernel_ns,
>  					&ka->master_cycle_now);
>  
> +	lockdep_assert_held(&kvm->arch.tsc_write_lock);
> +	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
> +			atomic_read(&kvm->online_vcpus));
> +
>  	ka->use_master_clock = host_tsc_clocksource && vcpus_matched
>  				&& !ka->backwards_tsc_observed
>  				&& !ka->boot_vcpu_runs_old_kvmclock;
> @@ -2760,14 +2759,18 @@ static void kvm_make_mclock_inprogress_request(struct kvm *kvm)
>  	kvm_make_all_cpus_request(kvm, KVM_REQ_MCLOCK_INPROGRESS);
>  }
>  
> -static void kvm_start_pvclock_update(struct kvm *kvm)
> +static void __kvm_start_pvclock_update(struct kvm *kvm)
>  {
> -	struct kvm_arch *ka = &kvm->arch;
> +	raw_spin_lock_irq(&kvm->arch.tsc_write_lock);
> +	write_seqcount_begin(&kvm->arch.pvclock_sc);
> +}
>  
> +static void kvm_start_pvclock_update(struct kvm *kvm)
> +{
>  	kvm_make_mclock_inprogress_request(kvm);
>  
>  	/* no guest entries from this point */
> -	spin_lock_irq(&ka->pvclock_gtod_sync_lock);
> +	__kvm_start_pvclock_update(kvm);
>  }
>  
>  static void kvm_end_pvclock_update(struct kvm *kvm)
> @@ -2776,7 +2779,8 @@ static void kvm_end_pvclock_update(struct kvm *kvm)
>  	struct kvm_vcpu *vcpu;
>  	int i;
>  
> -	spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
> +	write_seqcount_end(&ka->pvclock_sc);
> +	raw_spin_unlock_irq(&ka->tsc_write_lock);
>  	kvm_for_each_vcpu(i, vcpu, kvm)
>  		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>  
> @@ -2797,20 +2801,12 @@ static void get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
>  {
>  	struct kvm_arch *ka = &kvm->arch;
>  	struct pvclock_vcpu_time_info hv_clock;
> -	unsigned long flags;
>  
> -	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
>  	if (!ka->use_master_clock) {
> -		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
>  		data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
>  		return;
>  	}
>  
> -	data->flags |= KVM_CLOCK_TSC_STABLE;
> -	hv_clock.tsc_timestamp = ka->master_cycle_now;
> -	hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
> -	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
> -
>  	/* both __this_cpu_read() and rdtsc() should be on the same cpu */
>  	get_cpu();
>  
> @@ -2825,6 +2821,9 @@ static void get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
>  #endif
>  		data->host_tsc = rdtsc();
>  
> +		data->flags |= KVM_CLOCK_TSC_STABLE;
> +		hv_clock.tsc_timestamp = ka->master_cycle_now;
> +		hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
>  		kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
>  				   &hv_clock.tsc_shift,
>  				   &hv_clock.tsc_to_system_mul);
> @@ -2839,14 +2838,14 @@ static void get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
>  u64 get_kvmclock_ns(struct kvm *kvm)
>  {
>  	struct kvm_clock_data data;
> +	struct kvm_arch *ka = &kvm->arch;
> +	unsigned seq;
>  
> -	/*
> -	 * Zero flags as it's accessed RMW, leave everything else uninitialized
> -	 * as clock is always written and no other fields are consumed.
> -	 */
> -	data.flags = 0;
> -
> -	get_kvmclock(kvm, &data);
> +	do {
> +		seq = read_seqcount_begin(&ka->pvclock_sc);
> +		data.flags = 0;
> +		get_kvmclock(kvm, &data);
> +	} while (read_seqcount_retry(&ka->pvclock_sc, seq));
>  	return data.clock;
>  }
>  
> @@ -2912,6 +2911,7 @@ static void kvm_setup_pvclock_page(struct kvm_vcpu *v,
>  static int kvm_guest_time_update(struct kvm_vcpu *v)
>  {
>  	unsigned long flags, tgt_tsc_khz;
> +	unsigned seq;
>  	struct kvm_vcpu_arch *vcpu = &v->arch;
>  	struct kvm_arch *ka = &v->kvm->arch;
>  	s64 kernel_ns;
> @@ -2926,13 +2926,14 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  	 * If the host uses TSC clock, then passthrough TSC as stable
>  	 * to the guest.
>  	 */
> -	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
> -	use_master_clock = ka->use_master_clock;
> -	if (use_master_clock) {
> -		host_tsc = ka->master_cycle_now;
> -		kernel_ns = ka->master_kernel_ns;
> -	}
> -	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
> +	seq = read_seqcount_begin(&ka->pvclock_sc);
> +	do {
> +		use_master_clock = ka->use_master_clock;
> +		if (use_master_clock) {
> +			host_tsc = ka->master_cycle_now;
> +			kernel_ns = ka->master_kernel_ns;
> +		}
> +	} while (read_seqcount_retry(&ka->pvclock_sc, seq));
>  
>  	/* Keep irq disabled to prevent changes to the clock */
>  	local_irq_save(flags);
> @@ -5855,10 +5856,15 @@ int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
>  
>  static int kvm_vm_ioctl_get_clock(struct kvm *kvm, void __user *argp)
>  {
> -	struct kvm_clock_data data;
> +	struct kvm_clock_data data = { 0 };
> +	unsigned seq;
> +
> +	do {
> +		seq = read_seqcount_begin(&kvm->arch.pvclock_sc);
> +		data.flags = 0;
> +		get_kvmclock(kvm, &data);
> +	} while (read_seqcount_retry(&kvm->arch.pvclock_sc, seq));
>  
> -	memset(&data, 0, sizeof(data));
> -	get_kvmclock(kvm, &data);
>  	if (copy_to_user(argp, &data, sizeof(data)))
>  		return -EFAULT;
>  
> @@ -8159,9 +8165,7 @@ static void kvm_hyperv_tsc_notifier(void)
>  	kvm_max_guest_tsc_khz = tsc_khz;
>  
>  	list_for_each_entry(kvm, &vm_list, vm_list) {
> -		struct kvm_arch *ka = &kvm->arch;
> -
> -		spin_lock_irq(&ka->pvclock_gtod_sync_lock);
> +		__kvm_start_pvclock_update(kvm);
>  		pvclock_update_vm_gtod_copy(kvm);
>  		kvm_end_pvclock_update(kvm);
>  	}
> @@ -11188,8 +11192,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  
>  	raw_spin_lock_init(&kvm->arch.tsc_write_lock);
>  	mutex_init(&kvm->arch.apic_map_lock);
> -	spin_lock_init(&kvm->arch.pvclock_gtod_sync_lock);
> -
> +	seqcount_raw_spinlock_init(&kvm->arch.pvclock_sc, &kvm->arch.tsc_write_lock);
>  	kvm->arch.kvmclock_offset = -get_kvmclock_base_ns();
>  	pvclock_update_vm_gtod_copy(kvm);
>  
> -- 
> 2.33.0.309.g3052b89438-goog
> 
> 

ACK

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
