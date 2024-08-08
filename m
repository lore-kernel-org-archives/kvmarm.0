Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54ED190067
	for <kvmarm@lists.linux.dev>; Thu,  8 Aug 2024 17:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723136910; cv=none; b=IfwEPJ2n5afm4w4aqQtwjirZoeX0ZdIDixJb2tZHqhK9Ka69XfYzbirZgZWIajaMHU1ZnVZrAPakRhesLRQ/npbcmuUWG627SGcpHrm7liVPXvJ3rfFTP23Rcm5ZHyQSN/gnw/b+8hfnUdqtKvwJvocidsAmSTmV4nmZ5YCVUZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723136910; c=relaxed/simple;
	bh=CCl721fwZLLwFVPTTRtOjKAMb8FcpQm+CmEdhaT6Fi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZalgcEZnOzYXcl9ehmmk9v4soQGEg6KdI/ZHsUTjTAIB2LlFzqaov6lWyq/J9wHodBcN/ymgF5ELSmsBLpeRONP8Nzl3bdXGwzprlQGk+iD9HJJGxSwks92/v6AdyEI8DdMFGli3e0kXzugq5aWgKZldlK60dmGpIJpu4xUwMNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jhpnsxsW; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jhpnsxsW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723136906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K3jBZfWEj+1e1fJ+U8/m7v4ZnPyf/QPKdDTawGp6w18=;
	b=jhpnsxsWiVNYok08/KQtwRdfHZRSogusV69BAs1VX3lscQAfN3UU8tpnFAxG+gLB916JJ1
	gcms48cRvtyIYbOkoJ2wcPH85H8tP2Q4es6DfuzDmKxiVU5490rNcndiU4MEWNksyXyMv/
	VDfsFgnHLXHEkQ1/8k2l2ijB1uGfMjQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	catalin.marinas@arm.com,
	yuzenghui@huawei.com,
	smostafa@google.com,
	james.morse@arm.com,
	will@kernel.org,
	suzuki.poulose@arm.com,
	maz@kernel.org,
	joey.gouly@arm.com
Subject: Re: [PATCH v2] KVM: arm64: Tidying up PAuth code in KVM
Date: Thu,  8 Aug 2024 17:08:00 +0000
Message-ID: <172313677519.561165.4613543876409163930.b4-ty@linux.dev>
In-Reply-To: <20240722163311.1493879-1-tabba@google.com>
References: <20240722163311.1493879-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 22 Jul 2024 17:33:11 +0100, Fuad Tabba wrote:
> Tidy up some of the PAuth trapping code to clear up some comments
> and avoid clang/checkpatch warnings. Also, don't bother setting
> PAuth HCR_EL2 bits in pKVM, since it's handled by the hypervisor.
> 
> 

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Tidying up PAuth code in KVM
      https://git.kernel.org/kvmarm/kvmarm/c/7e814a20f6da

--
Best,
Oliver
