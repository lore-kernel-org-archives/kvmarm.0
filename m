Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F280030E0C0
	for <kvmarm@lists.linux.dev>; Sun, 23 Aug 2026 14:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787494123; cv=none; b=h/ZtGEpE8vPQKanAifTR3/jdpNVKrUIytoEpNTbQu/EcdJ3FCaPTO/E75n25Vo2Qq25Yix3SQyFY3LYMAvlDX6ccDpCWyvkHod4MXPGVG8rOQxiLEZ9xhXgx7Vovk4ebFTB4Tp+2wsYFB+WPNIevSyS25KqSzD0pK4b7xoJyZBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787494123; c=relaxed/simple;
	bh=f7K+M8Y4LLo9/DdnAcAfRgVV96waH6Z2WMNIZYEsknA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hjnteXqxpwyAkrT7miIN0BByVstRJfV62kkT+OGF5eKOYP6idUZzHITLazYEG/oGxdhgpSMaIQQNPBltpfiel08G0K2Y+dQsXl8kxhPsHuUzo+e0u4Di3q1Te66ldQBpthFx5vRHFh++ER5tWoSYk07AZT8h709I8QJq7xJKEk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QMsWpfNR; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QMsWpfNR"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 40E43176C;
	Sun, 23 Aug 2026 07:08:36 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A2D03F85F;
	Sun, 23 Aug 2026 07:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787494120; bh=f7K+M8Y4LLo9/DdnAcAfRgVV96waH6Z2WMNIZYEsknA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QMsWpfNRMMvAxgnC7Ad5Wunk90Ikd00hJyKHV1fHVOG1/SL9XRuzXKdlyI4a2HGUx
	 J9OuKXpReUI3EUBP2KObIkn3lHxc6+eYRbs+T/mcjSaTqSkaRPTSC/9gwGq4wI+JTy
	 F83U8FI4+j+UwvWTgalP07FVejPiqRW0Sp2RLYkc=
Date: Sun, 23 Aug 2026 15:07:38 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <fuad.tabba@linux.dev>, ljs@kernel.org, 
	Shen Yongchao <grayhat@foxmail.com>, Karl Mehltretter <kmehltretter@gmail.com>
Subject: Re: [PATCH v3 0/2] KVM: arm64: nv: Shadow S2 life-cycle fixes
Message-ID: <dwwsihz275bzh2ykt7rxj3sdq5wdorqju2fso6o3jf6sn6sxrx@nua7yri24fjc>
References: <20260821161829.1032561-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821161829.1032561-1-maz@kernel.org>

On Fri, Aug 21, 2026 at 05:18:27PM +0100, Marc Zyngier wrote:
> This is the (hopefully) last revision for this set of fixes for the
> shadow S2 life cycle.
> 
> * From v2 [1]
> 
>   - Fixed the nonsensical type used for allocating the nested S2
>     array, switching to kvmalloc_objs() in the process, guaranteeing
>     some level of type checking
> 
>   - Dropped the extra S2 freeing after Wei-Lin pointed out that we are
>     guaranteed to run the MMU notifier release callback, ensuring that
>     nothing is left behind
> 
>   - Collected AB from Lorenzo, with thanks.
> 
> [1] https://lore.kernel.org/all/20260814103230.858578-1-maz@kernel.org/
> 
> Marc Zyngier (2):
>   KVM: arm64: nv: Fix life cycle of the nested_mmus array
>   KVM: arm64: nv: Delay freeing of shadow S2 structures until VM
>     destruction
> 
>  arch/arm64/include/asm/kvm_host.h   |   2 +-
>  arch/arm64/include/asm/kvm_nested.h |   3 +-
>  arch/arm64/kvm/arm.c                |   8 ++-
>  arch/arm64/kvm/nested.c             | 100 ++++++++++++++--------------
>  4 files changed, 58 insertions(+), 55 deletions(-)
> 
> -- 
> 2.47.3
> 

Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>
