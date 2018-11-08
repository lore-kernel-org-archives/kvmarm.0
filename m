From: lantianyu1986@gmail.com
Subject: [Resend PATCH V5 2/10] x86/hyper-v: Add HvFlushGuestAddressList
 hypercall support
Date: Thu,  8 Nov 2018 22:46:31 +0800
Message-ID: <20181108144639.11206-2-Tianyu.Lan@microsoft.com>
References: <20181108144639.11206-1-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20181108144639.11206-1-Tianyu.Lan@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
Cc: linux-mips@linux-mips.org, kvm@vger.kernel.org, rkrcmar@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, paulus@ozlabs.org, hpa@zytor.com, kvmarm@lists.cs.columbia.edu, sthemmin@microsoft.com, mpe@ellerman.id.au, x86@kernel.org, linux@armlinux.org.uk, michael.h.kelley@microsoft.com, mingo@redhat.com, benh@kernel.crashing.org, jhogan@kernel.org, Lan Tianyu <Tianyu.Lan@microsoft.com>, marc.zyngier@arm.com, haiyangz@microsoft.com, kvm-ppc@vger.kernel.org, bp@alien8.de, devel@linuxdriverproject.org, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, christoffer.dall@arm.com, ralf@linux-mips.org, paul.burton@mips.com, pbonzini@redhat.com, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Lan Tianyu <Tianyu.Lan@microsoft.com>

Hyper-V provides HvFlushGuestAddressList() hypercall to flush EPT tlb
with specified ranges. This patch is to add the hypercall support.

Reviewed-by:  Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
---
Change sincd v4:
       - Expose function hyperv_fill_flush_guest_mapping_list()
       out of hyperv file
       - Adjust parameter of hyperv_flush_guest_mapping_range()

Change since v2:
      Fix some coding style issues
        - Move HV_MAX_FLUSH_PAGES and HV_MAX_FLUSH_REP_COUNT to
	hyperv-tlfs.h.
	- Calculate HV_MAX_FLUSH_REP_COUNT in the macro definition
	- Use HV_MAX_FLUSH_REP_COUNT to define length of gpa_list in
	struct hv_guest_mapping_flush_list.

Change since v1:
       Add hyperv tlb flush struct to avoid use kvm tlb flush struct
in the hyperv file.
---
 arch/x86/hyperv/nested.c           | 79 ++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/hyperv-tlfs.h | 32 +++++++++++++++
 arch/x86/include/asm/mshyperv.h    | 15 ++++++++
 3 files changed, 126 insertions(+)

diff --git a/arch/x86/hyperv/nested.c b/arch/x86/hyperv/nested.c
index b8e60cc50461..3d0f31e46954 100644
--- a/arch/x86/hyperv/nested.c
+++ b/arch/x86/hyperv/nested.c
@@ -7,6 +7,7 @@
  *
  * Author : Lan Tianyu <Tianyu.Lan@microsoft.com>
  */
+#define pr_fmt(fmt)  "Hyper-V: " fmt
 
 
 #include <linux/types.h>
@@ -54,3 +55,81 @@ int hyperv_flush_guest_mapping(u64 as)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(hyperv_flush_guest_mapping);
+
+int hyperv_fill_flush_guest_mapping_list(
+		struct hv_guest_mapping_flush_list *flush,
+		u64 start_gfn, u64 pages)
+{
+	u64 cur = start_gfn;
+	u64 additional_pages;
+	int gpa_n = 0;
+
+	do {
+		/*
+		 * If flush requests exceed max flush count, go back to
+		 * flush tlbs without range.
+		 */
+		if (gpa_n >= HV_MAX_FLUSH_REP_COUNT)
+			return -ENOSPC;
+
+		additional_pages = min_t(u64, pages, HV_MAX_FLUSH_PAGES) - 1;
+
+		flush->gpa_list[gpa_n].page.additional_pages = additional_pages;
+		flush->gpa_list[gpa_n].page.largepage = false;
+		flush->gpa_list[gpa_n].page.basepfn = cur;
+
+		pages -= additional_pages + 1;
+		cur += additional_pages + 1;
+		gpa_n++;
+	} while (pages > 0);
+
+	return gpa_n;
+}
+EXPORT_SYMBOL_GPL(hyperv_fill_flush_guest_mapping_list);
+
+int hyperv_flush_guest_mapping_range(u64 as,
+		hyperv_fill_flush_list_func fill_flush_list_func, void *data)
+{
+	struct hv_guest_mapping_flush_list **flush_pcpu;
+	struct hv_guest_mapping_flush_list *flush;
+	u64 status = 0;
+	unsigned long flags;
+	int ret = -ENOTSUPP;
+	int gpa_n = 0;
+
+	if (!hv_hypercall_pg || !fill_flush_list_func)
+		goto fault;
+
+	local_irq_save(flags);
+
+	flush_pcpu = (struct hv_guest_mapping_flush_list **)
+		this_cpu_ptr(hyperv_pcpu_input_arg);
+
+	flush = *flush_pcpu;
+	if (unlikely(!flush)) {
+		local_irq_restore(flags);
+		goto fault;
+	}
+
+	flush->address_space = as;
+	flush->flags = 0;
+
+	gpa_n = fill_flush_list_func(flush, data);
+	if (gpa_n < 0) {
+		local_irq_restore(flags);
+		goto fault;
+	}
+
+	status = hv_do_rep_hypercall(HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST,
+				     gpa_n, 0, flush, NULL);
+
+	local_irq_restore(flags);
+
+	if (!(status & HV_HYPERCALL_RESULT_MASK))
+		ret = 0;
+	else
+		ret = status;
+fault:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(hyperv_flush_guest_mapping_range);
diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 4139f7650fe5..405a378e1c62 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -10,6 +10,7 @@
 #define _ASM_X86_HYPERV_TLFS_H
 
 #include <linux/types.h>
+#include <asm/page.h>
 
 /*
  * The below CPUID leaves are present if VersionAndFeatures.HypervisorPresent
@@ -358,6 +359,7 @@ struct hv_tsc_emulation_status {
 #define HVCALL_POST_MESSAGE			0x005c
 #define HVCALL_SIGNAL_EVENT			0x005d
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
+#define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
 
 #define HV_X64_MSR_VP_ASSIST_PAGE_ENABLE	0x00000001
 #define HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_SHIFT	12
@@ -757,6 +759,36 @@ struct hv_guest_mapping_flush {
 	u64 flags;
 };
 
+/*
+ *  HV_MAX_FLUSH_PAGES = "additional_pages" + 1. It's limited
+ *  by the bitwidth of "additional_pages" in union hv_gpa_page_range.
+ */
+#define HV_MAX_FLUSH_PAGES (2048)
+
+/* HvFlushGuestPhysicalAddressList hypercall */
+union hv_gpa_page_range {
+	u64 address_space;
+	struct {
+		u64 additional_pages:11;
+		u64 largepage:1;
+		u64 basepfn:52;
+	} page;
+};
+
+/*
+ * All input flush parameters should be in single page. The max flush
+ * count is equal with how many entries of union hv_gpa_page_range can
+ * be populated into the input parameter page.
+ */
+#define HV_MAX_FLUSH_REP_COUNT (PAGE_SIZE - 2 * sizeof(u64) /	\
+				sizeof(union hv_gpa_page_range))
+
+struct hv_guest_mapping_flush_list {
+	u64 address_space;
+	u64 flags;
+	union hv_gpa_page_range gpa_list[HV_MAX_FLUSH_REP_COUNT];
+};
+
 /* HvFlushVirtualAddressSpace, HvFlushVirtualAddressList hypercalls */
 struct hv_tlb_flush {
 	u64 address_space;
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index 0d6271cce198..fde76f66f354 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -22,6 +22,11 @@ struct ms_hyperv_info {
 
 extern struct ms_hyperv_info ms_hyperv;
 
+
+typedef int (*hyperv_fill_flush_list_func)(
+		struct hv_guest_mapping_flush_list *flush,
+		void *data);
+
 /*
  * Generate the guest ID.
  */
@@ -348,6 +353,11 @@ void set_hv_tscchange_cb(void (*cb)(void));
 void clear_hv_tscchange_cb(void);
 void hyperv_stop_tsc_emulation(void);
 int hyperv_flush_guest_mapping(u64 as);
+int hyperv_flush_guest_mapping_range(u64 as,
+		hyperv_fill_flush_list_func fill_func, void *data);
+int hyperv_fill_flush_guest_mapping_list(
+		struct hv_guest_mapping_flush_list *flush,
+		u64 start_gfn, u64 end_gfn);
 
 #ifdef CONFIG_X86_64
 void hv_apic_init(void);
@@ -370,6 +380,11 @@ static inline struct hv_vp_assist_page *hv_get_vp_assist_page(unsigned int cpu)
 	return NULL;
 }
 static inline int hyperv_flush_guest_mapping(u64 as) { return -1; }
+static inline int hyperv_flush_guest_mapping_range(u64 as,
+		hyperv_fill_flush_list_func fill_func, void *data);
+{
+	return -1;
+}
 #endif /* CONFIG_HYPERV */
 
 #ifdef CONFIG_HYPERV_TSCPAGE
-- 
2.14.4
