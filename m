From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v1 0/3] manually add Error Synchronization Barrier at
 exception handler entry and exit
Date: Wed, 1 Nov 2017 20:44:02 +0800
Message-ID: <1d4b77c4-5505-ff4c-1aa2-b15f58e2b354@huawei.com>
References: <1509563697-6359-1-git-send-email-gengdongjiu@huawei.com>
 <59F9B0E9.5090609@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <59F9B0E9.5090609@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: catalin.marinas@arm.com, will.deacon@arm.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, mark.rutland@arm.com, ard.biesheuvel@linaro.org, robin.murphy@arm.com, cov@codeaurora.org, Dave.Martin@arm.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, lishuo1@hisilicon.com, liujun88@hisilicon.com
List-Id: kvmarm@lists.cs.columbia.edu


On 2017/11/1 19:32, James Morse wrote:
>> RAS&IESB for firmware first support". In Huawei's platform, we do not
>> support IESB, so software needs to insert that.
> Surely you don't implement it because your CPU doesn't need it. Can
> unrecoverable errors really cross an exception without becoming an SError?

CC lishuo and liujun.

Hi James,

we will needs that if we can ensure that the Error is not propagated.
The unrecoverable errors can cross an different exception, so hardware use IESB to isolate it.
Afterwards we may also not support IESB(about the definition as shown in [3] ), the reason that
we are not support IESB is that hardware colleague think software insert it in exception entry/exit can be flexibly.
And ARM spec allow that:
ARM spec allow software inset ESB instead of hardware insert as shown in [1].
About how to use the ESB in the software, the SPEC even give an example[2]:

[1]
AArch_v8A_v8.2_Extension_ARM-ECM-0326763-20-0:
"ARMv8.2 adds an extension to RAS to allow system software to insert implicit Error Synchronization Barrier operations at exception handler entry and exit".

[2]
RAS_Extension_PRD03-PRDC-010953-39-0:

Example exception entry sequence
Example 1 shows a typical sequence for exception entry.

Vector: ESB 					;; Error Synchronization Barrier
	SUB SP,SP,#34*8
	STP X0,X1,[SP] 				;; Save all general purpose registers
	STP X2,X3,[SP,#2*8]
	...
	STP X28,X29,[SP,#28*8]
	MRS X21,SP_EL0
	MRS X22,ELR_EL1 			;; Save exception syndrome registers
	MRS X23,SPSR_EL1
	STP X30,X21,[SP,#30*8]
	STP X22,X23,[SP,#32*8]
	...
	MRS X21,DISR_EL1 			;; Check for deferred error
	TBNZ X21,#DISR_A_bit,Error_Handler
	MSR DAIFClr,#0xF 			;; Clear flags
Example 1: Exception entry sequence


[3]
Below is the SCTLR_ELx.IESB definition.
SCTLR_ELx[21]: IESB – Implicit Error Synchronization Barrier enable.
0: Disabled.
1: An implicit ErrorSynchronizationBarrier() call is added:
   After each exception taken to ELx.
   Before the operational pseudocode of each ERET instruction executed at ELx.


Hi lishuo/liujun,
   could you explain more to James about the reason that why we need software inserts ESB instead of hardware support IESB?

> 
> The ESB instruction does the barrier, but it also consumes any pending SError.
> As it is this series will silently consume-and-discard uncontainable errors.

In the firmware-first solution, if ESB consumed a SError, it will trap to firmware.
firmware will handle it and record the Error. the DISR_EL1 will not record, so no need to Check for deferred error

But if it is non-firmware solution, it will not trap, it needs to check the defered error through DISR_EL1 and
call the Error_Handler, as shown in [2].
In the kernel patchset, I do not are check the defered error. If you think it should be added, I can add it.

welcome comments.
