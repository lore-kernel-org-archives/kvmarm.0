Return-Path: <SRS0=fGD+=OV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1121DC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 15:40:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D25A61268
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 15:40:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6D25A61268
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0BBB407E7;
	Fri,  1 Oct 2021 11:40:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9ZnLAuvwoBQN; Fri,  1 Oct 2021 11:40:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACFAD4083E;
	Fri,  1 Oct 2021 11:40:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E537406E7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 11:40:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q6WgkHrNTsac for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Oct 2021 11:40:10 -0400 (EDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com
 [209.85.167.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2399F405EE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 11:40:10 -0400 (EDT)
Received: by mail-lf1-f45.google.com with SMTP id z24so40430278lfu.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Oct 2021 08:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=iOLU+PCShJG7mENHHZDmXfBtA4qSABTxjGLw2vfUX2M=;
 b=FTPMXgWBWfgF0X587P8+s1ivBN5zQ86AEsMZsPqUhkAqpZfSYc01006geCHMsZrYSS
 /BlxSbkGJ2vpnZ+l+ytY+WRa6dTr09YIVuzOENTgTGtsDXx+3BrNnUV1if8FkhPXh1CX
 Epao7cmUnjwYPTQLUyKy2S7Dfg+J7Fsb6JY7sEuAP6soByMYDsDn4c/n31GS6u+/40/X
 SPmXvA4hFk37oLYnJI/xMnWxUdgKOQYPVH6zASRx+HECat6x0G8GV2JrS4PdBqBwiB1/
 Qralg04VhqUHVAMGM+7ur0MoRrKfP5OB3J6LpSrEgQDkfc/jQrFwocXgzQjTOUj0tGRM
 PAJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=iOLU+PCShJG7mENHHZDmXfBtA4qSABTxjGLw2vfUX2M=;
 b=Ztntwxrxe6zS3Jmw1vZzblvYRt65G70CrqJI225jYbywBX5fHTEGLVlG0ACN8x3OtC
 aB98YrF3MxUixwwaiM3DVIIIXaMQPQQHx2MnAJTTDOCFwIdPR3VxEHEA4MfEBrUngkFq
 QR0YwRYDe6tvBBgJMqaNSkISvs7VzJJ8qJqAOYoxiaojFyoCUVNsy2m3QA0E4u78lFLW
 wNTHyK1PGaGEYKKEf2vnsc0ldKphlitKdc9HFVBS4AhS5kNPA1+IxgT8kNOryWU1SjPv
 QQXJqdRIzqV4SlzP14+GAQh859lH/bYYf4TsTWYSOq7qwcca7cOqWg0zGJnCyXNwawpu
 F5Ow==
X-Gm-Message-State: AOAM5325XR+QGhkkqgqaaDlwiVjSqc86L/3npWVMC8onWD4KeIRY5RPV
 i4VLLjEmsJrH59iRTUrutgriGNT3tRp/qmGWxVX4Iw==
X-Google-Smtp-Source: ABdhPJyIyzUImniAS1WPH/aukNvZr9uNqVUOpo4zsi5GOyk1J8bsugXgDuozoLPp9qcCmCzvYTBMvavb9Z+NJVInTA4=
X-Received: by 2002:a2e:95cc:: with SMTP id y12mr12643770ljh.337.1633102808495; 
 Fri, 01 Oct 2021 08:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-5-oupton@google.com>
 <d88dae38-6e03-9d93-95fc-8c064e6fbb98@redhat.com>
 <746cfc82-ee7c-eba2-4443-7faf53baf083@redhat.com>
In-Reply-To: <746cfc82-ee7c-eba2-4443-7faf53baf083@redhat.com>
From: Oliver Upton <oupton@google.com>
Date: Fri, 1 Oct 2021 08:39:57 -0700
Message-ID: <CAOQ_QsgmpsjKD7SVzX4ftOUkDtMF+egorOyNwG8wpYqw2h44pw@mail.gmail.com>
Subject: Re: [PATCH v8 4/7] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On Fri, Oct 1, 2021 at 7:41 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 01/10/21 16:39, Paolo Bonzini wrote:
> > On 16/09/21 20:15, Oliver Upton wrote:
> >> +    if (data.flags & ~KVM_CLOCK_REALTIME)
> >>           return -EINVAL;
> >
> > Let's accept KVM_CLOCK_HOST_TSC here even though it's not used; there
> > may be programs that expect to send back to KVM_SET_CLOCK whatever they
> > got from KVM_GET_CLOCK.
>
> Nevermind, KVM_SET_CLOCK is already rejecting KVM_CLOCK_TSC_STABLE so no
> need to do that!

Yeah, I don't know the story on the interface but it is really odd
that userspace needs to blow away flags to successfully write the
clock structure.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
