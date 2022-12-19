Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A73C33F2;
	Mon, 19 Dec 2022 15:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09E8C433F1;
	Mon, 19 Dec 2022 15:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1671462282;
	bh=5OqadNzH/oenTwhkmzAVTiVeDE+niXDCzBuMzq7fF1E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=l2KE0ccvde0ofkGKBLrVmp9c5mEbXLH8E3qPX0GG3OWEsice9PeKHJSU5htahMUnG
	 NblaCDhkScOmpF4PumQ/G9nKBukdmwtOX/FuisoxF1oR8qBWIwhc9PXgkup54A8Pgu
	 ZLAu/RU3bGyRoWkzflgQFw/Tnbe18aq6BbwoBdhgtTDmz1BH2uT713YDG9kOk2V5Y9
	 jq/F/WEKVwO55b5jUs0LflWV3DHRAg+i8Y2UPSlngxamoU0i0S1DHLbRVne7rC0SEq
	 HFybllk1NoormH0imR3vW/3CzKUsz5EZTf+Gj6j5iXVE4HM5YBgyWPOE24uiP2IPEg
	 M5jyg3RFBSrIw==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1p7Hh2-00DgV2-Eb;
	Mon, 19 Dec 2022 15:04:40 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Mon, 19 Dec 2022 15:04:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Akihiko Odaki <akihiko.odaki@daynix.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Mathieu Poirier
 <mathieu.poirier@linaro.org>, Oliver Upton <oliver.upton@linux.dev>, Suzuki
 K Poulose <suzuki.poulose@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, Will Deacon
 <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 asahi@lists.linux.dev, Alyssa Rosenzweig <alyssa@rosenzweig.io>, Sven Peter
 <sven@svenpeter.dev>, Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH 1/3] arm64/sysreg: Add CCSIDR2_EL1
In-Reply-To: <Y6B6SNADJQkNRoLO@sirena.org.uk>
References: <20221211051700.275761-1-akihiko.odaki@daynix.com>
 <20221211051700.275761-2-akihiko.odaki@daynix.com>
 <Y6BjQiR5gUhIAyIS@sirena.org.uk>
 <6363f9d0979be5aedfb04db4810b71a4@kernel.org>
 <Y6B6SNADJQkNRoLO@sirena.org.uk>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <71c20a843550a71b3a0a745bc428eb29@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: broonie@kernel.org, akihiko.odaki@daynix.com, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, mathieu.poirier@linaro.org, oliver.upton@linux.dev, suzuki.poulose@arm.com, alexandru.elisei@arm.com, james.morse@arm.com, will@kernel.org, catalin.marinas@arm.com, asahi@lists.linux.dev, alyssa@rosenzweig.io, sven@svenpeter.dev, marcan@marcan.st
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20221219150440.6Sm6ZZe-2b6vHCsSvIxcyiy7g_b9DRp0kS5CtP1kfVM@z>

On 2022-12-19 14:50, Mark Brown wrote:
> On Mon, Dec 19, 2022 at 02:47:25PM +0000, Marc Zyngier wrote:
> 
>> Since you're reviewing some of this, please have a look at v3[1],
>> which outlined a limitation of the sysreg generation tool as well
>> as a potential fix.
> 
> Hrm, would've been nice to be CCed on stuff for the tool :/

Apologies for missing the Cc update. I'll add you to the list
next time.

         M.
-- 
Jazz is not dead. It just smells funny...
