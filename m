From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [kvmtool test PATCH 24/24] kvmtool: arm: Add support for creating
 VM with PA size
Date: Thu, 5 Jul 2018 09:58:50 +0200
Message-ID: <c04ac446-ec16-6ec9-383a-e93f0e2d7275@redhat.com>
References: <1530270944-11351-1-git-send-email-suzuki.poulose@arm.com>
 <1530270944-11351-25-git-send-email-suzuki.poulose@arm.com>
 <20180704142241.GG4828@arm.com> <8636wzysfl.wl-marc.zyngier@arm.com>
 <20180704155123.GO4828@arm.com>
 <CAFEAcA9wgnbK8PHMvksezHqgN1BQZd_+sxXCe85AW+E+cfrcXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA9wgnbK8PHMvksezHqgN1BQZd_+sxXCe85AW+E+cfrcXg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>, Will Deacon <will.deacon@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, QEMU Developers <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 07/05/2018 09:51 AM, Peter Maydell wrote:
> On 4 July 2018 at 16:51, Will Deacon <will.deacon@arm.com> wrote:
>> On Wed, Jul 04, 2018 at 03:41:18PM +0100, Marc Zyngier wrote:
>>> Not really. Let's say I want my IPA space split in two: memory covers
>>> the low 47 bit, and I want MMIO spanning the top 47 bit. With your
>>> scheme, you'd end-up with a 47bit IPA space, while you really want 48
>>> bits (MMIO space implemented by userspace isn't registered to the
>>> kernel).
>>
>> That still sounds quite niche for a VM. Does QEMU do that?
> 
> Not at 47 bits, but we have RAM up to the 256GB mark, and
> MMIO above that (including a large PCI window), so the general
> arrangement of having the top end of the IPA space not
> necessarily be things we've told the kernel about definitely
> exists.

Is this document (2012) still a reference document?
http://infocenter.arm.com/help/topic/com.arm.doc.den0001c/DEN0001C_principles_of_arm_memory_maps.pdf
(especially Fig 5?)

Peter, comments in QEMU hw/arm/virt.c suggested next RAM chunk should be
added at 2TB. This doc suggests to put it at 8TB. I understand the PA
memory map only is suggested but shouldn't we align?

Thanks

Eric


> 
> thanks
> -- PMM
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
