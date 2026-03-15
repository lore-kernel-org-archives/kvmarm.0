Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AD5366541;
	Sun, 15 Mar 2026 15:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773587520; cv=none; b=g2tm3x7wprqc+x/Lyavz0PUQ3vyXyUfofk2AOxgDX4tZmsdnvwHU2hbOZphQCmatERNxbn2c7gfHpN7V+Hmz0KlfShwnVq3FaK7FyzDVd6Wkdo5RVrdLIrFzsTzaZoB2u9PX873lf9wwaYc5QexJwUQ/+irymh4eZtq1YKGzwN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773587520; c=relaxed/simple;
	bh=6jQp4ea3K3hRb3fhb0FEeSzMJUsm3BVSJ/Pao5wNtNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qf8lGGX6+LBOHja4palxvfdqSmAmhCOJ1ReT9muQ+nOJF/ct/hiBIAES+rozB61//7nPWosaoYxJUw9YaWoJTPFEnAkugfoZ0RIperxFAXQdxKCnF286+Ui6hEA7USC8pHW7ACFGe6h4wNZz6DPMJwxJHqV7RCOeoItMe9QkYGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TuC6Tv/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TuC6Tv/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BC0C4CEF7;
	Sun, 15 Mar 2026 15:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773587519;
	bh=6jQp4ea3K3hRb3fhb0FEeSzMJUsm3BVSJ/Pao5wNtNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TuC6Tv/YRav5hWMQVY1n8ds6PVQRaEXmkqV5HnkMb8QUdDkq8pmhJCsS1yCSlufRT
	 eIpjCx/DsXjz+/a+3iO4DTVBbCj7zLlfS6zFzTYlicEiggh0w+615rb7lN2IaIPGl/
	 J2C2UqI2urx+SSaflRQI8y+g7nPPEu3cbi516dR3e+afM7vuRZfRzK5AwP7O5LqdfK
	 RjbaITlZ6qeFaboki++hc9GIYW1fCOImjAc3u7y5oBTdqH7XL8VGvEMb80f/I8eIkV
	 zR9UlU2386mCiJEfdxA1auuauhuGuQ4iI1qAnEQChOglz6dY/6IXwBm01ksLjmYaQm
	 1Tsaq+ByWMYLg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w1n8H-00000002AWr-0hpc;
	Sun, 15 Mar 2026 15:11:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Discard PC update state on vcpu reset
Date: Sun, 15 Mar 2026 15:11:53 +0000
Message-ID: <177358750718.974845.17608338527108220660.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260312140850.822968-1-maz@kernel.org>
References: <20260312140850.822968-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 12 Mar 2026 14:08:50 +0000, Marc Zyngier wrote:
> Our vcpu reset suffers from a particularly interesting flaw, as it
> does not correctly deal with state that will have an effect on the
> execution flow out of reset.
> 
> Take the following completely random example, never seen in the wild
> and that never resulted in a couple of sleepless nights: /s
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Discard PC update state on vcpu reset
      commit: 1744a6ef48b9a48f017e3e1a0d05de0a6978396e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


