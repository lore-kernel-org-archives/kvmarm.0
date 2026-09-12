Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 719D63546E4
	for <kvmarm@lists.linux.dev>; Sat, 12 Sep 2026 07:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198394; cv=none; b=KcVR67JEJh1cIUzEBc4srFeY/5J0+E+OURPTd5TsvUd9azu8nLQtVuaTOGYTT+gfq3Or+4oi0U84U5wefXYsqPEMRWY3HAipfN9IFkVYEwz94XK5XH4/L16Aq668DekaLH5kNZxqQjQxr75L+DTvaS3sjzw9bMSnk4pC+Bi9frw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198394; c=relaxed/simple;
	bh=W6P9S/5u8vvHOhPV+LxKN8SC8NvTFt1LDLUls5YKdl4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aA/AzupMaAftLmVGX3Yt0dQEp+5nMSezIyez/vGO+d3MeibgR23oiRM+3tkF9zb5oKjWhyFX4itLNHjLvAhhZ50tJMp4BkQaNzwrTR5YJdMV22sYFtKYZkHmr8U4wvqDs8pcnVDX5IvIEZtsEqyZYf7tWvlpMMbEu5VSJULJa6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nm8FPW1y; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nm8FPW1y"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E760C16F2;
	Sat, 12 Sep 2026 00:33:07 -0700 (PDT)
Received: from [10.57.10.2] (unknown [10.57.10.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1E8663F7D8;
	Sat, 12 Sep 2026 00:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789198391; bh=W6P9S/5u8vvHOhPV+LxKN8SC8NvTFt1LDLUls5YKdl4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nm8FPW1yjoqULOYMreKfRXF4Ys5DBXDCuQ6Zld6B0FzCKooBANTT8kB+jhuMTxzex
	 kLRGEciCvly24goO0SByBH9X7LBHATupsqFJBxMdj4QV/Rsjy1pAGFNGazIZeX9/gL
	 7wGuKIvFUgJQlOXcAt2gUcgbiN3MOvUhyD08T+0s=
Message-ID: <3bb3d57a-1862-4645-a5e2-789d70e9fc73@arm.com>
Date: Sat, 12 Sep 2026 08:33:08 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool 1/5] arm64: Do not abort on register-dump failures
Content-Language: en-GB
To: Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Fuad Tabba <tabba@google.com>
References: <20260831192406.1341841-1-fuad.tabba@linux.dev>
 <20260831192406.1341841-2-fuad.tabba@linux.dev>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260831192406.1341841-2-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/08/2026 20:24, Fuad Tabba wrote:
> kvm_cpu__show_registers() and kvm_cpu__show_code() read the vCPU's core
> registers with KVM_GET_ONE_REG, and die() if the ioctl fails. Both are
> diagnostics. They run from the KVM_EXIT_DEBUG case in kvm_cpu__start(),
> from the "lkvm debug -d" dump path in handle_sigusr1(), and from the
> panic dump in kvm_cpu_thread().
> 
> Once a protected vCPU has run, its registers belong to the guest and
> KVM_GET_ONE_REG returns -EPERM. Dying on that turns a diagnostic into a
> VMM abort.

Marc once suggested that these could always succeed with junk values for
protected/Realm VMs. Do you think that is an option for pKVM ?


If we go with this approach :

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> 
> Report that the register state is unavailable, with the errno, and
> return instead of dying.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>   arm64/kvm-cpu.c | 36 ++++++++++++++++++++++++------------
>   1 file changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
> index 3aa7684..c58d61f 100644
> --- a/arm64/kvm-cpu.c
> +++ b/arm64/kvm-cpu.c
> @@ -476,15 +476,19 @@ void kvm_cpu__show_code(struct kvm_cpu *vcpu)
>   
>   	dprintf(debug_fd, "\n*pc:\n");
>   	reg.id = ARM64_CORE_REG(regs.pc);
> -	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> -		die("KVM_GET_ONE_REG failed (show_code @ PC)");
> +	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
> +		pr_err("register state unavailable (pc): %s", strerror(errno));
> +		return;
> +	}

>   
>   	kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
>   
>   	dprintf(debug_fd, "\n*lr:\n");
>   	reg.id = ARM64_CORE_REG(regs.regs[30]);
> -	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> -		die("KVM_GET_ONE_REG failed (show_code @ LR)");
> +	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
> +		pr_err("register state unavailable (lr): %s", strerror(errno));
> +		return;
> +	}
>   
>   	kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
>   }
> @@ -499,23 +503,31 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
>   	dprintf(debug_fd, "\n Registers:\n");
>   
>   	reg.id		= ARM64_CORE_REG(regs.pc);
> -	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> -		die("KVM_GET_ONE_REG failed (pc)");
> +	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
> +		pr_err("register state unavailable (pc): %s", strerror(errno));
> +		return;
> +	}
>   	dprintf(debug_fd, " PC:    0x%lx\n", data);
>   
>   	reg.id		= ARM64_CORE_REG(regs.pstate);
> -	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> -		die("KVM_GET_ONE_REG failed (pstate)");
> +	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
> +		pr_err("register state unavailable (pstate): %s", strerror(errno));
> +		return;
> +	}
>   	dprintf(debug_fd, " PSTATE:    0x%lx\n", data);
>   
>   	reg.id		= ARM64_CORE_REG(sp_el1);
> -	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> -		die("KVM_GET_ONE_REG failed (sp_el1)");
> +	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
> +		pr_err("register state unavailable (sp_el1): %s", strerror(errno));
> +		return;
> +	}
>   	dprintf(debug_fd, " SP_EL1:    0x%lx\n", data);
>   
>   	reg.id		= ARM64_CORE_REG(regs.regs[30]);
> -	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
> -		die("KVM_GET_ONE_REG failed (lr)");
> +	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
> +		pr_err("register state unavailable (lr): %s", strerror(errno));
> +		return;
> +	}
>   	dprintf(debug_fd, " LR:    0x%lx\n", data);
>   }
>   

