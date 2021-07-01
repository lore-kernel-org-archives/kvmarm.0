Return-Path: <SRS0=4KxT=LZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9BEC11F69
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 12:56:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8036461402
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 12:56:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8036461402
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F336E4A531;
	Thu,  1 Jul 2021 08:56:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3B7fmh4DEpFE; Thu,  1 Jul 2021 08:56:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C797F4A483;
	Thu,  1 Jul 2021 08:56:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DBF14A483
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 08:56:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q38i2qzSIftO for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jul 2021 08:56:05 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CC3540895
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 08:56:05 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDA2761402;
 Thu,  1 Jul 2021 12:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1625144164;
 bh=2F2NkJoy0oC8PHuVSSObVqxbVRioQcbYvBDlNtzhQUg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=scI6StJMAeja2JMW7wsaNAzjL6k4BJUEBXroLKiuOp9x+YKh/N6CBQmg9UEH6vTgd
 AXNjSsGNnqR0FrU9zPwDyGra9FClBhvaXgqH/FyD6j3aAdPXq/iP4N7VHMtsp4lcuj
 Myd2zKbaak1DSeVRzluoLbpNEkEt8i8GtDCL7GeAxWquuc3gLk5RTbqu0ImGCdv5tk
 zTRKpzMGUvL4YhZU0oXBI0O9ZeA44vjViN8qNHnITrmzu45Y9cg1SxU1HLUFKQJ7Eg
 SuzF8EeKAEnaXog8KiWmFgQsC+E57EnSkJj+Q2qYfCGnWE7veKZwh5v8ji+sEIgfZc
 mwAAF91T7p1bw==
Date: Thu, 1 Jul 2021 13:55:58 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 01/13] KVM: arm64: Remove trailing whitespace in
 comments
Message-ID: <20210701125558.GB9757@willie-the-truck>
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-2-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210615133950.693489-2-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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

On Tue, Jun 15, 2021 at 02:39:38PM +0100, Fuad Tabba wrote:
> Editing this file later, and my editor always cleans up trailing
> whitespace. Removing it earler for clearer future patches.

s/earler/earlier/

Although the commit message is probably better as:

  "Remove trailing whitespace from comment in trap_dbgauthstatus_el1()."

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
