Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06A2C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 23:12:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26D1640C2B;
	Mon, 14 Mar 2022 19:12:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iyZy6IWj7WjL; Mon, 14 Mar 2022 19:12:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 176F349ED7;
	Mon, 14 Mar 2022 19:12:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BD5C40C2B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 19:12:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t67Vj3gniqZo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 19:12:31 -0400 (EDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com
 [209.85.219.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 497B540B3B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 19:12:31 -0400 (EDT)
Received: by mail-yb1-f181.google.com with SMTP id t11so2186562ybi.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 16:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=6jcGFDnk2ZGG1bJEADu4KX2ojHtFBsAIu/76P0Vp8qQ=;
 b=dEkCRsYp+MJ88Ryr09A72p/YdO6yGqO6HYOT4j+2PmSf1Fc1i9uuNZUJ+dRzhXIR6c
 hxl6+bTXY9g96VrCHB0rf9zglCVg57wIzPMGUcl5G2N5nJP47hZFJ5A4EU3etADVLZgi
 rCnORkYhOEfIzI1brWjsOm2WChZta6k5dxI7S2kWeXNu/p9wcGlH00DgLS5xj0VIdA9+
 kRr9gSd3K2K6tVeJ2E4Pc4R6dxc6xmvfG6BS2pPF+t9G64rYVLNSg+w8f8XYM9gZuG4M
 eD2+VeyTWRB3lxjb3FjgONy4cWYZK5gUSzWbV3xwfDDe8hn56mHOHgTPMbNq8JcjBCJS
 8t1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=6jcGFDnk2ZGG1bJEADu4KX2ojHtFBsAIu/76P0Vp8qQ=;
 b=Pyv7ZXQtiHHGUC9QSmd+7Wfsjiy+kYaSCKIG4e7xdWSeKvJfekfoX4JMDJ2nACEZmo
 FzwdSnQMQGQGaIPULiwOljd75F41T6uQnqJqzhZqfP1KPD/IvG2uJ5m6zc9JnxMsrdwJ
 C11eYQHJyQmqVyTGv2mnTdFXF69CE/2eWCFN55vqu2oA/0TwcpXKXxfCPXGAgdUbBSKz
 jtN4cldOJEHAkY388taHK4Bj9s5F2vI5uqyCFpLqr6+DKCjYboJscpEkm+rC+A24Dw3F
 x43x+hkD7qVlINA+ZWYdrdlbVxDBtKW7a/FRQuUgqxZipzQDNZZMH2XSNt3/3DCjUl+F
 AZlw==
X-Gm-Message-State: AOAM5326P33zMJERUduigI+r3mIz1yw625PMC2mzwnuan+YInPmylE8B
 XVfpBGJaGxZ92zyO/2o8k9ZWR77eWLBJXc1YkkHjNQ==
X-Google-Smtp-Source: ABdhPJwOFHiGKaFjeiuAVqn0xvjObYV2J61nUJiTd5dhiZHHRCKHynlwkSXGaPtMkDjYwpTL95ZQnsnKJb988XLF1wk=
X-Received: by 2002:a25:d512:0:b0:61d:aded:1743 with SMTP id
 r18-20020a25d512000000b0061daded1743mr19108638ybe.526.1647299550552; Mon, 14
 Mar 2022 16:12:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com>
 <20220224172559.4170192-5-rananta@google.com>
 <Yi+DS/BUPMiB+B0a@google.com>
In-Reply-To: <Yi+DS/BUPMiB+B0a@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 14 Mar 2022 16:12:19 -0700
Message-ID: <CAJHc60zTDrwM_cEBKACQjqxceKbCV65mMM83xgPa0xvxMtZo=Q@mail.gmail.com>
Subject: Re: [PATCH v4 04/13] KVM: arm64: Capture VM's first run
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

On Mon, Mar 14, 2022 at 11:02 AM Oliver Upton <oupton@google.com> wrote:
Hi Oliver,
>
> Hi Raghavendra,
>
> On Thu, Feb 24, 2022 at 05:25:50PM +0000, Raghavendra Rao Ananta wrote:
> > Capture the first run of the KVM VM, which is basically the
> > first KVM_RUN issued for any vCPU. This state of the VM is
> > helpful in the upcoming patches to prevent user-space from
> > configuring certain VM features, such as the feature bitmap
> > exposed by the psuedo-firmware registers, after the VM has
> > started running.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>
> I believe this patch is superseded by commit:
>
>   5177fe91e4cf ("KVM: arm64: Do not change the PMU event filter after a VCPU has run")
>
> on kvmarm/next.
>
Perfect! Just what we needed. I'll drop this patch.

Regards,
Raghavendra
>
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
