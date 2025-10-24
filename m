Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73C2B2F8BF7
	for <kvmarm@lists.linux.dev>; Fri, 24 Oct 2025 08:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761296196; cv=none; b=GuR+YG9uYJ0oBEPQtlFpGcnLj7UxptVhZ8jAvvB6GE0Uc1CKY2P3DbvAAlV4afXR/X8xvhxVAkTccTqAhy9+qxrTbisvkBaFFB1XzuazcjvDQaG9MqLhzj1jfvFqgoGZMAE4oxIzWQMd/Q2AXXKOS9EuaFmAGSeedyAFERhb+Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761296196; c=relaxed/simple;
	bh=6Rb3pGmcQ3WWjYFKgBeNCXjNeL3qm6EeK5c4MJTNmAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F/jVVVuj90LQfRQsE2g9c8f0thSmfZH1QJRjiAGGyYJE802xVptC0ahw/TlSYbkx82Ct0UMVcxxzSewEbiJg8kyjJa3gxfJzYls9e5BAhL/5R8r/zpUv7ByPxVBtat1VLh2wNQvp29by8OU78qOJoa4ZTvTlY2WbiYu0mMLb2D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04B261516;
	Fri, 24 Oct 2025 01:56:25 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B384A3F63F;
	Fri, 24 Oct 2025 01:56:31 -0700 (PDT)
Message-ID: <95ee2490-6904-4a24-93db-411c489bd2b4@arm.com>
Date: Fri, 24 Oct 2025 09:56:30 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/2] arm64/mm: Add remaining TLBI_XXX_MASK macros
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
References: <20251024040207.137480-1-anshuman.khandual@arm.com>
 <20251024040207.137480-3-anshuman.khandual@arm.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20251024040207.137480-3-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Anshuman,

On 10/24/25 05:02, Anshuman Khandual wrote:
> Add remaining TLBI_XXX_MASK macros and replace current open encoded fields.
> While here replace hard coded page size based shifts but with derived ones
> via ilog2() thus adding some required context.
> 
> TLBI_TTL_MASK has been split into separate TLBI_TTL_MASK and TLBI_TG_MASK
> as appropriate because currently it simultaneously contains both page size
> and translation table level information. KVM on arm64 has been updated to
> accommodate these changes to TLBI_TTL_MASK.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kvmarm@lists.linux.dev
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/include/asm/tlbflush.h | 26 ++++++++++++++++++--------
>  arch/arm64/kvm/nested.c           |  8 +++++---
>  2 files changed, 23 insertions(+), 11 deletions(-)
> 
The code looks correct to me, no functional changes. I however, don't
have any experience with this code and so don't know whether the split
of TTL into TG and TTL is a good idea or not and if the kvm naming is
best to stay the same or be updated to match this.

Thanks,

Ben

