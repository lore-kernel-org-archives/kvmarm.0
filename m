Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36866C43334
	for <kvmarm@archiver.kernel.org>; Wed, 29 Jun 2022 14:33:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90F104B4A6;
	Wed, 29 Jun 2022 10:33:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2J8NHtDt2SbJ; Wed, 29 Jun 2022 10:33:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CA974B5F4;
	Wed, 29 Jun 2022 10:33:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E33944B5F4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2022 10:33:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y0wm-EUwAkTk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jun 2022 10:33:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DAE84B5DF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2022 10:33:40 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19403152B;
 Wed, 29 Jun 2022 07:33:40 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E23843F792;
 Wed, 29 Jun 2022 07:33:38 -0700 (PDT)
Date: Wed, 29 Jun 2022 15:33:32 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool] arm64: pvtime: Use correct region size
Message-ID: <20220629153332.01a94234@donnerap.cambridge.arm.com>
In-Reply-To: <20220629103905.24480-1-alexandru.elisei@arm.com>
References: <20220629103905.24480-1-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Cc: pierre.gondois@arm.com, maz@kernel.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, 29 Jun 2022 11:39:05 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> pvtime uses ARM_PVTIME_BASE instead of ARM_PVTIME_SIZE for the size of the
> memory region given to the guest, which causes to the following error when
> creating a flash device (via the -F/--flash command line argument):
> 
>   Error: RAM (read-only) region [2000000-27fffff] would overlap RAM region [1020000-203ffff]
> 
> The read-only region represents the guest memory where the flash image is
> copied by kvmtool. The region starting at 0x102_0000 (ARM_PVTIME_BASE) is
> the pvtime region, which should be 64K in size. kvmtool erroneously creates
> the region to be ARM_PVTIME_BASE in size instead, and the last address
> becomes:
> 
> ARM_PVTIME_BASE + ARM_PVTIME_BASE - 1 = 0x102_0000 + 0x102_0000 - 1 = 0x203_ffff
> 
> which corresponds to the end of the region from the error message.
> 
> Do the right thing and make the pvtime memory region ARM_PVTIME_SIZE = 64K
> bytes, as it was intended.
> 
> Fixes: 7d4671e5d372 ("aarch64: Add stolen time support")
> Reported-by: Pierre Gondois <pierre.gondois@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Oops, this looks indeed like a glaring bug, PVTIME_SIZE was not used
anywhere.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  arm/aarch64/pvtime.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
> index a49cf3ed5478..2933ac7ca959 100644
> --- a/arm/aarch64/pvtime.c
> +++ b/arm/aarch64/pvtime.c
> @@ -14,15 +14,15 @@ static int pvtime__alloc_region(struct kvm *kvm)
>  	char *mem;
>  	int ret = 0;
>  
> -	mem = mmap(NULL, ARM_PVTIME_BASE, PROT_RW,
> +	mem = mmap(NULL, ARM_PVTIME_SIZE, PROT_RW,
>  		   MAP_ANON_NORESERVE, -1, 0);
>  	if (mem == MAP_FAILED)
>  		return -errno;
>  
>  	ret = kvm__register_ram(kvm, ARM_PVTIME_BASE,
> -				ARM_PVTIME_BASE, mem);
> +				ARM_PVTIME_SIZE, mem);
>  	if (ret) {
> -		munmap(mem, ARM_PVTIME_BASE);
> +		munmap(mem, ARM_PVTIME_SIZE);
>  		return ret;
>  	}
>  
> @@ -36,8 +36,8 @@ static int pvtime__teardown_region(struct kvm *kvm)
>  		return 0;
>  
>  	kvm__destroy_mem(kvm, ARM_PVTIME_BASE,
> -			 ARM_PVTIME_BASE, usr_mem);
> -	munmap(usr_mem, ARM_PVTIME_BASE);
> +			 ARM_PVTIME_SIZE, usr_mem);
> +	munmap(usr_mem, ARM_PVTIME_SIZE);
>  	usr_mem = NULL;
>  	return 0;
>  }

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
