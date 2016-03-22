From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PULL 0/3] KVM/ARM Fixes for v4.6-rc1
Date: Tue, 22 Mar 2016 11:48:13 +0100
Message-ID: <56F122ED.3000105@redhat.com>
References: <1458634776-18388-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE5EB40F9B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2016 06:47:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1HlRa9MpG2Zf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2016 06:47:40 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 77BBB40BDA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2016 06:47:39 -0400 (EDT)
In-Reply-To: <1458634776-18388-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 22/03/2016 09:19, Christoffer Dall wrote:
> The following changes since commit 643ad15d47410d37d43daf3ef1c8ac52c281efa5:
> 
>   Merge branch 'mm-pkeys-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2016-03-20 19:08:56 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.6-rc1
> 
> for you to fetch changes up to a6cdf1c08cbfe0818a3d8042844d75bf74fd82bd:
> 
>   kvm: arm64: Disable compiler instrumentation for hypervisor code (2016-03-21 14:02:17 +0100)
> 
> ----------------------------------------------------------------
> KVM/ARM Changes for v4.6-rc1
> 
> Second round of patches for v4.6-rc1, fixing a small handful of issue:
>  - disable preemption when calling smp_call_function_many
>  - Make kvm_ksym_ref work on VHE systems again after KASRL breakage
>  - Disable compiler instrumentation for hypervisor code that could make
>    KVM/arm64 blow up.
> 
> ----------------------------------------------------------------
> Catalin Marinas (1):
>       kvm: arm64: Disable compiler instrumentation for hypervisor code
> 
> Eric Auger (1):
>       KVM: arm/arm64: disable preemption when calling smp_call_function_many
> 
> Marc Zyngier (1):
>       arm64: KVM: Turn kvm_ksym_ref into a NOP on VHE
> 
>  arch/arm/kvm/arm.c               | 2 ++
>  arch/arm64/include/asm/kvm_asm.h | 8 +++++++-
>  arch/arm64/kvm/hyp/Makefile      | 4 ++++
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 

Pulled, thanks.

Paolo
