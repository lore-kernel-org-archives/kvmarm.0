Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55CD2C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 19 Dec 2022 15:04:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E49654B8C6;
	Mon, 19 Dec 2022 10:04:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z5djxbpF7VHC; Mon, 19 Dec 2022 10:04:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBB204B8BB;
	Mon, 19 Dec 2022 10:04:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EEC04B8BB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 10:04:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LOpLaCURy9CI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2022 10:04:45 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D6D14B8A9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 10:04:45 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 2F204B80E54;
 Mon, 19 Dec 2022 15:04:44 +0000 (UTC)
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
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1p7Hh2-00DgV2-Eb;
 Mon, 19 Dec 2022 15:04:40 +0000
MIME-Version: 1.0
Date: Mon, 19 Dec 2022 15:04:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: Mark Brown <broonie@kernel.org>
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
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: broonie@kernel.org, akihiko.odaki@daynix.com,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 mathieu.poirier@linaro.org, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, james.morse@arm.com, will@kernel.org,
 catalin.marinas@arm.com, asahi@lists.linux.dev, alyssa@rosenzweig.io,
 sven@svenpeter.dev, marcan@marcan.st
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Alyssa Rosenzweig <alyssa@rosenzweig.io>, Hector Martin <marcan@marcan.st>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>, Will Deacon <will@kernel.org>,
 Sven Peter <sven@svenpeter.dev>, linux-kernel@vger.kernel.org,
 asahi@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
