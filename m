From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: "info cpus" issue
Date: Mon, 16 Mar 2015 18:05:27 +0000
Message-ID: <CAFEAcA9PA7ZK5k+CdhjOv36nyAxyG5jr+hzqJaWxwvfwJVfqBQ@mail.gmail.com>
References: <5506EA45.1060407@freescale.com> <55071A8A.2060408@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADDDC48E9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2015 13:59:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KIlmsVFXAHiT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Mar 2015 13:59:13 -0400 (EDT)
Received: from mail-ig0-f174.google.com (mail-ig0-f174.google.com
 [209.85.213.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7789048E95
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2015 13:59:13 -0400 (EDT)
Received: by igbue6 with SMTP id ue6so37596922igb.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2015 11:05:47 -0700 (PDT)
In-Reply-To: <55071A8A.2060408@siemens.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 16 March 2015 at 18:01, Jan Kiszka <jan.kiszka@siemens.com> wrote:
> Can't comment if it's known but, from x86 experiences, such a pattern is
> usually related to inconsistency between "get kvm state" and "put kvm
> state" in QEMU or the related kernel interfaces:
>
> QEMU obtains the in-kernel CPU state when you issue "info cpus", marks
> it as "dirty" (in case other QEMU functions will manipulate it - won't
> happen in this case) and then writes it back to the kernel once the
> guest is resumed on that vcpu. If the state you get is not fully
> reflecting what you will write back, you corrupt the guest.

There are some known issues with migration/state save/load for
ARM -- try with Alex Bennee's kernel and QEMU patches that are
on the list right now?

-- PMM
