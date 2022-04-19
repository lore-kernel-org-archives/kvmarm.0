Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C129C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 14:10:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF6AE49F02;
	Tue, 19 Apr 2022 10:10:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qBvuBayuE5eg; Tue, 19 Apr 2022 10:10:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DDF44B0DD;
	Tue, 19 Apr 2022 10:10:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B13E48F9C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 10:10:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cVqM7LzYCLGM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 10:10:26 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 90BCE43C72
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 10:10:26 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 30C07CE18A1;
 Tue, 19 Apr 2022 14:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01113C385A7;
 Tue, 19 Apr 2022 14:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1650377418;
 bh=0nhux9KiEQromYdtSaEzV3I8DtuQ8Z93gboBBQUEsII=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=kIjXlrleNlWbfTMc/WrsLg7Aq6KO+8LJgLS/1qHc1KjSoAyrC9jZe8G0OcllHklab
 lsb5vvk8qGI2ZH0/3ZkF2IEwQLx2C3JS8cf2Fx+tCLpLyyvKvqCoum2SDmrQVy05Dl
 RaOLB2LhCGaYQEVs4r7xNpa6yZ5RHVYHs08B/WJJHS3RDyHxL4LwFpAi5uVfw6sHM1
 CWWEQ+DBkv9o2rml8LVrWprZytzQVnRRRVVSNt4pS1gs6jSSAilHJzRE7UQKIaKGMz
 8agkIsbe8w5lWwI8AsSz1kdu0lLFSR+z4CfFAmbvvdvZpU/8NowOJywAX646wU1iLt
 +B2llkGoneNlw==
Date: Tue, 19 Apr 2022 15:10:13 +0100
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: KVM/arm64: SPE: Translate VA to IPA on a stage 2 fault instead
 of pinning VM memory
Message-ID: <20220419141012.GB6143@willie-the-truck>
References: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yl6+JWaP+mq2Nc0b@monolith.localdoman>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Apr 19, 2022 at 02:51:05PM +0100, Alexandru Elisei wrote:
> The approach I've taken so far in adding support for SPE in KVM [1] relies
> on pinning the entire VM memory to avoid SPE triggering stage 2 faults
> altogether. I've taken this approach because:
> 
> 1. SPE reports the guest VA on an stage 2 fault, similar to stage 1 faults,
> and at the moment KVM has no way to resolve the VA to IPA translation.  The
> AT instruction is not useful here, because PAR_EL1 doesn't report the IPA
> in the case of a stage 2 fault on a stage 1 translation table walk.
> 
> 2. The stage 2 fault is reported asynchronously via an interrupt, which
> means there will be a window where profiling is stopped from the moment SPE
> triggers the fault and when the PE taks the interrupt. This blackout window
> is obviously not present when running on bare metal, as there is no second
> stage of address translation being performed.

Are these faults actually recoverable? My memory is a bit hazy here, but I
thought SPE buffer data could be written out in whacky ways such that even
a bog-standard page fault could result in uncoverable data loss (i.e. DL=1),
and so pinning is the only game in town.

A funkier approach might be to defer pinning of the buffer until the SPE is
enabled and avoid pinning all of VM memory that way, although I can't
immediately tell how flexible the architecture is in allowing you to cache
the base/limit values.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
