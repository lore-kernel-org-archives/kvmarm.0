Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D044C4F6C
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 15:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349549; cv=none; b=GndULvBTWhFujRfxpZKcwmgWsiNeyscM7WJ3B7TbHkK9kH55DvwSJftOHTeQ3kegPiIOleN1/0dk/U49ND9Jzxhija2tyRdEMidbxAQilV3lru7WkequrAifOIFsV/SThGdVYNNXgPjQ0s2Nl0XEFlVs2KC4J8wzXZep9utjkDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349549; c=relaxed/simple;
	bh=R05+Lt91G2/g2cAbUpujVOaCkpFF33VyxVL3k+3S3/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=W07Z5Z89LtQAbQU11ikOxxw1VHs/1pUa3p1QPotlycLa51tPiTWgaxcMAYuwAIYknWOCg0+AoZZWyK5GAAX10XDUpUdxbK70nB+Mz/GclPudtWC9lgiKrwYsNhqWX2b6pP8JvyqmXAsOjaQPbIzAVSPj19TNb0Kjd0pWC9nB3MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pb2ARhBI; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pb2ARhBI"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72FC71688;
	Fri, 25 Sep 2026 08:18:53 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7BBDB3F86F;
	Fri, 25 Sep 2026 08:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790349536; bh=R05+Lt91G2/g2cAbUpujVOaCkpFF33VyxVL3k+3S3/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pb2ARhBIlfYuBg0XWQkTB98LMAz0mPFbeQUgb1vnNrYxKSni7Bcti0k2tQkt7rIja
	 yn+/6uQMvEIh2GfIdqXMWBKIrkFOaPTTFiGWjF+CSSw4e/y25IwKS9AO5PELiXdivX
	 Oalhj19z8x7TWo7sXVdfEPWeswbw1f5nc5A3xN48=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 14/22] KVM: arm64: Grant write permission when DBM is set at S1
Date: Fri, 25 Sep 2026 16:18:53 +0100
Message-ID: <araQ3A24w6sqlO75@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260623184201.1518871-15-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org> <20260623184201.1518871-15-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 23, 2026 at 11:41:53AM -0700, Oliver Upton wrote:
> The DBM bit effectively behaves as a permission bit when using direct
> permissions, especially so in the context of accesses that do not update
> the dirty state (like AT).
> 
> Treat AP[1] == 0 for the purposes of computing permissions, relying on
> the walker to abort if it fails to set the dirty state where required.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/at.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index bfba31b270a9..faffb69c2eef 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -1077,11 +1077,23 @@ static void compute_s1_direct_permissions(struct kvm_vcpu *vcpu,
>  					  struct s1_walk_info *wi,
>  					  struct s1_walk_result *wr)
>  {
> +	u8 ap = FIELD_GET(PTE_USER | PTE_RDONLY, wr->desc);
>  	bool wxn;
>  
> +	/*
> +	 * Descriptors with the DBM bit set while hardware dirty state are
> +	 * considered writable, even though certain accesses (like AT instructions)
> +	 * don't actually update the dirty state.
> +	 *
> +	 * Assume that walk_s1() made the necessary descriptor updates for the
> +	 * access and just treat DBM as writable here.
> +	 */
> +	if (wi->hd && (wr->desc & PTE_DBM))
> +		ap &= ~BIT(1);

So for S1, mark the page writable if HD && DBM=1, which HAFDBS should do.

> +
>  	/* Non-hierarchical part of AArch64.S1DirectBasePermissions() */
>  	if (wi->regime != TR_EL2) {
> -		switch (FIELD_GET(PTE_USER | PTE_RDONLY, wr->desc)) {
> +		switch (ap) {
>  		case 0b00:
>  			wr->pr = wr->pw = true;
>  			wr->ur = wr->uw = false;
> @@ -1105,7 +1117,7 @@ static void compute_s1_direct_permissions(struct kvm_vcpu *vcpu,
>  	} else {
>  		wr->ur = wr->uw = wr->ux = false;
>  
> -		if (!(wr->desc & PTE_RDONLY)) {
> +		if (!(ap & BIT(1))) {
>  			wr->pr = wr->pw = true;
>  		} else {
>  			wr->pr = true;
> -- 
> 2.47.3
> 

The rest is just using 'ap' as a proxy for wr->desc.AP[], which mimics 
AArch64.S1DirectBasePermissions() as it should be.

So, FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
