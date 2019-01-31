From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v4 3/6] arm64/kvm: add a userspace option to enable
 pointer authentication
Date: Thu, 31 Jan 2019 16:19:35 +0000
Message-ID: <3936d9fd-1e3f-0437-e866-edf2d9cbf797@arm.com>
References: <1545119810-12182-1-git-send-email-amit.kachhap@arm.com>
 <1545119810-12182-4-git-send-email-amit.kachhap@arm.com>
 <49474d5f-6f4e-b57d-4b45-94c16d85136c@arm.com>
 <CADGdYn7t7-vXNmQxBUxnCWq5UxG8uGJraCnRxjDgwvC0V6y8jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADGdYn7t7-vXNmQxBUxnCWq5UxG8uGJraCnRxjDgwvC0V6y8jA@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: LAK <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Amit,

On 09/01/2019 10:13, Amit Daniel Kachhap wrote:
> On Sat, Jan 5, 2019 at 12:05 AM James Morse <james.morse@arm.com> wrote:
>> On 18/12/2018 07:56, Amit Daniel Kachhap wrote:
>>> This feature will allow the KVM guest to allow the handling of
>>> pointer authentication instructions or to treat them as undefined
>>> if not set. It uses the existing vcpu API KVM_ARM_VCPU_INIT to
>>> supply this parameter instead of creating a new API.
>>>
>>> A new register is not created to pass this parameter via
>>> SET/GET_ONE_REG interface as just a flag (KVM_ARM_VCPU_PTRAUTH)
>>> supplied is enough to select this feature.
>>
>> What is the motivation for doing this? Doesn't ptrauth 'just' need turning on?
>> It doesn't need additional setup to be useable, or rely on some qemu support to
>> work properly. There isn't any hidden state that can't be migrated in the usual way.
>> Is it just because we don't want to commit to the ABI?

> This allows migration of guest to non pointer authenticated supported
> systems and hides the extra ptrauth registers.

The MIDR already has to match, so the hardware must be the same. I guess this
lets us hide the new feature so old-guests can migrate to a new-kernel without a
write to the id registers failing.


> Basically this suggestion was given by Christoffer
> (https://lore.kernel.org/lkml/20180206123847.GY21802@cbox/).

Ah, Christoffer asked for it, that's reason enough!


Thanks,

James
