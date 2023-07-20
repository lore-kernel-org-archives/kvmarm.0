Received: from out-57.mta1.migadu.com (out-57.mta1.migadu.com [95.215.58.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4F82FA4B
	for <kvmarm@lists.linux.dev>; Thu, 20 Jul 2023 17:19:34 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689873572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bIl53wXMPa4HkzIzFhBZtZ5ptrFFMx1S/HNsV1bnoM4=;
	b=RBptZ4S8+Z6+kTQE+ynI5dGB9ZkRW6xFEVlUooN6o4VRojsICmdqeGbjt5ZD1WHPRhsbB7
	j1lWtZ3rTYYGVGTbbrFphKdWa7hHLvUH9AtXEHgjC5/KrEZnWDzOABDW7MXeL0PMd0BsGi
	bRNm+tlmoTzy0iebEVzxIKEQvdTs7J4=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Rephrase percpu enable/disable tracking in terms of hyp
Date: Thu, 20 Jul 2023 17:19:21 +0000
Message-ID: <168987354990.692466.7704411520002432992.b4-ty@linux.dev>
In-Reply-To: <20230719231855.262973-1-oliver.upton@linux.dev>
References: <20230719231855.262973-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 19 Jul 2023 23:18:55 +0000, Oliver Upton wrote:
> kvm_arm_hardware_enabled is rather misleading, since it doesn't track
> the state of all hardware resources needed for running a VM. What it
> actually tracks is whether or not the hyp cpu context has been
> initialized.
> 
> Since we're now at the point where vgic + timer irq management has
> been separated from kvm_arm_hardware_enabled, rephrase it (and the
> associated helpers) to make it clear what state is being tracked.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Rephrase percpu enable/disable tracking in terms of hyp
      https://git.kernel.org/kvmarm/kvmarm/c/733c758e509b

--
Best,
Oliver
