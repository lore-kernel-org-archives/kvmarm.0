From: gengdongjiu <gengdj.1984@gmail.com>
Subject: Re: [PATCH v6 5/7] arm64: kvm: route synchronous external abort
 exceptions to el2
Date: Mon, 16 Oct 2017 21:44:59 +0800
Message-ID: <CAMj-D2Bn8HUL=HJO-tysisVT4HSTZW0z-xY-1w1EsgPvShFooQ@mail.gmail.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
 <1503916701-13516-6-git-send-email-gengdongjiu@huawei.com>
 <59B17449.6010201@arm.com> <fb7da3e3-d0f7-7ac6-b088-888a563d7ee7@huawei.com>
 <59E49BB8.8080801@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BAD3240D25
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 09:44:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rESw2kM4PFW6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Oct 2017 09:44:04 -0400 (EDT)
Received: from mail-vk0-f41.google.com (mail-vk0-f41.google.com
 [209.85.213.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1A20406D0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 09:44:04 -0400 (EDT)
Received: by mail-vk0-f41.google.com with SMTP id t203so7678755vke.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 06:45:00 -0700 (PDT)
In-Reply-To: <59E49BB8.8080801@arm.com>
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
Cc: wangkefeng.wang@huawei.com, kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, tbaicar@codeaurora.org, will.deacon@arm.com, linuxarm@huawei.com, linux@armlinux.org.uk, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, stefan@hello-penguin.com, zjzhang@codeaurora.org, robert.moore@intel.com, gengdongjiu <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, huangshaoyu@huawei.com, huangdaode@hisilicon.com, bp@suse.de, Dave.Martin@arm.com, lenb@kernel.org, mingo@kernel.org, wuquanming@huawei.com, marc.zyngier@arm.com, john.garry@huawei.com, kristina.martsenko@arm.com, cov@codeaurora.org, jonathan.cameron@huawei.com, zhengqiang10@huawei.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, wangzhou1@hisilicon.com, mst@redhat.com, shiju.jose@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

>
>> Today I added the support to do some minimal emulation for
>> RAS-Error-Record registers, thanks
>> for the good suggestion.
>
> Where can I find this patch?
> I'd like to repost it as part of the SError_rework/RAS/IESB series: this is
> one
> of the bits KVM needs but I didn't touch as it looks like your updated
> version
> of this patch should cover it.

I have updated this patch according your suggestion that do some
emulation for the ERR* trap. and have verified it. but still not sent
it out. Tomorrow I will send it out for your review(now it is Chinese
midnight), if you think it is ok, you can add it as part of the
SError_rework/RAS/IESB series. thanks for your reminder and good
review comments.


>
>
> Thanks,
>
> James
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>
