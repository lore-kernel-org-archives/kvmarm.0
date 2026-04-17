Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAC23A3805
	for <kvmarm@lists.linux.dev>; Fri, 17 Apr 2026 14:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776435834; cv=none; b=IBfxDvr8pxc2IjUw7omsIE34lBez22Gl1NS9v4ZXCB9tPCsI/mrjKxyhFLD4L6zIW8OqLIqWrSPOoKdfJYdwe+idyX2ZJ0fMJIt1ToEODce0I58h5B1bTRzgi7hfmvZNUmOEwcqtGo9z0xbzwtRQ5g5uJcroo5/8gkZT4qU1AT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776435834; c=relaxed/simple;
	bh=QSt6j0W6pMiio5QTp6a2cbkfPTTGBRXzqIob3FlkAUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fOm5VY39WeyLXyFric4Ix0li4bRwVhAhbsiwaAT1zCvXWcyj8qduYpvntvPbGvhoAEMmDj5dyGYHdZrRG15ntSZSv0/PIqP23SW4CtaZ5kQ2jS5u2gmQfVvUbGA6WYXTZqo4vPdDoJkBFRn33TDt7xc4JYJo2d3nBCqYd1xJYxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wm48HSKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wm48HSKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38894C19425;
	Fri, 17 Apr 2026 14:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776435833;
	bh=QSt6j0W6pMiio5QTp6a2cbkfPTTGBRXzqIob3FlkAUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wm48HSKhaI8SA5MxAEernWSnujsKRBi1Gsa/5utLnjUaQCdLjkgwn74KT2/fbNDWa
	 E/hGjdJnzrE1E8haO7Rh4vw65jFPgvAkilc2zUM8zxIB296hNT+fX+BoXpSYgWJeUG
	 sB1ZHIi6X+GBDWa2mQ3BDJFjXZ3kGt2DQbYDU3kHQlta80TIlGmMgi1yu90TWeSw/+
	 YcdSh+AQVvo12tLR67pkHkiXIv3MSEbD87mhNgmcPnEQK3M2ygPmKY/UE+hXL+tgsp
	 u1Td7R7h/WogpUDTbRPfDyW3zXeK9nRTxdrdNkKTeTAQ0B2F9x8BSZrNMkLOwRXsgO
	 YCvK5NKagBVrA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wDk6p-0000000CTLo-19xx;
	Fri, 17 Apr 2026 14:23:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: pkvm: Adopt MARKER() to define host hypercall ranges
Date: Fri, 17 Apr 2026 15:23:48 +0100
Message-ID: <177643580645.2772443.3213087362625681888.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260414160528.2218858-1-maz@kernel.org>
References: <20260414160528.2218858-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, will@kernel.org, vdonnefort@google.com, tabba@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 14 Apr 2026 17:05:28 +0100, Marc Zyngier wrote:
> The EL2 code defines ranges of host hypercalls that are either
> enabled at boot-time only, used by [nh]VHE KVM, or reserved to pKVM.
> 
> The way these ranges are delineated is error prone, as the enum symbols
> defining the limits are expressed in terms of actual function symbols.
> This means that should a new function be added, special care must be
> taken to also update the limit symbol.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: pkvm: Adopt MARKER() to define host hypercall ranges
      commit: 9b72acd3f770517d3fd4bd7193fd60f3a81d1f69

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


