Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560F63112B4;
	Fri, 15 Aug 2025 17:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755277350; cv=none; b=Ys/hC+kGNd4oc8QXJHwaux1mpZlLWm5u7WypoL21n9yzbZg785deJ3XmvHLIUM5ymS/KRyf/WBMJYFeGnF3qLPsXL9mUeR8e1l/0nr3plxNU2qp3Ik4dUDuVTdcc3eHKknDorknMs89qZGkxA3axGZbWJuHisnXQZiKb/Elstvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755277350; c=relaxed/simple;
	bh=qzEdvMBezwE5JXpLjbnfIkvJ2/iVeikA41lC7b4Vlw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qwgR4LOW6k5ENFunkw82XGzrOY2WG0fQ+oc98H2bVpKyHLixeFtIpKMjEwZWyKXk8tLF5f6+RjwOSrsBHgAn5ndCXAcBv6yqPLrsV/o2cEug92cxHhPF9WCPWLrra4HbtWIeUuQah3V170vnKiQQYOfr0KrOenmYo6qlHlivZog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0F6C4CEEB;
	Fri, 15 Aug 2025 17:02:27 +0000 (UTC)
Date: Fri, 15 Aug 2025 18:02:25 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com,
	joey.gouly@arm.com, james.morse@arm.com, ardb@kernel.org,
	scott@os.amperecomputing.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 5/5] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aJ9oIes7LLF3Nsp1@arm.com>
References: <20250811163635.1562145-1-yeoreum.yun@arm.com>
 <20250811163635.1562145-6-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811163635.1562145-6-yeoreum.yun@arm.com>

On Mon, Aug 11, 2025 at 05:36:35PM +0100, Yeoreum Yun wrote:
> +#ifdef CONFIG_AS_HAS_LSUI
> +
> +#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> +
> +#define LSUI_FUTEX_ATOMIC_OP(op, asm_op, mb)				\
> +static __always_inline int						\
> +__lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> +{									\
> +	int ret = 0;							\
> +	int val;							\
> +									\
> +	mte_enable_tco();						\

The reason uaccess_disable_privileged() sets the MTE TCO (tag check
override) is because the user and the kernel may have different settings
for tag checking. If we use the user instructions provided by FEAT_LSUI,
we leave the MTE checking as is.

The same comment for all the other functions here.

-- 
Catalin
