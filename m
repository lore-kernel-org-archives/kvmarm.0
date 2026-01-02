Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDFFB207DF7
	for <kvmarm@lists.linux.dev>; Fri,  2 Jan 2026 14:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767364965; cv=none; b=jM+ETasHbTL/tQNzJ3qqK9MiQzzBEB5HSlLp6VnD8lepqyEDqcEN0Eq3sSs0PB8dBRrCJuL1hI/A7mpEKo9AhGWaDA/nJZBhZ/pK3/Bef/7emQOVlJDZ1KPcXaZMBAiKMi+Sxcu18TbZ52CE+545XKjYMPesLii2/N4Y9dbowLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767364965; c=relaxed/simple;
	bh=j+0md4xMGQDF5koODOqbddxSR8/pVlmIT/xX8zVwaUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oWasC+HK0Gnl83KIjxARFhJwnMY827Z5dSxilf28JGUpU40A1C31We7krQhUKRrtbuLg6a7F1REZhcsLzKWAbnWZD1k2pPfnFKkNASLozGD+a9U06d2sWp3FileYYAf7UVia93P/LiFHTjvSP8JtlgOTxpS2RCLnr11uhKYqd4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5011C497;
	Fri,  2 Jan 2026 06:42:36 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 45D1E3F63F;
	Fri,  2 Jan 2026 06:42:41 -0800 (PST)
Message-ID: <99f23278-47de-4ee5-8ca5-18387f187f16@arm.com>
Date: Fri, 2 Jan 2026 14:42:39 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] KVM: selftests: arm64: Report register reset tests
 individually
To: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Oliver Upton <oupton@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251219-kvm-arm64-set-id-regs-aarch64-v3-0-bfa474ec3218@kernel.org>
 <20251219-kvm-arm64-set-id-regs-aarch64-v3-2-bfa474ec3218@kernel.org>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20251219-kvm-arm64-set-id-regs-aarch64-v3-2-bfa474ec3218@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Mark,

On 12/19/25 19:28, Mark Brown wrote:
> set_id_regs tests that registers have their values preserved over reset.
> Currently it reports all registers in a single test with an instantly fatal
> assert which isn't great for diagnostics, it's hard to tell which register
> failed or if it's just one register. Change this to report each register as
> a separate test so that it's clear from the program output which registers
> have problems.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/kvm/arm64/set_id_regs.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

Thanks,

Ben

