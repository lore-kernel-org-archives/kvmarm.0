Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20391C352BE
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 09:29:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 976A220776
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 09:29:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="tuKU9z9r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 976A220776
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C3454B10E;
	Fri, 17 Apr 2020 05:29:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LjQirSDzw2SS; Fri, 17 Apr 2020 05:29:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39BDA4B1FD;
	Fri, 17 Apr 2020 05:29:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 475154B1FD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 05:29:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sSQCcuryCBDC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 05:29:33 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A34F4B10E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 05:29:33 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3242D20776;
 Fri, 17 Apr 2020 09:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587115772;
 bh=8GFWZC8Mlqm1nrlxFXiXZ+DRoDx2jHTF7EPJnkvnhR8=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=tuKU9z9rJkUGyVamDwgpc4De6rBtKFOiabUsjvOFu9FJIuHSdwFzebiaMDcDRNpHP
 7S6LgVFAKhCGGQ9IftBm+2v72/J+swxa+p9D+fOEHJUlltXee9BaN3ZkH56xffgi/g
 CxidCiZV2ChfeIzk6G/0RaHHSWXjwxIQTs+SO9/8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jPNJS-00487e-FA; Fri, 17 Apr 2020 10:29:30 +0100
MIME-Version: 1.0
Date: Fri, 17 Apr 2020 10:29:30 +0100
From: Marc Zyngier <maz@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 0/4] KVM: arm64: Tidy up arch Kconfig and Makefiles
In-Reply-To: <20200417085522.150701-1-tabba@google.com>
References: <20200417085522.150701-1-tabba@google.com>
Message-ID: <50eb0bea7691f2430e4dfa72a1a22a73@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: tabba@google.com, catalin.marinas@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kvmarm@lists.cs.columbia.edu, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi Fuad,

Thanks for this.

On 2020-04-17 09:55, Fuad Tabba wrote:
> Hi,
> 
> This small patch series tidies up the arm64 KVM build system by
> rejigging config options, removing some redundant help text, and
> consolidating some of the Makefile rules.
> 
> The changes are cosmetic, but it seemed worthwhile to send this out
> for consideration.

Happy to take these patches for 5.8. Could you please rebase them on top
of [1], which moves all of the (now arm64-specific) code where it 
belongs?

Cheers,

         M.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/welcome-home
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
