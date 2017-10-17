From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v6 5/7] arm64: kvm: route synchronous external abort
 exceptions to el2
Date: Tue, 17 Oct 2017 15:22:56 +0000
Message-ID: <0184EA26B2509940AA629AE1405DD7F2016A338D@DGGEMA503-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F4EF40D25
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 11:24:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CDf+ry33TOsH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 11:24:17 -0400 (EDT)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9649340638
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 11:24:14 -0400 (EDT)
Content-Language: zh-CN
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: "Wangkefeng (Kevin)" <wangkefeng.wang@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "david.daney@cavium.com" <david.daney@cavium.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "tbaicar@codeaurora.org" <tbaicar@codeaurora.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Linuxarm <linuxarm@huawei.com>, "robert.moore@intel.com" <robert.moore@intel.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "zjzhang@codeaurora.org" <zjzhang@codeaurora.org>, "mingo@kernel.org" <mingo@kernel.org>, "stefan@hello-penguin.com" <stefan@hello-penguin.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Huangshaoyu <huangshaoyu@huawei.com>, huangdaode <huangdaode@hisilicon.com>, "bp@suse.de" <bp@suse.de>, "Dave.Martin@arm.com" <Dave.Martin@ar>
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

> Hi gengdongjiu,
> 
> On 14/09/17 12:12, gengdongjiu wrote:
> > On 2017/9/8 0:31, James Morse wrote:
> >> KVM already handles external aborts from lower exception levels, no
> >> more work needs doing for TEA.
> > If it is firmware first solution, that is SCR_EL3.EA=1, all SError
> > interrupt and synchronous External Abort exceptions are taken to EL3, so EL3 firmware will handle it, KVM no needs to handle it.
> >
> > HCR_EL3.TEA is only for EL3 to check its value to decide to jump to hypervisor or kernel.
> >
> >>
> >> What happens when a guest access the RAS-Error-Record registers?
> >>
> >> Before we can set HCR_EL2.TERR I think we need to add some minimal
> >> emulation for the registers it traps. Most of them should be RAZ/WI,
> >> so it should be straightforward. (I think KVMs default is to emulate an undef for unknown traps).
> 
> > Today I added the support to do some minimal emulation for
> > RAS-Error-Record registers, thanks for the good suggestion.
> 
> Where can I find this patch?
> I'd like to repost it as part of the SError_rework/RAS/IESB series: this is one of the bits KVM needs but I didn't touch as it looks like your
> updated version of this patch should cover it.

I have updated my series patches to a new version, and have sent it out, you can find it. Thank you very much.

> 
> 
> Thanks,
> 
> James
