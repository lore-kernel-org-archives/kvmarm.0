Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795528423;
	b=2zZtArPv4beVzIrogMiIslyNte+a7nPzxEll8xyaWHnPSeM4NcW72s9aAKdO7SUjycac
	 Kqx59FluGJroERsPi8QUFBhalMD0BvLdp/uB1/Gqaa+2Ennkbz0F76PHl9F7APMApdZ5/
	 RJTGlsn9jlx0oKZQdWwHZQ4NLiQmeGayZ0fTPPkohxcPoMQ8/HiUI8oWgXaZ+NzkMifQT
	 VhnGGSW4xFM+iH74umoI/JQZCYas5DVkT96hlGNlJbatdE0Jz3AjtZQJPYvVwx7+bBlzV
	 7wdKu3x4bUPIqnS0Eietuq+cn+afKHl9aP5xcDkeKKBvuAClDtVpSm4LOgK8ao99njQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795528423;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=MIkTVr4RcMW6zywCfrJZui4jF3ihGLOv2lESiFwO/2g=;
	b=vIbWaNfIDUEObKgHD65EU4m1Q9oUQaDg8RTxnFBsCBFc3+fvET0LREgkx2Y9SlfCn3Sw
	 wVT+G/xMWg3hFWanN9aVfIiRvYBLdnMP0kEM0mbdzuwY0RFIfj9Qq9ydm4v92uquzRxXF
	 dZKVcoPvWjqkj42fovu6BED90u6SjbNesbNPUIc7N5MGtNGsJEGK0bmyI6qs2UvZXgLF8
	 y7dqBfPDmn1Ho+KoAIFOv4iI2ijUlEKjrWcpGQVwxvvFCJt+dsjqhZ+nVWHn44Co5tk17
	 iTz4PD1RB89L6FBrG/F47Kv4ERdS1HVBnF463m/Vt8+uxGi8bsYza2Fme8x3unR6bhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=nndDHg3l;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED272606A322
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 13:53:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED272606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=nndDHg3l
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27C3E339;
	Tue, 24 Nov 2026 05:53:39 -0800 (PST)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AE6213F763;
	Tue, 24 Nov 2026 05:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795528422; bh=+APSVgCGhYAgoDVaz3XyVGIzx7Jm+ECnvgl+Mo3ccbw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nndDHg3lTtR63L3UJR/QPaZ1wafVNDpQBCCZ+cFzjl1lRrB7pNlrxCK3t2fyafFkt
	 0/1iW09TNYzVrXfe88pK0leeZh6RmvKXyxAbsp1/DFld5IZ7Cbf3CXC7/KuhEEPeqa
	 GHttcEwpGz7XbYz+SVSOE/BCApFxVLy7aaxqOCBs=
Date: Tue, 24 Nov 2026 13:53:27 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <fuad.tabba@linux.dev>, Dan Carpenter <dan@pereq.eu>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: nv: Upgrade sub-page TTL hint to maximum size
Message-ID: <abrygylfbe47jhkufe3hl5wpdawazeno554ovwijwvh43hzpab@uqxszjzp63jc>
References: <20261123182312.4842-1-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123182312.4842-1-maz@kernel.org>

On Mon, Nov 23, 2026 at 06:23:12PM +0000, Marc Zyngier wrote:
> Should a guest be slightly foolish and submit a S2 TLBI with a TTL hint
> that describe a base granule size smaller than the host's page size,
> we take the resulting size at face value and feed it to the S2 unmapping
> code. Which legitimately screams about something not being page-aligned.
> 
> The architecture allows us to drop the TLBI on the floor, as we don't
> support a S2 granule size smaller than the host's page size. But it turns
> out that doing so is proving pretty hard (we call compute_tlb_inval_range
> from a number of places, none of which is amenable to an early out).
> 
> Instead, detect the annoying case, and pretend that we don't have a TTL
> hint at all, leaving the size upgrade mechanism to take place and use
> the largest possible size for the guest's S2 granule size.
> 
> This will still allow nonsensical stuff to get through, such as a 4kB
> level 2 (aka 2MB) from a guest with a 64kB S2 base granule size running
> on a 16kB page size host, but that's not worse than doing nothing, and
> the host code won't get shouty.
> 
> Reported-by: Dan Carpenter <dan@pereq.eu>
> Link: https://lore.kernel.org/r/20261123-inval_range-v1-1-815e15797089@pereq.eu
> Fixes: d1de1576dc21 ("KVM: arm64: nv: Handle FEAT_TTL hinted TLB operations")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org

Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>

> ---
> 
> Notes:
>     Reposting this as a first class patch, as I'd like to plug that one
>     as early as possible (and Dan has plenty of other patches in flight...)
> 
>  arch/arm64/kvm/nested.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 78d5b18dbd2d6..36e4e83badf0a 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -714,6 +714,13 @@ unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val)
>  	 */
>  	max_size = __ttl_to_size(ttl);
>  
> +	/*
> +	 * IMPDEF behaviour: treat subpage TTL-annotated TLBI as the largest
> +	 * possible invalidation. Don't try this at home, kids!
> +	 */
> +	if (max_size < PAGE_SIZE)
> +		max_size = 0;
> +
>  	if (!max_size) {
>  		/* Compute the maximum extent of the invalidation */
>  		switch (vtcr_to_tg0_pgsize(kvm, mmu->tlb_vtcr)) {
> -- 
> 2.47.3
> 
