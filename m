Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7811331221;
	Wed, 18 Mar 2026 17:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773856470; cv=none; b=g8UFwF04xOgg0/7YRIOdG5KEaRu455QZnG09mpV8yQCKPVF5DznXbN1vdWiILCX5G4JaEVw5jheiB/JMkwqHoSes09U64+BMK0SylSzovgP+60bW9+OKSReOMj5s4ZfcUltCrJHUZNWJYniGbxWi6fwz84V2VdRaLGYgRhKmDVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773856470; c=relaxed/simple;
	bh=+m5vnfAODYCyWjrqQrLd5vT4BlnOmJEpTCTU2aZfT9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VB/ucuJd7boCBxE3m5UuSCQELxYTCAWGP521E7Ye5stamQi8Y7P8cIFJMZkDFDujBz5PyEPX0YJuvUDOhsHi8uKjQ+9f/22qAWh5DTxodmGAB0ei4XTsdT7ZXQZPfrgbpZ+HOEtLTiA8X5OD5mEpv4NpyS0kyZeF0+2o5JXlO1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s/BoreZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s/BoreZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8CCC19421;
	Wed, 18 Mar 2026 17:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773856470;
	bh=+m5vnfAODYCyWjrqQrLd5vT4BlnOmJEpTCTU2aZfT9Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s/BoreZdVnqsrVWBwMBkI9I4X6O9EBpAiG4YvaVjSHEwR9RpjQ3lXv1VfNRHR1TnJ
	 n4WnTMiYAE7IIwIqONzVShWf/LfjZwxtlUNb71eV38iDZXkrWVkEmG1PgENrcSRAiI
	 7i3KFNKBTkY/1Ar/P6MM1OEG1Uk5vVJinP/w8LzbAu+quj/JFPmG4ca62TaUG3uL+m
	 V61FOabdtsrO62978MAEL0RK8bgF6Z3L7gy9fjz7otdzxmBBXhFLO6ZlV5s1ZdZGLL
	 p3VsACkBOZqhKyxlBLxAR1+7OX4Y49J+UB9BnsC/PTrvW+hDnsdiL2XR/008HZkZQl
	 MiDk/Kv8QoEkg==
Date: Wed, 18 Mar 2026 17:54:42 +0000
From: Jean-Philippe Brucker <jpb@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Mark Rutland <mark.rutland@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 15/30] KVM: arm64: Support SME control registers
Message-ID: <20260318175442.GM2390801@myrica>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-15-43f7683a0fb7@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306-kvm-arm64-sme-v10-15-43f7683a0fb7@kernel.org>

On Fri, Mar 06, 2026 at 05:01:07PM +0000, Mark Brown wrote:
> SME is configured by the system registers SMCR_EL1 and SMCR_EL2, add
> definitions and userspace access for them.  These control the SME vector
> length in a manner similar to that for SVE and also have feature enable
> bits for SME2 and FA64.  A subsequent patch will add management of them
> for guests as part of the general floating point context switch, as is
> done for the equivalent SVE registers.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Looks correct, but I think we also need locate_direct_register(),
read_sr_from_cpu() and write_sr_to_cpu() now?

Thanks,
Jean

