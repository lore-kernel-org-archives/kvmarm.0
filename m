Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B41C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 00:31:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A64CA49ED5;
	Mon, 14 Mar 2022 20:31:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iowYHMq8NRQa; Mon, 14 Mar 2022 20:31:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EE4A4141A;
	Mon, 14 Mar 2022 20:31:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2119F4141A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 20:31:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7JnPGjeAWs8f for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 20:31:27 -0400 (EDT)
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com
 [209.85.128.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D15A40815
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 20:31:26 -0400 (EDT)
Received: by mail-yw1-f175.google.com with SMTP id
 00721157ae682-2e2ca8d7812so122748097b3.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 17:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=YnoyBJB4Vv+r/cyuNhSI23nMPjDoxQQKXvsuHnpgbcI=;
 b=PSFX9gfeFcOI3JOPqNvJetxxmUTBlvBY8E8nVXjfau+zKPvT4Ae1Miv61r/b0yl+Jy
 9ov2T/6OM54/+FPS1f9ldXjbCnRrDSNOGFc64criJJ5uhfyuemoZqlJqcXbMtyfJsX7E
 XHWFBFDIOYnCpY9ZJA7YgtgUkK+l5vHyw+omD5kCIBWNzv1r1n4Ewsxziq1TYVn43Xyr
 jFTKLJB48bTExvvnMVYSmW3nOmzzqFoLhq3s7QWWw8rGUivo17gAE65VBEWONLAsO4En
 uTrubKEXSj4wv+pZGX/QRaKfMf538zH0eDKlynRFg2sX6wI5YSxV2QQHptfBHrqNMEEc
 VBkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=YnoyBJB4Vv+r/cyuNhSI23nMPjDoxQQKXvsuHnpgbcI=;
 b=IWXRVjJdVaJczdilulkZhpaq98vSRrKW4mO8nbNcb3+ZiRgWmQhIzVzzHp8nVzXOXv
 4f0bzB3nSxv5jbAgv2z6j3ZN1xIBAcYlrDPoNA4VkY+LErv+iT3yuVi5jnal1hiTv+et
 UZR1vaMUcYBvExywAxVFYmYznDKOfd9jdXXbaEiOSW8wePqecojsoK4AB83grzgPsZVi
 ajytVAKp/qAh/TQ8us4ofGQzjPQu/XjJ+Altxfa0KO34GpHq6Alv9uEQMjNF4HZAAi1e
 TmNYI1HQLdUKnabtIOCSH5Cg71gXsUfmuaTivugjgEyPKvNYYUxHXu1I10v6IJoD8qqy
 j2Tw==
X-Gm-Message-State: AOAM533UIPBgxr7k1efpS93xMhnK/CypMJsrR7Lds0r9wulbkavD5FZZ
 AA49kwKtpxjAdwivLFlSOrG+O5pnN+LxstYydcHsXg==
X-Google-Smtp-Source: ABdhPJx0ZQH+VD+ZyMThZH6pJAH5dliNKcrn86KX8y9RAJDtsJQVBBS5ElKUjCu1XR/RgGug+LADQgGpd2KZUUJ1lsA=
X-Received: by 2002:a81:57c5:0:b0:2d6:eefb:a518 with SMTP id
 l188-20020a8157c5000000b002d6eefba518mr22401412ywb.427.1647304286043; Mon, 14
 Mar 2022 17:31:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com>
 <20220224172559.4170192-10-rananta@google.com>
 <Yi+fNr9w28Nz2j3G@google.com>
In-Reply-To: <Yi+fNr9w28Nz2j3G@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 14 Mar 2022 17:31:14 -0700
Message-ID: <CAJHc60z5cuGHquGa-06=p3SuZrwu1pjh75f1ccHhuCUzvnT5Hg@mail.gmail.com>
Subject: Re: [PATCH v4 09/13] Docs: KVM: Rename psci.rst to hypercalls.rst
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

On Mon, Mar 14, 2022 at 1:02 PM Oliver Upton <oupton@google.com> wrote:
>
> On Thu, Feb 24, 2022 at 05:25:55PM +0000, Raghavendra Rao Ananta wrote:
> > Since the doc now covers more of general hypercalls'
> > details, rather than just PSCI, rename the file to a
> > more appropriate name- hypercalls.rst.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>
> You should move the file before adding to it IMO (switch this patch with
> the previous one).
>
Sure, I can do that.

Regards,
Raghavendra

> Reviewed-by: Oliver Upton <oupton@google.com>
>
> > ---
> >  Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} | 0
> >  1 file changed, 0 insertions(+), 0 deletions(-)
> >  rename Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} (100%)
> >
> > diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/hypercalls.rst
> > similarity index 100%
> > rename from Documentation/virt/kvm/arm/psci.rst
> > rename to Documentation/virt/kvm/arm/hypercalls.rst
> > --
> > 2.35.1.473.g83b2b277ed-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
