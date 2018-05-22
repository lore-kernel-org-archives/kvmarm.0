From: Andrey Konovalov <andreyknvl@google.com>
Subject: Re: [PATCH] arm64: kvm: use -fno-jump-tables with clang
Date: Tue, 22 May 2018 19:58:31 +0200
Message-ID: <CAAeHK+z2LmMYasYtRTt2U=QF8Pe_i10RA3-SkLzGXXByZqLh1w@mail.gmail.com>
References: <20180518170202.11458-1-samitolvanen@google.com>
 <05d14ac7-0feb-63a3-e7ef-b8ca1ae2fd1d@arm.com> <CAKwvOdm1kYedukCq=g74AvqJHp6KC03oNoouQy2nkvfo4idoEw@mail.gmail.com>
 <8c7be44f-086d-65e3-9969-8182261ce82f@arm.com> <CAKwvOd=XZqg5=mkXZb-cxq3i_AGoJGAbmF=Fwc7Q98oi0tbN9g@mail.gmail.com>
 <3fd89842-86cd-ee01-0c2c-5438dd2d5f2a@arm.com> <CAKwvOdk+=JKcQP1ieLEkZftRGf-pqCTTzEuYvT_45YNMkEw_wA@mail.gmail.com>
 <86k1rzc4ba.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <86k1rzc4ba.wl-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Sami Tolvanen <samitolvanen@google.com>, christoffer.dall@arm.com, Takahiro Akashi <takahiro.akashi@linaro.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, LKML <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, May 19, 2018 at 12:44 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> That would definitely be the right thing to do. Make sure you (or
> Andrey tests with the latest released mainline kernel (4.16 for now)
> or (even better) the tip of Linus' tree.

Hi!

I can confirm that after applying this patch onto 4.17-rc4 kernel the
Odroid C2 board that I have boots (it doesn't without the patch).

This is the result of running KVM tests that I was able to find [1]:

root@odroid64:/home/odroid/kvm-unit-tests# ./run_tests.sh
PASS selftest-setup (2 tests)
PASS selftest-vectors-kernel (2 tests)
PASS selftest-vectors-user (2 tests)
PASS selftest-smp (5 tests)
PASS pci-test (1 tests)
FAIL pmu (3 tests, 3 unexpected failures)
PASS gicv2-ipi (3 tests)
SKIP gicv3-ipi (qemu-system-aarch64: Initialization of device
kvm-arm-gicv3 failed: error creating in-kernel VGIC: No such device)
PASS gicv2-active (1 tests)
SKIP gicv3-active (qemu-system-aarch64: Initialization of device
kvm-arm-gicv3 failed: error creating in-kernel VGIC: No such device)
PASS psci (4 tests)
PASS timer (8 tests)

Here is the result of running the same tests on GCC compiled kernel
(looks the same):

root@odroid64:/home/odroid/kvm-unit-tests# ./run_tests.sh
PASS selftest-setup (2 tests)
PASS selftest-vectors-kernel (2 tests)
PASS selftest-vectors-user (2 tests)
PASS selftest-smp (5 tests)
PASS pci-test (1 tests)
FAIL pmu (3 tests, 3 unexpected failures)
PASS gicv2-ipi (3 tests)
SKIP gicv3-ipi (qemu-system-aarch64: Initialization of device
kvm-arm-gicv3 failed: error creating in-kernel VGIC: No such device)
PASS gicv2-active (1 tests)
SKIP gicv3-active (qemu-system-aarch64: Initialization of device
kvm-arm-gicv3 failed: error creating in-kernel VGIC: No such device)
PASS psci (4 tests)
PASS timer (8 tests)

Tested-by: Andrey Konovalov <andreyknvl@google.com>

Thanks!

[1] https://www.linux-kvm.org/page/KVM-unit-tests
