From: Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>
Subject: Re: [PATCH 00/17] ARMv8.3 pointer authentication support
Date: Tue, 23 Oct 2018 08:39:19 +0000
Message-ID: <8478fc27-6e74-4fa6-7956-ffc1cca6c063@arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
 <20181019123646.GG14246@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019123646.GG14246@arm.com>
Content-Language: en-US
Content-ID: <E4BEBC7F548CBB4BB7EB7193E0C88AD2@eurprd08.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <Will.Deacon@arm.com>, Kristina Martsenko <Kristina.Martsenko@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <Amit.Kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <Catalin.Marinas@arm.com>, Christoffer Dall <Christoffer.Dall@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Mark Rutland <Mark.Rutland@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.or>
List-Id: kvmarm@lists.cs.columbia.edu

On 19/10/2018 13:36, Will Deacon wrote:
> On Fri, Oct 05, 2018 at 09:47:37AM +0100, Kristina Martsenko wrote:
>> 1) Key support
>>
>> This series enables the use of instructions using APIAKey, which is
>> initialised and maintained per-process (shared by all threads). GCC
>> currently only makes use of APIAKey.
>>
>> This series does not add support for APIBKey, APDAKey, APDBKey, nor
>> APGAKey. HINT-space instructions using these keys will currently execute
>> as NOPs. Support for these keys can be added as users appear.
>>
>> Note that while we expose the cpuid register (ID_AA64ISAR1_EL1) to
>> userspace, it only contains one feature for address authentication
>> (API/APA), so it cannot be used by userspace to tell which keys the
>> kernel supports. For this the kernel exposes HWCAP bits, one per key
>> (currently only APIAKey), which must be checked instead.
>=20
> Given that the architecture doesn't provide an identification mechanism
> for the case where only one of the keys is available, I would much prefer
> that we expose both of the keys to userspace. Is the only downside of
> that a possible exception entry overhead if the kernel wants to use point=
er
> authentication as well?
>=20
> Having an initial implementation where the B key operations act as NOPs
> isn't ideal if we want to support future users -- chances are they'll
> be put off because deployed kernels don't give them whatever security
> guarantees they require. It's a bit of a chicken-and-egg problem, so
> unless we have good reasons to keep the B key hidden, I think we should
> be exposing it from the start.

There are patches in flight to get B key signing support in for GCC 9  -=20
so exposing this to user space will be good.

Ramana

>=20
> Will
>=20
