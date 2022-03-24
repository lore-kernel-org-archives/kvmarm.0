Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0352C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 25 Mar 2022 11:16:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 342194B177;
	Fri, 25 Mar 2022 07:16:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V6fJ3-RhKLJg; Fri, 25 Mar 2022 07:16:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF2494B137;
	Fri, 25 Mar 2022 07:16:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 658EC4B0DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 13:04:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qonu-lf4yVBV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2022 13:04:41 -0400 (EDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com
 [209.85.219.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F3594B086
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 13:04:41 -0400 (EDT)
Received: by mail-yb1-f175.google.com with SMTP id o5so9580625ybe.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 10:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=2oWKmkfOWvxUnDra7Y+PB5WR2ZpUOaT3XNR+3ADMGVQ=;
 b=AjhT77S4UyfQs2EucIciQpHpbBjbeMDxGx4qyANZJ9f5UjGs+Vq3pEDBSVwSeVOEyc
 xy/cE1twoFjLoMS1Yl8/JAlnvbpxCve3OeNFLBA43TFtauWRAFVdwbbv1FOjKVzIlLGV
 SFkWwPUFuPoX+qzDS7lhFFT8O9E7bM2xMabmHtESeY1yOzJs8k73gc5/h1o32JTltPJt
 rn1X6IwSmldaBzp5F+1nOduB2HPA6RWJiTRHcQwvPJBWJTObtj+dCYBPal+PG43ELNI6
 pn0nK5b5Mf3qbUNAOsjUvxQFNIeBzdy+b8xyuavsrwL9FzngmUNbWBAfsvtHRMKWF3Ok
 e+Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=2oWKmkfOWvxUnDra7Y+PB5WR2ZpUOaT3XNR+3ADMGVQ=;
 b=ZqS90nrn6EkPkTJ7YQdbALdpcPouDM8zItkFNhRzGGEd6BIbOvr9nUJ1Twr2gkb5eP
 O5trfuf5oLak2DvqNnGS+psbOZNyKCdwK1XDjcginWp26+x8W6r6vOyVkvlsUnrpQKLD
 prvoI/Y4tQZ54eoGioBwF7ezf0PB8QFhSV68YZi6NLCZzrCjPe8eS4Yxc1hldMkGyTPk
 ntf9HqcHX5XHPkJfVUlRKwDfq4mKfZ/n+85WzakEOD+yKt0QUFc3aXp2aySemcHLni8C
 QGisSYzgKAsVC5hjkX9zuxNrD+yLpk6iF3PFJziG8m28pZ8ihADQkgjn6s24yNMtuNmh
 TyvQ==
X-Gm-Message-State: AOAM531kI0hJgdYzYnvWwW5a0HCRTaZTCpyTe/mqadSm4fRPhfU8KGD3
 A7sBM0o0FR3fI5yCuVlW1wRzfjnylwF2ajbz/v0cLg==
X-Google-Smtp-Source: ABdhPJx4QO2adUVPIQLJqcmbG3j2RaYOsBWpQ8MyrkefRdlsvv2nPVXBlAAhccFX7iodZ0q091RZshB2aAGcnPm0HSU=
X-Received: by 2002:a25:2449:0:b0:633:c9aa:b9de with SMTP id
 k70-20020a252449000000b00633c9aab9demr5322435ybk.255.1648141480639; Thu, 24
 Mar 2022 10:04:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220323225405.267155-1-ricarkol@google.com>
 <20220323225405.267155-6-ricarkol@google.com>
In-Reply-To: <20220323225405.267155-6-ricarkol@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Thu, 24 Mar 2022 10:04:29 -0700
Message-ID: <CANgfPd-YQ9PRpp0py3_oM6FUzgd4wbf9y_Wz0Go-GxFUEi9hSw@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] KVM: selftests: Add missing close and munmap in
 __vm_mem_region_delete
To: Ricardo Koller <ricarkol@google.com>
X-Mailman-Approved-At: Fri, 25 Mar 2022 07:16:15 -0400
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

On Wed, Mar 23, 2022 at 3:54 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> Deleting a memslot (when freeing a VM) is not closing the backing fd,
> nor it's unmapping the alias mapping. Fix by adding the missing close
> and munmap.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index e18f1c93e4b4..268ad3d75fe2 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -679,6 +679,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
>         sparsebit_free(&region->unused_phy_pages);
>         ret = munmap(region->mmap_start, region->mmap_size);
>         TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
> +       if (region->fd >= 0) {
> +               /* There's an extra map shen using shared memory. */
> +               ret = munmap(region->mmap_alias, region->mmap_size);
> +               TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
> +               close(region->fd);
> +       }
>
>         free(region);
>  }
> --
> 2.35.1.894.gb6a874cedc-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
