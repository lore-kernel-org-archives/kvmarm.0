Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816FF10954
	for <kvmarm@lists.linux.dev>; Mon, 20 Nov 2023 09:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCOor4pL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEFAC433C7;
	Mon, 20 Nov 2023 09:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700471751;
	bh=ulfrs1lwWSLiXa93qQO9UqueURMN8+QeUnxSoLFXX0Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cCOor4pLsOHql5WLvcGXZEYvoJJgCdP0dv7gc9dgTo0RnGdI5D/8iHTgNxiym7Nj8
	 HC8t211AYj0Fg8YlBzkSpaZdVvRGIY4sqBh5fchkBYntgra/yoClh23RI7wLSWdhwe
	 qNXAHk3cLoputk93bBuMHE6mWP9CYewx/CvOYPO75iV5lYufQy0WrMJks5/ZjJh3HH
	 rm3FR8ewEdd8aIhcxRopp5udjy5ou5ka59n70KKKk7mRNQY5+mucUqV9zmrpRAzCMW
	 fmoiWCDtZWmCyy0Ibu2wO0eWCj2FUHXj6AssDx8APgs0r3aMvYr6biIxb3y06rYJxF
	 TbWGhpMfCvqpA==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r50Ng-00EfhU-Gk;
	Mon, 20 Nov 2023 09:15:48 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 20 Nov 2023 09:15:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, James Morse
 <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
 eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, wanghaibin.wang@huawei.com
Subject: Re: [PATCH v2] KVM: arm/arm64: GICv4: Do not perform a map to a
 mapped vLPI
In-Reply-To: <20231119104941.1952-1-jiangkunkun@huawei.com>
References: <20231119104941.1952-1-jiangkunkun@huawei.com>
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <8a84365107c856e266b206e6e2374ec3@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: jiangkunkun@huawei.com, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, jean-philippe@linaro.org, eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2023-11-19 10:49, Kunkun Jiang wrote:
> Before performing a map, let's check whether the vLPI has been
> mapped. This corresponds to checking whether a vLPI is valid
> before unmap it.

I don't understand this last sentence. Mapping and unmapping
are two different actions, and we shouldn't conflate them.

> 
> Fixes: 196b136498b3 ("KVM: arm/arm64: GICv4: Wire mapping/unmapping of
> VLPIs in VFIO irq bypass")
> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> ---
>  arch/arm64/kvm/vgic/vgic-v4.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c 
> b/arch/arm64/kvm/vgic/vgic-v4.c
> index 339a55194b2c..fb60bbb94460 100644
> --- a/arch/arm64/kvm/vgic/vgic-v4.c
> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
> @@ -436,6 +436,11 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, 
> int virq,
>  	if (ret)
>  		goto out;
> 
> +	if (irq->hw) {
> +		ret = 0;

ret is obviously already 0.

> +		goto out;
> +	}
> +
>  	/*
>  	 * Emit the mapping request. If it fails, the ITS probably
>  	 * isn't v4 compatible, so let's silently bail out. Holding

Furthermore, this really deserves a comment. Something like:

/* Silently exit if the vLPI is already mapped */

With these changes:

Acked-by: Marc Zyngier <maz@kernel.org>

Oliver, can you please apply these changes and queue it as a fix
for 6.7?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
