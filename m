Return-Path: <SRS0=To9v=JA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA1F9C43461
	for <kvmarm@archiver.kernel.org>; Sat,  3 Apr 2021 17:43:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C8C46128B
	for <kvmarm@archiver.kernel.org>; Sat,  3 Apr 2021 17:43:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C8C46128B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC4634B49A;
	Sat,  3 Apr 2021 13:43:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wXd5He6A7640; Sat,  3 Apr 2021 13:43:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 973504B53E;
	Sat,  3 Apr 2021 13:43:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B22F4B53F
 for <kvmarm@lists.cs.columbia.edu>; Sat,  3 Apr 2021 13:43:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oeg47v7VGH2q for <kvmarm@lists.cs.columbia.edu>;
 Sat,  3 Apr 2021 13:43:06 -0400 (EDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com
 [209.85.208.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4296C4B53E
 for <kvmarm@lists.cs.columbia.edu>; Sat,  3 Apr 2021 13:43:06 -0400 (EDT)
Received: by mail-lj1-f170.google.com with SMTP id u20so8583714lja.13
 for <kvmarm@lists.cs.columbia.edu>; Sat, 03 Apr 2021 10:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=/IBHWY9KNBBG6nCdTgxJNzHRop44ReYjl5lJIYYJHDQ=;
 b=EfS5LLvX3kU4+qQlEroXp84UFgM7EjtkSw2FfILegRS42vivBkZ7RR2MoGlv8+dRbi
 1acuh9KHT7n9AFDUVT3Q0qHd8a7twsus/RwsjzQ2PyhI54fauvY2FBUy3lzoJhSc8VYp
 G8Cju+PDs14tS1te2kd1HiHMw4cfxrb3XHTaCXx0Zpq3Xd/Pa4C5k8D7a4hCclp5vyxs
 3BQpos0LsADLfyv2xTDioRz/bsdv6Jnd/a54wdHR9p/37YCw58vQrjsm/M7Ao40eS6Ml
 Xsp3JsuzxNKH9s/jCWOQcApw1S/ksfxwA6FUq23rvEfMMgJ1VSIQTBdB8l2r2WWTrtH0
 wmpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=/IBHWY9KNBBG6nCdTgxJNzHRop44ReYjl5lJIYYJHDQ=;
 b=fDupbFG7QJ2rlRl7CGJ0YCaRPJflKHPrdEIraRWgd4t2IUDGDYEalQHYI+S8eAFnRt
 WofH/uOMc5PoMg/D9XNirwLaGdO2Q5DGPhfKmavexsDEauPDy2RR5Cz0WDDefpF08+Io
 91ky30VXnVu92UKC3sJcuDa9RpaypM6xpw4vr5+kQDt934kNOKeJ66KBz4bkVrbvweTm
 4DWYiaOp89uY5+Xaf1UG9guPD52UJPxxbmjBX4K26+J/Z+R/LsqcIkIv6l1Rf90po3Lp
 i/rJb3dWrcGDb8dBx9K2nMpYYYl5A5k0/+KbqSJBv45OlOC0PKzdwRJj17SPIfNMx2Bs
 V2qw==
X-Gm-Message-State: AOAM532jxE71tkbivrFG1a+7bCvxV8kzUsZncSddTe253+cH96BtLjEy
 VHdJ8OyI8SZ+qLOYZyOJREGfcqVhh8sRL5Z/IVPVWw==
X-Google-Smtp-Source: ABdhPJxEjp5gonu+hQHB4Abduquvh78zo5GomYM0ev+L22zJaVtT8zAODonDrRhIx1y/0PA+aUruMV2Qf67ktMgTwEk=
X-Received: by 2002:a2e:9907:: with SMTP id v7mr11657200lji.256.1617471784580; 
 Sat, 03 Apr 2021 10:43:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210402224359.2297157-3-jingzhangos@google.com>
 <202104031344.oNE1vaQq-lkp@intel.com>
In-Reply-To: <202104031344.oNE1vaQq-lkp@intel.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Sat, 3 Apr 2021 12:42:52 -0500
Message-ID: <CAAdAUthtA8K1bpB1W4pm+Bgi10JokPi=Q_tv037qMu7+5b9N6Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: stats: Add fd-based API to read binary stats data
To: kernel test robot <lkp@intel.com>
Cc: LinuxS390 <linux-s390@vger.kernel.org>, kbuild-all@lists.01.org,
 KVM <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 LinuxMIPS <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, KVMARM <kvmarm@lists.cs.columbia.edu>
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

On Sat, Apr 3, 2021 at 12:25 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Jing,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on f96be2deac9bca3ef5a2b0b66b71fcef8bad586d]
>
> url:    https://github.com/0day-ci/linux/commits/Jing-Zhang/KVM-statistics-data-fd-based-binary-interface/20210403-064555
> base:   f96be2deac9bca3ef5a2b0b66b71fcef8bad586d
> config: i386-allyesconfig (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
>
> cocci warnings: (new ones prefixed by >>)
> >> arch/x86/kvm/x86.c:270:36-37: WARNING: Use ARRAY_SIZE
>    arch/x86/kvm/x86.c:235:34-35: WARNING: Use ARRAY_SIZE
>
> vim +270 arch/x86/kvm/x86.c
>
>    267
>    268  struct _kvm_stats_header kvm_vcpu_stats_header = {
>    269          .name_size = KVM_STATS_NAME_LEN,
>  > 270          .count = sizeof(kvm_vcpu_stats_desc) / sizeof(struct _kvm_stats_desc),
Thanks, will do.
>    271          .desc_offset = sizeof(struct kvm_stats_header),
>    272          .data_offset = sizeof(struct kvm_stats_header) +
>    273                  sizeof(kvm_vcpu_stats_desc),
>    274  };
>    275
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
