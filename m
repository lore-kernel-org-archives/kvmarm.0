Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3110AC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 09:28:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC0964B09C;
	Thu, 17 Mar 2022 05:28:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qu44BDeUiJol; Thu, 17 Mar 2022 05:28:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A0704A534;
	Thu, 17 Mar 2022 05:28:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B055404B2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 14:09:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IzBARwleIg4Q for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 14:09:56 -0400 (EDT)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com
 [209.85.219.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 62EA3402A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 14:09:56 -0400 (EDT)
Received: by mail-yb1-f170.google.com with SMTP id v130so5832609ybe.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 11:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=7XMutS1ghlFhAcs8/x/Pe4DRiYkYF5xHdbcHJcH98bI=;
 b=N8TA6UWt/HOTEUiK2WpWKW40MkVKi/M/jIZRss20ZggSq7GJz5XtmemrF++vDpZ813
 HVY1KkL9Dav4FNanRmYAdoNHzAu1hhSfkElr97BrORfOqAILEz3t/M/znBJ60sAXUo0O
 tGqTGc1Xrwtxt8mt2Eysga5G+Swqou1oK3q4q7cvyss/ocyzimgw4ez0YOOOQr9a9/Jt
 dynAZdRFrx1DWJeCwtxC5v5udwc4o/hgHgN7CcUsvOUkE/F8afr2RxZD6ERHo7iHmdc9
 hb4CoWBRf6K2Z9LixnudJLtjOP5o+awJY6SrI+buRJjdPepgL3Qv1OnZk89Uxg9MfMXd
 I1Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=7XMutS1ghlFhAcs8/x/Pe4DRiYkYF5xHdbcHJcH98bI=;
 b=67dzB1dZ6KbheNaWfC3NGa4cnIia02aEM9jXU8Iqp9VsEtaSWfPgNoacdJukk74TL8
 udJyhygXj2HRRDMpdHoZdc96FlOa/PP+UgqBuXqIl4F5OmryO+r5U6s9qn1SjT6uMoCK
 d7oJEYgYkEs8nnyBS9HfpYAvgrCBjUm2mzl3W0H+cWscUh4oylN/ynYeMsWJh9sKdeAD
 n/OXWu1A+PH09hoC10gKtbuqo5YRJvA+FwFErXlQ7lDUo8m6vzRrVtBcvrWi1p4GKGYC
 IcRZzeI7/O5pv8yODdSAu9+jK7BaznMvcuFoaa5Lf9dM4iVqqogiwdEH4k6aIuT7cqRK
 XxXA==
X-Gm-Message-State: AOAM5320x7D4W4kNx9tFUJlURzGyDAxCtTnMhFCZH3q2HyBCt22wQCqp
 dgI68oYkJMMlfWsYSIXb7E2C/DgkId9bWnOyAnxFDQ==
X-Google-Smtp-Source: ABdhPJzKmoZaOsrzO1wchwLd6WsW2qXHfdiZHlUIC3mlysLp2Pr0Fg01zSB0WOL7T6g+DtckFOBF0OW7YHskbDSV6HQ=
X-Received: by 2002:a25:7b85:0:b0:628:beb3:d877 with SMTP id
 w127-20020a257b85000000b00628beb3d877mr1302980ybc.8.1647454195715; Wed, 16
 Mar 2022 11:09:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com>
 <20220311060207.2438667-7-ricarkol@google.com>
In-Reply-To: <20220311060207.2438667-7-ricarkol@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Wed, 16 Mar 2022 12:09:44 -0600
Message-ID: <CANgfPd9d=C65y=hbpcf5y68d=u+p0LTtk3OO+q8reGmjv8TEEg@mail.gmail.com>
Subject: Re: [PATCH 06/11] KVM: selftests: Add missing close and munmap in
 __vm_mem_region_delete
To: Ricardo Koller <ricarkol@google.com>
X-Mailman-Approved-At: Thu, 17 Mar 2022 05:28:50 -0400
Cc: kvm <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>,
 kvmarm@lists.cs.columbia.edu
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

On Fri, Mar 11, 2022 at 12:02 AM Ricardo Koller <ricarkol@google.com> wrote:
>
> Deleting a memslot (when freeing a VM) is not closing the backing fd,
> nor it's unmapping the alias mapping. Fix by adding the missing close
> and munmap.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index ae21564241c8..c25c79f97695 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -702,6 +702,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
>         sparsebit_free(&region->unused_phy_pages);
>         ret = munmap(region->mmap_start, region->mmap_size);
>         TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
> +       if (region->fd >= 0) {
> +       /* There's an extra map if shared memory. */

Nit: indentation

> +               ret = munmap(region->mmap_alias, region->mmap_size);
> +               TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
> +               close(region->fd);
> +       }
>
>         free(region);
>  }
> --
> 2.35.1.723.g4982287a31-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
