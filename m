From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v4 0/4] Add support for for GICv2m and MSIs to arm-virt
Date: Mon, 1 Jun 2015 18:15:58 +0100
Message-ID: <CAFEAcA-JOr508G5AASNn-O8BO9AwOOPPATJNsoPqgcGTQg+Qdw@mail.gmail.com>
References: <1432897270-7780-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D30C52BC9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jun 2015 13:06:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H5NPeHJxyR6K for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Jun 2015 13:06:22 -0400 (EDT)
Received: from mail-ig0-f174.google.com (mail-ig0-f174.google.com
 [209.85.213.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB61052BC8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Jun 2015 13:06:22 -0400 (EDT)
Received: by igbhj9 with SMTP id hj9so66754605igb.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 01 Jun 2015 10:16:18 -0700 (PDT)
In-Reply-To: <1432897270-7780-1-git-send-email-christoffer.dall@linaro.org>
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
Cc: QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 29 May 2015 at 12:01, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> Now when we have a host generic PCIe controller in the virt board, it
> would be nice to be able to use MSIs so that we can eventually enable
> VHOST with KVM.
>
> With these patches you can use MSIs with TCG and with KVM, but you still
> need some fixes for the mapping of the IRQ index to the GSI number for
> IRQFD to work.  A separate series that enables IRQFD and vhost
> is available: "ARM adaptations for vhost irqfd setup"
> https://lists.gnu.org/archive/html/qemu-devel/2015-04/msg01054.html)
>
> Tested with KVM on XGene and with TCG by configuring a virtio-pci
> network adapter for the guest and verifying MSIs going through as
> expected.
>
> Rebased on target-arm.next, see the individual patches for detailed
> changelogs.

Applied, thanks.

-- PMM
