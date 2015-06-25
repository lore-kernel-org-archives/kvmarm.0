From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: should KVM or userspace be the one which decides what
 MIPIDR/affinity values to assign to vcpus?
Date: Thu, 25 Jun 2015 13:51:12 +0100
Message-ID: <CAFEAcA9E8evJe78NqbJ=hOXsSMWh003u3_gHOtPMjTafGGB3Xg@mail.gmail.com>
References: <CAFEAcA-AY7rqcWmd13mpBuBWugbqwjzMdWfWt2N2rV0=7LT3KA@mail.gmail.com>
 <5576C559.2000902@arm.com>
 <CAFEAcA8x6BbHZPLj_U9HuZJs8i3n777vL=Gxs5V8pdmO+bsEcA@mail.gmail.com>
 <20150625080014.GC28244@cbox>
 <CAFEAcA_cDT7r-LrX+4vYD5DSK6wTYbDTqoDm2B9gaS3ftJTqJg@mail.gmail.com>
 <20150625124113.GF28244@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DE9756FD2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2015 08:40:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6Y-DPIiK3Htb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2015 08:40:33 -0400 (EDT)
Received: from mail-vn0-f42.google.com (mail-vn0-f42.google.com
 [209.85.216.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A4DB56FCF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2015 08:40:32 -0400 (EDT)
Received: by vnbg129 with SMTP id g129so10836583vnb.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2015 05:51:32 -0700 (PDT)
In-Reply-To: <20150625124113.GF28244@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shlomo Pongratz <shlomo.pongratz@huawei.com>, Shlomo Pongratz <shlomopongratz@gmail.com>, Pavel Fedin <p.fedin@samsung.com>, QEMU Developers <qemu-devel@nongnu.org>, Shannon Zhao <shannon.zhao@linaro.org>, Ashok Kumar <ashoks@broadcom.com>, Igor Mammedov <imammedo@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 25 June 2015 at 13:41, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> On Thu, Jun 25, 2015 at 10:06:20AM +0100, Peter Maydell wrote:
>> I agree it's not very likely anybody cares about the specific cluster
>> topology. However if we don't want to support arbitrary topologies
>> then QEMU is going to end up in the business of editing the user
>> supplied device tree blob to make its cpu definitions match up with
>> whatever the kernel provides, which could be pretty tedious.
>>
> I see, then you can't easily contruct a machine and a DT in one go
> before talking to KVM.

Also the "use upstream's kernel and its associated dtb with a
model that matches real hardware" use case would require either
DTB editing or getting the kernel to handle the topology of
the thing we're modelling.

-- PMM
