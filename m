Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D69A1A705E
	for <kvmarm@lists.linux.dev>; Tue, 24 Sep 2024 11:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727177288; cv=none; b=AT58GPaAIpppMDns3nEihCieGyrd/e9EYtlPKkxpgMiybo5lMZ7DHrwNPXFXHDkGYhPszYVdz8lDq5/hKZB87eoYwWilNKk9DB7eR5WhAEKoMvM4ZYhKy0u+YmVyPy/lGiSfVi7kmitgochc1OIMJ+WS8uKYGtpJBO2ouHLYSV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727177288; c=relaxed/simple;
	bh=w6ZtRnLtQAfgK8GE4fbEyNK/ud8SdGHKIdYvFa+frKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zp1MBbgPzKWUCgpErZiH6W6h/ca1JAJJItab9JYiFMTycCqzrCbP4ytfcyQzRnXa0ilDfaIsHLt2Yh4WmdROkCWGBITZ1vG28Qgsl3rwx0yVpY/Uu8qRFo6op8BjYXvLv83DkrU8lndAButuDs54Q4MXx8ps42WBPXYY6Ik3Nvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EADECDA7;
	Tue, 24 Sep 2024 04:28:34 -0700 (PDT)
Received: from [10.57.76.149] (unknown [10.57.76.149])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 452493F528;
	Tue, 24 Sep 2024 04:28:00 -0700 (PDT)
Message-ID: <47e1537f-5b60-4541-aed1-a20e804c137d@arm.com>
Date: Tue, 24 Sep 2024 13:27:58 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 19/30] arm64: add POE signal support
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: nd@arm.com, akpm@linux-foundation.org, aneesh.kumar@kernel.org,
 aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, bp@alien8.de,
 broonie@kernel.org, catalin.marinas@arm.com, christophe.leroy@csgroup.eu,
 dave.hansen@linux.intel.com, hpa@zytor.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, maz@kernel.org,
 mingo@redhat.com, mpe@ellerman.id.au, naveen.n.rao@linux.ibm.com,
 npiggin@gmail.com, oliver.upton@linux.dev, shuah@kernel.org,
 skhan@linuxfoundation.org, szabolcs.nagy@arm.com, tglx@linutronix.de,
 will@kernel.org, x86@kernel.org, kvmarm@lists.linux.dev,
 linux-kselftest@vger.kernel.org
References: <20240822151113.1479789-1-joey.gouly@arm.com>
 <20240822151113.1479789-20-joey.gouly@arm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <20240822151113.1479789-20-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/08/2024 17:11, Joey Gouly wrote:
> @@ -1178,6 +1237,9 @@ static void setup_return(struct pt_regs *regs, struct k_sigaction *ka,
>  		sme_smstop();
>  	}
>  
> +	if (system_supports_poe())
> +		write_sysreg_s(POR_EL0_INIT, SYS_POR_EL0);

At the point where setup_return() is called, the signal frame has
already been written to the user stack. In other words, we write to the
user stack first, and then reset POR_EL0. This may be problematic,
especially if we are using the alternate signal stack, which the
interrupted POR_EL0 may not grant access to. In that situation uaccess
will fail and we'll end up with a SIGSEGV.

This issue has already been discussed on the x86 side, and as it happens
patches to reset PKRU early [1] have just landed. I don't think this is
a blocker for getting this series landed, but we should try and align
with x86. If there's no objection, I'm planning to work on a counterpart
to the x86 series (resetting POR_EL0 early during signal delivery).

Kevin

[1]
https://lore.kernel.org/lkml/20240802061318.2140081-2-aruna.ramakrishna@oracle.com/

> +
>  	if (ka->sa.sa_flags & SA_RESTORER)
>  		sigtramp = ka->sa.sa_restorer;
>  	else

