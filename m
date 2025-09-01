Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5AF4409;
	Mon,  1 Sep 2025 20:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756757058; cv=none; b=q6HvbExOvlpevOGRzCkq6quLo4IbOt6lF+BqhOVbi5U8Nq4QFHDDODOcAa26FShHvR2ZrXiG5W36onKqRI68YARbbypi1xIMSpaob8Ab0dnniYzmF8v60PyaEutOekK3cOPMkwfNG8VlCqeCdvp8tWqLM/RUt5emiU1sLxzcNoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756757058; c=relaxed/simple;
	bh=JjMEb+rcANH9IoHEvd4So3cfv4dWZoqGvcHUiSWe6I0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K1emz+rAdZmPfQDibOCDhFFnkAIb01Ziqrla73WeqAa+yDo09E+ctkvzUH/pEgoFlWnNdkR8WcA5v4eul1tqGO3+pMyaSzMEgGl3mibaaNfLFOJlTsdrnYeFVBD3ZO+1q2mnOHN5frEEPlSHaPV8k4bNat+FGVm0rVYCQgUPhEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=syStq+NA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="syStq+NA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CD8C4CEF0;
	Mon,  1 Sep 2025 20:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756757057;
	bh=JjMEb+rcANH9IoHEvd4So3cfv4dWZoqGvcHUiSWe6I0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=syStq+NA4tCIhKOKN571VBlVzKRxvHgdQBE+1pOx0lmdTsOUKrAWuwywf1USnJc39
	 9QJn68tkB1yKiTYF4Py2dCAl910835pbge0/6i4xvRGyw9iJPCpLdWzRzqMxgDe4wA
	 zmRsDbEXUN0ppWiNoBgzecrmeY9sCODevGXmxruw=
Date: Mon, 1 Sep 2025 22:04:14 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Gyujeong Jin <wlsrbwjd7232@gmail.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, gyutrange <wlsrbwjd643@naver.com>,
	stable@vger.kernel.org, DongHa Lee <gap-dev@example.com>,
	Daehyeon Ko <4ncient@example.com>, Geonha Lee <leegn4a@example.com>,
	Hyungyu Oh <dqpc_lover@example.com>,
	Jaewon Yang <r4mbb1@example.com>
Subject: Re: [PATCH] KVM: arm64: nested: Fix VA sign extension in VNCR/TLBI
 paths
Message-ID: <2025090158-kilt-fabulous-3e76@gregkh>
References: <20250901141551.57981-1-wlsrbwjd7232@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901141551.57981-1-wlsrbwjd7232@gmail.com>

On Mon, Sep 01, 2025 at 11:15:51PM +0900, Gyujeong Jin wrote:
> From: gyutrange <wlsrbwjd643@naver.com>
> 
> VNCR/TLBI VA reconstruction currently uses bit 48 as the sign bit,
> but for 48-bit virtual addresses the correct sign bit is bit 47.
> Using 48 can mis-canonicalize addresses in the negative half and may
> cause missed invalidations.
> 
> Although VNCR_EL2 encodes other architectural fields (RESS, BADDR;
> see Arm ARM D24.2.206), sign_extend64() interprets its second argument
> as the index of the sign bit. Passing 48 prevents propagation of the
> canonical sign bit for 48-bit VAs.
> 
> Impact:
> - Incorrect canonicalization of VAs with bit47=1
> - Potential stale VNCR pseudo-TLB entries after TLBI or MMU notifier
> - Possible incorrect translation/permissions or DoS when combined
>   with other issues
> 
> Fixes: 667304740537 ("KVM: arm64: Mask out non-VA bits from TLBI VA* on VNCR invalidation")
> Cc: stable@vger.kernel.org
> Reported-by: DongHa Lee <gap-dev@example.com>
> Reported-by: Gyujeong Jin <wlsrbwjd7232@gmail.com>
> Reported-by: Daehyeon Ko <4ncient@example.com>
> Reported-by: Geonha Lee <leegn4a@example.com>
> Reported-by: Hyungyu Oh <dqpc_lover@example.com>
> Reported-by: Jaewon Yang <r4mbb1@example.com>

Please do not use fake email addresses.

