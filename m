From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [Qemu-devel] [RFC/RFT PATCH v2 0/3] KVM: Introduce
 KVM_MEM_UNCACHED
Date: Fri, 15 May 2015 11:00:17 +0200
Message-ID: <CAKv+Gu8NBL5cySMw7rpRaYxSMJ-Bh2m2bocDd=nwhwGAS3w0mw@mail.gmail.com>
References: <5554893E.4030105@redhat.com> <20150514120039.GU32765@cbox>
 <55549051.1090007@redhat.com> <20150514122413.GV32765@cbox>
 <55549501.2010000@redhat.com>
 <CAFEAcA_OXHH2NmU6c=KB+DgRQS=+YYX4es+otjE_k0qzn+6+0Q@mail.gmail.com>
 <20150514130037.GB12812@localhost.localdomain>
 <5554A3DA.2070307@redhat.com>
 <20150514154327-mutt-send-email-mst@redhat.com>
 <5554AEEB.6040401@redhat.com>
 <20150514163942-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0FFD5162D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 04:51:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VSgWGF-V+vCv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 May 2015 04:51:07 -0400 (EDT)
Received: from mail-ie0-f180.google.com (mail-ie0-f180.google.com
 [209.85.223.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D5E551629
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 04:51:07 -0400 (EDT)
Received: by iesa3 with SMTP id a3so13016338ies.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 02:00:17 -0700 (PDT)
In-Reply-To: <20150514163942-mutt-send-email-mst@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 14 May 2015 at 16:41, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Thu, May 14, 2015 at 04:19:23PM +0200, Laszlo Ersek wrote:
>> On 05/14/15 15:48, Michael S. Tsirkin wrote:
>> > On Thu, May 14, 2015 at 03:32:10PM +0200, Laszlo Ersek wrote:
>> >> On 05/14/15 15:00, Andrew Jones wrote:
>> >>> On Thu, May 14, 2015 at 01:38:11PM +0100, Peter Maydell wrote:
>> >>>> On 14 May 2015 at 13:28, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> >>>>> Well, PCI BARs are generally MMIO resources, and hence should not be cached.
>> >>>>>
>> >>>>> As an optimization, OS drivers can mark them as cacheable or
>> >>>>> write-combining or something like that, but in general it's a safe
>> >>>>> default to leave them uncached---one would think.
>> >>>>
>> >>>> Isn't this handled by the OS mapping them in the 'prefetchable'
>> >>>> MMIO window rather than the 'non-prefetchable' one? (QEMU's
>> >>>> generic-PCIe device doesn't yet support the prefetchable window.)
>> >>>
>> >>> I was thinking (with my limited PCI knowledge) the same thing, and
>> >>> was planning on experimenting with that.
>> >>
>> >> This could be supported in UEFI as well, with the following steps:
>> >> - the DTB that QEMU provides UEFI with should advertise such a
>> >>   prefetchable window.
>> >> - The driver in UEFI that parses the DTB should understand that DTB
>> >>   node (well, record type), and store the appropriate base & size into
>> >>   some new dynamic PCDs (= basically, firmware wide global variables;
>> >>   PCD = platform configuration database)
>> >> - The entry point of the host bridge driver would call
>> >>   gDS->AddMemorySpace() twice, separately for the two different windows,
>> >>   with their appropriate caching attributes.
>> >> - The host bridge driver needs to be extended so that TypePMem32
>> >>   requests are not rejected (like now); they should be handled
>> >>   similarly to TypeMem32. Except, the gDS->AllocateMemorySpace() call
>> >>   should allocate from the prefetchable range (determined by the new
>> >>   PCDs above).
>> >> - QEMU's emulated devices should then expose their BARs as prefetchable
>> >>   (so that the above branch would be taken in the host bridge driver).
>> >>
>> >> (Of course, if QEMU intends to emulate PCI devices somewhat
>> >> realistically, then QEMU should claim "non-prefetchable" for BARs that
>> >> would not be prefetchable on physical hardware either, and then the
>> >> hypervisor should accommodate the firmware's UC mapping and say "hey I
>> >> know better, we're virtual in fact", and override the attribute (-> use
>> >> WB instead of UC). With which we'd be back to square one...)
>> >>
>> >> Thanks
>> >> Laszlo
>> >
>> > Prefetcheable is unrelated to BAR caching or drivers, it's a way to tell
>> > host bridges they can do limited tweaks to downstream transactions in a
>> > specific range.
>> >
>> > Really non-prefetcheable BARs are mostly those where read has
>> > side-effects, which is best avoided. this does not mean it's ok to
>> > reorder transactions or cache them.
>>
>> I believe I understood that (although certainly not in the depth that
>> you do), because when the idea had come up first (ie. equating cacheable
>> with prefetchable, or at least "repurposing" the latter for the former)
>> I had tried to read up on prefetchable (just on the web; no time for
>> reading the PCI spec. ... I peeked now, it also mentions "write merging"
>> for bridges.)
>
> Read up on what it is if you like, it is much weaker than WC not to
> mention cacheable.
>
>> The way I perceived it, the idea was to give the guest a
>> hint about caching with the prefetchable bit / DTB entry. Sorry if I was
>> mistaken.
>>
>> Thanks
>> Laszlo
>
> And what I am saying is that prefetchable bit would be a PV solution -
> on real devices it is not a hint about caching and can't be used as
> such.
>

On a general note, may I point out that while this discussion now
focuses heavily on PCI and its metadata that could potentially
describe the cached/uncached nature of a region, there are other
emulated devices that are affected as well. Most notably, there is the
emulated NOR flash which is backed by a read-only memslot while in
array mode, but treated as a device by the guest and hence mapped
uncached. Since the NOR flash contains the executable image of the
firmware (in case of UEFI), it must be backed by actual host RAM or
the CPU won't be able to fetch instructions from it (since instruction
fetches cannot be emulated like ordinary loads and stores). On the
other hand, since the guest treats it as a ROM, it is totally
oblivious of any caching concerns that may exist.
