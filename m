Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A96BC43219
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 11:47:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FDFB40FB6;
	Fri,  4 Nov 2022 07:47:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ogXJb4AFbVck; Fri,  4 Nov 2022 07:47:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 702D643399;
	Fri,  4 Nov 2022 07:47:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D324640F60
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 01:37:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t4Vp4osOdscP for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 01:37:56 -0400 (EDT)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C23440D23
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 01:37:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1667540276; x=1699076276;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:in-reply-to;
 bh=EgmtsBqJVK3JbLONjG56zRgFCzcOwywt2/xTnCkOP1Y=;
 b=d3WIdSbT2M5wuPfs590yyM/SazuoQjVLsAMB/ob5HXBVQ/1Sd7lKwocY
 SE25FiUr5kUPA19R28eVksP/9uYN6HWcREaEjAhutXhxroeDv99FISRAO
 AIUQUfsvRZ/VeP/O8w5MknrAPP+ri6gZyV1LIflukp1ye+JDKi+eyx76t
 NHGEnO736HmwsR9pTtvBY8qINeW3D28BITvsKvi6d9GiYorWaObVhCIAC
 /MHbjje8VsfvqJEnC2cDU/vtcrwk2I6vMcYUhnAzvz67Cl7kWoGzgnINc
 c83ntkrN+GoqkMPRqaHdUnb+xOSBtE0y4tbuEtesVrSNEzdGZr6SDnrJG A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="297350905"
X-IronPort-AV: E=Sophos;i="5.96,136,1665471600"; d="scan'208";a="297350905"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
 by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 03 Nov 2022 22:37:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="666249074"
X-IronPort-AV: E=Sophos;i="5.96,136,1665471600"; d="scan'208";a="666249074"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
 by orsmga008.jf.intel.com with ESMTP; 03 Nov 2022 22:37:46 -0700
Date: Fri, 4 Nov 2022 13:37:45 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 03/44] KVM: Allocate cpus_hardware_enabled after arch
 hardware setup
Message-ID: <20221104053745.qvi35kflf2i2ifgs@yy-desk-7060>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-4-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221102231911.3107438-4-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Mailman-Approved-At: Fri, 04 Nov 2022 07:47:47 -0400
Cc: Matthew Rosato <mjrosato@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Yuan Yao <yuan.yao@intel.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-kernel@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chao Gao <chao.gao@intel.com>, Eric Farman <farman@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 linuxppc-dev@lists.ozlabs.org
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

On Wed, Nov 02, 2022 at 11:18:30PM +0000, Sean Christopherson wrote:
> Allocate cpus_hardware_enabled after arch hardware setup so that arch
> "init" and "hardware setup" are called back-to-back and thus can be
> combined in a future patch.  cpus_hardware_enabled is never used before
> kvm_create_vm(), i.e. doesn't have a dependency with hardware setup and
> only needs to be allocated before /dev/kvm is exposed to userspace.
>
> Free the object before the arch hooks are invoked to maintain symmetry,
> and so that arch code can move away from the hooks without having to
> worry about ordering changes.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e0424af52acc..8b7534cc953b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5843,15 +5843,15 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  	if (r)
>  		return r;
>
> +	r = kvm_arch_hardware_setup(opaque);
> +	if (r < 0)
> +		goto err_hw_setup;
> +
>  	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
>  		r = -ENOMEM;
>  		goto err_hw_enabled;
>  	}
>
> -	r = kvm_arch_hardware_setup(opaque);
> -	if (r < 0)
> -		goto out_free_1;
> -
>  	c.ret = &r;
>  	c.opaque = opaque;
>  	for_each_online_cpu(cpu) {
> @@ -5937,10 +5937,10 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  	unregister_reboot_notifier(&kvm_reboot_notifier);
>  	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
>  out_free_2:
> -	kvm_arch_hardware_unsetup();
> -out_free_1:
>  	free_cpumask_var(cpus_hardware_enabled);
>  err_hw_enabled:
> +	kvm_arch_hardware_unsetup();
> +err_hw_setup:
>  	kvm_arch_exit();
>  	return r;
>  }
> @@ -5967,9 +5967,9 @@ void kvm_exit(void)
>  	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
>  	on_each_cpu(hardware_disable_nolock, NULL, 1);
>  	kvm_irqfd_exit();
> +	free_cpumask_var(cpus_hardware_enabled);
>  	kvm_arch_hardware_unsetup();
>  	kvm_arch_exit();
> -	free_cpumask_var(cpus_hardware_enabled);
>  	kvm_vfio_ops_exit();

Looks good to me.

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

>  }
>  EXPORT_SYMBOL_GPL(kvm_exit);
> --
> 2.38.1.431.g37b22c650d-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
