From: gengdongjiu <gengdj.1984@gmail.com>
Subject: Re: [PATCH] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Thu, 6 Apr 2017 23:06:22 +0800
Message-ID: <CAMj-D2AKzp-J97ZZGYdtgMvUR7o=sDw5n-Ygy7amvRk6k1p9aQ@mail.gmail.com>
References: <20170315160727.16465-1-james.morse@arm.com>
 <CAMj-D2A2QyvjUvbEcnaPcPsgySvAguWFkZSS1WxxT+T3uNU7aw@mail.gmail.com>
 <58E6096E.4060206@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B0B740BAC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Apr 2017 11:04:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ga+2iEVICbwu for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Apr 2017 11:04:08 -0400 (EDT)
Received: from mail-yb0-f194.google.com (mail-yb0-f194.google.com
 [209.85.213.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5701340B3E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Apr 2017 11:04:08 -0400 (EDT)
Received: by mail-yb0-f194.google.com with SMTP id k6so1587888ybk.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Apr 2017 08:06:23 -0700 (PDT)
In-Reply-To: <58E6096E.4060206@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, gengdongjiu <gengdongjiu@huawei.com>, wuquanming@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,
  thanks for the mail.

2017-04-06 17:25 GMT+08:00, James Morse <james.morse@arm.com>:
> Hi gengdongjiu,
>
> On 05/04/17 00:05, gengdongjiu wrote:
>> thanks for the patch, have you consider to told Qemu or KVM tools
>> the reason for this bus error(SEA/SEI)?
>
> They should never need to know. We should treat Qemu/kvmtool like any other
> program. Programs should only need to know about the affect on them, not
> the
> underlying reason or mechanism.
>
>
>> when Qemu or KVM tools get this SIGBUS signal, it do not know receive
>> this SIGBUS due to SEA or SEI.
>
> Why would this matter?
>
> Firmware signalled Linux that something bad happened. Linux handles the
> problem
> and everything keeps running.
>
> The interface with firmware has to be architecture specific. When
> signalling
> user-space it should be architecture agnostic, otherwise we can't write
> portable
> user space code.
>
>
> If Qemu was affected by the error (currently only if some of its memory was
> hwpoisoned) we send it SIGBUS as we would for any other program. Qemu can
> choose
> if and how to signal the guest about this error, it doesn't have to use the
> same
> interface as firmware and the host used. With TCG Qemu may be emulating a
> totally different architecture!
>
>
> Looking at the list of errors in table 250 of UEFI 2.6, cache-errors are
> the
> only case I can imagine we would want to report to a guest, these are
> effectively transient memory errors. SIGBUS is still appropriate here, but
> we
> probably need a new si_code value to indicate the error can be cleared.
> (unlike
> hwpoison which appears to never re-use the affected page).

James,

I understand your idea.

Below is my previous idea:
  When signalling Qemu, Qemu generate GHES ,then  Qemu/kvmtool  inject
the SEA/SEI to guest OS. For different reason, Qemu/.KVMtool injects
diferent notification type. if inject SEA/SEI/IRQ, guest OS handle the
guest SEA/SEI/IRQ. handling guest OS SEA/SEI and IRQ guest OS software
logical is  different.
for example, guest OS call API "ghes_notify_sea" when happening SEA;
call API  "ghes_notify_sei" when happening SEI.

so what is your suggested way to notify guest OS after Qemu generating the CPER?

X86 Qemu uses below method(send acpi event) to notify guest OS for
runtime modification CPER, this method should not through KVM.
            /* Send _GPE.E05 event */
            acpi_send_event(DEVICE(obj), ACPI_VMGENID_CHANGE_STATUS);

so for the notification guest OS, I think Qemu uses IOCTL to let KVM
inject error may be better.



>
>
> Thanks,
>
> James
>
