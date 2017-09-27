From: gengdongjiu <gengdj.1984@gmail.com>
Subject: Re: [PATCH v6 6/7] KVM: arm64: allow get exception information from userspace
Date: Wed, 27 Sep 2017 23:37:18 +0800
Message-ID: <CAMj-D2AuCqAgQBRAp2CSf24HsHWteNLigZAUEKK8oKL_SAmBNw@mail.gmail.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
 <1503916701-13516-7-git-send-email-gengdongjiu@huawei.com>
 <59B17438.5070501@arm.com> <2a42d1ea-3456-2873-c9ea-d8a027b59789@huawei.com>
 <59BA7D72.4090403@arm.com> <92f2fecc-9833-15e4-30cc-b4dd5ba93cb7@huawei.com>
 <59C53FA7.2080803@arm.com> <8be64586-3722-cd96-80fd-6e815d2e911d@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <8be64586-3722-cd96-80fd-6e815d2e911d@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: James Morse <james.morse@arm.com>, wangkefeng.wang@huawei.com, kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, Achin Gupta <Achin.Gupta@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, will.deacon@arm.com, linuxarm@huawei.com, robert.moore@intel.com, lv.zheng@intel.com, zjzhang@codeaurora.org, mingo@kernel.org, stefan@hello-penguin.com, linux@armlinux.org.uk, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, Huangshaoyu <huangshaoyu@huawei.com>, huangdaode@hisilicon.com, Borislav Petkov <bp@suse.de>, Dave.Martin@arm.com, Len Brown <lenb@kernel.org>, wuquanming <wuquanming@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, John Garry <john.garry@huawei.com>, kristina.martsenko@arm.com, cov@codeaurora.org, jonathan.cameron@huawei.com, zhengqiang10
List-Id: kvmarm@lists.cs.columbia.edu

>> What you may be seeing is some awkwardness with the change in the SError ESR
>> with v8.2. Previously the VSE mechanism injected an impdef SError, (but they
>> were all impdef so it didn't matter).
>> With VSESR_EL2 KVM has to specify one, and all-zeros is a bad choice as this
>> means 'classified as a RAS error ... unknown!'.
>>
>> I have a patch in the upcoming SError/RAS series that changes KVMs virtual-abort
>> code to specify an impdef ESR for this path.
> Before I remember Marc and you suggest me specify the an impdef ESR (set the vsesr_el2) in
> the userspace,

I pasted Marc's propose and your suggestion that set VSESR_EL2(specify
virtual SError syndrome) by the user space.
https://lkml.org/lkml/2017/3/20/441
https://lkml.org/lkml/2017/3/20/516


> now do you want to specify an impdef ESR in KVM instead of usrspace?
> if setting the vsesr_el2 in the KVM, whether user-space need to specify?
> May be we can combine the patches that specify an impdef ESR(set vsesr_el2) patch to one.
>
