Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B463AC4321E
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:21:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 281ED4B492;
	Wed, 30 Nov 2022 18:21:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9UioYSbvb8SV; Wed, 30 Nov 2022 18:21:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB16F4B4D7;
	Wed, 30 Nov 2022 18:21:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1B4E4B422
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:21:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NrcJE8TVSyML for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:21:21 -0500 (EST)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 918F14B3FB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:21:21 -0500 (EST)
Received: by mail-pj1-f48.google.com with SMTP id
 e7-20020a17090a77c700b00216928a3917so3483954pjs.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=oOrPD6CB7rqzyj1SaEV3kuD/IhDMhOZPI51nCiB/NGg=;
 b=ZRW2ZUTv1n147KoQiZQIoZW74j4A7EtjIYOcRFO0rF0DPUCmy6VUy2g0JuJ1nS/0PG
 bPSRbTqLAdAfhndt51DMfOPkb6sHyNfjGeyL8kdbar+k+xIpBX4SiQnfKVs3jxbhY30i
 fE+0B93J3f1zH3nafXrLqY7rdRuq0maSuVI9QpeW8enceqQk351ZWU6NHH/BazdCHb+E
 L5o+TvbdnPsX9MioomkdsvtUqYHZQq6KqAvnuPAuThxGPwZ++G4eWoki6stkyg4QcWza
 6l0SCQXCBclmuJYQ9VytxAYkOvwHCR0J4TrW1rGbFwPNrD/IzVnCsAgUxIa0vHOndA6A
 NTuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=oOrPD6CB7rqzyj1SaEV3kuD/IhDMhOZPI51nCiB/NGg=;
 b=BfuikHWqbB7SUcW3dEFMfJ6AN6HeJD5lQGNsPZU0HUEmLYwGSmCci3WvJPjA3MLppd
 X3EpSFxHNH6xy7GQJhVRlAFdpc1883CWybcVJel7LViDCcV24fdhKcSJONyOT1taY508
 dNcqYlYU8efMLboQf1eTgVRp2126oHxNwQt3A6W4OCs9u6Ve8uBJF4vaooSasNZJM6/k
 SX9bhJTwx6u/LpbogRzDbgz1osTCd+8FWTA5o7X/J5bdQ9KHhJrhkCzqQOdWrKi/l54E
 dXYAVX7vnStgKCcU4wJYxE6MP8ZgWrRLrrj/zhuRUiN2/Shpk5aEem7bOpuOmZ4l9SQ1
 GFOw==
X-Gm-Message-State: ANoB5pkIHmI+6bAM4bUZQ7/n16lMYE8BXgG4G70qIEOvycWmrlSGaNGh
 t/2GDaWRtn4vM4+iT9cMLQ5Zyg==
X-Google-Smtp-Source: AA0mqf7MFNPbEgt6osld/lAYA9wa6vF/JYI716/qDYMZhDxdPiOnFjxOBihEjXxstiNyC9WOq9G0Fg==
X-Received: by 2002:a17:90a:d24e:b0:218:b478:f44f with SMTP id
 o14-20020a17090ad24e00b00218b478f44fmr46173649pjw.232.1669850480496; 
 Wed, 30 Nov 2022 15:21:20 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 o13-20020a17090a0a0d00b0021896fa945asm3637054pjo.15.2022.11.30.15.21.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 30 Nov 2022 15:21:20 -0800 (PST)
Date: Wed, 30 Nov 2022 15:21:16 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/4] KVM: arm64: Don't serialize if the access flag isn't
 set
Message-ID: <Y4flbAiRyGgpDvnJ@google.com>
References: <20221129191946.1735662-1-oliver.upton@linux.dev>
 <20221129191946.1735662-3-oliver.upton@linux.dev>
 <Y4Zw/J3srTsZ57P7@google.com> <Y4Z2aWVEnluy+d3+@google.com>
 <Y4awiKLuKORZmU2z@google.com> <87pmd4ua2q.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87pmd4ua2q.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

On Wed, Nov 30, 2022 at 08:21:17AM +0000, Marc Zyngier wrote:
> On Wed, 30 Nov 2022 01:23:20 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Tue, Nov 29, 2022 at 09:15:21PM +0000, Oliver Upton wrote:
> > > Hi Ricardo,
> > > 
> > > Thanks for having a look.
> > > 
> > > On Tue, Nov 29, 2022 at 12:52:12PM -0800, Ricardo Koller wrote:
> > > > On Tue, Nov 29, 2022 at 07:19:44PM +0000, Oliver Upton wrote:
> > > 
> > > [...]
> > > 
> > > > > +	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> > > > > +				       &pte, NULL, 0);
> > > > > +	if (!ret)
> > > > > +		dsb(ishst);
> > > > 
> > > > At the moment, the only reason for stage2_update_leaf_attrs() to not
> > > > update the PTE is if it's not valid:
> > > > 
> > > > 	if (!kvm_pte_valid(pte))
> > > > 			return 0;
> > > > 
> > > > I guess you could check that as well:
> > > > 
> > > > +	if (!ret || kvm_pte_valid(pte))
> > > > +		dsb(ishst);
> > > 
> > > Thanks for catching this.
> > > 
> > > Instead of pivoting on the returned PTE value, how about we return
> > > -EAGAIN from the early return in stage2_attr_walker()? It would better
> > > match the pattern used elsewhere in the pgtable code.
> > 
> > That works, although I would use another return code (e.g., EINVAL)? as
> > that's not exactly a "try again" type of error.
> 
> EINVAL usually is an indication of something that went horribly wrong.
> 
> But is that really a failure mode? Here, failing to update the PTE
> should not be considered a failure, but just a benign race: access
> fault being taken on a CPU and the page being evicted on another (not
> unlikely, as the page was marked old before).

I see, I agree, what you describe not look like a failure.

> 
> And if I'm correct above, this is definitely a "try again" situation:
> you probably won't take the same type of fault the second time though.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
