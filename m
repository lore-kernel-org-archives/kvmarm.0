Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE033EFD24;
	Mon, 10 Aug 2026 15:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786374343; cv=none; b=Nh2TuYJHxBQnrIPEfP/X+OlKTAINwuzky52L1CRq68kJ3IqwS6E2qwM1yk7AfOUKfOKLYmInEQfDfhNAA+5dkUBE+AgMci65Acdrb+mNOPnolNs6fo3Un5EAZ74V6EsAnmg9HcIwOBFHnl8WKC3ukiGeHn01teI0OqUhupn5Kww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786374343; c=relaxed/simple;
	bh=9hocbGktqstTMjPnIEb61JAFPnzqOpAsoX7EfvB6d88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ati98uIfwsy/nzrTElhP/MhqlRHFUhDsDFJzMGiUZGhgp7GLi4apwQV28LL6rJuk/FRGOufL8o1+fO2hdxUGSJKWghprUWWlx0GR5ysQBKYh/OHRW1g02coIY8xw/LBP9Ere5mihp9nGFO4/tnRhVSxwiRFITFOD1BWYBCLV9EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=RANKzl0r; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="RANKzl0r"
Received: from francesco-nb (93-35-5-212.ip52.fastwebnet.it [93.35.5.212])
	by mail11.truemail.it (Postfix) with ESMTPA id 75AAD1F83F;
	Mon, 10 Aug 2026 16:51:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1786373515;
	bh=8xOWdWttJ5lEYJAi21opwk9aDpKJg8EeQXY1WVzHESc=; h=From:To:Subject;
	b=RANKzl0rwIbXN++I6LA8Rlhna7AgTZYi8AbfcmaILTUXvORdWCRcBx64ECxagA2MJ
	 BspMT1vAvOBmCSw9kdnSnrJaEueE+vt1by7Gf1gGafC4T1t6wa25e/eoHBZzLynsDJ
	 yxBALaK8zAkLmDzyi47NQZ3/I7RSGTz9FH1ILF+uxfsaR39QgUp4Ia9XEYi+RGPtA1
	 a7B+okTo48bYkaP4jR4Y8etBFO4y3M2uAWqcoY5uTTiUwGclz34pcaj496Uy04uXMq
	 IRZu4UHuTQOkdRZ4MNVsjBefRn9kVgLio9jjwQ5q/Q6ZlIA3d0KqpZBSwKxBUobFUB
	 LUDheqXSoUyvg==
Date: Mon, 10 Aug 2026 16:51:49 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	Francesco Dolcini <francesco@dolcini.it>,
	Frank Li <frank.li@nxp.com>, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, imx@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>, Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH v3] arm64: errata: Add NXP iMX8QM workaround for A53
 cache coherency issue
Message-ID: <20260810145149.GA81453@francesco-nb>
References: <20260803-imx8qm-cache-coherency-v3-1-c518d0da3d3b@nxp.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803-imx8qm-cache-coherency-v3-1-c518d0da3d3b@nxp.com>

Hello Peng,
thanks for the patch, very much appreciated.

On Mon, Aug 03, 2026 at 04:54:44PM +0800, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> According to NXP errata document IMX8_1N94W[1], the i.MX8QuadMax SoC
> suffers from a cache coherency issue (ERR050104). The upper bits, above
> bit 35, of the ARADDR and ACADDR buses within the Arm A53 subsystem
> have been incorrectly connected. This causes some TLBI and IC
> maintenance operations exchanged between the A53 and A72 core clusters
> to be corrupted.

...

> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index 5db8f0619e4b..4ba68c1f29b2 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -200,6 +202,28 @@ cpu_enable_cache_maint_trap(const struct arm64_cpu_capabilities *__unused)
>  	sysreg_clear_set(sctlr_el1, SCTLR_EL1_UCI, 0);
>  }
>  
> +#ifdef CONFIG_NXP_IMX8QM_ERRATUM_ERR050104
> +static bool
> +is_imx8qm_soc(const struct arm64_cpu_capabilities *entry, int scope)
> +{
> +	WARN_ON(preemptible());
> +
> +	return of_machine_is_compatible("fsl,imx8qm");

fsl,imx8qp is also affected, please adjust


Francesco

