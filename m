Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80AEFC433DB
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 16:59:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC20C65081
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 16:59:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC20C65081
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BB7A4B532;
	Fri,  5 Mar 2021 11:59:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j-I2jAFWUxCR; Fri,  5 Mar 2021 11:59:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8C704B4F0;
	Fri,  5 Mar 2021 11:59:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 175A24B4EF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 11:59:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AIsBPdCaIcDV for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 11:59:12 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25D134B328
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 11:59:12 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B31D64F1E;
 Fri,  5 Mar 2021 16:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614963551;
 bh=Anr2szlxokrML4bcZ0Hk4njlruTj6i3bBKAsz8Ik/i8=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ZUPrT4WrxDvcA5waC/JCToBDhp1Kk6d3fuhFTFtApJbxl0DgugRoL98HlHKCN+L7k
 tDU5jCwdV+7H8hoi0mdwLKsCb6Sb6+QgoyLpevCgAngM79HAAGqMdDWgx6G4KN1p0z
 3jQAWjeCtBm8z+uq76vuvHzUu3XyyM/ucb1oWgdgFZeql/ibvBWxASXsCw5Ya/5Bj9
 66KUukox4oZMKGGxtCD3+ISsnUhlVKb4PZPuMde71ut26Ojz2C/0qfpL0Lex4NeBt9
 /cwZFHGTuCvZyl0jAguHl1gtlz88pIRcTXtKzXA0H3PgovHmIkSq6dLJSpA1aSfQur
 Wkmsn/I2oG+ZQ==
Date: Fri, 5 Mar 2021 16:59:05 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 28/32] KVM: arm64: Add kvm_pgtable_stage2_idmap_greedy()
Message-ID: <20210305165904.GA23172@willie-the-truck>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-29-qperret@google.com>
 <20210305143941.GA23017@willie-the-truck>
 <YEJISCQOHNbs363+@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YEJISCQOHNbs363+@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Fri, Mar 05, 2021 at 03:03:36PM +0000, Quentin Perret wrote:
> On Friday 05 Mar 2021 at 14:39:42 (+0000), Will Deacon wrote:
> > On Tue, Mar 02, 2021 at 02:59:58PM +0000, Quentin Perret wrote:
> > > +	/* Reduce the kvm_mem_range to a granule size */
> > > +	ret = __stage2_reduce_range(&data, range->end);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	/* Walk the range to check permissions and reduce further if needed */
> > > +	do {
> > > +		ret = kvm_pgtable_walk(pgt, range->start, range->end, &walker);
> > 
> > (we spent some time debugging an issue here and you spotted that you're
> > passing range->end instead of the size ;)
> 
> Yep, I have the fix applied locally, and ready to fly in v4 :)
> 
> > > +	} while (ret == -EAGAIN);
> > 
> > I'm a bit nervous about this loop -- what guarantees forward progress here?
> > Can we return to the host after a few tries instead?
> 
> -EAGAIN only happens when we've been able to successfully reduce the
> range to a potentially valid granule size. That can't happen infinitely.
> 
> We're guaranteed to fail when trying to reduce the range to a
> granularity smaller than PAGE_SIZE (the -EINVAL case of
> __stage2_reduce_range), which is indicative of a host memory abort in a
> page it should not access (because marked PROT_NONE for instance).

Can you compute an upper bound on the number of iterations based on the
number of page-table levels then? I'm just conscious that all of this is
effectively running with irqs disabled, and so being able to reason about
the amount of work we're going to do makes me much more comfortable.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
