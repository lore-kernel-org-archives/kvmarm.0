Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5BF310651;
	Fri,  2 Oct 2026 11:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790940483; cv=none; b=plyJvfM15FKUsmDbNoTi/u7dZL1lCmo0pby0QQQb/WPd4RfcM1DDsfAS490FVG3dsIuH+m0WEJNoS65tstPub27OcsEDF18SVwzRyEUgIMK+QDvwnP8XiNooSscDin3J4K93xOUq0lG29yP6847lynQ8kOEiiiZWRgt/QNUrVbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790940483; c=relaxed/simple;
	bh=r3XSvVIqIJb9n/x3qaYL7kH0gfxPLdje2eVvkPwfr1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lW9X8gseHRqDcbsfSdL0qBfTult5Ryp25ko6fPZH1I71rQUmVCWpfkCorbfex/LWSCOXLV7cJnmndpl6JCUg7yHa5QuKrkvt8esmE3stZK3bmPJ+3bhl5I+dFCUx0FosMa4Tb7Ecxf7WTqNCMdL4dzgJXv0eRaxgZyuzoizgJaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nAYNTtyx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nAYNTtyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488E91F000FF;
	Fri,  2 Oct 2026 11:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790940482;
	bh=r3XSvVIqIJb9n/x3qaYL7kH0gfxPLdje2eVvkPwfr1I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nAYNTtyxSvEJWlBwMsuLcNL+tHeMYXYUfLPsAX1ucTE/y72zAPwEggidfF76fDiuw
	 Kh+kphHP4rWdvz0VzThertJ6AM7Q18c8vkZQtWmoyMAPKyOPdxs/4OILFBZl/O8BVZ
	 9y/cD1gaXPdFeM5vv8wEKYA0GnzUMqJZ9tQYI4hlGD1wp5TB0GN52P8GZcBUjQXrP4
	 g6yqw6Ka9jpHj5CiKGiuxz4alEMWuwHFafNDDa/qwCm0NdVH70yl8xQjkfAhWmBks0
	 1J1PQJR6gukcWrNsBzOKVB1E8vOjMW45NxETR3F0WMvt4v6wrGpIaG1mm5PsprQ8fC
	 JSyhpUqm8cW5A==
Date: Fri, 2 Oct 2026 12:27:55 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 12/15] KVM: selftests: arm64: Add GCS to set_id_regs
Message-ID: <ar-VI92hceN5njfG@gremlin>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-12-3556644cd927@kernel.org>
 <ar6MIFW2vfM893yd@gremlin>
 <8eb4d0f8-3080-4efa-afaf-bbe2a16eaa37@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8eb4d0f8-3080-4efa-afaf-bbe2a16eaa37@sirena.org.uk>

On Thu, Oct 01, 2026 at 07:14:26PM +0100, Mark Brown wrote:
> On Thu, Oct 01, 2026 at 05:38:54PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Sep 30, 2026 at 10:48:22PM +0100, Mark Brown wrote:
>
> > > Now that GCS is configurable via the ID registers update set_id_regs to
> > > cover ID_AA64PFR1_EL1.GCS.
>
> > Should maybe also mention adding the GCS-without-S1PIE test?
>
> I'd have said that was part of the coverage the test now has for
> bitfields TBH.

Fair enough, all LGTM at any rate! :)

--
Cheers, Lorenzo
