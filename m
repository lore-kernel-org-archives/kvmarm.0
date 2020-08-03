Return-Path: <SRS0=KyyX=BN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB062C433E1
	for <kvmarm@archiver.kernel.org>; Mon,  3 Aug 2020 15:03:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 37D4920775
	for <kvmarm@archiver.kernel.org>; Mon,  3 Aug 2020 15:03:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="CSS0rPpK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37D4920775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D35EA4B4BB;
	Mon,  3 Aug 2020 11:03:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mNxTo0mek1le; Mon,  3 Aug 2020 11:03:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A072D4B37C;
	Mon,  3 Aug 2020 11:03:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB17D4B2D7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2020 11:03:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id heeUh8XeZ2aL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Aug 2020 11:03:38 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B9E04B2D3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Aug 2020 11:03:38 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 25E1820775;
 Mon,  3 Aug 2020 15:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596467016;
 bh=pW3bNjWyJcDiHAUU730IG4r/gQzncCYWSqpvkt9UiD4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=CSS0rPpKC1jCbHEdRNp9oUvzD8CN/BLw9wNHIX0gFxC5/Sx5/AqB6JJDsuBdZzyDg
 jDoIU5/0+OixUeWTMVGLkVcSeFsGoKWqZxrbHrONDLTjcZmuHpOhOb9KBkZspWxc/n
 /5miLhP0yDRMYVt8WEXMFHSJfjlNjurJfCqJJezg=
Date: Mon, 3 Aug 2020 16:03:32 +0100
From: Will Deacon <will@kernel.org>
To: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 3/3] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
Message-ID: <20200803150332.GA29247@willie-the-truck>
References: <20200717205233.903344-1-robh@kernel.org>
 <20200717205233.903344-4-robh@kernel.org>
 <20200729163800.GA24572@gaia>
 <20200730082227.GA24095@willie-the-truck>
 <CAL_JsqKhytox6+rbZBbkgs2=Zgh3ZtXeYyzjqSWF6Picn-c27A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAL_JsqKhytox6+rbZBbkgs2=Zgh3ZtXeYyzjqSWF6Picn-c27A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
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

On Fri, Jul 31, 2020 at 04:55:26PM -0600, Rob Herring wrote:
> On Thu, Jul 30, 2020 at 2:22 AM Will Deacon <will@kernel.org> wrote:
> >
> > On Wed, Jul 29, 2020 at 05:38:00PM +0100, Catalin Marinas wrote:
> > > On Fri, Jul 17, 2020 at 02:52:33PM -0600, Rob Herring wrote:
> > > > diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> > > > index ce3080834bfa..ce5b0d9b12bf 100644
> > > > --- a/arch/arm64/include/asm/kvm_hyp.h
> > > > +++ b/arch/arm64/include/asm/kvm_hyp.h
> > > > @@ -46,6 +46,17 @@
> > > >  #define read_sysreg_el2(r) read_sysreg_elx(r, _EL2, _EL1)
> > > >  #define write_sysreg_el2(v,r)      write_sysreg_elx(v, r, _EL2, _EL1)
> > > >
> > > > +static inline u64 __hyp_text read_sysreg_par(void)
> > > > +{
> > > > +   u64 par;
> > > > +   if (cpus_have_const_cap(ARM64_WORKAROUND_1508412))
> > > > +           dmb(sy);
> > > > +   par = read_sysreg(par_el1);
> > > > +   if (cpus_have_const_cap(ARM64_WORKAROUND_1508412))
> > > > +           dmb(sy);
> > > > +   return par;
> > > > +}
> > >
> > > Even if that's not always called on a critical path, I agree with Andrew
> > > that we could use alternatives here for dmb(sy).
> >
> > Even then, I'm not sure how this helps if the CPU can speculatively branch
> > to the PAR access without executing the DMB. Is that not possible on A77?
> 
> I'm told by the h/w folks speculation is not possible in this case.

Thanks. Could you add a comment to that effect, please?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
