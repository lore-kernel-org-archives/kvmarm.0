From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH 0/3] arm: KVM: VFP lazy switch in KVM Host Mode may save
 upto 98%
Date: Sun, 28 Jun 2015 10:57:09 -0700
Message-ID: <55903575.8060702@samsung.com>
References: <1435203028-23142-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A12C756BB5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Jun 2015 13:46:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i8esVDSJXRY6 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 28 Jun 2015 13:46:20 -0400 (EDT)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6B0C56BA8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Jun 2015 13:46:20 -0400 (EDT)
Received: from uscpsbgex3.samsung.com
 (u124.gpu85.samsung.co.kr [203.254.195.124]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NQO00GY11VR1A10@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Sun, 28 Jun 2015 13:57:27 -0400 (EDT)
In-reply-to: <1435203028-23142-1-git-send-email-m.smarduch@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: pbonzini@redhat.com, will.deacon@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc, Christoffer -

to clarify - this series may be causing a conflict with the arm64
basic approach, and arm32 exit code touch ups.

The intent for this series  is more of an RFC or preview, to get some
feedback - if this approach is sensible (I guess later applied to
arm64 as well if it is).

Thanks,
- Mario


On 06/24/2015 08:30 PM, Mario Smarduch wrote:
> Currently we do a lazy VFP switch in Hyp mode, but once we exit and re-enter hyp
> mode we trap again on VFP access. This mode has shown around 30-50% improvement
> running hackbench and lmbench.
> 
> This patch series extends lazy VFP switch beyond Hyp mode to KVM host mode.
> 
> 1 - On guest access we switch from host to guest and set a flag accessible to 
>     host
> 2 - On exit to KVM host, VFP state is restored on vcpu_put if flag is marked (1)
> 3 - Otherwise guest is resumed and continues to use its VFP registers. 
> 4 - In case of 2 on VM entry we set VFP trap flag to repeat 1.
> 
> If guest does not access VFP registers them implemenation remains the same.
> 
> Executing hackbench on Fast Models and Exynos arm32 board shows good
> results. Considering all exits 2% of the time KVM host lazy vfp switch is 
> invoked.
> 
> Howeverr this patch set requires more burn in time and testing under various 
> loads.
> 
> Currently ARM32 is addressed later ARM64.
> 
> Mario Smarduch (3):
>   define headers and offsets to mange VFP state
>   Implement lazy VFP switching outside of Hyp Mode
>   Add VFP lazy switch hooks in Host KVM
> 
>  arch/arm/include/asm/kvm_asm.h  |    1 +
>  arch/arm/include/asm/kvm_host.h |    3 +++
>  arch/arm/kernel/asm-offsets.c   |    1 +
>  arch/arm/kvm/arm.c              |   15 ++++++++++++
>  arch/arm/kvm/interrupts.S       |   49 +++++++++++++++++++++++++--------------
>  5 files changed, 51 insertions(+), 18 deletions(-)
> 
