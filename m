From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] ARM: KVM: Correctly order SGI register entries in the
 cp15 array
Date: Thu, 4 Oct 2018 10:19:54 -0700
Message-ID: <1334e22d-a64b-9116-e8a5-448eacbecf45@gmail.com>
References: <20181004092946.59836-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B2214A2A9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Oct 2018 13:20:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zSdNu+Y4MVud for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Oct 2018 13:20:07 -0400 (EDT)
Received: from mail-ed1-f67.google.com (mail-ed1-f67.google.com
 [209.85.208.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 855994A1D1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Oct 2018 13:20:07 -0400 (EDT)
Received: by mail-ed1-f67.google.com with SMTP id c22-v6so9273142edc.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Oct 2018 10:20:07 -0700 (PDT)
In-Reply-To: <20181004092946.59836-1-marc.zyngier@arm.com>
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
To: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/04/2018 02:29 AM, Marc Zyngier wrote:
> The ICC_ASGI1R and ICC_SGI0R register entries in the cp15 array
> are not correctly ordered, leading to a BUG() at boot time.
> 
> Move them to their natural location.
> 
> Fixes: 3e8a8a50c7ef ("KVM: arm: vgic-v3: Add support for ICC_SGI0R and ICC_ASGI1R accesses")
> Reported-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
> Paolo, Radim,
> 
> Could you please send this patch directly to Greg so that it makes it
> into 4.19? I thought I had it fixed long before the merge window, and
> obviously didn't...

Thanks for the quick fix! I probably won't be able to test this until 8h
from now but this looks obviously correct.

> 
> Thanks,
> 
> 	M.
> 
>  arch/arm/kvm/coproc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
> index 450c7a4fbc8a..cb094e55dc5f 100644
> --- a/arch/arm/kvm/coproc.c
> +++ b/arch/arm/kvm/coproc.c
> @@ -478,15 +478,15 @@ static const struct coproc_reg cp15_regs[] = {
>  
>  	/* ICC_SGI1R */
>  	{ CRm64(12), Op1( 0), is64, access_gic_sgi},
> -	/* ICC_ASGI1R */
> -	{ CRm64(12), Op1( 1), is64, access_gic_sgi},
> -	/* ICC_SGI0R */
> -	{ CRm64(12), Op1( 2), is64, access_gic_sgi},
>  
>  	/* VBAR: swapped by interrupt.S. */
>  	{ CRn(12), CRm( 0), Op1( 0), Op2( 0), is32,
>  			NULL, reset_val, c12_VBAR, 0x00000000 },
>  
> +	/* ICC_ASGI1R */
> +	{ CRm64(12), Op1( 1), is64, access_gic_sgi},
> +	/* ICC_SGI0R */
> +	{ CRm64(12), Op1( 2), is64, access_gic_sgi},
>  	/* ICC_SRE */
>  	{ CRn(12), CRm(12), Op1( 0), Op2(5), is32, access_gic_sre },
>  
> 


-- 
Florian
