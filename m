From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 00/21] arm64: KVM: world switch in C
Date: Tue, 01 Dec 2015 17:51:46 +0000
Message-ID: <565DDE32.6080500@arm.com>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com> <20151130203345.GI11704@cbox> <565D6F3F.5030700@arm.com> <20151201120025.GN11704@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20151201120025.GN11704@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: =?windows-1252?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 01/12/15 12:00, Christoffer Dall wrote:
> On Tue, Dec 01, 2015 at 09:58:23AM +0000, Marc Zyngier wrote:
>> On 30/11/15 20:33, Christoffer Dall wrote:
>>> On Fri, Nov 27, 2015 at 06:49:54PM +0000, Marc Zyngier wrote:
>>>> Once upon a time, the KVM/arm64 world switch was a nice, clean, lean
>>>> and mean piece of hand-crafted assembly code. Over time, features have
>>>> crept in, the code has become harder to maintain, and the smallest
>>>> change is a pain to introduce. The VHE patches are a prime example of
>>>> why this doesn't work anymore.
>>>>
>>>> This series rewrites most of the existing assembly code in C, but keeps
>>>> the existing code structure in place (most function names will look
>>>> familiar to the reader). The biggest change is that we don't have to
>>>> deal with a static register allocation (the compiler does it for us),
>>>> we can easily follow structure and pointers, and only the lowest level
>>>> is still in assembly code. Oh, and a negative diffstat.
>>>>
>>>> There is still a healthy dose of inline assembly (system register
>>>> accessors, runtime code patching), but I've tried not to make it too
>>>> invasive. The generated code, while not exactly brilliant, doesn't
>>>> look too shaby. I do expect a small performance degradation, but I
>>>> believe this is something we can improve over time (my initial
>>>> measurements don't show any obvious regression though).
>>>
>>> I ran this through my experimental setup on m400 and got this:
>>
>> [...]
>>
>>> What this tells me is that we do take a noticable hit on the
>>> world-switch path, which shows up in the TCP_RR and hackbench workloads,
>>> which have a high precision in their output.
>>>
>>> Note that the memcached number is well within its variability between
>>> individual benchmark runs, where it varies to 12% of its average in over
>>> 80% of the executions.
>>>
>>> I don't think this is a showstopper thought, but we could consider
>>> looking more closely at a breakdown of the world-switch path and verify
>>> if/where we are really taking a hit.
>>
>> Thanks for doing so, very interesting. As a data point, what compiler
>> are you using? I'd expect some variability based on the compiler version...
>>
> I used the following (compiling natively on the m400):
> 
> gcc version 4.8.2 (Ubuntu/Linaro 4.8.2-19ubuntu1)

For what it is worth, I've ran hackbench on my Seattle B0 (8xA57 2GHz),
with a 4 vcpu VM and got the following results (10 runs per kernel
version, same configuration):

v4.4-rc3-wsinc: Average 31.750
32.459
32.124
32.435
31.940
31.085
31.804
31.862
30.985
31.450
31.359

v4.4-rc3: Average 31.954
31.806
31.598
32.697
31.472
31.410
32.562
31.938
31.932
31.672
32.459

This is with GCC as produced by Linaro:
aarch64-linux-gnu-gcc (Linaro GCC 5.1-2015.08) 5.1.1 20150608

It could well be that your compiler generates worse code than the one I
use, or that the code it outputs is badly tuned for XGene. I guess I
need to unearth my Mustang to find out...

	M.
-- 
Jazz is not dead. It just smells funny...
