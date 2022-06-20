Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F24AACCA479
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jun 2022 08:59:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EA274B35E;
	Mon, 20 Jun 2022 04:59:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@brainfault-org.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rZx2fJ0GbFpr; Mon, 20 Jun 2022 04:59:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19CC84B38F;
	Mon, 20 Jun 2022 04:59:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15D954B38F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 04:59:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XRXAaH3CjfyZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jun 2022 04:59:49 -0400 (EDT)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com
 [209.85.128.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CFDAE4B35E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 04:59:48 -0400 (EDT)
Received: by mail-wm1-f43.google.com with SMTP id
 m16-20020a7bca50000000b0039c8a224c95so5326135wml.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 01:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=brainfault-org.20210112.gappssmtp.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=UhbqiV0Ln/z8uccUqeNX/XfJm8bU+4E6XGmgA7WoQZ4=;
 b=1nFPBdzSAp7vUSAKAIEYwUqVfc1EngKszrSD5daAJJS9L/gUzz3co+QVs7DjWHb8NL
 OyVi7JeMaZpDTMmCZ9fDCRja2ouJ7BylDdBFmJ/W7OEdBQrno/Arq6liGahflLYGi43T
 QgKGiYwBQ7+H6+UwOtXf9yISqC+1oTEtRToF9R+XA/eRr/Yb2dW+S0FIAJjNihsNiWNA
 ebxH9lvVxxL9z+412j7l6tJko1BTnAIwEzXrmx30bjnHpONrZcLI29QuB2WAxFoBVIkk
 0QaEJ2U6zVlTwOvjRoPiN6ZQs1SrN6TWhSoZz9gbuJa533tlxc6yt9fwJvZQnobB1ePm
 vhIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=UhbqiV0Ln/z8uccUqeNX/XfJm8bU+4E6XGmgA7WoQZ4=;
 b=3scuqnsyEkj43i+vCV/WmE2UIie5qwvCNvo07CRbsUc6VarjLDIAKF01K+p1l1uh+h
 UbIOj5aVaj17eX+anC+wu75cUKr2/kFZcgHbeUMfNqk+OGhFQYhfVsCSe9wOqI9ZZ1lT
 WSraXPKH7vLw2XoSncD9L/57lSve+ihNXngxZbBqghAmbjHAEl6Qi7FIQMb3hLSFVRYG
 H3Co+cgR1nVwiwbLsaM9VJshsKbXDmFvMvxzUqvRL/WbR4x1YWXnaiJzhfPwSdfVBjl4
 /AToM2APZLbnuLxGong8+jXWZG23ujqAOHOTBIeHMTwamFs6cQmGY4Pyx9Jk6BgG0PIH
 bCVQ==
X-Gm-Message-State: AOAM533laxUaHq+Yg8R4dJleQIHeODkWy4/oacTTAXCfHDk0LecPUPTr
 77eS7kj/TLJ8W9HtTKABVdqe5R1AQd1C3fs3u2XSQg==
X-Google-Smtp-Source: ABdhPJwAclle+CORSjPjJi7db7HxxfijathTLOpl4t/xDnpFtnPOk3qBJwYvtl+L7pGIQa1vVGSlvbBX2RiLau/aEgs=
X-Received: by 2002:a05:600c:3caa:b0:394:8fb8:716 with SMTP id
 bg42-20020a05600c3caa00b003948fb80716mr33862529wmb.105.1655715587518; Mon, 20
 Jun 2022 01:59:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-3-coltonlewis@google.com>
 <20220616121006.ch6x7du6ycevjo5m@gator>
 <Yqy0ZhmF8NF4Jzpe@google.com> <Yq0Xpzk2Wa6wBXw9@google.com>
 <20220620072111.ymj2bti6jgw3gsas@gator>
In-Reply-To: <20220620072111.ymj2bti6jgw3gsas@gator>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 20 Jun 2022 14:29:36 +0530
Message-ID: <CAAhSdy03XsyP3B2VYtpLUkWfr5SREsTJWmuStKfS05hib3e7CQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: selftests: Increase UCALL_MAX_ARGS to 7
To: Andrew Jones <drjones@redhat.com>
Cc: thuth@redhat.com, KVM General <kvm@vger.kernel.org>,
 Colton Lewis <coltonlewis@google.com>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Mon, Jun 20, 2022 at 12:51 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Sat, Jun 18, 2022 at 12:09:11AM +0000, Sean Christopherson wrote:
> > On Fri, Jun 17, 2022, Colton Lewis wrote:
> > > On Thu, Jun 16, 2022 at 02:10:06PM +0200, Andrew Jones wrote:
> > > > We probably want to ensure all architectures are good with this. afaict,
> > > > riscv only expects 6 args and uses UCALL_MAX_ARGS to cap the ucall inputs,
> > > > for example.
> > >
> > > All architectures use UCALL_MAX_ARGS for that. Are you saying there
> > > might be limitations beyond the value of the macro? If so, who should
> > > verify whether this is ok?
> >
> > I thought there were architectural limitations too, but I believe I was thinking
> > of vcpu_args_set(), where the number of params is limited by the function call
> > ABI, e.g. the number of registers.
> >
> > Unless there's something really, really subtle going on, all architectures pass
> > the actual ucall struct purely through memory.  Actually, that code is ripe for
> > deduplication, and amazingly it doesn't conflict with Colton's series.  Patches
> > incoming...
> >
>
> RISC-V uses sbi_ecall() for their implementation of ucall(). CC'ing Anup
> for confirmation, but if I understand the SBI spec correctly, then inputs
> are limited to registers a0-a5.

Yes, we only have 6 parameters in ucall() since it is based on SBI spec.

Actually, a6 and a7 are used to identify the type of SBI call (i.e. extension
and function number) whereas a0-a5 are function parameters.

Regards,
Anup

>
> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
