Return-Path: <SRS0=/TDH=74=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422B6C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 12:59:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C28F82076A
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 12:59:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C28F82076A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1982D4B09B;
	Mon, 15 Jun 2020 08:59:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eyiExMBx8KrD; Mon, 15 Jun 2020 08:59:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EC164B09F;
	Mon, 15 Jun 2020 08:59:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE9674B09B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 08:59:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 72BOXXL8CFNy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jun 2020 08:59:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71D074A4E5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 08:59:24 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E334431B;
 Mon, 15 Jun 2020 05:59:23 -0700 (PDT)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2461D3F6CF;
 Mon, 15 Jun 2020 05:59:23 -0700 (PDT)
Date: Mon, 15 Jun 2020 13:59:21 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 0/4] KVM/arm64: Enable PtrAuth on non-VHE KVM
Message-ID: <20200615125920.GJ25945@arm.com>
References: <20200615081954.6233-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200615081954.6233-1-maz@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

On Mon, Jun 15, 2020 at 09:19:50AM +0100, Marc Zyngier wrote:
> Not having PtrAuth on non-VHE KVM (for whatever reason VHE is not
> enabled on a v8.3 system) has always looked like an oddity. This
> trivial series remedies it, and allows a non-VHE KVM to offer PtrAuth
> to its guests.

How likely do you think it is that people will use such a configuration?

The only reason I can see for people to build a kernel with CONFIG_VHE=n
is as a workaround for broken hardware, or because the kernel is too old
to support VHE (in which case it doesn't understand ptrauth either, so
it is irrelevant whether ptrauth depends on VHE).

I wonder whether it's therefore better to "encourage" people to turn
VHE on by making subsequent features depend on it where appropriate.
We do want multiplatform kernels to be configured with CONFIG_VHE=y for
example.


I ask this, because SVE suffers the same "oddity".  If SVE can be
enabled for non-VHE kernels straightforwardly then there's no reason not
to do so, but I worried in the past that this would duplicate complex
code that would never be tested or used.

If supporting ptrauth with !VHE is as simple as this series suggests,
then it's low-risk.  Perhaps SVE isn't much worse.  I was chasing nasty
bugs around at the time the SVE KVM support was originally written, and
didn't want to add more unknowns into the mix...

(Note, this is not an offer from me to do the SVE work!)

[...]

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
