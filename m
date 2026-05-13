Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D9223EA89;
	Wed, 13 May 2026 07:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778658357; cv=none; b=sgoxXXmGYcuy3S1SeHGuyDRMveivpA964IUzb9Zg5tYqnxxV7muvCVEL8jeo5dOjK0y4bIwy9qX5XZ20Tzetd+4I/u5lxicWOOejpHVjnCqEI5xnTJ8kMDWke2ycmQ0tpCNx8frKA54JDcgKbaS9PdZmdGIUxt6fwZGw5CPoRE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778658357; c=relaxed/simple;
	bh=4LEL2I02ZNcYBvdRSq6ZKXzxViElK+3D8okdJW4tWaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CDZEMErrMy9bZkLoQrXs1m2PZqgELBVvYB6fRz8mfmotP9KHvuY92+egjQsDHuy42cX7Z4gCUeDoS8dA3GXQToqlzktIznW5erSGbaHBIPP6Xf5jh6DutFj1xiFDDssIKmpR13Apwdc3x+xoHFfpMRlLiZcmj1GJGuj7mBYYWJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JcmzwXJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JcmzwXJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E23C2BCB7;
	Wed, 13 May 2026 07:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778658357;
	bh=4LEL2I02ZNcYBvdRSq6ZKXzxViElK+3D8okdJW4tWaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JcmzwXJoOLz0s9/QXfUAL87bTvpMBs+SpVCsKRsXEsJPMUgjJ+74KkiMp315a4v4u
	 N8HSvEa/jlN8MMNHG4YgW4hGjEC2CZykvVEBTh7PSfzwLybzsJYdPrBbit2g2e3j1Q
	 Q1Y4a8+8LZKppLGWhI6TAf/e3SPIhpFcY7ZxdhsBv3tcSPVKb6orlxt8Gn83IuftPd
	 XJIXUnazS71GUEOT0jtvA+IpCEG5zwk8AIqSxYjla909ZkQ3RJRhFTSah/HHutKGfy
	 Fr/OPxJvx76L5Lic6jk1UoSQThATSTwac24yXFynsEF2/00LZyrw5sg8b/9t13lIec
	 URFGDSi9SzN4A==
Date: Wed, 13 May 2026 00:45:55 -0700
From: Oliver Upton <oupton@kernel.org>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	James Clark <james.clark@linaro.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v7 08/20] KVM: arm64: Add Partitioned PMU register trap
 handlers
Message-ID: <agQsM7XFsbxbFRLO@kernel.org>
References: <20260504211813.1804997-1-coltonlewis@google.com>
 <20260504211813.1804997-9-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504211813.1804997-9-coltonlewis@google.com>

On Mon, May 04, 2026 at 09:18:01PM +0000, Colton Lewis wrote:
> We may want a partitioned PMU but not have FEAT_FGT to untrap the
> specific registers that would normally be untrapped. Add handling for
> those trapped register accesses that does the right thing if the PMU
> is partitioned.
> 
> For registers that shouldn't be written to hardware because they
> require special handling (PMEVTYPER and PMOVS), write to the virtual
> register. A later patch will ensure these are handled correctly at
> vcpu_load time.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

I'd prefer an approach that provides a single accessor helper that takes
a vcpu_sysreg enum as an argument and internally handles the dispatch
between partitioned and emulated PMUs. That goes for all of the PMU
sysregs.

This will help you reuse some of the PMU emuation code that you'll still
need for things like nested...

Thanks,
Oliver
