From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Wed, 4 Mar 2015 12:29:57 +0000
Message-ID: <20150304122956.GT28951@e104818-lin.cambridge.arm.com>
References: <54E62404.9040702@redhat.com>
 <20150220142905.GA10942@hawk.usersys.redhat.com>
 <CAKv+Gu-YUzmnACZQi98OPRgKKL+gAGqwWYq2-_dwCdNqcktNUg@mail.gmail.com>
 <20150220153626.GB10942@hawk.usersys.redhat.com>
 <20150224145529.GA5498@hawk.usersys.redhat.com>
 <CAKv+Gu-Uk2wg1OkoWgQe4da_EiFoEz_u8VuD8Ees6qU1UYMDvQ@mail.gmail.com>
 <20150302163146.GB9686@lvm>
 <54F51A63.4060302@samsung.com>
 <20150304113505.GS28951@e104818-lin.cambridge.arm.com>
 <CAKv+Gu8OUtcpaQh5+gb6vNrdi+Q7eu_zKOujmyoRPrzrs+GJVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8OUtcpaQh5+gb6vNrdi+Q7eu_zKOujmyoRPrzrs+GJVQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Mario Smarduch <m.smarduch@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 04, 2015 at 12:50:57PM +0100, Ard Biesheuvel wrote:
> On 4 March 2015 at 12:35, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Mon, Mar 02, 2015 at 06:20:19PM -0800, Mario Smarduch wrote:
> >> On 03/02/2015 08:31 AM, Christoffer Dall wrote:
> >> > However, my concern with these patches are on two points:
> >> >
> >> > 1. It's not a fix-all.  We still have the case where the guest expects
> >> > the behavior of device memory (for strong ordering for example) on a RAM
> >> > region, which we now break.  Similiarly this doesn't support the
> >> > non-coherent DMA to RAM region case.
> >> >
> >> > 2. While the code is probably as nice as this kind of stuff gets, it
> >> > is non-trivial and extremely difficult to debug.  The counter-point here
> >> > is that we may end up handling other stuff at EL2 for performanc reasons
> >> > in the future.
> >> >
> >> > Mainly because of point 1 above, I am leaning to thinking userspace
> >> > should do the invalidation when it knows it needs to, either through KVM
> >> > via a memslot flag or through some other syscall mechanism.
> >
> > I expressed my concerns as well, I'm definitely against merging this
> > series.
> 
> Don't worry, that was never the intention, at least not as-is :-)

I wasn't worried, just wanted to make my position clearer ;).

> I think we have established that the performance hit is not the
> problem but the correctness is.

I haven't looked at the performance figures but has anyone assessed the
hit caused by doing cache maintenance in Qemu vs cacheable guest
accesses (and no maintenance)?

> I do have a remaining question, though: my original [non-working]
> approach was to replace uncached mappings with write-through
> read-allocate write-allocate,

Does it make sense to have write-through and write-allocate at the same
time? The write-allocate hint would probably be ignored as write-through
writes do not generate linefills.

> which I expected would keep the caches
> in sync with main memory, but apparently I am misunderstanding
> something here. (This is the reason for s/0xbb/0xff/ in patch #2 to
> get it to work: it replaces WT/RA/WA with WB/RA/WA)
> 
> Is there no way to use write-through caching here?

Write-through is considered non-cacheable from a write perspective when
it does not hit in the cache. AFAIK, it should still be able to hit
existing cache lines and evict. The ARM ARM states that cache cleaning
to _PoU_ is not required for coherency when the writes are to
write-through memory but I have to dig further into the PoC because
that's what we care about here.

What platform did you test it on? I can't tell what the behaviour of
system caches is. I know they intercept explicit cache maintenance by VA
but not sure what happens to write-through writes when they hit in the
system cache (are they evicted to RAM or not?). If such write-through
writes are only evicted to the point-of-unification, they won't work
since non-cacheable accesses go all the way to PoC.

I need to do more reading through the ARM ARM, it should be hidden
somewhere ;).

-- 
Catalin
