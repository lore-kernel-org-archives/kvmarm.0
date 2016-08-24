From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH] arm64: KVM: Enable support for Cortex-A72
Date: Wed, 24 Aug 2016 11:19:06 +0100
Message-ID: <c02d842a-2576-92f5-8b25-8802cd9876d4@arm.com>
References: <1472023297-2756-1-git-send-email-zhaoshenglong@huawei.com>
 <ffda6889-5c31-1b56-942c-de65bbb1c16f@arm.com> <57BD679A.6060406@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD53B412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2016 06:11:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rzUbwF7i7mdA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Aug 2016 06:11:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3F6240F90
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2016 06:11:21 -0400 (EDT)
In-Reply-To: <57BD679A.6060406@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: shannon.zhao@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 24/08/16 10:23, Shannon Zhao wrote:
>
>
> On 2016/8/24 16:57, Suzuki K Poulose wrote:
>> On 24/08/16 08:21, Shannon Zhao wrote:
>>> In order to allow KVM to run on Cortex-A72 physical cpus, enable KVM
>>> support for Cortex-A72.
>>
>> Do we really need this change ? Given that A72 is using the generic_v8
>> table,
>> it will automatically be supported via the GENERIC_V8 target. That was
>> added
>> just for this purpose. The pre-existing targets were preserved so that
>> we don't break the ABI for older user space.
>>
> Yes, this works for qemu with "-cpu host". But if it specifies the cpu
> type with "-cpu cortex-a72". It will fail without this patch.

Thats because you specify the expected target from the kernel in Qemu.

I don't know what are the plans for Qemu. Are we going to add every single
ARM CPU released to the target list both in Kernel and Qemu ? e.g, what about
A35, A73 and others from the partners ?

Suzuki

>
> The corresponding qemu patches could be found at [1].
> [1] https://lists.gnu.org/archive/html/qemu-devel/2016-08/msg03653.html
>
> Thanks,
>
