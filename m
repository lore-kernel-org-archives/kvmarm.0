Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 926E2C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 16:43:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 06B4A6113A
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 16:43:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 06B4A6113A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 893C04B15E;
	Thu,  9 Sep 2021 12:43:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fH7conAoadj2; Thu,  9 Sep 2021 12:43:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CBB44B10B;
	Thu,  9 Sep 2021 12:43:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 723184066E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 12:43:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vo+mdAhKcZNa for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 12:43:44 -0400 (EDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com
 [209.85.219.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 82E41405A6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 12:43:44 -0400 (EDT)
Received: by mail-yb1-f173.google.com with SMTP id k65so5105447yba.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 09:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=8rBbbtBdxJo/z24uZXVl1WsJ9x865p3tX3wOkYNw8zI=;
 b=CxwyPEJx4brKYyNJfKH8xuVZVHNOb+imoHwqrC+m2OvLlX1CF4dc26BHqiDbb0sFdk
 FmFt0zmLzKgCa1DNQCsc6xZr9y3Z4pPNnzfIhUb3+16a9bNWy6ONfjK/aT8G5S4TT4x2
 SkyR9dYU1Bc3NWOfR/N8Xx4cdUqvv0TI5ThmKPXKlq0Dk9Zn2TJzowps8qXs4ziXJamP
 twWLDiVKUzt9dDskgQnZ+tuA0VajMO+0ZZb02gUUe6KXZatND7/Lkxi5UJx9cL/zyBl2
 9opFUHOSodvBlEv+qiApY+wGv/xCn72PWdKYkA+dJ2BOP4oZE/fSnYIKWCoQG3Sc2S3C
 kONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=8rBbbtBdxJo/z24uZXVl1WsJ9x865p3tX3wOkYNw8zI=;
 b=rnDkd6wFlbprQVe+ORhNVRysFLDxwrJ3vwEweV0/7+AmWoNNkxcKfyyDjMqnhw5kL+
 2QEFzm2fP6FExEU3gFnVeMQv7ZfQ/Zu0QM5vmvjZZDJzg5E3LE+45q0G0eyYvouTLa9n
 4kLVqNf2rdScIH0aEOrtm+nv6QqCD8mrl/8a8YRWhPlimvdH8FZbPvVngdHra7Ffu3F2
 PRPIr1E1WaPbiRaOKRN9OF58O/XacC8+s/pTlMWuhUUkqxR3I1HRwABrMzXPyZ+PpGl9
 vznHDX/h1ukb5ri/ak8lu6unzKt3u3YGeye0XC3se2FU8VR4W+n1+OVOsMeBqWpl/nqt
 pbiA==
X-Gm-Message-State: AOAM531KdwZFdHr5Dkve/VIkruJA4xAghbB0xaAn+8Wk7548kzv7NLOU
 qpRcxVWtWgHM/TpSLNUW46heMCn35TzGqkCNix2vww==
X-Google-Smtp-Source: ABdhPJxK5TixXHGpQ0HcjLdTV1bZ1SKePd5PRIPCrE5JXb/3IBGHK3nqLVQvIpatA9h6OifefO1lBmdtxEyNyano2rg=
X-Received: by 2002:a25:cd82:: with SMTP id d124mr5096262ybf.491.1631205823874; 
 Thu, 09 Sep 2021 09:43:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-4-rananta@google.com>
 <20210909065612.d36255fur5alf6sl@gator>
In-Reply-To: <20210909065612.d36255fur5alf6sl@gator>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 9 Sep 2021 09:43:32 -0700
Message-ID: <CAJHc60y2i9AT5rEat0pK-h2BsNjzp_1tbqGAM5Lx=V3WfBBaMA@mail.gmail.com>
Subject: Re: [PATCH v4 03/18] KVM: arm64: selftests: Use read/write
 definitions from sysreg.h
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
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

On Wed, Sep 8, 2021 at 11:56 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Thu, Sep 09, 2021 at 01:38:03AM +0000, Raghavendra Rao Ananta wrote:
> > Make use of the register read/write definitions from
> > sysreg.h, instead of the existing definitions. A syntax
> > correction is needed for the files that use write_sysreg()
> > to make it compliant with the new (kernel's) syntax.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../selftests/kvm/aarch64/debug-exceptions.c  | 28 +++++++++----------
> >  .../selftests/kvm/include/aarch64/processor.h | 13 +--------
> >  2 files changed, 15 insertions(+), 26 deletions(-)
> >
>
> Same comment as Oliver, otherwise
>
Will fix.

Regards,
Raghavendra
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
