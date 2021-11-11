Return-Path: <SRS0=nF4w=P6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 494D1C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 10:48:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B133161267
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 10:48:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B133161267
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B58C4B20A;
	Thu, 11 Nov 2021 05:48:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u04fvlYY7ZoP; Thu, 11 Nov 2021 05:48:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3E5E4B1F6;
	Thu, 11 Nov 2021 05:48:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 776224B1F6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 05:48:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BK35rGF-2mwV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Nov 2021 05:48:50 -0500 (EST)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7DF5F4B1F5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 05:48:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=Lk4G/R3I07fhmcAqeSUqtCqNDck8UECisYgW0RP2fZk=; b=AET3uxMt3hHFzdG81TShZLlRhA
 lnzx4x2xkBejjcu8i+MuOlBWGAq82yBnQhP9jNhSKqzutZkvoPrE+DaFRBQ2JOb4j5DojW+YmB1TQ
 EZfc3k1Z3m4KXMajFbDtwS9023NbK50LztQbXevsdQvS6AOv4JY3DBFmFrzKqXOH+RV3M0pyTvPbI
 9sn7wEgLyUpWZTEsemou0MiLDGDeur8Ama9taCLIXAaN6Ru7/xY5zsA5qZdI+ad11Hfx7npvyG54r
 SstAvX6uYL3TOGkFqkoXYIn4TKwOJvn7Eki+iTRy2VOK059F6VHaZNIoBBTll1KF9xSh0wvNlGSuH
 NL6Mf2Yg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100]
 helo=noisy.programming.kicks-ass.net)
 by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1ml7ce-002eyR-My; Thu, 11 Nov 2021 10:48:01 +0000
Received: from hirez.programming.kicks-ass.net
 (hirez.programming.kicks-ass.net [192.168.1.225])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (Client did not present a certificate)
 by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CB96930001B;
 Thu, 11 Nov 2021 11:47:57 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
 id 950042D1ADCA5; Thu, 11 Nov 2021 11:47:57 +0100 (CET)
Date: Thu, 11 Nov 2021 11:47:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4 01/17] perf: Protect perf_guest_cbs with RCU
Message-ID: <YYz03fcDRV9NZnyA@hirez.programming.kicks-ass.net>
References: <20211111020738.2512932-1-seanjc@google.com>
 <20211111020738.2512932-2-seanjc@google.com>
 <d784dc27-72d0-d64f-e1f4-a2b9a5f86dd4@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d784dc27-72d0-d64f-e1f4-a2b9a5f86dd4@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Guo Ren <guoren@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Vincent Chen <deanbo422@gmail.com>, Will Deacon <will@kernel.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 Russell King <linux@armlinux.org.uk>, linux-csky@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Ingo Molnar <mingo@redhat.com>,
 Like Xu <like.xu.linux@gmail.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Zhu Lingshan <lingshan.zhu@intel.com>, Jiri Olsa <jolsa@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Greentime Hu <green.hu@gmail.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>, Like Xu <like.xu@linux.intel.com>,
 Nick Hu <nickhu@andestech.com>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Palmer Dabbelt <palmer@dabbelt.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Thu, Nov 11, 2021 at 08:26:58AM +0100, Paolo Bonzini wrote:
> On 11/11/21 03:07, Sean Christopherson wrote:

> >   EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
> >   int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
> >   {
> > -	perf_guest_cbs = NULL;
> > +	if (WARN_ON_ONCE(rcu_access_pointer(perf_guest_cbs) != cbs))
> > +		return -EINVAL;
> > +
> > +	rcu_assign_pointer(perf_guest_cbs, NULL);
> > +	synchronize_rcu();
> This technically could be RCU_INIT_POINTER but it's not worth a respin.
> There are dozens of other occurrences, and if somebody wanted they
> could use Coccinelle to fix all of them.

I've been pushing the other way, trying to get rid of RCU_INIT_POINTER()
since rcu_assign_pointer(, NULL) actualy DTRT per __builtin_constant_p()
etc.

There's a very few sites where we use RCU_INIT_POINTER() with a !NULL
argument, and those are 'special'.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
