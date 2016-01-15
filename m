From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v9 00/21] KVM: ARM64: Add guest PMU support
Date: Fri, 15 Jan 2016 22:04:03 +0800
Message-ID: <5698FC53.2090907@linaro.org>
References: <1452839275-19368-1-git-send-email-zhaoshenglong@huawei.com>
 <20160115134523.GH3915@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFEBE49A1C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 08:59:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZjYzZr1GXUKs for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2016 08:59:47 -0500 (EST)
Received: from mail-pf0-f179.google.com (mail-pf0-f179.google.com
 [209.85.192.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEDDA49A14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 08:59:47 -0500 (EST)
Received: by mail-pf0-f179.google.com with SMTP id 65so118215885pff.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 06:04:01 -0800 (PST)
In-Reply-To: <20160115134523.GH3915@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/1/15 21:45, Andrew Jones wrote:
> On Fri, Jan 15, 2016 at 02:27:34PM +0800, Shannon Zhao wrote:
>> From: Shannon Zhao <shannon.zhao@linaro.org>
> ...
>> This patchset can be fetched from [1] and the relevant QEMU version for
>> test can be fetched from [2].
>>
> ...
>> [1] https://git.linaro.org/people/shannon.zhao/linux-mainline.git  KVM_ARM64_PMU_v9
>> [2] https://git.linaro.org/people/shannon.zhao/qemu.git  PMU
>
> I don't see corresponding qemu vcpu ioctl code for patch 21/21 in this
> branch. Forget to push it?
>
Sorry, I forget to commit the changes. Will update the branch tomorrow 
since the codes are on my working computer.

Thanks,
-- 
Shannon
