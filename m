From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH V2 2/2] KVM: arm64: Increase number of user memslots to 508
Date: Thu, 23 Feb 2017 11:14:07 +0100
Message-ID: <20170223101407.GB1409@cbox>
References: <1486538141-30627-1-git-send-email-linucherian@gmail.com>
 <1486538141-30627-3-git-send-email-linucherian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F423840D56
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Feb 2017 05:13:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T6-4XFPjr-O0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Feb 2017 05:13:21 -0500 (EST)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BDD2340C56
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Feb 2017 05:13:21 -0500 (EST)
Received: by mail-wm0-f43.google.com with SMTP id r141so7053789wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Feb 2017 02:14:21 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1486538141-30627-3-git-send-email-linucherian@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linucherian@gmail.com
Cc: sunil.goutham@cavium.com, marc.zyngier@arm.com, linu.cherian@cavium.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 08, 2017 at 12:45:41PM +0530, linucherian@gmail.com wrote:
> From: Linu Cherian <linu.cherian@cavium.com>
> 
> Having only 32 memslots is a real constraint for the maximum
> number of PCI devices that can be assigned to a single guest.
> Assuming each PCI device/virtual function having two memory BAR
> regions, we could assign only 15 devices/virtual functions to a
> guest.
> 
> Hence increase KVM_USER_MEM_SLOTS to 508, so that KVM_MEM_SLOTS_NUM is
> 512 as done in other archs like x86 and powerpc.

Actually on powerpc they just define KVM_USER_MEM_SLOTS as 512 directly.

On x86 they define them as 509 and have 3 private mem slots.

I don't understand the difference and as far as I can tell we don't have
any private memslots on arm/arm64, so this is just weird to me.

Thanks,
-Christoffer

> 
> Signed-off-by: Linu Cherian <linu.cherian@cavium.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index e505038..88f017d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -30,7 +30,7 @@
>  
>  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
>  
> -#define KVM_USER_MEM_SLOTS 32
> +#define KVM_USER_MEM_SLOTS 508
>  #define KVM_PRIVATE_MEM_SLOTS 4
>  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
>  #define KVM_HALT_POLL_NS_DEFAULT 500000
> -- 
> 1.9.1
> 
