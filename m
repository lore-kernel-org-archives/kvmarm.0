Return-Path: <SRS0=8LgP=AH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4827CC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 26 Jun 2020 13:00:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B79FA20775
	for <kvmarm@archiver.kernel.org>; Fri, 26 Jun 2020 13:00:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Vfzaao/u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B79FA20775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0856A4B1D8;
	Fri, 26 Jun 2020 09:00:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cLhYe+bKCtKf; Fri, 26 Jun 2020 09:00:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1A084B1D3;
	Fri, 26 Jun 2020 09:00:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B918B4B135
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2020 09:00:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YaYZC75I9X2c for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Jun 2020 08:59:59 -0400 (EDT)
Received: from mail-oi1-f196.google.com (mail-oi1-f196.google.com
 [209.85.167.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D70214B114
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2020 08:59:59 -0400 (EDT)
Received: by mail-oi1-f196.google.com with SMTP id k4so7984603oik.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jun 2020 05:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Ka0oIQYu+5hhSwRJltqEXo4HJnZK2e5WXM5WZG7JEZ8=;
 b=Vfzaao/uT44wP7JQQ1HUEopzlxRDTsfA/lgWLklhGJ1EzSieoOZtrUPBWpBjgq0kjZ
 b5uU/DPsWjuToJCs20CyFJG/L4J5jBmhrKnjx4wDaRkY1wQY1uMvyDlPF6qOUjyu9LGr
 qwiALLpWJyKSUtkO0dzU0Ki9rQ4C27pxFnM7RzjkjJZ9bCj5CLb3xv5eiqpCEpbbHU3y
 DKo9ruGYHTTgT8lDKfUhG2AOyPG8TzqLlL9yKJ5BLCM3pqK1I/xVTlaFBZgF66bkhywR
 YvZc89NGEHdM/mFeI8ZCih87d18NxW7UXRS6zYvJESqQbIof+436h2+U04vi/YJj6HMN
 OrNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Ka0oIQYu+5hhSwRJltqEXo4HJnZK2e5WXM5WZG7JEZ8=;
 b=W20K4wRXP3Ac8bT5X9iZysQJOAKeWbdKUtkKEVx4BZmMwYMzviaILO9XVNRHTZodk2
 7w7y7NRpRip2PSMzaEUXeSP3ZRF06H6Ja2mR9EAlwH5bZYS1S1Xb4XzOp3qw10/TVk3w
 q4sW0lLmjRjJpy0DYKF7eFR+irnjBGShw540TRp+Vgk8/vDC8uUvTDr8q4eneNvVylPs
 m+h81wIJ9gA2GKP9WAmrTikEL/XinMsxx8omIJSaJ+vjkMu7M4FdKjhoeNLc1NUJGRO8
 tsTzSycVoa5x8bFbfKKgM58CJ6ca+cygmf8NcuxOZR/ZTV3iNpHHN0AsfpPauSs5TOUa
 +gUQ==
X-Gm-Message-State: AOAM533ZqJP5ndREWiAW5sCOQHCxOXMjryzTy4IOGLfsQaQkNwYQ0fdf
 VIr8kJOIgUCy7sgVoGE7j3kxbt7D4XbQUUHli/2KOw==
X-Google-Smtp-Source: ABdhPJzxBJVtDzPQT8otlYc/WbHU8cc5xTATMD0y0OAnzfPjFZn1MLZgdW7ZJVsxMb40LJgJIhZPxgsVATyKPyZ9L4E=
X-Received: by 2002:a54:4694:: with SMTP id k20mr2186547oic.146.1593176399314; 
 Fri, 26 Jun 2020 05:59:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200625220336.10186-1-beata.michalska@linaro.org>
 <20200625220336.10186-2-beata.michalska@linaro.org>
 <20200626090050.3sqsukopwydv43od@kamzik.brq.redhat.com>
In-Reply-To: <20200626090050.3sqsukopwydv43od@kamzik.brq.redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 26 Jun 2020 13:59:48 +0100
Message-ID: <CAFEAcA_pKMkwAGAAdkCXk3dOqJQnX+qRsZuLMWA0qfMsw+aF1Q@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] target/arm: kvm: Handle DABT with no valid ISS
To: Andrew Jones <drjones@redhat.com>
Cc: QEMU Developers <qemu-devel@nongnu.org>, qemu-arm <qemu-arm@nongnu.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On Fri, 26 Jun 2020 at 10:01, Andrew Jones <drjones@redhat.com> wrote:
> nit: How about using '= {0}' when declaring the variable, rather than this
> memset?

We prefer "= {}" -- although "= {0}" is the C standard approved
version, some compiler versions produce spurious warnings for
it in some situations. (cf commit 039d4e3df0049bdd8f9).

thanks
-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
