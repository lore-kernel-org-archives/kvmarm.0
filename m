From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 0/4] KVM: arm64: BUG FIX: Correctly handle zero
 register transfers
Date: Mon, 7 Dec 2015 15:50:02 -0600
Message-ID: <20151207215002.GG4402@hawk.localdomain>
References: <cover.1449230499.git.p.fedin@samsung.com>
 <20151205003334.GB3117@hawk.localdomain>
 <011701d130cb$f2efc830$d8cf5890$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 429C3411F6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2015 16:48:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7ii0UWvUi-lk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2015 16:48:22 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EBFED40FA7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2015 16:48:21 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <011701d130cb$f2efc830$d8cf5890$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 07, 2015 at 11:47:44AM +0300, Pavel Fedin wrote:
>  Hello!
> 
> > But, if Pavel doesn't
> > mind trying them out on his system, then it'd be good to know if they
> > reproduce there. I'd like to find out if it's a test case problem or
> > something else strange going on with environments.
> 
> Does not build, applied to master:
> --- cut ---
> aarch64-unknown-linux-gnu-gcc  -std=gnu99 -ffreestanding -Wextra -O2 -I lib -I lib/libfdt -g -MMD -MF arm/.xzr-test.d -Wall
> -fomit-frame-pointer  -fno-stack-protector     -c -o arm/xzr-test.o arm/xzr-test.c
> arm/xzr-test.c: In function 'check_xzr_sysreg':
> arm/xzr-test.c:13:2: warning: implicit declaration of function 'mmu_disable' [-Wimplicit-function-declaration]
>   mmu_disable(); /* Tell KVM to set HCR_TVM for this VCPU */
>   ^
> aarch64-unknown-linux-gnu-gcc  -std=gnu99 -ffreestanding -Wextra -O2 -I lib -I lib/libfdt -g -MMD -MF arm/.xzr-test.d -Wall
> -fomit-frame-pointer  -fno-stack-protector   -nostdlib -o arm/xzr-test.elf \
>         -Wl,-T,arm/flat.lds,--build-id=none,-Ttext=40080000 \
>         arm/xzr-test.o arm/cstart64.o lib/libcflat.a lib/libfdt/libfdt.a /usr/lib/gcc/aarch64-unknown-linux-gnu/4.9.0/libgcc.a
> lib/arm/libeabi.a
> arm/xzr-test.o: In function `check_xzr_sysreg':
> /cygdrive/d/Projects/kvm-unit-tests/arm/xzr-test.c:13: undefined reference to `mmu_disable'
> --- cut ---

Have you done a git pull of your kvm-unit-tests repo lately? The patch
that introduces mmu_disable was commit a few months ago or so. Other
than your repo just not having mmu_disable(), then I can't think of why
it compiles for me and not you. If you have done a recent git pull, then
maybe do a 'make distclean; ./configure; make'

Thanks,
drew

> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
