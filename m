Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9D062185B8
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 12:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740574215; cv=none; b=HaOzgttS8ikkCiq0OCbyaCt00PFd3gL9op7+zPCKy/RAc+l26FkQmzjdobilEp30nh1rIEdVKO9RH2hPXSZ1j4PHVBtWvTVqLPGzEmFvVgs5txMYD/jEpPbAfSGKayeu0XnsuGxdEce6WkDli4QpWfOVYdbj89q18QcjGzKPFaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740574215; c=relaxed/simple;
	bh=fN3Sb53xeNCJ9LjtIsyWpWduSaQsGJv6Bs/u5lAlxME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BNbasvypMrpNw5ipAT1FCcfF6bAwy1CrlRThQSS3duOgbVH1aZqOphWqb0m4fy0/9xBEuzK1vru8wndA9ZfOP+54tRTvE4gCEf7KuMo/lbrRuv7ud4rKTbqUriBt7V4aXAUWUwvym+utckrXC2Zj5S53Ue+NbEgisjOq/bN3zac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4Z2v3D0g7Fz9sSK;
	Wed, 26 Feb 2025 13:31:20 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zdl6tAtT0ddh; Wed, 26 Feb 2025 13:31:19 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4Z2v3C6tl5z9sSH;
	Wed, 26 Feb 2025 13:31:19 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id D853B8B78B;
	Wed, 26 Feb 2025 13:31:19 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id lyR8MYIwt_Lw; Wed, 26 Feb 2025 13:31:19 +0100 (CET)
Received: from [10.25.207.138] (unknown [10.25.207.138])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 96D918B77C;
	Wed, 26 Feb 2025 13:31:19 +0100 (CET)
Message-ID: <50339b41-9b4d-4315-a69b-ee32fc86baa6@csgroup.eu>
Date: Wed, 26 Feb 2025 13:31:19 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/5] arch/powerpc: Drop GENERIC_PTDUMP from
 mpc885_ads_defconfig
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>
References: <20250226122404.1927473-1-anshuman.khandual@arm.com>
 <20250226122404.1927473-3-anshuman.khandual@arm.com>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <20250226122404.1927473-3-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 26/02/2025 à 13:24, Anshuman Khandual a écrit :
> GENERIC_PTDUMP gets selected on powerpc explicitly and hence can be dropped
> off from mpc885_ads_defconfig. Replace with CONFIG_PTDUMP_DEBUGFS instead.
> 
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Fixes: e084728393a5 ("powerpc/ptdump: Convert powerpc to GENERIC_PTDUMP")
> Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>

> ---
>   arch/powerpc/configs/mpc885_ads_defconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/configs/mpc885_ads_defconfig b/arch/powerpc/configs/mpc885_ads_defconfig
> index 77306be62e9e..129355f87f80 100644
> --- a/arch/powerpc/configs/mpc885_ads_defconfig
> +++ b/arch/powerpc/configs/mpc885_ads_defconfig
> @@ -78,4 +78,4 @@ CONFIG_DEBUG_VM_PGTABLE=y
>   CONFIG_DETECT_HUNG_TASK=y
>   CONFIG_BDI_SWITCH=y
>   CONFIG_PPC_EARLY_DEBUG=y
> -CONFIG_GENERIC_PTDUMP=y
> +CONFIG_PTDUMP_DEBUGFS=y

