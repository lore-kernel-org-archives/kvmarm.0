From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Wed, 4 Mar 2015 12:50:57 +0100
Message-ID: <CAKv+Gu8OUtcpaQh5+gb6vNrdi+Q7eu_zKOujmyoRPrzrs+GJVQ@mail.gmail.com>
References: <CAKv+Gu8Je3RRrgEFCZ7JUWtOgk3WqA_qdBEOPAMc3OqnKr1bwg@mail.gmail.com>
 <20150219175518.GB26965@hawk.usersys.redhat.com>
 <54E62404.9040702@redhat.com>
 <20150220142905.GA10942@hawk.usersys.redhat.com>
 <CAKv+Gu-YUzmnACZQi98OPRgKKL+gAGqwWYq2-_dwCdNqcktNUg@mail.gmail.com>
 <20150220153626.GB10942@hawk.usersys.redhat.com>
 <20150224145529.GA5498@hawk.usersys.redhat.com>
 <CAKv+Gu-Uk2wg1OkoWgQe4da_EiFoEz_u8VuD8Ees6qU1UYMDvQ@mail.gmail.com>
 <20150302163146.GB9686@lvm> <54F51A63.4060302@samsung.com>
 <20150304113505.GS28951@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE612479B0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 06:44:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KAzWzkg4pVLX for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2015 06:44:56 -0500 (EST)
Received: from mail-ig0-f182.google.com (mail-ig0-f182.google.com
 [209.85.213.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA1F6479AE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 06:44:55 -0500 (EST)
Received: by igdh15 with SMTP id h15so35786650igd.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Mar 2015 03:50:58 -0800 (PST)
In-Reply-To: <20150304113505.GS28951@e104818-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 4 March 2015 at 12:35, Catalin Marinas <catalin.marinas@arm.com> wrote:
> (please try to avoid top-posting)
>
> On Mon, Mar 02, 2015 at 06:20:19PM -0800, Mario Smarduch wrote:
>> On 03/02/2015 08:31 AM, Christoffer Dall wrote:
>> > However, my concern with these patches are on two points:
>> >
>> > 1. It's not a fix-all.  We still have the case where the guest expects
>> > the behavior of device memory (for strong ordering for example) on a RAM
>> > region, which we now break.  Similiarly this doesn't support the
>> > non-coherent DMA to RAM region case.
>> >
>> > 2. While the code is probably as nice as this kind of stuff gets, it
>> > is non-trivial and extremely difficult to debug.  The counter-point here
>> > is that we may end up handling other stuff at EL2 for performanc reasons
>> > in the future.
>> >
>> > Mainly because of point 1 above, I am leaning to thinking userspace
>> > should do the invalidation when it knows it needs to, either through KVM
>> > via a memslot flag or through some other syscall mechanism.
>
> I expressed my concerns as well, I'm definitely against merging this
> series.
>

Don't worry, that was never the intention, at least not as-is :-)

I think we have established that the performance hit is not the
problem but the correctness is.

I do have a remaining question, though: my original [non-working]
approach was to replace uncached mappings with write-through
read-allocate write-allocate, which I expected would keep the caches
in sync with main memory, but apparently I am misunderstanding
something here. (This is the reason for s/0xbb/0xff/ in patch #2 to
get it to work: it replaces WT/RA/WA with WB/RA/WA)

Is there no way to use write-through caching here?

>> I don't understand how can the CPU handle different cache attributes
>> used by QEMU and Guest won't you run into B2.9 checklist? Wouldn't
>> cache evictions or cleans wipe out guest updates to same cache
>> line(s)?
>
> "Clean+invalidate" is a safe operation even if the guest accesses the
> memory in a cacheable way. But if the guest can update the cache lines,
> Qemu should avoid cache maintenance from a performance perspective.
>
> The guest is either told that the DMA is coherent (via DT properties) or
> Qemu deals with (non-)coherency itself. The latter is fully in line with
> the B2.9 chapter in the ARM ARM, more precisely point 5:
>
>   If the mismatched attributes for a memory location all assign the same
>   shareability attribute to the location, any loss of uniprocessor
>   semantics or coherency within a shareability domain can be avoided by
>   use of software cache management.
>
> ... it continues with what kind of cache maintenance is required,
> together with:
>
>   A clean and invalidate instruction can be used instead of a clean
>   instruction, or instead of an invalidate instruction.
>
> --
> Catalin
