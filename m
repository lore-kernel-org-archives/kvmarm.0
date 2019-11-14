Return-Path: <SRS0=Zv6D=ZG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12EC6C432C3
	for <kvmarm@archiver.kernel.org>; Thu, 14 Nov 2019 14:17:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 90355206DB
	for <kvmarm@archiver.kernel.org>; Thu, 14 Nov 2019 14:17:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90355206DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC26D4AED4;
	Thu, 14 Nov 2019 09:17:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZBRNpcXc79KW; Thu, 14 Nov 2019 09:17:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD1124AEC4;
	Thu, 14 Nov 2019 09:17:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE20F4AEBD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Nov 2019 09:17:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oalZ2eWkZ4pv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Nov 2019 09:17:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BADA34AEBC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Nov 2019 09:17:51 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44BE730E;
 Thu, 14 Nov 2019 06:17:51 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1736A3F52E;
 Thu, 14 Nov 2019 06:17:49 -0800 (PST)
Date: Thu, 14 Nov 2019 14:17:45 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [kvm-unit-tests PATCH 09/17] arm: gic: Add test for flipping
 GICD_CTLR.DS
Message-ID: <20191114141745.32d3b89c@donnerap.cambridge.arm.com>
In-Reply-To: <7ca57a0c-3934-1778-e3f9-a3eee0658002@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-10-andre.przywara@arm.com>
 <2e14ccd4-89f4-aa90-cc58-bebf0e2eeede@arm.com>
 <7ca57a0c-3934-1778-e3f9-a3eee0658002@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, 14 Nov 2019 13:39:33 +0000
Vladimir Murzin <vladimir.murzin@arm.com> wrote:

> Hi,
> 
> On 11/12/19 4:42 PM, Alexandru Elisei wrote:
> > Are we not testing KVM? Why are we not treating a behaviour different than what
> > KVM should emulate as a fail?
> 
> Can kvm-unit-tests be run with qemu TCG?

Yes, it does that actually by default if you cross compile. I also tested this explicitly on TCG: unlike KVM that actually passes all those tests.
If you set the environment variable ACCEL to either tcg or kvm, you can select this at runtime:
$ ACCEL=tcg arm/run arm/gic.flat -smp 3 -append irq

Cheers,
Andre
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
