From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 13/14] MIPS: use read wrappers in kernel loading
Date: Thu, 30 Jul 2015 11:52:30 +0100
Message-ID: <1438253551-2378-14-git-send-email-andre.przywara@arm.com>
References: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1679F59712
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2015 06:40:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lbQ9mCExUynr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2015 06:40:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7F5A5970A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2015 06:40:11 -0400 (EDT)
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

Replace the unsafe read-loops used in the MIPS kernel image loading
with our safe read_file() and read_in_full() wrappers.
This should fix random fails in kernel image loading, especially
from pipes and sockets.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 mips/kvm.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/mips/kvm.c b/mips/kvm.c
index d970ee0..2f0d61b 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -169,21 +169,27 @@ static bool load_flat_binary(struct kvm *kvm, int fd_kernel, const void *buf,
 {
 	void *p;
 	void *k_start;
-	int nr;
+	ssize_t kernel_size;
 
 	p = k_start = guest_flat_to_host(kvm, KERNEL_LOAD_ADDR);
 
 	memcpy(p, buf, buflen);
 	p += buflen;
 
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
 
-	pr_info("Loaded kernel to 0x%x (%ld bytes)", KERNEL_LOAD_ADDR,
-		(long int)(p - k_start));
+	pr_info("Loaded kernel to 0x%x (%zd bytes)", KERNEL_LOAD_ADDR,
+		kernel_size);
 
 	return true;
 }
@@ -199,7 +205,6 @@ static bool kvm__arch_get_elf_64_info(Elf64_Ehdr *ehdr, int fd_kernel,
 				      struct kvm__arch_elf_info *ei)
 {
 	int i;
-	size_t nr;
 	Elf64_Phdr phdr;
 
 	if (ehdr->e_phentsize != sizeof(phdr)) {
@@ -214,8 +219,7 @@ static bool kvm__arch_get_elf_64_info(Elf64_Ehdr *ehdr, int fd_kernel,
 
 	phdr.p_type = PT_NULL;
 	for (i = 0; i < ehdr->e_phnum; i++) {
-		nr = read(fd_kernel, &phdr, sizeof(phdr));
-		if (nr != sizeof(phdr)) {
+		if (read_in_full(fd_kernel, &phdr, sizeof(phdr)) != sizeof(phdr)) {
 			pr_info("Couldn't read %d bytes for ELF PHDR.", (int)sizeof(phdr));
 			return false;
 		}
@@ -245,7 +249,6 @@ static bool kvm__arch_get_elf_32_info(Elf32_Ehdr *ehdr, int fd_kernel,
 				      struct kvm__arch_elf_info *ei)
 {
 	int i;
-	size_t nr;
 	Elf32_Phdr phdr;
 
 	if (ehdr->e_phentsize != sizeof(phdr)) {
@@ -260,8 +263,7 @@ static bool kvm__arch_get_elf_32_info(Elf32_Ehdr *ehdr, int fd_kernel,
 
 	phdr.p_type = PT_NULL;
 	for (i = 0; i < ehdr->e_phnum; i++) {
-		nr = read(fd_kernel, &phdr, sizeof(phdr));
-		if (nr != sizeof(phdr)) {
+		if (read_in_full(fd_kernel, &phdr, sizeof(phdr)) != sizeof(phdr)) {
 			pr_info("Couldn't read %d bytes for ELF PHDR.", (int)sizeof(phdr));
 			return false;
 		}
@@ -292,7 +294,6 @@ union ElfHeaders {
 static bool load_elf_binary(struct kvm *kvm, int fd_kernel,
 			    union ElfHeaders *eh)
 {
-	size_t nr;
 	char *p;
 	struct kvm__arch_elf_info ei;
 
@@ -331,13 +332,9 @@ static bool load_elf_binary(struct kvm *kvm, int fd_kernel,
 	pr_info("ELF Loading 0x%lx bytes from 0x%llx to 0x%llx",
 		(unsigned long)ei.len, (unsigned long long)ei.offset,
 		(unsigned long long)ei.load_addr);
-	do {
-		nr = read(fd_kernel, p, ei.len);
-		if (nr < 0)
-			die_perror("read");
-		p += nr;
-		ei.len -= nr;
-	} while (ei.len);
+
+	if (read_in_full(fd_kernel, p, ei.len) != (ssize_t)ei.len)
+		die_perror("read");
 
 	return true;
 }
-- 
2.3.5
