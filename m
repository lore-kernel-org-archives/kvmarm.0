Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48286521889;
	Thu, 15 Oct 2026 12:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792068617; cv=none; b=YUdsPuyWCn8RZ1z2eYqOGbnjT0Oyg2OLDyksjK9paM81w8o9eRJG4sFvLhiCLNM6Bjt9G54JwLMYlM1MbszcHVZkagJVf2YdcoNYIJ084OEUn/MC2Fp5x1wkwaVurOhqXjTVXpxRaW+k7aw7UIjcczPwgEV8JyFKe4oMIcTdQYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792068617; c=relaxed/simple;
	bh=4R6C3otfPSRMB7sLJWxWEvrFS4WjHRVB+TeXnhUt7Q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sxxpSc7GfNQvUHgEizhWyaNVj8oJQKO02mMiioengHvCvJ7xQgpx09+PmQKZE3uzTG5ydjqLEZdsTqmLsEMpK7fQFnHoaHiXX/J0QIkI06oVsHp9mTwWoSr2boqpMDb1KpGQk8EHuia58D30rQC5vrGaBwcimoXvmQmSZBrThOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VvGzkhkX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VvGzkhkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245CE1F000C4;
	Thu, 15 Oct 2026 12:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792068616;
	bh=4R6C3otfPSRMB7sLJWxWEvrFS4WjHRVB+TeXnhUt7Q4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VvGzkhkXPC+gUqSIhDNIhuCk0U83Pnahsv8JWnqIZ3WPyxMgOfEb+v3pExjdpYNxe
	 W/DFwGWQw5PbXO5XkdnRnOfsq6fsX2h7zN6IbOl3Dv3OyhcLvvRchrsRr89oj7iBLb
	 ZpcdNGsIzKQzNngva2sZwFCck9DPcqkhDTGxN5BwUI+DuCS94HpNk5CyyRb81p0kLb
	 8Fi3S5FvPc9kIbhpwu2GLI1IO0sRIuJuHevOB6krAS18ddMyqvrQh4dhqljaWzkHod
	 SkVW+AnFQjrwb175AzOTl3IC51i8mb0xSa7+Y5X3jAleab7bsU3ETmJZmPs6JZVczB
	 ZxvRVUKkg4gfA==
Date: Thu, 15 Oct 2026 13:50:09 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 00/28] KVM: arm64: Add Statistical Profiling
 Extension (SPE) support
Message-ID: <atDLgcMeh7kizHGt@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <atCqFRdGzFq5dOdT@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atCqFRdGzFq5dOdT@raptor>

On Thu, Oct 15, 2026 at 11:25:25AM +0100, Alexandru Elisei wrote:
> Hi Oliver, Marc,
>
> Gentle ping regarding this series. Is there something you want me to do to make
> reviewing easier? Do you want me to rebase it on top of v7.4-rc1 when it comes
> out? Something else?
>
> Thanks,
> Alex

Just to say that I'm planning to go through this series myself and can hopefully
help with the review workload here! :)

--
Cheers, Lorenzo
