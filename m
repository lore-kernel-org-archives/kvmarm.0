From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 11/17] arm64: docs: document pointer authentication
Date: Fri, 19 Oct 2018 12:47:16 +0100
Message-ID: <05738017-5886-fe4d-e8fd-a834da6b1576@arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
 <20181005084754.20950-12-kristina.martsenko@arm.com>
 <9acb0cd2-66b0-1c41-b1a8-7c70608e9a9b@foss.arm.com>
 <7b0de19b-45b9-f4df-25d1-c7e80fab49dc@arm.com>
 <20181019113556.ljbdmjo5pdw7muvz@mbp>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019113556.ljbdmjo5pdw7muvz@mbp>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>
Cc: Ramana Radhakrishnan <ramana.radhakrishnan@foss.arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Mark Rutland <Mark.Rutland@arm.com>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Andrew Jones <drjones@redhat.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Adam Wallis <awallis@codeaurora.org>, Suzuki Poulose <Suzuki.Poulose@arm.com>, Will Deacon <Will.Deacon@arm.com>, Christoffer Dall <Christoffer.Dall@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Amit Kachhap <Amit.Kachhap@arm.com>, Dave P Martin <Dave.Martin@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescoo>
List-Id: kvmarm@lists.cs.columbia.edu

On 19/10/18 12:35, Catalin Marinas wrote:
> On Tue, Oct 16, 2018 at 05:14:39PM +0100, Kristina Martsenko wrote:
>> On 05/10/2018 10:04, Ramana Radhakrishnan wrote:
>>> On 05/10/2018 09:47, Kristina Martsenko wrote:

[...]

>> The other option is to turn off trapping entirely. However then on a
>> big.LITTLE system with mismatched pointer authentication support
>> instructions will work intermittently on some CPUs but not others.
> 
> That's another case but let's assume we never see such configurations ;).

I'd like to put it on the record that I'm not willing to support such a
configuration. So my ask is that if we detect a system where only some
of the CPUs have pointer authentication support, we either:

1) prevent some of the CPUs from booting (that's harsh)
2) disable KVM (that's easy)

I'm perfectly happy with (2).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
