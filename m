Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5673C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jun 2022 13:40:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 197BD49EC5;
	Wed,  1 Jun 2022 09:40:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zrxCfAXlfvbI; Wed,  1 Jun 2022 09:40:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84D564088C;
	Wed,  1 Jun 2022 09:40:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68E534B382
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jun 2022 09:40:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QUO90fImy6Zn for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Jun 2022 09:40:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECD204B166
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jun 2022 09:40:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5DF65ED1;
 Wed,  1 Jun 2022 06:40:25 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1BD893F73D;
 Wed,  1 Jun 2022 06:40:24 -0700 (PDT)
Date: Mon, 30 May 2022 16:05:17 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 kvmtool 02/13] sizes.h: Make all sizes 64bit
Message-ID: <20220530160517.657115f8@donnerap.cambridge.arm.com>
In-Reply-To: <20220525112345.121321-3-alexandru.elisei@arm.com>
References: <20220525112345.121321-1-alexandru.elisei@arm.com>
 <20220525112345.121321-3-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Cc: julien@xen.org, maz@kernel.org, will@kernel.org,
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

On Wed, 25 May 2022 12:23:34 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> Append ULL to all of the size definitions to make them 64bit and avoid
> overflows.

I am not fully convinced this is the best solution, as it deviates from
the kernel file, and just papers over issues at the call sites. I
acknowledge the pragmatic approach of trying to fix multiple problems at
once, but am wondering if we should use -fsanitize=undefined to identify
problematic code and fix it (I started doing this, actually).

Cheers,
Andre

> Reported-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  include/linux/sizes.h | 64 +++++++++++++++++++++----------------------
>  1 file changed, 32 insertions(+), 32 deletions(-)
> 
> diff --git a/include/linux/sizes.h b/include/linux/sizes.h
> index ce3e8150c174..b2b5c457cf1c 100644
> --- a/include/linux/sizes.h
> +++ b/include/linux/sizes.h
> @@ -8,40 +8,40 @@
>  #ifndef __LINUX_SIZES_H__
>  #define __LINUX_SIZES_H__
>  
> -#define SZ_1				0x00000001
> -#define SZ_2				0x00000002
> -#define SZ_4				0x00000004
> -#define SZ_8				0x00000008
> -#define SZ_16				0x00000010
> -#define SZ_32				0x00000020
> -#define SZ_64				0x00000040
> -#define SZ_128				0x00000080
> -#define SZ_256				0x00000100
> -#define SZ_512				0x00000200
> +#define SZ_1				0x00000001ULL
> +#define SZ_2				0x00000002ULL
> +#define SZ_4				0x00000004ULL
> +#define SZ_8				0x00000008ULL
> +#define SZ_16				0x00000010ULL
> +#define SZ_32				0x00000020ULL
> +#define SZ_64				0x00000040ULL
> +#define SZ_128				0x00000080ULL
> +#define SZ_256				0x00000100ULL
> +#define SZ_512				0x00000200ULL
>  
> -#define SZ_1K				0x00000400
> -#define SZ_2K				0x00000800
> -#define SZ_4K				0x00001000
> -#define SZ_8K				0x00002000
> -#define SZ_16K				0x00004000
> -#define SZ_32K				0x00008000
> -#define SZ_64K				0x00010000
> -#define SZ_128K				0x00020000
> -#define SZ_256K				0x00040000
> -#define SZ_512K				0x00080000
> +#define SZ_1K				0x00000400ULL
> +#define SZ_2K				0x00000800ULL
> +#define SZ_4K				0x00001000ULL
> +#define SZ_8K				0x00002000ULL
> +#define SZ_16K				0x00004000ULL
> +#define SZ_32K				0x00008000ULL
> +#define SZ_64K				0x00010000ULL
> +#define SZ_128K				0x00020000ULL
> +#define SZ_256K				0x00040000ULL
> +#define SZ_512K				0x00080000ULL
>  
> -#define SZ_1M				0x00100000
> -#define SZ_2M				0x00200000
> -#define SZ_4M				0x00400000
> -#define SZ_8M				0x00800000
> -#define SZ_16M				0x01000000
> -#define SZ_32M				0x02000000
> -#define SZ_64M				0x04000000
> -#define SZ_128M				0x08000000
> -#define SZ_256M				0x10000000
> -#define SZ_512M				0x20000000
> +#define SZ_1M				0x00100000ULL
> +#define SZ_2M				0x00200000ULL
> +#define SZ_4M				0x00400000ULL
> +#define SZ_8M				0x00800000ULL
> +#define SZ_16M				0x01000000ULL
> +#define SZ_32M				0x02000000ULL
> +#define SZ_64M				0x04000000ULL
> +#define SZ_128M				0x08000000ULL
> +#define SZ_256M				0x10000000ULL
> +#define SZ_512M				0x20000000ULL
>  
> -#define SZ_1G				0x40000000
> -#define SZ_2G				0x80000000
> +#define SZ_1G				0x40000000ULL
> +#define SZ_2G				0x80000000ULL
>  
>  #endif /* __LINUX_SIZES_H__ */

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
