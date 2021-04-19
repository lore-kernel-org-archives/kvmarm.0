Return-Path: <SRS0=F21+=JQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E795BC433B4
	for <kvmarm@archiver.kernel.org>; Mon, 19 Apr 2021 13:26:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5B743610CC
	for <kvmarm@archiver.kernel.org>; Mon, 19 Apr 2021 13:26:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B743610CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB1434B56D;
	Mon, 19 Apr 2021 09:26:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q-+gDfWc9W1x; Mon, 19 Apr 2021 09:26:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACA864B569;
	Mon, 19 Apr 2021 09:26:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF5134B566
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Apr 2021 09:26:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pe-GroTTwisX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Apr 2021 09:26:23 -0400 (EDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com
 [209.85.167.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB3564B55E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Apr 2021 09:26:23 -0400 (EDT)
Received: by mail-lf1-f51.google.com with SMTP id n8so56039703lfh.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Apr 2021 06:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=NqBtQukzUcKGvmZ1aJArxdkZjllZ69uT8+WTmwdJ6G4=;
 b=em/J+S9hHzBCCI9MSW7xxROUGoj1ECCpWbKbkDd7uZveF8DcpPGfSfeXe7udqDYAGS
 Jj37aD7VWJOTXi/3DhMCYdi9pJNW7jm5Sf4PAqzlM+s1im59ujQ9g0r3tX6QKiCnqI8I
 oO5sYxp5JVgxN3n4uVwCg7nst4zKPgyNiqk71xh9fzEU1SJZSiHV0spwlLta2FppoNXt
 4Sn69HhmbhTj4I1GZVCwzi8/H+Q2tBi5gcCNkX4caIusJ3tMJ1W1hCmiVohKi/6R3p1P
 P4SE3XIUdcjPLBQZiKpeMRryN/1muaULpqJ4vS3LQj+EtgGFUJ9LyQpWIyR+n0cbkMPO
 AGIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=NqBtQukzUcKGvmZ1aJArxdkZjllZ69uT8+WTmwdJ6G4=;
 b=uYWgzXFj0ToDoX81N/u5Bhb7mAa7X4D01YtiLaV6TrtOBA0JaI0xxHIgKtGVG3lJx8
 zdKxJdp9Rw+0cbSWbNCXElF5WggC4QWIn/3KI5oohCTKbOgMnSNXWNMK1HBaNXj2IcFd
 eCd0bJeovR3e+urDf1CIYHQsWczKGhffOFOtGSWQjqvA/j9m2t0pzvN3evedJm3WUZM+
 rOk/uiOs+cSkmXhObWQNEBPByyvNMVxWReP0jWr8c99V3/+iKpN7PJ9/Pea2L1dqUsho
 TRh2L9QgcDJweIHIhARDRatK5MsRZ7r5jsjSXSf4/8VaDwEAXFw+UpKVIxNYXF1y/M0T
 /WNw==
X-Gm-Message-State: AOAM533D3rGg9RIR+IwkRJnXD2M+6VpoQienV//wY15qvsim35sZi+HQ
 6srTMQFJh4ZgOONGky190T7803glcQXohLlGyJBeQQ==
X-Google-Smtp-Source: ABdhPJzC7C637Xaczt8wN5cywlsLikI7xQQerJcl2++bY+AQeL59litpEy9MDacIxAURgyTiZJG8O4odjR7fc14+zi0=
X-Received: by 2002:a19:3813:: with SMTP id f19mr5725327lfa.473.1618838781799; 
 Mon, 19 Apr 2021 06:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210415151741.1607806-1-jingzhangos@google.com>
 <20210415151741.1607806-5-jingzhangos@google.com>
 <9f2a8873-c2c2-ec84-58b4-7c90c59d1d25@redhat.com>
In-Reply-To: <9f2a8873-c2c2-ec84-58b4-7c90c59d1d25@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 19 Apr 2021 08:26:09 -0500
Message-ID: <CAAdAUtinT2+kqV7ia+gVFpy=Mf5TiNJU2QNSbGGC0Ybj3PPuzw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: selftests: Add selftest for KVM statistics
 data binary interface
To: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, LinuxS390 <linux-s390@vger.kernel.org>,
 Janosch Frank <frankja@linux.ibm.com>, Oliver Upton <oupton@google.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Jim Mattson <jmattson@google.com>,
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

Hi Emanuele,

On Mon, Apr 19, 2021 at 6:18 AM Emanuele Giuseppe Esposito
<eesposit@redhat.com> wrote:
>
> Hi Jing,
>
> > +int vm_stats_test(struct kvm_vm *vm)
> > +{
> > +     ssize_t ret;
> > +     int i, stats_fd, err = -1;
> > +     size_t size_desc, size_data = 0;
> > +     struct kvm_stats_header header;
> > +     struct kvm_stats_desc *stats_desc, *pdesc;
> > +     struct kvm_vm_stats_data *stats_data;
> > +
> > +     // Get fd for VM stats
>
> Another small nitpick: comments should go in /* */ format
Thanks. Will fix all comments.
>
> Thank you,
> Emanuele
>

Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
