Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC606C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 22 Apr 2022 17:10:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14E7949F03;
	Fri, 22 Apr 2022 13:10:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z5KMmgBxk106; Fri, 22 Apr 2022 13:10:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D3AD4B262;
	Fri, 22 Apr 2022 13:10:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D83549EE6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 13:10:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ieEIw8f4a6Xc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Apr 2022 13:10:31 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A68D49EC3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 13:10:31 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 79D5A62173;
 Fri, 22 Apr 2022 17:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABCAC385A0;
 Fri, 22 Apr 2022 17:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1650647429;
 bh=Tfj8nbxLW/+CjRCUEie3vjlP1L/DEQVuXe32j0yQLNE=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=jm4EE8qFWyeLHTFHK/6Bd8CJthF89PKLDKTJ15+dn/fJQVrQW6KoDBl1qHSJSGKSJ
 BnIFusNX0tQ4usi1IA1cyinwk3RJcLWSwjorCWCm14dUJfKItAcaizn7R04aqWJUIu
 1fmXAYoKLayuMQ56QSJbAVPAh6u3beAMAHLDSBg6eU/bIWT4eWsTbnx86/C6xEdrja
 RplqP7gFfDTsulM7vxPaP2clDBsYsnEK56ImoWsQe9pQ9gJaK5AOU1+yQz6gcFWyEa
 0OaV+4Z7vNErNCvNZlJKTijSkcxCAl3xBCS8tth8p8KiS1U4JapArStTbu27oQqgo8
 o1riTvGYPOA3g==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nhwnb-006ES4-7z; Fri, 22 Apr 2022 18:10:27 +0100
MIME-Version: 1.0
Date: Fri, 22 Apr 2022 18:10:27 +0100
From: Marc Zyngier <maz@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v14 00/39] arm64/sme: Initial support for the Scalable
 Matrix Extension
In-Reply-To: <20220419112247.711548-1-broonie@kernel.org>
References: <20220419112247.711548-1-broonie@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <65c761cedb3b6e56f4a03fd196a3a767@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, broonie@kernel.org, will@kernel.org,
 skhan@linuxfoundation.org, shuah@kernel.org, alan.hayward@arm.com,
 luis.machado@arm.com, Salil.Akerkar@arm.com, Basant.KumarDwivedi@arm.com,
 szabolcs.nagy@arm.com, james.morse@arm.com, alexandru.elisei@arm.com,
 suzuki.poulose@arm.com, luca.scalabrino@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Will Deacon <will@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 Alan Hayward <alan.hayward@arm.com>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>,
 Luca Salabrino <luca.scalabrino@arm.com>
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

On 2022-04-19 12:22, Mark Brown wrote:
> This series provides initial support for the ARMv9 Scalable Matrix
> Extension (SME).  SME takes the approach used for vectors in SVE and
> extends this to provide architectural support for matrix operations.  A
> more detailed overview can be found in [1].

For the KVM patches:

Reviewed-by: Marc Zyngier <maz@kernel.org>

Catalin: the KVM patches are likely to slash a bit with the
WFxT stuff as well. It'd be good to swap stable branches!

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
