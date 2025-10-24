Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571C9322C7B
	for <kvmarm@lists.linux.dev>; Fri, 24 Oct 2025 11:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761304606; cv=none; b=kfdcB4ADmf/+HaAAGWpRQGmW7Vb55IpBEyiAr10NhAyI7Pu7IbldiboYu6zbzV8oNgT1j/KZFFPnw7o6WOypCtxiKzhjGeJ/sdbkxOCFXKh8L73NGqD8SI5v+YkfhXdQE5yoO11x7Yb5tEOkBJLQ0ts161hjd4wvstmJ87lPuoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761304606; c=relaxed/simple;
	bh=UmZL96xlmSUAFD/iKxPCFAWAz1I/vlMjvK+h+poTwgo=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Typu7z47KPoJAqzDvzHqRN24L6mei2n4brXxxsZFvOClP46txB64Vd7osSyqCXdhZ96FYHqW4q/1nos1TU6NchZ9x8j/W6HoNK0Gzv7vN9NmoDA98rjN9k1k5iy1zvdxxMTwPHfEq3QeKz36xJykNHHwdwJAdu5ZG2P8+vRwNqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=DDZFKj8k; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="DDZFKj8k"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4UMPDfQ6PuPOQC+bvltkEyQ8+xopQBoiLu+OoONi8G0=;
	b=DDZFKj8kmPinEskrMJO9itfgm2rN0noacKtHlzLWMdwfrCcs1QLnENC7AuER4chtFiFxcyCkr
	p4d6LXnHmTm8zGM6ipHRaZn1qdlkr86aNYkWqSlfasyqvWOunX4oVdrgPkdq64LNr4pzuKlMQyr
	Y2dgHkbhQnJz1PSJ0CO3eME=
Received: from frasgout.his.huawei.com (unknown [172.18.146.37])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4ctKgJ26dJz1P6gM;
	Fri, 24 Oct 2025 19:00:12 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ctKbZ2T7wz6GDCL;
	Fri, 24 Oct 2025 18:56:58 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 6A4D914020C;
	Fri, 24 Oct 2025 19:00:16 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 24 Oct
 2025 12:00:15 +0100
Date: Fri, 24 Oct 2025 12:00:14 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <ben.horgan@arm.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	<linux-kernel@vger.kernel.org>, <kvmarm@lists.linux.dev>
Subject: Re: [PATCH V2 2/2] arm64/mm: Add remaining TLBI_XXX_MASK macros
Message-ID: <20251024120014.000020af@huawei.com>
In-Reply-To: <20251024040207.137480-3-anshuman.khandual@arm.com>
References: <20251024040207.137480-1-anshuman.khandual@arm.com>
	<20251024040207.137480-3-anshuman.khandual@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 24 Oct 2025 05:02:07 +0100
Anshuman Khandual <anshuman.khandual@arm.com> wrote:

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
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index 131096094f5b..cf75fc2a06c3 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -57,9 +57,10 @@
>  /* This macro creates a properly formatted VA operand for the TLBI */
>  #define __TLBI_VADDR(addr, asid)				\
>  	({							\
> -		unsigned long __ta = (addr) >> 12;		\
> -		__ta &= GENMASK_ULL(43, 0);			\
> -		__ta |= (unsigned long)(asid) << 48;		\
> +		unsigned long __ta = (addr) >> ilog2(SZ_4K);	\
> +		__ta &= TLBI_BADDR_MASK;			\
> +		__ta &= ~TLBI_ASID_MASK;			\
> +		__ta |= FIELD_PREP(TLBI_ASID_MASK, asid);	\
I think you can replace the two lines above with
		FIELD_MODIFY(TLBI_ASID_MASK, &__ta, asid);

It's a small reduction in code but I don't mind much either way.

>  		__ta;						\
>  	})
>  
> @@ -100,8 +101,17 @@ static inline unsigned long get_trans_granule(void)
>   *
>   * For Stage-2 invalidation, use the level values provided to that effect
>   * in asm/stage2_pgtable.h.
> + *
> + * +----------+------+-------+--------------------------------------+
> + * |   ASID   |  TG  |  TTL  |                 BADDR                |
> + * +-----------------+-------+--------------------------------------+
> + * |63      48|47  46|45   44|43                                   0|
> + * +----------+------+-------+--------------------------------------+
>   */
> -#define TLBI_TTL_MASK		GENMASK_ULL(47, 44)
> +#define TLBI_ASID_MASK		GENMASK_ULL(63, 48)
> +#define TLBI_TG_MASK		GENMASK_ULL(47, 46)
> +#define TLBI_TTL_MASK		GENMASK_ULL(45, 44)
> +#define TLBI_BADDR_MASK		GENMASK_ULL(43, 0)
>  
>  #define TLBI_TTL_UNKNOWN	INT_MAX
>  
> @@ -110,10 +120,10 @@ static inline unsigned long get_trans_granule(void)
>  									\
>  	if (alternative_has_cap_unlikely(ARM64_HAS_ARMv8_4_TTL) &&	\
>  	    level >= 0 && level <= 3) {					\
> -		u64 ttl = level;					\
> -		ttl |= get_trans_granule() << 2;			\
> +		arg &= ~TLBI_TG_MASK;					\
> +		arg |= FIELD_PREP(TLBI_TG_MASK, get_trans_granule());	\
>  		arg &= ~TLBI_TTL_MASK;					\
> -		arg |= FIELD_PREP(TLBI_TTL_MASK, ttl);			\
> +		arg |= FIELD_PREP(TLBI_TTL_MASK, level);		\

Similar potential to use FIELD_MODIFY for these.

Jonathan

