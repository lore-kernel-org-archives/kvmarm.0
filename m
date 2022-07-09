Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB18C43334
	for <kvmarm@archiver.kernel.org>; Sat,  9 Jul 2022 07:00:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51D994B396;
	Sat,  9 Jul 2022 03:00:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aHNKLEsk6vnW; Sat,  9 Jul 2022 02:59:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 297584B442;
	Sat,  9 Jul 2022 02:59:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 132314B43F
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jul 2022 02:59:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pd2l57oZgAOI for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Jul 2022 02:59:57 -0400 (EDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com
 [209.85.217.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 164524B396
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Jul 2022 02:59:57 -0400 (EDT)
Received: by mail-vs1-f54.google.com with SMTP id l190so599684vsc.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jul 2022 23:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=HaPegW27H93Qf4TuxECcq/yCoVA6MfE/QOnVJszZDqA=;
 b=Lkv82oUqjvx4Bsq9AtLaUds17K8rvpLSqlVTwzEriO+7DAVVH66sFzMkvAUGaWd/kU
 gwVuwFKFD88nJ5O4pZoIxtg1lhPUARBkvmy+v0uiswS2j0T/Xs1cWWFlB/Xwm9gKbMF1
 9LdwLGg3eYo0Og81xf32dTXWkZtwvExnAmDmqBZAVLlzXmIR00QcirlEByuOKO4S7OBa
 fNGpR3C8b/A4BfNfDeki405qB7XJhjS746SRczj0m3Vl7i7QR3RAbN26P+vjxsUqvm0d
 /UNbQQIYkbDS/RPA40vb+LVvrsrFohjok+eDSgXFmCXuc2ODIyYBBNzjCrPQ6GtJfIXk
 WTsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=HaPegW27H93Qf4TuxECcq/yCoVA6MfE/QOnVJszZDqA=;
 b=jfh5fM9lDY2oFI0in+mp+oAyQFhqjScdRyKzJ4AyJlz0XOa6BwwkPwwOMkW1hEdjLl
 /nOQIKkfnIOcGtOwy4Ot6/c0B7+3tKjPTtK0w7dhLwxs36v04uu86DyaFwSX/m2+417Q
 PUV4Aafyzm/w3Uj5Y6RYW2pparqrtwDv+6I68zNfUCoSkJuZggd/v9RNmBNdDzBMKJsc
 6kojx3iBXJlkKMO0RX3BuQUhQUtVUfDXwOnJjaeNaJtRq4IIO3EEF0BFSXVN8KDAJIEI
 89naGTfokv9zs/TczIgJ7tqSx4JPGz8aO37laneBN+smfmALyrk1qTQounXEEksplN1v
 C9Fw==
X-Gm-Message-State: AJIora/B8x+GOi7i+rzYsJ+7I5aVd/ZmntwD5AyzBBf7+9DXbY+2kGUg
 bnNzy6vfrmvavuT0YGymSOHt5RHRgill8QE760k+qw==
X-Google-Smtp-Source: AGRyM1siUKjCQ234FL+iWMyc7JxnpRG4THdhKQrLHWHdu6Z5JHZJxU9jxDzxB/Hqk+PLOrefUUydrBpwTKwsKgw61xs=
X-Received: by 2002:a05:6102:cc6:b0:356:3c5c:beb5 with SMTP id
 g6-20020a0561020cc600b003563c5cbeb5mr3066937vst.80.1657349996519; Fri, 08 Jul
 2022 23:59:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-4-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-4-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 8 Jul 2022 23:59:40 -0700
Message-ID: <CAAeT=Fx0Xr7cGxO64vMUH0uKg1upeOZ3Tvu-1av7ro_+AbTi+g@mail.gmail.com>
Subject: Re: [PATCH 03/19] KVM: arm64: Introduce generic get_user/set_user
 helpers for system registers
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
 Oliver Upton <oliver.upton@linux.dev>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Wed, Jul 6, 2022 at 9:43 AM Marc Zyngier <maz@kernel.org> wrote:
>
> The userspace access to the system registers is done using helpers
> that hardcode the table that is looked up. extract some generic
> helpers from this, moving the handling of hidden sysregs into
> the core code.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
