Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5A715B0
	for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 01:02:11 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id jn7so13902075plb.13
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 17:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=mcNtez6jYgSBORtXnslI/oRyuWQopBh+z4vRawIcbO2Yc1wh3u1RccHz+LnMEypZmD
         WO6MAb+ONSnu7O5aACChDchugQcouLxl1TpHLZ7v6mC7zDn10AvI479LJTrJh/eZmxGj
         1u1GuRqLLczuvLxFw5QvWU0OBZIAShkilFKCSQ7GxcxgWtzWhxUEJiVsnhB4sdsVPmOy
         o3oCIeI338C7J8dPnkNFQPqp14Z08QeJATozyDjPQU4pIIvW5m8tMGhUg8Abc9Itvmyk
         UzbEiaXsIFTxMDh5JzkMdvcjKAIIDgweBDyP1xDr23C1/y8J17cGKa6Xmpqy1hScF/5R
         PwsQ==
X-Gm-Message-State: ANoB5pmFXc7LueitrlYbxlIjNxmfLSOjr9wq2C9CjmFMFK847CRyJDx4
	Kiji3WW82H1dlt/mW5P64v5Zrg==
X-Google-Smtp-Source: AA0mqf6YEPI+D/p+C5vB/eTbMi0DUTnPh+gMPudwZTqoN9JqStWe3ScZcQMFez7S1hpnK/27SYk6nw==
X-Received: by 2002:a17:90b:394b:b0:218:7bf2:4ff2 with SMTP id oe11-20020a17090b394b00b002187bf24ff2mr62913pjb.0.1670893330943;
        Mon, 12 Dec 2022 17:02:10 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n15-20020a170903110f00b00186bc66d2cbsm7066219plh.73.2022.12.12.17.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 17:02:10 -0800 (PST)
Date: Tue, 13 Dec 2022 01:02:06 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Nadav Amit <namit@vmware.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
	Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Krish Sadhukhan <krish.sadhukhan@oracle.com>,
	Ricardo Koller <ricarkol@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org
Subject: Re: [RFC PATCH 20/37] KVM: x86/mmu: Abstract away computing the max
 mapping level
Message-ID: <Y5fPDqI7TBngeaj8@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-21-dmatlack@google.com>
 <CANgfPd-6LNdZ42tb0DnC21r1Z5JGR_1Lvvop8RKJJ8hEz+PUDg@mail.gmail.com>
 <CALzav=cashgJPmeKSRQnd_kdYg2EK0G4rygSCt6GaJWSYz3juw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=cashgJPmeKSRQnd_kdYg2EK0G4rygSCt6GaJWSYz3juw@mail.gmail.com>
Message-ID: <20221213010206.0QmLJ0pLiOuJLxt6G6D0HBipoPTUx2VOkBI-tNwGTA4@z>

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
