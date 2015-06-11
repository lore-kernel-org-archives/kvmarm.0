From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH V2 3/5] kvm: arm64: Detect GIC version for proper ACPI
 vGIC probing
Date: Thu, 11 Jun 2015 08:54:05 +0100
Message-ID: <55793E9D.7090506@arm.com>
References: <1433909767-12189-1-git-send-email-wei@redhat.com> <1433909767-12189-4-git-send-email-wei@redhat.com> <5578694A.9070905@arm.com> <557913BC.1090201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <557913BC.1090201@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Wei Huang <wei@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "drjones@redhat.com" <drjones@redhat.com>, "a.spyridakis@virtualopensystems.com" <a.spyridakis@virtualopensystems.com>, "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Wei,

On 11/06/15 05:51, Wei Huang wrote:
> 
> 
> On 06/10/2015 11:43 AM, Marc Zyngier wrote:
>> On 10/06/15 05:16, Wei Huang wrote:
>>> There are two GICs (GICv2 and GICv3) supported by KVM. So it is necessary
>>> to find out GIC version before calling ACPI probing functions defined
>>> in vgic-v2.c and vgic-v3.c.
>>>
>>> This patch detects GIC version by checking gic_version field of GIC
>>> distributor, which was defined  since ACPI 6.0. In case of ACPI 5.1,
>>> we use manual hardware discovery to find out GIC version.
>>>
>>> NOTE: This patch is based on a recent patch by Hanjun Guo.
>>
>> Well, this is really a duplicate of Hanjun's patch, and I'd rather have
>> some common infrastructure.
>>
>> Surely it should be possible for the ACPI GIC code to export the
>> necessary entry points, or even to provide the required information?
>>
> 
> I agreed that this is a duplication and should be avoided if possible.
> One easy solution is to export from GIC driver to KVM (using
> EXPORT_SYMBOL or something similar). Is this acceptable?

I don't think EXPORT_SYMBOL is required, as we currently don't support
having KVM as a module.

Simply making available a global structure containing the base addresses
and interrupt should be enough, and could be shared with both DT and
ACPI. You could start your series by letting both GIC drivers expose
that information obtained through DT, convert KVM to use this structure,
and later on let ACPI fill in this structure too.

> Anyway the difficulty is to find a common place to store and share info
> between other modules & KVM.

Indeed. As a rule of thumb, I want to minimize the amount of gratuitous
divergence between DT and ACPI. So the sooner we extract the required
information from whatever firmware we have, the better.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
