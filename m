Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BAE14D431;
	Tue, 10 Sep 2024 09:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962246; cv=none; b=ocUNv3kw3WSEsalvSMFhl+7XBsv+pRq0DxG6G6q6zAHAT6trrAE/JlQC1zLoTAlJ3ukUEMCqtecc8yRkfy5s3SGt7Rhb6des08DNIC15dzTuRXMKdfEefWPVNi6yf7JcqtqssMCo1+BwhMAtoB66Z8S9tN7u7vIfw34HVGQfoM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962246; c=relaxed/simple;
	bh=/uYJCno5GCPMxaVDq+V1GmZ4Wfep91o4OGTMPJMCNn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K6c2+/bqJfKtM5sZnOc1Ef8CgcablIJaKTiKz6Ly1tHGR7rlyCW8LzVZClw9kKHgzOWdYml7mqFeNAkz2RBaFTbmnWdwXq6WnTCtct0WdGVt4Jo+RvYMpgjicCDHZylHjRJZ+xiIidb3ecWobszpgjEu23j0wUbYMvvyeFGSQnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZoF37BDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZoF37BDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA6EC4CEC3;
	Tue, 10 Sep 2024 09:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725962245;
	bh=/uYJCno5GCPMxaVDq+V1GmZ4Wfep91o4OGTMPJMCNn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZoF37BDNzQ1PsB5Du4gHWsC9KkLecyxnxdXyAsith81gwqWSldgkYVP1W5RlLLPVS
	 EYkcgglhgw1Z375zWGCwJUfLfiPnNUY9XpXhoaXpBjvuCxV+Qs8qGffgQGTemTxeEz
	 LVBnwHO1XQH5YKc2ai/NI+nAeQDaoGPXtg6oR9gzgCoucx2F7AAPh2/EHkcWvmpVMc
	 VTrfTIMMMUD0x2fwG56t1JgQckBFYWcZHAPWw6loORtePusr0Dvv5mPoKq4oImeoFi
	 sAYacWVutcP3w9bdxofeN7BIZq55QWIhmAL/sFcr7NDpXojDbxZ9c1mQSlFppD/xUE
	 WhQT/ayYPY+rA==
Date: Tue, 10 Sep 2024 10:57:18 +0100
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com,
	ardb@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, james.morse@arm.com,
	vdonnefort@google.com, mark.rutland@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, rananta@google.com, ryan.roberts@arm.com,
	shahuang@redhat.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v10 2/5] arm64: ptdump: Expose the attribute parsing
 functionality
Message-ID: <20240910095718.GB20813@willie-the-truck>
References: <20240909124721.1672199-1-sebastianene@google.com>
 <20240909124721.1672199-3-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909124721.1672199-3-sebastianene@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Sep 09, 2024 at 12:47:18PM +0000, Sebastian Ene wrote:
> Reuse the descriptor parsing functionality to keep the same output format
> as the original ptdump code. In order for this to happen, move the state
> tracking objects into a common header.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/include/asm/ptdump.h | 41 +++++++++++++++++++++++-
>  arch/arm64/mm/ptdump.c          | 55 +++++++--------------------------
>  2 files changed, 51 insertions(+), 45 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
> index 5b1701c76d1c..bd5d3ee3e8dc 100644
> --- a/arch/arm64/include/asm/ptdump.h
> +++ b/arch/arm64/include/asm/ptdump.h
> @@ -9,6 +9,7 @@
>  
>  #include <linux/mm_types.h>
>  #include <linux/seq_file.h>
> +#include <linux/ptdump.h>
>  
>  struct addr_marker {
>  	unsigned long start_address;
> @@ -21,14 +22,52 @@ struct ptdump_info {
>  	unsigned long			base_addr;
>  };
>  
> +struct ptdump_prot_bits {
> +	u64		mask;
> +	u64		val;
> +	const char	*set;
> +	const char	*clear;
> +};
> +
> +struct ptdump_pg_level {
> +	const struct ptdump_prot_bits *bits;
> +	char name[4];
> +	int num;
> +	u64 mask;
> +};
> +
> +/*
> + * The page dumper groups page table entries of the same type into a single
> + * description. It uses pg_state to track the range information while
> + * iterating over the pte entries. When the continuity is broken it then
> + * dumps out a description of the range.
> + */
> +struct ptdump_pg_state {
> +	struct ptdump_state ptdump;
> +	struct seq_file *seq;
> +	const struct addr_marker *marker;
> +	const struct mm_struct *mm;
> +	unsigned long start_address;
> +	int level;
> +	u64 current_prot;
> +	bool check_wx;
> +	unsigned long wx_pages;
> +	unsigned long uxn_pages;
> +};
> +
>  void ptdump_walk(struct seq_file *s, struct ptdump_info *info);
> +void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
> +	       u64 val);
>  #ifdef CONFIG_PTDUMP_DEBUGFS
>  #define EFI_RUNTIME_MAP_END	DEFAULT_MAP_WINDOW_64
>  void __init ptdump_debugfs_register(struct ptdump_info *info, const char *name);
>  #else
>  static inline void ptdump_debugfs_register(struct ptdump_info *info,
>  					   const char *name) { }
> -#endif
> +#endif /* CONFIG_PTDUMP_DEBUGFS */
> +#else
> +static inline void note_page(void *pt_st, unsigned long addr,
> +			     int level, u64 val) { }

nit: but why isn't 'pt_st' a pointer to 'struct ptdump_state'?

Perhaps you should #include <linux/ptdump.h> before the #ifdef
CONFIG_PTDUMP_CORE ?

In any case, the meat of the patch is fine:

Acked-by: Will Deacon <will@kernel.org>

Will
