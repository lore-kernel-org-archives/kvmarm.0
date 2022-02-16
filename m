Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE676C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 16 Feb 2022 02:52:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2529E41173;
	Tue, 15 Feb 2022 21:52:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a2TKFLUkKqWb; Tue, 15 Feb 2022 21:52:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A75AA40DFE;
	Tue, 15 Feb 2022 21:52:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CF8F40C2B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Feb 2022 21:52:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CXdUWCdviwWN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Feb 2022 21:52:45 -0500 (EST)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 36D0040A84
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Feb 2022 21:52:45 -0500 (EST)
Received: by mail-pg1-f178.google.com with SMTP id 139so923805pge.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Feb 2022 18:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=T+3VYyLTECeMOgMEiaC+u6xcJ2KtTI5ankI+rDGci68=;
 b=RkVxrBBbGlwz2LwLmUz7vynCN/Hz6yebDI6Ug4N2e6KSbowJjnGGfo5/oRl3W3bahj
 BXiCJ6uViTXhNvdB+Q1ElZW8lUxk09g/v0mpKVFDy4YreCxrvmtSoAgcFeAyPzl0J03Y
 NalWLIGV6CHe//5ceFpoG+T9OmXOa9zJcOOI11Qu0mISxXAD1ox/Hh1sIiW7Kt6qwA6F
 7dbKufKasGrPiQB+Pb6KeLT5s7PHj7otdLDc+GTw10M4r80oDXeQzY7BVvQncPIs7TQL
 wPZljBtKv12fMLemhmd3fg/JzWyUM7+ueJehkzw0uJ8/RXsz/uUjqCH9L//u3dyT5cwZ
 d4Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=T+3VYyLTECeMOgMEiaC+u6xcJ2KtTI5ankI+rDGci68=;
 b=2L3z7mXgba/oy/ObcUzgMS1ViTSFZ86ZaUfdNavWiG9pBU38ZBxMOU8C+5YgiNAHYl
 sU8kmm/amPDOQOLoUYa/Qqt4BJP+3wklOSjh4wm4bfBgxHpDxFjW9V4Q1cQEWlaaibLH
 RbVvPvA5Mcyz6NOJHoFxed26lBGpjSal2U/ByiLl622cF/G1ogHrYMgQzsOosiPRkEPv
 Gp3MloDChonYz7pYXzLw9q4QPMk8ufupNXoLjMlx7uxkA7PuG55KQbjz5WoRkBeqXwJg
 +84i/Spq4IVjv0ko2jiiXs2EtMId+QuqO1cIYKsDmalx0xvqa51xLh7OMhS7eMpRkyBi
 NbYQ==
X-Gm-Message-State: AOAM532eCHrzsMOclePP4ClJPughdi7fP3TBrvYBWvMtl4c+eltG+SvJ
 Z30H1s7IsvATeK71JPfjKvvpyABm4e9Y0ZTeh5adQQ==
X-Google-Smtp-Source: ABdhPJwiN0rD8LslLaIwFI6zgh4dyuMS3WAvh9+7lnEbHj9G2opQoU8bmKoO6GTQVnjXTzExS+VwI7tNaAlZNrS7rkA=
X-Received: by 2002:a63:5525:0:b0:372:c376:74f1 with SMTP id
 j37-20020a635525000000b00372c37674f1mr504815pgb.433.1644979964245; Tue, 15
 Feb 2022 18:52:44 -0800 (PST)
MIME-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
 <20220214065746.1230608-11-reijiw@google.com>
 <Ygv3q/+arejIWnzs@google.com>
In-Reply-To: <Ygv3q/+arejIWnzs@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 15 Feb 2022 18:52:27 -0800
Message-ID: <CAAeT=Fxvsniq4NW92LESqJ1ie6e+N1J793JrX0UBf2mq9B35dg@mail.gmail.com>
Subject: Re: [PATCH v5 10/27] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Oliver,

Thank you for the review!

On Tue, Feb 15, 2022 at 10:57 AM Oliver Upton <oupton@google.com> wrote:
>
> Hi Reiji,
>
> On Sun, Feb 13, 2022 at 10:57:29PM -0800, Reiji Watanabe wrote:
> > When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> > means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> > expose the value for the guest as it is.  Since KVM doesn't support
> > IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> > expose 0x0 (PMU is not implemented) instead.
> >
> > Change cpuid_feature_cap_perfmon_field() to update the field value
> > to 0x0 when it is 0xf.
>
> Definitely agree with the change in this patch. Do we need to tolerate
> writes of 0xf for ABI compatibility (even if it is nonsensical)?
> Otherwise a guest with IMP_DEF PMU cannot be migrated to a newer kernel.

Hmm, yes, I think KVM should tolerate writes of 0xf so that we can
avoid the migration failure.  I will make this change in v6.

Since ID registers are immutable with the current KVM, I think a live
migration failure to a newer kernel happens when the newer kernel/KVM
supports more CPU features (or when an ID register field is newly
masked or capped by KVM, etc).  So, I would assume such migration
breakage on KVM/ARM has been introduced from time to time though.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
