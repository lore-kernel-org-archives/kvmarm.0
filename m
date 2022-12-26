Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51999C4167B
	for <kvmarm@archiver.kernel.org>; Mon, 26 Dec 2022 18:22:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B43C34BB5E;
	Mon, 26 Dec 2022 13:22:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rXUtrvupVfb0; Mon, 26 Dec 2022 13:22:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88B764BB25;
	Mon, 26 Dec 2022 13:22:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FE774BAC0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2022 13:22:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BEivaXbhAd03 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Dec 2022 13:22:02 -0500 (EST)
Received: from out-67.mta0.migadu.com (out-67.mta0.migadu.com [91.218.175.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E51A74BAB4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2022 13:22:01 -0500 (EST)
Date: Mon, 26 Dec 2022 19:21:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1672078920;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=cj8fvcXIPRKjdcbdoKyucOKTny9ACesRtz6BgpVcVkM=;
 b=EIWyG69G/AZtzcWq5XIyBUSNRlQZDkyfc0U20LTF9fEMJl0FX0uOlJ/eAr9rqya/camTUG
 P+2F4Zq12xJ+DnTU/groB8gJHKmz/EnZ7/Oqqa66FkhngYxN7a/rJrXobamlTZBnn8glVM
 +7T7V3/Iiag3Ym7nSyg49j/ThSgmh2M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Subject: Re: [kvm-unit-tests PATCH] arm: Remove MAX_SMP probe loop
Message-ID: <20221226182158.3azk5zwvl2vsy36h@orel>
References: <Y6GRXreBu56PqCyG@monolith.localdoman>
 <gsnt8rj2ghof.fsf@coltonlewis-kvm.c.googlers.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <gsnt8rj2ghof.fsf@coltonlewis-kvm.c.googlers.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Tue, Dec 20, 2022 at 04:32:00PM +0000, Colton Lewis wrote:
> Alexandru Elisei <alexandru.elisei@arm.com> writes:
> 
> > Though I'm not sure how you managed to get MAX_SMP to go down to 6 cores
> > on
> > a 12 core machine. MAX_SMP is initialized to $(getconf _NPROCESSORS_ONLN),
> > so the body of the loop should never execute. I also tried it on a 6 core
> > machine, and MAX_SMP was 6, not 3.
> 
> > Am I missing something?
> 
> To be clear, 12 cores was a simplified example I did not directly
> verify. What happened to me was 152 cores being cut down to 4. I was
> confused why one machine was running a test with 4 cores when my other
> machines were running with 8 and traced it to that loop. In effect the
> loop was doing MAX_SMP=floor(MAX_SMP / 2) until MAX_SMP <= 8. I printed
> the iterations and MAX_SMP followed the sequence 152->76->38->19->9->4.

Ah, I think I understand now. Were you running 32-bit arm tests? If so,
it'd be good to point that out explicitly in the commit message (the
'arm:' prefix in the summary is ambiguous).

Assuming the loop body was running because it needed to reduce MAX_SMP to
8 or lower for 32-bit arm tests, then we should be replacing the loop with
something that caps MAX_SMP at 8 for 32-bit arm tests instead.

Thanks,
drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
