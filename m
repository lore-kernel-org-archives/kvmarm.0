Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77396224AE0
	for <kvmarm@lists.linux.dev>; Mon,  7 Jul 2025 16:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751904481; cv=none; b=WD3qsbdYTT+vyoSj5jaMuuEguNCpeYiFnlK/MzjUaGiHC4EJTC3JXz1jSHFWeHUCVFwUeMvgsWVAxGX6kr7oVxlgrzuM14ESIbE9DXbhw9odhjuNBbZo8WvLkSNO3uX4Y2PNqN0u8cSiWJ3XPuHlNQO5F6dU3+t8gUf8L3kGdBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751904481; c=relaxed/simple;
	bh=2ygqV8EB6mY5V3xqX1r9SYbhNO7fGfzN/oIydN4m5Vc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O2CpUaP7hVkTowbL/kvpDOMzQV5s93hRjtcEfh3YqiNDTgkuvFCoXBBKUEcKHg4xkWG50zVMgDVGirPzdpO4O+GFP9nRDr+mfvMQeZxvhkfbWViytvg7zPzad0a+zzxojKsuK/Gp5bpQU178YFQpQlW15NbuDNd6+QZPQa08M88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78937168F;
	Mon,  7 Jul 2025 09:07:47 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3ADCC3F694;
	Mon,  7 Jul 2025 09:07:56 -0700 (PDT)
Date: Mon, 7 Jul 2025 17:07:53 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Shuah Khan <shuah@kernel.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 02/22] arm64: Generate sign macro for sysreg Enums
Message-ID: <aGvw2YojY0vVX_QT@J2N7QTR9R3>
References: <20250626200459.1153955-1-coltonlewis@google.com>
 <20250626200459.1153955-3-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250626200459.1153955-3-coltonlewis@google.com>

On Thu, Jun 26, 2025 at 08:04:38PM +0000, Colton Lewis wrote:
> There's no reason Enums shouldn't be equivalent to UnsignedEnums and
> explicitly specify they are unsigned. This will avoid the annoyance I
> had with HPMN0.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

I realise you've already agreed to drop this, so the below is mostly for
the sake of the archive.

We deliberately kept Enum separate from SignedEnum and UnsignedEnum as
there are enumerated ID fields which have no ordering, and are neither
signed nor unsigned (e.g. CTR_EL0.L1Ip).

That was discussed previously at:

  https://lore.kernel.org/all/Y5MrVC3d8MPhvshE@FVFF77S0Q05N/

We could consider adding a comment to that effect in gen-sysreg.awk, but
that needn't be part of this series.

Mark.

> ---
>  arch/arm64/tools/gen-sysreg.awk | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.awk
> index f2a1732cb1f6..fa21a632d9b7 100755
> --- a/arch/arm64/tools/gen-sysreg.awk
> +++ b/arch/arm64/tools/gen-sysreg.awk
> @@ -308,6 +308,7 @@ $1 == "Enum" && (block_current() == "Sysreg" || block_current() == "SysregFields
>  	parse_bitdef(reg, field, $2)
>  
>  	define_field(reg, field, msb, lsb)
> +	define_field_sign(reg, field, "false")
>  
>  	next
>  }
> -- 
> 2.50.0.727.gbf7dc18ff4-goog
> 
