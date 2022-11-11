Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F4BC43217
	for <kvmarm@archiver.kernel.org>; Fri, 11 Nov 2022 01:39:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B15AF4BAE6;
	Thu, 10 Nov 2022 20:39:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4vCZFYcIMH8M; Thu, 10 Nov 2022 20:39:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 210EC4BACB;
	Thu, 10 Nov 2022 20:39:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C840E4BAC8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 20:39:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1SPp6j-46kfQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2022 20:39:00 -0500 (EST)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
 [209.85.215.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5C64B4BAB0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 20:39:00 -0500 (EST)
Received: by mail-pg1-f169.google.com with SMTP id s196so3233740pgs.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 17:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=RS3a6hLMxUUoEPjaozjVNm3jkJhC+H0XClz14w/jfaA=;
 b=SoG++eGsogNhOXHNYNGSQwqVVuREga4mMXnUJPEp2Aaf3wDTjmN4pUpcDu6NyDyk/7
 ZCrJ5tCMaVWUaaxyvaQrhL0T5FiyghxHxIWcZucG8+WiPsxAaytMKmY0pIZmkCvM/P3A
 FzRDVfuDDdZ0ZvXjDTxrK9PvmsGmkf3tvXZwJCbLUSF0TG776tNA1944kmAMkLT9zZec
 fBYk+3bEeWzmhZC19FCrSr44X5QV+XC8WpwQgvzfkBuRNUn1T3FMjmURa/IIpEBzEphS
 S5BEZ0ZwTijqaaaZMQZlcNfQrroFpxn8GJ4NeHygg9gK3xqWbjbKbAj8qSY8fGLozXvu
 Gsig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=RS3a6hLMxUUoEPjaozjVNm3jkJhC+H0XClz14w/jfaA=;
 b=pHIbAJ5Dh1OjIuupDdWsiqIKDfXDTCi1MbDpbdlTaCX+L5FBSF2ZqrTrFoHgLiNILL
 1K3GgAFgaekJhmweYASPNVznyM0k+j1YdPswHD6E0aIxdFKztToCHC8SyHlcQOrZ37OV
 lL/1bcd7aBJmiLevATY9RTTJkQwzUKArTS0iOWfLC98R0x1yf216bCNoVUGYFh02/JTD
 9bsab201A2h8WrEuAxrQOQwPtJXiGYwUQXTZwjDf2nkmAN5cl3bjt6x3EGH6g4YqDGFj
 DJVPY54fIpy+/gqaEoIZA25xYhSbasJiSTl0GUwj5YkxCeDewvanJrnnEhtk/JV9i67X
 Xjbg==
X-Gm-Message-State: ACrzQf2MH04PLyKwpY5yseZjsmmc6VHhdRajXqzrnAeo1jwjnU4UYo0w
 PsD20RrgdQj2WH77dtXeoI7Y+Q==
X-Google-Smtp-Source: AMsMyM5NZekdvfkLtC3kWWLVHXrB1AuT7u9X73tzeCo4RhIdse0v2yQHD++RSAOfBDE10qOQXDbeUA==
X-Received: by 2002:a63:e62:0:b0:46f:e658:a8ff with SMTP id
 34-20020a630e62000000b0046fe658a8ffmr4116215pgo.493.1668130739232; 
 Thu, 10 Nov 2022 17:38:59 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 z6-20020aa79486000000b005636326fdbfsm310014pfk.78.2022.11.10.17.38.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 10 Nov 2022 17:38:58 -0800 (PST)
Date: Fri, 11 Nov 2022 01:38:53 +0000
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 10/44] KVM: VMX: Clean up eVMCS enabling if KVM
 initialization fails
Message-ID: <Y22nrQ7aziK0NMOE@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-11-seanjc@google.com>
 <87mt98qfi2.fsf@ovpn-194-252.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87mt98qfi2.fsf@ovpn-194-252.brq.redhat.com>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Chao Gao <chao.gao@intel.com>,
 Eric Farman <farman@linux.ibm.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Paul Walmsley <paul.walmsley@sifive.com>, Yuan Yao <yuan.yao@intel.com>,
 kvmarm@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

On Thu, Nov 03, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > +	/*
> > +	 * Reset everything to support using non-enlightened VMCS access later
> > +	 * (e.g. when we reload the module with enlightened_vmcs=0)
> > +	 */
> > +	for_each_online_cpu(cpu) {
> > +		vp_ap =	hv_get_vp_assist_page(cpu);
> > +
> > +		if (!vp_ap)
> > +			continue;
> > +
> > +		vp_ap->nested_control.features.directhypercall = 0;
> > +		vp_ap->current_nested_vmcs = 0;
> > +		vp_ap->enlighten_vmentry = 0;
> > +	}
> 
> Unrelated to your patch but while looking at this code I got curious
> about why don't we need a protection against CPU offlining here. Turns
> out that even when we offline a CPU, its VP assist page remains
> allocated (see hv_cpu_die()), we just write '0' to the MSR and thus

Heh, "die".  Hyper-V is quite dramatic.

> accessing the page is safe. The consequent hv_cpu_init(), however, does
> not restore VP assist page when it's already allocated:
> 
> # rdmsr -p 24 0x40000073
> 10212f001
> # echo 0 > /sys/devices/system/cpu/cpu24/online 
> # echo 1 > /sys/devices/system/cpu/cpu24/online 
> # rdmsr -p 24 0x40000073
> 0
> 
> The culprit is commit e5d9b714fe402 ("x86/hyperv: fix root partition
> faults when writing to VP assist page MSR"). A patch is inbound.
> 
> 'hv_root_partition' case is different though. We do memunmap() and reset
> VP assist page to zero so it is theoretically possible we're going to
> clash. Unless I'm missing some obvious reason why module unload can't
> coincide with CPU offlining, we may be better off surrounding this with
> cpus_read_lock()/cpus_read_unlock(). 

I finally see what you're concerned about.  If a CPU goes offline and its assist
page is unmapped, zeroing out the nested/eVMCS stuff will fault.

I think the real problem is that the purging of the eVMCS is in the wrong place.
Move the clearing to vmx_hardware_disable() and then the CPU hotplug bug goes
away once KVM disables hotplug during hardware enabling/disable later in the series.
There's no need to wait until module exit, e.g. it's not like it costs much to
clear a few variables, and IIUC the state is used only when KVM is actively using
VMX/eVMCS.

However, I believe there's a second bug.  KVM's CPU online hook is called before
Hyper-V's online hook (CPUHP_AP_ONLINE_DYN).  Before this series, which moves KVM's
hook from STARTING to ONLINE, KVM's hook is waaaay before Hyper-V's.  That means
that hv_cpu_init()'s allocation of the VP assist page will come _after_ KVM's
check in vmx_hardware_enable()

	/*
	 * This can happen if we hot-added a CPU but failed to allocate
	 * VP assist page for it.
	 */
	if (static_branch_unlikely(&enable_evmcs) &&
	    !hv_get_vp_assist_page(cpu))
		return -EFAULT;

I.e. CPU hotplug will never work if KVM is running VMs as a Hyper-V guest.  I bet
you can repro by doing a SUSPEND+RESUME.

Can you try to see if that's actually a bug?  If so, the only sane fix seems to
be to add a dedicated ONLINE action for Hyper-V.  Per patch

  KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section

from this series, CPUHP_AP_KVM_ONLINE needs to be before CPUHP_AP_SCHED_WAIT_EMPTY
to ensure there are no tasks, i.e. no vCPUs, running on the to-be-unplugged CPU.

Back to the original bug, proposed fix is below.  The other advantage of moving
the reset to hardware disabling is that the "cleanup" is just disabling the static
key, and at that point can simply be deleted as there's no need to disable the
static key when kvm-intel is unloaded since kvm-intel owns the key.  I.e. this
patch (that we're replying to) would get replaced with a patch to delete the
disabling of the static key.

--
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Nov 2022 17:28:08 -0800
Subject: [PATCH] KVM: VMX: Reset eVMCS controls in VP assist page during
 hardware disabling

Reset the eVMCS controls in the per-CPU VP assist page during hardware
disabling instead of waiting until kvm-intel's module exit.  The controls
are activated if and only if KVM creates a VM, i.e. don't need to be
reset if hardware is never enabled.

Doing the reset during hardware disabling will naturally fix a potential
NULL pointer deref bug once KVM disables CPU hotplug while enabling and
disabling hardware (which is necessary to fix a variety of bugs).  If the
kernel is running as the root partition, the VP assist page is unmapped
during CPU hot unplug, and so KVM's clearing of the eVMCS controls needs
to occur with CPU hot(un)plug disabled, otherwise KVM could attempt to
write to a CPU's VP assist page after it's unmapped.

Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 50 +++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aca88524fd1e..ae13aa3e8a1d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -552,6 +552,33 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static void hv_reset_evmcs(void)
+{
+	struct hv_vp_assist_page *vp_ap;
+
+	if (!static_branch_unlikely(&enable_evmcs))
+		return;
+
+	/*
+	 * KVM should enable eVMCS if and only if all CPUs have a VP assist
+	 * page, and should reject CPU onlining if eVMCS is enabled the CPU
+	 * doesn't have a VP assist page allocated.
+	 */
+	vp_ap = hv_get_vp_assist_page(smp_processor_id());
+	if (WARN_ON_ONCE(!vp_ap))
+		return;
+
+	/*
+	 * Reset everything to support using non-enlightened VMCS access later
+	 * (e.g. when we reload the module with enlightened_vmcs=0)
+	 */
+	vp_ap->nested_control.features.directhypercall = 0;
+	vp_ap->current_nested_vmcs = 0;
+	vp_ap->enlighten_vmentry = 0;
+}
+
+#else /* IS_ENABLED(CONFIG_HYPERV) */
+static void hv_reset_evmcs(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 /*
@@ -2497,6 +2524,8 @@ static void vmx_hardware_disable(void)
 	if (cpu_vmxoff())
 		kvm_spurious_fault();
 
+	hv_reset_evmcs();
+
 	intel_pt_handle_vmx(0);
 }
 
@@ -8463,27 +8492,8 @@ static void vmx_exit(void)
 	kvm_exit();
 
 #if IS_ENABLED(CONFIG_HYPERV)
-	if (static_branch_unlikely(&enable_evmcs)) {
-		int cpu;
-		struct hv_vp_assist_page *vp_ap;
-		/*
-		 * Reset everything to support using non-enlightened VMCS
-		 * access later (e.g. when we reload the module with
-		 * enlightened_vmcs=0)
-		 */
-		for_each_online_cpu(cpu) {
-			vp_ap =	hv_get_vp_assist_page(cpu);
-
-			if (!vp_ap)
-				continue;
-
-			vp_ap->nested_control.features.directhypercall = 0;
-			vp_ap->current_nested_vmcs = 0;
-			vp_ap->enlighten_vmentry = 0;
-		}
-
+	if (static_branch_unlikely(&enable_evmcs))
 		static_branch_disable(&enable_evmcs);
-	}
 #endif
 	vmx_cleanup_l1d_flush();
 

base-commit: 5f47ba6894477dfbdc5416467a25fb7acb47d404
-- 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
