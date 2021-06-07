Return-Path: <SRS0=60kf=LB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B30C47094
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 22:09:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2451C6120F
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 22:09:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2451C6120F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EFCB40878;
	Mon,  7 Jun 2021 18:09:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C3NYUs-YnwkH; Mon,  7 Jun 2021 18:09:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6A6649FE6;
	Mon,  7 Jun 2021 18:09:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65E0540821
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 18:09:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u4GxRPT9j8ka for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Jun 2021 18:09:29 -0400 (EDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com
 [209.85.208.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 375E9402A9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 18:09:29 -0400 (EDT)
Received: by mail-lj1-f178.google.com with SMTP id r16so5109965ljk.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Jun 2021 15:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ojkenvNiiMJ/yZxzALQAvVOssk272sH9CMMN9SkFSfU=;
 b=scorcLCcI0LBPm9wcVnjifV6Rld0kygpxzlM1OlhyCOBjp7hRZWPRWoLugL9M7JlN6
 27upFcxj55TaoHjwekygpXGi7EgWqp03dJui/rRvlhRtHd7CT2LJmbb2S9cXJOUoF2wK
 HgQ8bQnTz02bOyShOhv+PkyZkqLA4NFMd3P6u/V0uLpNyKwi6gRHMFDYdDp9qns4UMhy
 7bOWLJKgGl3+kVvoVw9nwS64ZcBTlGGJ9OQr+72D1/iR/IvBqeJ+t2He3tnmGHM05G8c
 Au5Adr/6UjG/jOCZ0kXQnWekjGDvdHt2G2WJsAuToVcoosz+5ouEDwhzHLTigNvioGp+
 WhcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ojkenvNiiMJ/yZxzALQAvVOssk272sH9CMMN9SkFSfU=;
 b=gn178w6dET1QN0SHO5X9iNvOYcNZYb57Rx57WQ0nbnX4R8TRSeFk8aol0cpQZsqYZv
 Xuy0wfjnEsORbZr6hyWqWyeWBYSW9Slh7HiywkwLIHJFa/UYLj8uWwNH0+99Z45ydyzT
 XsgDp7V945iNpYp/KQuZG27xs+lIBJ1bhEflCseU0RHXlvw20/SUyJGTKVs3J4sRj4MR
 v2ON4pPksrn1mpmWOUrdkzpvVI0v7NWegDIIBI1ZDtP86vAPC+7Y/BTu+vntWyCBtQCK
 1KGgPO3DUs2sTkUBMuEv/eIk1j+F0RvWo2sgMfZUY0nxQEZRQryJ2P3pTfKmSL+Ijhh7
 mbjg==
X-Gm-Message-State: AOAM5319ORYqSeugB4/95WIWkzOcJ+KCuKCLhqzt6UHuPt2gjwtqGzx2
 io9xBYD1aTyiP9cPmq0coW/ApVWxotOszRySUg8S5Q==
X-Google-Smtp-Source: ABdhPJxi6tb2r0pJmMhmi63qDmjwZ/KGdLzNQvJ8mecYi1Lr8qXGOwPWWus419mRjpBfQ3XAPM9Yjn4/oYH83qk0+N8=
X-Received: by 2002:a2e:591:: with SMTP id 139mr16357593ljf.207.1623103767520; 
 Mon, 07 Jun 2021 15:09:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210603211426.790093-1-jingzhangos@google.com>
 <20210603211426.790093-4-jingzhangos@google.com>
 <0431329c-4fda-8011-607d-2ef4a3af9237@oracle.com>
In-Reply-To: <0431329c-4fda-8011-607d-2ef4a3af9237@oracle.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 7 Jun 2021 17:09:15 -0500
Message-ID: <CAAdAUthKv=E+uKzf2sB6_JvEL8dp+rOube-6C-VfrWMOcHTE6g@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] KVM: stats: Add documentation for statistics data
 binary interface
To: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
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

On Mon, Jun 7, 2021 at 2:23 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 6/3/21 2:14 PM, Jing Zhang wrote:
> > Update KVM API documentation for binary statistics.
> >
> > Reviewed-by: David Matlack <dmatlack@google.com>
> > Reviewed-by: Ricardo Koller <ricarkol@google.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >   Documentation/virt/kvm/api.rst | 180 +++++++++++++++++++++++++++++++++
> >   1 file changed, 180 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 7fcb2fd38f42..550bfbdf611b 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -5034,6 +5034,178 @@ see KVM_XEN_VCPU_SET_ATTR above.
> >   The KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST type may not be used
> >   with the KVM_XEN_VCPU_GET_ATTR ioctl.
> >
> > +4.130 KVM_GET_STATS_FD
> > +---------------------
> > +
> > +:Capability: KVM_CAP_STATS_BINARY_FD
> > +:Architectures: all
> > +:Type: vm ioctl, vcpu ioctl
> > +:Parameters: none
> > +:Returns: statistics file descriptor on success, < 0 on error
> > +
> > +Errors:
> > +
> > +  ======     ======================================================
> > +  ENOMEM     if the fd could not be created due to lack of memory
> > +  EMFILE     if the number of opened files exceeds the limit
> > +  ======     ======================================================
> > +
> > +The file descriptor can be used to read VM/vCPU statistics data in binary
> > +format. The file data is organized into three blocks as below:
> > ++-------------+
> > +|   Header    |
> > ++-------------+
> > +| Descriptors |
> > ++-------------+
> > +| Stats Data  |
> > ++-------------+
> > +
> > +The Header block is always at the start of the file. It is only needed to be
> > +read one time for the lifetime of the file descriptor.
> > +It is in the form of ``struct kvm_stats_header`` as below::
> > +
> > +     #define KVM_STATS_ID_MAXLEN             64
> > +
> > +     struct kvm_stats_header {
> > +             char id[KVM_STATS_ID_MAXLEN];
> > +             __u32 name_size;
> > +             __u32 count;
> > +             __u32 desc_offset;
> > +             __u32 data_offset;
> > +     };
> > +
> > +The ``id`` field is identification for the corresponding KVM statistics. For
> > +VM statistics, it is in the form of "kvm-{kvm pid}", like "kvm-12345". For
> > +VCPU statistics, it is in the form of "kvm-{kvm pid}/vcpu-{vcpu id}", like
> > +"kvm-12345/vcpu-12".
>
> Currently, KVM debugfs shows VCPUs as "vcpuXX" where is XX is the id.
> Should we follow the same convention ?
It looks more clear to be like vcpu-xx. Let's keep it this way. Thanks.
> > +
> > +The ``name_size`` field is the size (byte) of the statistics name string
> > +(including trailing '\0') appended to the end of every statistics descriptor.
> > +
> > +The ``count`` field is the number of statistics.
> > +
> > +The ``desc_offset`` field is the offset of the Descriptors block from the start
> > +of the file indicated by the file descriptor.
> > +
> > +The ``data_offset`` field is the offset of the Stats Data block from the start
> > +of the file indicated by the file descriptor.
> > +
> > +The Descriptors block is only needed to be read once for the lifetime of the
> > +file descriptor. It is an array of ``struct kvm_stats_desc`` as shown in
> > +below code block::
> > +
> > +     #define KVM_STATS_TYPE_SHIFT            0
> > +     #define KVM_STATS_TYPE_MASK             (0xF << KVM_STATS_TYPE_SHIFT)
> > +     #define KVM_STATS_TYPE_CUMULATIVE       (0x0 << KVM_STATS_TYPE_SHIFT)
> > +     #define KVM_STATS_TYPE_INSTANT          (0x1 << KVM_STATS_TYPE_SHIFT)
> > +     #define KVM_STATS_TYPE_MAX              KVM_STATS_TYPE_INSTANT
> > +
> > +     #define KVM_STATS_UNIT_SHIFT            4
> > +     #define KVM_STATS_UNIT_MASK             (0xF << KVM_STATS_UNIT_SHIFT)
> > +     #define KVM_STATS_UNIT_NONE             (0x0 << KVM_STATS_UNIT_SHIFT)
> > +     #define KVM_STATS_UNIT_BYTES            (0x1 << KVM_STATS_UNIT_SHIFT)
> > +     #define KVM_STATS_UNIT_SECONDS          (0x2 << KVM_STATS_UNIT_SHIFT)
> > +     #define KVM_STATS_UNIT_CYCLES           (0x3 << KVM_STATS_UNIT_SHIFT)
> > +     #define KVM_STATS_UNIT_MAX              KVM_STATS_UNIT_CYCLES
> > +
> > +     #define KVM_STATS_BASE_SHIFT            8
> > +     #define KVM_STATS_BASE_MASK             (0xF << KVM_STATS_BASE_SHIFT)
> > +     #define KVM_STATS_BASE_POW10            (0x0 << KVM_STATS_BASE_SHIFT)
> > +     #define KVM_STATS_BASE_POW2             (0x1 << KVM_STATS_BASE_SHIFT)
> > +     #define KVM_STATS_BASE_MAX              KVM_STATS_BASE_POW2
> > +
> > +     struct kvm_stats_desc {
> > +             __u32 flags;
> > +             __s16 exponent;
> > +             __u16 size;
> > +             __u32 unused1;
> > +             __u32 unused2;
> > +             char name[0];
> > +     };
> > +
> > +The ``flags`` field contains the type and unit of the statistics data described
> > +by this descriptor. The following flags are supported:
> > +
> > +Bits 0-3 of ``flags`` encode the type:
> > +  * ``KVM_STATS_TYPE_CUMULATIVE``
> > +    The statistics data is cumulative. The value of data can only be increased.
> > +    Most of the counters used in KVM are of this type.
> > +    The corresponding ``count`` filed for this type is always 1.
> > +  * ``KVM_STATS_TYPE_INSTANT``
> > +    The statistics data is instantaneous. Its value can be increased or
> > +    decreased. This type is usually used as a measurement of some resources,
> > +    like the number of dirty pages, the number of large pages, etc.
> > +    The corresponding ``count`` field for this type is always 1.
> > +
> > +Bits 4-7 of ``flags`` encode the unit:
> > +  * ``KVM_STATS_UNIT_NONE``
> > +    There is no unit for the value of statistics data. This usually means that
> > +    the value is a simple counter of an event.
> > +  * ``KVM_STATS_UNIT_BYTES``
> > +    It indicates that the statistics data is used to measure memory size, in the
> > +    unit of Byte, KiByte, MiByte, GiByte, etc. The unit of the data is
> > +    determined by the ``exponent`` field in the descriptor. The
> > +    ``KVM_STATS_BASE_POW2`` flag is valid in this case. The unit of the data is
> > +    determined by ``pow(2, exponent)``. For example, if value is 10,
> > +    ``exponent`` is 20, which means the unit of statistics data is MiByte, we
> > +    can get the statistics data in the unit of Byte by
> > +    ``value * pow(2, exponent) = 10 * pow(2, 20) = 10 MiByte`` which is
> > +    10 * 1024 * 1024 Bytes.
> > +  * ``KVM_STATS_UNIT_SECONDS``
> > +    It indicates that the statistics data is used to measure time/latency, in
> > +    the unit of nanosecond, microsecond, millisecond and second. The unit of the
> > +    data is determined by the ``exponent`` field in the descriptor. The
> > +    ``KVM_STATS_BASE_POW10`` flag is valid in this case. The unit of the data
> > +    is determined by ``pow(10, exponent)``. For example, if value is 2000000,
> > +    ``exponent`` is -6, which means the unit of statistics data is microsecond,
> > +    we can get the statistics data in the unit of second by
> > +    ``value * pow(10, exponent) = 2000000 * pow(10, -6) = 2 seconds``.
> > +  * ``KVM_STATS_UNIT_CYCLES``
> > +    It indicates that the statistics data is used to measure CPU clock cycles.
> > +    The ``KVM_STATS_BASE_POW10`` flag is valid in this case. For example, if
> > +    value is 200, ``exponent`` is 4, we can get the number of CPU clock cycles
> > +    by ``value * pow(10, exponent) = 200 * pow(10, 4) = 2000000``.
> > +
> > +Bits 7-11 of ``flags`` encode the base:
> > +  * ``KVM_STATS_BASE_POW10``
> > +    The scale is based on power of 10. It is used for measurement of time and
> > +    CPU clock cycles.
> > +  * ``KVM_STATS_BASE_POW2``
> > +    The scale is based on power of 2. It is used for measurement of memory size.
> > +
> > +The ``exponent`` field is the scale of corresponding statistics data. For
> > +example, if the unit is ``KVM_STATS_UNIT_BYTES``, the base is
> > +``KVM_STATS_BASE_POW2``, the ``exponent`` is 10, then we know that the real
> > +unit of the statistics data is KBytes a.k.a pow(2, 10) = 1024 bytes.
> > +
> > +The ``size`` field is the number of values of this statistics data. It is in the
> > +unit of ``unsigned long`` for VM or ``__u64`` for VCPU.
> > +
> > +The ``unused1`` and ``unused2`` fields are reserved for future
> > +support for other types of statistics data, like log/linear histogram.
> > +
> > +The ``name`` field points to the name string of the statistics data. The name
> > +string starts at the end of ``struct kvm_stats_desc``.
> > +The maximum length (including trailing '\0') is indicated by ``name_size``
> > +in ``struct kvm_stats_header``.
> > +
> > +The Stats Data block contains an array of data values of type ``struct
> > +kvm_vm_stats_data`` or ``struct kvm_vcpu_stats_data``. It would be read by
> > +user space periodically to pull statistics data.
> > +The order of data value in Stats Data block is the same as the order of
> > +descriptors in Descriptors block.
> > +  * Statistics data for VM::
> > +
> > +     struct kvm_vm_stats_data {
> > +             unsigned long value[0];
> > +     };
> > +
> > +  * Statistics data for VCPU::
> > +
> > +     struct kvm_vcpu_stats_data {
> > +             __u64 value[0];
> > +     };
> > +
> >   5. The kvm_run structure
> >   ========================
> >
> > @@ -6891,3 +7063,11 @@ This capability is always enabled.
> >   This capability indicates that the KVM virtual PTP service is
> >   supported in the host. A VMM can check whether the service is
> >   available to the guest on migration.
> > +
> > +8.33 KVM_CAP_STATS_BINARY_FD
> > +----------------------------
> > +
> > +:Architectures: all
> > +
> > +This capability indicates the feature that user space can create get a file
> > +descriptor for every VM and VCPU to read statistics data in binary format.
>
>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
