Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B84C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jul 2022 04:24:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA0914B94C;
	Thu,  7 Jul 2022 00:24:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PKSN-ay65K9P; Thu,  7 Jul 2022 00:24:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5CE34B925;
	Thu,  7 Jul 2022 00:24:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D3104B8D9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jul 2022 00:24:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9rEnjxMCLK8l for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jul 2022 00:24:35 -0400 (EDT)
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com
 [209.85.217.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E48B4B8C4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jul 2022 00:24:35 -0400 (EDT)
Received: by mail-vs1-f48.google.com with SMTP id 126so17064867vsq.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Jul 2022 21:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=P5zAW3N5J57Ljdte2To+3ZiUYAaiHtJmcrsOoDQ8EzE=;
 b=Pa2ATAe+73A0Q+/FoTio8/f1LsRzXiZenNRY9StpKZGLP7J4+tSHUfcxioqp3BHqZQ
 YJC2lx0bPthD8VVq16HO5F01zGxsDxPUFVHzSsOefuyRMI3VUARdrXzlTgrC0a7Uo5Rb
 gpdowRjUjtVZgTUZWTgLuxQWoocZ+ehST5cxJz/lQsD1ZSMkRm6aPi+Veyru+724PHcZ
 IOJOueuPuFYGCkKPbaGGxPmEMNUKkZuhLJRpexpLzRIVCKTxLBuzqqYRtL9QOIeeEQHv
 qcUQGj84e/FxKezNH6UcCqDaqq1xbuuoY6hVz7tfYmIRDGGRW2ta2pTVHxgu9yajmtGD
 iP3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=P5zAW3N5J57Ljdte2To+3ZiUYAaiHtJmcrsOoDQ8EzE=;
 b=74jwGZetFzZCVyD9IK0KDJTJLHzEb1cV6MV4+8Mfh5F7O+UMcqvVByGzyfVkLrxZtY
 1aDk3ZN1ZuaHGgtY1b0gQwnA7jasMaOhgQMqniiUDjm5feMFOgN+Dg0npqenfHsGaP9t
 VQd1NMWnfSyk+Rrv3xAeiM2gM8wCTbuDMtl0B3JzQuWJAHiLtSWLwNJT6DMTaNa4BCgA
 MHfzNCUWvyKgJCxTAtgL8PDFB+lh7s+yVOX+wBk8mi94raVHC2mUvqzfVROq7IsC7whl
 80cnZrQTr6hae+hnZnzwyN8U1mEMQA8tJzgXF9yXdFrCGEe+3kAQ2cnybufO5CBXLy3g
 MU7w==
X-Gm-Message-State: AJIora+EnlF7fd09wv2QeBhywDMyUmyIuQmv8fE9HGFaVDVHwc/InSn9
 lntHpt8QNfkYbJtW1gNgUhH549qYgfQWihWfFREHSQ==
X-Google-Smtp-Source: AGRyM1u+6cJnnmplQZFZti4im80gj+0WDEfv/JlcAJPgVrQyz5iGHDZGkTpKJG9Bc9yqtFJP346GgkIbfbWLptG2UbI=
X-Received: by 2002:a05:6102:cc6:b0:356:3c5c:beb5 with SMTP id
 g6-20020a0561020cc600b003563c5cbeb5mr24856988vst.80.1657167874863; Wed, 06
 Jul 2022 21:24:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org>
 <20220706164304.1582687-3-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-3-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 6 Jul 2022 21:24:19 -0700
Message-ID: <CAAeT=Fw5XZ9BX-0Gv61L7Aw44PPhUoZJ5gkzKJhsky+FC=ODbg@mail.gmail.com>
Subject: Re: [PATCH 02/19] KVM: arm64: Reorder handling of invariant sysregs
 from userspace
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
> In order to allow some further refactor of the sysreg helpers,
> move the handling of invariant sysreg to occur before we handle
> all the other ones.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
