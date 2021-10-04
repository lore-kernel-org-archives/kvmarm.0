Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B0FC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 18:23:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C8CC6613D2
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 18:23:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C8CC6613D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A5C04B2AC;
	Mon,  4 Oct 2021 14:23:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9FV6LBBGpdkA; Mon,  4 Oct 2021 14:23:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FB134B27B;
	Mon,  4 Oct 2021 14:23:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13F614B276
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 14:23:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pMmI96N6rJvY for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 14:23:36 -0400 (EDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com
 [209.85.219.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 00B394B22E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 14:23:35 -0400 (EDT)
Received: by mail-yb1-f173.google.com with SMTP id v195so39336362ybb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 11:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=BFKM7U3UDEJ55Ej869376prtCofZCVdDub7v4Xo/Buo=;
 b=jPaiEO68fCD9c6m0PyHUFtUdWd2HM024YbBjs8TME+hIf+piF7+5VAIiq+zs8Vzl45
 J4j4CYBHEt/FR6TmTuiy1T7z58//v7+afg0bY2a4sut/NvU3ophdU1Rlrw0e+7vdqWIQ
 Sz+ZA6lMkIBKN4xxiLRBDlw/FkWvgLMy6P1THW1kal1aqrq1bStbTzwQ5gacHB5rqjch
 pGTnW1djIrAQIcMyEi6AMSCn72+6D9QYFNxPp5NtltoAkWdb+muid/3/Q678/vvn59rC
 wk02LQwP5PBzi2WwLdmdHvaR2WE59PqJza8JQfjZt04WBFyLfLeF1wAZNuHe6iy1sVX0
 vl5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=BFKM7U3UDEJ55Ej869376prtCofZCVdDub7v4Xo/Buo=;
 b=47ZKM/fbANO6qaGOTxAg8a1d6cY5yZN7Z8WS9c9moVFIx0RIsJryJygVjrCKMQtgvT
 ttchdzWzSdvYZ08as91NsuhvXdyxtrXhkQrM3bXEHzBkAkJpxYtARGz/4FsVN5eSMGNw
 N1s5oy4nu2BLrtWewQ5/ERwRcyMA5B46U2Q65Kq3seH5ZoerxnwUJRzYwJ0BpCGzUWiR
 ue6iVuh/UrbMhlSo3p4boMHnnFxFUsz9FoxbjsUFrYPl77djqdM3N9SYkEkqUIBdJ3v5
 foPOTZ8z06kl51q/3qhIInMZnlDuOYXLq50tlc44W2YjuijV4y9Njba0iasVkNQ3rSxt
 vClg==
X-Gm-Message-State: AOAM5326ZsIR3WG0yedbSsMPylof5hjS2a4NRs73hvVjFNzgt8aAy5rE
 m2asc9gMaY5lxcsUtQ+vqBoQBXm7kE/cJuYDrtVrJg==
X-Google-Smtp-Source: ABdhPJxY3TE/jiifKSp9sVvDhnfPt509VcHgkIJv6dDJItL4Wj6IeZVwTsaqflKieQJelqqbgwTG9z9Tb8IjBjfJQzI=
X-Received: by 2002:a25:6557:: with SMTP id z84mr17297165ybb.243.1633371815123; 
 Mon, 04 Oct 2021 11:23:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210914223114.435273-1-rananta@google.com>
 <20210914223114.435273-16-rananta@google.com>
 <61419b8f-4da9-955e-b8e3-1d401d91ab1a@huawei.com>
In-Reply-To: <61419b8f-4da9-955e-b8e3-1d401d91ab1a@huawei.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 4 Oct 2021 11:23:24 -0700
Message-ID: <CAJHc60yXia60BL6_NddvqsjhXJ19bHrnyQKiPNMqEjjQuHXedw@mail.gmail.com>
Subject: Re: [PATCH v7 15/15] KVM: arm64: selftests: arch_timer: Support vCPU
 migration
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, Sep 30, 2021 at 2:41 AM Zenghui Yu <yuzenghui@huawei.com> wrote:
>
> On 2021/9/15 6:31, Raghavendra Rao Ananta wrote:
> >  static void test_run(struct kvm_vm *vm)
> >  {
> >       int i, ret;
> > +     pthread_t pt_vcpu_migration;
> > +
> > +     pthread_mutex_init(&vcpu_done_map_lock, NULL);
> > +     vcpu_done_map = bitmap_alloc(test_args.nr_vcpus);
>
> This one fails to build.
>
> aarch64/arch_timer.c: In function 'test_run':
> aarch64/arch_timer.c:321:18: warning: implicit declaration of function
> 'bitmap_alloc'; did you mean 'bitmap_zalloc'?
> [-Wimplicit-function-declaration]
>    vcpu_done_map = bitmap_alloc(test_args.nr_vcpus);
>                    ^~~~~~~~~~~~
>                    bitmap_zalloc
> aarch64/arch_timer.c:321:16: warning: assignment makes pointer from
> integer without a cast [-Wint-conversion]
>    vcpu_done_map = bitmap_alloc(test_args.nr_vcpus);
>                  ^

bitmap_alloc() is defined as an inline function in
tools/include/linux/bitmap.h (since 4.8), which is included as a part
of this patch. Do you mind double-checking if you have it in the
header file?
Also, the function is referenced by other tests such as
dirty_log_[perf_]]test.c. Do you see the same warnings when you
compile them too?

Regards,
Raghavendra
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
