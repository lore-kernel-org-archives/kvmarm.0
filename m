From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH] arm/arm64: KVM: fix missing unlock on error in
 kvm_vgic_create()
Date: Fri, 27 Feb 2015 12:07:51 +0000
Message-ID: <54F05E17.9090904@arm.com>
References: <1425037305-23292-1-git-send-email-weiyj_lk@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B62A46C61
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Feb 2015 07:02:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b2Edm3Rd6bmx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Feb 2015 07:02:12 -0500 (EST)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D39B46C51
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Feb 2015 07:02:11 -0500 (EST)
In-Reply-To: <1425037305-23292-1-git-send-email-weiyj_lk@163.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "weiyj_lk@163.com" <weiyj_lk@163.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Wei,

On 27/02/15 11:41, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add the missing unlock before return from function kvm_vgic_create()
> in the error handling case.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  virt/kvm/arm/vgic.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 0cc6ab6..4b2c2e7 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1583,8 +1583,10 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>  	 * emulation. So check this here again. KVM_CREATE_DEVICE does
>  	 * the proper checks already.
>  	 */
> -	if (type == KVM_DEV_TYPE_ARM_VGIC_V2 && !vgic->can_emulate_gicv2)
> -		return -ENODEV;
> +	if (type == KVM_DEV_TYPE_ARM_VGIC_V2 && !vgic->can_emulate_gicv2) {
> +		ret = -ENODEV;
> +		goto out;
> +	}

Ah, good catch. Embarrassing that that could slip through ...


Acked-by: Andre Przywara <andre.przywara@arm.com>


Out of curiosity: did you see it hang or was this just by looking at the
code? I thought that I tested this case ...

Cheers,
Andre.
