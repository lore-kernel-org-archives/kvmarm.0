Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857B77D3EC
	for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 18:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718131756; cv=none; b=cDB97udTzpUE78m/wRclQkuxfEb1fEcw5hXbJE1fwDhhd/rtH22om9d9ZtvFzOt3TGArX5ZYaTkfdiYexqdYKzc9Ejcilx4abCsMP+vzEQAwrJCF2alodlyAv94hxjgXFUgDIseekP+GvhxAo8C+pZLxoVPPXVdlIyT08ygh+Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718131756; c=relaxed/simple;
	bh=gG4qUXerF5Z46gwnCgAGRy+sJAa5vkVUxsxkDl55Ns0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nj3GGr0JF6ndc4J2pET/i6//APsMGj75mApIbLRBiPCyBBdqjBfsZZpWDbtxPCF4g6zP0xwPczbsBSusnPp3uJp18o5l2Gu9US9w72U9QWwDQ67zLmdVYYJtmTXjB8+RtmVAOYzflQKrc5ECx2foGPe6qe5XOWwTknLVr6bXm7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E1TqPrRX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E1TqPrRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D02C2BD10;
	Tue, 11 Jun 2024 18:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718131756;
	bh=gG4qUXerF5Z46gwnCgAGRy+sJAa5vkVUxsxkDl55Ns0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1TqPrRXAd4oH8guC7sNZPgDFELH74MZa1UKAHFKXJ68ctRMdJIi7On2MsvBpcFtA
	 nVPkmfogsUjLX/g4fetqFbLH8CeVliw5/pHd8zq3/gBkwuIkpyJhvJM3/DWOupke4U
	 1u254WXiGh8hLAqtahpqEwm9CVmqy7EsHJ5RBRA1iC36vof7sJE88tMteQYI6xRNqi
	 GRKxz1rEU8mDdgzCXYgii0k9fMlQachdpGWbp+sf93iW2XDmzTbf5wNAplfXafZ35c
	 X5jZ/08PJ7T8LkhW9WcEwUGwiVRog7U4f8121qRFg0O2me2Util7dMOW8Qz7tCOmT/
	 NxgSKgD412ERg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sH6YT-002s0S-Hh;
	Tue, 11 Jun 2024 19:49:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: oliver.upton@linux.dev,
	sudeep.holla@arm.com,
	Vincent Donnefort <vdonnefort@google.com>
Cc: sebastianene@google.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH v2] KVM: arm64: FFA: Release hyp rx buffer
Date: Tue, 11 Jun 2024 19:49:06 +0100
Message-Id: <171813173716.2382482.5218269177122602078.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240611175317.1220842-1-vdonnefort@google.com>
References: <20240611175317.1220842-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, sudeep.holla@arm.com, vdonnefort@google.com, sebastianene@google.com, will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 11 Jun 2024 18:53:17 +0100, Vincent Donnefort wrote:
> According to the FF-A spec (Buffer states and ownership), after a
> producer has written into a buffer, it is "full" and now owned by the
> consumer. The producer won't be able to use that buffer, until the
> consumer hands it over with an invocation such as RX_RELEASE.
> 
> It is clear in the following paragraph (Transfer of buffer ownership),
> that MEM_RETRIEVE_RESP is transferring the ownership from producer (in
> our case SPM) to consumer (hypervisor). RX_RELEASE is therefore
> mandatory here.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: FFA: Release hyp rx buffer
      commit: d66e50beb91114f387bd798a371384b2a245e8cc

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


