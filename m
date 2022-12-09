Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D12C04FDE
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 01:09:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F10814BA20;
	Thu,  8 Dec 2022 20:09:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iKHccf0ivif8; Thu,  8 Dec 2022 20:09:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B430B4BA13;
	Thu,  8 Dec 2022 20:09:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C7C44B9F7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 20:09:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XCiIMAWX-r2J for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 20:08:58 -0500 (EST)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AFB4C4B99E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 20:08:58 -0500 (EST)
Received: by mail-pj1-f44.google.com with SMTP id u5so3227528pjy.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 17:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=R0W5fcABi4X+T/jYwfg3acG+mAXpKXLqoOLMcVDvb94=;
 b=YriPTaeIiA+dLmTSSSXERGxZoMyfxJhoF2Q8RM1j7icfTqEwdCfNmwHRywZVksID9N
 yt3L9g633vwLWxIZEY1PievSOwRoolVjFuC2ekFqhXWDrbAgmSyOG8E61xcBei/0WmkD
 n3zTXHfaLve5+vNvZO0l7Nq5ja3MPhbw/Zy0/wgqCgHFNdKS3cxS/4qNYhNLqDue4ooc
 J5EXd9M3CGckvr5AeCg01H05bHqrWl9oIldXxZyKGqNhqjj4kHaNhCQp1c7egMM531/g
 0N6aof8FoDZ0/n1nLpXmasPJ3LYaX/UAhpwEXGBjpWrXiOyYtqQVHTcsdM7gm/cVbdTY
 W13w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=R0W5fcABi4X+T/jYwfg3acG+mAXpKXLqoOLMcVDvb94=;
 b=Ti3ggj+Mh/7sduUaHsM5hUcg9a1muzFbllaniKowKtx/HaTuVR5JoWzLpXYVWpA518
 kmE5ZtuRQWpSyXHyFVoc5PN49S4IqxSEm5LlmQDtELsTocZ1XzR0mFz/FTwaXAny6GMJ
 ISbyyYV90bygzrRVrt2j3YWdqnHcVzSWgIYKVgKkqb95o9+PmggYjwO+HHleQm4G1Fpa
 Udie2tp8q7jStFweA635aJ2BoFnTEao09tjEJm+omK41As0CBaJgg+yqGo0UOpjVsF2J
 4rPvjTSoYIM0YgtcnABbuDdqLqTJWuRCRTT9ygXsX6QgG7q/zdqxsWnmYcMl0j1FNFhm
 KzYQ==
X-Gm-Message-State: ANoB5pkDKkh+Vm2cuKckrf+lN/DisiiEmRiY2kUypaFjTlM5Mj+6eAfV
 ZdCFXbylbnF4dxKPq5EDNgHmCQ==
X-Google-Smtp-Source: AA0mqf7592VdpFGEsXHXafhoIIzr0OlDlMvX/sxUwlVGqoBDiQgVEZPiR3YzSXTZCX1tcoMfJ2vdoQ==
X-Received: by 2002:a17:902:d491:b0:189:858f:b5c0 with SMTP id
 c17-20020a170902d49100b00189858fb5c0mr1689887plg.0.1670548137442; 
 Thu, 08 Dec 2022 17:08:57 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 n6-20020a170902d2c600b00189e1522982sm51067plc.168.2022.12.08.17.08.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 08 Dec 2022 17:08:57 -0800 (PST)
Date: Fri, 9 Dec 2022 01:08:53 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH 2/4] KVM: selftests: Setup ucall after loading program
 into guest memory
Message-ID: <Y5KKpQSd8H88vDoH@google.com>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
 <20221207214809.489070-3-oliver.upton@linux.dev>
 <Y5EoZ5uwrTF3eSKw@google.com> <Y5EtMWuTaJk9I3Bd@google.com>
 <Y5EutGSjkRmdItQb@google.com> <Y5Exwzr6Ibmmthl0@google.com>
 <Y5IxNTKRnacfSsLt@google.com> <Y5I0paok+dvTtrkt@google.com>
 <Y5I/xiFMLVbpAZj+@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y5I/xiFMLVbpAZj+@google.com>
Cc: Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, kvmarm@lists.linux.dev,
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

On Thu, Dec 08, 2022, Ricardo Koller wrote:
> On Thu, Dec 08, 2022 at 07:01:57PM +0000, Sean Christopherson wrote:
> > On Thu, Dec 08, 2022, Ricardo Koller wrote:
> > > On Thu, Dec 08, 2022 at 12:37:23AM +0000, Oliver Upton wrote:
> > > > On Thu, Dec 08, 2022 at 12:24:20AM +0000, Sean Christopherson wrote:
> > > > > > Even still, that's just a kludge to make ucalls work. We have other
> > > > > > MMIO devices (GIC distributor, for example) that work by chance since
> > > > > > nothing conflicts with the constant GPAs we've selected in the tests.
> > > > > > 
> > > > > > I'd rather we go down the route of having an address allocator for the
> > > > > > for both the VA and PA spaces to provide carveouts at runtime.
> > > > > 
> > > > > Aren't those two separate issues?  The PA, a.k.a. memslots space, can be solved
> > > > > by allocating a dedicated memslot, i.e. doesn't need a carve.  At worst, collisions
> > > > > will yield very explicit asserts, which IMO is better than whatever might go wrong
> > > > > with a carve out.
> > > > 
> > > > Perhaps the use of the term 'carveout' wasn't right here.
> > > > 
> > > > What I'm suggesting is we cannot rely on KVM memslots alone to act as an
> > > > allocator for the PA space. KVM can provide devices to the guest that
> > > > aren't represented as memslots. If we're trying to fix PA allocations
> > > > anyway, why not make it generic enough to suit the needs of things
> > > > beyond ucalls?
> > > 
> > > One extra bit of information: in arm, IO is any access to an address (within
> > > bounds) not backed by a memslot. Not the same as x86 where MMIO are writes to
> > > read-only memslots.  No idea what other arches do.
> > 
> > I don't think that's correct, doesn't this code turn write abort on a RO memslot
> > into an io_mem_abort()?  Specifically, the "(write_fault && !writable)" check will
> > match, and assuming none the the edge cases in the if-statement fire, KVM will
> > send the write down io_mem_abort().
> 
> You are right. In fact, page_fault_test checks precisely that: writes on
> RO memslots are sent to userspace as an mmio exit. I was just referring
> to the MMIO done for ucall.

To clarify for others, Ricardo thought that x86 selftests were already using a
read-only memslot for ucalls, hence the confusion.

> Having said that, we could use ucall as writes on read-only memslots
> like what x86 does.

+1.  x86 currently uses I/O with a hardcoded port, but theoretically that's just
as error prone as hardcoding a GPA, it just works because x86 doesn't have any
port I/O tests.

Ugh, and that made me look at sync_regs_test.c, which does its own open coded
ucall.  That thing is probably working by dumb luck at this point.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
