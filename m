From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v9 00/21] KVM: ARM64: Add guest PMU support
Date: Sat, 16 Jan 2016 15:33:54 +0800
Message-ID: <5699F262.8000400@linaro.org>
References: <1452839275-19368-1-git-send-email-zhaoshenglong@huawei.com>
 <20160115134523.GH3915@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160115134523.GH3915@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
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
I've updated the branch. Now it includes the codes. You could fetch it
from https://git.linaro.org/people/shannon.zhao/qemu.git  PMU

Thanks,
-- 
Shannon
