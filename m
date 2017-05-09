From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: Re: [PATCH v3 7/8] arm64: exception: handle asynchronous SError
 interrupt
Date: Tue, 9 May 2017 10:16:32 +0800
Message-ID: <4cfa4f66-e9a2-fd52-fb64-b2510bcdf1d8@huawei.com>
References: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
 <1490869877-118713-8-git-send-email-xiexiuqi@huawei.com>
 <20170413105131.GD24027@leverpostej>
 <d7a8884d-f6b7-69d0-2438-83c202926000@huawei.com> <58F5EFC6.5070601@arm.com>
 <e6502f82-108e-3f53-4791-515671e4d515@huawei.com> <58F876EB.2020805@arm.com>
 <2bb41d98-553f-1361-e497-4095ddd501d0@huawei.com> <58FE328E.7030106@arm.com>
 <d20bb634-d70b-5ab9-20e2-46275675ce1f@huawei.com> <5910AA92.2010106@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <5910AA92.2010106@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, wuquanming@huawei.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Xie XiuQi <xiexiuqi@huawei.com>, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, rostedt@goodmis.org, gengdongjiu@huawei.com, linux-acpi@vger.kernel.org, fu.wei@linaro.org, shiju.jose@huawei.com, zhengqiang10@huawei.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, hanjun.guo@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On 2017/5/9 1:27, James Morse wrote:
> Hi Xiongfeng Wang,
> 
> On 28/04/17 03:55, Xiongfeng Wang wrote:
>>>>>> It is ok to just ignore the process following the ESB instruction in el0_sync, because the process will be sent SIGBUS signal.
>>>>
>>>> I don't understand. How will Linux know the process caused an error if we
>>>> neither take an SError nor read DISR_EL1 after an ESB?
> 
>> I think there may be some misunderstanding here. The ESB instruction is placed in kernel_entry
>> of el0_sync and el0_irq. For the el0_sync, such as an syscall from userspace, after ESB is executed,
>> we check whether DISR.A is set. If it is not set, we go on to process the syscall. If it is set, we
>> jump to sError vector and then just eret.
> 
> Ah, this looks like an early optimisation!
> 
> We can't assume that the SError will result in the processing being killed, the
> AET bits of the SError ISS Encoding (page D7-2284 of ARM-ARM DDI0487B.a), has a
> 'corrected' error encoding.
> For these I would expect the SError-vector C code to do nothing and return to
> where it came from. In this case the syscall should still be run.
> 
Yes, it makes sense, so we should add a return value for the do_sei handler.

Thanks,
Wang Xiongfeng
