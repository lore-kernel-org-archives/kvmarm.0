Return-Path: <SRS0=YqI3=NO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 133CDC4338F
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 10:24:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 88E97611EF
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 10:24:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 88E97611EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 162B94B1A3;
	Mon, 23 Aug 2021 06:24:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A0iTNkfXwtY7; Mon, 23 Aug 2021 06:24:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 220504B1E5;
	Mon, 23 Aug 2021 06:24:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 478524B1AC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 06:24:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hAlHvTliHITA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Aug 2021 06:24:23 -0400 (EDT)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com
 [209.85.210.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 211E14B1A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 06:24:23 -0400 (EDT)
Received: by mail-ot1-f42.google.com with SMTP id
 v33-20020a0568300921b0290517cd06302dso34964798ott.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 03:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=k3uARFKW5i95Stpaj6QcX5SJb/gBsd5wlKEHWvxTOlE=;
 b=WC9BKVUPEOP7oxtXFoSslK3UCllSr4wtkJ5GS7jnuiGbxOzFlvh7IZH+Zcvxg89wPQ
 QLL+AV1Z4hLDWp7zZi+e7cgUJ4/d/R04W4gED4FYKdPm7pKrVoqI4OGGkOEK8bvxM6/z
 v8Dytaoxjljppi25q2KvOdmn0mMabXeYaZS8x1psv5tICnFjLs2WJDIJmorv5CkkNZgz
 AM2rNAOhO+sYIr1VYvV3LOMLQDsbUWmDVAY26Dm4YGsZe9HSn0QCtOe4/6wYGomGJiEn
 2NF/PD3DFr7UcQNbwDAl+HdY1Yr+LI+El0+wL+KWzeUftDzjsEjh57ggEak3wLVQl6ym
 f8IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=k3uARFKW5i95Stpaj6QcX5SJb/gBsd5wlKEHWvxTOlE=;
 b=A0HxcCy28mQKqypaewCjeb0hL6QsmVgSyZpxax1cIz/Xszg3EgTaOZIkETn5PHbheM
 G4nk79YQWFudB9wEMLKp3ihi49XR0KMzjbusZoaUEeXAI/mSXvIRQtfxvPR0DNJgvgfJ
 WHZAK4cmEvsG2e7ZNSIFaNoD6Gk36bDrGeCQGfBaNtRS3AluALYjmGzn0NGtVfHvaG/Z
 RIKlyKARIA8Js+qvcRgU13P7eFDJut60c1Nd1iva7UBAZGfE4CddLZM1+V62fFBTWlxA
 q7IXwH6VpmQwzV1rzv3aZNbhHzyuCHli62OfgXEKXemFZTwFrzS9O9zVJ4ZP80W0Jlnn
 vTZg==
X-Gm-Message-State: AOAM530FrkB9UXGFJpRkuTuVa3nRO5JiyHiUdepZKnCAAzGrRnwnTBKX
 4fw5sd67P3cQK3HTo2UQKQMUwn011lwvwe3K51hDpg==
X-Google-Smtp-Source: ABdhPJw47asjLGg3IHhq6DwkpRq1WK6eZuxYYe87HFmvJkCVR3ngD76xFymCkYMGEPR3xZRntez8Vcl8RXyvpG9rt38=
X-Received: by 2002:a9d:309:: with SMTP id 9mr27320777otv.365.1629714262300;
 Mon, 23 Aug 2021 03:24:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
 <162945557041.2025988.6137048861111259637.b4-ty@kernel.org>
In-Reply-To: <162945557041.2025988.6137048861111259637.b4-ty@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 23 Aug 2021 11:23:46 +0100
Message-ID: <CA+EHjTzZn+_4VZ+J7gToBv6XYXUBDxmHT0zkHVy+-2RDFY=-wQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/15] KVM: arm64: Fixed features for protected VMs
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com, will@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On Fri, Aug 20, 2021 at 11:34 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 17 Aug 2021 09:11:19 +0100, Fuad Tabba wrote:
> > Changes since v3 [1]:
> > - Redid calculating restricted values of feature register fields, ensuring that
> >   the code distinguishes between unsigned and (potentially in the future)
> >   signed fields (Will)
> > - Refactoring and fixes (Drew, Will)
> > - More documentation and comments (Oliver, Will)
> > - Dropped patch "Restrict protected VM capabilities", since it should come with
> >   or after the user ABI series for pKVM (Will)
> > - Carried Will's acks
> >
> > [...]
>
> I've taken the first 10 patches of this series in order to
> progress it. I also stashed a fixlet on top to address the
> tracepoint issue.
>
> Hopefully we can resolve the rest of the issues quickly.

Thanks. I am working on a patch series with the remaining patches to
address the issues. Stay tuned :)

Cheers,
/fuad

> [01/15] KVM: arm64: placeholder to check if VM is protected
>         commit: 2ea7f655800b00b109951f22539fe2025add210b
> [02/15] KVM: arm64: Remove trailing whitespace in comment
>         commit: e6bc555c96990046d680ff92c8e2e7b6b43b509f
> [03/15] KVM: arm64: MDCR_EL2 is a 64-bit register
>         commit: d6c850dd6ce9ce4b410142a600d8c34dc041d860
> [04/15] KVM: arm64: Fix names of config register fields
>         commit: dabb1667d8573302712a75530cccfee8f3ffff84
> [05/15] KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
>         commit: f76f89e2f73d93720cfcad7fb7b24d022b2846bf
> [06/15] KVM: arm64: Restore mdcr_el2 from vcpu
>         commit: 1460b4b25fde52cbee746c11a4b1d3185f2e2847
> [07/15] KVM: arm64: Keep mdcr_el2's value as set by __init_el2_debug
>         commit: 12849badc6d2456f15f8f2c93037628d5176810b
> [08/15] KVM: arm64: Track value of cptr_el2 in struct kvm_vcpu_arch
>         commit: cd496228fd8de2e82b6636d3d89105631ea2b69c
> [09/15] KVM: arm64: Add feature register flag definitions
>         commit: 95b54c3e4c92b9185b15c83e8baab9ba312195f6
> [10/15] KVM: arm64: Add config register bit definitions
>         commit: 2d701243b9f231b5d7f9a8cb81870650d3eb32bc
>
> Cheers,
>
>         M.
> --
> Without deviation from the norm, progress is not possible.
>
>

On Fri, Aug 20, 2021 at 11:34 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 17 Aug 2021 09:11:19 +0100, Fuad Tabba wrote:
> > Changes since v3 [1]:
> > - Redid calculating restricted values of feature register fields, ensuring that
> >   the code distinguishes between unsigned and (potentially in the future)
> >   signed fields (Will)
> > - Refactoring and fixes (Drew, Will)
> > - More documentation and comments (Oliver, Will)
> > - Dropped patch "Restrict protected VM capabilities", since it should come with
> >   or after the user ABI series for pKVM (Will)
> > - Carried Will's acks
> >
> > [...]
>
> I've taken the first 10 patches of this series in order to
> progress it. I also stashed a fixlet on top to address the
> tracepoint issue.
>
> Hopefully we can resolve the rest of the issues quickly.
>
> [01/15] KVM: arm64: placeholder to check if VM is protected
>         commit: 2ea7f655800b00b109951f22539fe2025add210b
> [02/15] KVM: arm64: Remove trailing whitespace in comment
>         commit: e6bc555c96990046d680ff92c8e2e7b6b43b509f
> [03/15] KVM: arm64: MDCR_EL2 is a 64-bit register
>         commit: d6c850dd6ce9ce4b410142a600d8c34dc041d860
> [04/15] KVM: arm64: Fix names of config register fields
>         commit: dabb1667d8573302712a75530cccfee8f3ffff84
> [05/15] KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
>         commit: f76f89e2f73d93720cfcad7fb7b24d022b2846bf
> [06/15] KVM: arm64: Restore mdcr_el2 from vcpu
>         commit: 1460b4b25fde52cbee746c11a4b1d3185f2e2847
> [07/15] KVM: arm64: Keep mdcr_el2's value as set by __init_el2_debug
>         commit: 12849badc6d2456f15f8f2c93037628d5176810b
> [08/15] KVM: arm64: Track value of cptr_el2 in struct kvm_vcpu_arch
>         commit: cd496228fd8de2e82b6636d3d89105631ea2b69c
> [09/15] KVM: arm64: Add feature register flag definitions
>         commit: 95b54c3e4c92b9185b15c83e8baab9ba312195f6
> [10/15] KVM: arm64: Add config register bit definitions
>         commit: 2d701243b9f231b5d7f9a8cb81870650d3eb32bc
>
> Cheers,
>
>         M.
> --
> Without deviation from the norm, progress is not possible.
>
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
