From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Thu, 05 Mar 2015 13:26:39 +0100
Message-ID: <54F84B7F.5010007@redhat.com>
References: <CAKv+Gu8OUtcpaQh5+gb6vNrdi+Q7eu_zKOujmyoRPrzrs+GJVQ@mail.gmail.com>
 <20150304122956.GT28951@e104818-lin.cambridge.arm.com>
 <CAKv+Gu-JnvXFzr-fpjZZ-zTt8hOSfGqefw69s+4JX2iu_6_BMw@mail.gmail.com>
 <20150304141212.GA5352@hawk.usersys.redhat.com>
 <20150304142943.GU28951@e104818-lin.cambridge.arm.com>
 <54F73ACF.1090605@redhat.com>
 <20150304172855.GA28951@e104818-lin.cambridge.arm.com>
 <54F82C06.2000701@redhat.com>
 <20150305110415.GA7712@e104818-lin.cambridge.arm.com>
 <CAFEAcA98j_EsP4Hy20tQCKdnP3=NuvS3Ona37peBjan8aWLSEA@mail.gmail.com>
 <20150305120348.GD7712@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1896B47D86
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2015 07:20:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fdp-fppNoNYN for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Mar 2015 07:20:48 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 549D947D85
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2015 07:20:47 -0500 (EST)
In-Reply-To: <20150305120348.GD7712@e104818-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Peter Maydell <peter.maydell@linaro.org>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 05/03/2015 13:03, Catalin Marinas wrote:
>> > 
>> > I'd hate to have to do that. PCI should be entirely probeable
>> > given that we tell the guest where the host bridge is, that's
>> > one of its advantages.
> I didn't say a DT node per device, the DT doesn't know what PCI devices
> are available (otherwise it defeats the idea of probing). But we need to
> tell the OS where the host bridge is via DT.
> 
> So the guest would be told about two host bridges: one for real devices
> and another for virtual devices. These can have different coherency
> properties.

Yeah, and it would suck that the user needs to know the difference
between the coherency proprties of the host bridges.

It would especially suck if the user has a cluster with different
machines, some of them coherent and others non-coherent, and then has to
debug why the same configuration works on some machines and not on others.


To avoid replying in two different places, which of the solutions look
to me like something that half-works?  Pretty much all of them, because
in the end it is just a processor misfeature.  For example, Intel
virtualization extensions let the hypervisor override stage1 translation
_if necessary_.  AMD doesn't, but has some other quirky things that let
you achieve the same effect..

In particular, I am not even sure that this is about bus coherency,
because this problem does not happen when the device is doing bus master
DMA.  Working around coherency for bus master DMA would be easy.

The problem arises with MMIO areas that the guest can reasonably expect
to be uncacheable, but that are optimized by the host so that they end
up backed by cacheable RAM.  It's perfectly reasonable that the same
device needs cacheable mapping with one userspace, and works with
uncacheable mapping with another userspace that doesn't optimize the
MMIO area to RAM.

Currently the VGA framebuffer is the main case where this happen, and I
don't expect many more.  Because this is not bus master DMA, it's hard
to find a QEMU API that can be hooked to invalidate the cache.  QEMU is
just reading from an array of chars.

In practice, the VGA framebuffer has an optimization that uses dirty
page tracking, so we could piggyback on the ioctls that return which
pages are dirty.  It turns out that piggybacking on those ioctls also
should fix the case of migrating a guest while the MMU is disabled.

But it's a hack, and it may not work for other devices.

We could use _DSD to export the device tree property separately for each
device, but that wouldn't work for hotplugged devices.

Paolo
