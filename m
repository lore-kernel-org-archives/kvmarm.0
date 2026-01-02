Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B80E822688C
	for <kvmarm@lists.linux.dev>; Fri,  2 Jan 2026 14:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767365111; cv=none; b=uYdEYc8j1LmRfd3ljxWp8T/ibgkXDNqyJ97TYyO6o2JHdYE8f01iYIjS97LlLggzqFbbkiIVxl3wvOf0JQqyR0XeUNo+UOVCDGHFCGKfJRmNUWqvNZdWd8EhCTu6jKatxDdTyFGYbec/VRZNkHjN76kkFgjYRWfOBEW4Jx8/i/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767365111; c=relaxed/simple;
	bh=uvh5CMuL1qjDeAkfbKton4beIpNhvv8kthzSLHp0lSY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=szfKs0MloHBEI7iLV1+26Mo7a0aLPsUhYE3zAyoVkE7b/2qiTGKAxIBtWYfiAgBQBoK7Js9FfNy0q/aKAjvDVRlE6VjNmTSTL/8ObHtKhD0Ck8t6bo2/HOBUWb2k8QSrLCgMbahoHCrThO8Y1gWQMltNQi/GGy2ZSg+8bY25pAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14127497;
	Fri,  2 Jan 2026 06:45:01 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C4383F63F;
	Fri,  2 Jan 2026 06:45:05 -0800 (PST)
Message-ID: <89fd9661-731c-4335-bee8-575a7c221390@arm.com>
Date: Fri, 2 Jan 2026 14:45:04 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] KVM: selftests: arm64: Make set_id_regs bitfield
 validatity checks non-fatal
To: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Oliver Upton <oupton@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251219-kvm-arm64-set-id-regs-aarch64-v3-0-bfa474ec3218@kernel.org>
 <20251219-kvm-arm64-set-id-regs-aarch64-v3-3-bfa474ec3218@kernel.org>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20251219-kvm-arm64-set-id-regs-aarch64-v3-3-bfa474ec3218@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Mark,

On 12/19/25 19:28, Mark Brown wrote:
> Currently when set_id_regs encounters a problem checking validation of
> writes to feature registers it uses an immediately fatal assert to report
> the problem. This is not idiomatic for kselftest, and it is also not great
> for usability. The affected bitfield is not clearly reported and further
> tests do not have their results reported.
> 
> Switch to using standard kselftest result reporting for the two asserts
> we do, these are non-fatal asserts so allow the program to continue and the
> test names include the affected field.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/kvm/arm64/set_id_regs.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)

This one also looks good to me. I'm not aware of why the asserts have
been favoured previously though.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

Thanks,

Ben

