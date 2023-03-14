Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E6028EF
	for <kvmarm@lists.linux.dev>; Tue, 14 Mar 2023 09:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46161C433D2;
	Tue, 14 Mar 2023 09:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678786108;
	bh=4Wq+DimwJRCWsYXNLxJIg3GulKjYDMChn3aYr3G0Boc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jjnV93wj9esKa9LllQg9W+Q5AnVH7HDe4ay4KSETMVhXECN+3FTxPW54X1JrxQo47
	 nK0yPXaWDnBLAN29CJRsZjiLzwtnxBuUmLwRE063aZ3kiF7CZFtW9N7wFhQQ9//2gC
	 5cmPcQhEZ97LcHqJqpOKdFvcwUtWCziFIEKyC+YAFPGtTpQfc29Gt7rIP2HmIb3CX8
	 AVR5h+jsrVzx0xygLQWERsffByc1T/5QXCpxy4EPUM1xS6OoWhrgPURqFzr0Dw756w
	 2AoPm3vnf5CDSeV3jQqzgpI1QA9ZHRVDSTD4wZvtroVoWcLw2weAUiYoJ/6kLvtj5c
	 HUdTvGTD0hBtg==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pc0xF-00HVTC-Tw;
	Tue, 14 Mar 2023 09:28:26 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Tue, 14 Mar 2023 09:28:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: Cristian Marussi <cristian.marussi@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Jeremy Linton
 <jeremy.linton@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, David Woodhouse
 <dwmw@amazon.co.uk>
Subject: Re: Circular lockdep in kvm_reset_vcpu() ?
In-Reply-To: <ZA9pUNZPyFtLDfxC@e120937-lin>
References: <f6452cdd-65ff-34b8-bab0-5c06416da5f6@arm.com>
 <Y+bnybGEkMpZzm/y@linux.dev> <ZA72c+TT9epTcvX4@e120937-lin>
 <3496a6a10b2d8693825e733b871938f5@misterjones.org>
 <ZA9pUNZPyFtLDfxC@e120937-lin>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <82978ec75c0b34203dd1df693e7adf83@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: cristian.marussi@arm.com, oliver.upton@linux.dev, jeremy.linton@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, dwmw@amazon.co.uk
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2023-03-13 18:20, Cristian Marussi wrote:
> On Mon, Mar 13, 2023 at 02:09:55PM +0000, Marc Zyngier wrote:

>> And -rc2 works just fine here.
> 
> Thanks, I'll dig deeper what's going on un my setup.

Actually, you really want this patch[1] which is on its
way to Linus.

It could explain the issue you're seeing with SMP.

         M.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/commit/?h=fixes&id=47053904e18282af4525a02e3e0f519f014fc7f9
-- 
Jazz is not dead. It just smells funny...
