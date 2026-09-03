Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD09847F2D3;
	Thu,  3 Sep 2026 16:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451848; cv=none; b=i7oN51fUnbdf4s7S8QqpWVQgUwcHD25pnJgy249uR/YVLhVBLLczrjONNG4HQtB+dYVIT76zI9H0Hahl2VAY+1EUwuuVd5+KsG2WN6fydR/YBRbPebNVxO++TWQccqCpWMmu7hNdKnnrvBPcqhSl+zCCf8DcZVAOSyB5AYfVWyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451848; c=relaxed/simple;
	bh=spJZ+iAfaUboSrfrYfHD1ZugMzuusDISfb/fmWfy7i4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rjIcK4LYmNlN4K6I3+mtzAQHcMO7xBFByyonNA6dv5qUgH642rjja3OsNj/SGkMI9O7RsIAQZHGp4yl3v6+2myKpP13JxLdXwzhfP546kbcQTTFyGp4fPBfmphFpynjK/3kzam1eDBsV1dR6Ye1ZPDZ5HffAFABZRpZgAWMzJAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=La7gvet+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="La7gvet+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F6E1F000E9;
	Thu,  3 Sep 2026 16:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788451847;
	bh=pBXLV/aReRggToYPyghrVtwl5A0a39umqxSD8Pkwnbo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=La7gvet+3cgiB6ZHetPHOHJ/G5wn1zMPvJrFbrd1xKIBS1PvlfH2NKKWCxPKJKLTu
	 naHfridSE8ebRQpg3ZSoCaKPKQ+An6rV489cLxgBFuFKQuDclp1WSuGsx9ksS0gNzX
	 7LYGI++Oc5fp/g/htz2fhSsR/mWNMjIKCaC8lJAIJemJZ8ueF1IN4VxSCvtGZmk9XP
	 W2wykO/AkuGaCivJ0M6NpGiF3GgMDoLSZKtM8bFiXa5Tq5+PPAf8d8/pyRQ5nJfzmW
	 duFUjAY4dZm6V5YX+0kRFo72uUE6alj2NFxBMns5RskQBas+udohXUSmCpJ6PlxLTO
	 O3wsJZ1TK7saw==
Date: Thu, 3 Sep 2026 17:10:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 01/14] arm64/gcs: Ensure FGTs for EL1 GCS
 instructions are disabled
Message-ID: <apmXlJ3ScZ3-qlKV@gremlin>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-1-f31750bdfadb@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-arm64-gcs-v20-1-f31750bdfadb@kernel.org>

On Tue, Sep 01, 2026 at 10:46:59PM +0100, Mark Brown wrote:
> The initial EL2 setup for GCS did not include disabling of EL1 usage of
> GCS instructions, also disable these traps.
>
> Fixes: ff5181d8a2a8 ("arm64/gcs: Provide basic EL2 setup to allow GCS usage at EL0 and EL1")
> Reviewed-by: Leonardo Bras <leo.bras@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/el2_setup.h | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index aa8ec9df8024..d308c6e6757d 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -393,6 +393,11 @@
>  	orr	x0, x0, #HFGRTR_EL2_nGCS_EL1_MASK
>  	orr	x0, x0, #HFGRTR_EL2_nGCS_EL0_MASK
>
> +	/* Disable traps of GCS instructions at EL1 */
> +	orr	x2, x2, #HFGITR_EL2_nGCSEPP_MASK
> +	orr	x2, x2, #HFGITR_EL2_nGCSSTR_EL1_MASK
> +	orr	x2, x2, #HFGITR_EL2_nGCSPUSHM_EL1_MASK

(Forgive me being verbose here I'm thinking my way through things :)

So this is effectively:

Set bits from these masks:

	HFGITR_EL2_nGCSEPP_MASK |
	HFGITR_EL2_nGCSSTR_EL1_MASK |
	HFGITR_EL2_nGCSPUSHM_EL1_MASK

Then (later instruction):

msr_s	SYS_HFGITR_EL2, x2

I.e. set the hypervisor fine-grained instruction register ([0]).

And I can see from that document that for each bit:

0b1
Execution of the specified instructions is not trapped by this mechanism.

So this correctly disables these instructions:

GCSPUSHX
GCSPOPCX
GCSSTR
GCSSTTR when PSTATE.UAO is 1
GCSSTTR when the Effective value of HCR_EL2.{NV, NV1} is {1, 1}
GCSPUSHM

And these are the only listed GCS sets of instructions there.

On that basis LGTM :)

So:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[0]: https://support.arm.com/documentation/111107/2026-06/AArch64-Registers/HFGITR-EL2--Hypervisor-Fine-Grained-Instruction-Trap-Register


> +
>  .Lskip_gce_fgt_\@:
>
>  .Lset_fgt_\@:
>
> --
> 2.47.3
>
>

--
Cheers, Lorenzo
