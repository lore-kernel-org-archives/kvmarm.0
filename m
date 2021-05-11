Return-Path: <SRS0=u/VZ=KG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E98C433ED
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 08:04:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C96E761448
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 08:04:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C96E761448
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EC3C4B495;
	Tue, 11 May 2021 04:04:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U4Ntiig-mZQe; Tue, 11 May 2021 04:04:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47A3B4B49A;
	Tue, 11 May 2021 04:04:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 752284B495
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 04:04:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T8+mneZnRaY1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 May 2021 04:04:18 -0400 (EDT)
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com
 [209.85.161.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E8914B434
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 04:04:18 -0400 (EDT)
Received: by mail-oo1-f54.google.com with SMTP id
 v14-20020a4ae6ce0000b02901fe68cd377fso4028427oot.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 01:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=vqWqlRo1t8unIB3Z/gPDCFXryTe+VxOxmZbywII60x4=;
 b=RsARpI9kPbe8fGR56PQ4skYG8c9j7c835d7rOcGai/qr7PmvAFxTBwMPg0n2VNOOJ5
 KkP+xqxkTWNxfq5af47pwFhxQ+gI535/8Hg4Py+5tIBUnpVpw+uUqHNdiGy1We0e6P7C
 U3pDYJNh9iAbAGww3qtuHQ2C6EI76iWRqwRdduT/OiYZNMX9ZOvWrl/LOZQlW9gSIr1c
 Lza0R/5guKEDeTbh4LO7VrsbCV1JlyXIRO9IliK93CHvkIlqHwTidtABkP6MtO1RLgI8
 0futdZOP85C/BHdhcmoHGmhTFD1t2/pn5mxbgN3B6aATye6KVk+2Hm+OkS0WCKlV7WAR
 mPUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=vqWqlRo1t8unIB3Z/gPDCFXryTe+VxOxmZbywII60x4=;
 b=iVxdT3j/Q0xB9xpx2XkZa/hN9a8dAo7eOYj/Is9IWPb9CKbIDSSUbgPwpiM0h5LF6U
 TBKwGk74Ke+t7Pl0Y5s8L3O7o136kbKCVq8snDN/b9cmGgE1S4KgxwG+DJC9rkRC/kai
 1mR4BkFbMzZdx4hFuSFR/rDWU+aNTME9KKtmrKWqFuwEHbaZOw+TPfjH9oBMYlm/Mboj
 3aT9Ic7eQJeuefRTFdv870uR0UADAmLAt7EzmWtdnyZSJ2kAuk6/6lXMvP0rC1YsvtQu
 R5oDgCLl1IC8VtZrflAjOUdoGaR2N94+0nzsvmincM3bKkFHXxMyLZH6FXKgQRHj615p
 2JBQ==
X-Gm-Message-State: AOAM530/Lo3MZQJi1ItilTZho182Dc2KYc/6xYMRE6XXFcHc86jP0skK
 Jl0X7r6TRO0rYkRJN2agiSzlVW00lYdGnLxxZ0ja0g==
X-Google-Smtp-Source: ABdhPJwiG5f14ptUggSSt+hUanG2tnouIAtbpU1JD68oO5A0s7qMCGnueWGVnCFx9fN6AZ33rumu5oXEfhtT2qh7sVs=
X-Received: by 2002:a4a:ea2b:: with SMTP id y11mr285770ood.42.1620720257457;
 Tue, 11 May 2021 01:04:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210510094915.1909484-1-maz@kernel.org>
 <20210510094915.1909484-3-maz@kernel.org>
In-Reply-To: <20210510094915.1909484-3-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 11 May 2021 09:03:40 +0100
Message-ID: <CA+EHjTzcfmt4mxh05a_P+nheQ_A2FuXhpgvKXuV5__pZP0SxkA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Commit pending PC adjustemnts before
 returning to userspace
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com, stable@vger.kernel.org,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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

> KVM: arm64: Commit pending PC adjustemnts before returning to userspace

s/adjustments/adjustments

On Mon, May 10, 2021 at 10:49 AM Marc Zyngier <maz@kernel.org> wrote:
>
> KVM currently updates PC (and the corresponding exception state)
> using a two phase approach: first by setting a set of flags,
> then by converting these flags into a state update when the vcpu
> is about to enter the guest.
>
> However, this creates a disconnect with userspace if the vcpu thread
> returns there with any exception/PC flag set. In this case, the exposed
> context is wrong, as userpsace doesn't have access to these flags
> (they aren't architectural). It also means that these flags are
> preserved across a reset, which isn't expected.
>
> To solve this problem, force an explicit synchronisation of the
> exception state on vcpu exit to userspace. As an optimisation
> for nVHE systems, only perform this when there is something pending.

I've tested this with a few nvhe and vhe tests that exercise both
__kvm_adjust_pc call paths (__kvm_vcpu_run and
kvm_arch_vcpu_ioctl_run), and the tests ran as expected.  I'll do the
same for v2 when you send it out.

Cheers,
/fuad
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
