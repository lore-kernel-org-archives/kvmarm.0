Return-Path: <SRS0=jF9t=B7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B563C433DF
	for <kvmarm@archiver.kernel.org>; Fri, 21 Aug 2020 10:57:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B6EE120656
	for <kvmarm@archiver.kernel.org>; Fri, 21 Aug 2020 10:57:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="GK7uQDjR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6EE120656
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42AE44C4A3;
	Fri, 21 Aug 2020 06:57:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VM2qvbRrJg4z; Fri, 21 Aug 2020 06:56:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3643C4C498;
	Fri, 21 Aug 2020 06:56:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A97C94C495
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Aug 2020 06:56:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zDu6Eb5io01R for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Aug 2020 06:56:56 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD6E84C484
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Aug 2020 06:56:56 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1BB9D20656;
 Fri, 21 Aug 2020 10:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1598007415;
 bh=L2Q1UQmGppCsqc9wpsjy+PTNp8/7EQtdtd/k56eZFmo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=GK7uQDjR04si5FUeFUnvJdh2egeav92yMIKanXJOKzYhO0lBnVOfK32c3FlOWnKR1
 w5QnbBrEfJN7vKdj6df7FIZHqrRf73KCBdzY5sLzW72zi0IPlsRBQnD8aSjRzbjfV1
 hInzPib6E9k/ZIbQCmANF0KtCLd7aszBPxLrTykE=
Date: Fri, 21 Aug 2020 11:56:51 +0100
From: Will Deacon <will@kernel.org>
To: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v4 0/3] Cortex-A77 erratum 1508412 workaround
Message-ID: <20200821105650.GB20455@willie-the-truck>
References: <20200803193127.3012242-1-robh@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200803193127.3012242-1-robh@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Aug 03, 2020 at 01:31:24PM -0600, Rob Herring wrote:
> This series implements the work-around for Cortex-A77 erratum 1508412.
> KVM guests which don't implement the workaround can still deadlock the
> system. This is also the case with the existing Cortex-A57 erratum 832075,
> so we add a warning message if an erratum can cause deadlock.

For the series:

Acked-by: Will Deacon <will@kernel.org>

I'm a bit worried about how we'll get on maintaining this, given that we
need to make sure that all new users of read_sysreg(par_el1) use
read_sysreg_par() instead, but oh well.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
