Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF0B13BAC4
	for <kvmarm@lists.linux.dev>; Mon, 15 Jul 2024 08:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721032598; cv=none; b=nX63lzLDaOiV9OmvL4qAiXs2A6S8/Enh/89Ms5PyuXs1wnXeZZWqLSdyp/TP9wJFhDngvpWxUaCJ3hVFnJsXOwWJaLQw604LRSPPk6i53eJKm8KpnWi1mxsuAhSQfwCAoeuPUxCNdcjdBTkTupPNNuDCgP4hOsihGGunwBsRsG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721032598; c=relaxed/simple;
	bh=QDXXHwp4Bn8wZX+9ZWPKdP0qyb/qIHEd3mli5XN3Egg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YCfS1h5cFwV6ACiR3G7IezpDm9lmbW2FKFbUxTFJ78jt+RqDhcb64pwmGxf3yb9188MTJ6mp4wKSqvVoo2p/Jp9/SYx2AqsVUzbcmjQ596LZChE0vxUVvwggQEef6Tr4B6n1wGcWewsNxffg1escfELke2q7EywVZB5LJRR67fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 256A8DA7;
	Mon, 15 Jul 2024 01:37:01 -0700 (PDT)
Received: from [10.162.40.16] (a077893.blr.arm.com [10.162.40.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C89A3F73F;
	Mon, 15 Jul 2024 01:36:27 -0700 (PDT)
Message-ID: <82a5acea-0a06-437e-b246-ae2874c3493e@arm.com>
Date: Mon, 15 Jul 2024 14:06:24 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/29] KVM: arm64: make kvm_at() take an OP_AT_*
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, aneesh.kumar@kernel.org,
 aneesh.kumar@linux.ibm.com, bp@alien8.de, broonie@kernel.org,
 catalin.marinas@arm.com, christophe.leroy@csgroup.eu,
 dave.hansen@linux.intel.com, hpa@zytor.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, maz@kernel.org,
 mingo@redhat.com, mpe@ellerman.id.au, naveen.n.rao@linux.ibm.com,
 npiggin@gmail.com, oliver.upton@linux.dev, shuah@kernel.org,
 szabolcs.nagy@arm.com, tglx@linutronix.de, will@kernel.org, x86@kernel.org,
 kvmarm@lists.linux.dev
References: <20240503130147.1154804-1-joey.gouly@arm.com>
 <20240503130147.1154804-9-joey.gouly@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20240503130147.1154804-9-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/3/24 18:31, Joey Gouly wrote:
> To allow using newer instructions that current assemblers don't know about,
> replace the `at` instruction with the underlying SYS instruction.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_asm.h       | 3 ++-
>  arch/arm64/kvm/hyp/include/hyp/fault.h | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 24b5e6b23417..ce65fd0f01b0 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -10,6 +10,7 @@
>  #include <asm/hyp_image.h>
>  #include <asm/insn.h>
>  #include <asm/virt.h>
> +#include <asm/sysreg.h>
>  
>  #define ARM_EXIT_WITH_SERROR_BIT  31
>  #define ARM_EXCEPTION_CODE(x)	  ((x) & ~(1U << ARM_EXIT_WITH_SERROR_BIT))
> @@ -261,7 +262,7 @@ extern u64 __kvm_get_mdcr_el2(void);
>  	asm volatile(							\
>  	"	mrs	%1, spsr_el2\n"					\
>  	"	mrs	%2, elr_el2\n"					\
> -	"1:	at	"at_op", %3\n"					\
> +	"1:	" __msr_s(at_op, "%3") "\n"				\
>  	"	isb\n"							\
>  	"	b	9f\n"						\
>  	"2:	msr	spsr_el2, %1\n"					\
> diff --git a/arch/arm64/kvm/hyp/include/hyp/fault.h b/arch/arm64/kvm/hyp/include/hyp/fault.h
> index 9e13c1bc2ad5..487c06099d6f 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/fault.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/fault.h
> @@ -27,7 +27,7 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
>  	 * saved the guest context yet, and we may return early...
>  	 */
>  	par = read_sysreg_par();
> -	if (!__kvm_at("s1e1r", far))
> +	if (!__kvm_at(OP_AT_S1E1R, far))
>  		tmp = read_sysreg_par();
>  	else
>  		tmp = SYS_PAR_EL1_F; /* back to the guest */

I guess this patch has already been included in a different series now.

https://lore.kernel.org/all/20240625133508.259829-6-maz@kernel.org/
