From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v4 0/4] KVM: arm64: BUG FIX: Correctly handle zero register
 transfers
Date: Mon, 07 Dec 2015 11:47:44 +0300
Message-ID: <011701d130cb$f2efc830$d8cf5890$@samsung.com>
References: <cover.1449230499.git.p.fedin@samsung.com>
 <20151205003334.GB3117@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D02D5419D1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2015 03:46:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hutJByIMzf8Q for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2015 03:46:05 -0500 (EST)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2447D40FA6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2015 03:46:04 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYZ00KAGCFOJI50@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 07 Dec 2015 08:47:48 +0000 (GMT)
In-reply-to: <20151205003334.GB3117@hawk.localdomain>
Content-language: ru
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Andrew Jones' <drjones@redhat.com>
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> But, if Pavel doesn't
> mind trying them out on his system, then it'd be good to know if they
> reproduce there. I'd like to find out if it's a test case problem or
> something else strange going on with environments.

Does not build, applied to master:
--- cut ---
aarch64-unknown-linux-gnu-gcc  -std=gnu99 -ffreestanding -Wextra -O2 -I lib -I lib/libfdt -g -MMD -MF arm/.xzr-test.d -Wall
-fomit-frame-pointer  -fno-stack-protector     -c -o arm/xzr-test.o arm/xzr-test.c
arm/xzr-test.c: In function 'check_xzr_sysreg':
arm/xzr-test.c:13:2: warning: implicit declaration of function 'mmu_disable' [-Wimplicit-function-declaration]
  mmu_disable(); /* Tell KVM to set HCR_TVM for this VCPU */
  ^
aarch64-unknown-linux-gnu-gcc  -std=gnu99 -ffreestanding -Wextra -O2 -I lib -I lib/libfdt -g -MMD -MF arm/.xzr-test.d -Wall
-fomit-frame-pointer  -fno-stack-protector   -nostdlib -o arm/xzr-test.elf \
        -Wl,-T,arm/flat.lds,--build-id=none,-Ttext=40080000 \
        arm/xzr-test.o arm/cstart64.o lib/libcflat.a lib/libfdt/libfdt.a /usr/lib/gcc/aarch64-unknown-linux-gnu/4.9.0/libgcc.a
lib/arm/libeabi.a
arm/xzr-test.o: In function `check_xzr_sysreg':
/cygdrive/d/Projects/kvm-unit-tests/arm/xzr-test.c:13: undefined reference to `mmu_disable'
--- cut ---

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
