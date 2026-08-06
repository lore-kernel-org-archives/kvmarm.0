Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24433859E9;
	Thu,  6 Aug 2026 04:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785991392; cv=none; b=U4oWK6XhgCHAgUNIjfRbOn3AIayfhAq5aEyIZ2raXq4IaF+IQ2FBHHQfr0vQLghm29jFSIYBDPHqK9IkiUpKxY90ANRqLLqedVuc5Lcbv65Ij8x1dDXxDIOmT09TaCJRTq798I6rmnkno4Q9iuMXFCKa3puiKFkEC0eTo5f6ZMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785991392; c=relaxed/simple;
	bh=rad9tPjK5xL8zCcJUV+tMq9GGs3okrFDeFJl0dJp0iw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S0QH2+Xwfj1VDBHw5QSjYPYUOVre+k/rB4o/PjI2rDAqEA7WUfb65RJ/52ccOgdnK5T/L5Ya7ONjhLEIAlNDBVb9FOC9bZobS2pj8d9efjTTr1fYrsl2xbGOQzBglUBYDRGo4CI17eI8iIshp0ZVyNjAg9PnUEhuey1FJsdbQuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C8WZ96F5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C8WZ96F5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297D71F00A3A;
	Thu,  6 Aug 2026 04:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785991391;
	bh=4SVxBCorFWnwDAuAecXmW1rPgG8B8npbUR3574wL1DE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C8WZ96F5i/eogrhOVIrrB+nQUrCTef7IwXFM+DwBzsVBrp60Syip/QwKNOlf2Bsuc
	 KDKfq+OmfJQs8ps7Is1NxOtxu57OVphU0FVT3JGqUNomcrF9opEwTr+7isWZwyhmE3
	 ckIXShRJLj5DKD3S/en55L4sjLJ55/bcvQusw9HLe+HQoqZ0m9MdFNJd64uLXz3tlt
	 0+f7CIXkeD82WO/0uBwduwoVB5YAGvKszlmdE53BEfYbodUEXxJbpLuYKNcyHYHInF
	 k+ELTE6bOam1d0Loz5RP/BOvSRwroZGXyN8dDJFJ3ohG8ApMixA2ebMn6z80WZQ18+
	 T8RazoXxNRouQ==
Date: Wed, 5 Aug 2026 21:43:09 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: arm64: vgic-its: Don't dereference a NULL
 collection on ITT save
Message-ID: <anQQ3dcbk72N1g1a@kernel.org>
References: <20260805093828.3626610-1-fuad.tabba@linux.dev>
 <20260805093828.3626610-2-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805093828.3626610-2-fuad.tabba@linux.dev>

Hi Fuad,

Thanks for fixing this.

On Wed, Aug 05, 2026 at 10:38:26AM +0100, Fuad Tabba wrote:
> @@ -2119,6 +2119,14 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
>  	u32 next_offset;
>  	u64 val;
>  
> +	/*
> +	 * MAPC with V=0 keeps the ITEs mapped but drops their collection,
> +	 * and with it the ICID. Save a zeroed entry, which the restore path
> +	 * reads back as invalid.
> +	 */
> +	if (!ite->collection)
> +		return vgic_its_write_entry_lock(its, gpa, 0ULL, ite);
> +

Writing a zero entry results in a suboptimal scan on the target,
compute_next_eventid_offset() should just skip ITEs that are known
invalid. Or better yet, we should just make the ITS emulation consistent
with the migration behavior and delete ITEs when their corresponding
collection is deleted. As you note, this is UNPRED after all :)

Thanks,
Oliver
