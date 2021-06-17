Return-Path: <SRS0=srdq=LL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_RED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284DDC49EA2
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 15:09:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 904E0613EA
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 15:09:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 904E0613EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01F6D4B08C;
	Thu, 17 Jun 2021 11:09:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JG5IQi7z4g9j; Thu, 17 Jun 2021 11:09:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD24649F92;
	Thu, 17 Jun 2021 11:09:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A59A44086A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 11:09:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p2NnnYpQFPX6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jun 2021 11:09:40 -0400 (EDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com
 [209.85.167.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9960C40821
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 11:09:40 -0400 (EDT)
Received: by mail-lf1-f52.google.com with SMTP id p7so11039791lfg.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 08:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=xXZRhEcd2Cbrj/tVl2ryBxrcp7ZNIEiNaJWzDG2F5Kg=;
 b=TqWgVeNXToRFcCgGFrlG52MtXOvoEpEgH+psGbhdraIxWdvhr8qhRpfWoVKcSxORjB
 B831vy6R7RTZzs2nM/KQJ71iM9aVLCvGMf20DJUF4AiJWHbwKHIT31rxxZUeXh2p2oRt
 XL4KPiTOT9hbUZgUJfDFuKG7oGbFDKYHU8SCBYWaX0RmwnVcF135fDTnUplDx6/kg56A
 WtUBi4LRlBK+S9bbzajtt7FAUOTE3fofCi+CtbjwZsPln+zjbIngScXUpHx9H35LbAYv
 yhbCZ2245i7w4fll7tlZ0JTQLXy7oTYwQOusiRyXIwwEXch8Jc2WjtK44ttM+hrJsoLv
 Zk4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=xXZRhEcd2Cbrj/tVl2ryBxrcp7ZNIEiNaJWzDG2F5Kg=;
 b=i+0UmtD7R102eyaooMYP6EGGHts3tLRnDGkLutmaUSoUaWIpjMSD17ZvIusHZzZF9U
 YBA98u2lqki8+FeOgrIfJb3vrugU53hZery62Dt32u9LqKHdHU5VdLTAH4+jFtMiDEQD
 VQcpLA00gQqIpk9hu9VtXvU//iCvY0FXkWbNUsHiiPxTfo8ZYvRlN048ySHSaJ3Bcx2V
 HnO/dtIyXIwxvMS2y9iqFSUMTgQg4dKDvJYazYXWbLz3Pvi6ExYAM8OLxVSoI7EAKu+s
 j3PAwsmDG5Wq+5tJYFNBd41yhJME8Wj6MOLI1oc61IHIcC4F+++lMeZ56JQZytKH1DlH
 Vs/g==
X-Gm-Message-State: AOAM531Th6jnuXQ3G2s7gnvfRkzCZsMfau6/gNMAGgST8P19zkNxBcQ3
 +q4PqrOa7xvE6UiHTH/Kx8UUu7Rp2TZptP+DEPJFpw==
X-Google-Smtp-Source: ABdhPJzAyrQsMnAqbBOEYMZVZQD5qO0SZlAXpM63+DpcX+GVx2elMNK7wl3R9skQOGetSMH5r+n7sJJM07csoEf6gTw=
X-Received: by 2002:a05:6512:33c4:: with SMTP id
 d4mr4587741lfg.536.1623942578963; 
 Thu, 17 Jun 2021 08:09:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210617044146.2667540-1-jingzhangos@google.com>
 <20210617044146.2667540-4-jingzhangos@google.com> <YMrjKhV8TNwmRtf6@kroah.com>
In-Reply-To: <YMrjKhV8TNwmRtf6@kroah.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Thu, 17 Jun 2021 10:09:27 -0500
Message-ID: <CAAdAUtiySqu6VKpK2LDnG5S0m9tRKjrKSu5BWoFurkhWay4yCg@mail.gmail.com>
Subject: Re: [PATCH v10 3/5] KVM: stats: Add documentation for binary
 statistics interface
To: Greg KH <gregkh@linuxfoundation.org>
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
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

Hi Greg,

On Thu, Jun 17, 2021 at 12:52 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jun 17, 2021 at 04:41:44AM +0000, Jing Zhang wrote:
> > +     struct kvm_stats_desc {
> > +             __u32 flags;
> > +             __s16 exponent;
> > +             __u16 size;
> > +             __u32 offset;
> > +             __u32 unused;
> > +             char name[0];
> > +     };
> > +
> > +The ``flags`` field contains the type and unit of the statistics data described
> > +by this descriptor. The following flags are supported:
> > +
> > +Bits 0-3 of ``flags`` encode the type:
>
> <snip>
>
> As flags is a bit field, what is the endian of it?  Native or LE or BE?
> I'm guessing "cpu native", but you should be explicit as userspace will
> have to deal with this somehow.
Sure, will add clarification for endianness.
>
> thanks,
>
> greg k-h

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
