Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1C422D51
	for <kvmarm@lists.linux.dev>; Thu,  1 Jun 2023 14:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E29CC4339B;
	Thu,  1 Jun 2023 14:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685629895;
	bh=NbMV7LIgvgBDUQvdU51us3yM5fKENbe6xgKNU1bx0WI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GcoKHvZvWnFs3JeJ2GDyF+w7BXJu5mkAWARaDKiI62s//nw9T3c+OP09UN6WlQQ1N
	 hgHxBqrz7GhFrE1g2WM41hWRhirNmOOXrE/a9NZE2EEKtAkFHPCe9VCUcRpSabYjgY
	 c3ePYmJGiIM9GC2WXoguVdkpsvWRmFOFoAc5K81pqFy2BdxMg80daCfr4L+3OS9Gd+
	 CnF5r9tPq90vaYnqBEInowcAcVd/b518J+Wx9hz9irLrPj++4BRX1GwCjhSHmGH7+J
	 eV5ubs3EyqKQlVuLZhxL2QNxkA4fp0mCoC7uar5aMO9cpksNJIGt/RckQVR6ZFT8fS
	 7ujN/a9Vw6Zeg==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q4jKu-0024is-Vi;
	Thu, 01 Jun 2023 15:31:33 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 01 Jun 2023 15:31:32 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel
 <ardb@kernel.org>, James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu
 <yuzenghui@huawei.com>, Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH 0/5] arm64: Get rid of CnP
In-Reply-To: <20230601142429.12835-1-maz@kernel.org>
References: <20230601142429.12835-1-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <ddb1f252a668f6845a94143bd4b2943a@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, ardb@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, vladimir.murzin@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2023-06-01 15:24, Marc Zyngier wrote:
> FEAT_TTCNP (née ARMv8.2-TTCNP, "Translation table Common not private
> translations", commonly known as CnP) was an attempt at allowing the
> sharing of TLBs in a SMT implementation. This was an interesting idea,
> but it never really went anywhere:

[...]

Ah, the joy of using another machine that doesn't have the alias
for the "new" kvmarm ML. Please make sure you fix it when (and if)
replying.

And apologies for the potential noise.

        M.
-- 
Jazz is not dead. It just smells funny...
