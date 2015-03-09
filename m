From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Mon, 09 Mar 2015 08:33:13 -0700
Message-ID: <54FDBD39.8060000@samsung.com>
References: <54F73ACF.1090605@redhat.com>
 <20150304172855.GA28951@e104818-lin.cambridge.arm.com>
 <54F82C06.2000701@redhat.com>
 <20150305110415.GA7712@e104818-lin.cambridge.arm.com>
 <CAFEAcA98j_EsP4Hy20tQCKdnP3=NuvS3Ona37peBjan8aWLSEA@mail.gmail.com>
 <20150305120348.GD7712@e104818-lin.cambridge.arm.com>
 <54F84B7F.5010007@redhat.com>
 <20150305145831.GA11447@e104818-lin.cambridge.arm.com>
 <54F895C8.2070306@redhat.com> <54FA174D.4030807@samsung.com>
 <20150309142601.GA4171@hawk.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 103A74823D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2015 11:27:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s033biT7OktK for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Mar 2015 11:27:01 -0400 (EDT)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42D704823C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2015 11:27:00 -0400 (EDT)
Received: from uscpsbgex4.samsung.com
 (u125.gpu85.samsung.co.kr [203.254.195.125]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKY006F8B7F6I30@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 09 Mar 2015 11:33:15 -0400 (EDT)
In-reply-to: <20150309142601.GA4171@hawk.usersys.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 03/09/2015 07:26 AM, Andrew Jones wrote:
> On Fri, Mar 06, 2015 at 01:08:29PM -0800, Mario Smarduch wrote:
>> On 03/05/2015 09:43 AM, Paolo Bonzini wrote:
>>>
>>>
>>> On 05/03/2015 15:58, Catalin Marinas wrote:
>>>>> It would especially suck if the user has a cluster with different
>>>>> machines, some of them coherent and others non-coherent, and then has to
>>>>> debug why the same configuration works on some machines and not on others.
>>>>
>>>> That's a problem indeed, especially with guest migration. But I don't
>>>> think we have any sane solution here for the bus master DMA.
>>>
>>> I do not oppose doing cache management in QEMU for bus master DMA
>>> (though if the solution you outlined below works it would be great).
>>>
>>>> ARM can override them as well but only making them stricter. Otherwise,
>>>> on a weakly ordered architecture, it's not always safe (let's say the
>>>> guest thinks it accesses Strongly Ordered memory and avoids barriers for
>>>> flag updates but the host "upgrades" it to Cacheable which breaks the
>>>> memory order).
>>>
>>> The same can happen on x86 though, even if it's rarer.  You still need a
>>> barrier between stores and loads.
>>>
>>>> If we want the host to enforce guest memory mapping attributes via stage
>>>> 2, we could do it the other way around: get the guests to always assume
>>>> full cache coherency, generating Normal Cacheable mappings, but use the
>>>> stage 2 attributes restriction in the host to make such mappings
>>>> non-cacheable when needed (it works this way on ARM but not in the other
>>>> direction to relax the attributes).
>>>
>>> That sounds like a plan for device assignment.  But it still would not
>>> solve the problem of the MMIO framebuffer, right?
>>>
>>>>> The problem arises with MMIO areas that the guest can reasonably expect
>>>>> to be uncacheable, but that are optimized by the host so that they end
>>>>> up backed by cacheable RAM.  It's perfectly reasonable that the same
>>>>> device needs cacheable mapping with one userspace, and works with
>>>>> uncacheable mapping with another userspace that doesn't optimize the
>>>>> MMIO area to RAM.
>>>>
>>>> Unless the guest allocates the framebuffer itself (e.g.
>>>> dma_alloc_coherent), we can't control the cacheability via
>>>> "dma-coherent" properties as it refers to bus master DMA.
>>>
>>> Okay, it's good to rule that out.  One less thing to think about. :)
>>> Same for _DSD.
>>>
>>>> So for MMIO with the buffer allocated by the host (Qemu), the only
>>>> solution I see on ARM is for the host to ensure coherency, either via
>>>> explicit cache maintenance (new KVM API) or by changing the memory
>>>> attributes used by Qemu to access such virtual MMIO.
>>>>
>>>> Basically Qemu is acting as a bus master when reading the framebuffer it
>>>> allocated but the guest considers it a slave access and we don't have a
>>>> way to tell the guest that such accesses should be cacheable, nor can we
>>>> upgrade them via architecture features.
>>>
>>> Yes, that's a way to put it.
>>>
>>>>> In practice, the VGA framebuffer has an optimization that uses dirty
>>>>> page tracking, so we could piggyback on the ioctls that return which
>>>>> pages are dirty.  It turns out that piggybacking on those ioctls also
>>>>> should fix the case of migrating a guest while the MMU is disabled.
>>>>
>>>> Yes, Qemu would need to invalidate the cache before reading a dirty
>>>> framebuffer page.
>>>>
>>>> As I said above, an API that allows non-cacheable mappings for the VGA
>>>> framebuffer in Qemu would also solve the problem. I'm not sure what KVM
>>>> provides here (or whether we can add such API).
>>>
>>> Nothing for now; other architectures simply do not have the issue.
>>>
>>> As long as it's just VGA, we can quirk it.  There's just a couple
>>> vendor/device IDs to catch, and the guest can then use a cacheable mapping.
>>>
>>> For a more generic solution, the API would be madvise(MADV_DONTCACHE).
>>> It would be easy for QEMU to use it, but I am not too optimistic about
>>> convincing the mm folks about it.  We can try.
> 
> I forgot to list this one in my summary of approaches[*]. This is a
> nice, clean approach. Avoids getting cache maintenance into everything.
> However, besides the difficulty to get it past mm people, it reduces
> performance for any userspace-userspace uses/sharing of the memory.
> userspace-guest requires cache maintenance, but nothing else. Maybe
> that's not an important concern for the few emulated devices that need
> it though.
> 
>>
>> Interested to see the outcome.
>>
>> I was thinking of a very basic memory driver that can provide
>> an uncached memslot to QEMU - in mmap() file operation
>> apply pgprot_uncached to allocated pages, lock them, flush TLB
>> call remap_pfn_range().
> 
> I guess this is the same as the madvise approach, but with a driver.
> KVM could take this approach itself when memslots are added/updated
> with the INCOHERENT flag. Maybe worth some experimental patches to
> find out?

I would work on this but I'm tied up for next 3 weeks.
If anyone is interested I can provide base code, I used
it for memory passthrough although testing may be time consuming.
I think the hurdle here is the kernel doesn't map these
for any reason like page migration, locking pages should
tell kernel don't touch. madvise() is the  desired solution
but I suspect it might take a while to get in.
> 
> I'm still thinking about experimenting with the ARM private syscalls
> next though.

Hope it succeeds.
> 
> drew
> 
> [*] http://lists.gnu.org/archive/html/qemu-devel/2015-03/msg01254.html
> 
