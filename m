Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74CF1233730
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 12:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740399612; cv=none; b=rJhcCfA/gSVmZcb6ASSRR0JGnh/c4gp2UI//eCxj2Z1KPuaH6R2r+LsGrFbDR2HBmZNYAxvXqFBuD5+6lymA34oAIyy9wM6iWODRIlQhAibrz36N5ekSe4qpsEMifc2Gsw7pV7W4bTKZ4blPhf3Lsz3zyblcs7oh75o5H1mTe1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740399612; c=relaxed/simple;
	bh=5BAuLMhC6Rqt1wdGAns8uutdl/iqePryxlBpJEjYAtQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=khJPvbhkw7ilm3eWtZubCQrQep2rcdV1VIpD6SwdAwrz27snFhLaaGU7ndyRsZGq1Q1M1jwz5XoQu4BHTmLF5Wa5P9/RPZXyeiDjgf8eZGOzSEH4PnaytnCXoKYRQafDYSLS8sPyKCVqbG3RXAZWgmkxhSSJLmt70WG3KTmqGK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4Z1fY56pPJz9sSK;
	Mon, 24 Feb 2025 13:04:25 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jmjW4wRXcRyZ; Mon, 24 Feb 2025 13:04:25 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4Z1fY55w83z9sSC;
	Mon, 24 Feb 2025 13:04:25 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id B37438B765;
	Mon, 24 Feb 2025 13:04:25 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id lGRMugV4dhlW; Mon, 24 Feb 2025 13:04:25 +0100 (CET)
Received: from [10.25.207.138] (unknown [10.25.207.138])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 7A6868B763;
	Mon, 24 Feb 2025 13:04:25 +0100 (CET)
Message-ID: <93e96586-13a2-4800-9dc7-5b35177a328e@csgroup.eu>
Date: Mon, 24 Feb 2025 13:04:25 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/5] arch/powerpc: Drop GENERIC_PTDUMP from
 mpc885_ads_defconfig
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: steven.price@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>
References: <20250217042220.32920-1-anshuman.khandual@arm.com>
 <20250217042220.32920-3-anshuman.khandual@arm.com>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <20250217042220.32920-3-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 17/02/2025 à 05:22, Anshuman Khandual a écrit :
> GENERIC_PTDUMP gets selected on powerpc explicitly and hence can be dropped
> off from mpc885_ads_defconfig.
> 
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> Just wondering - Should CONFIG_PTDUMP_DEBUGFS be added instead ?

Yes please do that as a fix to commit e084728393a5 ("powerpc/ptdump: 
Convert powerpc to GENERIC_PTDUMP")

> 
>   arch/powerpc/configs/mpc885_ads_defconfig | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/arch/powerpc/configs/mpc885_ads_defconfig b/arch/powerpc/configs/mpc885_ads_defconfig
> index 77306be62e9e..ea6f836407d2 100644
> --- a/arch/powerpc/configs/mpc885_ads_defconfig
> +++ b/arch/powerpc/configs/mpc885_ads_defconfig
> @@ -78,4 +78,3 @@ CONFIG_DEBUG_VM_PGTABLE=y
>   CONFIG_DETECT_HUNG_TASK=y
>   CONFIG_BDI_SWITCH=y
>   CONFIG_PPC_EARLY_DEBUG=y
> -CONFIG_GENERIC_PTDUMP=y

