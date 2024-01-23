Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731BE7FBD7
	for <kvmarm@lists.linux.dev>; Tue, 23 Jan 2024 17:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706031336; cv=none; b=CoUqzJ2AhOZN1sGYT6qCEgY2HZk6Di+E65YuloQK3ugVuSMfA9GOBElf6su9KZBMB34Mph4+GrL4rtxeC3EXt42bGQPyOuXJi6/KL2bhCpdFozmH6FxlCVkenT/SQzCTVChZVH7ku2P76hM4rVjGf3vWHO+JO/MMyBhFhmc0PWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706031336; c=relaxed/simple;
	bh=VQ9Gn56B0UNrOuJsLhXK6Sa7vlzzG5qg1k0KFEwnyoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L+Z5+yUHBtGe4rjEjKusSVC6rnrl8u8PqxgT+uyfF7v7wYJYKCr3IaEOzWixCVrv60/kdyPPcLolqU3Lt/gt/IqOxRJDpVevg/GsHYN56NFioyWeEh4A3083sXjWsweMAeIgcHiTcM4pMqEjRsAf0sDH3CLOWyUggGHuzBt2Xfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i7TJuyqG; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i7TJuyqG"
Date: Tue, 23 Jan 2024 17:35:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706031331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UwviwEcY1cghsMNJvI1Ple+2zXBuNHw/5USyAIIn4xk=;
	b=i7TJuyqGANrL1hkBQsvtx8m9oVlfgkFOaC8sBUxH59Fzw4I0A0HdausJEmDONdFGmQlTkA
	WzWVwKUwWBamk2r8MUlCfOMXRIeGbbd6PX0cQ6Y9bMZreJBOCWH8PiiowscZXIVCxE32Ep
	f66j0y5KfrkoWxyv8wPI9wrYQ1Co0PQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ene <sebastianene@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix circular locking dependency
Message-ID: <Za_43qOnVsCPauEr@linux.dev>
References: <20240123164818.1306122-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123164818.1306122-2-sebastianene@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 23, 2024 at 04:48:19PM +0000, Sebastian Ene wrote:
> The rule inside kvm enforces that the vcpu->mutex is taken *inside*
> kvm->lock. The rule is violated by the pkvm_create_hyp_vm which acquires
                                         ^~~~~~~~~~~~~~~~~~

nit: always suffix function names with '()'

> the kvm->lock while already holding the vcpu->mutex lock from
> kvm_vcpu_ioctl. Follow the rule by taking the config lock while getting the
> VM handle and make sure that this is cleaned on VM destroy under the
> same lock.

It is always better to describe a lock in terms of what data it
protects, the critical section(s) are rather obvious here.

  Avoid the circular locking dependency altogether by protecting the hyp
  vm handle with the config_lock, much like we already do for other
  forms of VM-scoped data.

> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> Cc: stable@vger.kernel.org

nitpicks aside, this looks fine.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
