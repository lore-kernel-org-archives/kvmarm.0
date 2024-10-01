Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83A019D06E
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 14:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727792945; cv=none; b=Rsu69JD76b1KNARuQtTZPjt3TZDyQ9Z68rKgWTFeNSgSVdMZFuJ4dXSN9o1iikkMBcQcmqmJo9NQcyBoAt+Lyhn9OCEY66PnpunqjbRq7wQDB3Hr636wGep4dRlwUPlsR0uNWMTVcl8En+59ITiyTi9SK5TR7s5pqAoyyV78WkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727792945; c=relaxed/simple;
	bh=91/8EARmqzNF/DvNjl82wkx7d1Z6sPtdCZ95dx/cjgs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ocx+p06g8ePrTY2Y4rhyCa1hjMxdS+NetQshognqC5738xm967Yf79GxxvOY/1q7EqBRhhtroqnSceWe6ltIcTw+5+Oe9ILOd9e4oh9vnBgX5nj9iCX5Cyb3+DHZ7Jh+zVEqAvZtS4KI0d2F1l/XdHMP8sNfVyjo69TQRrFXSKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dTP5cBHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dTP5cBHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B422FC4CEC6;
	Tue,  1 Oct 2024 14:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727792944;
	bh=91/8EARmqzNF/DvNjl82wkx7d1Z6sPtdCZ95dx/cjgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dTP5cBHAmOt6eQWwk98S7ejyomGNErVc2coCUYKQzgu6GEFmTWIRdgtKA0sKQKyAc
	 Hv4+oalkq2t8xyr5ufV1tqO0G3lMTPxG1xk1UltL4G2zvf9zQNqrkCfrUVSEPL6qoF
	 Gb7jJYd85zjlPyqeKeSyZCcZxSNPOjSH/ZAavgLDpTf96XgpyvQ48+786HifxzYVB1
	 PrWHolCNjShWaXu89dzTEcRMOG5zUlIvxxc00A1mYzBLBx5XyfptWHZ0ghUtBAEdTL
	 EnHsKrowK7Z1v2NYNHSvjSQGwW4g4pd6rmnoyV4dkJ/JKWqLDFzTADnMm4qWRIrbc0
	 nVp26j9b1zg5g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1svds5-00GmHg-LC;
	Tue, 01 Oct 2024 15:29:01 +0100
From: Marc Zyngier <maz@kernel.org>
To: oliver.upton@linux.dev,
	Vincent Donnefort <vdonnefort@google.com>
Cc: tabba@google.com,
	kvmarm@lists.linux.dev,
	kernel-team@android.com
Subject: Re: [PATCH v2] KVM: arm64: Fix __pkvm_init_vcpu cptr_el2 error path
Date: Tue,  1 Oct 2024 15:28:56 +0100
Message-Id: <172779288238.1647258.6543049929158020222.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240919110500.2345927-1-vdonnefort@google.com>
References: <20240919110500.2345927-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, vdonnefort@google.com, tabba@google.com, kvmarm@lists.linux.dev, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 19 Sep 2024 12:05:00 +0100, Vincent Donnefort wrote:
> On an error, hyp_vcpu will be accessed while this memory has already
> been relinquished to the host and unmapped from the hypervisor. Protect
> the CPTR assignment with an early return.
> 
> 

Applied to fixes, thanks!

[1/1] KVM: arm64: Fix __pkvm_init_vcpu cptr_el2 error path
      commit: 78fee4198bb4d29cf82c457086d07e009955a682

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


