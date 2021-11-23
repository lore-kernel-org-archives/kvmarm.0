Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F16B7C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 23 Nov 2021 18:32:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D86A4B16F;
	Tue, 23 Nov 2021 13:32:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KcI7QhMq9PNK; Tue, 23 Nov 2021 13:32:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B64CD4B1A4;
	Tue, 23 Nov 2021 13:32:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E1924B19A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 13:32:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZJttQAhpF1B6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Nov 2021 13:32:04 -0500 (EST)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com
 [209.85.219.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B329A4B16F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 13:32:04 -0500 (EST)
Received: by mail-yb1-f173.google.com with SMTP id v64so36581ybi.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 10:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=sWVtHaZi/e9UJUnkTaYofcMjEaLdDp/jPuX8rBQAchs=;
 b=nfFKmAZwvXAM3ASdqYnv4QRwJxyeMfTIoQtcS254MI36Gt2Ht8an01gHjneszrzERs
 Ui2ZFyHN3B1RmxuMcDtfSLEZ8BxmRj0GysG6G9D2OaOIkURKNyoUk+xW2aUrUD59KdmL
 LCNGzsxaxepXdiVgXd9JR7YMOXr8YWmBQomke0ErKHcm4E7dwY1NAc+f9TsmQ+YaZ/8X
 1Zkp9RRIcc9JpTpnf+HiPbY344nMNYCVmZCML3nd0YWbnMMgQZgCmQKt+r2rwGqrMDXn
 Mcp9Dj7imz/jAG37XeK9uC92zEhQ7aDC8Mbivm3uM7CmJ0nHJZ6E/tBv6OslKhUth4hg
 5WtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=sWVtHaZi/e9UJUnkTaYofcMjEaLdDp/jPuX8rBQAchs=;
 b=fJLpK2LnLaVY+2A8FmkxHjgvQDMDcD4ULLx/rPdEvnM1sCzKsBPrhCbS/JPE/cz3Cg
 cTya79VKL7uh9z5r8eEXIrC5ZpTgY6zzstpM5vWWZhPlhpWAfESJpsGOazlARHCRoOYT
 ION3xaySf6CiZk12kCdB+4YoDHeQhGtkmdYM+DDpmKLekQNk46lMLVGTkWZQSZ5KUrvu
 ZjlebQx9pzfl5CsG/MjfHklRBi35UCwO1/5D9TOYCA9gq0fopY2S1V5y8WasCr+5NEyB
 MN71CuF7e4EYfdgl0W3dFI4+l4hhBgdj5jP4Ttx4pVxJcKXJoG4huCPrXKYEHK19Dg5Z
 Mp9Q==
X-Gm-Message-State: AOAM532FTNYYY5Oz7Y7nC3lhRXhtPhfFAwhL8n2FoN1GwsuViq6DRY0m
 hLtxCr/py9UkmhA7fporRzb42WNkpzC1EWphDGA+Sg==
X-Google-Smtp-Source: ABdhPJzD79MwgizGCt6LZiTbZtlpIJ5vPiTXvUDS/Do60Z2kHs5u3LD+wEQLzYsksrOBEYM4TrigBY1feOG3lG6S/TM=
X-Received: by 2002:a25:a169:: with SMTP id z96mr7882343ybh.491.1637692323881; 
 Tue, 23 Nov 2021 10:32:03 -0800 (PST)
MIME-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com>
 <20211113012234.1443009-3-rananta@google.com>
 <87zgpwcg0s.wl-maz@kernel.org>
In-Reply-To: <87zgpwcg0s.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 23 Nov 2021 10:31:53 -0800
Message-ID: <CAJHc60ysebqSukBLpZ9na7daoFr+sGB0PWw-_V5nFObjqdkSyg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 02/11] KVM: Introduce kvm_vcpu_has_run_once
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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

Hello Marc,

On Mon, Nov 22, 2021 at 8:27 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Sat, 13 Nov 2021 01:22:25 +0000,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > Architectures such as arm64 and riscv uses vcpu variables
> > such as has_run_once and ran_atleast_once, respectively,
> > to mark if the vCPU has started running. Since these are
> > architecture agnostic variables, introduce
> > kvm_vcpu_has_run_once() as a core kvm functionality and
> > use this instead of the architecture defined variables.
> >
> > No functional change intended.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>
> arm64 is moving away from this, see [1]. You also don't need any new
> state, as vcpu->pid gives you exactly what you need.

Thanks for the pointer. I can directly use this!
>
> Happy to queue additional patches on top if you want to deal with
> riscv.
>
Just to clarify, you mean get the kvm support for riscv on kvmarm-next?
If yes, then sure, I can make changes in riscv to use
vcpu_has_run_once() from your series.

Regards,
Raghavendra


> Thanks,
>
>         M.
>
> [1] https://lore.kernel.org/all/20211018211158.3050779-1-maz@kernel.org/
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
