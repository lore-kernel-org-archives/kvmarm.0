Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51D213C8F3
	for <kvmarm@lists.linux.dev>; Mon, 17 Mar 2025 20:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742241687; cv=none; b=gW/GQEjPwpe5E6sQJzk//N99Gs0wCN5asLKQ+hZf3rSs0C8I1VLi85futa4VKiTmYXssNVxFhusV1/k03PH/nYi682lX3dqFdZA/ugfRECNqWPWStg5hK2dnFP6eW79fW7BQGvf6HF2nuzDreDwKEzEscwWInx475nwpAuRp/gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742241687; c=relaxed/simple;
	bh=E/xZ+54KctjZ9m5sKDMSFIYRtt8Xn2G3hsazpBjuQBE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sfAnB15RBcJkIx/hAOlFTouCa8kFv8q/4an8H4Y5bEaH+Zzv53KDyLBuWi1uk5M2dbELRB64+9ZLquY+Mf6eR/cSn9EKsr/LGDR8cbluyQBUyiKDooIFpJgipz8yFhGGLrizNuscLP2EZ1sXQivCgv6fX8Ht485gwBl+qo4t7HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iSqMGIM5; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iSqMGIM5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742241680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vu17wjBsFBCZ0+3MLyENCrSMY6OUYDwd3aPaG2b678Y=;
	b=iSqMGIM5dt9iMPdojc31nopo9hKqmXZO6m/dgNFvLRNdYeReE7hDnUkJqKY7bShOAFHp5h
	DEY80ffWRrxSJCsfjRKiFbxYdTwJK8ck8aMHT+o57UoCcCjsFxx6bjWFwJhXdYFIc/Gg07
	nheG9vUQcD647tUcUEwt1m88nlV037Y=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Jones <andrew.jones@linux.dev>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	devel@daynix.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v5 0/5] KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
Date: Mon, 17 Mar 2025 13:01:07 -0700
Message-Id: <174224155547.1588441.3490436622132208645.b4-ty@linux.dev>
In-Reply-To: <20250315-pmc-v5-0-ecee87dab216@daynix.com>
References: <20250315-pmc-v5-0-ecee87dab216@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Sat, 15 Mar 2025 18:12:09 +0900, Akihiko Odaki wrote:
> Prepare vPMC registers for user-initiated changes after first run. This
> is important specifically for debugging Windows on QEMU with GDB; QEMU
> tries to write back all visible registers when resuming the VM execution
> with GDB, corrupting the PMU state. Windows always uses the PMU so this
> can cause adverse effects on that particular OS.
> 
> This series also contains patch "KVM: arm64: PMU: Set raw values from
> user to PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}", which reverts semantic
> changes made for the mentioned registers in the past. It is necessary
> to migrate the PMU state properly on Firecracker, QEMU, and crosvm.
> 
> [...]

Squashed in a fix for CONFIG_HW_PERF_EVENTS=n build.

Applied to next, thanks!

[1/5] KVM: arm64: PMU: Set raw values from user to PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
      https://git.kernel.org/kvmarm/kvmarm/c/f2aeb7bbd574
[2/5] KVM: arm64: PMU: Assume PMU presence in pmu-emul.c
      https://git.kernel.org/kvmarm/kvmarm/c/be5ccac3f15e
[3/5] KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
      https://git.kernel.org/kvmarm/kvmarm/c/64074ca8ca92
[4/5] KVM: arm64: PMU: Reload when user modifies registers
      https://git.kernel.org/kvmarm/kvmarm/c/1db4aaa05589
[5/5] KVM: arm64: PMU: Reload when resetting
      https://git.kernel.org/kvmarm/kvmarm/c/fe53538069bb

--
Best,
Oliver
