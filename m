From: Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH -next 3/3] mm: select HAVE_MOVE_PMD in x86 for faster mremap
Date: Fri,  2 Nov 2018 21:00:41 -0700
Message-ID: <20181103040041.7085-4-joelaf@google.com>
References: <20181103040041.7085-1-joelaf@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
In-Reply-To: <20181103040041.7085-1-joelaf@google.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-snps-arc/>
List-Post: <mailto:linux-snps-arc@lists.infradead.org>
List-Help: <mailto:linux-snps-arc-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=subscribe>
Sender: "linux-snps-arc" <linux-snps-arc-bounces@lists.infradead.org>
Errors-To: linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org
To: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org, Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, Will Deacon <will.deacon@arm.com>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, lokeshgidra@google.com, "Joel Fernandes (Google)" <joel@joelfernandes.org>, linux-riscv@lists.infradead.org, elfring@users.sourceforge.net, Jonas Bonn <jonas@southpole.se>, kvmarm@lists.cs.columbia.edu, dancol@google.com, Yoshinori Sato <ysato@users.sourceforge.jp>, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-hexagon@vger.kernel.org, Helge Deller <deller@gmx.de>, "maintainer:X86 ARCHITECTURE 32-BIT AND 64-BIT" <x86@kernel.org>, hughd@google.com, "James E.J. Bottomley" <jejb@parisc-linux.org>, kasan-dev@googlegroups.com, anton.i
List-Id: kvmarm@lists.cs.columbia.edu

From: "Joel Fernandes (Google)" <joel@joelfernandes.org>

Moving page-tables at the PMD-level on x86 is known to be safe. Enable
this option so that we can do fast mremap when possible.

Suggested-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ba7e3464ee92..48aef01a0bd1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -173,6 +173,7 @@ config X86
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select HAVE_MOD_ARCH_SPECIFIC
+	select HAVE_MOVE_PMD
 	select HAVE_NMI
 	select HAVE_OPROFILE
 	select HAVE_OPTPROBES
-- 
2.19.1.930.g4563a0d9d0-goog
