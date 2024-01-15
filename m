Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1930918E28
	for <kvmarm@lists.linux.dev>; Mon, 15 Jan 2024 14:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jADQY+aV"
Date: Mon, 15 Jan 2024 14:47:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705330079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=70gQbu/giMgMkf4XDme2+PvJ3v9UrOA9656rWrCyjgc=;
	b=jADQY+aVG6V1M1+JSosgf/4FbPMNq0qEkomdtCuRkhoJjLA6ByHC5wE/Ks7JMP4XtYKpWH
	iL8ltxfsg/AbK4Ldf4Tb1l0GdsuYrG5zteM2dFMJB1q8DY8k0Y7DkZ4/UlScefpV5mQdW8
	6mNT7mUFP8OzaSoLXXdMfpcEJuWxMw4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Ruidong Tian <tianruidong@linux.alibaba.com>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH] KVM: arm64: Add missing ERX*_EL1 registers
Message-ID: <ZaVFmtKbtCJtaAAu@linux.dev>
References: <20240110075739.8291-1-tianruidong@linux.alibaba.com>
 <867ckh9y7l.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867ckh9y7l.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 10, 2024 at 12:20:30PM +0000, Marc Zyngier wrote:
> If my reading of the ARM ARM is correct, these registers only exist if
> FEAT_RASv1p1 is implemented. Which means that we shouldn't handle
> those as RAZ/WI unconditionally, but instead check for what we
> advertise to the guest and handle it accordingly.

Can we go a step further and just stop advertising RAS to guests? I don't
expect VMs to gain much from our RAZ/WI implementation. Conditional
RAZ/WI would still be helpful in this case for migrated VMs that have
'seen' the feature.

-- 
Thanks,
Oliver
