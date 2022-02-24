Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07440C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 06:14:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A2584BE52;
	Thu, 24 Feb 2022 01:14:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ro71KGYihmM5; Thu, 24 Feb 2022 01:14:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 288FF4BE3D;
	Thu, 24 Feb 2022 01:14:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B64C4BE39
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 01:14:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cdBDxBUoYJf1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 01:14:27 -0500 (EST)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A6EE44BE32
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 01:14:27 -0500 (EST)
Received: by mail-pf1-f180.google.com with SMTP id i21so951443pfd.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 22:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=AcesQizc+ubZc3BIrOT5zz6JTdW6rEleTjgpKAn42RQ=;
 b=C4xlXdce515O+e+mu5KsDJlkUT0q8i+OwflyqkLbu9OgXXhJPm+IFmxLmq+eF6lX0+
 E60Cgs1wwbm/76XCpMbAGbZEwO/xZd2ib9Wk9MUjC2kH6zKI/NQ1xy4JXt4l7VoIwvwZ
 QyO47cWdfQSgdHu5aM1QTYfl+8k/LbcWbWvOYF9lFVKSzwLxjGkJoMfEvooKS5fZAvSo
 dLYzreUYLEmC1vQwZaFhP6d/6K8HAFC+/L5DoMtXed863g/wxlUqDeFkrCAFaakN+aKI
 tG1T9y8Sg0Bq47XaSx7UPJAGRAFuqoei4ARB7j0jzLjMSzGtOA3Rx74BWQnYkh1pF55q
 GpZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=AcesQizc+ubZc3BIrOT5zz6JTdW6rEleTjgpKAn42RQ=;
 b=XTFoIHeZqCuO1AHeBg3S3loZo1FTdLmyTDBJJTy2wvZu2XDwuAU+0+r2a5gUHHH7lW
 gQvNk950QO1YLwQdMoghhQ9jToKIQLMDDl1/t/OtnC0E0kLdXsYQW6w1YBKp+JExXa8s
 Qc/r77iO+gbx0amhVwQ5iJNOQlUgZvOUmsKuknJmILdJgQe3K/g7wiz/cdTIwNh5Gj0z
 7sAeUeiWwDUHLjsbB5NoALH0adhhKFLnQl+qQVwvlymMWffs4hbC0KlbFjujUVNTRkok
 F4w/X3tArSJVqqAls3nJlbHHSMjEvYG3VUgl1UCUXNGDZUSD4xe7W+P4IqCHraOW38Xl
 eH4Q==
X-Gm-Message-State: AOAM5339rReemzCQ6xhsXN15ZabxH2znZ7SRbSKEhxPEGsFLTqb7mXfj
 jD1Au8aY12Zf3S36VVjuq0ec39g//cGIh+as7Q7OYA==
X-Google-Smtp-Source: ABdhPJxI2uT3Q1vcNIt/vBqPLHZP7CvTxkIVzKbUC8ZJOcqQjVxntyiAbpTdnGLxdUaIQfKtQMtmwRDM/xvJ2RoY4Xk=
X-Received: by 2002:a05:6a00:194b:b0:4e1:799:7a3 with SMTP id
 s11-20020a056a00194b00b004e1079907a3mr1167891pfk.82.1645683266572; Wed, 23
 Feb 2022 22:14:26 -0800 (PST)
MIME-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
 <20220223041844.3984439-2-oupton@google.com>
In-Reply-To: <20220223041844.3984439-2-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 23 Feb 2022 22:14:10 -0800
Message-ID: <CAAeT=FwgekGA-OjqN5hQeWNY8TS=Vf03GKfgW03sFhFahpgTKw@mail.gmail.com>
Subject: Re: [PATCH v3 01/19] KVM: arm64: Drop unused param from
 kvm_psci_version()
To: Oliver Upton <oupton@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Atish Patra <atishp@atishpatra.org>, Peter Shier <pshier@google.com>,
 kvm-riscv@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Tue, Feb 22, 2022 at 8:19 PM Oliver Upton <oupton@google.com> wrote:
>
> kvm_psci_version() consumes a pointer to struct kvm in addition to a
> vcpu pointer. Drop the kvm pointer as it is unused. While the comment
> suggests the explicit kvm pointer was useful for calling from hyp, there
> exist no such callsite in hyp.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
