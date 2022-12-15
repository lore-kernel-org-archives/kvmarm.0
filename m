Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9DD3234
	for <kvmarm@lists.linux.dev>; Thu, 15 Dec 2022 13:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5224CC433D2;
	Thu, 15 Dec 2022 13:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1671111126;
	bh=9Pc/Oa81r/SyJaABgX1OKgnJyICVpKTQ1XBBUC7rpGQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Re6/CY9Yxwi2Oye59SA5KSMHnxCPzuFRy3m4nbzaAodwx17B8YadHZ3CHHhf0ZXux
	 R3crWqomEz811wMRMSYe6XT5DB78r43h6BoE54fCTf6sSGeYC+K6KSrrtmwsWLFdrh
	 oBr7O69DBJCMcJ6k79eljZl3OT/ob5S6/6N0ifpEVyrLwjqede5qKO9PeIqP5uw4YD
	 uOgtYULuYCXJbSoe0qYAwtPOeuu5l3LgSXu3BKys+xU+vftZ5VlFj0J6eGQBmBJyfn
	 C2qNNlRE1fmO4TT75QfZVAarvwHm2XqNXZOFJ6MaFPcRYUc6y9eWYiydaHZ5U6sFKI
	 kcbxlLy7YZRRA==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1p5oLD-00Cr9p-Up;
	Thu, 15 Dec 2022 13:32:04 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 15 Dec 2022 13:32:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Sami Mujawar <Sami.Mujawar@arm.com>, Thomas Gleixner
 <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 10/14] arm64/nmi: Manage masking for superpriority
 interrupts along with DAIF
In-Reply-To: <Y5h617/poqLRQU8H@sirena.org.uk>
References: <20221112151708.175147-1-broonie@kernel.org>
 <20221112151708.175147-11-broonie@kernel.org> <Y5IchpFrIB3y8575@lpieralisi>
 <Y5c0tW7sidPE0oxd@sirena.org.uk> <Y5g55A3N9rXmS4LK@lpieralisi>
 <Y5h617/poqLRQU8H@sirena.org.uk>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <c4bbc7bb6c9e0f7bf7fea185727945d0@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: broonie@kernel.org, lpieralisi@kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, Sami.Mujawar@arm.com, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2022-12-13 13:15, Mark Brown wrote:
> On Tue, Dec 13, 2022 at 09:37:56AM +0100, Lorenzo Pieralisi wrote:
>> On Mon, Dec 12, 2022 at 02:03:33PM +0000, Mark Brown wrote:
> 
> It might be Marc's changes I guess, I didn't pull them in but I don't
> see anything there that should be doing anything without running a 
> guest
> either...

Quite. And even with that, the virtual state is, by definition,
isolated from the the physical state.

         M.
-- 
Jazz is not dead. It just smells funny...
