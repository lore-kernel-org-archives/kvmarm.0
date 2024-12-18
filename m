Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3621F3D48
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 21:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734557429; cv=none; b=R0yX/NfnGavkeFrg0CLohmXDXlguavLy6vgpb86XMOpLyyd2mRpFSzDMt2PovJ3w8ePz7dGyG0PHvSiW57uq05faGIqAbWG/3mdsIUZixuaB9TquKqaN74b9x4OhPUlHQsOGMAoMmZwy8Vjv+wBIGEQLIQEJ2fbBTZ6KG1LBC1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734557429; c=relaxed/simple;
	bh=hgRC8Gjh6IHjLs9ONLgk/UPfm1wZMvPGc20h3KBYwEI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LimYkJb1xpcXz257CiWNSH5DxYEK5nr/PpzshCx5qMs/Uq6q9U4KxUmj8qbsQH5kOWd2VhWNgv1P/BS62Ax1hLcBZ4eVz26K4GjLfl18fm3jpJup+GXJVRyQ2hYdgH1cLu2U8mzVZsaN9krempYBkjGXjHNFSOebrBWw01TCoIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fpQBYJUp; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fpQBYJUp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734557424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=239HfuCRhKCpp+4WWr7O20LVxf/zoUlui0dQGFzrep0=;
	b=fpQBYJUpHYokrA10I520OOEt5CKUCmcJr7MyOsjcSiXkHyazyMnPrD6Ttefp+bbBg1nx9C
	ls8tjfXCelWyTS8E/FVZVCCaARwaTP08o4td/Z5WewQ4jRYkN+5isBsTcBvazJJw/H6Jq6
	XVG/O2qGMXmvEMg+24vZd4U9vT/s9rM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>
Subject: Re: [PATCH 0/4] KVM: arm64: PMU fixes for 6.13
Date: Wed, 18 Dec 2024 13:30:14 -0800
Message-Id: <173455738567.3742443.17084979445331902005.b4-ty@linux.dev>
In-Reply-To: <20241217175336.3657966-1-oliver.upton@linux.dev>
References: <20241217175336.3657966-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 17 Dec 2024 09:53:32 -0800, Oliver Upton wrote:
> Small set of fixes for PMU, mostly focused on plugging gaps in nested
> support that I'd missed last time around:
> 
>  - Don't attempt to enable/disable EL2 counters when PMCR_EL0.E is
>    changed. This is already the case since the enable state of a
>    counter is re-evaluated in kvm_pmu_create_perf_event(), though the
>    handling of PMCR_EL0.E would suggest otherwise.
> 
> [...]

Applied to fixes, thanks!

[1/4] KVM: arm64: Add unified helper for reprogramming counters by mask
      https://git.kernel.org/kvmarm/kvmarm/c/e22c369520d0
[2/4] KVM: arm64: Use KVM_REQ_RELOAD_PMU to handle PMCR_EL0.E change
      https://git.kernel.org/kvmarm/kvmarm/c/adf8623b3f51
[3/4] KVM: arm64: nv: Reload PMU events upon MDCR_EL2.HPME change
      https://git.kernel.org/kvmarm/kvmarm/c/d3ba35b69eae
[4/4] KVM: arm64: Only apply PMCR_EL0.P to the guest range of counters
      https://git.kernel.org/kvmarm/kvmarm/c/e96d8b80afd3

--
Best,
Oliver
