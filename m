From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v2 00/22] KVM: ARM64: Add guest PMU support
Date: Thu, 17 Sep 2015 09:32:34 +0800
Message-ID: <55FA1832.3040008@linaro.org>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
 <55F9D9FC.6010905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55F9D9FC.6010905@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Wei Huang <wei@redhat.com>, Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, peter.huangpeng@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Wei,

On 2015/9/17 5:07, Wei Huang wrote:
> I am testing this series. 
Thanks for your time and help.

> The first question is: do you plan to add ACPI
> support in QEMU?
To the completeness, this should be added. Maybe this could be added at
v3. But I have a look at the kernel PMU driver, it doesn't support
probing through ACPI, although there are some patches[1] out-of-tree.

> My in-house kernel uses ACPI for device probing. I had
> to force "acpi=off" when I test this patch series.
Guest kernel only boots with ACPI when you add "acpi=force". No need to
add "acpi=off".

Thanks,

[1] http://marc.info/?l=linaro-acpi&m=137949337925645&w=2
-- 
Shannon
