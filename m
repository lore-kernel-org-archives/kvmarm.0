From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Thu, 05 Mar 2015 18:43:36 +0100
Message-ID: <54F895C8.2070306@redhat.com>
References: <CAKv+Gu-JnvXFzr-fpjZZ-zTt8hOSfGqefw69s+4JX2iu_6_BMw@mail.gmail.com>
 <20150304141212.GA5352@hawk.usersys.redhat.com>
 <20150304142943.GU28951@e104818-lin.cambridge.arm.com>
 <54F73ACF.1090605@redhat.com>
 <20150304172855.GA28951@e104818-lin.cambridge.arm.com>
 <54F82C06.2000701@redhat.com>
 <20150305110415.GA7712@e104818-lin.cambridge.arm.com>
 <CAFEAcA98j_EsP4Hy20tQCKdnP3=NuvS3Ona37peBjan8aWLSEA@mail.gmail.com>
 <20150305120348.GD7712@e104818-lin.cambridge.arm.com>
 <54F84B7F.5010007@redhat.com>
 <20150305145831.GA11447@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11B4847DBF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2015 12:37:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BywWTaY1mWt2 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Mar 2015 12:37:49 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2EF147D84
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2015 12:37:49 -0500 (EST)
In-Reply-To: <20150305145831.GA11447@e104818-lin.cambridge.arm.com>
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
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 05/03/2015 15:58, Catalin Marinas wrote:
>> It would especially suck if the user has a cluster with different
>> machines, some of them coherent and others non-coherent, and then has to
>> debug why the same configuration works on some machines and not on others.
> 
> That's a problem indeed, especially with guest migration. But I don't
> think we have any sane solution here for the bus master DMA.

I do not oppose doing cache management in QEMU for bus master DMA
(though if the solution you outlined below works it would be great).

> ARM can override them as well but only making them stricter. Otherwise,
> on a weakly ordered architecture, it's not always safe (let's say the
> guest thinks it accesses Strongly Ordered memory and avoids barriers for
> flag updates but the host "upgrades" it to Cacheable which breaks the
> memory order).

The same can happen on x86 though, even if it's rarer.  You still need a
barrier between stores and loads.

> If we want the host to enforce guest memory mapping attributes via stage
> 2, we could do it the other way around: get the guests to always assume
> full cache coherency, generating Normal Cacheable mappings, but use the
> stage 2 attributes restriction in the host to make such mappings
> non-cacheable when needed (it works this way on ARM but not in the other
> direction to relax the attributes).

That sounds like a plan for device assignment.  But it still would not
solve the problem of the MMIO framebuffer, right?

>> The problem arises with MMIO areas that the guest can reasonably expect
>> to be uncacheable, but that are optimized by the host so that they end
>> up backed by cacheable RAM.  It's perfectly reasonable that the same
>> device needs cacheable mapping with one userspace, and works with
>> uncacheable mapping with another userspace that doesn't optimize the
>> MMIO area to RAM.
> 
> Unless the guest allocates the framebuffer itself (e.g.
> dma_alloc_coherent), we can't control the cacheability via
> "dma-coherent" properties as it refers to bus master DMA.

Okay, it's good to rule that out.  One less thing to think about. :)
Same for _DSD.

> So for MMIO with the buffer allocated by the host (Qemu), the only
> solution I see on ARM is for the host to ensure coherency, either via
> explicit cache maintenance (new KVM API) or by changing the memory
> attributes used by Qemu to access such virtual MMIO.
> 
> Basically Qemu is acting as a bus master when reading the framebuffer it
> allocated but the guest considers it a slave access and we don't have a
> way to tell the guest that such accesses should be cacheable, nor can we
> upgrade them via architecture features.

Yes, that's a way to put it.

>> In practice, the VGA framebuffer has an optimization that uses dirty
>> page tracking, so we could piggyback on the ioctls that return which
>> pages are dirty.  It turns out that piggybacking on those ioctls also
>> should fix the case of migrating a guest while the MMU is disabled.
> 
> Yes, Qemu would need to invalidate the cache before reading a dirty
> framebuffer page.
> 
> As I said above, an API that allows non-cacheable mappings for the VGA
> framebuffer in Qemu would also solve the problem. I'm not sure what KVM
> provides here (or whether we can add such API).

Nothing for now; other architectures simply do not have the issue.

As long as it's just VGA, we can quirk it.  There's just a couple
vendor/device IDs to catch, and the guest can then use a cacheable mapping.

For a more generic solution, the API would be madvise(MADV_DONTCACHE).
It would be easy for QEMU to use it, but I am not too optimistic about
convincing the mm folks about it.  We can try.

Paolo
