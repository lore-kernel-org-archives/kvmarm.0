From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH v3 1/8] trace: ras: add ARM processor error information
 trace event
Date: Fri, 14 Apr 2017 14:36:06 -0600
Message-ID: <32ca4e7e-eb5e-a4ff-33d6-68d06e9242fb@codeaurora.org>
References: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
 <1490869877-118713-11-git-send-email-xiexiuqi@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1490869877-118713-11-git-send-email-xiexiuqi@huawei.com>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: Xie XiuQi <xiexiuqi@huawei.com>, christoffer.dall@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, fu.wei@linaro.org, rostedt@goodmis.org, hanjun.guo@linaro.org, shiju.jose@huawei.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, gengdongjiu@huawei.com, zhengqiang10@huawei.com, wuquanming@huawei.com, wangxiongfeng2@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 3/30/2017 4:31 AM, Xie XiuQi wrote:
> Add a new trace event for ARM processor error information, so that
> the user will know what error occurred. With this information the
> user may take appropriate action.
>
> These trace events are consistent with the ARM processor error
> information table which defined in UEFI 2.6 spec section N.2.4.4.1.
>
> ---
> v2: add trace enabled condition as Steven's suggestion.
>      fix a typo.
> ---
>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Tyler Baicar <tbaicar@codeaurora.org>
> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
> ---
...
>   
> +#define ARM_PROC_ERR_TYPE	\
> +	EM ( CPER_ARM_INFO_TYPE_CACHE, "cache error" )	\
> +	EM ( CPER_ARM_INFO_TYPE_TLB,  "TLB error" )	\
> +	EM ( CPER_ARM_INFO_TYPE_BUS, "bus error" )	\
> +	EMe ( CPER_ARM_INFO_TYPE_UARCH, "micro-architectural error" )
> +
> +#define ARM_PROC_ERR_FLAGS	\
> +	EM ( CPER_ARM_INFO_FLAGS_FIRST, "First error captured" )	\
> +	EM ( CPER_ARM_INFO_FLAGS_LAST,  "Last error captured" )	\
> +	EM ( CPER_ARM_INFO_FLAGS_PROPAGATED, "Propagated" )	\
> +	EMe ( CPER_ARM_INFO_FLAGS_OVERFLOW, "Overflow" )
> +
Hello Xie XiuQi,

This isn't compiling for me because of these definitions. Here you are 
using ARM_*, but below in the TP_printk you are using ARCH_*. The 
compiler complains the ARCH_* ones are undefined:

./include/trace/../../include/ras/ras_event.h:278:37: error: 
'ARCH_PROC_ERR_TYPE' undeclared (first use in this function)
      __print_symbolic(__entry->type, ARCH_PROC_ERR_TYPE),
./include/trace/../../include/ras/ras_event.h:280:38: error: 
'ARCH_PROC_ERR_FLAGS' undeclared (first use in this function)
      __print_symbolic(__entry->flags, ARCH_PROC_ERR_FLAGS),

> +/*
> + * First define the enums in MM_ACTION_RESULT to be exported to userspace
> + * via TRACE_DEFINE_ENUM().
> + */
> +#undef EM
> +#undef EMe
> +#define EM(a, b) TRACE_DEFINE_ENUM(a);
> +#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
> +
> +ARM_PROC_ERR_TYPE
> +ARM_PROC_ERR_FLAGS
Are the above two lines supposed to be here?
> +
> +/*
> + * Now redefine the EM() and EMe() macros to map the enums to the strings
> + * that will be printed in the output.
> + */
> +#undef EM
> +#undef EMe
> +#define EM(a, b)		{ a, b },
> +#define EMe(a, b)	{ a, b }
> +
> +TRACE_EVENT(arm_proc_err,
I think it would be better to keep this similar to the naming of the 
current RAS trace events (right now we have mc_event, arm_event, 
aer_event, etc.). I would suggest using "arm_err_info_event" since this 
is handling the error information structures of the arm errors.
> +
> +	TP_PROTO(const struct cper_arm_err_info *err),
> +
> +	TP_ARGS(err),
> +
> +	TP_STRUCT__entry(
> +		__field(u8, type)
> +		__field(u16, multiple_error)
> +		__field(u8, flags)
> +		__field(u64, error_info)
> +		__field(u64, virt_fault_addr)
> +		__field(u64, physical_fault_addr)
Validation bits should also be a part of this structure that way user 
space tools will know which of these fields are valid.
> +	),
> +
> +	TP_fast_assign(
> +		__entry->type = err->type;
> +
> +		if (err->validation_bits & CPER_ARM_INFO_VALID_MULTI_ERR)
> +			__entry->multiple_error = err->multiple_error;
> +		else
> +			__entry->multiple_error = ~0;
> +
> +		if (err->validation_bits & CPER_ARM_INFO_VALID_FLAGS)
> +			__entry->flags = err->flags;
> +		else
> +			__entry->flags = ~0;
> +
> +		if (err->validation_bits & CPER_ARM_INFO_VALID_ERR_INFO)
> +			__entry->error_info = err->error_info;
> +		else
> +			__entry->error_info = 0ULL;
> +
> +		if (err->validation_bits & CPER_ARM_INFO_VALID_VIRT_ADDR)
> +			__entry->virt_fault_addr = err->virt_fault_addr;
> +		else
> +			__entry->virt_fault_addr = 0ULL;
> +
> +		if (err->validation_bits & CPER_ARM_INFO_VALID_PHYSICAL_ADDR)
> +			__entry->physical_fault_addr = err->physical_fault_addr;
> +		else
> +			__entry->physical_fault_addr = 0ULL;
> +	),
> +
> +	TP_printk("ARM Processor Error: type %s; count: %u; flags: %s;"
I think the "ARM Processor Error:" part of this should just be removed. 
Here's the output with this removed and the trace event renamed to 
arm_err_info_event. I think this looks much cleaner and matches the 
style used with the arm_event.

           <idle>-0     [020] .ns.   366.592434: arm_event: affinity 
level: 2; MPIDR: 0000000000000000; MIDR: 00000000510f8000; running 
state: 1; PSCI state: 0
           <idle>-0     [020] .ns.   366.592437: arm_err_info_event: 
type cache error; count: 0; flags: 0x3; error info: 0000000000c20058; 
virtual address: 0000000000000000; physical address: 0000000000000000

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.

