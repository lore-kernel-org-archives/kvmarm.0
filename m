From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: Aarch64: Qemu master or 2.9.0-rc1 breaks compatibility with 4.10
 kernel.
Date: Tue, 28 Mar 2017 12:29:35 +0100
Message-ID: <CAFEAcA-kKvS_6OZE1mKbFYgCzm4wPK2XJi_A03nFxu+K3ZA4hQ@mail.gmail.com>
References: <CACJhumejPG6s_dewyHH=e5=QLcOUCzvzhakA7oSqm2Ms5cQvRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4C8840C17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 07:28:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EKGYRoj9Ibca for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Mar 2017 07:27:59 -0400 (EDT)
Received: from mail-wr0-f175.google.com (mail-wr0-f175.google.com
 [209.85.128.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E48040A95
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 07:27:58 -0400 (EDT)
Received: by mail-wr0-f175.google.com with SMTP id w43so86137199wrb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 04:29:57 -0700 (PDT)
In-Reply-To: <CACJhumejPG6s_dewyHH=e5=QLcOUCzvzhakA7oSqm2Ms5cQvRA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Prakash B <bjsprakash.linux@gmail.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, bprakash@caviumnetworks.com, QEMU Developers <qemu-devel@nongnu.org>, "Kumar,
 Vijaya" <Vijaya.Kumar@cavium.com>, qemu-arm <qemu-arm@nongnu.org>, sgoutham@cavium.com, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 28 March 2017 at 12:22, Prakash B <bjsprakash.linux@gmail.com> wrote:
> Qemu master or v2.9.0-rc1 doesn't launch guest  when host kernel
> version 4.10 or  lower on Aarch64 (cavium ThunderX), its failing with
> abort  "qemu-system-aarch64: KVM_GET_DEVICE_ATTR failed: No such
> device or address"
>
> "GICv3 live migration support"  patch breaks the  compatibility b/w
> kernel and qemu.
>
> Is this expected behaviour,  can we provide a fix without  breaking
> compatibility b/w kernel and qemu .

This is indeed not supposed to happen. Eric, can you take a look?

thanks
-- PMM
