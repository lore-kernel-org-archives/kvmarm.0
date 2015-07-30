From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 07/14] MIPS: move ELF headers loading outside of
 load_elf_binary()
Date: Thu, 30 Jul 2015 11:52:24 +0100
Message-ID: <1438253551-2378-8-git-send-email-andre.przywara@arm.com>
References: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39CD9596EC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2015 06:40:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3XTaoOTOS0LS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2015 06:40:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0E29596D5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2015 06:40:03 -0400 (EDT)
In-Reply-To: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Refactor MIPS' load_elf_binary() implementation by not reading the
ELF header itself, but using a pointer to a memory buffer instead.
This prepares for removing the need to rewind the image file later.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 mips/kvm.c | 52 +++++++++++++++++++++++++---------------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/mips/kvm.c b/mips/kvm.c
index 4d08b20..ed81a02 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -282,46 +282,39 @@ static bool kvm__arch_get_elf_32_info(Elf32_Ehdr *ehdr, int fd_kernel,
 	return true;
 }
 
-static bool load_elf_binary(struct kvm *kvm, int fd_kernel)
-{
-	union {
-		Elf64_Ehdr ehdr;
-		Elf32_Ehdr ehdr32;
-	} eh;
+union ElfHeaders {
+	Elf64_Ehdr ehdr;
+	Elf32_Ehdr ehdr32;
+};
 
+static bool load_elf_binary(struct kvm *kvm, int fd_kernel,
+			    union ElfHeaders *eh)
+{
 	size_t nr;
 	char *p;
 	struct kvm__arch_elf_info ei;
 
-	if (lseek(fd_kernel, 0, SEEK_SET) < 0)
-		die_perror("lseek");
-
-	nr = read(fd_kernel, &eh, sizeof(eh));
-	if (nr != sizeof(eh)) {
-		pr_info("Couldn't read %d bytes for ELF header.", (int)sizeof(eh));
-		return false;
-	}
-
-	if (eh.ehdr.e_ident[EI_MAG0] != ELFMAG0 ||
-	    eh.ehdr.e_ident[EI_MAG1] != ELFMAG1 ||
-	    eh.ehdr.e_ident[EI_MAG2] != ELFMAG2 ||
-	    eh.ehdr.e_ident[EI_MAG3] != ELFMAG3 ||
-	    (eh.ehdr.e_ident[EI_CLASS] != ELFCLASS64 && eh.ehdr.e_ident[EI_CLASS] != ELFCLASS32) ||
-	    eh.ehdr.e_ident[EI_VERSION] != EV_CURRENT) {
+	if (eh->ehdr.e_ident[EI_MAG0] != ELFMAG0 ||
+	    eh->ehdr.e_ident[EI_MAG1] != ELFMAG1 ||
+	    eh->ehdr.e_ident[EI_MAG2] != ELFMAG2 ||
+	    eh->ehdr.e_ident[EI_MAG3] != ELFMAG3 ||
+	    (eh->ehdr.e_ident[EI_CLASS] != ELFCLASS64 &&
+		eh->ehdr.e_ident[EI_CLASS] != ELFCLASS32) ||
+	    eh->ehdr.e_ident[EI_VERSION] != EV_CURRENT) {
 		pr_info("Incompatible ELF header.");
 		return false;
 	}
-	if (eh.ehdr.e_type != ET_EXEC || eh.ehdr.e_machine != EM_MIPS) {
+	if (eh->ehdr.e_type != ET_EXEC || eh->ehdr.e_machine != EM_MIPS) {
 		pr_info("Incompatible ELF not MIPS EXEC.");
 		return false;
 	}
 
-	if (eh.ehdr.e_ident[EI_CLASS] == ELFCLASS64) {
-		if (!kvm__arch_get_elf_64_info(&eh.ehdr, fd_kernel, &ei))
+	if (eh->ehdr.e_ident[EI_CLASS] == ELFCLASS64) {
+		if (!kvm__arch_get_elf_64_info(&eh->ehdr, fd_kernel, &ei))
 			return false;
 		kvm->arch.is64bit = true;
 	} else {
-		if (!kvm__arch_get_elf_32_info(&eh.ehdr32, fd_kernel, &ei))
+		if (!kvm__arch_get_elf_32_info(&eh->ehdr32, fd_kernel, &ei))
 			return false;
 		kvm->arch.is64bit = false;
 	}
@@ -334,7 +327,8 @@ static bool load_elf_binary(struct kvm *kvm, int fd_kernel)
 	p = guest_flat_to_host(kvm, ei.load_addr);
 
 	pr_info("ELF Loading 0x%lx bytes from 0x%llx to 0x%llx",
-		(unsigned long)ei.len, (unsigned long long)ei.offset, (unsigned long long)ei.load_addr);
+		(unsigned long)ei.len, (unsigned long long)ei.offset,
+		(unsigned long long)ei.load_addr);
 	do {
 		nr = read(fd_kernel, p, ei.len);
 		if (nr < 0)
@@ -349,12 +343,16 @@ static bool load_elf_binary(struct kvm *kvm, int fd_kernel)
 bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 				 const char *kernel_cmdline)
 {
+	union ElfHeaders eh;
+
 	if (fd_initrd != -1) {
 		pr_err("Initrd not supported on MIPS.");
 		return false;
 	}
 
-	if (load_elf_binary(kvm, fd_kernel)) {
+	read_in_full(fd_kernel, &eh, sizeof(eh));
+
+	if (load_elf_binary(kvm, fd_kernel, &eh)) {
 		kvm__mips_install_cmdline(kvm);
 		return true;
 	}
-- 
2.3.5
