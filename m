Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1157919BDF
	for <kvmarm@lists.linux.dev>; Wed, 11 Oct 2023 15:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DJpupm4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96D7C433C7;
	Wed, 11 Oct 2023 15:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1697039691;
	bh=jQoCWV0LLSnpXnSUdI4fT3RNp9XP0wcuYGalGwjpAJU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DJpupm4Kiv4tPJPKCZlHQcWxk1Vkukq5KyySJz2yJm8vTQQQ66njkuCxCN+f5cdsm
	 JPwXGdxWeOnUHOaNl0nZtwJYrnHuGfntBfFeZEscsa/uF70UU5pxdAc4TC2+FPcxZJ
	 wNQbAH5RHQfimRSlHLlZ9I5EJR0wK39Em52Cho9GGxtev+PxXNOe6+yJTkx20+Z1JP
	 U3YYKmBtww8d3CeNA237Z7np2QbOAqhiYMGAcG5yg7GuSDNMEnbXDyDgg2LDjinAUf
	 94JD3BzhCB1NIGqrLsuZlBXO9cg55VHk934yDLZ8lVJY4pCTY2SihVdPculhGEdOob
	 Rhr2kyQCGegaw==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qqbXt-003Cki-Ao;
	Wed, 11 Oct 2023 16:54:49 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Wed, 11 Oct 2023 16:54:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, James Morse
 <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Raghavendra Rao Ananta <rananta@google.com>, Mark
 Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>, James Clark
 <james.clark@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Disallow vPMU for NV guests
In-Reply-To: <20231011081649.3226792-2-oliver.upton@linux.dev>
References: <20231011081649.3226792-1-oliver.upton@linux.dev>
 <20231011081649.3226792-2-oliver.upton@linux.dev>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <281b88c0d74b9260b659e6be579a4984@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, rananta@google.com, mark.rutland@arm.com, will@kernel.org, james.clark@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2023-10-11 09:16, Oliver Upton wrote:
> The existing PMU emulation code is inadequate for use with nested
> virt. Disable the feature altogether with NV until the hypervisor
> controls are handled correctly.

Could you at least mention *what* is missing? Most of the handling
should identical, and the couple of bits what would need to be
handled (such as MDCR_EL2) are not covered by this disabling.

As it is stands, I'm not there is much to be gained from this.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
