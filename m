Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827620;
	b=QVdsqFqz2xjNW8EAZycGa9xn2/wXKpeQgmbHF7qsqA0+B7fr4moeYfnpSjLMJqUTDx86
	 Bt9NoK1JWeipGMUqOOWM9QIS+BCOE5pX2R+tx1efL8C4f58HKaMy3cfagWFmzIbkLHEZt
	 qyA+K0rFuLoVemD0UT1qwyoXZt8JSI9wL/LIygm+IICkKT7G8xSdoWIuNwH33CvFFYUBt
	 d9U0GDDcfPJYUQ7a+CGxn0YRdauABDkxN6PPJ9kTG8ZCPjSKVxxxVdkYAbPRG5j3kGvjs
	 iafPJ0mdsp39NdATysbpRo9N9UpAqBiu5UzOIAZqmZtRX58LVwqYxQ+5Z0DzywSH8yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827620;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=YujtF9aG5FJtZ1fqhFraeDow6hmwqE3ooTREx9HW1QQ=;
	b=k2F/PxjTSA9um96CU5Dl4aMZEJ8fOClWiNUFZS8fG6Kl9axkFzmcqkVg3gvCklaCjGTE
	 crZpbjM1tSME2gP25piPlC3OKCKmjLoLPogVsJxNGjoO45YS5Vxs9RLXJVNfeJnlGBAS9
	 +KO4QId8WlcTApYVewUnxzycSCtFLBcW4w6VP0AO3Z55tJdjJsAAtEa61v+mhU6Hh5Ujv
	 lSsSF0g2YCTfNhIDyVjAvKPpV8bnHFe4Y4PG5repMLG3e/QSNIG7Ra5r6WlvDlXA34wYh
	 uWNng+Lwa1MWJ34QqGP6kKFDh2bT/uQHQiLk/RDE7nayCCm++6NIZSjwheK7qY8Z+8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Z+eSypcy;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1839606A89D;
	Mon, 16 Nov 2026 11:13:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1839606A89D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Z+eSypcy
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 204451713;
	Mon, 16 Nov 2026 03:13:35 -0800 (PST)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA7643F632;
	Mon, 16 Nov 2026 03:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794827618; bh=aQUXlrLmvLA3/9J6e20mDqf2MdnG5musjaN7p70UOk8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Z+eSypcy8fNRkVainTE6LqR1+ogDNwY6a5fVhPAHNZrjtwDKa2x+PGD88IsZlhlTc
	 TO8sTnBMyTb/ujZzwOBZB+VofsKDHilkaEZ0sE/agL1JB7ZOYMRsxprEUHr9zYJf7B
	 BGH12vWH3xRs6fGloUxxxS3Qpo7ZIGCQnnWKhI88=
Message-ID: <9a2fab79-8266-4e23-b718-c9d7e128c5c0@arm.com>
Date: Mon, 16 Nov 2026 11:13:33 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/virt: pkvm: Zero and clean memory before sharing
 it with the host
To: Fuad Tabba <fuad.tabba@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
 Mostafa Saleh <smostafa@google.com>,
 Vincent Donnefort <vdonnefort@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 Fuad Tabba <tabba@google.com>, stable@vger.kernel.org
References: <20261116110549.1863653-1-fuad.tabba@linux.dev>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261116110549.1863653-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/11/2026 11:05, Fuad Tabba wrote:
> From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
> 
> On pKVM, set_memory_decrypted() shares pages with the host in place and
> without cache maintenance. The atomic pool, dma-direct and dynamic
> SWIOTLB pools zero their memory only after sharing it, so unless the
> page allocator has zeroed it, the host can read whatever the guest last
> left in it. Zeroing first isn't enough on its own, as the zeroes may not
> have been written back to memory, and a host that maps the pages
> Non-cacheable then reads the old contents.
> 
> Zero the range and clean it to the PoC before sharing it, so that no
> caller can hand the host stale data.
> 
> Fixes: ebc59b120c588 ("drivers/virt: pkvm: Hook up mem_encrypt API using pKVM hypercalls")
> Fixes: e62decaf98e7c ("arm64/coco: Add pKVM as a CC platform")
> Link: https://lore.kernel.org/r/20261116091137.94252-3-aneesh.kumar@kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> [fuad: take the pKVM hunk of v10 patch 2 as a standalone fix, add the clean to the PoC]
> Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

> ---
> 
> Notes:
>      This is the pKVM hunk of patch 2 of Aneesh's v10 [1] plus a clean to
>      the PoC, taken on its own because it fixes a bug that has exposed
>      guest memory to the host since v6.12.
>      
>      Based on Linux 7.4-rc3 (aebb727447640).
>      
>      [1] https://lore.kernel.org/r/20261116091137.94252-3-aneesh.kumar@kernel.org
> 
>   drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
> index 26fe9c3f22e36..81d1cd24a2eff 100644
> --- a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
> +++ b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
> @@ -9,10 +9,12 @@
>   
>   #include <linux/arm-smccc.h>
>   #include <linux/array_size.h>
> +#include <linux/cacheflush.h>
>   #include <linux/io.h>
>   #include <linux/mem_encrypt.h>
>   #include <linux/mm.h>
>   #include <linux/pgtable.h>
> +#include <linux/string.h>
>   
>   #include <asm/hypervisor.h>
>   
> @@ -61,6 +63,15 @@ static int pkvm_set_memory_encrypted(unsigned long addr, int numpages)
>   
>   static int pkvm_set_memory_decrypted(unsigned long addr, int numpages)
>   {
> +	size_t size = numpages * PAGE_SIZE;
> +
> +	/*
> +	 * The host can read the pages as soon as they are shared, possibly
> +	 * through a Non-cacheable mapping. No caller relies on their contents.
> +	 */
> +	memset((void *)addr, 0, size);
> +	dcache_clean_poc(addr, addr + size);
> +
>   	return __set_memory_range(ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID,
>   				  addr, numpages);
>   }
> 
> base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3

