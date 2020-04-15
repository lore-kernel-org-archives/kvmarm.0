Return-Path: <SRS0=fBez=57=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A655C2BA19
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 10:14:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A43F820784
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 10:14:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kkl3LAbh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A43F820784
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BAE24B11E;
	Wed, 15 Apr 2020 06:14:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1pnFNaAFZ9GS; Wed, 15 Apr 2020 06:14:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BE1B4B257;
	Wed, 15 Apr 2020 06:14:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 588AF4B252
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 06:14:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SVaEYkIx1hCp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Apr 2020 06:14:51 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 43DDE4B11E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 06:14:51 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6205720775;
 Wed, 15 Apr 2020 10:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586945690;
 bh=Ewe88LkPUS4nDP5Snumb3J4za5bNTQxjgtEZIyIztSo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Kkl3LAbhH971rT3Xs2uaG7Qc+MzCHl/Er5SfyO2GRjpi48vKSiZYzeVByfeEmfaQi
 sldSSCkeeqEbyKQbDyhJ/fqSzw51uj802Xt9qlxBt7KgIeNTyL1vaXj9HEkBPzk92R
 HvSpTRRNTIh7aeiIK8grfDhBjW97uTkH90J1t0cA=
Date: Wed, 15 Apr 2020 11:14:44 +0100
From: Will Deacon <will@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 3/8] arm64: cpufeature: Add CPU capability for AArch32
 EL1 support
Message-ID: <20200415101444.GC12621@willie-the-truck>
References: <20200414213114.2378-1-will@kernel.org>
 <20200414213114.2378-4-will@kernel.org>
 <a83a19eb-9051-0a43-0bac-353f67d93d79@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a83a19eb-9051-0a43-0bac-353f67d93d79@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: saiprakash.ranjan@codeaurora.org, anshuman.khandual@arm.com, maz@kernel.org,
 linux-kernel@vger.kernel.org, dianders@chromium.org, catalin.marinas@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Wed, Apr 15, 2020 at 11:13:54AM +0100, Suzuki K Poulose wrote:
> On 04/14/2020 10:31 PM, Will Deacon wrote:
> > Although we emit a "SANITY CHECK" warning and taint the kernel if we
> > detect a CPU mismatch for AArch32 support at EL1, we still online the
> > CPU with disastrous consequences for any running 32-bit VMs.
> > 
> > Introduce a capability for AArch32 support at EL1 so that late onlining
> > of incompatible CPUs is forbidden.
> > 
> > Signed-off-by: Will Deacon <will@kernel.org>
> 
> One of the other important missing sanity check for KVM is the VMID width
> check. I will code something up.

Cheers! Do we handle things like the IPA size already?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
