Received: from out-40.mta0.migadu.com (out-40.mta0.migadu.com [91.218.175.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0C511196
	for <kvmarm@lists.linux.dev>; Fri,  7 Jul 2023 17:16:18 +0000 (UTC)
Date: Fri, 7 Jul 2023 17:16:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1688750175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MgD/1IVW5Bgo6C3rsqk1ZusNkWbZT0MYcmbLOXvyZ0A=;
	b=CdaxDCJR240gLrTWtVoeHO2R6gLfUd9xPnAwu59N9o4AZk20jbnzIKDFRc2sGZYCcWGUcF
	z80ksCHzKWmG+AZk20trbkVD4KN3KMmwTfjfIJNxQLMmTz0SFpvU8j6KtyTJzSiehVnYVH
	0tPfWPKFYiu1W+mxvAatu7Lj6r7GmiQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: chenxiang <chenxiang66@hisilicon.com>
Cc: maz@kernel.org, james.morse@arm.com, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH] KVM: arm64: Keep need_db always true in vgic_v4_put()
 when emulating WFI
Message-ID: <ZKhIXFlPykpvI8MG@linux.dev>
References: <1688720145-37923-1-git-send-email-chenxiang66@hisilicon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1688720145-37923-1-git-send-email-chenxiang66@hisilicon.com>
X-Migadu-Flow: FLOW_OUT

Hi Xiang,

Thanks for reporting this.

On Fri, Jul 07, 2023 at 04:55:45PM +0800, chenxiang wrote:
> When enabled GICv4.1 on Kunpeng 920 platform with 6.4 kernel (preemptible
> kernel), running a vm with 128 vcpus on 64 pcpu, sometimes vm is not booted
> successfully, and we find there is a situation that doorbell interrupt will
> not occur event if there is a pending interrupt.

Oh, that's no good.

> ---
>  arch/arm64/kvm/vgic/vgic-v4.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
> index c1c28fe..37152cf8 100644
> --- a/arch/arm64/kvm/vgic/vgic-v4.c
> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
> @@ -343,6 +343,9 @@ int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db)
>  	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
>  		return 0;
>  
> +	if (vcpu->stat.generic.blocking == 1)
> +		need_db = true;
> +

As I understand it, the issue really comes from the fact that @need_db
is always false when called from vgic_v3_put(). I'd rather we not
override the argument, as that could have unintended consequences in the
future.

You could also use the helper we already have for determining if a vCPU
is blocking, which we could use as a hint for requesting a doorbell
interrupt on sched out.

Putting the two comments together, I arrived at the following (untested)
diff. I don't have a GICv4 system on hand, sadly. Mind taking it for a
spin?

--
Thanks,
Oliver

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 93a47a515c13..8c743643b122 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -756,7 +756,7 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
-	WARN_ON(vgic_v4_put(vcpu, false));
+	WARN_ON(vgic_v4_put(vcpu, kvm_vcpu_is_blocking(vcpu)));
 
 	vgic_v3_vmcr_sync(vcpu);
 
