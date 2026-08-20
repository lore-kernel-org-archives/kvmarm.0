Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0A83468C0C
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 17:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787245470; cv=none; b=FmMZ5Vm+38vs+xKsjh82KPYFQYi9/q4VBVsrStFnTQxeqwnSHPkIddFBxGBGcsUKr3kd8dIsHi2n9OpnTj7XgM39AA/qakUcKlnlrKiIIOhs51N/Gn5iD3SRCgppLD5qFXhANlS4JWsdlXaXoBlTXByN4bNqKylU9m1W+YJpc/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787245470; c=relaxed/simple;
	bh=MzjPfbXUBxp8rxesicfs3Tm8H0ScdeMdlbod//WyAiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=svlzDupgw2RrFxDzhz5pzFPm+tUTKiGeE9TpHJHUjvcQGTlKYd7mGUlPcBhdhh2WajBpteNwEEDuOFUlUmDcvTEytbJfZzKwmZSYQB+8jNs6skv2WvVPpLqUDhvqSurVc4MxP7oD1yN8TxrWJkvdS2cDWYOVnWcOYZ8cK73UVGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=OX3RjfuO; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="OX3RjfuO"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07F79153B;
	Thu, 20 Aug 2026 10:04:23 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5D1393F763;
	Thu, 20 Aug 2026 10:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787245466; bh=MzjPfbXUBxp8rxesicfs3Tm8H0ScdeMdlbod//WyAiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OX3RjfuOP4Q4dR5jtZNkDU4QsH/FXs0HNn8SVT57ECA2JGEbrLPGuj4uEWySVjLXS
	 A4kDhP1zSOz8p2ODduOVRigYngb2OPdL3mQl0sPlV4ADQb/m+UsaV9slhRSo8wRr8t
	 9iudRy5Fy+Maxgr8LAoTWkRrdhP/goZnQ3UVkUvk=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 05/14] KVM: arm64: Set PSTATE.EXLOCK when entering an exception
Date: Thu, 20 Aug 2026 18:04:18 +0100
Message-ID: <aoczkgxXzqtotl9G@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812-arm64-gcs-v19-5-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org> <20260812-arm64-gcs-v19-5-9105afd828ac@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Aug 12, 2026 at 08:12:04PM +0100, Mark Brown wrote:

> +static unsigned long compute_exlock(struct kvm_vcpu *vcpu,
> +				    unsigned long mode,
> +				    unsigned long target_mode)
> +{
[...]
> +
> +	if (gcscr & GCSCR_ELx_EXLOCKEN)
> +		return PSR_EXLOCK_BIT;

Nit: here I would do:

	return gcscr & GCSCR_ELx_EXLOCKEN;

So that...

> +	// PSTATE.EXLOCK is set to 0 upon any exception to a higher
> +	// EL, or to GCSCR_ELx.EXLOCKEN for an exception to the same
> +	// exception level.  See ARM DDI 0487 R_WTXBY.
> +	new |= compute_exlock(vcpu, mode, target_mode);
> +

we have here, instead (naming is bad):
	
	if (is_exlock_set(vcpu,...))
		new |= PSR_EXLOCK_BIT;

this way it looks more like above sets, such as this one a few lines 
earlier:

	if (kvm_has_mte(kern_hyp_va(vcpu->kvm)))
		new |= PSR_TCO_BIT;

How does that sound?

Thanks!
Leo
