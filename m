Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D7219DF73
	for <kvmarm@lists.linux.dev>; Thu, 15 Aug 2024 13:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723727343; cv=none; b=R5GoVMKiHUAO1HVjQpPrAHIxeE+U4SSTtNKI63bF6eJCNGqXNQAgM+cdhO/hZaDEjXeySp7Z3/YCdv/69Ddyh9RRQaCu098KuF4yaHZX25hlYsglsQjWJf5sWRsPiolalHi4h5oDWDFyLzij3qj/D5PHC66yd2CAZMWMcWhztOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723727343; c=relaxed/simple;
	bh=5xwQGFLbh8QEwG1vd5ZqwAdM3tys8ecqNU6q476h8KI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l4JiJ2uvFtYjPaWa5Rb4izukOB+Xy1lE7Bn+GpMtEd0XFZzDCHyJdNipJiInvn/VepQGvEMdjYysmUmXOu1rR8U9/qNATmn4xA3sTC8/6OFCEQ5GVSU8un9K+0ZpsfG7+/Arsr11lVKYakHGJQWDmtl40Ipk+waF7wsR2FFH6jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ga2sTILu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ga2sTILu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3390C4AF14;
	Thu, 15 Aug 2024 13:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723727342;
	bh=5xwQGFLbh8QEwG1vd5ZqwAdM3tys8ecqNU6q476h8KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ga2sTILu6sTCQKPvKUumQhMABTelRGUidgDPJlBrSrDZ98lQZK/U/0Rk/5IlqFgP+
	 1aOioJSjLdZRSdKPbdXSyjD5BUeVFEJXtBXvybExnpaoI0f7d3xXmK3rJrQiPx7J6I
	 cAdF2PfV7t7HhR7y9jUbbfSuIecDksqf+pKnLLHcVUOY7hEQAvrY6J+uaRb7ozORv8
	 qlIC7ZoaoECXU8GaV6vqxoGwFe7mmcMe0trqVDQHHe/xwrZwZvie0B0hBOEnUBx0Uu
	 oij336Ww14a8xYPu6pCEZIpAWv/vgs43kGpiym6Jr4IWr7QIdVXxc1G5dkNDdpc5n0
	 oQcfq/9KEIK5Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1seaDs-003y2F-Mq;
	Thu, 15 Aug 2024 14:09:00 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 0/2] KVM: arm64: Fix a couple of pKVM/nVHE TLB invalidation bugs
Date: Thu, 15 Aug 2024 14:08:56 +0100
Message-Id: <172372733038.2098190.15067662992297038393.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240814123429.20457-1-will@kernel.org>
References: <20240814123429.20457-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, will@kernel.org, oliver.upton@linux.dev, tabba@google.com, kvmarm@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 14 Aug 2024 13:34:27 +0100, Will Deacon wrote:
> These two patches fix a couple of TLB invalidation bugs in pKVM. The
> first one was spotted by inspection while I was debugging a crash which
> turned out to be caused by the second problem.
> 
> Feedback welcome.
> 
> Cheers,
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Invalidate EL1&0 TLB entries for all VMIDs in nvhe hyp init
      commit: dc0dddb1d66de88c571cf1a5bc3b484521a578af
[2/2] KVM: arm64: Ensure TLBI uses correct VMID after changing context
      commit: ed49fe5a6fb9c1a1bbbf4b5b648c7d34a756cb6d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


