Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5A21F09BF
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 07:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757401257; cv=none; b=txDS5/ICgiSCCxhaP+o4NtOr3r4fwrfbSN7+HXmuGWvebRE0widn1J6C7AAHVKJO8IBI7CI4pCHJou4z4U/+uj8VoQHrwR7pmFwQewzMvA4Re0RBVPJnq6sAn8GKLo0fO7V2ftPzPIX+iNV8LBrPsoMVzjhKDZKyYYNMwn4vd4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757401257; c=relaxed/simple;
	bh=zQ/SEToBnCahJDFB3j4VROEtK163bCT4JP8R4kUel3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LHCtaxj4cEPThG3gxkMnLAAb4+0w34zHATFxOlIsW1qjlEShKFILTi+C2mX9uPwooiO1scBq1uhDoR25o7dWc6RPEYwUz1Jl2GR1p+wngedG+eSM8GrGRlphIUujbZGrOx0cKq8O+zC0LDQgV+7amdDs8NYC9mBBM+XuFqhoeTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r3cdzDZc; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r3cdzDZc"
Date: Tue, 9 Sep 2025 00:00:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757401253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sS9KBzVCPbJWJWQ0UZ0j5q0+Yoxsvx3SirUPYIS2U7w=;
	b=r3cdzDZcXKNh1ojPr0RNT8j7PkCqsztCRReeScRBIXigTRwrHQzCqgNV1zlusFoXRvpTUp
	bkd3wy/xGi0tFJNQXWn/bGYskpEVuq5v5jff5QslEy7u/c68ET842FIB7DAXkUmkVuxf3B
	U22VPhQz8M8BEg7jBu2ccv6ysABXPR8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jinqian Yang <yangjinqian1@huawei.com>
Cc: yuzenghui@huawei.com, maz@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, liuyonglong@huawei.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH v2 0/3] KVM: arm64: make EL2 feature fields writable in
 ID_AA64MMFR1_EL1
Message-ID: <aL_QjZbkvHsYIRt6@linux.dev>
References: <20250909034415.3822478-1-yangjinqian1@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909034415.3822478-1-yangjinqian1@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 09, 2025 at 11:44:12AM +0800, Jinqian Yang wrote:
> Allow userspace to downgrade EL2 features (VH, TWED, HCX) to ensure VM live
> migration compatibility between hosts with varying feature support.
> 
> v1: https://lore.kernel.org/linux-arm-kernel/20250325121126.1380681-1-yangjinqian1@huawei.com/
> 
> Change Log:
> v1->v2:
>   -Added support for downgrading TWED and VH fields.
>   -Added corresponding test cases to the set_id_regs selftest.
> 
> Jinqian Yang (3):
>   KVM: arm64: Make ID_AA64MMFR1_EL1.HCX writable from userspace
>   KVM: arm64: Make ID_AA64MMFR1_EL1.TWED writable from userspace
>   KVM: arm64: Make ID_AA64MMFR1_EL1.VH writable from userspace
> 
>  arch/arm64/kvm/sys_regs.c                       | 3 ---
>  tools/testing/selftests/kvm/arm64/set_id_regs.c | 3 +++

General comment: please make do kernel and selftest changes in separate
patches.

Thanks,
Oliver
