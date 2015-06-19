From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvmtool: Makefile: allow overriding CC and LD
Date: Fri, 19 Jun 2015 11:59:50 +0200
Message-ID: <5583E816.3090705@redhat.com>
References: <1434642647-3127-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5854F560C4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2015 05:49:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yif6g1IBNCrb for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Jun 2015 05:49:10 -0400 (EDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
 [209.85.212.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14067560A9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2015 05:49:09 -0400 (EDT)
Received: by wicgi11 with SMTP id gi11so13702560wic.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2015 02:59:52 -0700 (PDT)
In-Reply-To: <1434642647-3127-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, will.deacon@arm.com
Cc: kvm-ppc@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 18/06/2015 17:50, Andre Przywara wrote:
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
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  Makefile | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 6110b8e..888bee5 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -14,9 +14,13 @@ export E Q
>  include config/utilities.mak
>  include config/feature-tests.mak
>  
> -CC	:= $(CROSS_COMPILE)gcc
> +ifeq ($(origin CC), default)
> +	CC	:= $(CROSS_COMPILE)gcc
> +endif
>  CFLAGS	:=
> -LD	:= $(CROSS_COMPILE)ld
> +ifeq ($(origin LD), default)
> +	LD	:= $(CROSS_COMPILE)ld
> +endif

I know zero about the kvmtool build system, but that ought not to be
necessary.  The make manual says:

"If a variable has been set with a command argument (*note Overriding
Variables: Overriding.), then ordinary assignments in the makefile are
ignored."

Paolo

>  LDFLAGS	:=
>  
>  FIND	:= find
> @@ -148,8 +152,6 @@ ifeq ($(ARCH), powerpc)
>  	OBJS	+= powerpc/spapr_pci.o
>  	OBJS	+= powerpc/xics.o
>  	ARCH_INCLUDE := powerpc/include
> -	CFLAGS 	+= -m64
> -	LDFLAGS += -m elf64ppc
>  
>  	ARCH_WANT_LIBFDT := y
>  endif
> 
