Return-Path: <SRS0=JvcX=7V=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0992EC433E0
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jun 2020 09:36:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5DB6206D5
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jun 2020 09:36:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n69Rj4B3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5DB6206D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E7FF4B1CE;
	Mon,  8 Jun 2020 05:36:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SRub2HGLHBtO; Mon,  8 Jun 2020 05:36:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 417E34B1BA;
	Mon,  8 Jun 2020 05:36:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C60894B1C1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2020 04:57:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 40BTxw75fLLg for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jun 2020 04:57:06 -0400 (EDT)
Received: from mail-io1-f65.google.com (mail-io1-f65.google.com
 [209.85.166.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E14FA4B1BF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2020 04:57:06 -0400 (EDT)
Received: by mail-io1-f65.google.com with SMTP id m81so17745913ioa.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Jun 2020 01:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=dl5xv/IGmW59O6enCMfcyhbX0k4Cox4q6lQplQWI50g=;
 b=n69Rj4B317q2AUkFxmxxCNdE3kD8/kgP//csqFWYb9IxlektA3qJLb4csUHzN4Fl8y
 ivL16ciXx349vbCQZrEMphHtlcbJhKgT+WhtCA5zhYOwtHbhwhbKfz8hJgAuXmfwGBMI
 lHPk7EDSgfwr1fd45vQJ0S22yScT0iaSX+RSzdjB3oRkMMUjC6GPDTBD98pV+ws2GRIj
 M4iE/ZZKSMW8pIaaGox0gwC+xA5qMBAHAXCHldJvqPjqBfikj+7cM9KCYtQaxCT29K5c
 XqqXB2VvOI0boHGZ2KbezKV2THiExcTvbSfxJx2gyqKEDQZvFA3J4KaZgqDULPn9HkEZ
 fjSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=dl5xv/IGmW59O6enCMfcyhbX0k4Cox4q6lQplQWI50g=;
 b=WJ+Nu3vAg/sQyMpJeaZgUHvJ0Puj8NgBjh/uqIrHmZJqVGMhdS4JCgOjgv1A9vPpEH
 hrYNTmrGI2GsZDzIF/squhR9OASIyBPLjQyCJfbxgVzeGj6VnVRSvgIuSY9RbmHA6uym
 YH/+NI8IeI8P8/Ifr0NO9Ezqr2C0+QILSs0zId/3A6WpN3qU1MJuTvTZVo3pef08t4Lv
 9UJqZiXWcf9EfRtTE5tJOk4auxLFVNVO5Te3wBvrGJV9SDMmsK8aCXEhlHmEnIRqmqS1
 lsaCwSEjPwpxkd6DsHx0pS3xkNfipRQRtkga3ppyeOnuYyu24KgGza4TFbiolssq//ve
 QCUw==
X-Gm-Message-State: AOAM533Wu6zIAfTTnUwu26dlCslLzvWEn027M57b2qTsV53Ypu4nSlXM
 DjJWgsggpBJ0zaZhlC1e96scN8XK0MkyDAVaCQM=
X-Google-Smtp-Source: ABdhPJyqapi7KbQS7kw+93/4pmWdcph1yT6gP2ngPU+7u2tF0I6b3vpCSASJKLF1zq7aDFqM5yDJCLKmeao6ImlWGzc=
X-Received: by 2002:a05:6638:dd3:: with SMTP id
 m19mr21525269jaj.106.1591606626515; 
 Mon, 08 Jun 2020 01:57:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-21-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-21-sean.j.christopherson@intel.com>
From: Huacai Chen <chenhuacai@gmail.com>
Date: Mon, 8 Jun 2020 16:56:55 +0800
Message-ID: <CAAhV-H6eyj2ihKAygqkCvgfCnBnAhx7Eu6Vooh2FHqQdRcdhrA@mail.gmail.com>
Subject: Re: [PATCH 20/21] KVM: MIPS: Account pages used for GPA page tables
To: Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailman-Approved-At: Mon, 08 Jun 2020 05:36:10 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
 David Hildenbrand <david@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>, Ben Gardon <bgardon@google.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 Junaid Shahid <junaids@google.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, "open list:MIPS" <linux-mips@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Peter Feiner <pfeiner@google.com>
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

Reviewed-by: Huacai Chen <chenhc@lemote.com>

On Sat, Jun 6, 2020 at 5:40 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Use GFP_KERNEL_ACCOUNT instead of GFP_KERNEL when allocating pages for
> the the GPA page tables.  The primary motivation for accounting the
> allocations is to align with the common KVM memory cache helpers in
> preparation for moving to the common implementation in a future patch.
> The actual accounting is a bonus side effect.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/mips/kvm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
> index 94562c54b930..41a4a063a730 100644
> --- a/arch/mips/kvm/mmu.c
> +++ b/arch/mips/kvm/mmu.c
> @@ -32,7 +32,7 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, int min)
>         if (cache->nobjs >= min)
>                 return 0;
>         while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> -               page = (void *)__get_free_page(GFP_KERNEL);
> +               page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
>                 if (!page)
>                         return -ENOMEM;
>                 cache->objects[cache->nobjs++] = page;
> --
> 2.26.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
