Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF17EC25B08
	for <kvmarm@archiver.kernel.org>; Sat, 13 Aug 2022 08:13:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37CC74E5BF;
	Sat, 13 Aug 2022 04:13:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BhfnJOAZDMSf; Sat, 13 Aug 2022 04:13:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1098D4F4A5;
	Sat, 13 Aug 2022 04:13:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D3EC4E5BE
 for <kvmarm@lists.cs.columbia.edu>; Sat, 13 Aug 2022 04:13:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7xoWI0nuKwLE for <kvmarm@lists.cs.columbia.edu>;
 Sat, 13 Aug 2022 04:13:50 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 920844C81E
 for <kvmarm@lists.cs.columbia.edu>; Sat, 13 Aug 2022 04:13:50 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 510B2B80E91;
 Sat, 13 Aug 2022 08:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB05C433D6;
 Sat, 13 Aug 2022 08:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1660378428;
 bh=T38Od1Xlo14TNSE6/5h1pVKOnEmN0PeaCuAmu9IX5oQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=ITBEUXcGVM5htpyntSHrufd+ec7jBK7/1eLYI5R9FGB0tPryOdso7qcnaHvD5rAwZ
 +r627JmEtWdqATEmKfWEwpV6B0VKaXwe/L1E7BoXdZr8iSusWzXs2NqsU08752cS2P
 rrP8QuaSRH0nHq1jSdrBeXXp7uBUYmOcD8SK1KBVnUlpSBqxsoTlru9sEhd/HVp4vM
 KBzGLDWWbo1c2PT9X1Jpp5jCdDQ2Q0GIBKicE01tWPR+6Q52zupfj1dUqTn78Xvd8A
 9IfZadTKozdHoUQYD3Xc4bjBs3UV3NtxjnNk7NA9yM087/7mEWqorkAs9pD9yw4kfJ
 S8W3e5zjhLQSg==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oMmHB-002gj4-PT;
 Sat, 13 Aug 2022 09:13:45 +0100
MIME-Version: 1.0
Date: Sat, 13 Aug 2022 09:13:45 +0100
From: Marc Zyngier <maz@kernel.org>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [kvm-unit-tests PATCH v4 0/4] arm: pmu: Fixes for bare metal
In-Reply-To: <20220811185210.234711-1-ricarkol@google.com>
References: <20220811185210.234711-1-ricarkol@google.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <6f73b9c76d9fcdb61a1bb2ee0404159c@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ricarkol@google.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev, alexandru.elisei@arm.com,
 eric.auger@redhat.com, oliver.upton@linux.dev, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, andrew.jones@linux.dev, kvmarm@lists.cs.columbia.edu
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

On 2022-08-11 19:52, Ricardo Koller wrote:
> There are some tests that fail when running on bare metal (including a
> passthrough prototype).  There are three issues with the tests.  The
> first one is that there are some missing isb()'s between enabling event
> counting and the actual counting. This wasn't an issue on KVM as
> trapping on registers served as context synchronization events. The
> second issue is that some tests assume that registers reset to 0.  And
> finally, the third issue is that overflowing the low counter of a
> chained event sets the overflow flag in PMVOS and some tests fail by
> checking for it not being set.
> 
> Addressed all comments from the previous version:
> https://lore.kernel.org/kvmarm/YvPsBKGbHHQP+0oS@google.com/T/#mb077998e2eb9fb3e15930b3412fd7ba2fb4103ca
> - add pmu_reset() for 32-bit arm [Andrew]
> - collect r-b from Alexandru
> 
> Thanks!
> Ricardo
> 
> Ricardo Koller (4):
>   arm: pmu: Add missing isb()'s after sys register writing
>   arm: pmu: Add reset_pmu() for 32-bit arm
>   arm: pmu: Reset the pmu registers before starting some tests
>   arm: pmu: Check for overflow in the low counter in chained counters
>     tests
> 
>  arm/pmu.c | 72 ++++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 55 insertions(+), 17 deletions(-)

For the series:

Acked-by: Marc Zyngier <maz@kernel.org>

        M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
