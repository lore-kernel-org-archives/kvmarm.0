Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44305379EE0;
	Tue, 15 Sep 2026 22:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789512558; cv=none; b=iFhmTMnsDFyen+ictpvXFpR+JNBqlMnYNeE73UUsSN+nTWioBtk2waPfAk+Bs/mtGD7KRH1ys6/d+AZK/mt5E37Okof+kKPJLigt7ph3Ok92cMZwnmOe4zqGZ4XB0uO81QfVEu0w5Jl2iE8mDP2t1qMrjcSSc1IZRP1EiVxYgWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789512558; c=relaxed/simple;
	bh=I6hnICVO3eviiYVtsdEcR+XTrIwdAQhCm+cOfFPVG1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q5A4TXvMYK/iRxNMOLp7xuqZAWR6jAS4srey9+77XLMywoJ+yVDKbX5JmUq56UhO3gPhsq3mFY6nWGql/Pnu+rclAlh2PPqFZka06Mv+dNuSl2/RQNWszB8ab2vuTclUQk986LDqvXS/n1bfKXOiRqa6NcaPty2ixgg/auNUBvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FpiSvfNs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FpiSvfNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DC31F000FF;
	Tue, 15 Sep 2026 22:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789512556;
	bh=kZzsGaXPUVqWdbiJlm0sqmPG8X19xHFYaAJPDTPlT8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FpiSvfNsjtOquI9DAMwpgwxVSzGM0L4KGw3+pi75m44IuyDlheeQQIl1+YMvU9oFQ
	 AbAdF1z1neMsu20+Cn89GlfetfTJNG6KskbLbYv6g9hFfElcfrjntm+dBC0GUSbbTj
	 JG6H4DK7Hfom1M7NsWMP8Prhjk2OdKvC39flf+OkUHVpSTKq7djpYOapPadN5IIAcx
	 RGR5l84P/9GoEiQsdexAwg7wccAeY8+B1QPAP3lmms1vMOb4SV7xboNBz1kb9fkGFH
	 e4FBNL/+nhZsr6j4HOfJeYxLWTAEQownhFAJAx5t6pd5ZuWyVsA8PX7hx21cv9sZlA
	 UyV9uuhTWBXNg==
Date: Tue, 15 Sep 2026 15:49:15 -0700
From: Oliver Upton <oupton@kernel.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wang Han <wanghan@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH v6 0/7] KVM: arm64: nv: Implement nested stage-2 reverse
 map
Message-ID: <aqnLa0_QSGlIs2qn@kernel.org>
References: <20260915154305.3852871-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915154305.3852871-1-weilin.chang@arm.com>

On Tue, Sep 15, 2026 at 04:42:58PM +0100, Wei-Lin Chang wrote:
> Hi,
> 
> This is v6 of optimizing the shadow s2 mmu unmapping during MMU
> notifiers.
> 
> This version fixes a few issues, and adds Marc's space optimization
> for kvm_guest_s2_mapping [1]. Please see the changelog for the details.
> 
> Tested by booting L3, and running in-kernel targetted tests described
> in [2]. v5 got some tested-by's from Itaru and Wang (thanks), I didn't
> carry them over since some bugs fixed in v6 are non-obvious. Some
> retest would be much appreciated!
> 
> Series based on v7.3-rc3 + Marc's nested mmu lifecycle fixes [3].

Looking pretty good to me, thanks Wei-Lin!

Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver
