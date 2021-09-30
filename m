Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B241EC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 17:19:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2FAD2617E6
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 17:19:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2FAD2617E6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D3F54B0C5;
	Thu, 30 Sep 2021 13:19:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EzZfKiVS414x; Thu, 30 Sep 2021 13:19:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70D414B0C0;
	Thu, 30 Sep 2021 13:19:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6F584B0B4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 13:19:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WtVsX99G+KhG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 13:19:23 -0400 (EDT)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B647F4B099
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 13:19:23 -0400 (EDT)
Received: by mail-pf1-f170.google.com with SMTP id 145so5577375pfz.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 10:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=FbUMduP+V7YnqmanKgM6nU8SaYibHpVmraBSeLg1aDM=;
 b=bYLXQKEpsloNnvsHfy/j8500N9x/ynvqqMtXn5sN5GSVf9iu2E0yiCvHR6+tveYSRF
 kmVrrANLCl4pgMNjtLDYSm5s3jem1aABmFVatjxdL16HrFTX2WjDb1B90K6jdb73d7f5
 BCUMOf43v1SqO/6bCO9meJISuWfIcxI+RLkVFrLQJTUeUcEPrBEiapNuQs2ht64kUhNG
 Udmw/pPF3P1scQ7K4tRSr3rVaUTpFnEOrTDmFvBiEyw0V6w7VPnU9fpmgDkPe6xf1+o/
 g00yBzaTvFnTOWcdpnUB8/aaBQ4qDSmAG1PN1GMxv7JvQ/zDgYLDcinUPoUWZQDDMOcd
 p++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=FbUMduP+V7YnqmanKgM6nU8SaYibHpVmraBSeLg1aDM=;
 b=Kjh+agjw/9fRsUMiGCLTRp0fwnhcUSrEkVz+mFfTQnJ4oTbW7TsDQH51s1n+ZnReum
 RPhb2xwiO5lYMJUxFlPVXB9TBywGGH+JekkR8muzjRHBFEdSCuqBORYL30SH0e9J3Nxv
 eyeoOskD6Dcb49VQSmjeYiJCP7XTsyt7k5bMvvK/4I+Vh1RQRtEOwl9HufVq+uZe2uPi
 TW80bJTfevzY7IRpYsUl2ey5K27RaQpxhBoBZ2MkqENvCR+cQoHvZEhLz9YV6oJPyZrq
 kSFxLmTQpMrhNcQekojxfmV+3AmhiuCuoqgOEFiJsDhZuIoZXas2fk2EYlBi697peJcY
 ubBw==
X-Gm-Message-State: AOAM530Rvod8Hwg25bwqm2mfQwx1kwIL5NpMMKS6ZNxFSmLL/B2bQSAF
 DKYXyRlBY+NhuUi4zO+exchAlQ==
X-Google-Smtp-Source: ABdhPJzo4auAyDB0h9s5ykpt5niwliEjviFUy6E2xL/2EeRvCDpS3aPUP1uUEhuzYpWfypFK//XGoA==
X-Received: by 2002:a63:1d5c:: with SMTP id d28mr5872510pgm.143.1633022362363; 
 Thu, 30 Sep 2021 10:19:22 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id w6sm3852283pfj.179.2021.09.30.10.19.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Sep 2021 10:19:21 -0700 (PDT)
Date: Thu, 30 Sep 2021 17:19:18 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 06/11] KVM: arm64: Add support for SYSTEM_SUSPEND PSCI
 call
Message-ID: <YVXxlg6g4fYsphwM@google.com>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-7-oupton@google.com>
 <877deytfes.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <877deytfes.wl-maz@kernel.org>
Cc: Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

On Thu, Sep 30, 2021, Marc Zyngier wrote:
> Hi Oliver,
> 
> On Thu, 23 Sep 2021 20:16:05 +0100,
> Oliver Upton <oupton@google.com> wrote:
> > 
> > ARM DEN0022D 5.19 "SYSTEM_SUSPEND" describes a PSCI call that may be
> > used to request a system be suspended. This is optional for PSCI v1.0
> > and to date KVM has elected to not implement the call. However, a
> > VMM/operator may wish to provide their guests with the ability to
> > suspend/resume, necessitating this PSCI call.
> > 
> > Implement support for SYSTEM_SUSPEND according to the prescribed
> > behavior in the specification. Add a new system event exit type,
> > KVM_SYSTEM_EVENT_SUSPEND, to notify userspace when a VM has requested a
> > system suspend. Make KVM_MP_STATE_HALTED a valid state on arm64.
> 
> KVM_MP_STATE_HALTED is a per-CPU state on x86 (it denotes HLT). Does
> it make really sense to hijack this for something that is more of a
> VM-wide state? I can see that it is tempting to do so as we're using
> the WFI semantics (which are close to HLT's, in a twisted kind of
> way), but I'm also painfully aware that gluing x86 expectations on
> arm64 rarely leads to a palatable result.

Agreed, we literally have billions of possible KVM_MP_STATE_* values, and I'm pretty
sure all of the existing states are arch-specific.  Some are common to multiple
architectures, but I don't think _any_ are common to all architectures.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
