Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63BB3C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 14:22:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E72AE2463C
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 14:22:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E72AE2463C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5669C4B4EE;
	Mon, 26 Oct 2020 10:22:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gj-H6JX4j1V5; Mon, 26 Oct 2020 10:22:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 509C04B4AC;
	Mon, 26 Oct 2020 10:22:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA7DC4B3BC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 10:22:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w2PdPu7d7Tgu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 10:22:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C57154B328
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 10:22:49 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 74CB130E;
 Mon, 26 Oct 2020 07:22:49 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.56.187])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2995B3F68F;
 Mon, 26 Oct 2020 07:22:47 -0700 (PDT)
Date: Mon, 26 Oct 2020 14:22:45 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 01/11] KVM: arm64: Don't adjust PC on SError during SMC
 trap
Message-ID: <20201026142245.GI12454@C02TD0UTHF1T.local>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-2-maz@kernel.org>
 <20201026135308.GC12454@C02TD0UTHF1T.local>
 <b85f3ed6b97944055eda7f4bfeae8abc@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b85f3ed6b97944055eda7f4bfeae8abc@kernel.org>
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Oct 26, 2020 at 02:08:35PM +0000, Marc Zyngier wrote:
> On 2020-10-26 13:53, Mark Rutland wrote:
> > Assuming that there is no 16-bit HVC:
> 
> It is actually impossible to have a 16bit encoding for HVC, as
> it always convey a 16bit immediate, and you need some space
> to encode the instruction itself!

Ah, of course!

Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
