Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 959E4C4708D
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 01:02:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10A454B930;
	Mon, 12 Dec 2022 20:02:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bU59vi+JOjYr; Mon, 12 Dec 2022 20:02:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0BCE4B931;
	Mon, 12 Dec 2022 20:02:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DDC24B92D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 20:02:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mzhRXktJBu4k for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 20:02:12 -0500 (EST)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1693D4B922
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 20:02:12 -0500 (EST)
Received: by mail-pl1-f172.google.com with SMTP id w23so13906846ply.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=6GqFhoQ5IFUAK9oX1MHOecDUK0USc3JCTx3X8yerj1o=;
 b=FtjwIkrUOBV2twjG7aSDbbD70cPG5TPStSgDCsNV45Bhmz74eNy+ozucvejg73x4O1
 Iohs4s0dpsdVjim7W9yTFCi/EcSDg8iCwzhlHWz1fotOSARecFpPQ4Hcfa3qQYCWl4fD
 i1NYMRChruL7+5L6pSJLJXVhu8QmidC5EEUqHA/lI7bch3t3TIv1aCN57q4l7rtPFYua
 FlWlimYfUfUgVCukMvVJuuDDKaWduMb0REZn22mFV2kYcjkEnorPqV83jL7/8bj0vUDj
 SOGbsMyi3efvpD/4Q6/fjpBXN88wAA6q87W5qjPxSb+fHE/weIam6vo+2qT/aO85DhR1
 U6LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=6GqFhoQ5IFUAK9oX1MHOecDUK0USc3JCTx3X8yerj1o=;
 b=Vyzj0tIbxRt+XoSB+p846ETIDZQ91vs4L5cJFsWffyv4Sxf4/PMEQ17/lp6AuR6n9s
 OXtju9VLZojeh6uPP81W6jLgvkleoHDW4QWa5BbrqYMwIyk4c1vf6GIz1H4YNxzTrvHC
 WSby8eXWlRkUvqgNPl5rUbuqxbEoJClRU0u68lVAvkITdb+H9KWRCjPSx+GvyAeOmAAO
 4xw9AUQDsfKtTJY9iKJoVqFDRUT5kJHjYGW/ixlmg91k9PvlzJUrToUBXsEFRIkvE7p4
 e/SbLnJjzBUjs4ghhIOSspNU8WIWDPN85Vr6TqTS2BwY1CuLylOVpc2eTXVbtsAtCNO6
 5Hsg==
X-Gm-Message-State: ANoB5pnt7Sfci1tGUoN+bbQfsLPsKP0VCB8Ru9ykOLT10tPBG0KyFc7D
 2uukwL9puWv265szt6XLsGrVkQ==
X-Google-Smtp-Source: AA0mqf6YEPI+D/p+C5vB/eTbMi0DUTnPh+gMPudwZTqoN9JqStWe3ScZcQMFez7S1hpnK/27SYk6nw==
X-Received: by 2002:a17:90b:394b:b0:218:7bf2:4ff2 with SMTP id
 oe11-20020a17090b394b00b002187bf24ff2mr62913pjb.0.1670893330943; 
 Mon, 12 Dec 2022 17:02:10 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 n15-20020a170903110f00b00186bc66d2cbsm7066219plh.73.2022.12.12.17.02.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 12 Dec 2022 17:02:10 -0800 (PST)
Date: Tue, 13 Dec 2022 01:02:06 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [RFC PATCH 20/37] KVM: x86/mmu: Abstract away computing the max
 mapping level
Message-ID: <Y5fPDqI7TBngeaj8@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-21-dmatlack@google.com>
 <CANgfPd-6LNdZ42tb0DnC21r1Z5JGR_1Lvvop8RKJJ8hEz+PUDg@mail.gmail.com>
 <CALzav=cashgJPmeKSRQnd_kdYg2EK0G4rygSCt6GaJWSYz3juw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALzav=cashgJPmeKSRQnd_kdYg2EK0G4rygSCt6GaJWSYz3juw@mail.gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Nadav Amit <namit@vmware.com>, Colin Cross <ccross@google.com>,
 Ben Gardon <bgardon@google.com>, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, Yu Zhao <yuzhao@google.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>,
 kvmarm@lists.linux.dev, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
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

On Mon, Dec 12, 2022, David Matlack wrote:
> On Mon, Dec 12, 2022 at 11:32 AM Ben Gardon <bgardon@google.com> wrote:
> >
> > On Thu, Dec 8, 2022 at 11:39 AM David Matlack <dmatlack@google.com> wrote:
> > >
> > > Abstract away kvm_mmu_max_mapping_level(), which is an x86-specific
> > > function for computing the max level that a given GFN can be mapped in
> > > KVM's page tables. This will be used in a future commit to enable moving
> > > the TDP MMU to common code.
> > >
> > > Provide a default implementation for non-x86 architectures that just
> > > returns the max level. This will result in more zapping than necessary
> > > when disabling dirty logging (i.e. less than optimal performance) but no
> > > correctness issues.
> >
> > Apologies if you already implemented it in a later patch in this
> > series, but would it not at least be possible to port
> > host_pfn_mapping_level to common code and check that?
> > I'm assuming, though I could be wrong, that all archs map GFNs with at
> > most a host page table granularity mapping.
> > I suppose that doesn't strictly need to be included in this series,
> > but it would be worth addressing in the commit description.
> 
> It's not implemented later in this series, but I agree it's something
> we should do. In fact, it's worth doing regardless of this series as a
> way to share more code across architectures (e.g. KVM/ARM has it's own
> version in arch/arm64/kvm/mmu.c:get_user_mapping_size()).

Ya, ARM converted to walking the host user page tables largely in response to
x86's conversion.  After x86 switched, ARM was left holding the bag that was
PageTransCompoundMap().

On a related topic, I'm guessing all the comments in transparent_hugepage_adjust()
about the code working _only_ for THP are stale.  Unless ARM support for HugeTLB
works differently, walking host user page tables should Just Work for all hugepage
types.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
