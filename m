From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Vexpress TC2 no longer booting on v4.12-rc1
Date: Fri, 2 Jun 2017 16:16:59 -0600
Message-ID: <CANLsYkz3dcVArStN2GJguYfJbWc_4dC4vvTE1KVtYpVWipEYjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>, marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: kvm@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Good afternoon Russell and friends,

I noticed that my vexpress-TC2 platform stopped booting when moving to
kernel v4.12-rc1 (same with -rc2 and 3).  The last time things worked
properly was on v4.11.  I did a bisect between v4.11 and v4.12-rc1 and
ended up on [1], hence this email.

Since CONFIG_ARM_VIRT_EXT is selected by  default I removed the
"#ifdef CONFIG_ARM_VIRT_EXT" section in the last hunk of the patch and
the system sprung up to life again.

Compiler: arm-linux-gnueabi-gcc (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.4)
5.4.0 20160609
Kernel command line: console=ttyAMA0,38400 loglevel=8 root=/dev/sda2 rootwait
U-boot:
 ## Flattened Device Tree blob at 82000000
   Booting using the fdt blob at 0x82000000
   Loading Ramdisk to 9fcea000, end 9feea6d1 ... OK
   Loading Device Tree to 9fce2000, end 9fce9ad8 ... OK

I'm not sure what else you need at this time - simply get back to me
with what I'm missing and I'll be happy to provided.  I'm also
offering to test patches.

Many thanks,
Mathieu

[1]. 9da5ac236de6 ARM: soft-reboot into same mode that we entered the kernel
