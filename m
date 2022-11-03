Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AD4C4332F
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 15:23:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 150774B24C;
	Thu,  3 Nov 2022 11:23:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7Szw9RaT7iem; Thu,  3 Nov 2022 11:23:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3E244B5F4;
	Thu,  3 Nov 2022 11:23:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 389BD4B2A1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 11:23:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IGMSuNXipKsp for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 11:23:19 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD74D4B24C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 11:23:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667488999;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ex9w6AF29xEwpNLs+Jj1aaojn2ZZjhH0ZX9iUoTOfgc=;
 b=JYIcN4Qvut2ueP8N4RFbgV0SYq5S8nvRybbNe2ttD9jexTpnOj2XngkrGJD88PEFd9PSiO
 khIJaLvEJXZECQvfBP2WCcEPF4mGZDl/ojdIeFDtnqLr+D9EM85KqMhDa91FrMO3n72YH3
 QJLdpwtvDAncQDbMJaVB0ruJZizXNQ0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-413-kjToxg4nMyKTiEv4BYwfEA-1; Thu, 03 Nov 2022 11:23:18 -0400
X-MC-Unique: kjToxg4nMyKTiEv4BYwfEA-1
Received: by mail-ej1-f70.google.com with SMTP id
 qf25-20020a1709077f1900b0078c02a23da3so1499247ejc.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 08:23:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=ex9w6AF29xEwpNLs+Jj1aaojn2ZZjhH0ZX9iUoTOfgc=;
 b=mz9VEMABOa+UwiMP83NEpayCSL4ok6G4G99O8rGfUyWuLU508lLn3wrxWHvP9dJ640
 epzOgZx1YGm13SRgsBfLfle4O+Fz5uv9V5mx706Naam0xE5uLm01jG4vYuCl9mxjPbuh
 VQWh7y7U1jI3lB7aLNhclP7R4axPIMyjeDqUISUuW7jbkm4a2Qv/wCQQIP2zHwVf84qv
 awirm9sp9J4w4vGc6Gc61brzj2+Srb5rYSgzNfnXKyNmioGSfFBZio8aEOA/c6wYKDje
 Ay9I0B8WYKFLrrGGbOui876QLGZ/6e8mDB1i53xRRgGuUwS7Q9KwtK2kkZMLA8wYxi1U
 yQtA==
X-Gm-Message-State: ACrzQf0LL7MbmnpM0kAKoM0zgEKE0BBjRCUVxSCbz0tkPL9H4h/Ac/i1
 ZOHeh29CIptEjUA06pgE11brnVbQLCjB+gFzfGRhl6uFUn8TbruqO1Op+OtcRb2QGE+/jihp9++
 hycAh676Yal4nHJDaaBHW7Ddf
X-Received: by 2002:a17:907:8a07:b0:7ad:e111:9f1f with SMTP id
 sc7-20020a1709078a0700b007ade1119f1fmr18706654ejc.748.1667488996732; 
 Thu, 03 Nov 2022 08:23:16 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7w/ZtXgKJ7V+2Z8oeupCi1g9Jll17Pmqv+y4uPqlw3EJEEB8/pAd5jt1iBgMRagb/0UlEDkg==
X-Received: by 2002:a17:907:8a07:b0:7ad:e111:9f1f with SMTP id
 sc7-20020a1709078a0700b007ade1119f1fmr18706603ejc.748.1667488996425; 
 Thu, 03 Nov 2022 08:23:16 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c?
 ([2001:b07:6468:f312:1c09:f536:3de6:228c])
 by smtp.googlemail.com with ESMTPSA id
 9-20020a170906218900b007a9c3831409sm596520eju.137.2022.11.03.08.23.13
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 03 Nov 2022 08:23:15 -0700 (PDT)
Message-ID: <7b6ce80e-7f1f-11cd-8bde-8d8fa9fd7e1d@redhat.com>
Date: Thu, 3 Nov 2022 16:23:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 39/44] KVM: Drop kvm_count_lock and instead protect
 kvm_usage_count with kvm_lock
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-40-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221102231911.3107438-40-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 Chao Gao <chao.gao@intel.com>, Yuan Yao <yuan.yao@intel.com>,
 kvmarm@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
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

On 11/3/22 00:19, Sean Christopherson wrote:
> +- kvm_lock is taken outside kvm->mmu_lock

Not surprising since one is a mutex and one is an rwlock. :)  You can 
drop this hunk as well as the "Opportunistically update KVM's locking 
documentation" sentence in the commit message.

>   - vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock
>   
>   - kvm->arch.mmu_lock is an rwlock.  kvm->arch.tdp_mmu_pages_lock and
> @@ -216,15 +220,11 @@ time it will be set using the Dirty tracking mechanism described above.
>   :Type:		mutex
>   :Arch:		any
>   :Protects:	- vm_list
> -
> -``kvm_count_lock``
> -^^^^^^^^^^^^^^^^^^
> -
> -:Type:		raw_spinlock_t
> -:Arch:		any
> -:Protects:	- hardware virtualization enable/disable
> -:Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
> -		migration.
> +		- kvm_usage_count
> +		- hardware virtualization enable/disable
> +		- module probing (x86 only)

What do you mean exactly by "module probing"?  Is it anything else than 
what is serialized by vendor_module_lock?

Paolo

> +:Comment:	KVM also disables CPU hotplug via cpus_read_lock() during
> +		enable/disable.
>   
>   ``kvm->mn_invalidate_lock``
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4e765ef9f4bd..c8d92e6c3922 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -100,7 +100,6 @@ EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
>    */
>   
>   DEFINE_MUTEX(kvm_lock);
> -static DEFINE_RAW_SPINLOCK(kvm_count_lock);
>   LIST_HEAD(vm_list);
>   
>   static cpumask_var_t cpus_hardware_enabled;
> @@ -5028,9 +5027,10 @@ static void hardware_enable_nolock(void *junk)
>   
>   static int kvm_online_cpu(unsigned int cpu)
>   {
> +	unsigned long flags;
>   	int ret = 0;
>   
> -	raw_spin_lock(&kvm_count_lock);
> +	mutex_lock(&kvm_lock);
>   	/*
>   	 * Abort the CPU online process if hardware virtualization cannot
>   	 * be enabled. Otherwise running VMs would encounter unrecoverable
> @@ -5039,13 +5039,16 @@ static int kvm_online_cpu(unsigned int cpu)
>   	if (kvm_usage_count) {
>   		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
>   
> +		local_irq_save(flags);
>   		hardware_enable_nolock(NULL);
> +		local_irq_restore(flags);
> +
>   		if (atomic_read(&hardware_enable_failed)) {
>   			atomic_set(&hardware_enable_failed, 0);
>   			ret = -EIO;
>   		}
>   	}
> -	raw_spin_unlock(&kvm_count_lock);
> +	mutex_unlock(&kvm_lock);
>   	return ret;
>   }
>   
> @@ -5061,10 +5064,13 @@ static void hardware_disable_nolock(void *junk)
>   
>   static int kvm_offline_cpu(unsigned int cpu)
>   {
> -	raw_spin_lock(&kvm_count_lock);
> -	if (kvm_usage_count)
> +	mutex_lock(&kvm_lock);
> +	if (kvm_usage_count) {
> +		preempt_disable();
>   		hardware_disable_nolock(NULL);
> -	raw_spin_unlock(&kvm_count_lock);
> +		preempt_enable();
> +	}
> +	mutex_unlock(&kvm_lock);
>   	return 0;
>   }
>   
> @@ -5079,9 +5085,11 @@ static void hardware_disable_all_nolock(void)
>   
>   static void hardware_disable_all(void)
>   {
> -	raw_spin_lock(&kvm_count_lock);
> +	cpus_read_lock();
> +	mutex_lock(&kvm_lock);
>   	hardware_disable_all_nolock();
> -	raw_spin_unlock(&kvm_count_lock);
> +	mutex_unlock(&kvm_lock);
> +	cpus_read_unlock();
>   }
>   
>   static int hardware_enable_all(void)
> @@ -5097,7 +5105,7 @@ static int hardware_enable_all(void)
>   	 * Disable CPU hotplug to prevent scenarios where KVM sees
>   	 */
>   	cpus_read_lock();
> -	raw_spin_lock(&kvm_count_lock);
> +	mutex_lock(&kvm_lock);
>   
>   	kvm_usage_count++;
>   	if (kvm_usage_count == 1) {
> @@ -5110,7 +5118,7 @@ static int hardware_enable_all(void)
>   		}
>   	}
>   
> -	raw_spin_unlock(&kvm_count_lock);
> +	mutex_unlock(&kvm_lock);
>   	cpus_read_unlock();
>   
>   	return r;
> @@ -5716,6 +5724,15 @@ static void kvm_init_debug(void)
>   
>   static int kvm_suspend(void)
>   {
> +	/*
> +	 * Secondary CPUs and CPU hotplug are disabled across the suspend/resume
> +	 * callbacks, i.e. no need to acquire kvm_lock to ensure the usage count
> +	 * is stable.  Assert that kvm_lock is not held as a paranoid sanity
> +	 * check that the system isn't suspended when KVM is enabling hardware.
> +	 */
> +	lockdep_assert_not_held(&kvm_lock);
> +	lockdep_assert_irqs_disabled();
> +
>   	if (kvm_usage_count)
>   		hardware_disable_nolock(NULL);
>   	return 0;
> @@ -5723,10 +5740,11 @@ static int kvm_suspend(void)
>   
>   static void kvm_resume(void)
>   {
> -	if (kvm_usage_count) {
> -		lockdep_assert_not_held(&kvm_count_lock);
> +	lockdep_assert_not_held(&kvm_lock);
> +	lockdep_assert_irqs_disabled();
> +
> +	if (kvm_usage_count)
>   		hardware_enable_nolock(NULL);
> -	}
>   }
>   
>   static struct syscore_ops kvm_syscore_ops = {

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
