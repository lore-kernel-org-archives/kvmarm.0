From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 1/4] arm: fdt: add stdout-path to /chosen node
Date: Fri,  1 Feb 2019 12:37:13 +0000
Message-ID: <20190201123716.92901-2-andre.przywara@arm.com>
References: <20190201123716.92901-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 621384A32D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 07:37:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0CHNSk+7yEwK for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Feb 2019 07:37:23 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F96F4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 07:37:23 -0500 (EST)
In-Reply-To: <20190201123716.92901-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The DT spec describes the stdout-path property in the /chosen node to
contain the DT path for a default device usable for outputting characters.
The Linux kernel uses this for earlycon (without further parameters),
other DT users might rely on this as well.

Add a stdout-path property pointing to the "serial0" alias, then add an
aliases node at the end of the FDT, containing the actual path. This
allows the FDT generation code in hw/serial.c to set this string.

Even when we use the virtio console, the serial console is still there
and works, so we can expose this unconditionally. Putting the virtio
console path in there will not work anyway.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/fdt.c         | 10 ++++++++++
 hw/serial.c       |  9 +++++++++
 include/kvm/fdt.h |  2 ++
 3 files changed, 21 insertions(+)

diff --git a/arm/fdt.c b/arm/fdt.c
index 7c50464a..624dbace 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -145,6 +145,7 @@ static int setup_fdt(struct kvm *kvm)
 					 kvm->cfg.real_cmdline));
 
 	_FDT(fdt_property_u64(fdt, "kaslr-seed", kvm->cfg.arch.kaslr_seed));
+	_FDT(fdt_property_string(fdt, "stdout-path", "serial0"));
 
 	/* Initrd */
 	if (kvm->arch.initrd_size != 0) {
@@ -210,6 +211,15 @@ static int setup_fdt(struct kvm *kvm)
 	_FDT(fdt_property_cell(fdt, "migrate", fns->migrate));
 	_FDT(fdt_end_node(fdt));
 
+	if (fdt_stdout_path) {
+		_FDT(fdt_begin_node(fdt, "aliases"));
+		_FDT(fdt_property_string(fdt, "serial0", fdt_stdout_path));
+		_FDT(fdt_end_node(fdt));
+
+		free(fdt_stdout_path);
+		fdt_stdout_path = NULL;
+	}
+
 	/* Finalise. */
 	_FDT(fdt_end_node(fdt));
 	_FDT(fdt_finish(fdt));
diff --git a/hw/serial.c b/hw/serial.c
index 2f19ba80..13c4663e 100644
--- a/hw/serial.c
+++ b/hw/serial.c
@@ -366,6 +366,9 @@ static bool serial8250_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port,
 }
 
 #ifdef CONFIG_HAS_LIBFDT
+
+char *fdt_stdout_path = NULL;
+
 #define DEVICE_NAME_MAX_LEN 32
 static
 void serial8250_generate_fdt_node(struct ioport *ioport, void *fdt,
@@ -383,6 +386,12 @@ void serial8250_generate_fdt_node(struct ioport *ioport, void *fdt,
 
 	snprintf(dev_name, DEVICE_NAME_MAX_LEN, "U6_16550A@%llx", addr);
 
+	if (!fdt_stdout_path) {
+		fdt_stdout_path = malloc(strlen(dev_name) + 2);
+		/* Assumes that this node is a child of the root node. */
+		sprintf(fdt_stdout_path, "/%s", dev_name);
+	}
+
 	_FDT(fdt_begin_node(fdt, dev_name));
 	_FDT(fdt_property_string(fdt, "compatible", "ns16550a"));
 	_FDT(fdt_property(fdt, "reg", reg_prop, sizeof(reg_prop)));
diff --git a/include/kvm/fdt.h b/include/kvm/fdt.h
index beadc7f3..4e615725 100644
--- a/include/kvm/fdt.h
+++ b/include/kvm/fdt.h
@@ -25,6 +25,8 @@ enum irq_type {
 	IRQ_TYPE_LEVEL_MASK	= (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH),
 };
 
+extern char *fdt_stdout_path;
+
 /* Helper for the various bits of code that generate FDT nodes */
 #define _FDT(exp)							\
 	do {								\
-- 
2.17.1
