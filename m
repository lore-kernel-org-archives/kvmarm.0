Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53715C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:52:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 148DF4BAD7;
	Thu, 10 Nov 2022 09:52:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zk0Zuv+PYM+E; Thu, 10 Nov 2022 09:52:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F19B64BB94;
	Thu, 10 Nov 2022 09:51:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAE084BA71
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 02:31:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h9PhNIzIQhao for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2022 02:31:54 -0500 (EST)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0E7224BA30
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2022 02:31:53 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1668065514; x=1699601514;
 h=message-id:subject:from:to:cc:date:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=K4DExVACpt2lARFBBsyLRbh7EHo+YwPLCynabZeKIUc=;
 b=TV1rBoPzlJGQZjLP0n4ynasJmdsVtIONEcL8Ctkx1adDy0+2HbfPeifi
 7d4843iZLNkEPJIa8WGBxUWlRmsCUZYpB3MDn3ge+s7/Y3LYhMJc9671N
 4paY8t44sxIbtYMqqbwvXzmoKM4FxUyJXJDwkJBuY0edIJ+8eftm72KL3
 9pu5PfsdrS51LndgDnCe56NBNy+DiQK7rLCk20Eiy4SQSVotoXZOJURqe
 Nz134h8eCdPWw+asWN5Gk0SpwtNJn4LrrhNO74a47Zw2rhEhKKPCw66fi
 nD0SjtNbMa6UNtHe4Ypesq6GsBN0+XA1BUZAM+sQkcM2wTJogJLvATCXl w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="312368516"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; d="scan'208";a="312368516"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 09 Nov 2022 23:31:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="631556568"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; d="scan'208";a="631556568"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org)
 ([10.239.48.212])
 by orsmga007.jf.intel.com with ESMTP; 09 Nov 2022 23:31:43 -0800
Message-ID: <ff0e8701d02ee161d064f92c8b742c2cc061bce0.camel@linux.intel.com>
Subject: Re: [PATCH 32/44] KVM: x86: Unify pr_fmt to use module name for all
 KVM modules
From: Robert Hoo <robert.hu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Marc Zyngier <maz@kernel.org>, Huacai Chen
 <chenhuacai@kernel.org>, Aleksandar Markovic
 <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, Paul
 Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger
 <borntraeger@linux.ibm.com>,  Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Matthew Rosato
 <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, Vitaly
 Kuznetsov <vkuznets@redhat.com>
Date: Thu, 10 Nov 2022 15:31:42 +0800
In-Reply-To: <20221102231911.3107438-33-seanjc@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-33-seanjc@google.com>
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
X-Mailman-Approved-At: Thu, 10 Nov 2022 09:51:44 -0500
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, 2022-11-02 at 23:18 +0000, Sean Christopherson wrote:
> Define pr_fmt using KBUILD_MODNAME for all KVM x86 code so that
> printks
> use consistent formatting across common x86, Intel, and AMD code.  In
> addition to providing consistent print formatting, using
> KBUILD_MODNAME,
> e.g. kvm_amd and kvm_intel, allows referencing SVM and VMX (and SEV
> and
> SGX and ...) as technologies without generating weird messages, and
> without causing naming conflicts with other kernel code, e.g. "SEV:
> ",
> "tdx: ", "sgx: " etc.. are all used by the kernel for non-KVM
> subsystems.
> 
> Opportunistically move away from printk() for prints that need to be
> modified anyways, e.g. to drop a manual "kvm: " prefix.
> 
> Opportunistically convert a few SGX WARNs that are similarly modified
> to
> WARN_ONCE; in the very unlikely event that the WARNs fire, odds are
> good
> that they would fire repeatedly and spam the kernel log without
> providing
> unique information in each print.
> 
> Note, defining pr_fmt yields undesirable results for code that uses
> KVM's
> printk wrappers, e.g. vcpu_unimpl().  But, that's a pre-existing
> problem
> as SVM/kvm_amd already defines a pr_fmt, and thankfully use of KVM's
> wrappers is relatively limited in KVM x86 code.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c            |  1 +
>  arch/x86/kvm/debugfs.c          |  2 ++
>  arch/x86/kvm/emulate.c          |  1 +
>  arch/x86/kvm/hyperv.c           |  1 +
>  arch/x86/kvm/i8254.c            |  4 ++--
>  arch/x86/kvm/i8259.c            |  4 +++-
>  arch/x86/kvm/ioapic.c           |  1 +
>  arch/x86/kvm/irq.c              |  1 +
>  arch/x86/kvm/irq_comm.c         |  7 +++---
>  arch/x86/kvm/kvm_onhyperv.c     |  1 +
>  arch/x86/kvm/lapic.c            |  8 +++----
>  arch/x86/kvm/mmu/mmu.c          |  6 ++---
>  arch/x86/kvm/mmu/page_track.c   |  1 +
>  arch/x86/kvm/mmu/spte.c         |  4 ++--
>  arch/x86/kvm/mmu/spte.h         |  4 ++--
>  arch/x86/kvm/mmu/tdp_iter.c     |  1 +
>  arch/x86/kvm/mmu/tdp_mmu.c      |  1 +
>  arch/x86/kvm/mtrr.c             |  1 +
>  arch/x86/kvm/pmu.c              |  1 +
>  arch/x86/kvm/smm.c              |  1 +
>  arch/x86/kvm/svm/avic.c         |  2 +-
>  arch/x86/kvm/svm/nested.c       |  2 +-
>  arch/x86/kvm/svm/pmu.c          |  2 ++
>  arch/x86/kvm/svm/sev.c          |  1 +
>  arch/x86/kvm/svm/svm.c          | 10 ++++-----
>  arch/x86/kvm/svm/svm_onhyperv.c |  1 +
>  arch/x86/kvm/svm/svm_onhyperv.h |  4 ++--
>  arch/x86/kvm/vmx/evmcs.c        |  1 +
>  arch/x86/kvm/vmx/evmcs.h        |  4 +---
>  arch/x86/kvm/vmx/nested.c       |  3 ++-
>  arch/x86/kvm/vmx/pmu_intel.c    |  5 +++--
>  arch/x86/kvm/vmx/posted_intr.c  |  2 ++
>  arch/x86/kvm/vmx/sgx.c          |  5 +++--
>  arch/x86/kvm/vmx/vmcs12.c       |  1 +
>  arch/x86/kvm/vmx/vmx.c          | 40 ++++++++++++++++---------------
> --
>  arch/x86/kvm/vmx/vmx_ops.h      |  4 ++--
>  arch/x86/kvm/x86.c              | 28 ++++++++++++-----------
>  arch/x86/kvm/xen.c              |  1 +
>  38 files changed, 97 insertions(+), 70 deletions(-)
> 
After this patch set, still find some printk()s left in arch/x86/kvm/*,
consider clean all of them up?

arch/x86/kvm/lapic.c:1215:		printk(KERN_ERR "TODO:
unsupported delivery mode %x\n",
arch/x86/kvm/lapic.c:1506:		printk(KERN_ERR "Local APIC
read with len = %x, "
arch/x86/kvm/lapic.c:2586:		printk(KERN_ERR "malloc apic
regs error for vcpu %x\n",
arch/x86/kvm/ioapic.h:95:		printk(KERN_EMERG "assertion
failed %s: %d: %s\n",	\
arch/x86/kvm/ioapic.c:614:		printk(KERN_WARNING "ioapic:
wrong length %d\n", len);
arch/x86/kvm/ioapic.c:641:		printk(KERN_WARNING "ioapic:
Unsupported size %d\n", len);
arch/x86/kvm/mmu/mmu.c:1652:			printk(KERN_ERR "%s: %p
%llx\n", __func__,
arch/x86/kvm/svm/svm.c:3450:		printk(KERN_ERR "%s: unexpected
exit_int_info 0x%x "
arch/x86/kvm/vmx/posted_intr.c:322:				printk(
KERN_INFO
arch/x86/kvm/vmx/posted_intr.c:343:			printk(KERN_INF
O "%s: failed to update PI IRTE\n",
arch/x86/kvm/vmx/vmx.c:6507:			printk(KERN_WARNING
"%s: Breaking out of NMI-blocked "
arch/x86/kvm/x86.c:13027:		printk(KERN_INFO "irq bypass
consumer (token %p) unregistration"

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
