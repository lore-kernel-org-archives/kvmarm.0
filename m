From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v2 00/22] KVM: ARM64: Add guest PMU support
Date: Thu, 17 Sep 2015 17:35:26 +0800
Message-ID: <55FA895E.8080304@huawei.com>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com> <55F9D9FC.6010905@redhat.com> <55FA1832.3040008@linaro.org> <20150917093007.GB5933@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150917093007.GB5933@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, Shannon Zhao <shannon.zhao@linaro.org>
Cc: Wei Huang <wei@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andrew,

On 2015/9/17 17:30, Andrew Jones wrote:
> On Thu, Sep 17, 2015 at 09:32:34AM +0800, Shannon Zhao wrote:
>> > Hi Wei,
>> > 
>> > On 2015/9/17 5:07, Wei Huang wrote:
>>> > > I am testing this series. 
>> > Thanks for your time and help.
>> > 
>>> > > The first question is: do you plan to add ACPI
>>> > > support in QEMU?
>> > To the completeness, this should be added. Maybe this could be added at
>> > v3. But I have a look at the kernel PMU driver, it doesn't support
>> > probing through ACPI, although there are some patches[1] out-of-tree.
>> > 
>>> > > My in-house kernel uses ACPI for device probing. I had
>>> > > to force "acpi=off" when I test this patch series.
>> > Guest kernel only boots with ACPI when you add "acpi=force". No need to
>> > add "acpi=off".
> The Red Hat kernel uses ACPI by default, when tables are present (Thanks
> again for your QEMU table generation patches!)
> 
Oh, I see. Thanks for your explanation.

-- 
Shannon

