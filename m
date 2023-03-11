Received: from out-17.mta0.migadu.com (out-17.mta0.migadu.com [91.218.175.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BCF7B
	for <kvmarm@lists.linux.dev>; Sat, 11 Mar 2023 21:36:35 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1678570592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CDvJmKwcQ6mlkbKDImbYY9XC6Sv7fyBerr0ue+LLiOk=;
	b=R8Bg2lPLvmq62VycO4YPWKiU/8+NozgJtqQPdRaRKapbpdc+OkYIa5ziQsd/+npNvaCypP
	FKZNag1uHriCnYCbsoEyjsHU1T8WiJHNp/aZ7hzWRGUzlk/P1GpleGTJMhqfeoiDpYL6VL
	v2Yfi5CwblF4zRltau1qmsL8iaQzkQs=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2] KVM: arm64: timers: Convert per-vcpu virtual offset to a global value
Date: Sat, 11 Mar 2023 21:36:15 +0000
Message-Id: <167857054887.1651970.3335887833625425284.b4-ty@linux.dev>
In-Reply-To: <20230224191640.3396734-1-maz@kernel.org>
References: <20230224191640.3396734-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 24 Feb 2023 19:16:40 +0000, Marc Zyngier wrote:
> Having a per-vcpu virtual offset is a pain. It needs to be synchronized
> on each update, and expands badly to a setup where different timers can
> have different offsets, or have composite offsets (as with NV).
> 
> So let's start by replacing the use of the CNTVOFF_EL2 shadow register
> (which we want to reclaim for NV anyway), and make the virtual timer
> carry a pointer to a VM-wide offset.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: timers: Convert per-vcpu virtual offset to a global value
      https://git.kernel.org/kvmarm/kvmarm/c/47053904e182

--
Best,
Oliver
