Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA3A21B429;
	Fri, 11 Oct 2024 13:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728652839; cv=none; b=XON1bW5OsjuYk3M7i6LguPHXGv3qrBmH4mmKIodDH8iSw15PLLbwj/hNPQT33agYqOrhr+nKLRQQeKhQe3KBN52rcOeWCxINzduAdllOBRw+em/zEqMkMwSlikF9VMewXaA1YG5FzHD1VOlXTV7+s1/AiIxn3R9OzZZddLUofkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728652839; c=relaxed/simple;
	bh=Z1SQ09SYwlr/dF8uBuyIFQrsIaalaG8GEpkSgY4uIho=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JNWs1Ag6LY3LHMRY5/GeBEwQkI6yddiTQP53iHON6MRUM5TynyhpoP5ZDOkJDko1hcVMcsBlK0/Ici8kGQoPkuzKjtAYqEhiGMOpfyHSWIpMhW8WtSqXEiIInmTNPaSa376RsrfCgXikkVyWJ0O+aufmPpQjdOFysl2vwpdl3as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DH+sX7FS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DH+sX7FS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F23C4CEC7;
	Fri, 11 Oct 2024 13:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728652838;
	bh=Z1SQ09SYwlr/dF8uBuyIFQrsIaalaG8GEpkSgY4uIho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DH+sX7FSZ84vmc4uolai2WrCyQgSd3xDv8XmUOw2jmPCPQkJxaBcn8F2NRWdttLGD
	 5P242/1VSp1BmgkI5Q4fkmq8S7ylH8TzZAhOaDj00QOxyxHGMnVDh9sssTuYpUMeqM
	 sWNo7KPUbaixPIy5h8zoj0ySperwOQSJNxZLUsCqP9PMPhJCE9gwnNKxZJt/3mz51y
	 vMUVwGvvieg6PcS99BK7CT0ZbKOR8axTt0I06GGLvuXLGtdtCytv1L1iex05Ky2EF7
	 AaGQp/8Bx/2aVIeuL+Xp8KkcZtW4wbIcZ2KqT9DzI1TiZOw4bwBS3qjbOjVQEe1v9J
	 e4hpdlf5y6dQQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1szFZM-002YrT-QU;
	Fri, 11 Oct 2024 14:20:36 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	stable@vger.kernel.org,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't eagerly teardown the vgic on init error
Date: Fri, 11 Oct 2024 14:20:34 +0100
Message-Id: <172865282291.3792539.10958756835672218529.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241009183603.3221824-1-maz@kernel.org>
References: <20241009183603.3221824-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, stable@vger.kernel.org, glider@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 09 Oct 2024 19:36:03 +0100, Marc Zyngier wrote:
> As there is very little ordering in the KVM API, userspace can
> instanciate a half-baked GIC (missing its memory map, for example)
> at almost any time.
> 
> This means that, with the right timing, a thread running vcpu-0
> can enter the kernel without a GIC configured and get a GIC created
> behind its back by another thread. Amusingly, it will pick up
> that GIC and start messing with the data structures without the
> GIC having been fully initialised.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Don't eagerly teardown the vgic on init error
      commit: df5fd75ee305cb5927e0b1a0b46cc988ad8db2b1

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


