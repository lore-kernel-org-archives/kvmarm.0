From: lantianyu1986@gmail.com
Subject: [Resend PATCH V5 3/10] x86/Hyper-v: Add trace in the
 hyperv_nested_flush_guest_mapping_range()
Date: Thu,  6 Dec 2018 21:21:06 +0800
Message-ID: <20181206132113.2691-4-Tianyu.Lan@microsoft.com>
References: <20181206132113.2691-1-Tianyu.Lan@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20181206132113.2691-1-Tianyu.Lan@microsoft.com>
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

This patch is to trace log in the hyperv_nested_flush_
guest_mapping_range().

Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
---
 arch/x86/hyperv/nested.c            |  1 +
 arch/x86/include/asm/trace/hyperv.h | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/x86/hyperv/nested.c b/arch/x86/hyperv/nested.c
index 3d0f31e46954..dd0a843f766d 100644
--- a/arch/x86/hyperv/nested.c
+++ b/arch/x86/hyperv/nested.c
@@ -130,6 +130,7 @@ int hyperv_flush_guest_mapping_range(u64 as,
 	else
 		ret = status;
 fault:
+	trace_hyperv_nested_flush_guest_mapping_range(as, ret);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(hyperv_flush_guest_mapping_range);
diff --git a/arch/x86/include/asm/trace/hyperv.h b/arch/x86/include/asm/trace/hyperv.h
index 2e6245a023ef..ace464f09681 100644
--- a/arch/x86/include/asm/trace/hyperv.h
+++ b/arch/x86/include/asm/trace/hyperv.h
@@ -42,6 +42,20 @@ TRACE_EVENT(hyperv_nested_flush_guest_mapping,
 	    TP_printk("address space %llx ret %d", __entry->as, __entry->ret)
 	);
 
+TRACE_EVENT(hyperv_nested_flush_guest_mapping_range,
+	    TP_PROTO(u64 as, int ret),
+	    TP_ARGS(as, ret),
+
+	    TP_STRUCT__entry(
+		    __field(u64, as)
+		    __field(int, ret)
+		    ),
+	    TP_fast_assign(__entry->as = as;
+			   __entry->ret = ret;
+		    ),
+	    TP_printk("address space %llx ret %d", __entry->as, __entry->ret)
+	);
+
 TRACE_EVENT(hyperv_send_ipi_mask,
 	    TP_PROTO(const struct cpumask *cpus,
 		     int vector),
-- 
2.14.4
