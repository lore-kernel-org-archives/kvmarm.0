From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 05/10] KVM: arm/arm64: don't clear exit request from
 caller
Date: Sat, 6 May 2017 20:12:56 +0200
Message-ID: <20170506181256.GB5923@cbox>
References: <20170503160635.21669-1-drjones@redhat.com>
 <20170503160635.21669-6-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFDB840625
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 May 2017 14:09:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iuELcd6kMsK9 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  6 May 2017 14:09:51 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD20B405DA
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 May 2017 14:09:51 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id u65so47451337wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 06 May 2017 11:13:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170503160635.21669-6-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 03, 2017 at 06:06:30PM +0200, Andrew Jones wrote:
> VCPU requests that the receiver should handle should only be cleared
> by the receiver. 

I cannot parse this sentence.

> Not only does this properly implement the protocol,
> but also avoids bugs where one VCPU clears another VCPU's request,
> before the receiving VCPU has had a chance to see it.

Is this an actual race we have currently or just something thay may
happen later.  Im' not sure.

> ARM VCPUs
> currently only handle one request, EXIT, and handling it is achieved
> by checking pause to see if the VCPU should sleep.

This makes sense.  So forget my comment on the previous patch about
getting rid of the pause flag.

> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm/kvm/arm.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 9174ed13135a..7be0d9b0c63a 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -553,7 +553,6 @@ void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu)
>  {
>  	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
>  
> -	kvm_clear_request(KVM_REQ_VCPU_EXIT, vcpu);
>  	vcpu->arch.pause = false;
>  	swake_up(wq);
>  }
> @@ -625,7 +624,14 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  		update_vttbr(vcpu->kvm);
>  
> -		if (vcpu->arch.power_off || vcpu->arch.pause)
> +		if (kvm_request_pending(vcpu)) {
> +			if (kvm_check_request(KVM_REQ_VCPU_EXIT, vcpu)) {
> +				if (vcpu->arch.pause)
> +					vcpu_sleep(vcpu);
> +			}

Can we factor out this bit to a separate function,
kvm_handle_vcpu_requests() or something like that?

> +		}
> +
> +		if (vcpu->arch.power_off)
>  			vcpu_sleep(vcpu);
>  
>  		/*
> -- 
> 2.9.3
> 
Thanks,
-Christoffer
