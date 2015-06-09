From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: should KVM or userspace be the one which decides what
 MIPIDR/affinity values to assign to vcpus?
Date: Tue, 9 Jun 2015 15:01:08 +0100
Message-ID: <CAFEAcA-GAsd7vWsmmZm6ikw+rRK2p7S3uNWBwYzTUGum12pyNA@mail.gmail.com>
References: <CAFEAcA-AY7rqcWmd13mpBuBWugbqwjzMdWfWt2N2rV0=7LT3KA@mail.gmail.com>
 <5576C559.2000902@arm.com>
 <CAFEAcA8x6BbHZPLj_U9HuZJs8i3n777vL=Gxs5V8pdmO+bsEcA@mail.gmail.com>
 <5576DBB5.3010100@arm.com>
 <CAFEAcA_y9DNLJTe+4kMBYObuKD82y0a05gsx6gOYZ8=Oo5LBGA@mail.gmail.com>
 <5576F177.3090903@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EB3954008
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2015 09:51:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yl22j2b9eWix for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jun 2015 09:51:12 -0400 (EDT)
Received: from mail-vn0-f42.google.com (mail-vn0-f42.google.com
 [209.85.216.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2FCEB54006
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2015 09:51:11 -0400 (EDT)
Received: by vnbf7 with SMTP id f7so2901005vnb.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Jun 2015 07:01:29 -0700 (PDT)
In-Reply-To: <5576F177.3090903@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Shlomo Pongratz <shlomo.pongratz@huawei.com>, Shlomo Pongratz <shlomopongratz@gmail.com>, Pavel Fedin <p.fedin@samsung.com>, QEMU Developers <qemu-devel@nongnu.org>, Shannon Zhao <shannon.zhao@linaro.org>, Ashok Kumar <ashoks@broadcom.com>, Igor Mammedov <imammedo@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 9 June 2015 at 15:00, Marc Zyngier <marc.zyngier@arm.com> wrote:
>
> Yeah, what I had in mind was something along the lines of:
> - kernel computes its "default MPDIR"
> - kernel exposes a new capability "KVM_ARM_ALLOW_MPIDR_OVERRIDE" (or
> something along those lines)
> - userspace does the right thing.

You forgot the "???" step :-)

-- PMM
