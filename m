Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D5D9C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 14:16:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD52F40DAE;
	Thu, 16 Jun 2022 10:16:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gN-gG6XdvnuL; Thu, 16 Jun 2022 10:16:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 778634B0E6;
	Thu, 16 Jun 2022 10:16:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 103DE4B0BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 10:16:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id moPhliL-6Awb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 10:16:50 -0400 (EDT)
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com
 [209.85.222.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B701B40DAE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 10:16:50 -0400 (EDT)
Received: by mail-qk1-f170.google.com with SMTP id n197so1084111qke.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 07:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=xK2ZxjXv0fKdncHUmHdg0o8YzJkoROi9Gw3+1a0UQp4=;
 b=RqnV5e0T7D0gcUByoc8bhlzRUFw7YFnDowWByJRZLYppZEMjjZ+IOmCk1fGnMt+j7W
 3MtQskdKNmOjyb8ZHwC5Cjh2TQl73cLRFIGOXuttwocoVyX75X1c0nbwezlpoYEErXbm
 nMAcpk0L+zj7kXX4Tm2xmbo0bJnLNjQ8EpeYtL76zrgvjfFPf6a3xS++bJl6kzY3lAma
 7oG5+PEAbZ9E2Rr4tN/F0j1hu6G5GQG+/KN155Pa0dACHHu4n6hoN7l2KBHjiNLYi0Ix
 1u0S/N+LsCOknSFJRWqW4LSxRYPoJQnrtUbX8zz8d1Z+HdhTA81bUtf+EYucn3VkElhb
 pCpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=xK2ZxjXv0fKdncHUmHdg0o8YzJkoROi9Gw3+1a0UQp4=;
 b=7Fh9MEza1oJxXbW5y1lAZasjgjWEgWzeUYUFqWSD+9gZMx8yB0So556khpwUDYTnjN
 erjodQ5CtmwQ7+UfTDugjtyZNdQoIIUoz3Z0SWkphKbaow5SU/aJ1yRP+OOHubrLeWIi
 hKJsxyTjPeZS9ZuclPQ32ljUpg4iupmji7Z255OU1+Dc7DB+mQlYKQwe6ZJMJ0snS1/g
 XpsLBPbPebLymhen9clD0r3mVwzjadYn18x88GTjJZFvltoQwYoG4kVJb1dOhLBgqI6i
 HppNDYHwlD/XzvQe3KOnlFkwk9y6+85vWZKCzyOcFv0gHoJYVNJsNy4y20oR0zmHav5P
 ra0A==
X-Gm-Message-State: AJIora//G1q3h0TIbIY+dOw/VLZ2TE6zGRRtaiCe5GaGHaOncs2xD674
 ooijie3xrnLaNt0yn7DCC+er9wqV5OlhtMz8UWklnA==
X-Google-Smtp-Source: AGRyM1u+IP7jfHy5tTqPnnYf+ncMybAdBIu2OCE4ao6+C6xbVgm2BHw79V6SIwoL2RnspXoPc0IbgYLIf6VIIyl8p2k=
X-Received: by 2002:a05:620a:29c7:b0:6a7:4252:2607 with SMTP id
 s7-20020a05620a29c700b006a742522607mr3684714qkp.115.1655389009870; Thu, 16
 Jun 2022 07:16:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220616085318.1303657-1-maz@kernel.org>
In-Reply-To: <20220616085318.1303657-1-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Thu, 16 Jun 2022 09:16:39 -0500
Message-ID: <CAOQ_Qsh9QmHrSMVNwXUUCi9UX5CA8K42Pg1T2eiUSiX5LeAibQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Add Oliver as a reviewer
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thu, Jun 16, 2022 at 3:53 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Oliver Upton has agreed to help with reviewing the KVM/arm64
> patches, and has been doing so for a while now, so adding him
> as to the reviewer list.
>
> Note that Oliver is using a different email address for this
> purpose, rather than the one his been using for his other
> contributions.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

To close the loop that I am signing up for this and I own the inbox :)

Acked-by: Oliver Upton <oupton@google.com>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a6d3bd9d2a8d..7192d1277558 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10821,6 +10821,7 @@ M:      Marc Zyngier <maz@kernel.org>
>  R:     James Morse <james.morse@arm.com>
>  R:     Alexandru Elisei <alexandru.elisei@arm.com>
>  R:     Suzuki K Poulose <suzuki.poulose@arm.com>
> +R:     Oliver Upton <oliver.upton@linux.dev>
>  L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  L:     kvmarm@lists.cs.columbia.edu (moderated for non-subscribers)
>  S:     Maintained
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
