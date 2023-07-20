Received: from out-43.mta1.migadu.com (out-43.mta1.migadu.com [95.215.58.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897092FA4B
	for <kvmarm@lists.linux.dev>; Thu, 20 Jul 2023 17:19:37 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689873575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iYivxBWQ3YZQD179gp3mRMOft6cNkrnqZJhnecUb8kk=;
	b=lo7+AI8HOdXJoMbn030Hs420eLQ10ibM8nACrZO2FcXoUKxenC+5mGyAIA9D3g37Ei8b0N
	9TsVXovL7XTWEG76ZO51sIC+IrYh4aQQ5qWYu48lmJmToB3xbB7xTctOXka5DejDutnHeh
	GmqOAnIrPV5D/DdDeIOxjT05AtzRvTA=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev,
	Jing Zhang <jingzhangos@google.com>,
	James Morse <james.morse@arm.com>,
	Colton Lewis <coltonlewis@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Fix hardware enable/disable flows for pKVM
Date: Thu, 20 Jul 2023 17:19:22 +0000
Message-ID: <168987354993.692466.16634039861064795931.b4-ty@linux.dev>
In-Reply-To: <20230719215725.799162-1-rananta@google.com>
References: <20230719215725.799162-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 19 Jul 2023 21:57:25 +0000, Raghavendra Rao Ananta wrote:
> When running in protected mode, the hyp stub is disabled after pKVM is
> initialized, meaning the host cannot enable/disable the hyp at
> runtime. As such, kvm_arm_hardware_enabled is always 1 after
> initialization, and kvm_arch_hardware_enable() never enables the vgic
> maintenance irq or timer irqs.
> 
> Unconditionally enable/disable the vgic + timer irqs in the respective
> calls, instead relying on the percpu bookkeeping in the generic code
> to keep track of which cpus have the interrupts unmasked.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Fix hardware enable/disable flows for pKVM
      https://git.kernel.org/kvmarm/kvmarm/c/c718ca0e9940

--
Best,
Oliver
