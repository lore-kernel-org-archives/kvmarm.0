From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v9 19/21] KVM: ARM64: Add a new feature bit for PMUv3
Date: Tue, 26 Jan 2016 11:40:25 +0800
Message-ID: <56A6EAA9.3010506@huawei.com>
References: <1452839275-19368-1-git-send-email-zhaoshenglong@huawei.com> <1452839275-19368-20-git-send-email-zhaoshenglong@huawei.com> <20160115110816.GE3915@hawk.localdomain> <569DE171.1070602@huawei.com> <CAFEAcA_fyEp3tihjbCyQBzU6vex4273Sp78J4Kg1UXkkyX+1Pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA_fyEp3tihjbCyQBzU6vex4273Sp78J4Kg1UXkkyX+1Pg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Andrew Jones <drjones@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Wei Huang <wei@redhat.com>, Christopher Covington <cov@codeaurora.org>, Shannon Zhao <shannon.zhao@linaro.org>, "Huangpeng (Peter)" <peter.huangpeng@huawei.com>, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/1/26 0:47, Peter Maydell wrote:
> On 19 January 2016 at 07:10, Shannon Zhao <zhaoshenglong@huawei.com> wrote:
>> > Yes, for checking the CAP true/false is enough. Maybe I think the number
>> > of host counters could be useful for QEMU to know the number and for
>> > supporting cross-type vcpu, but I'm not sure. If someone else has no
>> > other suggestion, I will change it to what you suggest.
> Do we care about the number of host counters?
Currently we don't care about it. Anyway it could be added if it's
necessary in the future.

> We might want to
> know how many counters the guest sees, but we can do that by
> using KVM_GET_ONE_REG to look at the guest PMCR_EL0, right?
Yes, right.

-- 
Shannon

