From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: should KVM or userspace be the one which decides what
 MIPIDR/affinity values to assign to vcpus?
Date: Thu, 25 Jun 2015 10:06:20 +0100
Message-ID: <CAFEAcA_cDT7r-LrX+4vYD5DSK6wTYbDTqoDm2B9gaS3ftJTqJg@mail.gmail.com>
References: <CAFEAcA-AY7rqcWmd13mpBuBWugbqwjzMdWfWt2N2rV0=7LT3KA@mail.gmail.com>
 <5576C559.2000902@arm.com>
 <CAFEAcA8x6BbHZPLj_U9HuZJs8i3n777vL=Gxs5V8pdmO+bsEcA@mail.gmail.com>
 <20150625080014.GC28244@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 972B156F9B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2015 04:55:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EPZSUL8X+FDX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2015 04:55:41 -0400 (EDT)
Received: from mail-vn0-f42.google.com (mail-vn0-f42.google.com
 [209.85.216.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C795856F96
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2015 04:55:41 -0400 (EDT)
Received: by vnav203 with SMTP id v203so10040178vna.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2015 02:06:40 -0700 (PDT)
In-Reply-To: <20150625080014.GC28244@cbox>
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

On 25 June 2015 at 09:00, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> Of course, KVM can deny an unsupported configuration, but I am wondering
> if we really think anybody will care about the 'model such specific
> hardware' aspect with KVM, or if we should only consider the 'I want a
> VM with x VCPUs' scenario, in which case the second option below seems
> simpler to me.

I agree it's not very likely anybody cares about the specific cluster
topology. However if we don't want to support arbitrary topologies
then QEMU is going to end up in the business of editing the user
supplied device tree blob to make its cpu definitions match up with
whatever the kernel provides, which could be pretty tedious.

-- PMM
