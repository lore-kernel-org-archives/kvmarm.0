From: James Morse <james.morse@arm.com>
Subject: Re: =?UTF-8?B?562U5aSNOiBbUEFUQ0ggdjYgNC83XSBhcm02NDoga3ZtOiBzdXA=?=
 =?UTF-8?B?cG9ydCB1c2VyIHNwYWNlIHRvIHF1ZXJ5IFJBUyBleHRlbnNpb24gZmVhdHVyZQ==?=
Date: Thu, 14 Sep 2017 13:34:31 +0100
Message-ID: <59BA7757.3020804@arm.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
 <1503916701-13516-5-git-send-email-gengdongjiu@huawei.com>
 <59A84F9D.8030309@arm.com> <29951852-8d91-7c33-c68b-ad8b4bbdea54@huawei.com>
 <59B1747A.5030909@arm.com>
 <0184EA26B2509940AA629AE1405DD7F2015F5A1C@DGGEMA503-MBX.china.huawei.com>
 <CAFEAcA8tXV31RTa+RCkkNFyR2t1dTwR5kYXUmBXMj9wkeLWCpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BC9549C19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Sep 2017 08:33:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cxPKErK-rDCm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Sep 2017 08:33:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EABC40FAE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Sep 2017 08:33:24 -0400 (EDT)
In-Reply-To: <CAFEAcA8tXV31RTa+RCkkNFyR2t1dTwR5kYXUmBXMj9wkeLWCpg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>, gengdongjiu <gengdongjiu@huawei.com>
Cc: "Wangkefeng (Kevin)" <wangkefeng.wang@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "david.daney@cavium.com" <david.daney@cavium.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "tbaicar@codeaurora.org" <tbaicar@codeaurora.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Linuxarm <linuxarm@huawei.com>, "robert.moore@intel.com" <robert.moore@intel.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "zjzhang@codeaurora.org" <zjzhang@codeaurora.org>, "mingo@kernel.org" <mingo@kernel.org>, "stefan@hello-penguin.com" <stefan@hello-penguin.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Huangshaoyu <huangshaoyu@huawei.com>, huangdaode <huangdaode@hisilicon.com>, "bp@suse.de" <bp@suse.de>, "Dave.Martin@arm.com" <Dave.Martin@ar>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Peter,

On 08/09/17 16:03, Peter Maydell wrote:
> On 8 September 2017 at 15:34, gengdongjiu <gengdongjiu@huawei.com> wrote:
>> Hi Peter/ shenglong,
>>    What is your idea about it? We may need to consult with you about it.
> 
> I agree with what I take to be James' general point that we
> should be careful to distinguish "KVM supports API A to
> do a particular operation on the guest" and "KVM supports API
> B to tell QEMU about certain events" and so on, and not just
> lump these all together under "host CPU supports RAS and
> so we turn all these on together and expose RAS to the guest
> regardless". I don't know enough about the details of RAS
> to be more specific than that general point of view.

I think the question is 'when should qemu/kvmtool generate a HEST'.

The answer certainly doesn't depend on the CPU RAS extensions, with firmware
first these are just one mechanism to kicking RAS-errors up into firmware.
Firmware may have other ways of doing this, and other non-CPU components that
can generate errors.

User-space can generate a HEST for the guest whenever it thinks it might have to
describe an error to a guest, either totally emulated, or because it can handle
memory-failure notification.


The real question is 'which APEI GHES notification methods you can support for
this guest'. So far x86's NMI, and arm64's SEI or SDEI mechanisms require help
from KVM. But without any of these the Polled and (numerous) IRQ notifications
will still work.


Thanks,

James
