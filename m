From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm64: KVM: Fix user access for debug registers
Date: Wed, 16 Sep 2015 15:46:17 +0100
Message-ID: <55F980B9.6080601@arm.com>
References: <1442400070-23316-1-git-send-email-marc.zyngier@arm.com> <20150916134141.GA15903@cbox> <87wpvqmnxw.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <87wpvqmnxw.fsf@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/09/15 15:35, Alex Benn=C3=A9e wrote:
>=20
> Christoffer Dall <christoffer.dall@linaro.org> writes:
>=20
>> On Wed, Sep 16, 2015 at 11:41:10AM +0100, Marc Zyngier wrote:
>>> When setting the debug register from userspace, make sure that
>>> copy_from_user() is called with its parameters in the expected
>>> order. It otherwise doesn't do what you think.
>>>
>>> Reported-by: Peter Maydell <peter.maydell@linaro.org>
>>> Cc: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>> Fixes: 84e690bfbed1 ("KVM: arm64: introduce vcpu->arch.debug_ptr")
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>
>> yikes!
>=20
> OK I'm now muchly confused as to how it could have worked...

Well, we only write the registers at boot time, and corrupting userspac=
e
did go unnoticed. I was only able to reproduce this on a model with PAN
enabled.

Copy-paste bug.

	M.
--=20
Jazz is not dead. It just smells funny...
