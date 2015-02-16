From: Anup Patel <anup@brainfault.org>
Subject: Re: vexpress: Framebuffer broken with KVM enabled
Date: Mon, 16 Feb 2015 14:50:02 +0530
Message-ID: <CAAhSdy3mNAm6Jt=s3Nt_fy_z=mMf3kG3DqYW3jROTo-ztUGzkw@mail.gmail.com>
References: <54E1B4BA.3030705@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96C1B45C28
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Feb 2015 04:14:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BxlmzymeCHRx for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Feb 2015 04:14:42 -0500 (EST)
Received: from mail-yh0-f41.google.com (mail-yh0-f41.google.com
 [209.85.213.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5C7045C09
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Feb 2015 04:14:42 -0500 (EST)
Received: by mail-yh0-f41.google.com with SMTP id 29so13455537yhl.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Feb 2015 01:20:02 -0800 (PST)
In-Reply-To: <54E1B4BA.3030705@web.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jan Kiszka <jan.kiszka@web.de>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 16, 2015 at 2:43 PM, Jan Kiszka <jan.kiszka@web.de> wrote:
> Hi,
>
> next issue related to KVM/QEMU on the TK1: The guest image I'm running
> gives proper framebuffer output when in emulation mode. Once KVM is
> enabled, the screen is - at best - only initially updated. Sometimes I
> see the famous tux images and a bit of the console texts, but usually it
> stays black. Explanations?

The QEMU accesses Guest Video RAM (or any portion of Guest RAM) as
cacheable user space memory. The Guest Kernel might access Guest Video
RAM as non-cacheable to maintain coherency with video device. If this is
the case then all updates by Guest kernel to Guest Video RAM will not
be visible to QEMU.

--
Anup

>
> Jan
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
