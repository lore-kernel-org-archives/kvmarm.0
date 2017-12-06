From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 04/18] arm64: alternatives: Enforce alignment of struct
 alt_instr
Date: Wed, 6 Dec 2017 14:57:29 +0000
Message-ID: <dd8995ce-3065-3aba-2d93-9ed91de5cd50@arm.com>
References: <20171206143839.29223-1-marc.zyngier@arm.com>
 <20171206143839.29223-5-marc.zyngier@arm.com>
 <20171206144847.GA28074@char.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171206144847.GA28074@char.us.oracle.com>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/12/17 14:48, Konrad Rzeszutek Wilk wrote:
> On Wed, Dec 06, 2017 at 02:38:25PM +0000, Marc Zyngier wrote:
>> We're playing a dangerous game with struct alt_instr, as we produce
>> it using assembly tricks, but parse them using the C structure.
>> We just assume that the respective alignments of the two will
>> be the same.
>>
>> But as we add more fields to this structure, the alignment requirements
>> of the structure may change, and lead to all kind of funky bugs.
>>
>> TO solve this, let's move the definition of struct alt_instr to its
>> own file, and use this to generate the alignment constraint from
>> asm-offsets.c. The various macros are then patched to take the
>> alignment into account.
> 
> Would it be better to use .p2align as on 32-bit ARM you must
> have it 4-byte aligned. Or at least have and BUILD_BUG_ON
> to make sure the size can be divided by four??
> 
> Oh wait. You are not even touching ARM-32, how come? The alternative
> code can run on ARM-32 ...

How? Given that I haven't written yet, I'd be grateful if you could
share your time machine...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
