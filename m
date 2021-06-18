Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B251C48BDF
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 12:41:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B8E44613EE
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 12:40:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8E44613EE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C6EC4B08F;
	Fri, 18 Jun 2021 08:40:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X9ob6WEonQmP; Fri, 18 Jun 2021 08:40:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23B4F4A7FD;
	Fri, 18 Jun 2021 08:40:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CC414A522
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 08:40:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BElYovXv2vuJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 08:40:51 -0400 (EDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com
 [209.85.208.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4540F49E57
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 08:40:51 -0400 (EDT)
Received: by mail-lj1-f174.google.com with SMTP id u11so2872156ljh.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 05:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=lTCFT34wZQ6wqw0v55S0/U3NKIwHuOeNrXDMYFIV7K4=;
 b=hqTeJJbX7/uWvicwk0W7mO7VWFrxnAtEZEA9wxTwHPUsG1A9GE6o82dwk9h9G/Qg4+
 tYKd8Yc/RVBBDSV4YOARkn59pXkeWoIBpQTaR+GJr4EpTut+8QejHgmDJ9mdfHALLNdm
 CbmWCb4vhJAse6oi6zqqIwNnrz9qd1DuKoGwag6e7fymoju59tKdtWzKrhmrWpDg9tAL
 NcqmF73HloyPFiQuz9dpGEYVCuWOpud4ZHAYI30iVYKmLLiMp7Hijm5qV89/YwIOvMfT
 +caZ7f1zlGSQ0+Ba7zTU66Kw2AJ3u9q03sGTScMiLZkbn2Q6URb0DUR4wk6Ex+Xsx8ES
 tK1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=lTCFT34wZQ6wqw0v55S0/U3NKIwHuOeNrXDMYFIV7K4=;
 b=WKTXInIagrPy7NgR7hvWSti5caq5vR61CVmtvSubA7sdpkAz/v1zM3L5sZn5Qr25rA
 eY8t9Q5aO6oLE/KG96zb3gg1Uf6TGKZQVNF6XVixxh5JPlPXTM4j/xfvY6UkQCASvVdE
 wTPC3DFlEhyLuuratWsC9wQR3ygZWGTAddLQfEClVVfdO9Cmw6lxLhlJ78OQj31dyZra
 KyjGFR3A91ohm5fzbfOVlheGrwY/A7rqZ99LB4+SP6hn/Nb4YPB1kPjWGAp7MZLxNZnH
 yZcina1fUrJSnEuqibwJatozvJ3RyGIaMcfQKEOFZuvlPOrHhRINVfPwBPybWqsxp6uT
 tQVw==
X-Gm-Message-State: AOAM530r0+GfnNSTMkjTl2oH7kC4RdPmOJfiR/pwjEgDtlyiAcf266jb
 Hc0bEto313W0lqI2Mb9x62czMpz8tTalOonAGu9buw==
X-Google-Smtp-Source: ABdhPJzeSWkgT/cK9CFrufOw5F5I/U7jwEyhu1xuazXez4Bg7GmtDJRRX+/TkYXYISNxG1PG5VddP6h2LAZfRaK76Ko=
X-Received: by 2002:a05:651c:150a:: with SMTP id
 e10mr9439436ljf.215.1624020049341; 
 Fri, 18 Jun 2021 05:40:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210618044819.3690166-1-jingzhangos@google.com>
 <20210618044819.3690166-3-jingzhangos@google.com> <YMxDv5BgfdMn2Y9b@kroah.com>
In-Reply-To: <YMxDv5BgfdMn2Y9b@kroah.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Fri, 18 Jun 2021 07:40:37 -0500
Message-ID: <CAAdAUtim1zV=OtHCABYZVy4JnKjJ7+BwihUrTPbc6v4EZ5D4tw@mail.gmail.com>
Subject: Re: [PATCH v11 2/7] KVM: stats: Add fd-based API to read binary stats
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

On Fri, Jun 18, 2021 at 1:57 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> Minor comment nits:
>
> On Fri, Jun 18, 2021 at 04:48:14AM +0000, Jing Zhang wrote:
> > +/*
> > + * Common vm/vcpu stats read function to userspace.
>
> Should you use a real kernel-doc style here?  You almost are, might as
> well do it "right" :)
>
Will fix that.
> > + * @id: identification string of the stats
> > + * @header: stats header for a vm or a vcpu
> > + * @desc: start address of an array of stats descriptors for a vm or a vcpu
> > + * @stats: start address of stats data block for a vm or a vcpu
> > + * @size_stats: the size of stats data block pointed by @stats
> > + * @user_buffer: start address of userspace buffer
> > + * @size: requested read size from userspace
> > + * @offset: the start position from which the content will be read for the
> > + *          corresponding vm or vcp file descriptor
> > + *
> > + * The file content of a vm/vcpu file descriptor is now defined as below:
> > + * +-------------+
> > + * |   Header    |
> > + * +-------------+
> > + * | Descriptors |
> > + * +-------------+
> > + * | Stats Data  |
> > + * +-------------+
>
> Where is the "header id string"?  In the header?
>
Yes, the id string is in the header.
> > + * Although this function allows userspace to read any amount of data (as long
> > + * as in the limit) from any position, the typical usage would follow below
> > + * steps:
> > + * 1. Read header from offset 0. Get the offset of descriptors and stats data
> > + *    and some other necessary information. This is a one-time work for the
> > + *    lifecycle of the corresponding vm/vcpu stats fd.
> > + * 2. Read descriptors from its offset and discover all the stats by parsing
> > + *    descriptors. This is a one-time work for the lifecycle of the
> > + *    corresponding vm/vcpu stats fd.
> > + * 3. Periodically read stats data from its offset.
>
> You forgot "2.5.  rewind fd pointer position", see below...
>
Sure, will clarify that.
> > + */
> > +ssize_t kvm_stats_read(char *id, struct kvm_stats_header *header,
> > +             struct _kvm_stats_desc *desc, void *stats, size_t size_stats,
> > +             char __user *user_buffer, size_t size, loff_t *offset)
> > +{
> > +     ssize_t len;
> > +     ssize_t copylen;
> > +     ssize_t remain = size;
> > +     size_t size_desc;
> > +     size_t size_header;
> > +     void *src;
> > +     loff_t pos = *offset;
> > +     char __user *dest = user_buffer;
> > +
> > +     size_header = sizeof(*header);
> > +     size_desc = header->count * sizeof(*desc);
> > +
> > +     len = KVM_STATS_ID_MAXLEN + size_header + size_desc + size_stats - pos;
> > +     len = min(len, remain);
> > +     if (len <= 0)
> > +             return 0;
> > +     remain = len;
> > +
> > +     /* Copy kvm stats header.
> > +      * The header is the first block of content userspace usually read out.
> > +      * The pos is 0 and the copylen and remain would be the size of header.
> > +      * The copy of the header would be skipped if offset is larger than the
> > +      * size of header. That usually happens when userspace reads stats
> > +      * descriptors and stats data.
> > +      */
>
> Looks like this is the networking "style" of multi-line comments, not
> the rest of the kernel.  You might want to fix this up to be the normal
> style which would be:
>
>         /*
>          * Copy kvm stats header.
>          * The header is the first block of content userspace usually read out.
>          * The pos is 0 and the copylen and remain would be the size of header.
>          * The copy of the header would be skipped if offset is larger than the
>          * size of header. That usually happens when userspace reads stats
>          * descriptors and stats data.
>          */
>
> I do not know how picky the kvm maintainers are about this, that's up to
> them :)
>
>
Will fix it.
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
> > +
> > +     /* Copy kvm stats header id string.
> > +      * The id string is unique for every vm/vcpu, which is stored in kvm
> > +      * and kvm_vcpu structure.
> > +      */
>
> This header too is skipped if necessary, so you should say that as well.
>
>
Sure, will clarify that.
> > +     copylen = size_header + KVM_STATS_ID_MAXLEN - pos;
> > +     copylen = min(copylen, remain);
> > +     if (copylen > 0) {
> > +             src = id + pos - size_header;
> > +             if (copy_to_user(dest, src, copylen))
> > +                     return -EFAULT;
> > +             remain -= copylen;
> > +             pos += copylen;
> > +             dest += copylen;
> > +     }
> > +
> > +     /* Copy kvm stats descriptors.
> > +      * The descriptors copy would be skipped in the typical case that
> > +      * userspace periodically read stats data, since the pos would be
> > +      * greater than the end address of descriptors
> > +      * (header->header.desc_offset + size_desc) causing copylen <= 0.
> > +      */
>
> But you say that it is skipped here.
>
> > +     copylen = header->desc_offset + size_desc - pos;
> > +     copylen = min(copylen, remain);
> > +     if (copylen > 0) {
> > +             src = (void *)desc + pos - header->desc_offset;
> > +             if (copy_to_user(dest, src, copylen))
> > +                     return -EFAULT;
> > +             remain -= copylen;
> > +             pos += copylen;
> > +             dest += copylen;
> > +     }
> > +
> > +     /* Copy kvm stats values */
> > +     copylen = header->data_offset + size_stats - pos;
> > +     copylen = min(copylen, remain);
> > +     if (copylen > 0) {
> > +             src = stats + pos - header->data_offset;
>
> This lets you sync to the end of the header and read just the stats, but
> does that mean that userspace keeps needing to "rewind" back to the end
> of the header to read the stats again?
>
> Or can it just keep reading off the end of the previous read?
>
> It's not quite obvious here, and I mention that above in step "2.5", so
> maybe I am wrong, which is fine, but then I'm confused :)
Userspace needs to rewind back to read the stats again or just use pread
as Paolo mentioned and that's used in the testcase.
>
>
> thanks,
>
> greg k-h
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
