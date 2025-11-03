Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3BFE30DD1D
	for <kvmarm@lists.linux.dev>; Mon,  3 Nov 2025 17:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762191094; cv=none; b=n7WRhWYtRJiItazLVSeuYy5YmPanQG/k9FMYNBikHJfTmOKhZ7VWrq2rgCIpC5IpjDN4LwxXNV/DdRcjhhNrBte5MwjJjyE/spHE0kiapAF5cC5Q9cFhQI+uSPAHDO/sqn2BnXbBBnCctKgmSfCgstw7wJfgrak8avzGH58QTtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762191094; c=relaxed/simple;
	bh=snbr6jeY4aTnfrQZNiSlIdghCSfdLNRYZRmysRxKnL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KCSPLJzp0pTvqyUFeSFl0bzgYfkvKJbaOFHBZe9+XnO0tWQCu7jW9eplEWWhqY67Z3KYxHJOVWfIlVhzmCY0DZZuaKSgHL7aPLJ4fRIxZPdIm3sTnP3FnrSRXVgU/1eIaTOjF5fqTljMCfaalvGQod24DudXBNXL8nH3hApIkR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 237A61D14;
	Mon,  3 Nov 2025 09:31:24 -0800 (PST)
Received: from arm.com (unknown [10.1.25.188])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2244C3F66E;
	Mon,  3 Nov 2025 09:31:30 -0800 (PST)
Date: Mon, 3 Nov 2025 17:31:27 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>, Leo Yan <leo.yan@arm.com>
Subject: Re: [PATCH V6 1/3] tools: header: arm64: Replace TCR_NFD[0|1] with
 TCR_EL1_NFD[0|1]
Message-ID: <aQjm7wmvHa79hkyi@arm.com>
References: <20251013052945.2197190-1-anshuman.khandual@arm.com>
 <20251013052945.2197190-2-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013052945.2197190-2-anshuman.khandual@arm.com>

On Mon, Oct 13, 2025 at 10:59:43AM +0530, Anshuman Khandual wrote:
> Replace TCR_NFD[0|1] (used in TCR_CLEAR_FUJITSU_ERRATUM_010001) with field
> definitions which are available in tool sysreg format. Helps in completely
> dropping off the adhoc TCR_NFD[0|1] macros later.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Leo Yan <leo.yan@arm.com>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  tools/arch/arm64/include/asm/cputype.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/arch/arm64/include/asm/cputype.h b/tools/arch/arm64/include/asm/cputype.h
> index 139d5e87dc95..dfa12df5e290 100644
> --- a/tools/arch/arm64/include/asm/cputype.h
> +++ b/tools/arch/arm64/include/asm/cputype.h
> @@ -243,7 +243,7 @@
>  /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
>  #define MIDR_FUJITSU_ERRATUM_010001		MIDR_FUJITSU_A64FX
>  #define MIDR_FUJITSU_ERRATUM_010001_MASK	(~MIDR_CPU_VAR_REV(1, 0))
> -#define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_NFD1 | TCR_NFD0)
> +#define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_EL1_NFD1 | TCR_EL1_NFD0)

Isn't this file usually updated automatically (well, someone running a
script to sync) from the corresponding arch/arm64/ one?

-- 
Catalin
