Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4D5C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 13 Dec 2021 06:37:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D48E4064F;
	Mon, 13 Dec 2021 01:37:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SkLeZ3w6l2Kv; Mon, 13 Dec 2021 01:37:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 184014079A;
	Mon, 13 Dec 2021 01:37:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C02B4064F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 01:37:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4Yc+cETEsVWR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Dec 2021 01:37:09 -0500 (EST)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
 [209.85.216.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3560E401A2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Dec 2021 01:37:09 -0500 (EST)
Received: by mail-pj1-f47.google.com with SMTP id
 cq22-20020a17090af99600b001a9550a17a5so13924347pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 Dec 2021 22:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=RACP9VSONJlpojPsYQduBj0HP/5lIDcYWdB01YW/WKA=;
 b=KeMTas33BUCro4SE8FMxTE3ArGl0MV28/0DylQqpzIBp0HN/5U0xMOgK9t308VRdMU
 ZHaQCgknVwiDGORc9ivCj5fEJ63/+fLzut4g9dOoOikydF9Uo3UiHagSwlKbTw5pmA74
 u6TIlzAkoCSuX+W3f4jeDGuzyFB21a352xNmqQdVJ1jTIODEj3uwdGHyR3Cb3mW36rpL
 MA68FpVbZfU9DZs4UiBhGX68Zzpuqwh4aun28tocqWfVZTcFiObBcLVE6RDfN6hJBy8s
 /is34Pwm0bztYZzcBhj2yKs9P6baPvJeskUIv+AnzLluvnRfhvNbTb/Fjn4BVfNDUtul
 EVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=RACP9VSONJlpojPsYQduBj0HP/5lIDcYWdB01YW/WKA=;
 b=GsquYnFewq6L+ScD42u7PHq8UaHL8K6+ZhSg5Few7hrOR9z3bHK5iCZyORbUdHuN60
 pnNvDmtr/MO1ZQiBnbbhTtKhPUy8iB28JAhP403euUV/r4A5wCdeI/kjMgv+ucDZmrvg
 jelCTp8X11sq7rwWeViNs9PPk7L39gdPhypby7wc4fxXoa236QTiAuBjiyA/VXHpFEmK
 QPoMTlWpLd9C0bijsz0AbA0ME0Zx7yjXxwq79/z5UMBzH2Rb7F2SicRGfrcvGz+I2f+b
 8szLrw7PBilhbaCOqb8POAovW0nlDEnEzddmLolvNZjoLQwWeY6RDayaKpzAMpiBaMVh
 Z8yA==
X-Gm-Message-State: AOAM530vF6Fx9LvYuiVTnAcvqHqo21OwcRAkIKTAOCwPRYoAmN6tNsye
 M59n63I/LWT+Zm1kWjWktc6j67wfcE8mG1sDB4AcNw==
X-Google-Smtp-Source: ABdhPJwrIR6y9ALxLZpAhWK95u9NRyVNegCRWMOsdvReDookmEvw1GbO5o+YzWEz8e4+9hNwDWQvI+WHxMpL9o8WGBo=
X-Received: by 2002:a17:902:d703:b0:144:e012:d550 with SMTP id
 w3-20020a170902d70300b00144e012d550mr92265974ply.38.1639377428166; Sun, 12
 Dec 2021 22:37:08 -0800 (PST)
MIME-Version: 1.0
References: <20211206170223.309789-1-alexandru.elisei@arm.com>
 <CAAeT=FygprcS3YxbVaW+4yUjHBm8=MxZ+j4_iVjq7ie-ppRKRg@mail.gmail.com>
 <addac215bddf0b86bf6850093d500785@kernel.org>
In-Reply-To: <addac215bddf0b86bf6850093d500785@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Sun, 12 Dec 2021 22:36:52 -0800
Message-ID: <CAAeT=Fzz2UGQAWGx_4piJGng5BKpX3FQrZDA7u2PHFcTRD4G4w@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: Improve PMU support on heterogeneous
 systems
To: Marc Zyngier <maz@kernel.org>
Cc: will@kernel.org, mingo@redhat.com, tglx@linutronix.de,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, Dec 8, 2021 at 12:05 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Reji,
>
> On 2021-12-08 02:36, Reiji Watanabe wrote:
> > Hi Alex,
> >
> > On Mon, Dec 6, 2021 at 9:02 AM Alexandru Elisei
> > <alexandru.elisei@arm.com> wrote:
> >>
> >> (CC'ing Peter Maydell in case this might be of interest to qemu)
> >>
> >> The series can be found on a branch at [1], and the kvmtool support at
> >> [2].
> >> The kvmtool patches are also on the mailing list [3] and haven't
> >> changed
> >> since v1.
> >>
> >> Detailed explanation of the issue and symptoms that the patches
> >> attempt to
> >> correct can be found in the cover letter for v1 [4].
> >>
> >> A brief summary of the problem is that on heterogeneous systems KVM
> >> will
> >> always use the same PMU for creating the VCPU events for *all* VCPUs
> >> regardless of the physical CPU on which the VCPU is running, leading
> >> to
> >> events suddenly stopping and resuming in the guest as the VCPU thread
> >> gets
> >> migrated across different CPUs.
> >>
> >> This series proposes to fix this behaviour by allowing the user to
> >> specify
> >> which physical PMU is used when creating the VCPU events needed for
> >> guest
> >> PMU emulation. When the PMU is set, KVM will refuse to the VCPU on a
> >> physical which is not part of the supported CPUs for the specified
> >> PMU.
> >
> > Just to confirm, this series provides an API for userspace to request
> > KVM to detect a wrong affinity setting due to a userspace bug so that
> > userspace can get an error at KVM_RUN instead of leading to events
> > suddenly stopping, correct ?
>
> More than that, it allows userspace to select which PMU will be used
> for their guest. The affinity setting is a byproduct of the PMU's own
> affinity.

Thank you for the clarification.
(I overlooked the change in kvm_pmu_create_perf_event()...)


> >
> >> The default behaviour stays the same - without userspace setting the
> >> PMU,
> >> events will stop counting if the VCPU is scheduled on the wrong CPU.
> >
> > Can't we fix the default behavior (in addition to the current fix) ?
> > (Do we need to maintain the default behavior ??)
>
> Of course we do. This is a behaviour that has been exposed to userspace
> for years, and *we don't break userspace*.

I'm wondering if it might be better to have kvm_pmu_create_perf_event()
set attr.type to pmu_id based on the current (physical) CPU by default
on such heterogeneous systems (even if userspace don't explicitly
specify pmu_id with the new API).  Then, by setting the CPU affinity,
the PMU in that environment can behave predictably even with existing
userspace (or maybe this won't be helpful at all?).

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
