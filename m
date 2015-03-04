From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Wed, 4 Mar 2015 14:29:44 +0000
Message-ID: <20150304142943.GU28951@e104818-lin.cambridge.arm.com>
References: <20150220153626.GB10942@hawk.usersys.redhat.com>
 <20150224145529.GA5498@hawk.usersys.redhat.com>
 <CAKv+Gu-Uk2wg1OkoWgQe4da_EiFoEz_u8VuD8Ees6qU1UYMDvQ@mail.gmail.com>
 <20150302163146.GB9686@lvm>
 <54F51A63.4060302@samsung.com>
 <20150304113505.GS28951@e104818-lin.cambridge.arm.com>
 <CAKv+Gu8OUtcpaQh5+gb6vNrdi+Q7eu_zKOujmyoRPrzrs+GJVQ@mail.gmail.com>
 <20150304122956.GT28951@e104818-lin.cambridge.arm.com>
 <CAKv+Gu-JnvXFzr-fpjZZ-zTt8hOSfGqefw69s+4JX2iu_6_BMw@mail.gmail.com>
 <20150304141212.GA5352@hawk.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150304141212.GA5352@hawk.usersys.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 04, 2015 at 03:12:12PM +0100, Andrew Jones wrote:
> On Wed, Mar 04, 2015 at 01:43:02PM +0100, Ard Biesheuvel wrote:
> > On 4 March 2015 at 13:29, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > On Wed, Mar 04, 2015 at 12:50:57PM +0100, Ard Biesheuvel wrote:
> > >> I think we have established that the performance hit is not the
> > >> problem but the correctness is.
> > >
> > > I haven't looked at the performance figures but has anyone assessed the
> > > hit caused by doing cache maintenance in Qemu vs cacheable guest
> > > accesses (and no maintenance)?
> 
> I'm working on a PoC of a QEMU/KVM cache maintenance approach now.
> Hopefully I'll send it out this evening. Tomorrow at the latest.
> Getting numbers of that approach vs. a guest's use of cached memory
> for devices would take a decent amount of additional work, so won't
> be part of that post.

OK.

> I'm actually not sure we should care about
> the numbers for a guest using normal mem attributes for device
> memory - other than out of curiosity. For correctness this issue
> really needs to be solved 100% host-side. We can't rely on a
> guest to do different/weird things, just because it's a guest.
> Ideally guests don't even know that they're guests. (Even if we
> describe the memory as cache-able to the guest, I don't think we
> can rely on the guest believing us.)

I disagree it is 100% a host-side issue. It is a host-side issue _if_
the host tells the guest that the (virtual) device is non-coherent (or,
more precisely, it does not explicitly tell the guest that the device is
coherent). If the guest thinks the (virtual) device is non-coherent
because of information passed by the host, I fully agree that the host
needs to manage the cache coherency.

However, the host could also pass a "dma-coherent" property in the DT
given to the guest and avoid any form of cache maintenance. If the guest
does not honour such coherency property, it's a guest problem and it
needs fixing in the guest. This isn't any different from a real physical
device behaviour.

(there are counter arguments for the latter as well like emulating old
platforms that never had coherency but from a performance/production
perspective, I strongly recommend that guests are passed the
"dma-coherent" property for such virtual devices)

-- 
Catalin
