From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH] kvmtool: Makefile: allow overriding CC and LD
Date: Fri, 19 Jun 2015 11:00:34 +0100
Message-ID: <5583E842.8090402@arm.com>
References: <1434642647-3127-1-git-send-email-andre.przywara@arm.com>
 <1434676494.23771.2.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1434676494.23771.2.camel@ellerman.id.au>
Sender: kvm-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>, Will Deacon <Will.Deacon@arm.com>
Cc: Matt Evans <matt@ozlabs.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Michael,

On 19/06/15 02:14, Michael Ellerman wrote:
> On Thu, 2015-06-18 at 16:50 +0100, Andre Przywara wrote:
>> Currently we set CC unconditionally to ${CROSS_COMPILE}gcc, the same
>> for LD.
>> Allow people to override the compiler name by specifying it explicitly
>> on the command line or via the environment.
>> Beside calling a certain compiler binary this allows to pass in
>> options to the compiler, which lets us get rid of the PowerPC
>> overrides in the Makefile. Possible uses:
>> $ make CC="gcc -m64" LD="ld -melf64ppc"
>> (build kvmtool on a PowerPC toolchain defaulting to 32-bit)
>> $ make CC="gcc -m32" LD="ld -melf_i386"
>> (build a 32-bit binary on a multilib-enabled x86-64 compiler)
> 
> 
> I'm not a big fan of that.
> 
> Your examples are all about overriding CFLAGS and LDFLAGS, not CC and LD. So
> if anything you should be allowing that. Adding flags to CC and LD is asking
> for trouble.

Will just disabled overriding CFLAGS and LDFLAGS, I think because
kvmtool inherited some C nastiness from the kernel, which does not
compile with random flags set (CFLAGS=-std=gnu99 was the one the broke it).
Maybe we should revisit that, either fix the code to be more robust to
comply with various standards or document that you should not have
CFLAGS set. Then allow overriding CFLAGS again.

But I thought that overriding CC is common practise - if you want to
select a different compiler, that is. Using a different bitness seems a
lot like a different compiler to me, same with different endianness.
I think I saw quite some examples on the web about using CC="gcc -m32".

I agree that abusing CC to pass optimization options to the compiler is
not good, but for kvmtool's Makefile I don't see how adding flags to CC
would hurt.

Cheers,
Andre.
