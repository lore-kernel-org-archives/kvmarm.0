From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC] KVM API extensions for SVE
Date: Fri, 24 Nov 2017 15:03:17 +0000
Message-ID: <CAFEAcA_czAp1=n+BENZNiyn7k6bjRXOk3dYBQHgddDZXUP2osg@mail.gmail.com>
References: <20171121134913.GI22781@e103592.cambridge.arm.com>
 <20171122195230.GT28855@cbox>
 <20171123184050.GM22781@e103592.cambridge.arm.com>
 <20171124144538.GG28855@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77F9649D36
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Nov 2017 10:00:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8VM9voKyc1Q2 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Nov 2017 10:00:57 -0500 (EST)
Received: from mail-ot0-f193.google.com (mail-ot0-f193.google.com
 [74.125.82.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 48FFD49D1A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Nov 2017 10:00:57 -0500 (EST)
Received: by mail-ot0-f193.google.com with SMTP id j29so18982376oth.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Nov 2017 07:03:38 -0800 (PST)
In-Reply-To: <20171124144538.GG28855@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Dave Martin <Dave.Martin@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 24 November 2017 at 14:45, Christoffer Dall <cdall@linaro.org> wrote:
> On Thu, Nov 23, 2017 at 06:40:50PM +0000, Dave Martin wrote:
>> This creates another issue: if SVE is supported by the host kernel
>> but not enabled for the guest, do I need to hist the SVE regs from
>> KVM_GET_REG_LIST?
>
> I don't think so.  We should check with QEMU and kvmtool, but I think
> the way it works is that userspace matches the KVM list with its own
> internal list, and matches up anything it knows about, and discards the
> rest.  Certainly in the past we haven't been afraid of adding registers
> to KVM_GET_REG_LIST.

QEMU userspace doesn't discard things it doesn't knows about, it
just blindly passes them along in the migration stream to the
destination.

The awkward bit for SVE is that its registers for KVM_GET_REG_LIST
will be bigger than 64 bits. If you do that for existing QEMU
binaries they'll assert because of the check in kvm_arm_init_cpreg_list()
that the register size is something it can handle. So we mustn't
list the SVE regs in GET_REG_LIST unless userspace has told us it
can handle them (by setting a feature bit in the arguments to
KVM_ARM_VCPU_INIT, presumably).

thanks
-- PMM
