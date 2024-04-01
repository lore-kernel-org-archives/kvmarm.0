Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC5A8BF0
	for <kvmarm@lists.linux.dev>; Mon,  1 Apr 2024 08:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711961279; cv=none; b=Es8A1h4N8f9V8yb2iE0BZRVoYLLcTLrh+vlIF82k5cH+zH3781sbq+MtB+XLHUxe56DGvLKo7pqG3s0g7ai0SiIGgOXAOFKewlH3p8jThkYH+v5JTkOCxlN+33z694xuO0UzEExU1l4Xkn9DhxQ+GxNMSmEsPXVidHPxoQdRSY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711961279; c=relaxed/simple;
	bh=W4oHhYT6Q8DpjYDzm9C1bReCYof1B8btPRunda7aBzo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zj3sFv8WCcitts3rqSAJbWhQ50xvKmeefY9o5xP7aXsA88xkgpNh/BNBffluMhUgaqCM0J28u5ZZkuwVz2uJnO4Lhsf8JpbKBRc1KS0mdRjJjoGxVkpKyVYaP/nTlEDq9L8bqcKRqbyKla0eSxFvx7vH/ndRY3+TtPboLJtEhDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=siNz12tm; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="siNz12tm"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711961275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9/sKRzLNxeZrjMfkYPjjKdnUw1Gi0sWAyncGDID1Nmw=;
	b=siNz12tmyUBnQ5rpdTXjBA2zduGfPysIiyUs/jcqiEQdSbHymgelmrSNVBkHE46PCF7qkJ
	Tut0/1ahVCfamY28RKy/jmCuaZpF9Tnv5+fuZC8Eqa1/3FIxCfjk6HXxxfn5JLoQcnO0Bz
	O0ABCDcIFv8mGJGVhHOvHtSqF4+qH6E=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Rationalise KVM banner output
Date: Mon,  1 Apr 2024 01:47:27 -0700
Message-Id: <171196113083.400673.3068319808641697222.b4-ty@linux.dev>
In-Reply-To: <20240321173706.3280796-1-maz@kernel.org>
References: <20240321173706.3280796-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Thu, 21 Mar 2024 17:37:06 +0000, Marc Zyngier wrote:
> We are not very consistent when it comes to displaying which mode
> we're in (VHE, {n,h}VHE, protected or not). For example, booting
> in protected mode with hVHE results in:
> 
> [    0.969545] kvm [1]: Protected nVHE mode initialized successfully
> 
> which is mildly amusing considering that the machine is VHE only.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Rationalise KVM banner output
      commit: d96c66ab9fb3ad8b243669cf6b41e68d0f7f9ecd

--
Best,
Oliver
