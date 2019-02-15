From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH V2 3/10] KVM/MMU: Add last_level in the struct
 mmu_spte_page
Date: Fri, 15 Feb 2019 16:22:43 +0100
Message-ID: <d9043bc8-d006-bf64-2047-79a9b6f98183@redhat.com>
References: <20190202013825.51261-1-Tianyu.Lan@microsoft.com>
 <20190202013825.51261-4-Tianyu.Lan@microsoft.com>
 <572a6ce3-23f6-7b16-a070-4d4a81ee4335@redhat.com>
 <CAOLK0pzXnvk=FsfjH07jUyRJGpeiNG7-9vR9Vo0mLJtdPnt_7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BEA74A0CC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Feb 2019 10:23:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OrmwHfYQ4ShZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Feb 2019 10:23:02 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42D2A40493
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Feb 2019 10:23:02 -0500 (EST)
In-Reply-To: <CAOLK0pzXnvk=FsfjH07jUyRJGpeiNG7-9vR9Vo0mLJtdPnt_7Q@mail.gmail.com>
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
To: Tianyu Lan <lantianyu1986@gmail.com>
Cc: kvm <kvm@vger.kernel.org>, catalin.marinas@arm.com, will.deacon@arm.com, paulus@ozlabs.org, "H. Peter Anvin" <hpa@zytor.com>, kys@microsoft.com, kvmarm@lists.cs.columbia.edu, mpe@ellerman.id.au, the arch/x86 maintainers <x86@kernel.org>, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, Ingo Molnar <mingo@redhat.com>, benh@kernel.crashing.org, jhogan@kernel.org, linux-mips@vger.kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, kvm-ppc@vger.kernel.org, bp@alien8.de, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>, ralf@linux-mips.org, paul.burton@mips.com, Vitaly Kuznetsov <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

On 15/02/19 16:05, Tianyu Lan wrote:
> Yes, you are right. Thanks to point out and will fix. The last_level
> flag is to avoid adding middle page node(e.g, PGD, PMD)
> into flush list. The address range will be duplicated if adding both
> leaf, node and middle node into flush list.

Hmm, that's not easy to track.  One kvm_mmu_page could include both leaf
and non-leaf page (for example a huge page for 0 to 2 MB and a page
table for 2 MB to 4 MB).

Is this really needed?  First, your benchmarks so far have been done
with sp->last_level always set to true.  Second, you would only
encounter this optimization in kvm_mmu_commit_zap_page when zapping a 1
GB region (which then would be invalidated twice, at both the PMD and
PGD level) or bigger.

Paolo
