From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 7/8] arm64: exception: handle asynchronous SError interrupt
Date: Mon, 08 May 2017 18:27:46 +0100
Message-ID: <5910AA92.2010106@arm.com>
References: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com> <1490869877-118713-8-git-send-email-xiexiuqi@huawei.com> <20170413105131.GD24027@leverpostej> <d7a8884d-f6b7-69d0-2438-83c202926000@huawei.com> <58F5EFC6.5070601@arm.com> <e6502f82-108e-3f53-4791-515671e4d515@huawei.com> <58F876EB.2020805@arm.com> <2bb41d98-553f-1361-e497-4095ddd501d0@huawei.com> <58FE328E.7030106@arm.com> <d20bb634-d70b-5ab9-20e2-46275675ce1f@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d20bb634-d70b-5ab9-20e2-46275675ce1f@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Xie XiuQi <xiexiuqi@huawei.com>, christoffer.dall@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, fu.wei@linaro.org, rostedt@goodmis.org, hanjun.guo@linaro.org, shiju.jose@huawei.com, wuquanming@huawei.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, gengdongjiu@huawei.com, linux-acpi@vger.kernel.org, zhengqiang10@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Xiongfeng Wang,

On 28/04/17 03:55, Xiongfeng Wang wrote:
>>> >> It is ok to just ignore the process following the ESB instruction in el0_sync, because the process will be sent SIGBUS signal.
>> > 
>> > I don't understand. How will Linux know the process caused an error if we
>> > neither take an SError nor read DISR_EL1 after an ESB?

> I think there may be some misunderstanding here. The ESB instruction is placed in kernel_entry
> of el0_sync and el0_irq. For the el0_sync, such as an syscall from userspace, after ESB is executed,
> we check whether DISR.A is set. If it is not set, we go on to process the syscall. If it is set, we
> jump to sError vector and then just eret.

Ah, this looks like an early optimisation!

We can't assume that the SError will result in the processing being killed, the
AET bits of the SError ISS Encoding (page D7-2284 of ARM-ARM DDI0487B.a), has a
'corrected' error encoding.
For these I would expect the SError-vector C code to do nothing and return to
where it came from. In this case the syscall should still be run.


Thanks,

James
