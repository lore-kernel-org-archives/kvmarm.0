Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D91615C120
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 21:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734557433; cv=none; b=j8ROsiMt4nAta+VsaHSDEh3JIbqqUvWbcURbrtqu/JejIZKdcQ1IlYOGxwoKsdk1G1agzgzd9FKyPa+quqvOi9+FN5PfXG1gkP8O5HVOtANP/Z6YdINmwXQ1xftHB6r50Cp145UwvFgKKb7RD5OCFv00vDdoCA8z1dTA27erDws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734557433; c=relaxed/simple;
	bh=v4Oie/J++cKn5L0fPbVMNL1RhCl+DBExfaE329vAr+U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LBxBy31wzQBhHtUsj3+EhqV6VolTiPrgbrpGMDQvnBbSkXBmirZ2dqop2mpO6QPJHPd7d0YNLr+AfHiLjPQlbNpmOwr2giQcJNhP6LC1ZYDOG3+mGY01sH71OCH4LyaI1Cn/avbZ3+4umjW3CYl8eZWJjwocViZU1w+8trmmzQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=feW9Bw55; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="feW9Bw55"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734557429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A/2TdX/pJ5Tnhay1CknlqlFO2T3FDSPjhcjBairvzfI=;
	b=feW9Bw55jjom3zz35m58gW0P+mJt2O2OhcupsO7788pLdJTlTnO4LY+JCLgqQ9IqZopmpQ
	wSf75FAs/8VH+zNUvDOjTD9dmLO6ayJnlOR6/A6TONx/anvSZdGGWfboqf5susGCJ1f+qC
	GAny5CXGpuUJ6lldtzGSQOqhK/mbBfE=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Always check the state from hyp_ack_unshare()
Date: Wed, 18 Dec 2024 13:30:15 -0800
Message-Id: <173455738564.3742443.9773591453026966218.b4-ty@linux.dev>
In-Reply-To: <20241128154406.602875-1-qperret@google.com>
References: <20241128154406.602875-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 28 Nov 2024 15:44:06 +0000, Quentin Perret wrote:
> There are multiple pKVM memory transitions where the state of a page is
> not cross-checked from the completer's PoV for performance reasons.
> For example, if a page is PKVM_PAGE_OWNED from the initiator's PoV,
> we should be guaranteed by construction that it is PKVM_NOPAGE for
> everybody else, hence allowing us to save a page-table lookup.
> 
> When it was introduced, hyp_ack_unshare() followed that logic and bailed
> out without checking the PKVM_PAGE_SHARED_BORROWED state in the
> hypervisor's stage-1. This was correct as we could safely assume that
> all host-initiated shares were directed at the hypervisor at the time.
> But with the introduction of other types of shares (e.g. for FF-A or
> non-protected guests), it is now very much required to cross check this
> state to prevent the host from running __pkvm_host_unshare_hyp() on a
> page shared with TZ or a non-protected guest.
> 
> [...]

Sorry for letting this one slip.

Applied to fixes, thanks!

[1/1] KVM: arm64: Always check the state from hyp_ack_unshare()
      https://git.kernel.org/kvmarm/kvmarm/c/985bb51f17ab

--
Best,
Oliver
