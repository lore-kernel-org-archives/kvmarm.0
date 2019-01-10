From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool v2 4/6] arm: Support firmware loading
Date: Thu, 10 Jan 2019 14:20:44 +0000
Message-ID: <1547130046-14729-5-git-send-email-julien.thierry@arm.com>
References: <1547130046-14729-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 813FF4A485
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:21:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ULHnmxMWP-Yp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jan 2019 09:21:00 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7664C4A3F9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 09:21:00 -0500 (EST)
In-Reply-To: <1547130046-14729-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, Sami.Mujawar@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Implement firmware image loading for arm and set the boot start address
to the firmware address.

Add an option for the user to specify where to map the firmware.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 arm/fdt.c                                | 14 +++++++-
 arm/include/arm-common/kvm-config-arch.h |  5 ++-
 arm/kvm.c                                | 61 +++++++++++++++++++++++++++++++-
 3 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/arm/fdt.c b/arm/fdt.c
index 664bb62..2936986 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -131,7 +131,19 @@ static int setup_fdt(struct kvm *kvm)
 	/* /chosen */
 	_FDT(fdt_begin_node(fdt, "chosen"));
 	_FDT(fdt_property_cell(fdt, "linux,pci-probe-only", 1));
-	_FDT(fdt_property_string(fdt, "bootargs", kvm->cfg.real_cmdline));
+
+	if (kvm->cfg.firmware_filename) {
+		/*
+		 * When using a firmware, command line is not passed through DT,
+		 * or the firmware can add it itself
+		 */
+		if (kvm->cfg.kernel_cmdline)
+			pr_warning("Ignoring custom bootargs: %s\n",
+				   kvm->cfg.kernel_cmdline);
+	} else
+		_FDT(fdt_property_string(fdt, "bootargs",
+					 kvm->cfg.real_cmdline));
+
 	_FDT(fdt_property_u64(fdt, "kaslr-seed", kvm->cfg.arch.kaslr_seed));
 
 	/* Initrd */
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 6a196f1..5734c46 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -11,6 +11,7 @@ struct kvm_config_arch {
 	bool		has_pmuv3;
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
+	u64		fw_addr;
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
@@ -30,6 +31,8 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset);
         OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
 		     "[gicv2|gicv2m|gicv3|gicv3-its]",				\
 		     "Type of interrupt controller to emulate in the guest",	\
-		     irqchip_parser, NULL),
+		     irqchip_parser, NULL),					\
+	OPT_U64('\0', "firmware-address", &(cfg)->fw_addr,			\
+		"Address where firmware should be loaded"),
 
 #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
diff --git a/arm/kvm.c b/arm/kvm.c
index c6843e5..d3f8f5d 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -169,9 +169,68 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	return true;
 }
 
+static bool validate_fw_addr(struct kvm *kvm, u64 fw_addr)
+{
+	u64 ram_phys;
+
+	ram_phys = host_to_guest_flat(kvm, kvm->ram_start);
+
+	if (fw_addr < ram_phys || fw_addr >= ram_phys + kvm->ram_size) {
+		pr_err("Provide --firmware-address an address in RAM: "
+		       "0x%016llx - 0x%016llx",
+		       ram_phys, ram_phys + kvm->ram_size);
+
+		return false;
+	}
+
+	return true;
+}
+
 bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename)
 {
-	return false;
+	u64 fw_addr = kvm->cfg.arch.fw_addr;
+	void *host_pos;
+	void *limit;
+	ssize_t fw_sz;
+	int fd;
+
+	limit = kvm->ram_start + kvm->ram_size;
+
+	/* For default firmware address, lets load it at the begining of RAM */
+	if (fw_addr == 0)
+		fw_addr = ARM_MEMORY_AREA;
+
+	if (!validate_fw_addr(kvm, fw_addr))
+		die("Bad firmware destination: 0x%016llx", fw_addr);
+
+	fd = open(firmware_filename, O_RDONLY);
+	if (fd < 0)
+		return false;
+
+	host_pos = guest_flat_to_host(kvm, fw_addr);
+	if (!host_pos || host_pos < kvm->ram_start)
+		return false;
+
+	fw_sz = read_file(fd, host_pos, limit - host_pos);
+	if (fw_sz < 0)
+		die("failed to load firmware");
+	close(fd);
+
+	/* Kernel isn't loaded by kvm, point start address to firmware */
+	kvm->arch.kern_guest_start = fw_addr;
+
+	/* Load dtb just after the firmware image*/
+	host_pos += fw_sz;
+	if (host_pos + FDT_MAX_SIZE > limit)
+		die("not enough space to load fdt");
+
+	kvm->arch.dtb_guest_start = ALIGN(host_to_guest_flat(kvm, host_pos),
+					  FDT_ALIGN);
+	pr_info("Placing fdt at 0x%llx - 0x%llx",
+		kvm->arch.dtb_guest_start,
+		kvm->arch.dtb_guest_start + FDT_MAX_SIZE);
+
+	return true;
 }
 
 int kvm__arch_setup_firmware(struct kvm *kvm)
-- 
1.9.1
