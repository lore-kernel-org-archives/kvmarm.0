From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Wed, 4 Mar 2015 11:35:06 +0000
Message-ID: <20150304113505.GS28951@e104818-lin.cambridge.arm.com>
References: <CAKv+Gu8Je3RRrgEFCZ7JUWtOgk3WqA_qdBEOPAMc3OqnKr1bwg@mail.gmail.com>
 <20150219175518.GB26965@hawk.usersys.redhat.com>
 <54E62404.9040702@redhat.com>
 <20150220142905.GA10942@hawk.usersys.redhat.com>
 <CAKv+Gu-YUzmnACZQi98OPRgKKL+gAGqwWYq2-_dwCdNqcktNUg@mail.gmail.com>
 <20150220153626.GB10942@hawk.usersys.redhat.com>
 <20150224145529.GA5498@hawk.usersys.redhat.com>
 <CAKv+Gu-Uk2wg1OkoWgQe4da_EiFoEz_u8VuD8Ees6qU1UYMDvQ@mail.gmail.com>
 <20150302163146.GB9686@lvm>
 <54F51A63.4060302@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54F51A63.4060302@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, KVM devel mailing list <kvm@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

(please try to avoid top-posting)

On Mon, Mar 02, 2015 at 06:20:19PM -0800, Mario Smarduch wrote:
> On 03/02/2015 08:31 AM, Christoffer Dall wrote:
> > However, my concern with these patches are on two points:
> > 
> > 1. It's not a fix-all.  We still have the case where the guest expects
> > the behavior of device memory (for strong ordering for example) on a RAM
> > region, which we now break.  Similiarly this doesn't support the
> > non-coherent DMA to RAM region case.
> > 
> > 2. While the code is probably as nice as this kind of stuff gets, it
> > is non-trivial and extremely difficult to debug.  The counter-point here
> > is that we may end up handling other stuff at EL2 for performanc reasons
> > in the future.
> > 
> > Mainly because of point 1 above, I am leaning to thinking userspace
> > should do the invalidation when it knows it needs to, either through KVM
> > via a memslot flag or through some other syscall mechanism.

I expressed my concerns as well, I'm definitely against merging this
series.

> I don't understand how can the CPU handle different cache attributes
> used by QEMU and Guest won't you run into B2.9 checklist? Wouldn't
> cache evictions or cleans wipe out guest updates to same cache
> line(s)?

"Clean+invalidate" is a safe operation even if the guest accesses the
memory in a cacheable way. But if the guest can update the cache lines,
Qemu should avoid cache maintenance from a performance perspective.

The guest is either told that the DMA is coherent (via DT properties) or
Qemu deals with (non-)coherency itself. The latter is fully in line with
the B2.9 chapter in the ARM ARM, more precisely point 5:

  If the mismatched attributes for a memory location all assign the same
  shareability attribute to the location, any loss of uniprocessor
  semantics or coherency within a shareability domain can be avoided by
  use of software cache management.

... it continues with what kind of cache maintenance is required,
together with:

  A clean and invalidate instruction can be used instead of a clean
  instruction, or instead of an invalidate instruction.

-- 
Catalin
