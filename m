From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 1/8] arm64: KVM: Switch the sys_reg search to be a binary
 search
Date: Wed, 10 Feb 2016 14:00:34 +0000
Message-ID: <56BB4282.6040005@arm.com>
References: <1454931622-14902-1-git-send-email-marc.zyngier@arm.com>
 <1454931622-14902-2-git-send-email-marc.zyngier@arm.com>
 <87ziv8vfol.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <87ziv8vfol.fsf@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 10/02/16 13:49, Alex Benn=C3=A9e wrote:
>=20
> Marc Zyngier <marc.zyngier@arm.com> writes:
>=20
>> Our 64bit sys_reg table is about 90 entries long (so far, and the
>> PMU support is likely to increase this). This means that on average,
>> it takes 45 comparaisons to find the right entry (and actually the
>> full 90 if we have to search the invariant table).
>>
>> Not the most efficient thing. Specially when you think that this
>> table is already sorted. Switching to a binary search effectively
>> reduces the search to about 7 comparaisons. Slightly better!
>=20
> Is there an argument for making this a hash table instead or is this =
not
> possible as you would have to use dynamically allocated instead?

I believe it would be possible, assuming we have the right hash. Anothe=
r
alternative would be a radix tree, which would always give us the right
sysreg in four memory accesses. It has some impacts on the memory side,
but that's shouldn't a blocker.

As I said, the binary search was a very low hanging fruit, so it made
some sense to implement it and see how we fared. Finding the perfect
data structure is left as an exercise for the reader! ;-)

Thanks,

	M.
--=20
Jazz is not dead. It just smells funny...
