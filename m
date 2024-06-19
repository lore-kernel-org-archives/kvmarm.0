Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FD07D40E
	for <kvmarm@lists.linux.dev>; Wed, 19 Jun 2024 08:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718786678; cv=none; b=RPrzmn4+6fZ2Hzhj8EVLOceG/2G7BcNOrylyoU1acB3DuBy/y8rV/kqBNYwUBkD/u64/b/7tLCv1w1OWMbm8N/LfxlqbGPnEcYMbL/Dj4p7O2goVj67z0cHjWjGw8ah1aQ64NrCDd4Thr0O7aCSkfw+HCuPIihRXTnBJOA5bqls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718786678; c=relaxed/simple;
	bh=5aCPh77Ldx8FTswghU8WkSj+lO4LfEdFUS6n8x5JdU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ftg1ba9FOCMyLSg7h921TEi0prpPyFE+4fO+fEWLdXV2WF8HRW/d9VIjOTaY9OmZ5ybgjbrxoYBLuDwnhu315jObqoCc//c0UYcbryMIYkQEQusOblDpAxU3n5n3GAofjP18K92VarCLWoikDycQ78YSMk21P/VPhXMz0ot56pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vjxk5zuK; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vjxk5zuK"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718786675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wEXaKHJtfpcG478YA2q4EITe1Z4seqreYLJOQ6rw9gg=;
	b=Vjxk5zuKQ2UcS2p9UR8OCa7u7zF/n0n0lyRqtyV/LOyIj8fOKIwTxzRXUXYXr0AbimLRaw
	WJsQAIGDG7wXxbO8TkEOX8TOxkmOiTKUYbHCp7IvGe82CLNVqpnXngIrjqdzNAw0/DHP6b
	OUPnF59XoE72HWbffe1m1N2cld/FwsA=
X-Envelope-To: oliver.upton@linux.dev
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: maz@kernel.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: nv: Use GFP_KERNEL_ACCOUNT for sysreg_masks allocation
Date: Wed, 19 Jun 2024 08:44:25 +0000
Message-ID: <171878665214.244284.3784152770789758409.b4-ty@linux.dev>
In-Reply-To: <20240617181018.2054332-1-oliver.upton@linux.dev>
References: <20240617181018.2054332-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 17 Jun 2024 18:10:18 +0000, Oliver Upton wrote:
> Of course, userspace is in the driver's seat for struct kvm and
> associated allocations. Make sure the sysreg_masks allocation
> participates in kmem accounting.
> 
> 

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: nv: Use GFP_KERNEL_ACCOUNT for sysreg_masks allocation
      https://git.kernel.org/kvmarm/kvmarm/c/3dc14eefa504

--
Best,
Oliver
