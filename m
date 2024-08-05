Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE20916D9DC
	for <kvmarm@lists.linux.dev>; Mon,  5 Aug 2024 22:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722895957; cv=none; b=odFX5GWNd/R4A0myI05MvtSGfh4VG0MpNZdkRpx5hbxqyBZ6wmBs+ZgqX1XsgUvFnG5yevOvvhmx5hfulnUGHOL21otUoYgQR981pRzK6F9wtPJDl4ruXeA0kptz0c1oi83vhYoj+AiitAS1J3GbXwJYMm2XdoV9gnGHG0ZSX58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722895957; c=relaxed/simple;
	bh=mP0le3Ecr+q+WaHp0xN16KLmayF7PbiS4tFl1GVsYiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CQhhpzR3nQ88gPiUb7HPoQJZENRiYTzYKBKUKh6+jFW4ksq/rX0I6rx4QNME7dSIBkHXBqPew2HB/MPCIozPIFg+7HJ6IpWhcDvaadAY4yJPs/EnVmERz69X94/18ny5Mp3quQ3uBFv2fvkJKEJtOZ6kSZCHHrHSWMExlOW/6aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lMsvNTL4; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lMsvNTL4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722895954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xyzz3yd5OYMOps4lsgiuDb1QOK8b+DokzNfK7sphtSc=;
	b=lMsvNTL4tgvYnugYSreQD0DQil/aj1Z4VcmuRh2S6m1J8kAdfZQXJNyGgSspt7h5Qcj4/G
	gFWxljJwEgBQoNQQCaWBGR12dzD5lep0m7vS7UBc0IHaIPOme92o736E5lQF+u7vclZWc9
	tY8I392eK9QG/Zi6HZLHZHIjcXg0ULk=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 0/3] KVM: arm64: fix warnings in W=1 build
Date: Mon,  5 Aug 2024 22:12:23 +0000
Message-ID: <172289592799.3403138.16842618894557435476.b4-ty@linux.dev>
In-Reply-To: <20240723101204.7356-1-sebott@redhat.com>
References: <20240723101204.7356-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 23 Jul 2024 12:12:01 +0200, Sebastian Ott wrote:
> Building arch/arm64/kvm/ with W=1 spills out a lot of warnings. When
> changing stuff I try to use as much tooling as possible to make sure
> that I don't screw up - having a clean baseline imho helps with that.
> 
> With the first 2 patches applied make W=1 arch/arm64/kvm/ runs without
> warnings for me (fedora userspace, upstream linux after kvm merge).
> Patch 3 gets rid of sparse lock warnings in arch/arm64/kvm/vgic/.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/3] KVM: arm64: fix override-init warnings in W=1 builds
      https://git.kernel.org/kvmarm/kvmarm/c/963a08e586bd
[2/3] KVM: arm64: fix kdoc warnings in W=1 builds
      https://git.kernel.org/kvmarm/kvmarm/c/0aa34b37a78d
[3/3] KVM: arm64: vgic: fix unexpected unlock sparse warnings
      https://git.kernel.org/kvmarm/kvmarm/c/19d837bc881b

--
Best,
Oliver
