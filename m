Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE4819CC16
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 15:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726066925; cv=none; b=sXFUWh/e1Q6XlHxpVpIuMC3Hbe0fhmQhPp+asvnpRXXG/VW4c6YqjbrUtqmkqb0QdPXAghSWBGmKdzgm+9PLha5ILBRsgUh2oaBQuQwgTYRd0w5aMDgQ7QJK81verROZzGK8XLlVm59ZidiH0yAe8ypOtxHb9APcFMbRM8n6Sr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726066925; c=relaxed/simple;
	bh=KFoLsMibpjrh3IxjBWh3BLz+C6klx9k2wrAaGvcurH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=taxBtWBb97Fl1G0rtDw1WgYi8Wzr6lvru4hzQdSJIyRb56iYqOkaTAnUYll6IMsfP6JlwaGN5/57TxZlEt9O1cNfP4IG4IC6ueodEV2b9FgJQPDtEJA2rnI2XC8UMDI2mnhvNO+lr3KpitVRi/uMtGGtaztt8ikBVnEnGFjSNOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DBAFD1007;
	Wed, 11 Sep 2024 08:02:30 -0700 (PDT)
Received: from [10.57.74.200] (unknown [10.57.74.200])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE3AF3F73B;
	Wed, 11 Sep 2024 08:01:55 -0700 (PDT)
Message-ID: <425b8f8c-b6b5-422a-b5f4-41dd2d1ae3bb@arm.com>
Date: Wed, 11 Sep 2024 17:01:53 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/30] arm64: context switch POR_EL0 register
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
 <20240822151113.1479789-7-joey.gouly@arm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <20240822151113.1479789-7-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/08/2024 17:10, Joey Gouly wrote:
> @@ -371,6 +382,9 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
>  		if (system_supports_tpidr2())
>  			p->thread.tpidr2_el0 = read_sysreg_s(SYS_TPIDR2_EL0);
>  
> +		if (system_supports_poe())
> +			p->thread.por_el0 = read_sysreg_s(SYS_POR_EL0);

Here we are only reloading POR_EL0's value if the target is a user
thread. However, as this series stands, POR_EL0 is also relevant to
kthreads, because any uaccess or GUP done from a kthread will also be
checked against POR_EL0. This is especially important in cases like the
io_uring kthread, which accesses the memory of the user process that
spawned it. To prevent such a kthread from inheriting a stale value of
POR_EL0, it seems that we should reload POR_EL0's value in all cases
(user and kernel thread).

Other approaches could also be considered (e.g. resetting POR_EL0 to
unrestricted when creating a kthread), see my reply on v4 [1].

Kevin

[1]
https://lore.kernel.org/linux-arm-kernel/b4f8b351-4c83-43b4-bfbe-8f67f3f56fb9@arm.com/
