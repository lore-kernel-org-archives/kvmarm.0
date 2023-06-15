Received: from out-17.mta1.migadu.com (out-17.mta1.migadu.com [95.215.58.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECBE6AA8
	for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 13:21:15 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686835273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xexRpuIonQHFJjtwmgMSB7F6YQ+u0In8R6TeQRpV2V8=;
	b=fLZBWFuY300HJMPHwr2nVsYMWWwXXtQJx/hS+1r5dO4buQQY/NcRVbnUikXjDDOw7LumLb
	S0SQOumbLT+qct126KiIgPJHPc9yuemhnnxdVeWMDmMEDrqnacFzmkPvJDB1Zav0Ois3o7
	zXmNky2x30pCvmdgjtDRUJ3F05QvNWc=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Cornelia Huck <cohuck@redhat.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	surajjs@amazon.com
Subject: Re: [PATCH v12 00/11] Support writable CPU ID registers from userspace
Date: Thu, 15 Jun 2023 13:20:20 +0000
Message-ID: <168683521445.136757.11581079122600495563.b4-ty@linux.dev>
In-Reply-To: <20230609190054.1542113-1-oliver.upton@linux.dev>
References: <20230609190054.1542113-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 9 Jun 2023 19:00:43 +0000, Oliver Upton wrote:
> In the interest of expediting the acceptance of the generalized ID
> register infrastructure, I have taken Jing's series and applied fixes
> according to the feedback of reviewers and my own interpretation.
> 
> The laundry list:
>  - Split and reorganize the changes to avoid introducing intermediate
>    regressions in the series. Don't want to break bisection! Sadly,
>    this requires introducing a bit of churn but to me is an acceptable
>    tradeoff.
> 
> [...]

Applied to kvmarm/next, thanks!

[01/11] KVM: arm64: Separate out feature sanitisation and initialisation
        https://git.kernel.org/kvmarm/kvmarm/c/a7a2c72ae014
[02/11] KVM: arm64: Relax invariance of KVM_ARM_VCPU_POWER_OFF
        https://git.kernel.org/kvmarm/kvmarm/c/e3c1c0cae31e
[03/11] KVM: arm64: Make vCPU feature flags consistent VM-wide
        https://git.kernel.org/kvmarm/kvmarm/c/2251e9ff1573
[04/11] KVM: arm64: Rewrite IMPDEF PMU version as NI
        https://git.kernel.org/kvmarm/kvmarm/c/f90f9360c3d7
[05/11] KVM: arm64: Reuse fields of sys_reg_desc for idreg
        https://git.kernel.org/kvmarm/kvmarm/c/d86cde6e335f
[06/11] KVM: arm64: Save ID registers' sanitized value per guest
        https://git.kernel.org/kvmarm/kvmarm/c/473341469042
[07/11] KVM: arm64: Use arm64_ftr_bits to sanitise ID register writes
        https://git.kernel.org/kvmarm/kvmarm/c/2e8bf0cbd058
[08/11] KVM: arm64: Use generic sanitisation for ID_(AA64)DFR0_EL1
        https://git.kernel.org/kvmarm/kvmarm/c/c118cead07a7
[09/11] KVM: arm64: Use generic sanitisation for ID_AA64PFR0_EL1
        https://git.kernel.org/kvmarm/kvmarm/c/c39f5974d38f
[10/11] KVM: arm64: Handle ID register reads using the VM-wide values
        https://git.kernel.org/kvmarm/kvmarm/c/6db7af0d5b2b
[11/11] KVM: arm64: Rip out the vestiges of the 'old' ID register scheme
        https://git.kernel.org/kvmarm/kvmarm/c/686672407e6e

--
Best,
Oliver
