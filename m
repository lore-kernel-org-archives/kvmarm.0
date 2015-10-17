From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH] KVM/arm: kernel low level debug suport for ARM32 virtual
 platforms
Date: Fri, 16 Oct 2015 20:19:59 -0700
Message-ID: <1445051999-24360-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41240413DD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Oct 2015 23:18:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RHK9mK+pu8FA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Oct 2015 23:18:04 -0400 (EDT)
Received: from usmailout1.samsung.com (mailout1.w2.samsung.com
 [211.189.100.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 049ED411AA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Oct 2015 23:18:03 -0400 (EDT)
Received: from uscpsbgex2.samsung.com
 (u123.gpu85.samsung.co.kr [203.254.195.123]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NWC00H1IHA2GZ00@mailout1.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 16 Oct 2015 23:20:26 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: will.deacon@arm.com, andre.przywara@arm.com, peter.maydell@linaro.org, grant.likely@secretlab.ca, robherring2@gmail.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, linux@arm.linux.org.uk, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When booting a VM using QEMU or Kvmtool there are no clear ways to 
enable low level debugging for these virtual platforms. some menu port 
choices are not supported by the virtual platforms at all. And there is no
help on the location of physical and virtual addresses for the ports.
This may lead to wrong debug port and a frozen VM with a blank screen.

This patch adds menu selections for QEMU and Kvmtool virtual platforms for low 
level kernel print debugging. Help section displays port physical and
virutal addresses.

ARM reference models use the MIDR register to run-time select UART port address 
(for ARCH_VEXPRESS) based on A9 or A15 part numbers. Looked for a same approach
but couldn't find a way to differentiate between virtual platforms, something
like a platform register.

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/Kconfig.debug | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index a2e16f9..d126bd4 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1155,6 +1155,28 @@ choice
 		  This option selects UART0 on VIA/Wondermedia System-on-a-chip
 		  devices, including VT8500, WM8505, WM8650 and WM8850.
 
+	config DEBUG_VIRT_UART_QEMU
+		bool "Kernel low-level debugging on QEMU Virtual Platform"
+		depends on ARCH_VIRT
+		select DEBUG_UART_PL01X
+		help
+		  Say Y here if you want the debug print routines to direct
+		  their output to PL011 UART port on QEMU Virtual Platform.
+		  Appropriate address values are:
+			PHYS		VIRT
+			0x9000000	0xf8090000
+
+	config DEBUG_VIRT_UART_KVMTOOL
+		bool "Kernel low-level debugging on Kvmtool Virtual Platform"
+		depends on ARCH_VIRT
+		select DEBUG_UART_8250
+		help
+		  Say Y here if you want the debug print routines to direct
+		  their output to 8250 UART port on Kvmtool Virtual
+		  Platform. Appropriate address values are:
+			PHYS		VIRT
+			0x3f8		0xf80903f8
+
 	config DEBUG_ICEDCC
 		bool "Kernel low-level debugging via EmbeddedICE DCC channel"
 		help
-- 
1.9.1
