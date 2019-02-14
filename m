From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH V2 00/10] X86/KVM/Hyper-V: Add HV ept tlb range list flush
 support in KVM
Date: Thu, 14 Feb 2019 17:40:20 +0100
Message-ID: <3bcfedac-3054-7d5e-24b6-5c98d8171514@redhat.com>
References: <20190202013825.51261-1-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40E5B4A332
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Feb 2019 11:40:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YxgwC3nBBxEk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Feb 2019 11:40:38 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7123D4A1DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Feb 2019 11:40:38 -0500 (EST)
In-Reply-To: <20190202013825.51261-1-Tianyu.Lan@microsoft.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: lantianyu1986@gmail.com
Cc: kvm@vger.kernel.org, benh@kernel.crashing.org, will.deacon@arm.com, paulus@ozlabs.org, hpa@zytor.com, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, sashal@kernel.org, sthemmin@microsoft.com, mpe@ellerman.id.au, x86@kernel.org, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, mingo@redhat.com, catalin.marinas@arm.com, jhogan@kernel.org, linux-mips@vger.kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, haiyangz@microsoft.com, kvm-ppc@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, ralf@linux-mips.org, paul.burton@mips.com, devel@linuxdriverproject.org, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

On 02/02/19 02:38, lantianyu1986@gmail.com wrote:
> From: Lan Tianyu <Tianyu.Lan@microsoft.com>
> 
> This patchset is to introduce hv ept tlb range list flush function
> support in the KVM MMU component. Flushing ept tlbs of several address
> range can be done via single hypercall and new list flush function is
> used in the kvm_mmu_commit_zap_page() and FNAME(sync_page). This patchset
> also adds more hv ept tlb range flush support in more KVM MMU function.
> 
> Change since v1:
>        1) Make flush list as a hlist instead of list in order to 
>        keep struct kvm_mmu_page size.
>        2) Add last_level flag in the struct kvm_mmu_page instead
>        of spte pointer
>        3) Move tlb flush from kvm_mmu_notifier_clear_flush_young() to kvm_age_hva()
>        4) Use range flush in the kvm_vm_ioctl_get/clear_dirty_log()

Looks good except for the confusion on sp->last_level (which was mostly
mine---sorry about that).  I think it can still make 5.1.

However, note that I've never received "KVM/MMU: Use tlb range flush  in
the kvm_age_hva()".

Paolo
