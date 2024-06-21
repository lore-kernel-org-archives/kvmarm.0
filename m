Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A9D3EA66;
	Fri, 21 Jun 2024 17:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718990160; cv=none; b=lMJ0xtWDyekMk1H/XNFHVda/yrrAMdpSKKLgvGKq2gks8JsH1rbgOQ5Nv2amvI00Xl07+bYm+PZ9euMpZWi7ZUDu6KNnOkgeJ3KodzPl3rSQswNQWSsTdH1QHtr+XSBJWae+IOgOcRL5hCO00zzAeSNqip4vpT9MRvtRPy6R5L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718990160; c=relaxed/simple;
	bh=pBfUXzmpeYWnnxlVdF2pvrod1hAudHmhO1lCmGe2tSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ByXfMK9V0W/I2pmdOPvt+ldwPquDZl7sMM2OGjmVWraa2YJMVc2k309VdBV1MzfUwjd9c3eOAtb7/BJiAYuJXqKeQLMYMLhj2nMWsEw/5tlfUoj6mopZgKTxiBQHfCkmCUGRi4CN+Y2RZNxKAF+4BTZfWm5ZnsPGfJ1hFp8Hxf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3ADC2BBFC;
	Fri, 21 Jun 2024 17:15:55 +0000 (UTC)
Date: Fri, 21 Jun 2024 18:15:53 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
	aneesh.kumar@kernel.org, aneesh.kumar@linux.ibm.com, bp@alien8.de,
	broonie@kernel.org, christophe.leroy@csgroup.eu,
	dave.hansen@linux.intel.com, hpa@zytor.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, maz@kernel.org, mingo@redhat.com,
	mpe@ellerman.id.au, naveen.n.rao@linux.ibm.com, npiggin@gmail.com,
	oliver.upton@linux.dev, shuah@kernel.org, szabolcs.nagy@arm.com,
	tglx@linutronix.de, will@kernel.org, x86@kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 16/29] arm64: add pte_access_permitted_no_overlay()
Message-ID: <ZnW1SWwXzhBY9Goc@arm.com>
References: <20240503130147.1154804-1-joey.gouly@arm.com>
 <20240503130147.1154804-17-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503130147.1154804-17-joey.gouly@arm.com>

On Fri, May 03, 2024 at 02:01:34PM +0100, Joey Gouly wrote:
> We do not want take POE into account when clearing the MTE tags.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
