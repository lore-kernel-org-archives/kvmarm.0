Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B58DC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 19:36:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6ACF664FCC
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 19:36:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6ACF664FCC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E624A4B55E;
	Wed, 10 Mar 2021 14:36:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eu7nt9GdR4p8; Wed, 10 Mar 2021 14:36:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DAA54B577;
	Wed, 10 Mar 2021 14:36:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A034F4B55E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 14:36:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Uwes03lEMUkN for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 14:36:51 -0500 (EST)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com
 [209.85.208.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 24CE34B53D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 14:36:51 -0500 (EST)
Received: by mail-lj1-f180.google.com with SMTP id k12so27131167ljg.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 11:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=OvV6VLMTy2cQ72nIiRt8RKCJxHSvSwTj/dq7tmzrgvY=;
 b=ZsbKSq4Hp4ZcA3sY0++kdfFmm1N/pCis9Pxoe36/SvHvxeN8g8nz3mLZqj8PgOGJlJ
 AmiGQ2ahKV6rvITVB8x3LSyXi1WUyjpux1trLHntjrNGcCiXZ4i2UE95lLygkp7qKCtu
 Qj4Gb6hi0F89tYy2eGuoOpha3CqmaijvEZ0xdSsT/LMTLaLMxFvy2oCc9xa/1/oJ/u7E
 i67+1G4tyuE18oo5vb7LvtUVXIrIRv8fyNqARwrw30qI1hPitpRCmRvgMUU73g303WsB
 DIsv1FLaT/uu2Y1u07cn3nhUxsynTGlUGmhCpFrzetUBAE0gh3dY0/dFHt9QVJt1SZnS
 bFAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=OvV6VLMTy2cQ72nIiRt8RKCJxHSvSwTj/dq7tmzrgvY=;
 b=H0IHDAPZdbTCPug5/6OQYr+2L8V2XsIgXzh2W10IOYXG7E82QvGhn7qddXDovL+/O5
 GSYOz0MNSnBDLwOsTG6KvRG4AWfIxd9T0GmYmVU41PJ8ZSLJeMxMhJeSDEp87z/hsoRC
 bFAJhP0YIplp03tRj5hph+NT5a8gV/2XXeK6E8Ep+qHc706feLUdH9V2rGsP2L0LO85i
 ATkD2w5HNWWx1TEElVZ6gB37cTpPGI36czMnfTX+xUKrlaw7NOQPoUcbjTSJjBEMvlcv
 tNtBsCSOiBJwRKtFbSqwq1XkJtGUb0WZCW671GEogdaNf1vyQRhfWc07vkjscA/Np6ea
 rJKA==
X-Gm-Message-State: AOAM5307DKPvLkpTrxg+oznro9wnE110JsRGTtl4H7k3HX0o3idz4x3v
 i+/tyqZ0969I7oBx7CD6e+riKhXXN0tfVlKBl5HflQ==
X-Google-Smtp-Source: ABdhPJyi0EpYoQZeT12rvgt0ivdWvKvDg/Zfay6Zmq8jyRfkRgKS6lxf3OCYRlLodZpCnDNaNpzM1Yr7crDfQVFeizw=
X-Received: by 2002:a2e:8e75:: with SMTP id t21mr2724430ljk.216.1615405009536; 
 Wed, 10 Mar 2021 11:36:49 -0800 (PST)
MIME-Version: 1.0
References: <20210310003024.2026253-1-jingzhangos@google.com>
 <20210310003024.2026253-3-jingzhangos@google.com>
 <877dmfxdgp.wl-maz@kernel.org>
In-Reply-To: <877dmfxdgp.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 10 Mar 2021 13:36:38 -0600
Message-ID: <CAAdAUthRp-6v9eOkf0nJp0GFXmyB0PeQe2cWp1Sb1W0k68k1SQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] KVM: stats: Define APIs for aggregated stats
 retrieval in binary format
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linux kselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVM ARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 Linux S390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Oliver Upton <oupton@google.com>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVM PPC <kvm-ppc@vger.kernel.org>,
 Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, Linux MIPS <linux-mips@vger.kernel.org>,
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

Hi Marc,

On Wed, Mar 10, 2021 at 8:58 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 10 Mar 2021 00:30:22 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Define ioctl commands for VM/vCPU aggregated statistics data retrieval
> > in binary format and update corresponding API documentation.
> >
> > The capability and ioctl are not enabled for now.
> > No functional change intended.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 79 ++++++++++++++++++++++++++++++++++
> >  include/linux/kvm_host.h       |  1 -
> >  include/uapi/linux/kvm.h       | 60 ++++++++++++++++++++++++++
> >  3 files changed, 139 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 1a2b5210cdbf..aa4b5270c966 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -4938,6 +4938,76 @@ see KVM_XEN_VCPU_SET_ATTR above.
> >  The KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST type may not be used
> >  with the KVM_XEN_VCPU_GET_ATTR ioctl.
> >
> > +4.131 KVM_STATS_GET_INFO
> > +------------------------
> > +
> > +:Capability: KVM_CAP_STATS_BINARY_FORM
> > +:Architectures: all
> > +:Type: vm ioctl, vcpu ioctl
> > +:Parameters: struct kvm_stats_info (out)
> > +:Returns: 0 on success, < 0 on error
>
>
> Missing description of the errors (this is throughout the document).
Will add errors description.
>
> > +
> > +::
> > +
> > +  struct kvm_stats_info {
> > +        __u32 num_stats;
> > +  };
> > +
> > +This ioctl is used to get the information about VM or vCPU statistics data.
> > +The number of statistics data would be returned in field num_stats in
> > +struct kvm_stats_info. This ioctl only needs to be called once on running
> > +VMs on the same architecture.
>
> Is this allowed to be variable across VMs? Or is that a constant for a
> given host system boot?
It is a constant for a given host system boot.
>
> Given that this returns a single field, is there any value in copying
> this structure across? Could it be returned by the ioctl itself
> instead, at the expense of only being a 31bit value?
It is done in this way for potential information we need in the future.
One candidate is the length of stats names. I am considering to return
the length of name string in this info structure instead of as a constant
exported by uapi, which would be more flexible and put no limit on the
length of stats names.
>
> > +
> > +4.132 KVM_STATS_GET_NAMES
> > +-------------------------
> > +
> > +:Capability: KVM_CAP_STATS_BINARY_FORM
> > +:Architectures: all
> > +:Type: vm ioctl, vcpu ioctl
> > +:Parameters: struct kvm_stats_names (in/out)
> > +:Returns: 0 on success, < 0 on error
> > +
> > +::
> > +
> > +  #define KVM_STATS_NAME_LEN         32
> > +  struct kvm_stats_names {
> > +     __u32 size;
> > +     __u8  names[0];
> > +  };
> > +
> > +This ioctl is used to get the string names of all the statistics data for VM
> > +or vCPU. Users must use KVM_STATS_GET_INFO to find the number of statistics.
> > +They must allocate a buffer of the size num_stats * KVM_STATS_NAME_LEN
> > +immediately following struct kvm_stats_names. The size field of kvm_stats_name
> > +must contain the buffer size as an input.
>
> What is the unit for the buffer size? bytes? or number of "names"?
The unit for the buffer size is bytes. Will clearly indicate the unit.
>
> > +The buffer can be treated like a string array, each name string is null-padded
> > +to a size of KVM_STATS_NAME_LEN;
>
> Is this allowed to query fewer strings than described by
> kvm_stats_info? If it isn't, I question the need for the "size"
> field. Either there is enough space in the buffer passed by userspace,
> or -EFAULT is returned.
It isn't. Will remove the size field.
>
> > +This ioclt only needs to be called once on running VMs on the same architecture.
>
> Same question about the immutability of these names.
The names are immutable for a given system boot.
>
> > +
> > +4.133 KVM_STATS_GET_DATA
> > +-------------------------
> > +
> > +:Capability: KVM_CAP_STATS_BINARY_FORM
> > +:Architectures: all
> > +:Type: vm ioctl, vcpu ioctl
> > +:Parameters: struct kvm_stats_data (in/out)
> > +:Returns: 0 on success, < 0 on error
> > +
> > +::
> > +
> > +  struct kvm_stats_data {
> > +     __u32 size;
>
> Same question about the actual need for this field.
Will remove size field.
>
> > +     __u64 data[0];
>
> So userspace always sees a 64bit quantify per stat. My earlier comment
> about the ulong/u64 discrepancy stands! ;-)
Yes, userspace always sees a 64 bit, but the ulong in KVM would be
64bit or 32bit.
>
> > +  };
> > +
> > +This ioctl is used to get the aggregated statistics data for VM or vCPU.
> > +Users must use KVM_STATS_GET_INFO to find the number of statistics.
> > +They must allocate a buffer of the appropriate size num_stats * sizeof(data[0])
> > +immediately following struct kvm_stats_data. The size field of kvm_stats_data
> > +must contain the buffer size as an input.
> > +The data buffer 1-1 maps to name strings buffer in sequential order.
> > +This ioctl is usually called periodically to pull statistics data.
>
> Is there any provision to reset the counters on read?
Nope.
>
> > +
> >  5. The kvm_run structure
> >  ========================
> >
> > @@ -6721,3 +6791,12 @@ vcpu_info is set.
> >  The KVM_XEN_HVM_CONFIG_RUNSTATE flag indicates that the runstate-related
> >  features KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR/_CURRENT/_DATA/_ADJUST are
> >  supported by the KVM_XEN_VCPU_SET_ATTR/KVM_XEN_VCPU_GET_ATTR ioctls.
> > +
> > +8.31 KVM_CAP_STATS_BINARY_FORM
> > +------------------------------
> > +
> > +:Architectures: all
> > +
> > +This capability indicates that KVM supports retrieving aggregated statistics
> > +data in binary format with corresponding VM/VCPU ioctl KVM_STATS_GET_INFO,
> > +KVM_STATS_GET_NAMES and KVM_STATS_GET_DATA.
>
> nit: for ease of reviewing, consider splitting the documentation in a
> separate patch.
Will do.
>
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 1ea297458306..f2dabf457717 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1164,7 +1164,6 @@ static inline bool kvm_is_error_gpa(struct kvm *kvm, gpa_t gpa)
> >
> >  #define VM_STAT_COUNT                (sizeof(struct kvm_vm_stat)/sizeof(ulong))
> >  #define VCPU_STAT_COUNT              (sizeof(struct kvm_vcpu_stat)/sizeof(u64))
> > -#define KVM_STATS_NAME_LEN   32
> >
> >  /* Make sure it is synced with fields in struct kvm_vm_stat. */
> >  extern const char kvm_vm_stat_strings[][KVM_STATS_NAME_LEN];
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index f6afee209620..ad185d4c5e42 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1078,6 +1078,7 @@ struct kvm_ppc_resize_hpt {
> >  #define KVM_CAP_DIRTY_LOG_RING 192
> >  #define KVM_CAP_X86_BUS_LOCK_EXIT 193
> >  #define KVM_CAP_PPC_DAWR1 194
> > +#define KVM_CAP_STATS_BINARY_FORM 195
> >
> >  #ifdef KVM_CAP_IRQ_ROUTING
> >
> > @@ -1853,4 +1854,63 @@ struct kvm_dirty_gfn {
> >  #define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
> >  #define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
> >
> > +/* Available with KVM_CAP_STATS_BINARY_FORM */
> > +
> > +#define KVM_STATS_NAME_LEN           32
> > +
> > +/**
> > + * struct kvm_stats_info - statistics information
> > + *
> > + * Used as parameter for ioctl %KVM_STATS_GET_INFO.
> > + *
> > + * @num_stats: On return, the number of statistics data of vm or vcpu.
> > + *
> > + */
> > +struct kvm_stats_info {
> > +     __u32 num_stats;
> > +};
> > +
> > +/**
> > + * struct kvm_stats_names - string list of statistics names
> > + *
> > + * Used as parameter for ioctl %KVM_STATS_GET_NAMES.
> > + *
> > + * @size: Input from user, indicating the size of buffer after the struture.
> > + * @names: Buffer of name string list for vm or vcpu. Each string is
> > + *   null-padded to a size of %KVM_STATS_NAME_LEN.
> > + *
> > + * Users must use %KVM_STATS_GET_INFO to find the number of
> > + * statistics. They must allocate a buffer of the appropriate
> > + * size (>= &struct kvm_stats_info @num_stats * %KVM_STATS_NAME_LEN)
> > + * immediately following this struture.
> > + */
> > +struct kvm_stats_names {
> > +     __u32 size;
> > +     __u8  names[0];
> > +};
> > +
> > +/**
> > + * struct kvm_stats_data - statistics data array
> > + *
> > + * Used as parameter for ioctl %KVM_STATS_GET_DATA.
> > + *
> > + * @size: Input from user, indicating the size of buffer after the struture.
> > + * @data: Buffer of statistics data for vm or vcpu.
> > + *
> > + * Users must use %KVM_STATS_GET_INFO to find the number of
> > + * statistics. They must allocate a buffer of the appropriate
> > + * size (>= &struct kvm_stats_info @num_stats * sizeof(@data[0])
> > + * immediately following this structure.
> > + * &struct kvm_stats_names @names 1-1 maps to &structkvm_stats_data
> > + * @data in sequential order.
> > + */
> > +struct kvm_stats_data {
> > +     __u32 size;
> > +     __u64 data[0];
> > +};
> > +
> > +#define KVM_STATS_GET_INFO           _IOR(KVMIO, 0xcc, struct kvm_stats_info)
> > +#define KVM_STATS_GET_NAMES          _IOR(KVMIO, 0xcd, struct kvm_stats_names)
> > +#define KVM_STATS_GET_DATA           _IOR(KVMIO, 0xce, struct kvm_stats_data)
> > +
> >  #endif /* __LINUX_KVM_H */
> > --
> > 2.30.1.766.gb4fecdf3b7-goog
> >
> >
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
