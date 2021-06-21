Return-Path: <SRS0=rYk4=LP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC05AC4743C
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 17:47:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4DDE6611CE
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 17:47:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DDE6611CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6A9940667;
	Mon, 21 Jun 2021 13:47:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E9PTKPqWrnQR; Mon, 21 Jun 2021 13:47:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DF764019D;
	Mon, 21 Jun 2021 13:47:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D67A4019D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 13:47:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y4acynXrteaz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Jun 2021 13:46:59 -0400 (EDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
 [209.85.167.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F4B540162
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 13:46:59 -0400 (EDT)
Received: by mail-lf1-f43.google.com with SMTP id h4so31575600lfu.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 10:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=FMJXegssnqpONPLczONIAO8+jgmEKTYKlSdaRff4HUA=;
 b=bNnoexmihOl1CcryhmVv36Rjanlk/iMAQl9bFfd16w6MuIODaXTieL65lPs2H7bZqv
 f4O/tDRcz3FqQQQHU2/x2rEqppsTSRBVDIcu34r6zucvqCEGlw7ds3oDBKxxxd9U3EsL
 2uYRLNUwZ0cRhWENyKTyDpB/KmIUvLAZr8XAid4Q9hSdSFw3/scA7J2S3Kj1NIWtou6Q
 W3DlJBdFka6CzOO2Rk1prqJgmgxeF0x4EwoFNqgNwBklgsMCSt7W/OWl/rvlLreJaSrL
 CN1sbpdr5mYRX+7OaFrBeBrpgv76v9WvPMsA4Y8e5GMCkTOTc0MY/N5AmptXL4pRTLqa
 YU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=FMJXegssnqpONPLczONIAO8+jgmEKTYKlSdaRff4HUA=;
 b=DAhE/WnCoS4kceMpy6v8qK38fEaqOkeOPMGBSfNrPBxCBT2kev5Ai0C7+9aQa19YEi
 E/vDaNmVGvKprpg9hQBGVoDOXsVSzRmbzeGiYlZKgV57jEQ8Ti78sVtbq9sG2iLySIGV
 FBp1rfBfxXmW0QY3Ep3KK2DgpcAi5z9E7R1NsVWY23sMhALp2W30CppihaHcMlMOnJLF
 ymRh+SV65T7LDDPaVdpbWzI29KyxV24F7HisV5Vm2X7TPvw89PH+wnmb0PxUmowCfqXq
 VYrd3Zyn2QHsAq0bDRslhbAgZSnrWTIYgFmulSArDCHgAfuf1PQ5Sf3S2x12qc1R/4v3
 3xAw==
X-Gm-Message-State: AOAM530fiU2KhoVVTuSE0T/EGTO4YNQK2djxhUxs3BBYRMG3FbhDZcZh
 jd2s/ET7WHjtu4dOtQreq/Y9LmXa5NJ8YEIZv/uLxw==
X-Google-Smtp-Source: ABdhPJw5v74BJ4gFYne3uXqh8PwWAuCMlEwFfkqB3Kiz6G0K+WI5o4O+lwaJJg7O9+CNG6Qd/LAnulE6vGeoMEPuXcs=
X-Received: by 2002:a05:6512:3187:: with SMTP id
 i7mr6455431lfe.106.1624297617286; 
 Mon, 21 Jun 2021 10:46:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210618222709.1858088-1-jingzhangos@google.com>
 <20210618222709.1858088-3-jingzhangos@google.com>
 <0cde024e-a234-9a10-5157-d17ba423939e@redhat.com>
In-Reply-To: <0cde024e-a234-9a10-5157-d17ba423939e@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 21 Jun 2021 12:46:46 -0500
Message-ID: <CAAdAUtiL6DwJDWLLmUqct6B6n7Zaa2DyPhpwKZKb=cpRH+8+vQ@mail.gmail.com>
Subject: Re: [PATCH v12 2/7] KVM: stats: Add fd-based API to read binary stats
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
 Greg KH <gregkh@linuxfoundation.org>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Jun 21, 2021 at 11:54 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 19/06/21 00:27, Jing Zhang wrote:
> > +/**
> > + * kvm_stats_read() - Common vm/vcpu stats read function to userspace.
>
> Common function to read from the binary statistics file descriptor.
>
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
> > + * |  id string  |
> > + * +-------------+
> > + * | Descriptors |
> > + * +-------------+
> > + * | Stats Data  |
> > + * +-------------+
> > + * Although this function allows userspace to read any amount of data (as long
> > + * as in the limit) from any position, the typical usage would follow below
> > + * steps:
> > + * 1. Read header from offset 0. Get the offset of descriptors and stats data
> > + *    and some other necessary information. This is a one-time work for the
> > + *    lifecycle of the corresponding vm/vcpu stats fd.
> > + * 2. Read id string from its offset. This is a one-time work for the lifecycle
> > + *    of the corresponding vm/vcpu stats fd.
> > + * 3. Read descriptors from its offset and discover all the stats by parsing
> > + *    descriptors. This is a one-time work for the lifecycle of the
> > + *    corresponding vm/vcpu stats fd.
> > + * 4. Periodically read stats data from its offset using pread.
> > + *
> > + * Return: the number of bytes that has been successfully read
> > + */
> > +ssize_t kvm_stats_read(char *id, const struct kvm_stats_header *header,
> > +                    const struct _kvm_stats_desc *desc,
> > +                    void *stats, size_t size_stats,
> > +                    char __user *user_buffer, size_t size, loff_t *offset)
>
>
> You can replace the header argument with just the number of descriptors,
> and then construct the header in the "if" statement below that copies it
> to userspace:
>
> const struct kvm_stats_header kvm_vm_stats_header = {
>         .name_size = KVM_STATS_NAME_SIZE,
>         .num_desc = num_desc,
The problem is how we calculate the number of descriptors, which needs the
size of the descriptor array for each architecture.
Define another global variable to export the size of descriptor array?
>         .id_offset = size_header,
>         .desc_offset = size_header + KVM_STATS_NAME_SIZE,
>         .data_offset = size_header + KVM_STATS_NAME_SIZE +
>                        size_desc,
> };
>
> Of course size_header can be assigned with sizeof (struct kvm_stats_header).
>
> This removes the definition of the header in each architecture.
>
> Paolo
>
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
> > +     size_desc = header->num_desc * sizeof(*desc);
> > +
> > +     len = KVM_STATS_NAME_SIZE + size_header + size_desc + size_stats - pos;
> > +     len = min(len, remain);
> > +     if (len <= 0)
> > +             return 0;
> > +     remain = len;
> > +
> > +     /*
> > +      * Copy kvm stats header.
> > +      * The header is the first block of content userspace usually read out.
> > +      * The pos is 0 and the copylen and remain would be the size of header.
> > +      * The copy of the header would be skipped if offset is larger than the
> > +      * size of header. That usually happens when userspace reads stats
> > +      * descriptors and stats data.
> > +      */
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
> > +     /*
> > +      * Copy kvm stats header id string.
> > +      * The id string is unique for every vm/vcpu, which is stored in kvm
> > +      * and kvm_vcpu structure.
> > +      * The id string is part of the stat header from the perspective of
> > +      * userspace, it is usually read out together with previous constant
> > +      * header part and could be skipped for later descriptors and stats
> > +      * data readings.
> > +      */
> > +     copylen = size_header + KVM_STATS_NAME_SIZE - pos;
>
> Should use header->id_offset instead of size_header here and in the
> computation of src.
>
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
> > +     /*
> > +      * Copy kvm stats descriptors.
> > +      * The descriptors copy would be skipped in the typical case that
> > +      * userspace periodically read stats data, since the pos would be
> > +      * greater than the end address of descriptors
> > +      * (header->header.desc_offset + size_desc) causing copylen <= 0.
> > +      */
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
Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
