From: Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>
Subject: Re: [PATCH v5 07/17] arm64: add basic pointer authentication support
Date: Tue, 23 Oct 2018 08:36:16 +0000
Message-ID: <5ca5bf92-f2b7-48c9-ea41-5efeff09a799@arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
 <20181005084754.20950-8-kristina.martsenko@arm.com>
 <20181019111542.6wrvjguirglzg7vg@mbp>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019111542.6wrvjguirglzg7vg@mbp>
Content-Language: en-US
Content-ID: <AAD136982C3E6A438E34A7F2DAB94C7A@eurprd08.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <Catalin.Marinas@arm.com>, Kristina Martsenko <Kristina.Martsenko@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Mark Rutland <Mark.Rutland@arm.com>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Andrew Jones <drjones@redhat.com>, Jacob Bramley <Jacob.Bramley@arm.com>, Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Adam Wallis <awallis@codeaurora.org>, Suzuki Poulose <Suzuki.Poulose@arm.com>, Will Deacon <Will.Deacon@arm.com>, Christoffer Dall <Christoffer.Dall@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Amit Kachhap <Amit.Kachhap@arm.com>, Dave P Martin <Dave.Martin@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 19/10/2018 12:15, Catalin Marinas wrote:
> On Fri, Oct 05, 2018 at 09:47:44AM +0100, Kristina Martsenko wrote:
>> diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/=
asm/pointer_auth.h
>> new file mode 100644
>> index 000000000000..2aefedc31d9e
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/pointer_auth.h
>> @@ -0,0 +1,63 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +#ifndef __ASM_POINTER_AUTH_H
>> +#define __ASM_POINTER_AUTH_H
>> +
>> +#include <linux/random.h>
>> +
>> +#include <asm/cpufeature.h>
>> +#include <asm/sysreg.h>
>> +
>> +#ifdef CONFIG_ARM64_PTR_AUTH
>> +/*
>> + * Each key is a 128-bit quantity which is split across a pair of 64-bi=
t
>> + * registers (Lo and Hi).
>> + */
>> +struct ptrauth_key {
>> +	unsigned long lo, hi;
>> +};
>> +
>> +/*
>> + * We give each process its own instruction A key (APIAKey), which is s=
hared by
>> + * all threads. This is inherited upon fork(), and reinitialised upon e=
xec*().
>> + * All other keys are currently unused, with APIBKey, APDAKey, and APBA=
Key
>> + * instructions behaving as NOPs.
>> + */
>=20
> I don't remember the past discussions but I assume the tools guys are ok
> with a single key shared by multiple threads. Ramana, could you ack this
> part, FTR?

Sorry about the slow response, I've been traveling.

Ack and Will's response covers the reasons why pretty well. A prctl call=20
would be a good enhancement.

regards
Ramana
