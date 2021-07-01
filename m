Return-Path: <SRS0=4KxT=LZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B8D3C11F64
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 13:45:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 577EF61422
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 13:45:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 577EF61422
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA4E94A4BE;
	Thu,  1 Jul 2021 09:45:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fXo1SU4Bb7ZL; Thu,  1 Jul 2021 09:45:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC1834A483;
	Thu,  1 Jul 2021 09:45:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D0094A483
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 09:45:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kGmfHMdZ8HxT for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jul 2021 09:45:27 -0400 (EDT)
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com
 [209.85.210.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 311AD40CC5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 09:45:27 -0400 (EDT)
Received: by mail-ot1-f45.google.com with SMTP id
 n99-20020a9d206c0000b029045d4f996e62so6555815ota.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Jul 2021 06:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=3Z3Ky60fuRUeEkGom9Yl2zloU6rr5fasjCslnLTq5J4=;
 b=h1FHCJUTz+cPJ99ikqnWnu26wAhDi9Pbj2yi2ayDZV8XMkma6MQmm1iJ1OfkLzQrXa
 s5vBTY5sOM3h7IYkT+9aN9odhxcQqU/WjX9wH1rSGjswAXS2yGBj1/V4Le1bIYfGzIP8
 GB3QWd2YPXBm4mhdC7uFzRXGV7BIv6cGzzQARDWby9RfgrAQ9GfuGYLENR65ZlArlxGe
 sPzzTVQBS2Dgh5WIyzqCHF7hazDhs1V/KKprP8FODoL+Z4SgzHINpIca+4jAfnccHvGL
 jezzJBTipS2zc1gyrEhz6lmv9r9GdVsSHfXL9DzEnqZr6/IxlIM9FYXz4FkPxm5tI98n
 +J4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=3Z3Ky60fuRUeEkGom9Yl2zloU6rr5fasjCslnLTq5J4=;
 b=TDcnexy4qMAcibfXx7FecIfbxaYkkAarjjOzbrA/e9fWqza7PFMKH65VIPOx1l+N6c
 ByNoVzDZS7BEihgXd0FXVFlrcREkVrihdx9ZvTCc8Ikyjoh6/o+FLfFckgK/ZdUZ45Bf
 7y5LxVVwLUemP+RpulhSIg4UsDjWYXVtH81s4zfOmVACShI2/KY8P89KaFiAUYi4g4fA
 M/UunHYBapJsPRGPerfMVL81EgfmxPifYhFayzeLy021AfuRO+F6l5AordQwSXw+PWcA
 Lv/1Re+JOd79+ZEhUTG9u06uoI1snmSoQOFW8N8OymirlGi05vJarGmbeSW2XgJQ/TUr
 UTYA==
X-Gm-Message-State: AOAM5314N7Q2NlII0Vq/uyCgZP8WgCdzR5e/ZRftwRm7iMBW3nj/cHZ4
 d3JJCxDiO3wYBeXrFiTMW49o/LdoYvf/n/vlQir1gA==
X-Google-Smtp-Source: ABdhPJzeim6ujWY7qJh+wtQAcoH/aBYP+t9YLKycAH2wxkD4xqTn7Nen+pj2ik7IL4o31/4yRywN6rMyo9yoBfWXbvM=
X-Received: by 2002:a05:6830:1de2:: with SMTP id
 b2mr30219otj.365.1625147126448; 
 Thu, 01 Jul 2021 06:45:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-4-tabba@google.com>
 <20210701130149.GC9757@willie-the-truck>
In-Reply-To: <20210701130149.GC9757@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 1 Jul 2021 14:44:50 +0100
Message-ID: <CA+EHjTxmmLtGgSm6XOe9PL7S5hkjuzeW6VSzQbhR1wT5RWi7WQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/13] KVM: arm64: Fix names of config register fields
To: Will Deacon <will@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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

Hi Will,

On Thu, Jul 1, 2021 at 2:01 PM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Jun 15, 2021 at 02:39:40PM +0100, Fuad Tabba wrote:
> > Change the names of hcr_el2 register fields to match the Arm
> > Architecture Reference Manual. Easier for cross-referencing and
> > for grepping.
> >
> > Also, change the name of CPTR_EL2_RES1 to CPTR_NVHE_EL2_RES1,
> > because res1 bits are different for VHE.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_arm.h | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > index 25d8a61888e4..bee1ba6773fb 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -31,9 +31,9 @@
> >  #define HCR_TVM              (UL(1) << 26)
> >  #define HCR_TTLB     (UL(1) << 25)
> >  #define HCR_TPU              (UL(1) << 24)
> > -#define HCR_TPC              (UL(1) << 23)
> > +#define HCR_TPCP     (UL(1) << 23)
>
> This one is a bit weird: the field is called TPCP if the CPU supports
> FEAT_DPB but is called TPC otherwise! So I don't think renaming it like
> this really makes anything better. Perhaps add a comment:
>
>   #define HCR_TPC       (UL(1) << 23)   /* TPCP if FEAT_DPB */

I missed that. That's why it's referred to as Bit[23] in the diagram.
I'll add the comment and revert its name.

Thanks,
/fuad

> ?
>
> Rest of the patch looks good:
>
> Acked-by: Will Deacon <will@kernel.org>
>
> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
