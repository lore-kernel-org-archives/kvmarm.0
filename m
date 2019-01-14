From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: Unexpected Behavior of post-indexed LDR/STR to unmapped addresses
Date: Mon, 14 Jan 2019 10:41:14 +0000
Message-ID: <CAFEAcA9ruZazc9C=PuZjpBUmM3Ym1p41YDEwZi7uuKiNSFPNaw@mail.gmail.com>
References: <93B846538060DA46A9945E98A2E521E90141C32A@DE02WEMBXB.internal.synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5A294A3DB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jan 2019 05:41:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JOovJ3yc6B13 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Jan 2019 05:41:26 -0500 (EST)
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com
 [209.85.167.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAF254A3DA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jan 2019 05:41:25 -0500 (EST)
Received: by mail-oi1-f180.google.com with SMTP id r62so17487458oie.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jan 2019 02:41:25 -0800 (PST)
In-Reply-To: <93B846538060DA46A9945E98A2E521E90141C32A@DE02WEMBXB.internal.synopsys.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jan Bolke <jan.bolke@synopsys.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 14 Jan 2019 at 10:32, Jan Bolke <jan.bolke@synopsys.com> wrote:
> Then I observed some strange behavior:
>
> When accessing unmapped address with str instructions they lead
> to an KVM_EXIT_MMIO as expected.
>
> However, if the str instruction is post-indexed, KVM exits with
> KVM_EXIT_UNKNOWN.

Yes, that's expected. KVM only supports performing MMIO operations
with instructions which report an ESR on data aborts with a valid
instruction syndrome, which is to say:
 * loads and stores of a single general-purpose register,
   including those with acquire/release semantics but excluding
   load/store exclusive and excluding insns using writeback

Loads and stores in that category can be easily emulated by
the kernel, so it dos a KVM_EXIT_MMIO to userspace to get/set
the actual data. Other loads and stores are easily emulated,
so the kernel does a KVM_EXIT_UNKNOWN, which typically results
in the userspace component (QEMU, etc) saying "can't handle
this" and shutting down the VM. In theory a sufficiently
capable userspace component could read the offending guest
insn and do full instruction emulation of it, but in practice
we don't do that, because sensible guests don't use these
insns to do device IO.

thanks
-- PMM
