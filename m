From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC] arm/cpu: fix soft lockup panic after resuming from stop
Date: Tue, 12 Mar 2019 14:12:28 +0000
Message-ID: <136f773f-9b08-a39b-3ecb-2c00ff290b49@arm.com>
References: <1552370960-2061-1-git-send-email-guoheyi@huawei.com>
 <CAFEAcA-29Q-sTg2wLre0GJJCr2gfu89rg0vuTOf7cW5drE4d7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD6834A2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Mar 2019 10:12:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s2IiwROzYoKw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Mar 2019 10:12:32 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BE834A2BE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Mar 2019 10:12:31 -0400 (EDT)
In-Reply-To: <CAFEAcA-29Q-sTg2wLre0GJJCr2gfu89rg0vuTOf7cW5drE4d7Q@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>, Heyi Guo <guoheyi@huawei.com>
Cc: QEMU Developers <qemu-devel@nongnu.org>, Steven Price <Steven.Price@arm.com>, qemu-arm <qemu-arm@nongnu.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Peter,

On 12/03/2019 10:08, Peter Maydell wrote:
> On Tue, 12 Mar 2019 at 06:10, Heyi Guo <guoheyi@huawei.com> wrote:
>>
>> When we stop a VM for more than 30 seconds and then resume it, by qemu
>> monitor command "stop" and "cont", Linux on VM will complain of "soft
>> lockup - CPU#x stuck for xxs!" as below:
>>
>> [ 2783.809517] watchdog: BUG: soft lockup - CPU#3 stuck for 2395s!
>> [ 2783.809559] watchdog: BUG: soft lockup - CPU#2 stuck for 2395s!
>> [ 2783.809561] watchdog: BUG: soft lockup - CPU#1 stuck for 2395s!
>> [ 2783.809563] Modules linked in...
>>
>> This is because Guest Linux uses generic timer virtual counter as
>> a software watchdog, and CNTVCT_EL0 does not stop when VM is stopped
>> by qemu.
>>
>> This patch is to fix this issue by saving the value of CNTVCT_EL0 when
>> stopping and restoring it when resuming.
> 
> Hi -- I know we have issues with the passage of time in Arm VMs
> running under KVM when the VM is suspended, but the topic is
> a tricky one, and it's not clear to me that this is the correct
> way to fix it. I would prefer to see us start with a discussion
> on the kvm-arm mailing list about the best approach to the problem.
> 
> I've cc'd that list and a couple of the Arm KVM maintainers
> for their opinion.
> 
> QEMU patch left below for context -- the brief summary is that
> it uses KVM_GET_ONE_REG/KVM_SET_ONE_REG on the timer CNT register
> to save it on VM pause and write that value back on VM resume.

That's probably good enough for this particular use case, but I think
there is more. I can get into similar trouble if I suspend my laptop, or
suspend QEMU. It also has the slightly bizarre effect of skewing time,
and this will affect timekeeping in the guest in ways that are much more
subtle than just shouty CPUs.

Christoffer and Steve had some stuff regarding Live Physical Time, which
should cover that, and other cases such as host system suspend, and QEMU
being suspended.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
