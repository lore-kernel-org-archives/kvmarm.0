From: Heyi Guo <guoheyi@huawei.com>
Subject: Re: [RFC] arm/cpu: fix soft lockup panic after
 resuming from stop
Date: Wed, 13 Mar 2019 09:57:06 +0800
Message-ID: <f528c40f-7b31-3bd2-ca93-1c579961581d@huawei.com>
References: <1552370960-2061-1-git-send-email-guoheyi@huawei.com>
	<CAFEAcA-29Q-sTg2wLre0GJJCr2gfu89rg0vuTOf7cW5drE4d7Q@mail.gmail.com>
	<136f773f-9b08-a39b-3ecb-2c00ff290b49@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
In-Reply-To: <136f773f-9b08-a39b-3ecb-2c00ff290b49@arm.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel/>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org
Sender: "Qemu-devel"
	<qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
To: Marc Zyngier <marc.zyngier@arm.com>, Peter Maydell <peter.maydell@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, Christoffer Dall <christoffer.dall@arm.com>, Steven Price <Steven.Price@arm.com>, qemu-arm <qemu-arm@nongnu.org>, wanghaibin.wang@huawei.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Dear all,

Really appreciate your comments and information. For "Live Physical Time", is there any document to tell the whole story? And may I know the timeline to make it happen?

Thanks,

Heyi


On 2019/3/12 22:12, Marc Zyngier wrote:
> Hi Peter,
>
> On 12/03/2019 10:08, Peter Maydell wrote:
>> On Tue, 12 Mar 2019 at 06:10, Heyi Guo <guoheyi@huawei.com> wrote:
>>> When we stop a VM for more than 30 seconds and then resume it, by qemu
>>> monitor command "stop" and "cont", Linux on VM will complain of "soft
>>> lockup - CPU#x stuck for xxs!" as below:
>>>
>>> [ 2783.809517] watchdog: BUG: soft lockup - CPU#3 stuck for 2395s!
>>> [ 2783.809559] watchdog: BUG: soft lockup - CPU#2 stuck for 2395s!
>>> [ 2783.809561] watchdog: BUG: soft lockup - CPU#1 stuck for 2395s!
>>> [ 2783.809563] Modules linked in...
>>>
>>> This is because Guest Linux uses generic timer virtual counter as
>>> a software watchdog, and CNTVCT_EL0 does not stop when VM is stopped
>>> by qemu.
>>>
>>> This patch is to fix this issue by saving the value of CNTVCT_EL0 when
>>> stopping and restoring it when resuming.
>> Hi -- I know we have issues with the passage of time in Arm VMs
>> running under KVM when the VM is suspended, but the topic is
>> a tricky one, and it's not clear to me that this is the correct
>> way to fix it. I would prefer to see us start with a discussion
>> on the kvm-arm mailing list about the best approach to the problem.
>>
>> I've cc'd that list and a couple of the Arm KVM maintainers
>> for their opinion.
>>
>> QEMU patch left below for context -- the brief summary is that
>> it uses KVM_GET_ONE_REG/KVM_SET_ONE_REG on the timer CNT register
>> to save it on VM pause and write that value back on VM resume.
> That's probably good enough for this particular use case, but I think
> there is more. I can get into similar trouble if I suspend my laptop, or
> suspend QEMU. It also has the slightly bizarre effect of skewing time,
> and this will affect timekeeping in the guest in ways that are much more
> subtle than just shouty CPUs.
>
> Christoffer and Steve had some stuff regarding Live Physical Time, which
> should cover that, and other cases such as host system suspend, and QEMU
> being suspended.
>
> Thanks,
>
> 	M.
