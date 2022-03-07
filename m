Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0DAC4332F
	for <kvmarm@archiver.kernel.org>; Mon,  7 Mar 2022 15:48:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18F284B1AA;
	Mon,  7 Mar 2022 10:48:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WKQBOmXoBnnU; Mon,  7 Mar 2022 10:48:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B9554B1AB;
	Mon,  7 Mar 2022 10:48:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89F2C4B1A5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 10:48:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1PUFNYdDoV6x for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Mar 2022 10:48:25 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37DFE4B19F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2022 10:48:25 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id C7319B815F8;
 Mon,  7 Mar 2022 15:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EFFC340E9;
 Mon,  7 Mar 2022 15:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1646668103;
 bh=rwwzfeJQx2Fg241T8gSzdrTLHq4FAEtTT9qgzpxZuYs=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=Qj/5v6HUgig2upI/ZQVz9M4+6nTGaOt373JQpKOK2F7Fts+HHlvYnteq6vGPsfR17
 oF+1sUPeVUe0/R0OUgUIxXiIv1QIYbZaPtztfyDh9kfXqcKpb0IDIfHIKUHb2KlvI9
 sDenSBWvQi5e8cWjL2U6HjuxJwUTfK7FRILOLo90w8ZxFHDpc5K7m4z2QqNikfyN5r
 0+qgU6gtYUfh7fR0G51vEfPpSLc2Qm6ajNhmDRUhGqWsSHUzphHsDSwnc6zdutWjTz
 AxUdWSNbs0mGxfrOlZ4sQ/PMFC/lDvxfC+Qql3MF5X+WLdd4OAi0QnR2xcrCdSb8kE
 MMDeDoZLTYNFg==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nRFat-00CpXt-Kq; Mon, 07 Mar 2022 15:48:20 +0000
MIME-Version: 1.0
Date: Mon, 07 Mar 2022 15:48:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v6 43/64] KVM: arm64: nv: arch_timer: Support hyp timer
 emulation
In-Reply-To: <YiYcLIhdo5fQFbSA@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-44-maz@kernel.org>
 <YiYcLIhdo5fQFbSA@monolith.localdoman>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <c084f234eff61b0ab8da5716879745e2@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com,
 jintack@cs.columbia.edu, haibo.xu@linaro.org,
 gankulkarni@os.amperecomputing.com, chase.conklin@arm.com,
 linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com,
 karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>, kvmarm@lists.cs.columbia.edu,
 mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 "Russell King \(Oracle\)" <linux@armlinux.org.uk>,
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

On 2022-03-07 14:52, Alexandru Elisei wrote:
> Hi,
> 
> I was under the impression that KVM's nested virtualization doesn't 
> support
> AArch32 in the guest, why is the subject about hyp mode aarch32 timers?

Where did you see *ANY* mention of AArch32?

Or is that a very roundabout way to object to the 'hyp' name?
If that's the case, just apply a mental 's/hyp/el2/' substitution.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
