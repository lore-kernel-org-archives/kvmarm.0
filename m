From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v6 0/7] Add RAS virtualization support for SEA/SEI
 notification type in KVM
Date: Wed, 6 Sep 2017 12:19:21 +0100
Message-ID: <CAFEAcA9=Ct6ucd8kPWyi3vSzahEQpOqLEakD36vxWmw=JcppFQ@mail.gmail.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, linux@armlinux.org.uk, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, xiexiuqi@huawei.com, Christopher Covington <cov@codeaurora.org>, David Daney <david.daney@cavium.com>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>, stefan@hello-penguin.com, Dave P Martin <Dave.Martin@arm.com>, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, Tyler Baicar <tbaicar@codeaurora.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ingo Molnar <mingo@kernel.org>, bp@suse.de
List-Id: kvmarm@lists.cs.columbia.edu

On 28 August 2017 at 11:38, Dongjiu Geng <gengdongjiu@huawei.com> wrote:
> In the firmware-first RAS solution, corrupt data is detected in a
> memory location when guest OS application software executing at EL0
> or guest OS kernel El1 software are reading from the memory. The
> memory node records errors in an error record accessible using
> system registers.

Hi Dongjiu -- it looks like this patch set is extending
the API KVM provides to userspace, but it doesn't update
the documentation in Documentation/virtual/kvm/api.txt.
I appreciate the API is still somewhat under discussion,
but if you can include the docs updates it's helpful to
me for reviewing whether the API makes sense from the
userspace consumer end of it.

thanks
-- PMM
