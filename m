Return-Path: <SRS0=VO0i=4D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CEFEC2BA83
	for <kvmarm@archiver.kernel.org>; Sat, 15 Feb 2020 13:01:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1CBB02083B
	for <kvmarm@archiver.kernel.org>; Sat, 15 Feb 2020 13:01:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="OpqoOBzx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CBB02083B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A18FD4A982;
	Sat, 15 Feb 2020 08:01:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OyhcxiAAs0Fq; Sat, 15 Feb 2020 08:01:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DF6E4AEBC;
	Sat, 15 Feb 2020 08:01:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5336E4A982
 for <kvmarm@lists.cs.columbia.edu>; Sat, 15 Feb 2020 08:01:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8b0X3tLyZdZM for <kvmarm@lists.cs.columbia.edu>;
 Sat, 15 Feb 2020 08:00:59 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 66DF64A7E4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 15 Feb 2020 08:00:59 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3DDB12083B;
 Sat, 15 Feb 2020 13:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1581771658;
 bh=IlVg+7WZjLz8i78gKlPFmvAGVxAOutix+9XWCG/zJNU=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=OpqoOBzxtuhp34xWuSv1WvEvv+xj2BGRWrM9Oxrh4jTTuI7hPgtj60P1aF16NwBMA
 j8zwqPSkJSmIGMnY2aG5hU4Whc47ARjBQqr+XDDWVmfV/OnvA10nrt+WqSSlo0EUDQ
 hCEhxaaeR+IouzIhP5EaIGOv8YIsjwrsvR2M5xBg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j2x44-005RoV-HQ; Sat, 15 Feb 2020 13:00:56 +0000
Date: Sat, 15 Feb 2020 13:00:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: Filtering PMU events
Message-ID: <20200215130055.0995efe7@why>
In-Reply-To: <20200214183615.25498-1-maz@kernel.org>
References: <20200214183615.25498-1-maz@kernel.org>
Organization: Approximate
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, Robin.Murphy@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Robin Murphy <Robin.Murphy@arm.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, 14 Feb 2020 18:36:13 +0000
Marc Zyngier <maz@kernel.org> wrote:

> It is at times necessary to prevent a guest from being able to sample
> certain events if multiple CPUs share resources such as a cache level.
> In this case, it would be interesting if the VMM could simply prevent
> certain events from being counted instead of simply not exposing a PMU.
> 
> Given that most events are not architected, there is no easy way
> to designate which events shouldn't be counted other than specifying
> the raw event number.
> 
> Since I have no idea whether it is better to use an event whitelist
> or blacklist, the proposed API takes a cue from the x86 version and
> allows either allowing or denying counting of ranges of events.
> The event space being pretty large (16bits on ARMv8.1), the default
> policy is set by the first filter that gets installed (default deny if
> we first allow, default allow if we first deny).
> 
> The filter state is global to the guest, despite the PMU being per
> CPU. I'm not sure whether it would be worth it making it CPU-private.
> 
> Anyway, I'd be interesting in comments on how people would use this.
> I'll try to push a patch against kvmtool that implement this shortly
> (what I have currently is a harcoded set of hacks).

I now have a small extension to kvmtool allowing a --pmu-filter option
to be passed on the command line (see [1]).

I've also pushed out an update[2] to the kernel side of things, making
the filtering of the cycle counter consistent and documenting that
neither SW_INCR nor CHAIN could be filtered with this mechanism (but
this is of course up for discussion).

Thanks,

	M.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git/commit/?h=pmu-filter
[2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pmu-event-filter

-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
