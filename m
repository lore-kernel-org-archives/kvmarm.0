From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Thu, 5 Mar 2015 20:13:43 +0100
Message-ID: <CAKv+Gu_nv6SVXHLMpVJ5ArnBPuZjbNih7v+atwdRZ1fR8_pQGA@mail.gmail.com>
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
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06B8847C02
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2015 14:07:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KzIuRye8nwqG for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Mar 2015 14:07:38 -0500 (EST)
Received: from mail-ie0-f172.google.com (mail-ie0-f172.google.com
 [209.85.223.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4EEA47B8E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2015 14:07:38 -0500 (EST)
Received: by iery20 with SMTP id y20so25841948ier.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 Mar 2015 11:13:43 -0800 (PST)
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
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 5 March 2015 at 15:58, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Thu, Mar 05, 2015 at 01:26:39PM +0100, Paolo Bonzini wrote:
>> On 05/03/2015 13:03, Catalin Marinas wrote:
>> >> > I'd hate to have to do that. PCI should be entirely probeable
>> >> > given that we tell the guest where the host bridge is, that's
>> >> > one of its advantages.
>> > I didn't say a DT node per device, the DT doesn't know what PCI devices
>> > are available (otherwise it defeats the idea of probing). But we need to
>> > tell the OS where the host bridge is via DT.
>> >
>> > So the guest would be told about two host bridges: one for real devices
>> > and another for virtual devices. These can have different coherency
>> > properties.
>>
>> Yeah, and it would suck that the user needs to know the difference
>> between the coherency proprties of the host bridges.
>
> The host needs to know about this, unless we assume full coherency on
> all the platforms. Arguably, Qemu needs to know as well if it is the one
> generating the DT for guest (or at least passing some snippets from the
> host DT).
>
>> It would especially suck if the user has a cluster with different
>> machines, some of them coherent and others non-coherent, and then has to
>> debug why the same configuration works on some machines and not on others.
>
> That's a problem indeed, especially with guest migration. But I don't
> think we have any sane solution here for the bus master DMA.
>
>> To avoid replying in two different places, which of the solutions look
>> to me like something that half-works?  Pretty much all of them, because
>> in the end it is just a processor misfeature.  For example, Intel
>> virtualization extensions let the hypervisor override stage1 translation
>> _if necessary_.  AMD doesn't, but has some other quirky things that let
>> you achieve the same effect..
>
> ARM can override them as well but only making them stricter. Otherwise,
> on a weakly ordered architecture, it's not always safe (let's say the
> guest thinks it accesses Strongly Ordered memory and avoids barriers for
> flag updates but the host "upgrades" it to Cacheable which breaks the
> memory order).
>
> If we want the host to enforce guest memory mapping attributes via stage
> 2, we could do it the other way around: get the guests to always assume
> full cache coherency, generating Normal Cacheable mappings, but use the
> stage 2 attributes restriction in the host to make such mappings
> non-cacheable when needed (it works this way on ARM but not in the other
> direction to relax the attributes).
>

This was precisely the idea of the MAIR mangling patch: promote all
stage1 mappings to cacheable, and put the host in control by allowing
it to supersede them with device mappings in stage 2.
But it appears there are too many corner cases where this doesn't
quite work out.


>> In particular, I am not even sure that this is about bus coherency,
>> because this problem does not happen when the device is doing bus master
>> DMA.  Working around coherency for bus master DMA would be easy.
>
> My previous emails on the "dma-coherent" property were only about bus
> master DMA (which would cause the correct selection of the DMA API ops
> in the guest).
>
> But even for bus master DMA, guest OS still needs to be aware of the
> (virtual) device DMA capabilities (cache coherent or not). You may be
> able to work around it in the host (stage 2, explicit cache flushing or
> SMMU attributes) if the guests assumes non-coherency but it's not really
> efficient (nor nice to implement).
>
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
>
> So for MMIO with the buffer allocated by the host (Qemu), the only
> solution I see on ARM is for the host to ensure coherency, either via
> explicit cache maintenance (new KVM API) or by changing the memory
> attributes used by Qemu to access such virtual MMIO.
>
> Basically Qemu is acting as a bus master when reading the framebuffer it
> allocated but the guest considers it a slave access and we don't have a
> way to tell the guest that such accesses should be cacheable, nor can we
> upgrade them via architecture features.
>
>> Currently the VGA framebuffer is the main case where this happen, and I
>> don't expect many more.  Because this is not bus master DMA, it's hard
>> to find a QEMU API that can be hooked to invalidate the cache.  QEMU is
>> just reading from an array of chars.
>
> I now understand the problem better. I was under the impression that the
> guest allocates the framebuffer itself and tells Qemu where it is (like
> in amba-clcd.c for example).
>
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
>
>> We could use _DSD to export the device tree property separately for each
>> device, but that wouldn't work for hotplugged devices.
>
> This would only work for bus master DMA, so it doesn't solve the VGA
> framebuffer issue.
>
> --
> Catalin
