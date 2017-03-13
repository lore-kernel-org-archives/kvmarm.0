From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: Re: [PATCH V12 09/10] trace, ras: add ARM processor error trace event
Date: Mon, 13 Mar 2017 17:00:59 +0800
Message-ID: <58C65FCB.3040508@huawei.com>
References: <1488833103-21082-1-git-send-email-tbaicar@codeaurora.org>
 <1488833103-21082-10-git-send-email-tbaicar@codeaurora.org>
 <58C12342.2090701@huawei.com>
 <14545228-7ff1-b31c-1fa5-daacf89a44b9@codeaurora.org>
 <58C60485.2070509@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <58C60485.2070509@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "Baicar, Tyler" <tbaicar@codeaurora.org>, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edukvm
Cc: "wangxiongfeng2@huawei.com" <wangxiongfeng2@huawei.com>, Guo Hanjun <guohanjun@huawei.com>, "Zhengqiang (turing)" <zhengqiang10@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Baicar Tyler,

On 2017/3/13 10:31, Xie XiuQi wrote:
> Hi Baicar Tyler,
> 
> On 2017/3/11 2:23, Baicar, Tyler wrote:
>> Hello Xie XiuQi,
>>
>>
>> On 3/9/2017 2:41 AM, Xie XiuQi wrote:
>>> On 2017/3/7 4:45, Tyler Baicar wrote:
>>>> Currently there are trace events for the various RAS
>>>> errors with the exception of ARM processor type errors.
>>>> Add a new trace event for such errors so that the user
>>>> will know when they occur. These trace events are
>>>> consistent with the ARM processor error section type
>>>> defined in UEFI 2.6 spec section N.2.4.4.
>>>>
>>>> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
>>>> Acked-by: Steven Rostedt <rostedt@goodmis.org>
>>>> ---
>>>>   drivers/acpi/apei/ghes.c    |  8 +++++++-
>>>>   drivers/firmware/efi/cper.c |  1 +
>>>>   drivers/ras/ras.c           |  1 +
>>>>   include/ras/ras_event.h     | 34 ++++++++++++++++++++++++++++++++++
>>>>   4 files changed, 43 insertions(+), 1 deletion(-)
>>
>>>> diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
>>>> index 5861b6f..b36db48 100644
>>>> --- a/include/ras/ras_event.h
>>>> +++ b/include/ras/ras_event.h
>>>> @@ -162,6 +162,40 @@
>>>>   );
>>>>     /*
>>>> + * ARM Processor Events Report
>>>> + *
>>>> + * This event is generated when hardware detects an ARM processor error
>>>> + * has occurred. UEFI 2.6 spec section N.2.4.4.
>>>> + */
>>>> +TRACE_EVENT(arm_event,
>>>> +
>>>> +    TP_PROTO(const struct cper_sec_proc_arm *proc),
>>>> +
>>>> +    TP_ARGS(proc),
>>>> +
>>>> +    TP_STRUCT__entry(
>>>> +        __field(u64, mpidr)
>>>> +        __field(u64, midr)
>>>> +        __field(u32, running_state)
>>>> +        __field(u32, psci_state)
>>>> +        __field(u8, affinity)
>>>> +    ),
>>>> +
>>>> +    TP_fast_assign(
>>>> +        __entry->affinity = proc->affinity_level;
>>>> +        __entry->mpidr = proc->mpidr;
>>>> +        __entry->midr = proc->midr;
>>>> +        __entry->running_state = proc->running_state;
>>>> +        __entry->psci_state = proc->psci_state;
>>>> +    ),
>>>> +
>>>> +    TP_printk("affinity level: %d; MPIDR: %016llx; MIDR: %016llx; "
>>>> +          "running state: %d; PSCI state: %d",
>>>> +          __entry->affinity, __entry->mpidr, __entry->midr,
>>>> +          __entry->running_state, __entry->psci_state)
>>>> +);
>>>> +
>>> I think these fields are not enough, we need also export arm processor error
>>> information (UEFI 2.6 spec section N.2.4.4.1), or at least the error type,
>>> address, etc. So that the userspace (such as rasdaemon tool) could know what
>>> error occurred.
>>
>> This is something I am planning on adding in later. It is not clear to me how to
>> actually do this at this point. If you look at the spec, there is not a single
>> error information structure. There is at least one, but possibly a lot. There is
>> also an unknown amount of context information structures. In "Table 260. ARM Processor
>> Error Section" there are ERR_INFO_NUM and CONTEXT_INFO_NUM which give the number of these
>> structures. I think there will need to be separate trace events added in for each of
>> these structures because I don't think there is a way to have variable amounts of
>> structures inside of a trace event.

I have a patch below to add a trace event to expose arm processor error information
to user space. Would you take it to your series or later series if possible.
Any comments is welcome.

This patch is just compile OK. I have no arm box for testing just now.
Any one who can help to test it is very grateful.

Thanks.

>From e591570eecc6cd70e18d8f8ae75534b55a22f7ba Mon Sep 17 00:00:00 2001
From: Xie XiuQi <xiexiuqi@huawei.com>
Date: Mon, 13 Mar 2017 15:46:06 +0800
Subject: [PATCH] trace: ras: add ARM processor error information trace event

Add a new trace event for ARM processor error information, so that
the user will know what error occurred. With this information the
user may take appropriate action.

These trace events are consistent with the ARM processor error
information table which defined in UEFI 2.6 spec section N.2.4.4.1.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 drivers/acpi/apei/ghes.c |  8 +++++
 include/linux/cper.h     |  5 +++
 include/ras/ras_event.h  | 87 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 251d7e0..6d34c26 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -518,9 +518,17 @@ static void ghes_do_proc(struct ghes *ghes,
 		else if (!uuid_le_cmp(sec_type, CPER_SEC_PROC_ARM) &&
 			 trace_arm_event_enabled()) {
 			struct cper_sec_proc_arm *arm_err;
+			struct cper_arm_err_info *err_info;
+			int i;

 			arm_err = acpi_hest_generic_data_payload(gdata);
 			trace_arm_event(arm_err);
+
+			err_info = (struct cper_arm_err_info *)(arm_err + 1);
+			for (i = 0; i < arm_err->err_info_num; i++) {
+				trace_arm_proc_err(err_info);
+				err_info += 1;
+			}
 		} else if (trace_unknown_sec_event_enabled()) {
 			void *unknown_err = acpi_hest_generic_data_payload(gdata);
 			trace_unknown_sec_event(&sec_type,
diff --git a/include/linux/cper.h b/include/linux/cper.h
index 85450f3..0cae900 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -270,6 +270,11 @@ enum {
 #define CPER_ARM_INFO_VALID_VIRT_ADDR		0x0008
 #define CPER_ARM_INFO_VALID_PHYSICAL_ADDR	0x0010

+#define CPER_ARM_INFO_TYPE_CACHE		0
+#define CPER_ARM_INFO_TYPE_TLB			1
+#define CPER_ARM_INFO_TYPE_BUS			2
+#define CPER_ARM_INFO_TYPE_UARCH		3
+
 #define CPER_ARM_INFO_FLAGS_FIRST		0x0001
 #define CPER_ARM_INFO_FLAGS_LAST		0x0002
 #define CPER_ARM_INFO_FLAGS_PROPAGATED		0x0004
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index b36db48..72c6a06 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -195,6 +195,93 @@
 		  __entry->running_state, __entry->psci_state)
 );

+#define ARM_PROC_ERR_TYPE	\
+	EM ( CPER_ARM_INFO_TYPE_CACHE, "cache error" )	\
+	EM ( CPER_ARM_INFO_TYPE_TLB,  "TLB error" )	\
+	EM ( CPER_ARM_INFO_TYPE_BUS, "bus error" )	\
+	EMe ( CPER_ARM_INFO_TYPE_UARCH, "micro-architectural error" )
+
+#define ARM_PROC_ERR_FLAGS	\
+	EM ( CPER_ARM_INFO_FLAGS_FIRST, "First error captured" )	\
+	EM ( CPER_ARM_INFO_FLAGS_LAST,  "Last error captured" )	\
+	EM ( CPER_ARM_INFO_FLAGS_PROPAGATED, "Propagated" )	\
+	EMe ( CPER_ARM_INFO_FLAGS_OVERFLOW, "Overflow" )
+
+/*
+ * First define the enums in MM_ACTION_RESULT to be exported to userspace
+ * via TRACE_DEFINE_ENUM().
+ */
+#undef EM
+#undef EMe
+#define EM(a, b) TRACE_DEFINE_ENUM(a);
+#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
+
+ARM_PROC_ERR_TYPE
+ARM_PROC_ERR_FLAGS
+
+/*
+ * Now redefine the EM() and EMe() macros to map the enums to the strings
+ * that will be printed in the output.
+ */
+#undef EM
+#undef EMe
+#define EM(a, b)		{ a, b },
+#define EMe(a, b)	{ a, b }
+
+TRACE_EVENT(arm_proc_error,
+
+	TP_PROTO(const struct cper_arm_err_info *err),
+
+	TP_ARGS(err),
+
+	TP_STRUCT__entry(
+		__field(u8, type)
+		__field(u16, multiple_error)
+		__field(u8, flags)
+		__field(u64, error_info)
+		__field(u64, virt_fault_addr)
+		__field(u64, physical_fault_addr)
+	),
+
+	TP_fast_assign(
+		__entry->type = err->type;
+
+		if (err->validation_bits & CPER_ARM_INFO_VALID_MULTI_ERR)
+			__entry->multiple_error = err->multiple_error;
+		else
+			__entry->multiple_error = ~0;
+			
+		if (err->validation_bits & CPER_ARM_INFO_VALID_FLAGS)
+			__entry->flags = err->flags;
+		else
+			__entry->flags = ~0;
+
+		if (err->validation_bits & CPER_ARM_INFO_VALID_ERR_INFO)
+			__entry->error_info = err->error_info;
+		else
+			__entry->error_info = 0ULL;
+
+		if (err->validation_bits & CPER_ARM_INFO_VALID_VIRT_ADDR)
+			__entry->virt_fault_addr = err->virt_fault_addr;
+		else
+			__entry->virt_fault_addr = 0ULL;
+
+		if (err->validation_bits & CPER_ARM_INFO_VALID_PHYSICAL_ADDR)
+			__entry->physical_fault_addr = err->physical_fault_addr;
+		else
+			__entry->physical_fault_addr = 0ULL;
+	),
+
+	TP_printk("ARM Processor Error: type %s; count: %u; flags: %s;"
+		  " error info: %016llx; virtual address: %016llx;"
+		  " physical address: %016llx",
+		  __print_symbolic(__entry->type, ARCH_PROC_ERR_TYPE),
+		  __entry->multiple_error,
+		  __print_symbolic(__entry->flags, ARCH_PROC_ERR_FLAGS),
+		  __entry->error_info, __entry->virt_fault_addr,
+		  __entry->physical_fault_addr)
+);
+
 /*
  * Unknown Section Report
  *
-- 
1.8.3.1



> 
> Yes, I agree.
> 
> Additional, cper_sec_proc_arm has validation bit, which indicates whether or not each of
> the fields is valid in this section. How could we show it in this trace event? If the filed
> is invalid, we would get a wrong value here.
> 
> --
> Thanks,
> Xie XiuQi
> 
>>
>> The ARM processor error section also has a vendor specific error info buffer which will need to be exposed to userspace. This may be something that can reuse the unknown section type trace event or have it's own trace event for.
>>
>> Thanks,
>> Tyler
>>

