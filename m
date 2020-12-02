Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3979DC64E7B
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 17:24:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 958BA221E9
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 17:24:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 958BA221E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C96F74B40D;
	Wed,  2 Dec 2020 12:24:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JP3o4i1SIMpb; Wed,  2 Dec 2020 12:24:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCC0F4B385;
	Wed,  2 Dec 2020 12:24:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65BFF4B385
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 12:24:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fYNvR83mHvDu for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 12:24:00 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6BB44B346
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 12:23:59 -0500 (EST)
Date: Wed, 2 Dec 2020 17:23:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606929838;
 bh=V0R76wAcMBTseb7fEiuVbTmAEpHIR3O49CO3yXppN/I=;
 h=From:To:Cc:Subject:References:In-Reply-To:From;
 b=FcM3/E2OmXiVMI7VnOvHGhA0og08kaAC1vTFv+2+JyVbtr5S6dvvgr+tt72611V5u
 qg3cXulfjJtJpaBkyCifKgJLRAKGw6xUQfXXZ17081KXcA1NtDvhZFqm9Slhj8cfBI
 6JpUF4t3A2GONMWg5sVSPJgK3winpvI12tPcxCB0=
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [RFC PATCH v3 04/16] arm64: Introduce CPU SPE feature
Message-ID: <20201202172353.GB29813@willie-the-truck>
References: <20201027172705.15181-1-alexandru.elisei@arm.com>
 <20201027172705.15181-5-alexandru.elisei@arm.com>
 <418e3bf6-159c-6d1f-2b84-2fdb10c3cddd@arm.com>
 <906a02c2-3923-3542-ffb8-43d856498e07@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <906a02c2-3923-3542-ffb8-43d856498e07@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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

On Wed, Dec 02, 2020 at 02:29:31PM +0000, Alexandru Elisei wrote:
> On 11/19/20 4:58 PM, James Morse wrote:
> > On 27/10/2020 17:26, Alexandru Elisei wrote:
> >> Detect Statistical Profiling Extension (SPE) support using the cpufeatures
> >> framework. The presence of SPE is reported via the ARM64_SPE capability.
> >>
> >> The feature will be necessary for emulating SPE in KVM, because KVM needs
> >> that all CPUs have SPE hardware to avoid scheduling a VCPU on a CPU without
> >> support. For this reason, the feature type ARM64_CPUCAP_SYSTEM_FEATURE has
> >> been selected to disallow hotplugging a CPU which doesn't support SPE.
> > Can you mention the existing driver in the commit message? Surprisingly it doesn't use
> > cpufeature at all. It looks like arm_spe_pmu_dev_init() goes out of its way to support
> > mismatched systems. (otherwise the significance of the new behaviour isn't clear!)
> >
> > I read it as: the host is fine with mismatched systems, and the existing drivers supports
> > this. But KVM is not. After this patch you can't make the system mismatched 'late'.
> 
> That was exactly my intention. Certainly, I'll try to make the commit message
> clearer by mentioning the SPE driver.

Hmm, so are you saying that with this patch applied, a machine where KVM
isn't even being used can no longer late-online CPUs without SPE if the boot
CPUs had it? If so, then I don't think that's acceptable, unfortunately.

As James points out, the current driver is very careful to support
big.LITTLE misconfigurations and I don't see why KVM support should change
that.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
