From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v7 06/11] arm/Makefile.common: force -fno-pic
Date: Thu, 24 Nov 2016 16:10:28 +0000
Message-ID: <20161124161033.11456-7-alex.bennee@linaro.org>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161124161033.11456-1-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: qemu-devel@nongnu.org, mttcg@listserver.greensocs.com, fred.konrad@greensocs.com, a.rigo@virtualopensystems.com, cota@braap.org, bobby.prani@gmail.com, nikunj@linux.vnet.ibm.com, mark.burton@greensocs.com, pbonzini@redhat.com, jan.kiszka@siemens.com, serge.fdrv@gmail.com, rth@twiddle.net, peter.maydell@linaro.org, claudio.fontana@huawei.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

As distro compilers move towards defaults for build hardening for things
like ASLR we need to force -fno-pic. Failure to do can lead to weird
relocation problems when we build our "lat" binaries.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 arm/Makefile.common | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 52f7440..cca0d9c 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -21,6 +21,7 @@ phys_base = $(LOADADDR)
 
 CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
+CFLAGS += -fno-pic
 CFLAGS += -Wextra
 CFLAGS += -O2
 CFLAGS += -I lib -I lib/libfdt
-- 
2.10.1

