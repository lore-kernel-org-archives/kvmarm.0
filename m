Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4ADD23EA8A
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 19:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774638943; cv=none; b=WxCYPM7gA58hwU/vdAborhBB6CGw2IkOoqecEzKjmKxOP1JRyWXsNRA4f3A/UzwqwvrkH3qtLFc6YEkLil/fbMr1uBckqYYY4TMnFsopXO8ULzolWbCrVna2604J2jOScj+J+bRrXkpt9MRxBoscYz5FUC2ww2hKwYOqMyWsQmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774638943; c=relaxed/simple;
	bh=pVZsWAwTNhuQGve3K7yHl1CKc5vAbYKswR078p1evoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kf1/Q/99xl/lwgPIo98dAKn0F0I5vHNDRqtubryVNoc5VSZSKyAB/VcdaOioYWu1HDhidFCVFmlRoWM1TMGj6L1aAXEnBHsnetDZIXYhi7Sny0wJ6+buaxR27P1W2xGeauvayxaanJK/b2WRTgNcXiYPdjKztXh7L7vq8hEMK4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hgQoOoE+; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hgQoOoE+"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 456D639E7;
	Fri, 27 Mar 2026 12:15:29 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DDB5C3F99C;
	Fri, 27 Mar 2026 12:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774638935; bh=pVZsWAwTNhuQGve3K7yHl1CKc5vAbYKswR078p1evoo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hgQoOoE+flJivMYihP+g5wqzHDPcQMNXv8Ff/dJscTn92FOhwbJttWjuei4MqwPyg
	 Zg1OGoNfWxMgyfWOME71ME5u7znoolSFjVqXUtIeJf8TkO0X5IGOM3ibLMXZRqZmST
	 56j/bhTdh0Erpz1B1D1DA64HMBPid15RoHE0HPVw=
Date: Fri, 27 Mar 2026 19:15:31 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 4/5] arm64: errata: Work around early CME DVMSync
 acknowledgement
Message-ID: <acbXU2IEi4CPyoqU@arm.com>
References: <20260323162408.4163113-1-catalin.marinas@arm.com>
 <20260323162408.4163113-5-catalin.marinas@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323162408.4163113-5-catalin.marinas@arm.com>

On Mon, Mar 23, 2026 at 04:24:04PM +0000, Catalin Marinas wrote:
> +void sme_enable_dvmsync(void)
> +{
> +	if ((!cpumask_available(sme_dvmsync_cpus) &&
> +	     !zalloc_cpumask_var(&sme_dvmsync_cpus, GFP_ATOMIC)) ||
> +	    (!cpumask_available(sme_active_cpus) &&
> +	     !zalloc_cpumask_var(&sme_active_cpus, GFP_ATOMIC)))
> +		panic("Unable to allocate the cpumasks for SME DVMSync erratum");
> +
> +	cpumask_set_cpu(smp_processor_id(), sme_dvmsync_cpus);
> +}

Sashiko (correctly) highlighted a race here. This function, even if the
erratum is a local cpu feature, is still called via stop_machine() on
all active cpus when the non-boot features are initialised. It only
matters if CPUMASK_OFFSTACK is enabled. I'll add a fix, most likely a
lock around this to serialise the cpumask initialisation.

-- 
Catalin
