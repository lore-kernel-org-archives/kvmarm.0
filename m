From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 4/7] MIPS: use read wrappers in kernel loading
Date: Fri, 30 Oct 2015 18:26:57 +0000
Message-ID: <1446229620-28088-5-git-send-email-andre.przywara@arm.com>
References: <1446229620-28088-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1446229620-28088-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm-ppc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Replace the unsafe read-loops used in the MIPS kernel image loading
with our safe read_file() and read_in_full() wrappers.
This should fix random fails in kernel image loading, especially
from pipes and sockets.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 mips/kvm.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/mips/kvm.c b/mips/kvm.c
index c1c596c..8fbf8de 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -168,20 +168,27 @@ static bool load_flat_binary(struct kvm *kvm, int fd_kernel)
 {
 	void *p;
 	void *k_start;
-	int nr;
+	ssize_t kernel_size;
 
 	if (lseek(fd_kernel, 0, SEEK_SET) < 0)
 		die_perror("lseek");
 
 	p = k_start = guest_flat_to_host(kvm, KERNEL_LOAD_ADDR);
 
-	while ((nr = read(fd_kernel, p, 65536)) > 0)
-		p += nr;
+	kernel_size = read_file(fd_kernel, p,
+				kvm->cfg.ram_size - KERNEL_LOAD_ADDR);
+	if (kernel_size == -1) {
+		if (errno == ENOMEM)
+			die("kernel too big for guest memory");
+		else
+			die_perror("kernel read");
+	}
 
 	kvm->arch.is64bit = true;
 	kvm->arch.entry_point = 0xffffffff81000000ull;
 
-	pr_info("Loaded kernel to 0x%x (%ld bytes)", KERNEL_LOAD_ADDR, (long int)(p - k_start));
+	pr_info("Loaded kernel to 0x%x (%zd bytes)", KERNEL_LOAD_ADDR,
+		kernel_size);
 
 	return true;
 }
@@ -197,7 +204,6 @@ static bool kvm__arch_get_elf_64_info(Elf64_Ehdr *ehdr, int fd_kernel,
 				      struct kvm__arch_elf_info *ei)
 {
 	int i;
-	size_t nr;
 	Elf64_Phdr phdr;
 
 	if (ehdr->e_phentsize != sizeof(phdr)) {
@@ -212,8 +218,7 @@ static bool kvm__arch_get_elf_64_info(Elf64_Ehdr *ehdr, int fd_kernel,
 
 	phdr.p_type = PT_NULL;
 	for (i = 0; i < ehdr->e_phnum; i++) {
-		nr = read(fd_kernel, &phdr, sizeof(phdr));
-		if (nr != sizeof(phdr)) {
+		if (read_in_full(fd_kernel, &phdr, sizeof(phdr)) != sizeof(phdr)) {
 			pr_info("Couldn't read %d bytes for ELF PHDR.", (int)sizeof(phdr));
 			return false;
 		}
@@ -243,7 +248,6 @@ static bool kvm__arch_get_elf_32_info(Elf32_Ehdr *ehdr, int fd_kernel,
 				      struct kvm__arch_elf_info *ei)
 {
 	int i;
-	size_t nr;
 	Elf32_Phdr phdr;
 
 	if (ehdr->e_phentsize != sizeof(phdr)) {
@@ -258,8 +262,7 @@ static bool kvm__arch_get_elf_32_info(Elf32_Ehdr *ehdr, int fd_kernel,
 
 	phdr.p_type = PT_NULL;
 	for (i = 0; i < ehdr->e_phnum; i++) {
-		nr = read(fd_kernel, &phdr, sizeof(phdr));
-		if (nr != sizeof(phdr)) {
+		if (read_in_full(fd_kernel, &phdr, sizeof(phdr)) != sizeof(phdr)) {
 			pr_info("Couldn't read %d bytes for ELF PHDR.", (int)sizeof(phdr));
 			return false;
 		}
@@ -334,14 +337,11 @@ static bool load_elf_binary(struct kvm *kvm, int fd_kernel)
 	p = guest_flat_to_host(kvm, ei.load_addr);
 
 	pr_info("ELF Loading 0x%lx bytes from 0x%llx to 0x%llx",
-		(unsigned long)ei.len, (unsigned long long)ei.offset, (unsigned long long)ei.load_addr);
-	do {
-		nr = read(fd_kernel, p, ei.len);
-		if (nr < 0)
-			die_perror("read");
-		p += nr;
-		ei.len -= nr;
-	} while (ei.len);
+		(unsigned long)ei.len, (unsigned long long)ei.offset,
+		(unsigned long long)ei.load_addr);
+
+	if (read_in_full(fd_kernel, p, ei.len) != (ssize_t)ei.len)
+		die_perror("read");
 
 	return true;
 }
-- 
2.5.1

