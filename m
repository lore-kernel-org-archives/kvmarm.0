Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268FE14EC62;
	Fri, 12 Sep 2025 13:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757684930; cv=none; b=o8jVNa8B6vTbPidpFa/E1TFHYNYKqQLTfmhKPFTlCmq2EF7w0wHMDH5rq/qiDrgG0oC48IU43iWCmh2CaTBTIqUNimJzXZHTsG6cLdGrJSRumDmAkOHcm/lzln6B9uvu3br7vU7AAz4vLKDV4cmDhK6GgVIFMziozo9bPPZlnlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757684930; c=relaxed/simple;
	bh=chwM5K+xTzqEOy4QaouFWqu8+ltEBz2JlWDvhXp3SZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hx03ESs1BGDaABAkoZouQIogQZdnMKvy9413w5/IcuDHM8OO/gi4Xlr8Gs7/x2ARaBlY5yy4yeCL+kN3dKIOsMelCIx56P2gK8zIiJDEQSHPqofuOdUonpb9XLBugdubtNBDPOI1ngkuACZQXUp29501OINkZ62r4J9aqzav8vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n7UHCh5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n7UHCh5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2132C4CEF4;
	Fri, 12 Sep 2025 13:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757684929;
	bh=chwM5K+xTzqEOy4QaouFWqu8+ltEBz2JlWDvhXp3SZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n7UHCh5B5vrhQNfG9nY1XhpwhsjSK11kr/oOJbHpuZo9EF78yza6cnHHzItS9Z3jw
	 wC5bc/tE+2UbPEZFl1OkREx8UKSZ2F+0kmRaV95SAZpPQUbUHuNoHJqQTXeR3q1VTs
	 u5yUyJm1KYXqJkk9EHnDaQMbBfof3aWCLVoISVLBgDgDl6suwCLi2Z9n5uMXFufpJg
	 GEEcPaTjjpVoQhBM1gaCRoU38n2RFPCQGO1ce64hIyDnKJA1TYp87le9OLn5sJjcrD
	 ZlB6kGXSiQg6OAfjoXqFTNQhfDUUY5yT/jIt4JUWYpNdmStOE086YToHUnFX1sx1sb
	 pcS1FjtLnc8pw==
Date: Fri, 12 Sep 2025 14:48:43 +0100
From: Will Deacon <will@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	jstultz@google.com, qperret@google.com, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org,
	smostafa@google.com
Subject: Re: [PATCH v6 16/24] KVM: arm64: Add clock support for the pKVM hyp
Message-ID: <aMQku2zzNRppTRhS@willie-the-truck>
References: <20250821081412.1008261-1-vdonnefort@google.com>
 <20250821081412.1008261-17-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821081412.1008261-17-vdonnefort@google.com>

[+Mostafa]

On Thu, Aug 21, 2025 at 09:14:04AM +0100, Vincent Donnefort wrote:
> By default, the arm64 host kernel is using the arch timer as a source
> for sched_clock. Conveniently, EL2 has access to that same counter,
> allowing to generate clock values that are synchronized.
> 
> The clock needs nonetheless to be setup with the same slope values as
> the kernel. Introducing at the same time trace_clock() which is expected
> to be later configured by the hypervisor tracing.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

[...]

> +/* Using host provided data. Do not use for anything else than debugging. */
> +u64 trace_clock(void)
> +{
> +	struct clock_data *clock = &trace_clock_data;
> +	u64 bank = smp_load_acquire(&clock->cur);
> +	u64 cyc, ns;
> +
> +	cyc = __arch_counter_get_cntpct() - clock->data[bank].epoch_cyc;
> +
> +	if (likely(cyc < clock->data[bank].cyc_overflow64)) {
> +		ns = cyc * clock->data[bank].mult;
> +		ns >>= clock->data[bank].shift;
> +	} else {
> +		ns = __clock_mult_uint128(cyc, clock->data[bank].mult,
> +					  clock->data[bank].shift);
> +	}
> +
> +	return (u64)ns + clock->data[bank].epoch_ns;

So the comment here say this is for debugging only but, afaict, this
would also be useful for the cmdq timeouts in your nested SMMU series [1]
and would remove the need to mess around with the clock frequency in
the driver code...

Will

[1] https://lore.kernel.org/lkml/20250819215156.2494305-4-smostafa@google.com/
