Return-Path: <SRS0=ypkC=LK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC74C48BE6
	for <kvmarm@archiver.kernel.org>; Wed, 16 Jun 2021 18:04:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB40161375
	for <kvmarm@archiver.kernel.org>; Wed, 16 Jun 2021 18:04:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB40161375
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3457F40667;
	Wed, 16 Jun 2021 14:04:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wmw6MnSSF2Je; Wed, 16 Jun 2021 14:04:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34AC349DE7;
	Wed, 16 Jun 2021 14:04:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E98B740667
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jun 2021 14:04:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qKiYf33MERoL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Jun 2021 14:04:40 -0400 (EDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com
 [209.85.167.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE0E9402A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jun 2021 14:04:40 -0400 (EDT)
Received: by mail-lf1-f41.google.com with SMTP id a1so5624495lfr.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jun 2021 11:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=QL+p+jTvyBCoLxHGaGA1zRf3kZytampV5ZR7Ur3gf3U=;
 b=fc72JuPUMioH4fKcNp+iPSBFNFwPDf9vgPJdUSG3pw+STeGrnlJ9Ykw74FPB2eMydA
 Sqz9/CE4otVTzoV3HvOTnxoTeIPshc58RynzPKMqktwF+8M37v22nUpbn2fUK4p80EA/
 u+jDv0yLybYMqBYCsGGy1+uAjdoOYIPiVI+GMwvC8MVkrgIbkzWddLjLMtwjfV7JUFlx
 tMRPD64MsgNUMHxn1FEeM87Wj3TDYYrkOaoTd9AAiTHYZ7yBM0mQ9RRNy99pEcalkMNO
 bgUfYhJ4wiiU1aq2mWNaQr4ASs7AcbLZbwp/pDFZNTInyx4sL7X4HU1iZ2JHMIh3xvXt
 NHSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=QL+p+jTvyBCoLxHGaGA1zRf3kZytampV5ZR7Ur3gf3U=;
 b=Kgjg9CIil6HM1FdZuo5UrpqPIq+qn8sZn1UA/vefrrsCKl+9qvQCNG0GolI81a0a+A
 Nf0YjMSwro+dT7kuKkVkzeVdJiiLxMJBjcps0E2bIejMaos3LD14qJv1Ac42piFiDttj
 Idw33q8e2r2sgnZDaiTU3XxRk03ZYMYHZfp6LuRD1Vudf2SakNZsAhHoNmq6Ub7Wpiwz
 KIUrNKxLy0NGTMi/WsIn4RuHnTcyy3/zCnxeBZz/fROYPdFmTzeA5H1bathyAl6BFVSh
 KKZ3nYo6C7ZcrLiN4j794uLWLLU+zhJ+91xIalwM4LgLDpk33xZd1MwHna0d6EOHchI9
 2Pzg==
X-Gm-Message-State: AOAM533KSzzeqsMmRI+1NGZsW6OXbzxnBwx3QhI03wxhq3rT5TezZlce
 S9XJ6iDbUDLrehf41YyZegVa1xEWLwU58psU0HgzQQ==
X-Google-Smtp-Source: ABdhPJy4bQ7Jt4JKRNwI4lBCx0kB2MjipwAUemjUdaMvVbQnSwyfIs30xmfWtPQ46Uafcxy5ggZv35nXlECeV1DCBO4=
X-Received: by 2002:a05:6512:33c4:: with SMTP id
 d4mr713703lfg.536.1623866679050; 
 Wed, 16 Jun 2021 11:04:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210614212155.1670777-1-jingzhangos@google.com>
 <20210614212155.1670777-3-jingzhangos@google.com>
 <60b0d569-e484-f424-722b-eb7ba415e19b@redhat.com>
In-Reply-To: <60b0d569-e484-f424-722b-eb7ba415e19b@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 16 Jun 2021 13:04:28 -0500
Message-ID: <CAAdAUthShFyjhsdAPVhUSf78QsiBCfD1rbcJXhFZ5BsQG2f4Mg@mail.gmail.com>
Subject: Re: [PATCH v9 2/5] KVM: stats: Add fd-based API to read binary stats
 data
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 David Matlack <dmatlack@google.com>, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, LinuxMIPS <linux-mips@vger.kernel.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Wed, Jun 16, 2021 at 12:12 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 14/06/21 23:21, Jing Zhang wrote:
> > +     /* Copy kvm stats values */
> > +     copylen = header->header.data_offset + size_stats - pos;
> > +     copylen = min(copylen, remain);
> > +     if (copylen > 0) {
> > +             src = stats + pos - header->header.data_offset;
> > +             if (copy_to_user(dest, src, copylen))
> > +                     return -EFAULT;
> > +             remain -= copylen;
> > +             pos += copylen;
> > +             dest += copylen;
> > +     }
>
> Hi Jing,
>
> this code is causing usercopy warnings because the statistics are not
> part of the vcpu slab's usercopy region.  You need to move struct
> kvm_vcpu_stat next to struct kvm_vcpu_arch, and adjust the call to
> kmem_cache_create_usercopy in kvm_init.
>
> Can you post a new version of the series, and while you are at it
> explain the rationale for binary stats in the commit message for this
> patch?  This should include:
>
> - the problem statement (e.g. frequency of the accesses)
>
> - what are the benefits compared to debugfs
>
> - why the schema is included in the file descriptor as well
>
> You can probably find a lot or all of the information in my emails from
> the last couple days, but you might also have other breadcrumbs from
> Google's internal implementation of binary stats.
>
> Thanks,
>
> Paolo
>
Hi Paolo

Will fix the usercopy warnings, add more explanations and post another version.
And thanks for all the information in your emails.

Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
