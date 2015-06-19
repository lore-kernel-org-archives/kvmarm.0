From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] kvmtool: Makefile: allow overriding CC and LD
Date: Fri, 19 Jun 2015 11:14:54 +1000
Message-ID: <1434676494.23771.2.camel@ellerman.id.au>
References: <1434642647-3127-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-ppc-owner@vger.kernel.org>
In-Reply-To: <1434642647-3127-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-ppc-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: will.deacon@arm.com, Matt Evans <matt@ozlabs.org>, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 2015-06-18 at 16:50 +0100, Andre Przywara wrote:
> Currently we set CC unconditionally to ${CROSS_COMPILE}gcc, the same
> for LD.
> Allow people to override the compiler name by specifying it explicitly
> on the command line or via the environment.
> Beside calling a certain compiler binary this allows to pass in
> options to the compiler, which lets us get rid of the PowerPC
> overrides in the Makefile. Possible uses:
> $ make CC="gcc -m64" LD="ld -melf64ppc"
> (build kvmtool on a PowerPC toolchain defaulting to 32-bit)
> $ make CC="gcc -m32" LD="ld -melf_i386"
> (build a 32-bit binary on a multilib-enabled x86-64 compiler)


I'm not a big fan of that.

Your examples are all about overriding CFLAGS and LDFLAGS, not CC and LD. So
if anything you should be allowing that. Adding flags to CC and LD is asking
for trouble.

cheers
