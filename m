Return-Path: <SRS0=hs0s=PY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A4F7C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 01:34:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 79A8061245
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 01:34:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 79A8061245
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0380C4B0BF;
	Thu,  4 Nov 2021 21:34:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bblC9qsQ65DA; Thu,  4 Nov 2021 21:34:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E4124B0BE;
	Thu,  4 Nov 2021 21:34:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F21A54B0BE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 21:34:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dHYUK2HJ2dP8 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Nov 2021 21:34:10 -0400 (EDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com
 [209.85.208.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DAE74A5A0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 21:34:10 -0400 (EDT)
Received: by mail-lj1-f181.google.com with SMTP id t11so12492658ljh.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Nov 2021 18:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=WmJtXBkg7pd+AkHNmF/OOE0ZCZ7A0DUPGQ3AraUyTKE=;
 b=PZE9AjSPOY3ehFs177/vcSypOeEzbZbOjJTIP6cW52S5WQTctkopZtXJ8ZzGpp4Ftk
 X7/NIPtm/J/5VDoXx/Rk8S8UZL1YO1x3EzWDIGTtxRfd4KPeefDpEsG1u8daXYp9AqG+
 ERm34LdXlTc1oMG4MjN/+ZedoSmn6HMU7WNncJ0a8GhiBg++YuGmkY7sgeVTR00j4RQ0
 O6F1zstzgn2wLez4WTmwyygFlygy6VJXxNUKxBD5N1w99YYS1i9l6C4f3/9/BZXVXFJQ
 TBdoEpu2mzZovHHUC9PY1QP0DRbm7upXKQkmiBMSgs9gUyFpby5JJ0PbegWFoAG8mCC9
 tFUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=WmJtXBkg7pd+AkHNmF/OOE0ZCZ7A0DUPGQ3AraUyTKE=;
 b=0mtlE3tkjFkJ5lhEbUS4/j1EE73t2mQ8Ir8iSVbLE21uIV+BF0RAYYVQ5kLNFiYrWy
 R4HTjWKIAFlISXNq6tjBX3z8D4oof80F5QlhF2ynuMGzLxMrt4OXx6m+4XSu/u30uCb7
 4jNKbBtK8jZcJAlpsxGYllHE2TgJ65+EAOYHhChAYbN62qtvnC8g0YmROQwqsUWwyKEg
 NhF3DIo7ajV2OBeG0UL1BHjyiiU4kdulrh/q4EuKnKS/JNzEGsnaj83biX/EhdY7RmCY
 y2XOyJvSSzDdBxwP7XrEFZee8U4gwm+AeNEFntQ/hcmXpU0jmsDeN0rN2QkUkwhQlunI
 onXw==
X-Gm-Message-State: AOAM531+G7UefEKF/uHQul6pUXzKuEnnuQQq3zRyX2hqe8HDorwF8ERN
 Q+P8hsxxkWh30W5bjeUzeBzZbVn9nnPMZzg9QjwKMg==
X-Google-Smtp-Source: ABdhPJyewwZhYvIK3ydA+zOEsxVMwLZ6je5RssWrC6icEv9NcYFD1E5ThOQun0PMv8mV+NBDOBTesnHzih36VdxT/oQ=
X-Received: by 2002:a05:651c:984:: with SMTP id
 b4mr8397659ljq.170.1636076049067; 
 Thu, 04 Nov 2021 18:34:09 -0700 (PDT)
MIME-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
 <20211103062520.1445832-3-reijiw@google.com>
 <YYQG6fxRVEsJ9w2d@google.com>
 <CAAeT=FzTxpmnGJ4a=eGiE1xxvbQR2HqrtRA3vymwdJobN99eQA@mail.gmail.com>
In-Reply-To: <CAAeT=FzTxpmnGJ4a=eGiE1xxvbQR2HqrtRA3vymwdJobN99eQA@mail.gmail.com>
From: Oliver Upton <oupton@google.com>
Date: Thu, 4 Nov 2021 18:33:58 -0700
Message-ID: <CAOQ_QsjNDct2C8mrz4aezEu4hPU6RH8_1vLMq=RjngABu0qVjA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 02/28] KVM: arm64: Save ID registers' sanitized
 value per vCPU
To: Reiji Watanabe <reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Nov 4, 2021 at 2:39 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Oliver,
>
> On Thu, Nov 4, 2021 at 9:14 AM Oliver Upton <oupton@google.com> wrote:
> >
> > Hi Reiji,
> >
> > On Tue, Nov 02, 2021 at 11:24:54PM -0700, Reiji Watanabe wrote:
> > > Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> > > registers' sanitized value in the array for the vCPU at the first
> > > vCPU reset. Use the saved ones when ID registers are read by
> > > userspace (via KVM_GET_ONE_REG) or the guest.
> >
> > Based on my understanding of the series, it appears that we require the
> > CPU identity to be the same amongst all vCPUs in a VM. Is there any
> > value in keeping a single copy in kvm_arch?
>
> Yes, that's a good point.
> It reminded me that the idea bothered me after we discussed a similar
> case about your counter offset patches, but I didn't seriously
> consider that.

Yeah, it was a good suggestion for the counter offsetting series, and
one that I plan to adopt once I get back to that set :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
