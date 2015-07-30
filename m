From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 06/14] MIPS: use pseek() in ELF kernel image loading
Date: Thu, 30 Jul 2015 11:52:23 +0100
Message-ID: <1438253551-2378-7-git-send-email-andre.przywara@arm.com>
References: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1438253551-2378-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Use the newly introduced pseek() function when skipping to the start
offset in the ELF file.
The layout of an ELF file should satisfy the constraints of pseek, so
that we should be able to use a pipe file descriptor as well.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 mips/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mips/kvm.c b/mips/kvm.c
index c1c596c..4d08b20 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -328,8 +328,8 @@ static bool load_elf_binary(struct kvm *kvm, int fd_kernel)
 
 	kvm->arch.entry_point = ei.entry_point;
 
-	if (lseek(fd_kernel, ei.offset, SEEK_SET) < 0)
-		die_perror("lseek");
+	if (!pseek(fd_kernel, ei.offset - sizeof(union ElfHeaders)))
+		die_perror("seek");
 
 	p = guest_flat_to_host(kvm, ei.load_addr);
 
-- 
2.3.5

