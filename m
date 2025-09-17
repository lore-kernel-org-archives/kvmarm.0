Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A832FAC09
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 16:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758127366; cv=none; b=bfCSY+DKRlWj/nyjDu3sjLR/7+NnR8zM/MmqRqqsKPWeb4u5D84vrLT9JKbwjRsFzA4G4yoxS9HRQ7E2LOHtksh1Ecf3uppLvDZE4ndYkDEFfmpIq+rAzOVOSegLouTh18CYTXCsCMepkxZ/nKvrLPcXJPcKIKRzy8ttMgGhcC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758127366; c=relaxed/simple;
	bh=tay0VhD5lvvE7TcAMrCNkB2WpeKqaK2m2wjO/aE1OjE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b7qQZKsQtwwJfi1v7w9i86guVFU2CIQ3hRF0dWNo/oIDKscn7K2X0dXceenidd7uhrnLwdZgGWGRut0fP5Ebpoevxi6AYVCh9guv9yS97HimdRxgVfKTBO0lDA82Q8FlvBJVTctSYsvu1s1L9WGFlfMZHGcqEfZ5/6leARqqeLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SZIppzzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZIppzzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6CDC4CEF7;
	Wed, 17 Sep 2025 16:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758127366;
	bh=tay0VhD5lvvE7TcAMrCNkB2WpeKqaK2m2wjO/aE1OjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SZIppzzo5MayZHJzCDBrDeGZAynhLZrzT9TdP++eP+kmmGfq1Fh0e/vQDB/VC0RbM
	 56S8ixPzlHyVP2bx6nkepRRH0uBKXlQxp1zCaDxAwM+hFrBEoLvWloyU6XAPA4KSuB
	 29C3GobBbcreJUu4vv/a3X5QstEs8jZPkYWiXy9uRESye2KWSo+OM8VAoAvHUhNrRS
	 C7LLbPDJmSgAzdh/8nByaKulfqoQh9x5R7n4d+DZ7L/mTY852YozrfyzUdNO+9k3Uq
	 BG/ALmSw/XDr5Vue9OhoYmdUopZwRH/8QAgUlP2swV7A+dQo7CBQqKBjkbRAGDR6Xh
	 CLMLLRMUb/iMw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uyvEy-00000007ACn-0rbQ;
	Wed, 17 Sep 2025 16:42:44 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Fix kvm_vcpu_{set,is}_be() to deal with EL2 state
Date: Wed, 17 Sep 2025 17:42:32 +0100
Message-Id: <175812735031.1632717.2582315143939738044.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250916161103.1040727-1-maz@kernel.org>
References: <20250916161103.1040727-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 16 Sep 2025 17:11:03 +0100, Marc Zyngier wrote:
> Nobody really cares about BE, but KVM currently only deals with
> SCTLR_EL1 when evaluating or setting the endianness in PSCI,
> meaning that we evaluate whatever the L2 state has been at some point.
> 
> Teach these primitives about SCTLR_EL2, and forget about BE...
> 
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Fix kvm_vcpu_{set,is}_be() to deal with EL2 state
      commit: 6515c612e79949b17ef4b8c4180c07bbeaf01e4d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


