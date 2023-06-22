Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436E78494
	for <kvmarm@lists.linux.dev>; Thu, 22 Jun 2023 16:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA390C433C8;
	Thu, 22 Jun 2023 16:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687450446;
	bh=wTQQxsVDHIagtHlIima2kL8KO25tjq/CZK+I3bbJocs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fPlTLFPx+kr66YUVjWn5T/QQpM/2wwo/WmsFThkQPBaSmZhRFXmp/ZtoauGy/9PkH
	 FNLvXFBJYpzhLFsUzPUNdQmoJIJQJyyN1SxWNDrSmRKzbb40bw7id6T+HQwqBkCvgp
	 M1vZdi90fgGcn6bB+uEqp8ctlBU12kq05VFNsTaQeoZ+aH8zKcxI6XSQ3qE8RnQIld
	 5gFMb81Zu+LjdM96uG03zdGEzDIVfCiDSfGQBkqdjgyDhyatdu2cDYEyWx+7n/GBMB
	 6HyYU/N9SEkZUxJAef9qZF9B0kzEp5q0qiNdTuZrDsJk4XJhtkUh1PYKw956jdPhSJ
	 49B023bHP8aWw==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qCMwe-007Wv0-9j;
	Thu, 22 Jun 2023 17:14:04 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 22 Jun 2023 17:14:04 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Dan
 Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] KVM: arm64: Fix misuse of KVM_ARM_VCPU_POWER_OFF bit
 index
In-Reply-To: <20230622160922.1925530-1-oliver.upton@linux.dev>
References: <20230622160922.1925530-1-oliver.upton@linux.dev>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <d22e2bfaa5056f8789140169e2701b97@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, kvmarm@lists.linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, dan.carpenter@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2023-06-22 17:09, Oliver Upton wrote:
> KVM_ARM_VCPU_POWER_OFF is as bit index, _not_ a literal bitmask.
> Nonetheless, commit e3c1c0cae31e ("KVM: arm64: Relax invariance
> of KVM_ARM_VCPU_POWER_OFF") started using it that way, meaning that
> powering off a vCPU with the KVM_ARM_VCPU_INIT ioctl is completely
> broken.
> 
> Fix it by using a shifted bit for the bitwise operations instead.
> 
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Fixes: e3c1c0cae31e ("KVM: arm64: Relax invariance of 
> KVM_ARM_VCPU_POWER_OFF")
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/arm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 80ca7ec269dc..7d20bfd77e1c 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1250,8 +1250,8 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct
> kvm_vcpu *vcpu,
>  	 * reflecting it in the finalized feature set, thus limiting its 
> scope
>  	 * to a single KVM_ARM_VCPU_INIT call.
>  	 */
> -	if (init->features[0] & KVM_ARM_VCPU_POWER_OFF) {
> -		init->features[0] &= ~KVM_ARM_VCPU_POWER_OFF;
> +	if (init->features[0] & (1UL << KVM_ARM_VCPU_POWER_OFF)) {
> +		init->features[0] &= ~(1UL << KVM_ARM_VCPU_POWER_OFF);
>  		power_off = true;
>  	}

Huhuh. Maybe use BIT() instead? Otherwise:

Acked-by: Marc Zyngier <maz@kernel.org>

         M.
-- 
Jazz is not dead. It just smells funny...
