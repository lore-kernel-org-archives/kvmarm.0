From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v11 4/6] target-arm: kvm64: detect guest RAS EXTENSION
 feature
Date: Fri, 8 Sep 2017 15:55:53 +0100
Message-ID: <CAFEAcA-tCv9HAG4JzgHbW9VC77tYYFD=rp=b1BoKN7UayWc0yA@mail.gmail.com>
References: <0184EA26B2509940AA629AE1405DD7F2015F5973@DGGEMA503-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E231749C6C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Sep 2017 10:53:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tEk8hM0w8Vgn for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Sep 2017 10:53:45 -0400 (EDT)
Received: from mail-wr0-f174.google.com (mail-wr0-f174.google.com
 [209.85.128.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F1C4249C6A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Sep 2017 10:53:44 -0400 (EDT)
Received: by mail-wr0-f174.google.com with SMTP id 108so5135196wra.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Sep 2017 07:56:14 -0700 (PDT)
In-Reply-To: <0184EA26B2509940AA629AE1405DD7F2015F5973@DGGEMA503-MBX.china.huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "zjzhang@codeaurora.org" <zjzhang@codeaurora.org>, Ingo Molnar <mingo@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Huangshaoyu <huangshaoyu@huawei.com>, huangdaode <huangdaode@hisilicon.com>, "bp@suse.de" <bp@suse.de>, Wuquanming <wuquanming@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, "edk2-devel@lists.01.org" <edk2-devel@lists.01.org>, John Garry <john.garry@huawei.com>, Linuxarm <linuxarm@huawei.com>, qemu-arm <qemu-arm@nongnu.org>, Igor Mammedov <imammedo@redhat.com>, "Zhengqiang (turing)" <zhengqiang10@huawei.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, devel@acpica.org
List-Id: kvmarm@lists.cs.columbia.edu

On 8 September 2017 at 15:26, gengdongjiu <gengdongjiu@huawei.com> wrote:


>> Shouldn't we need to also tell the kernel that we actually want
>> it to expose RAS to the guest? Compare the PMU code in this function,
>> where we set a kvm_init_features bit to do this.

> In the PMU code, it indeed sets a kvm_init_features bit. Here ARM
> James has a concern that we are depend on the host CPU RAS extension,
> He means that if userspace receives the SIGBUS delivered by host
> memory_failure(), user space should record the CPER for guest
> and handling the error regardless whether host CPU supports RAS
> extension. But I think if user space receives the SIGBUS signal,
> that means
> host CPU RAS module detects the error or CPU consumes the poison
> data, thus we should check whether physical CPU support RAS extension.

I don't understand what you have in mind here. If the host does
not support the CPU RAS extension then we should never get a
SIGBUS in the first place.

In any case this doesn't seem relevant to the question of whether it
should be optional to expose the RAS extension to the *guest*.
Even if the host does support RAS, you should be able to run a
VM that knows nothing about RAS.

thanks
-- PMM
