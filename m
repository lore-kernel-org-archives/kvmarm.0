Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED534C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 19 Dec 2022 14:47:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68C5B4B8AF;
	Mon, 19 Dec 2022 09:47:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KRBA5upSUR8p; Mon, 19 Dec 2022 09:47:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 020C14B8A5;
	Mon, 19 Dec 2022 09:47:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CC484B8A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 09:47:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YmIbRAydACuI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2022 09:47:31 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EFD044B87A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 09:47:30 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 99D4CB80E47;
 Mon, 19 Dec 2022 14:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46683C433F0;
 Mon, 19 Dec 2022 14:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1671461248;
 bh=MENjf6lY8GK2GTH2tECqFbt7ss1GMvxx+PbZHvnU7iw=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=V4A3elTQRGlZEYtd8MKwSTgMymarhRIwCKt7XgdZbGmedeaWmDNJFT/GQYN8coL1I
 0l0lSITSPwMxU8GqiD2Gss7nE6WY5J0Ft054QnUj/Rm//pwxZ16Ry6tfRtN9hFZHZU
 EPT/+yhrXcSLK1dT23iU2QkUnDxqt1BcK8712esWHHYi5/pEwpITKuZU2AGm4r60Kf
 Gq9s8qcIPnyuaH4ccRUTKTB57DXM3BsvOMn1XdRy+2HWGjcAGPvhiFFCL6yhvfec48
 FPRuqjMnUDbdl6pexjynquwVAEdXlDghZ7X3Kvgk9blfVSFTJI15Dvgjt+5xjEsNEP
 I37YDyepK0MgA==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1p7HQL-00DgCo-Sg;
 Mon, 19 Dec 2022 14:47:25 +0000
MIME-Version: 1.0
Date: Mon, 19 Dec 2022 14:47:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 1/3] arm64/sysreg: Add CCSIDR2_EL1
In-Reply-To: <Y6BjQiR5gUhIAyIS@sirena.org.uk>
References: <20221211051700.275761-1-akihiko.odaki@daynix.com>
 <20221211051700.275761-2-akihiko.odaki@daynix.com>
 <Y6BjQiR5gUhIAyIS@sirena.org.uk>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <6363f9d0979be5aedfb04db4810b71a4@kernel.org>
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

On 2022-12-19 13:12, Mark Brown wrote:
> On Sun, Dec 11, 2022 at 02:16:58PM +0900, Akihiko Odaki wrote:
>> CCSIDR2_EL1 was added with FEAT_CCIDX.
> 
> This corresponds to the definition in DDI0487I.a.
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>

Since you're reviewing some of this, please have a look at v3[1],
which outlined a limitation of the sysreg generation tool as well
as a potential fix.

Thanks,

         M.

[1] 
https://lore.kernel.org/r/20221218051412.384657-2-akihiko.odaki@daynix.com
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
