Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39554949E0;
	Thu,  1 Oct 2026 16:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790873598; cv=none; b=CKO4xmzmcrWZpTWPidMapJwbnGzctm5Cgr4/zjxKCzq4VhFXJpuJxh9bnIGVTwCuUffiVOTH7x8j09rjJvmpvWNN3rKQCplp/nJ8e54Lp4VrCPJyVY3i38PN7QIYGNMVf/ZcVa5VtbvDrm5uCkBvy6MPWz+XI1ZKnOrzyJALHxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790873598; c=relaxed/simple;
	bh=pldxfBBUJszv2h95WSmrqJHgRj+RN0mpAukKCJ4Us+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i3RC18Q2/OjGr9ySsipBjjZZa4Ph4qmLTEOS7H0j5zNQq/xJnEinQIwzmf7eHbm3aJ8KxTq61slqjyxVdo81Pkhgw65se54iN58S4aNubv0zgpQNUZeh5e7vm+eWZAKbiHcR5jNeGkfExN8TJq2Q1zVf4AmiocGyDfX3pEQyL9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvbSVCpa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvbSVCpa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204151F000FF;
	Thu,  1 Oct 2026 16:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790873596;
	bh=pldxfBBUJszv2h95WSmrqJHgRj+RN0mpAukKCJ4Us+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LvbSVCpaCUVkCAz7so8zugOU3NwB259fPKMks2lna/kHm0w4qsV+s9KRttiSYjuTA
	 YWqi1beCw/63VRYo0D6E/5KjdiQoKuWAd02GWBKBvUyHv2gNb5OpWIBZgmsUN+JO77
	 fPkC76O599BnM951u6Mz1XTKKEeAlR3aeV0Pw8AKnIPyIHfQuI6mwgdcokO0RvViPk
	 RdT41/5KVCI+WaVbKnShZrhW6IiaQJW0alniE3u/M/Mzo96jeQdxwX+5sWe3XE02nT
	 gHobMG1OESuD/ILEtZBbpiDZA1gbnXyxoe6/X/W0xeRaKXMcPnl4XzBCqJkfx7M4xQ
	 tOdXdnwJxlghw==
Date: Thu, 1 Oct 2026 17:53:09 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 15/15] KVM: selftests: arm64: Add GCS EXLOCK
 exception emulation test
Message-ID: <ar6PJqq3Ujaz-ibx@gremlin>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-15-3556644cd927@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930-arm64-gcs-v21-15-3556644cd927@kernel.org>

On Wed, Sep 30, 2026 at 10:48:25PM +0100, Mark Brown wrote:
> When running in vEL2 ERET is emulated, this means that we must emulate
> the behaviour of GCSCR_EL2.EXLOCKEN. Add a test that validates the
> behaviour.
>
> As per DDI0487 R_WTXBY PSTATE.EXLOCK is set to the value of
> GCSCR_ELx.EXLOCKEN when taking an exception to the same exception level.
> As per DDI0487 R_TYTWB if on exception return to the same EL
> GCSCR_ELx.EXLOCKEN is 1 and PSTATE.EXLOCK is not 1 then the exception
> return is illegal.
>
> We nest handling of two UDFs to allow us to both observe and modify
> PSTATE.EXLOCK, checking that expected exceptions are generated for ERET.
> We also repeat the UDF tests having enabled fine grained traps for ERET
> to try to ensure that the slow paths are taken.
>
> We also attempt to write to both SPSR_ELx and ELR_ELx, again using a UDF
> handler to control PSTATE.EXLOCK. We do all this both with and without
> having enabled EXLOCKEN, though only for code running at EL2 due to
> framework limitations.
>
> For completeness we also inject a data abort from EL0 to EL2 with
> GCSCR_EL2.EXLOCKEN set, ensuring that PSTATE.EXLOCK is not set.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Reviewed-by: Leonardo Bras <leo.bras@arm.com>

This all seems reasonable test-wise, but I wonder if the discussion around 8/15
might alter some of what's tested here?

In that - if it's only hardware that's doing the locked check then the SPSR (and
probably ELR?) bits might only be exercising that rather than KVM stuff?

It might only need a comment update though :)

--
Cheers, Lorenzo
