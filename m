Return-Path: <SRS0=9OIH=S4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F23C43218
	for <kvmarm@archiver.kernel.org>; Fri, 26 Apr 2019 14:09:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C0119206C1
	for <kvmarm@archiver.kernel.org>; Fri, 26 Apr 2019 14:09:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0119206C1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 275F44A4AB;
	Fri, 26 Apr 2019 10:09:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hl3TVBUumXB4; Fri, 26 Apr 2019 10:09:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F348F4A389;
	Fri, 26 Apr 2019 10:09:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ED534A332
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Apr 2019 10:09:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L8hAxIUI9V82 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Apr 2019 10:09:36 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 002894A32E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Apr 2019 10:09:35 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4FC44A78;
 Fri, 26 Apr 2019 07:09:35 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 351133F5C1;
 Fri, 26 Apr 2019 07:09:34 -0700 (PDT)
Date: Fri, 26 Apr 2019 15:09:31 +0100
From: Will Deacon <will.deacon@arm.com>
To: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH kvmtool 00/16] Support PCI BAR configuration
Message-ID: <20190426140931.GC32062@fuggles.cambridge.arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Cc: Andre.Przywara@arm.com, Sami.Mujawar@arm.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190426140931.KzpTfYPZq3R5vwmQFq4xY4jUy5V0hnpap_pfX_Tz7X4@z>

On Thu, Mar 07, 2019 at 08:36:01AM +0000, Julien Thierry wrote:
> This series add support for guests writting to PCI BARs. Edk2 does this
> and is not aware of the "linux,pci-probe-only" property in the chosen node.
> 
> - Patches 1 to 3 do miscelaneous fixes

I've picked up these three fixes, but it looks like there are some
outstanding comments from Andre on some of the later patches.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
