Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CFF7366557
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 10:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768298728; cv=none; b=aRx0qrG5qzfXoX8CG7l6iZLgM/4SjlSWPgVRDdvELp0YBZ30Pr9IatVRmjwjBIq8yTKEIuIV0yVP09czb9OGbeIIkxHtv8VHZrQhYMpA0LCbQgQI++IfNbj7BJMnOIp40+LN3RQjllGIsEcYKqlxT0wG4fbkSVt00/reG4AP/Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768298728; c=relaxed/simple;
	bh=JWXLVb707nEHkqfVhm/mbYxV2ox0Guk+FjcUauUJ6/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LBsQPWLFXWXWtjJLCMmqRPT7VE27h9yDLKht+2iAV23wBxCuMJztn82b4Cfcn6Hh9cP2mLnR6mLoDGtPzb8XO6rIGTSVHNuku5CRCP++x6ZpcsgLG+nLWZDll01AHCc/Lv0XV3DoepI58DOwBb8NhMg9Qxv+WxBORTm4GlPdbjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25DCF497;
	Tue, 13 Jan 2026 02:05:13 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9488E3F694;
	Tue, 13 Jan 2026 02:05:16 -0800 (PST)
Message-ID: <dcbeb11f-bebe-465a-be4e-2461d3efc21b@arm.com>
Date: Tue, 13 Jan 2026 10:05:15 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 27/30] KVM: arm64: selftests: Remove spurious check for
 single bit safe values
To: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Joey Gouly <joey.gouly@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>,
 Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, Eric Auger <eric.auger@redhat.com>
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
 <20251223-kvm-arm64-sme-v9-27-8be3867cb883@kernel.org>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20251223-kvm-arm64-sme-v9-27-8be3867cb883@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Mark,

On 12/23/25 01:21, Mark Brown wrote:
> get_safe_value() currently asserts that bitfields it is generating a safe
> value for must be more than one bit wide but in actual fact it should
> always be possible to generate a safe value to write to a bitfield even if
> it is just the current value and the function correctly handles that.
> Remove the assert.
> 
> Fixes: bf09ee918053e ("KVM: arm64: selftests: Remove ARM64_FEATURE_FIELD_BITS and its last user")
> Signed-off-by: Mark Brown <broonie@kernel.org>

Yes, this assert was unneeded.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

Thanks,

Ben

