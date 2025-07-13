Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8B619D09C
	for <kvmarm@lists.linux.dev>; Sun, 13 Jul 2025 20:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752436879; cv=none; b=HRYIZFxR3mm6vQboHXmFIMFEaIp8hgKzQNo38103zE4o5RW5a1rgm8BgW4dshcfmB+RaHxPuN/JDNJe2y6WnOdGHTEImSG72YsCP7VmL2rIQnCoXWvkRqww2SR51FON3aiTNgjRFr7NnL9tJDptr+dJ90qJR7U/1t9jLxkclG70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752436879; c=relaxed/simple;
	bh=2zr47mFpEIUp6+WoMgmh+bczIGgMGmEmW+H3pXP+Vcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aD9KugfqWIZrcNkvoq9JbLYPG2rCZdh4tt2wyV+YlnzF4aoG0r9loYidHMDk4Sm2XljJVMK+MV2wBqZcA8FLQOBrRH7smYGOzzAQy5hgGrUbluWyOouaZGvYLgQZnMlKu5OnQ7oWJsSUIFRuOGIGI6WEemSazo/Ekm1KEmEX7O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YwN2eEvt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YwN2eEvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E933C4CEE3;
	Sun, 13 Jul 2025 20:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752436877;
	bh=2zr47mFpEIUp6+WoMgmh+bczIGgMGmEmW+H3pXP+Vcg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YwN2eEvtsmiwgZQkmgiaqQbNqM8MNGEksgicOAw3CXZyNWVJCTtiO/rOFa59iocTw
	 oeiCaQWneW4Ladp8vl2yc+tvSHl7lvf8dzfHHR8fSvEFpxAlg+hk05j/zHVcDxx5Pe
	 yjFXCSKC0y/hF5H5gb/+yiiC1ks8N9/w96abk/KQn/yy6lj4hZy3GKIB5uofoEC09k
	 oooE/Og0l1GzZi4wxZw1Z+rT88bBDEEVRA8nAaDDWJS3hVJ3WzLpTFjnHyuRlya7/m
	 jwFecGhR7ON4O82hNPiUIaaoIH4VyLZYZ0Dp1pdw1CGdOaxbsUuVwp/YjgS0XTlg+E
	 SNA15WlKueFaw==
Date: Sun, 13 Jul 2025 21:01:12 +0100
From: Will Deacon <will@kernel.org>
To: DaeRo Lee <skseofh@gmail.com>
Cc: alexandru.elisei@arm.com, james.morse@arm.com, kernel-team@android.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com,
	sebastianene@google.com, sudeep.holla@arm.com,
	suzuki.poulose@arm.com, tabba@google.com
Subject: Re: [PATCH v3 08/10] KVM: arm64: Handle FFA_MEM_LEND calls from the
 host
Message-ID: <aHQQiJr2xLe9KotP@willie-the-truck>
References: <aHOXzUvGaQ1Bz3jG@willie-the-truck>
 <20250713145957.623842-1-skseofh@naver.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250713145957.623842-1-skseofh@naver.com>

On Sun, Jul 13, 2025 at 11:59:57PM +0900, DaeRo Lee wrote:
> > > > Handle FFA_MEM_LEND calls from the host by treating them identically to
> > > > FFA_MEM_SHARE calls for the purposes of the host stage-2 page-table, but
> > > > forwarding on the original request to EL3.
> > > 
> > > I have a question about your patch.
> > > Does treating FFA_MEM_LEND as identical to FFA_MEM_SHARE imply that
> > > the host can still access the memory even after it has been lent?
> >
> > Only if your TZ implementation is broken and relies on the NS hypervisor
> > for isolation.
> 
> I believe pKVM is managing stage 2 isolation between Host and Non-secure Guest
> VMs or between Non-secure Guest VMs
> 
> <Quote DEN0140_FF-A_Memory Management Protocol>
> 2.2.1.2 Relayer responsibilities
> 10. Unmap the memory region from the translation regime of the Lender, if
> managed by the Relayer as specified in 1.2 Address translation regimes. This 
> must be done only if the memory region is in the Owner-EA state. This includes
> removing access to the memory region from any DMA capable devices assigned to 
> the Lender.
> 
> From the content, it seems that when performing a Lend operation, it's
> necessary to perform a Stage 2 unmap of the host memory area. Am I understanding
> this correctly?

No.

pKVM doesn't use FF-A to manage host/guest page ownership.

FF-A is only used for memory management with the Secure world, in which
case a LEND transaction will mean that the Secure world must prevent
Non-Secure access to the memory itself and not rely on pKVM to unmap
at stage-2.

Will
