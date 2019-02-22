From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH V3 00/10] X86/KVM/Hyper-V: Add HV ept tlb range list flush
 support in KVM
Date: Fri, 22 Feb 2019 19:25:53 +0100
Message-ID: <75e9238a-f168-b90d-e1f1-89938e6df57a@redhat.com>
References: <20190222150637.2337-1-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190222150637.2337-1-Tianyu.Lan@microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: lantianyu1986@gmail.com
Cc: Lan Tianyu <Tianyu.Lan@microsoft.com>, benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com, christoffer.dall@arm.com, devel@linuxdriverproject.org, haiyangz@microsoft.com, hpa@zytor.com, jhogan@kernel.org, kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org, kvm@vger.kernel.org, kys@microsoft.com, linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, marc.zyngier@arm.com, mingo@redhat.com, mpe@ellerman.id.au, paul.burton@mips.com, paulus@ozlabs.org, ralf@linux-mips.org, rkrcmar@redhat.com, sashal@kernel.org, sthemmin@microsoft.com, tglx@linutronix.de, will.deacon@arm.com, x86@kernel.org, michael.h.kelley@microsoft.com, vkuznets@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 22/02/19 16:06, lantianyu1986@gmail.com wrote:
> From: Lan Tianyu <Tianyu.Lan@microsoft.com>
> 
> This patchset is to introduce hv ept tlb range list flush function
> support in the KVM MMU component. Flushing ept tlbs of several address
> range can be done via single hypercall and new list flush function is
> used in the kvm_mmu_commit_zap_page() and FNAME(sync_page). This patchset
> also adds more hv ept tlb range flush support in more KVM MMU function.
> 
> This patchset is based on the fix patch "x86/Hyper-V: Fix definition HV_MAX_FLUSH_REP_COUNT".
> (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1939455.html)

Note that this won't make it in 5.1 unless Linus releases an -rc8.
Otherwise, I'll get to it next week.

Thanks,

Paolo
