From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH] arm64: KVM: Enable support for Cortex-A72
Date: Wed, 24 Aug 2016 17:23:38 +0800
Message-ID: <57BD679A.6060406@huawei.com>
References: <1472023297-2756-1-git-send-email-zhaoshenglong@huawei.com>
 <ffda6889-5c31-1b56-942c-de65bbb1c16f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D05FF412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2016 05:17:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AKGqU0BzU8Yp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Aug 2016 05:17:19 -0400 (EDT)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [119.145.14.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B0A9D40FA7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2016 05:17:18 -0400 (EDT)
In-Reply-To: <ffda6889-5c31-1b56-942c-de65bbb1c16f@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: shannon.zhao@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/8/24 16:57, Suzuki K Poulose wrote:
> On 24/08/16 08:21, Shannon Zhao wrote:
>> In order to allow KVM to run on Cortex-A72 physical cpus, enable KVM
>> support for Cortex-A72.
> 
> Do we really need this change ? Given that A72 is using the generic_v8
> table,
> it will automatically be supported via the GENERIC_V8 target. That was
> added
> just for this purpose. The pre-existing targets were preserved so that
> we don't break the ABI for older user space.
> 
Yes, this works for qemu with "-cpu host". But if it specifies the cpu
type with "-cpu cortex-a72". It will fail without this patch.

The corresponding qemu patches could be found at [1].
[1] https://lists.gnu.org/archive/html/qemu-devel/2016-08/msg03653.html

Thanks,
-- 
Shannon
