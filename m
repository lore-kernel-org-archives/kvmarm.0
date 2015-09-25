From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 5/5] KVM: arm64: Implement vGICv3 CPU interface access
Date: Fri, 25 Sep 2015 23:27:44 +0100
Message-ID: <5605CA60.4080101@arm.com>
References: <cover.1441370053.git.p.fedin@samsung.com>
 <20be17e4e8aebcd7f1a52a634f449955bef99996.1441370053.git.p.fedin@samsung.com>
 <55E9B528.50106@arm.com> <16a001d0f6c1$b113cbd0$133b6370$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <16a001d0f6c1$b113cbd0$133b6370$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, 'Peter Maydell' <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 24/09/15 13:08, Pavel Fedin wrote:
>  Hello!
> 
>> The only thing that is pure 64-bit is the MRS/MSR _instruction_ in
>> Aarch64, which always takes a x<nn> register.
>> So can you model the register size according to the spec and allow
>> 32-bit accesses from userland?
> 
>  I would like to complete the rework and respin v4, but this is, i guess, the only major issue left.
> Additionally, it impacts the API. So...
>  In order to allow 32-bit accesses we would have to drop using ARM64_SYS_REG() for building
> attribute ID and introduce something own, like KVM_DEV_ARM_VGIC_REG(). It will have different bits
> layout (actually it will be missing 'arch' and 'size' field, and instead i will use
> KVM_DEV_ARM_VGIC_64BIT flag for length specification, the same as for redistributor.
>  Will this be OK ?

No, instead you should go with your original approach ;-)
Thinking about that again I see that this interface is of course modeled
after the architectured GICv3 system registers, where AArch32 has its
own, separate encoding. So it's perfectly fine to use that 64-bit
interface between userland and KVM now. If we later get Aarch32 support
for the GICv3, we can add the appropriate Aarch32 sysregs to that
interface and have a natural match.

So: sorry for the noise, you can just go ahead with that native 64-bit
sysregs encoding for [SG]ET_ONE_REG as you had before.

Cheers,
Andre.

