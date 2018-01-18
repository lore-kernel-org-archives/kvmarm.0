From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 19/19] arm64: Update the KVM memory map documentation
Date: Thu, 18 Jan 2018 21:28:31 +0100
Message-ID: <20180118202831.GG21802@cbox>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
 <20180104184334.16571-20-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7318849E2B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jan 2018 15:23:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JmyfsLEnZaWp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jan 2018 15:23:26 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 971AC49E27
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jan 2018 15:23:26 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id b21so292048wme.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jan 2018 12:28:34 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20180104184334.16571-20-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 04, 2018 at 06:43:34PM +0000, Marc Zyngier wrote:
> Update the documentation to reflect the new tricks we play on the
> EL2 mappings...
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  Documentation/arm64/memory.txt | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
> index 671bc0639262..ea64e20037f6 100644
> --- a/Documentation/arm64/memory.txt
> +++ b/Documentation/arm64/memory.txt
> @@ -86,9 +86,11 @@ Translation table lookup with 64KB pages:
>   +-------------------------------------------------> [63] TTBR0/1
>  
>  
> -When using KVM without the Virtualization Host Extensions, the hypervisor
> -maps kernel pages in EL2 at a fixed offset from the kernel VA. See the
> -kern_hyp_va macro for more details.
> +When using KVM without the Virtualization Host Extensions, the
> +hypervisor maps kernel pages in EL2 at a fixed offset (modulo a random
> +offset) from the linear mapping. See the kern_hyp_va macro and
> +kvm_update_va_mask function for more details. MMIO devices such as
> +GICv2 gets mapped next to the HYP idmap page.
>  
>  When using KVM with the Virtualization Host Extensions, no additional
>  mappings are created, since the host kernel runs directly in EL2.
> -- 
> 2.14.2
> 
