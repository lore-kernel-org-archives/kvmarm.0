Return-Path: <SRS0=/TDH=74=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61146C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 14:18:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E285320644
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jun 2020 14:18:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E285320644
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AB384B0C7;
	Mon, 15 Jun 2020 10:18:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lMZhzZdIdHA9; Mon, 15 Jun 2020 10:18:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1047E4B09F;
	Mon, 15 Jun 2020 10:18:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A50D4B09F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 10:18:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xywxtoKow5mi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jun 2020 10:17:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1AE04B09C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jun 2020 10:17:59 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB5BC31B;
 Mon, 15 Jun 2020 07:17:58 -0700 (PDT)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1CA6A3F6CF;
 Mon, 15 Jun 2020 07:17:58 -0700 (PDT)
Date: Mon, 15 Jun 2020 15:17:56 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 0/4] KVM/arm64: Enable PtrAuth on non-VHE KVM
Message-ID: <20200615141755.GK25945@arm.com>
References: <20200615081954.6233-1-maz@kernel.org>
 <20200615125920.GJ25945@arm.com>
 <dd0e5196a4e7baf4d0f8fba2b00e9ef5@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <dd0e5196a4e7baf4d0f8fba2b00e9ef5@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On Mon, Jun 15, 2020 at 02:22:19PM +0100, Marc Zyngier wrote:
> Hi Dave,
> 
> On 2020-06-15 13:59, Dave Martin wrote:
> >On Mon, Jun 15, 2020 at 09:19:50AM +0100, Marc Zyngier wrote:
> >>Not having PtrAuth on non-VHE KVM (for whatever reason VHE is not
> >>enabled on a v8.3 system) has always looked like an oddity. This
> >>trivial series remedies it, and allows a non-VHE KVM to offer PtrAuth
> >>to its guests.
> >
> >How likely do you think it is that people will use such a configuration?
> 
> Depending on the use case, very. See below.
> 
> >The only reason I can see for people to build a kernel with CONFIG_VHE=n
> >is as a workaround for broken hardware, or because the kernel is too old
> >to support VHE (in which case it doesn't understand ptrauth either, so
> >it is irrelevant whether ptrauth depends on VHE).
> 
> Part of the work happening around running protected VMs (which cannot
> be tampered with from EL1/0 host) makes it mandatory to disable VHE,
> so that we can wrap the host EL1 in its own Stage-2 page tables.
> We (the Android kernel team) are actively working on enabling this
> feature.
> 
> >I wonder whether it's therefore better to "encourage" people to turn
> >VHE on by making subsequent features depend on it where appropriate.
> >We do want multiplatform kernels to be configured with CONFIG_VHE=y for
> >example.
> 
> I'm all for having VHE on for platforms that support it. Which is why
> CONFIG_VHE=y is present in defconfig. However, we cannot offer the same
> level of guarantee as we can hopefully achieve with non-VHE (we can
> drop mappings from Stage-1, but can't protect VMs from an evil or
> compromised host). This is a very different use case from the usual
> "reduced hypervisor overhead" that we want in the general case.
> 
> >I ask this, because SVE suffers the same "oddity".  If SVE can be
> >enabled for non-VHE kernels straightforwardly then there's no reason not
> >to do so, but I worried in the past that this would duplicate complex
> >code that would never be tested or used.
> 
> It is a concern. I guess that if we manage to get some traction on
> Android, then the feature will get some testing! And yes, SVE is
> next on my list.
> 
> >If supporting ptrauth with !VHE is as simple as this series suggests,
> >then it's low-risk.  Perhaps SVE isn't much worse.  I was chasing nasty
> >bugs around at the time the SVE KVM support was originally written, and
> >didn't want to add more unknowns into the mix...
> 
> I think having started with a slightly smaller problem space was the
> right thing to do at the time. We are now reasonably confident that
> KVM and SVE are working correctly together, and we can now try to enable
> it on !VHE.

Cool, now I understand.

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
