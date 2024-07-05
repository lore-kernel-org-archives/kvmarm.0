Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7096413665A;
	Fri,  5 Jul 2024 11:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720177675; cv=none; b=osySNTGG4v9w1GVy3sWKulDBix5T4lsbnysBWtsGwVQ3gdcXOL50Up0/DDZZtRRFW9GvbO9utPMJPdYZkupnOQc35tAkSnGol0IWjKbjVSFxBJ3VdpSra9b3++cXrqBJ/cBaMXwXdS+W6U5C+gbZ8MwlGEh6nNQaNCBEVJU+otQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720177675; c=relaxed/simple;
	bh=sBt65f4Hf0k3TzKERrmMvOBm6cmevdehMYOf8Ymnjj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hL+7su8eaD0EaItj3ZYzpUig6/KU6dbeITo+j/3WtaD/ZmtQmMzvS38aHZvCd4k/c+KO81UvBYrN8iXhpY+3nRsyQlg7oz5vlbFlchQMYcAfxflRNSQgU/2AH8/XYhHzPmkiapnKI6GvlcvbJPyjiXXq8sVJYIcJ9oQSyySGai4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uhbsqzDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uhbsqzDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B950C116B1;
	Fri,  5 Jul 2024 11:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720177675;
	bh=sBt65f4Hf0k3TzKERrmMvOBm6cmevdehMYOf8Ymnjj8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uhbsqzDgem2RIW9aYbV1FncW+hT3pY4I9ae35c5JZ8rqQvthK6ponowFvhIEjT6j2
	 W0hPPpxVvi6UIAsjzdaVI66+EFUMkd5XTAYXYOgnzuGy3pMq7lWzcayyVqtrpsbByO
	 vdbPwRlgCs40xVds7OAdapU+D3VqMu4/SUPmF0Xjb0q2cuPi8NFbon6AcFDv96UZRq
	 l2nv5TSU/uHXjKaq4+PAAfGIxVSJNWSbWAkwN2fbpJyznvtnVtynU6jgFhouiUy+hg
	 9dk0BSSazPD1a4TKh5WVZrHYBWz5fBW8jgZ/TeYUAw5VkPdOhnnezu5MYcOuB1jfXv
	 sP/sTzwauNKew==
Date: Fri, 5 Jul 2024 12:07:48 +0100
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
Subject: Re: [PATCH v7 2/6] arm64: ptdump: Expose the attribute parsing
 functionality
Message-ID: <20240705110747.GA9231@willie-the-truck>
References: <20240621123230.1085265-1-sebastianene@google.com>
 <20240621123230.1085265-3-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621123230.1085265-3-sebastianene@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Jun 21, 2024 at 12:32:26PM +0000, Sebastian Ene wrote:
> Reuse the descriptor parsing functionality to keep the same output format
> as the original ptdump code. In order for this to happen, move the state
> tracking objects into a common header.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/include/asm/ptdump.h | 41 ++++++++++++++++++++++++++++++++-
>  arch/arm64/mm/ptdump.c          | 37 ++---------------------------
>  2 files changed, 42 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
> index 5b1701c76d1c..c550b2afcab7 100644
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
> +struct prot_bits {
> +	u64		mask;
> +	u64		val;
> +	const char	*set;
> +	const char	*clear;
> +};
> +
> +struct pg_level {
> +	const struct prot_bits *bits;
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
> +struct pg_state {
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

Minor nit, but if we're moving these structure definitions into the
header then I'd be inclined to give them some more specific names (e.g.
prefix them with 'ptdump_'). Granted, this header isn't used widely, but
it's included by arch/arm64/mm/mmu.c and claiming 'struct prot_bits' is
a bit over-reaching imo!

Will
