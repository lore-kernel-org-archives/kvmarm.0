Return-Path: <SRS0=srdq=LL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_RED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 255C0C2B9F4
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 14:56:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9881A613E9
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 14:56:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9881A613E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E49774B090;
	Thu, 17 Jun 2021 10:56:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wva1nG33Q+7j; Thu, 17 Jun 2021 10:56:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA1A849E5F;
	Thu, 17 Jun 2021 10:56:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C813940821
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 10:56:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aMRUAqRRPGNf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jun 2021 10:56:25 -0400 (EDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com
 [209.85.208.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89A2D40233
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 10:56:25 -0400 (EDT)
Received: by mail-lj1-f173.google.com with SMTP id c11so9432588ljd.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 07:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=EbTYKOXEoTjmKWk+fpZnI99Si3buCUHA1ir4ZzP+nnI=;
 b=kc50UfvlreBP4U5XFPb9bvzXsic67xc5PlptbeuPCrbP14fhRwj9rOBUGLN6p+dtZX
 SOP1ZY5unyfg5G3JMXQ9hNEF7K9BJdNpysaExPQ4ZGnlcljp5AKYoIS2AnJWN9HA/eWW
 lcShCvH37ITs73OSDSewiBRwVuWFOqCDZuZLvOsSFwyv8XeY/lnBVaai2CWHMzpJ0ZWY
 Y53GpWGGPDQii1rEcnb3vD8rPnS7JYgrBF/1Tz+6xjdeaKCB2GHwPT9jPUZBQxOpU2vJ
 uVx93iAJ9KIPSlbLvTT+iKfClmYBRlq2GejTdrownxtxHdZu6Y8+qgMycGlLKMFEmk5n
 Fe2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=EbTYKOXEoTjmKWk+fpZnI99Si3buCUHA1ir4ZzP+nnI=;
 b=hxF+PDHqioM2/srUXf1scxx5f3LRmJtUtfGCIJ5ihXaNT7Lfwx0Ej8p2oG/0pOvqm0
 0uLxVMDomoO666NsJlTnfE3t1X6onljjXyj3Id17Hgu6Bt5r9yR+A/BW+t8rweqhROPE
 fdEkus/qsNk+1Mtqf4p/CN9xb9JEtZKgRjNBtQl8144Zohz28KP/BwLjoqx2IX/kb2fT
 IKYfy4MOUHUtp0TdqyaRK4EEdiingKZgQ0plDR4B/V2AnjzpRs/MaS+BaZe+IPB2MAKv
 UalOmi7tRpMNX/8IekhTqEJ3FTOvxghmQkw0luh8Q4PBzuBzG8pORh+bP4KvCtQrg1JP
 dJqQ==
X-Gm-Message-State: AOAM533WpSNgsMI1dRydpxEFSpzxMXhWCMcnSTuucF0R5ic3q7IML09q
 mO0MRnBgYPIOGDbW60/YLFZ1lriYAM17zb432+5whA==
X-Google-Smtp-Source: ABdhPJyHZSoRzwk/uvauvQQuu1bVwpP27gPIjPYDoJYNtfXQcbgPRMFOMqegaGb6vFsOuSX995igEG4xKcInEvg9Wdg=
X-Received: by 2002:a2e:9b8f:: with SMTP id z15mr4952786lji.304.1623941783847; 
 Thu, 17 Jun 2021 07:56:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210617044146.2667540-1-jingzhangos@google.com>
 <20210617044146.2667540-3-jingzhangos@google.com> <YMr4rArKvj3obDEM@kroah.com>
In-Reply-To: <YMr4rArKvj3obDEM@kroah.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Thu, 17 Jun 2021 09:56:12 -0500
Message-ID: <CAAdAUtiiQ0304vWR3Zm2XUKz374W4LY3=qdrFZCsQ27VkqMn9A@mail.gmail.com>
Subject: Re: [PATCH v10 2/5] KVM: stats: Add fd-based API to read binary stats
 data
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

On Thu, Jun 17, 2021 at 2:24 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jun 17, 2021 at 04:41:43AM +0000, Jing Zhang wrote:
> > Provides a file descriptor per VM to read VM stats info/data.
> > Provides a file descriptor per vCPU to read vCPU stats info/data.
>
> Shouldn't this be two separate patches, one for each thing as these are
> two different features being added?
>
Actually, it is really not easy to separate this change into two patches even by
following Paolo's suggestion. And it would be a surprise to userspace to see
only VM stats, no VCPU stats.
I guess it is the text that caused the confusion, I'll change the commit message
for this.
> Anyway, an implementation question for both of these:
>
> > +static ssize_t kvm_stats_read(struct _kvm_stats_header *header,
> > +             struct _kvm_stats_desc *desc, void *stats, size_t size_stats,
> > +             char __user *user_buffer, size_t size, loff_t *offset)
> > +{
> > +     ssize_t copylen, len, remain = size;
>
> You are "burying" the fact that remain is initialized here, not nice, I
> totally missed it when reading this the first time.
>
> This should be:
>         ssize_t copylen;
>         ssize_t len;
>         ssize_t remain = size;
> to be obvious.
>
> Remember you will be looking at this code for the next 20 years, make it
> easy to read.
>
Nice! Will do.
> > +     size_t size_header, size_desc;
> > +     loff_t pos = *offset;
> > +     char __user *dest = user_buffer;
> > +     void *src;
> > +
> > +     size_header = sizeof(*header);
> > +     size_desc = header->header.count * sizeof(*desc);
> > +
> > +     len = size_header + size_desc + size_stats - pos;
> > +     len = min(len, remain);
> > +     if (len <= 0)
> > +             return 0;
> > +     remain = len;
> > +
> > +     /* Copy kvm stats header */
> > +     copylen = size_header - pos;
> > +     copylen = min(copylen, remain);
> > +     if (copylen > 0) {
> > +             src = (void *)header + pos;
> > +             if (copy_to_user(dest, src, copylen))
> > +                     return -EFAULT;
> > +             remain -= copylen;
> > +             pos += copylen;
> > +             dest += copylen;
> > +     }
>
> I thought you said that you would not provide the header for each read,
> if you keep reading from the fd.  It looks like you are adding it here
> to each read, or is there some "magic" with pos happening here that I do
> not understand?
>
> And if there is "magic" with pos, you should document it as it's not
> very obvious :)
>
Will do.
> > +     /* Copy kvm stats descriptors */
> > +     copylen = header->header.desc_offset + size_desc - pos;
> > +     copylen = min(copylen, remain);
> > +     if (copylen > 0) {
> > +             src = (void *)desc + pos - header->header.desc_offset;
> > +             if (copy_to_user(dest, src, copylen))
> > +                     return -EFAULT;
> > +             remain -= copylen;
> > +             pos += copylen;
> > +             dest += copylen;
> > +     }
> > +     /* Copy kvm stats values */
>
> New lines between code blocks of doing things?
>
Will add lines between code blocks.
> And again, why copy the decriptor again?  or is it being skipped
> somehow?  Ah, I think I see how it's being skipped, if I look really
> closely.  But again, it's not obvious, and I could be wrong.  Please
> document this REALLY well.
>
> Write code for the developer first, compiler second.  Again, you are
> going to be maintaining it for 20+ years, think of your future self...
>
>
Sure, will document it.
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
> > +
> > +     *offset = pos;
> > +     return len;
> > +}
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
