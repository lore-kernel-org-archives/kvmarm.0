From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 00/21] arm64: KVM: world switch in C
Date: Tue, 01 Dec 2015 09:58:23 +0000
Message-ID: <565D6F3F.5030700@arm.com>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
 <20151130203345.GI11704@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43AF649840
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 04:57:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OQdjV-jUrPzA for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2015 04:57:04 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CB2549803
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 04:57:03 -0500 (EST)
In-Reply-To: <20151130203345.GI11704@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/11/15 20:33, Christoffer Dall wrote:
> On Fri, Nov 27, 2015 at 06:49:54PM +0000, Marc Zyngier wrote:
>> Once upon a time, the KVM/arm64 world switch was a nice, clean, lean
>> and mean piece of hand-crafted assembly code. Over time, features have
>> crept in, the code has become harder to maintain, and the smallest
>> change is a pain to introduce. The VHE patches are a prime example of
>> why this doesn't work anymore.
>>
>> This series rewrites most of the existing assembly code in C, but keeps
>> the existing code structure in place (most function names will look
>> familiar to the reader). The biggest change is that we don't have to
>> deal with a static register allocation (the compiler does it for us),
>> we can easily follow structure and pointers, and only the lowest level
>> is still in assembly code. Oh, and a negative diffstat.
>>
>> There is still a healthy dose of inline assembly (system register
>> accessors, runtime code patching), but I've tried not to make it too
>> invasive. The generated code, while not exactly brilliant, doesn't
>> look too shaby. I do expect a small performance degradation, but I
>> believe this is something we can improve over time (my initial
>> measurements don't show any obvious regression though).
> 
> I ran this through my experimental setup on m400 and got this:

[...]

> What this tells me is that we do take a noticable hit on the
> world-switch path, which shows up in the TCP_RR and hackbench workloads,
> which have a high precision in their output.
> 
> Note that the memcached number is well within its variability between
> individual benchmark runs, where it varies to 12% of its average in over
> 80% of the executions.
> 
> I don't think this is a showstopper thought, but we could consider
> looking more closely at a breakdown of the world-switch path and verify
> if/where we are really taking a hit.

Thanks for doing so, very interesting. As a data point, what compiler
are you using? I'd expect some variability based on the compiler version...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
