Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21218C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 22:16:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A98CE4B139;
	Tue, 11 Jan 2022 17:16:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Rb17Y9Ptip4T; Tue, 11 Jan 2022 17:16:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A05749F54;
	Tue, 11 Jan 2022 17:16:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2724E49F54
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 17:16:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G3cGtnkB2AIF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 17:16:15 -0500 (EST)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com
 [209.85.222.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 36A2449F4D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 17:16:15 -0500 (EST)
Received: by mail-ua1-f52.google.com with SMTP id l15so1250031uai.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 14:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=AF3AnK5QyRYkI5duIqUXZZyuc4HWRw2U/KYG/ayPad0=;
 b=kqs/HwY3kdGXMoeolWYAyWUmTsR5sUhlpiLE8CAWHX6TaOVUKEGXDoxHbcTKLmVCG0
 IhtAfUwVRh7KP08av16i05Pd8FSrwjNjdtpPbMsBBI6PnKm01aCOykc8ytoDzIF+jZDB
 ucnSWegydwRYmRG2G1HxICSrD5e0tifOqyBR84K9SvrJc3dFdKb2+NJk33fJ7KcgEmCj
 8My/Dr+oFtLZiKHrhV+u2262tUuikggcl6klljuaZ7xfc240+z/kd9ZN5q+lHPduYO6Z
 h7M0lXflluwxEqTugcPItRA1FJLHtUckpYA1aVFTZM2fVFlq5m8B05K0fMNvQZ60va7a
 9NAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=AF3AnK5QyRYkI5duIqUXZZyuc4HWRw2U/KYG/ayPad0=;
 b=pmHnNAAuTCPRNNZWDLkjFQIIWFF5fAMQ4sTM3b1DAIaus+YZF3xu8jZ2CJA1ZkFCot
 m96AYxyv7VWREtMEfDY6x5JuPVk2/4So0/8SZa2mwdB1GgSfXBEt98kQdqmd130pKrSD
 /LVotwIoxiPy/1QVbPv1yJopCBCmMGrGQGKqTnzeSdxYPfDe38tMxcHMLlAOffUPP1WG
 y/G1TCEyDzO0sLIxh/D7Xx3UnsFechHXhqjG8OuZTlc+BG5Qazkyw/l+TVVPtHaMBBr2
 iJ8pwWBtQ3HmX+OerjdMJjxYoLdMizLmqCMWW+oP0GM+AJ0/kSCRHmYaurfQEjAPxrZ/
 LJlg==
X-Gm-Message-State: AOAM531b/yqgFWRSTJND6oEqNeZH28Ndi4NX1T4kczrPBlzA9/qFeDME
 s4sy+n4mlk8YOcLCvxfTR62/+gLXLcDiQh0qsu5YvA==
X-Google-Smtp-Source: ABdhPJwH0XMvSBmXysbrAE0IMAmKDuqLdVGaZMH4BqCu7B80Ul8RetTLJ2iipZWKkFFmI8wAVmH1SRHloobnvEvWEdg=
X-Received: by 2002:a05:6102:c46:: with SMTP id
 y6mr3408907vss.82.1641939373465; 
 Tue, 11 Jan 2022 14:16:13 -0800 (PST)
MIME-Version: 1.0
References: <20220110210441.2074798-1-jingzhangos@google.com>
 <20220110210441.2074798-4-jingzhangos@google.com>
 <87a6g2tvia.wl-maz@kernel.org>
In-Reply-To: <87a6g2tvia.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 11 Jan 2022 14:16:01 -0800
Message-ID: <CAAdAUthmAMy3UE3_C_CitW9MWWMGcOPHu0x9aV72YEUL2kpO=g@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] KVM: selftests: Add vgic initialization for dirty
 log perf test for ARM
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Jan 11, 2022 at 2:30 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 10 Jan 2022 21:04:41 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > For ARM64, if no vgic is setup before the dirty log perf test, the
> > userspace irqchip would be used, which would affect the dirty log perf
> > test result.
>
> Doesn't it affect *all* performance tests? How much does this change
> contributes to the performance numbers you give in the cover letter?
>
This bottleneck showed up after adding the fast path patch. I didn't
try other performance tests with this, but I think it is a good idea
to add a vgic setup for all performance tests. I can post another
patch later to make it available for all performance tests after
finishing this one and verifying all other performance tests.
Below is the test result without adding the vgic setup. It shows
20~30% improvement for the different number of vCPUs.
+-------+------------------------+
    | #vCPU | dirty memory time (ms) |
    +-------+------------------------+
    | 1     | 965                    |
    +-------+------------------------+
    | 2     | 1006                    |
    +-------+------------------------+
    | 4     | 1128                    |
    +-------+------------------------+
    | 8     | 2005                   |
    +-------+------------------------+
    | 16    | 3903                   |
    +-------+------------------------+
    | 32    | 7595                   |
    +-------+------------------------+
    | 64    | 15783                  |
    +-------+------------------------+
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  tools/testing/selftests/kvm/dirty_log_perf_test.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > index 1954b964d1cf..b501338d9430 100644
> > --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > @@ -18,6 +18,12 @@
> >  #include "test_util.h"
> >  #include "perf_test_util.h"
> >  #include "guest_modes.h"
> > +#ifdef __aarch64__
> > +#include "aarch64/vgic.h"
> > +
> > +#define GICD_BASE_GPA                        0x8000000ULL
> > +#define GICR_BASE_GPA                        0x80A0000ULL
>
> How did you pick these values?
I used the same values from other tests.
Talked with Raghavendra about the values. It could be arbitrary and he
chose these values from QEMU's configuration.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
