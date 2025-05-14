Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEDE25D21B
	for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 09:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747216076; cv=none; b=PelWCQFAlpdVby6gqtqZVKxFUrl4FfXcBGSnDj/zsr+EfN1VK7ImTZq736yGtTXQc/Bivhcwx1EErtKHOcHt80WsAQ+yC9o9zONQ/bxJiu94GeLqZNzNKEPgXmzV+tCeBJeJoI2lz4qwZUDBHF4nOWhZQKetaM8LHq1oQSwHGTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747216076; c=relaxed/simple;
	bh=TG0IqLi9AgL0Uh4OwoVqyFUkBSVCDzsr00L7JqscPGg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bolYZWumA3iFaU1horRiyGIxlDWdhOh4ZXLzS6D4Wui+UuuJWV1RizWuvBQQ434n3CqED5HZSoj0oIQJRTc5I+D5BCJBpyRo/837FDawKRILL/uh1wRkBDLJHaPfzqsVY6KF/yzelk0Aj2ah7Z65aInnBp5SKfhKlVmfTEnCaPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BKJ/NDQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BKJ/NDQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6073C4CEE9;
	Wed, 14 May 2025 09:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747216074;
	bh=TG0IqLi9AgL0Uh4OwoVqyFUkBSVCDzsr00L7JqscPGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BKJ/NDQPzgPL2kV4gUS/qrUj3/e/JZ7/nyykwXtI6FqNNyNXs935nu4z/ooJg3J5c
	 tEBCioUOB9edyD7uC3jIWaeWbbijfow+7XjykDk93CGOEpEizatuq2nl8r+xxbSUSW
	 YYZ5EY8e812ArH0NDML5JRrwOEuwLTG292L352l0uivzM0TmE7goUKA+8+MWrdYSsL
	 PUgOjzCTnK4g2pHVQnwTEx8eoXNLQU5bYPoOXkHdK1oQuePJ7WG7fj7+PGdElKN8zJ
	 B8J6oeAHKEp9Kr2d34DMtyG3vR0DsfplHKVpVe1tS6zFBJ/y7zs7DkxkoKW+JgLsr3
	 l983tbEQPg8ng==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uF8iO-00Eo8b-Pz;
	Wed, 14 May 2025 10:47:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	D Scott Phillips <scott@os.amperecomputing.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Address Translation fixes
Date: Wed, 14 May 2025 10:47:48 +0100
Message-Id: <174721605556.2224247.6675762921692651616.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250422122612.2675672-1-maz@kernel.org>
References: <20250422122612.2675672-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, scott@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 22 Apr 2025 13:26:09 +0100, Marc Zyngier wrote:
> Here's a small series of fixes for KVM's implementation of address
> translation (aka the AT S1* instructions), addressing a number of
> issues in increasing levels of severity:
> 
> - We misreport PAR_EL1.PTW in a number of occasions, including state
>   that is not possible as per the architecture definition
> 
> [...]

Applied to next, thanks!

[1/3] KVM: arm64: Fix PAR_EL1.{PTW,S} reporting on AT S1E*
      commit: 493b01de726d02e835c510d01df6880fa28d41b7
[2/3] KVM: arm64: Teach address translation about access faults
      commit: ed648ab8043aab3135490d6c01f1c889c4bac62c
[3/3] KVM: arm64: Don't feed uninitialised data to HCR_EL2
      commit: 3e4d597220587593dba505f5a7e932309155c54d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


