Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829878468
	for <kvmarm@lists.linux.dev>; Sat, 30 Nov 2024 03:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732936116; cv=none; b=LcpCmCED6Bx9EHEEXttYyzccbQ9tK0nTnOlbp+0CMI3s6OJQDPg1UGznZNLDT10/Z+JlI5Xg3FhGjqdRvRPse2wFTu9j02wtmm2vJM+Eb4Mbr8i3o0MweZ20FRxx2DMmxTx718Ll1625jKizU3F1EbrtaiQN8Zb0unuVaBN7qqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732936116; c=relaxed/simple;
	bh=P62PUULtg2tZ7gwut1t8nu8Sl+WumtgWk/uWg0wKUDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VUh3nW6XKhMctKnTEy69yrJwGnI3Ed2V14se4DPyUSCb+o2l9wyEkPXDoKCugqpPv2QvorZCO7gnp3l+parh3AWx+7guHLXSU2NYXgxY36nVP1jhDdrh7S8ZwjTJYPVRt+fYIbMxtGUiDYrUnnGYEp3Iqxq4P8OrYxNt2x3dUz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GYgdfe0N; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GYgdfe0N"
Date: Fri, 29 Nov 2024 21:08:11 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732936111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K/lAtWcFTD6GkIKKqZ6pvrO58pPk9/bQpGVGvjlQ4EE=;
	b=GYgdfe0NHKRCfGTDQ+TGiieRIreb5gvT1ozPwimEFY38N+XyKBi+4dPbvbXNSADeVHHU/I
	GbWfTDTRoziFSC1+Tm3ZOer4EnH42O/sIqu5/Qu/wdzBZl8/WVMqPGxi0jtsQ2Xtrk8uxP
	JhKpgDsgfCenAe0/NYXRChOQIW28Wxs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Clark <james.clark@linaro.org>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2 00/16] KVM: arm64: Debug cleanups
Message-ID: <Z0qBau21-XN7NGVZ@linux.dev>
References: <20241115224924.2132364-1-oliver.upton@linux.dev>
 <5edb7c69-f548-4651-8b63-1643c5b13dac@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5edb7c69-f548-4651-8b63-1643c5b13dac@linaro.org>
X-Migadu-Flow: FLOW_OUT

Hey James,

On Fri, Nov 22, 2024 at 11:08:22AM +0000, James Clark wrote:
> 
> 
> On 15/11/2024 10:49 pm, Oliver Upton wrote:
> > Second pass at cleaning up the mess of debug support / trap
> > configuration we have.
> > 
> > Marc, I haven't yet gotten around to moving the per-CPU value of
> > mdcr_el2 into kvm_host_data. If you're alright with it, I'd like
> > to clean up the configuration + storage of all the trap registers
> > in a separate series, especially the pKVM bits of it.
> > 
> > Tested the userspace-facing parts by single-stepping + setting
> > breakpoints for a guest using QEMU's gdbstub. Tested the guest-facing
> > side of things with the debug-exceptions selftest.
> > 
> 
> Hi Oliver,
> 
> I get this bug when running the selftests, but the tests themselves seem to
> pass ok:

Thanks for taking the series for a spin!

Yeah, this is a pretty damn obvious one, since kvm_arm_setup_mdcr_el2()
dereferences per-CPU data. I'll clean that up in v3.

-- 
Thanks,
Oliver
