Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE6C15699E
	for <kvmarm@lists.linux.dev>; Tue,  9 Jul 2024 13:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720530235; cv=none; b=JIlfkJe3jFFCmjQqkq+MufWVd7rZt6aS/bVJcwBOcMlswFjG//2NQCQo7CTBAru4MrQk4om4YfM4OJ9eyh5B36GA3IJLOM1tqYpqkz+TpdqSj+zpsoJ4p/UDJM8kBznmCPEOZmNxKCqFYQN15+llMOqAnnb8ddJ26ukegEqkpd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720530235; c=relaxed/simple;
	bh=mwrASpw49AnYCbba3OfzUIrmgYAxUK7NmbfuMokRRyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lXTI9xdG1JNrRy33MFzSsa8K8FED2Y7k4964K6GSMUuxJjm4W1RL0SJBJ+Umf+hIQqtm2VVhh6LNUSv3unPy968nouTidjGU1SIKS5jdyVTdTEcnE/SCgz7SO4JydMCe0shxmKoB7c31liDUIH2RYngEhXM58SPwL0UqwbGQgZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E083B153B;
	Tue,  9 Jul 2024 06:04:17 -0700 (PDT)
Received: from [10.44.160.75] (e126510-lin.lund.arm.com [10.44.160.75])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 58E303F766;
	Tue,  9 Jul 2024 06:03:45 -0700 (PDT)
Message-ID: <d41e8660-e081-4a60-a901-94eb2f72a643@arm.com>
Date: Tue, 9 Jul 2024 15:03:41 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 15/29] arm64: handle PKEY/POE faults
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
 <20240503130147.1154804-16-joey.gouly@arm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <20240503130147.1154804-16-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/05/2024 15:01, Joey Gouly wrote:
> [...]
>
> +static bool fault_from_pkey(unsigned long esr, struct vm_area_struct *vma,
> +			unsigned int mm_flags)
> +{
> +	unsigned long iss2 = ESR_ELx_ISS2(esr);
> +
> +	if (!arch_pkeys_enabled())
> +		return false;
> +
> +	if (iss2 & ESR_ELx_Overlay)
> +		return true;
> +
> +	return !arch_vma_access_permitted(vma,
> +			mm_flags & FAULT_FLAG_WRITE,
> +			mm_flags & FAULT_FLAG_INSTRUCTION,
> +			mm_flags & FAULT_FLAG_REMOTE);

This function is only called from do_page_fault(), so the access cannot
be remote. The equivalent x86 function (access_error()) always sets
foreign to false.

> +}
> +
>  static vm_fault_t __do_page_fault(struct mm_struct *mm,
>  				  struct vm_area_struct *vma, unsigned long addr,
>  				  unsigned int mm_flags, unsigned long vm_flags,
> @@ -529,6 +547,8 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
>  	unsigned int mm_flags = FAULT_FLAG_DEFAULT;
>  	unsigned long addr = untagged_addr(far);
>  	struct vm_area_struct *vma;
> +	bool pkey_fault = false;
> +	int pkey = -1;
>  
>  	if (kprobe_page_fault(regs, esr))
>  		return 0;
> @@ -590,6 +610,12 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
>  		vma_end_read(vma);
>  		goto lock_mmap;
>  	}
> +
> +	if (fault_from_pkey(esr, vma, mm_flags)) {
> +		vma_end_read(vma);
> +		goto lock_mmap;
> +	}
> +
>  	fault = handle_mm_fault(vma, addr, mm_flags | FAULT_FLAG_VMA_LOCK, regs);
>  	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
>  		vma_end_read(vma);
> @@ -617,6 +643,11 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
>  		goto done;
>  	}
>  
> +	if (fault_from_pkey(esr, vma, mm_flags)) {
> +		pkey_fault = true;
> +		pkey = vma_pkey(vma);
> +	}
> +
>  	fault = __do_page_fault(mm, vma, addr, mm_flags, vm_flags, regs);

We don't actually need to call __do_page_fault()/handle_mm_fault() if
the fault was caused by POE. It still works since it checks
arch_vma_access_permitted() early, but we might as well skip it
altogether (like on x86). On 6.10-rcX, we could handle it like a missing
vm_flags (goto bad_area).

Kevin
