Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFCF315381B
	for <kvmarm@lists.linux.dev>; Tue,  9 Jul 2024 08:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720515513; cv=none; b=R46a5AltHzLwY9TU+nip+/Kq0rVN0q8JuuZldSoQq0JDoQq/Xg/0G26XwL4BooySmuAUDfeAxnLFkTNjI8DQEEyoyMRR+icIzqYHEAWM2RH2zM8LQGllh5GLXsNbPMbIeikbpht0zpO9q1rNoxwy+jRVWlBVzk2V7KUOmavqgZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720515513; c=relaxed/simple;
	bh=VE/eHrIXRvnnLJ3EmmPCTMSBPXant7mTwn1kdBGxg8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TcrXbJ/DxEd/4GIsJvp7LTxlxaf/VJj18vFKWEUuw/MlTAJPeeaFB6tCvlymxlcMVJ2ZaEuxl+CFddKxC8UjV50CVad6tORif+gFLobmdntcaCzEvS60lT9tQc0lUk92rYk7R2n/InDiJMzDHLPqM0jXLuE94BAhC3a43GTux5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 415581042;
	Tue,  9 Jul 2024 01:58:56 -0700 (PDT)
Received: from arm.com (e121798.manchester.arm.com [10.32.101.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 982653F766;
	Tue,  9 Jul 2024 01:58:28 -0700 (PDT)
Date: Tue, 9 Jul 2024 09:58:25 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: pbonzini@redhat.com, drjones@redhat.com, thuth@redhat.com,
	kvm@vger.kernel.org, qemu-arm@nongnu.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	christoffer.dall@arm.com, maz@kernel.org,
	Anders Roxell <anders.roxell@linaro.org>,
	Andrew Jones <andrew.jones@linux.dev>,
	Eric Auger <eric.auger@redhat.com>,
	"open list:ARM" <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH v1 1/2] arm/pmu: skip the PMU
 introspection test if missing
Message-ID: <Zoz7sQNoC9ePXH7w@arm.com>
References: <20240702163515.1964784-1-alex.bennee@linaro.org>
 <20240702163515.1964784-2-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240702163515.1964784-2-alex.bennee@linaro.org>

Hi,

On Tue, Jul 02, 2024 at 05:35:14PM +0100, Alex Bennée wrote:
> The test for number of events is not a substitute for properly
> checking the feature register. Fix the define and skip if PMUv3 is not
> available on the system. This includes emulator such as QEMU which
> don't implement PMU counters as a matter of policy.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Cc: Anders Roxell <anders.roxell@linaro.org>
> ---
>  arm/pmu.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 9ff7a301..66163a40 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -200,7 +200,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits) {}
>  #define ID_AA64DFR0_PERFMON_MASK  0xf
>  
>  #define ID_DFR0_PMU_NOTIMPL	0b0000
> -#define ID_DFR0_PMU_V3		0b0001
> +#define ID_DFR0_PMU_V3		0b0011
>  #define ID_DFR0_PMU_V3_8_1	0b0100
>  #define ID_DFR0_PMU_V3_8_4	0b0101
>  #define ID_DFR0_PMU_V3_8_5	0b0110
> @@ -286,6 +286,11 @@ static void test_event_introspection(void)
>  		return;
>  	}
>  
> +	if (pmu.version < ID_DFR0_PMU_V3) {
> +		report_skip("PMUv3 extensions not supported, skip ...");
> +		return;
> +	}
> +

I don't get this patch - test_event_introspection() is only run on 64bit. On
arm64, if there is a PMU present, that PMU is a PMUv3.  A prerequisite to
running any PMU tests is for pmu_probe() to succeed, and pmu_probe() fails if
there is no PMU implemented (PMUVer is either 0, or 0b1111). As a result, if
test_event_introspection() is executed, then a PMUv3 is present.

When does QEMU advertise FEAT_PMUv3*, but no event counters (other than the cycle
counter)?

If you want to be extra correct, you can add the above check to pmu_probe() for
32bit, since I doubt that the PMU tests were designed or tested on anything
other than a PMUv3 (and probably not much interest to maintain the tests for
PMUv1 or v2 either). If do do this, may I suggest:

#if defined(__arm__)
	if (pmu.version == ID_DFR0_PMU_V1 || pmu.version == ID_DFR0_PMU_V2)
		return false;
#endif

That way the check is self documenting.

Thanks,
Alex

>  	/* PMUv3 requires an implementation includes some common events */
>  	required_events = is_event_supported(SW_INCR, true) &&
>  			  is_event_supported(CPU_CYCLES, true) &&
> -- 
> 2.39.2
> 
