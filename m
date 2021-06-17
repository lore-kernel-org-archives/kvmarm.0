Return-Path: <SRS0=srdq=LL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C25C2B9F4
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 15:42:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 32C456120A
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 15:42:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32C456120A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8076F4B09B;
	Thu, 17 Jun 2021 11:42:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d9O9Aot5nTMq; Thu, 17 Jun 2021 11:42:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CED84B099;
	Thu, 17 Jun 2021 11:42:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FF5D4B099
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 11:42:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id efUl8pR4WfTk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jun 2021 11:42:30 -0400 (EDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com
 [209.85.167.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BC754B097
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 11:42:30 -0400 (EDT)
Received: by mail-lf1-f50.google.com with SMTP id q20so11298611lfo.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 08:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=gA9TZaqOl3zy1dJIWszjf8FGUKT8ntsayRnFvsMmeKE=;
 b=rjGGx3hDJcU8YgExYPvnRbDmEiwqIoA9VdAEle1149lM7CLqEmmZ5IGx5C6v2xN+BK
 erAId3gLrIx3qvunWhwnAkobhgz7xQLbphUZnztf54+GCy7Rt9jJnsQ4GTCIxooMQ6Nh
 ypsifEZBI7FXjvlJpbG15frf50E6gOgOxPY59sppGE5Gm3EVOP58JfTBQFuDrNsThg4g
 pW9dY09XQK2DWc9As8xzDId9FTmLnsz2UlZubPkc0QCrvBCN+9v6DMkPxvgT1sLw2hcx
 nQ6ahn5n70P/Vnyg/uULHRQf/KKgKU03kAOJCg30VCluDTMdCeu/RDCuXgsbWPpmgNDS
 NGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=gA9TZaqOl3zy1dJIWszjf8FGUKT8ntsayRnFvsMmeKE=;
 b=a6R1JH9MUTBcYBjQ8byCRZGRD3VrPgg4TzzfwZZ2elDIYf1EBYMmkj0Q0HK58R+WFY
 L0WOQGE1dhtb7e/DbDNGlDCjScNxIJ2nw/Xx3NDInFuuVPdj7bILwZBJTPivW4WvIujG
 sfqBnq6mVcvD+ZKjjpWzYDbUY/t4Gvl8xWH4rr93wTfh0iFMeXnOhP/6LLYZf26g1SUj
 eboNCatoY0kjS+UUgDAiaogzcYRvrQYhzvpA2qHU81k9QZP27YUUHSFIOSFTeSlJbVjQ
 I6HmqroOYACSd1C1GhoZO380i8VvumC5REIHs0ZuRR+a1Z2XIpyMgrxXyVLHChQ88czl
 881g==
X-Gm-Message-State: AOAM531rOPyVz+2sOG8Mv4oUFL9/MOW+ncEGuvnrY/fgxkVh2wnm/F25
 E879bhuR2QoNcmCN8XTGmjPvfj0mWzjrYelzq/i2IA==
X-Google-Smtp-Source: ABdhPJxIgtHTYijVD1CpTmwKu7GF1JsNiAyO8otRBPAhPiGuR1/vRj2f9gVDMVv2mwH8Qtqe0siOJfwZGA+WbyKt0Rk=
X-Received: by 2002:a05:6512:318d:: with SMTP id
 i13mr4638106lfe.407.1623944549075; 
 Thu, 17 Jun 2021 08:42:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210617044146.2667540-1-jingzhangos@google.com>
 <20210617044146.2667540-3-jingzhangos@google.com> <YMr4rArKvj3obDEM@kroah.com>
 <CAAdAUtiiQ0304vWR3Zm2XUKz374W4LY3=qdrFZCsQ27VkqMn9A@mail.gmail.com>
 <5ae75b1b-4cba-d06f-625b-35b42f11ac03@redhat.com>
In-Reply-To: <5ae75b1b-4cba-d06f-625b-35b42f11ac03@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Thu, 17 Jun 2021 10:42:17 -0500
Message-ID: <CAAdAUtigLr+n_d+XZ3FUUXSSb7PmSFNY5+XKATQp2r0s4xiY8A@mail.gmail.com>
Subject: Re: [PATCH v10 2/5] KVM: stats: Add fd-based API to read binary stats
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

On Thu, Jun 17, 2021 at 10:29 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 17/06/21 16:56, Jing Zhang wrote:
> > Actually, it is really not easy to separate this change into two patches even by
> > following Paolo's suggestion. And it would be a surprise to userspace to see
> > only VM stats, no VCPU stats.
>
> That does not matter.  Having two or three patches is useful because it
> makes review easier; they will never appear separately in a release.
>
> Paolo
>
Cool, then I'll separate them.

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
