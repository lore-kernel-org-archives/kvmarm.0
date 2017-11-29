From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] kvm: arm: don't treat unavailable HYP mode as an error
Date: Wed, 29 Nov 2017 18:12:59 +0100
Message-ID: <20171129171259.GC10563@lvm>
References: <20171128151819.18669-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E5ED49D6F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Nov 2017 12:10:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gAeoW6VGn2u0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Nov 2017 12:10:08 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C3D640795
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Nov 2017 12:10:08 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id g75so7896760wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Nov 2017 09:13:02 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20171128151819.18669-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 28, 2017 at 03:18:19PM +0000, Ard Biesheuvel wrote:
> Since it is perfectly legal to run the kernel at EL1, it is not
> actually an error if HYP mode is not available when attempting to
> initialize KVM, given that KVM support cannot be built as a module.
> So demote the kvm_err() to kvm_info(), which prevents the error from
> appearing on an otherwise 'quiet' console.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  virt/kvm/arm/arm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 772bf74ac2e9..988c888a9667 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1460,7 +1460,7 @@ int kvm_arch_init(void *opaque)
>  	bool in_hyp_mode;
>  
>  	if (!is_hyp_mode_available()) {
> -		kvm_err("HYP mode not available\n");
> +		kvm_info("HYP mode not available\n");
>  		return -ENODEV;
>  	}
>  
> -- 
> 2.11.0
> 
Applied, thanks.
-Christoffer
