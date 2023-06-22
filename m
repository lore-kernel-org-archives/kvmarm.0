Received: from out-7.mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4B51F16A
	for <kvmarm@lists.linux.dev>; Thu, 22 Jun 2023 17:20:05 +0000 (UTC)
Date: Thu, 22 Jun 2023 17:20:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687454404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WckLBxk9OxSq5fZgxiuJq8OmJ9YI+NLDWnL+U8xBYTc=;
	b=thMCH8sTfbBGdRb4BZgzkBQAUZXrWLYMQ1jQlKY3ZebLXNOSMVzWm+LC7zVwrGvHiJ8FGL
	DOpv0kkxSmKFQR3CzqhKPdJMingJFiiVvCDEif2XJ6+Z/DCi8JbmzimNsYIs1sJwvPFGop
	3b+17RB7qatwqhwsxRr72PWw/B4ij2Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: kvmarm@lists.linux.dev
Subject: Re: [bug report] KVM: arm64: Relax invariance of
 KVM_ARM_VCPU_POWER_OFF
Message-ID: <ZJSCwWF/nFFkXY+W@linux.dev>
References: <50fed6cc-5772-4bb2-b72a-bc7e4f9e93d2@moroto.mountain>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50fed6cc-5772-4bb2-b72a-bc7e4f9e93d2@moroto.mountain>
X-Migadu-Flow: FLOW_OUT

Hey Dan,

On Thu, Jun 22, 2023 at 03:49:18PM +0300, Dan Carpenter wrote:
> Hello Oliver Upton,
> 
> The patch e3c1c0cae31e: "KVM: arm64: Relax invariance of
> KVM_ARM_VCPU_POWER_OFF" from Jun 9, 2023, leads to the following
> Smatch static checker warning:
> 
> 	arch/arm64/kvm/arm.c:1283 kvm_arch_vcpu_ioctl_vcpu_init()
> 	warn: bitwise AND condition is false here
> 
> arch/arm64/kvm/arm.c
>     1272 static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
>     1273                                          struct kvm_vcpu_init *init)
>     1274 {
>     1275         bool power_off = false;
>     1276         int ret;
>     1277 
>     1278         /*
>     1279          * Treat the power-off vCPU feature as ephemeral. Clear the bit to avoid
>     1280          * reflecting it in the finalized feature set, thus limiting its scope
>     1281          * to a single KVM_ARM_VCPU_INIT call.
>     1282          */
> --> 1283         if (init->features[0] & KVM_ARM_VCPU_POWER_OFF) {
> 
> Prior to this commit KVM_ARM_VCPU_POWER_OFF was a bit number.  I think
> it still should be.  As in:
> 
> #define KVM_ARM_VCPU_POWER_OFF BIT(0)
> 
>     1284                 init->features[0] &= ~KVM_ARM_VCPU_POWER_OFF;
>     1285                 power_off = true;
>     1286         }
>     1287 
>     1288         ret = kvm_vcpu_set_target(vcpu, init);
>     1289         if (ret)
>     1290                 return ret;
>     1291 

Thanks for the bug report. I had to go find my brown paper bag, but the
fix is now queued up for 6.5:

https://lore.kernel.org/kvmarm/20230622160922.1925530-1-oliver.upton@linux.dev/

-- 
Thanks,
Oliver
