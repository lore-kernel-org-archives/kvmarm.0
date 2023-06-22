Received: from out-31.mta1.migadu.com (out-31.mta1.migadu.com [95.215.58.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A435A200A8
	for <kvmarm@lists.linux.dev>; Thu, 22 Jun 2023 17:18:13 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687454291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gHykEPQXA9+eJ0Z724D3BRxoxSL/mGpodLg/RPdfWeM=;
	b=eywEDEMULiEAxaN1fq9QxYJQSEs1YYsog/5+x632SInLRcEKkQEy3UEkISzDwpYvGYMn7w
	RX8Sw7G9hSZ/XR1mUaAMeymqKzy2Tayh0+ly7amaTcsl3v6X7xS2ufD0QitdSMq5capYnr
	hl7e5tLitQ8LBw/duGrlpfnQHkt878g=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix misuse of KVM_ARM_VCPU_POWER_OFF bit index
Date: Thu, 22 Jun 2023 17:17:44 +0000
Message-ID: <168745425982.2113651.18159840293696452756.b4-ty@linux.dev>
In-Reply-To: <20230622160922.1925530-1-oliver.upton@linux.dev>
References: <20230622160922.1925530-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 22 Jun 2023 16:09:22 +0000, Oliver Upton wrote:
> KVM_ARM_VCPU_POWER_OFF is as bit index, _not_ a literal bitmask.
> Nonetheless, commit e3c1c0cae31e ("KVM: arm64: Relax invariance
> of KVM_ARM_VCPU_POWER_OFF") started using it that way, meaning that
> powering off a vCPU with the KVM_ARM_VCPU_INIT ioctl is completely
> broken.
> 
> Fix it by using a shifted bit for the bitwise operations instead.
> 
> [...]

Applied, w/ Marc's suggestion to just use BIT() instead.

[1/1] KVM: arm64: Fix misuse of KVM_ARM_VCPU_POWER_OFF bit index
      https://git.kernel.org/kvmarm/kvmarm/c/192df2aa0113

--
Best,
Oliver
