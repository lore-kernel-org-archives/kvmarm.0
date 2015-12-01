From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v4 00/21] KVM: ARM64: Add guest PMU support
Date: Tue, 1 Dec 2015 09:52:15 +0800
Message-ID: <565CFD4F.7090906@huawei.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com> <20151130183419.471ec20f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20151130183419.471ec20f@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 2015/12/1 2:34, Marc Zyngier wrote:
> On Fri, 30 Oct 2015 14:21:42 +0800
> Shannon Zhao <zhaoshenglong@huawei.com> wrote:
> 
> Hi Shannon,
> 
>> > From: Shannon Zhao <shannon.zhao@linaro.org>
>> > 
>> > This patchset adds guest PMU support for KVM on ARM64. It takes
>> > trap-and-emulate approach. When guest wants to monitor one event, it
>> > will be trapped by KVM and KVM will call perf_event API to create a perf
>> > event and call relevant perf_event APIs to get the count value of event.
> I've been through this whole series, and while this is shaping nicely,
> there is still a number of things that are a bit odd (interrupt
> injection is one, the whole CP15 reset is another).
> 
> Can you please respin this soon? I'd really like to have this in for
> 4.5...

Thanks! I will respin it soon.

-- 
Shannon

