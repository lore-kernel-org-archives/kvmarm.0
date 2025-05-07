Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B46221D98
	for <kvmarm@lists.linux.dev>; Wed,  7 May 2025 07:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746604635; cv=none; b=Q023aLG4BbHuHRXi7zYAe8cblpkIKsK2GpFsrnnShvrFSPxVtY3RAdDJFSdBRKVy2mp2TY2PMOsAPce4sfovxBFvPMWdEWVehchAKn+uYenJt6GXIf92bb/1cVqpK7GlTJ0WMN/wdiZQDfEB206xOgPzYdxsVGPVqotUSML7eIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746604635; c=relaxed/simple;
	bh=TcMcUur/jQdLVvp833wknmZft9SDv6KsBh9u9mBzHug=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=urvHw4OkZQP5WnrH9LoTA660r0nQbCRkTNrdMiv1+JK6bKjZ38bmQv1ayvP1pU0+BPoAAqnEfoZRnARjR1OtrilCNk9fTxRAemY4lmI2H7cwjdmbl9EfxpPAVK2C5Oj4vQjhyODa4XEmBBfla/UPGmhv+95ksT3csPqbFqwk58U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bVzP8GPg; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bVzP8GPg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746604631;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qRWq+bBWMkqfZbZV/+7P3UIt2LtdL2A1Y5faFTjaNBA=;
	b=bVzP8GPgXCiJVtfukPZyZEn+h1ClvsVypIaZaEC/5LM2fZIMR+jjCvHA9f7exEtTbry2rE
	FJCnvJ9D2C7HZbuAGq+aYluNIbwZbjNud8S8OfPTPsZkjHyO0qEgKTH+JsqLWgxzfJRRvr
	jCNDUrNNnMVcCMel/QN+VtI6FzW4OBA=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Sebastian Ott <sebott@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix uninitialized memcache pointer in user_mem_abort()
Date: Wed,  7 May 2025 00:56:51 -0700
Message-Id: <174660459083.2542293.85268453831284543.b4-ty@linux.dev>
In-Reply-To: <20250505173148.33900-1-sebott@redhat.com>
References: <20250505173148.33900-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 05 May 2025 19:31:48 +0200, Sebastian Ott wrote:
> Commit fce886a60207 ("KVM: arm64: Plumb the pKVM MMU in KVM") made the
> initialization of the local memcache variable in user_mem_abort()
> conditional, leaving a codepath where it is used uninitialized via
> kvm_pgtable_stage2_map().
> 
> This can fail on any path that requires a stage-2 allocation
> without transition via a permission fault or dirty logging.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Fix uninitialized memcache pointer in user_mem_abort()
      https://git.kernel.org/kvmarm/kvmarm/c/157dbc4a321f

--
Best,
Oliver
