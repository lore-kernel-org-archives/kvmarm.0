Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 927B2C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 12:30:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0404361164
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 12:30:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0404361164
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 707E04B0DD;
	Thu, 23 Sep 2021 08:30:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R0CIbE-XHhAf; Thu, 23 Sep 2021 08:30:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 333A54B121;
	Thu, 23 Sep 2021 08:30:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17C814B11C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 08:29:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BJuWH+UdVKvE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 08:29:57 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FC5C4B0DD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 08:29:57 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id F093360F4C;
 Thu, 23 Sep 2021 12:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1632400195;
 bh=uqoHNJZa5TDP6HzkFMXYQIAfDgwMyi+BklxRbf1mwI8=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Dg8W5tH8ns8G/i3eAoa9nCc8EYzqPl/Z9D/bmN3WkWuhVnXvHTp4pSprko8d40rCc
 gJ+/d0cMy2/AuiB3eQjMLyCyNYf4HAqFPDkE5snNCJ4Hi5MnFDiVHmgBKobAhBPH2t
 kGmcRF1gxyYNW47tRURmyguPT1ilxw0uWD1DWEVB8nc2pC4mUb+knHix1V2stGfS3i
 fRkFPR3rZAMR97GsCCVPmwfY08AHV7lSEXZvaWCJqyRI4+K5uLKs0rScOUCTX/jK/8
 QCj3Trok0/3ZsgnA9JYpCFuD643sEWPgr17hudnhI7HimHTTZD3/x7KRk0qtm016QD
 e3eZnu4lnqrXQ==
Date: Thu, 23 Sep 2021 13:29:51 +0100
From: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 1/5] arm64: Prevent kexec and hibernation if
 is_protected_kvm_enabled()
Message-ID: <20210923122951.GA15860@willie-the-truck>
References: <20210923112256.15767-1-will@kernel.org>
 <20210923112256.15767-2-will@kernel.org>
 <20210923114506.GB14893@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210923114506.GB14893@C02TD0UTHF1T.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>
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

On Thu, Sep 23, 2021 at 12:45:06PM +0100, Mark Rutland wrote:
> On Thu, Sep 23, 2021 at 12:22:52PM +0100, Will Deacon wrote:
> > When pKVM is enabled, the hypervisor code at EL2 and its data structures
> > are inaccessible to the host kernel and cannot be torn down or replaced
> > as this would defeat the integrity properies which pKVM aims to provide.
> > Furthermore, the ABI between the host and EL2 is flexible and private to
> > whatever the current implementation of KVM requires and so booting a new
> > kernel with an old EL2 component is very likely to end in disaster.
> > 
> > In preparation for uninstalling the hyp stub calls which are relied upon
> > to reset EL2, disable kexec and hibernation in the host when protected
> > KVM is enabled.
> > 
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kernel/smp.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> > index 6f6ff072acbd..44369b99a57e 100644
> > --- a/arch/arm64/kernel/smp.c
> > +++ b/arch/arm64/kernel/smp.c
> > @@ -1128,5 +1128,6 @@ bool cpus_are_stuck_in_kernel(void)
> >  {
> >  	bool smp_spin_tables = (num_possible_cpus() > 1 && !have_cpu_die());
> >  
> > -	return !!cpus_stuck_in_kernel || smp_spin_tables;
> > +	return !!cpus_stuck_in_kernel || smp_spin_tables ||
> > +		is_protected_kvm_enabled();
> >  }
> 
> IIUC you'll also need to do something to prevent kdump, since even with
> CPUs stuck in the kernel that will try to do a kexec on the crashed CPU
> and __cpu_soft_restart() won't be able to return to EL2.
> 
> You could fiddle with the BUG_ON() in machine_kexec() to die in this
> case too.

I wondered about that, and I'm happy to do it if you reckon it's better,
but if the host is crashing _anyway_ then I wasn't convinced it was worth
the effort. With the approach here, we'll WARN and then enter the kdump
kernel at EL1 which maybe might work sometimes possibly? I suppose if the
kdump kernel is careful about the memory it accesses, then it has a
fighting chance of doing something useful.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
