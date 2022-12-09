Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD1F0C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 18:30:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 377A14B9C8;
	Fri,  9 Dec 2022 13:30:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1TQE4ivMLRIE; Fri,  9 Dec 2022 13:30:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 031964B8AB;
	Fri,  9 Dec 2022 13:30:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 766864B8AB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 13:30:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6BzryGG4DoJT for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2022 13:30:23 -0500 (EST)
Received: from out-202.mta0.migadu.com (out-202.mta0.migadu.com
 [91.218.175.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0F11B4B645
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 13:30:22 -0500 (EST)
Date: Fri, 9 Dec 2022 18:30:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1670610621;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Sp1A6UXIoqNJWGJtdonH4Zsm1F89DCGx3ZYcZ2op3bM=;
 b=jR4PiHfMsMGnm69Suf71e/70K7WEW4Ckwww6P2DbR1hvNOndJUptnkqHKMBTt6fIGBmQdr
 ov89mpeQhS51X1/M2mDXZLGgvayYnsNMKQf+C//bfr73BRyk9BbiZau9RKlj5+SRQzhmAd
 54D8anc79u/KgI2hxA84HnHQ8nsdRfk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: David Matlack <dmatlack@google.com>
Subject: Re: [RFC PATCH 23/37] KVM: MMU: Move VM-level TDP MMU state to
 struct kvm
Message-ID: <Y5N+s1BR7hacr8U/@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-24-dmatlack@google.com>
 <Y5NxCYz9XV3hgGYX@google.com>
 <CALzav=f-qDqJcvPEo1ZxxVizAE77crMFsbKUVif5B-mNgGEHyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALzav=f-qDqJcvPEo1ZxxVizAE77crMFsbKUVif5B-mNgGEHyQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Nadav Amit <namit@vmware.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, xu xin <cgel.zte@gmail.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Arnd Bergmann <arnd@arndb.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
 Colin Cross <ccross@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>
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

On Fri, Dec 09, 2022 at 09:57:15AM -0800, David Matlack wrote:
> On Fri, Dec 9, 2022 at 9:32 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > Hey David,
> >
> > On Thu, Dec 08, 2022 at 11:38:43AM -0800, David Matlack wrote:
> > > Move VM-level TDP MMU state to struct kvm so it can be accessed by
> > > common code in a future commit.
> > >
> > > No functional change intended.
> >
> > Could you instead introduce a structure to hold all of the MMU state and
> > stick that in struct kvm? If the goal is to eventually supersede all
> > uses of the arm64 pgtable library we are going to need the ability to
> > operate outside of a KVM VM context.
> 
> This patch does introduce a tdp_mmu struct to hold all of the TDP MMU
> state. Did you have something else in mind?

No, I'm just an idiot without caffeine. I read the patch then forgot
about it when reading the changelog. Sorry!

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
