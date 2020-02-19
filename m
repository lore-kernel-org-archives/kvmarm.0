Return-Path: <SRS0=1n5P=4H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE9AC34047
	for <kvmarm@archiver.kernel.org>; Wed, 19 Feb 2020 15:09:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ACE6324656
	for <kvmarm@archiver.kernel.org>; Wed, 19 Feb 2020 15:09:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACE6324656
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 10FF94AECA;
	Wed, 19 Feb 2020 10:09:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aHuLtYClmlYh; Wed, 19 Feb 2020 10:09:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0D364AECC;
	Wed, 19 Feb 2020 10:09:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABCBD4AF06
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 10:09:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ABEMUi7EEQip for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Feb 2020 10:09:36 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BD7F4A5A8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 10:09:36 -0500 (EST)
Received: from mail-qv1-f47.google.com ([209.85.219.47]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MY64R-1iwQdf42VJ-00YSCX for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb
 2020 16:09:35 +0100
Received: by mail-qv1-f47.google.com with SMTP id ek2so328525qvb.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 07:09:34 -0800 (PST)
X-Gm-Message-State: APjAAAWpBgT14RiKdg8tISW/nfObdYjSsDeKGT2WsikfrF9365RqR07o
 UoB77BBvRMHKC39exMRmqWaF4/w15tMtCVmuK8o=
X-Google-Smtp-Source: APXvYqy3rlxWW3PibWcS7Utz29Jg0Z9gTgANCeAjjrXu+xhh/WzI1/Ni7Mlpywm71HMgkez+fQvQf5f2uWJlSlHGL2o=
X-Received: by 2002:ad4:52eb:: with SMTP id p11mr20046350qvu.211.1582124973474; 
 Wed, 19 Feb 2020 07:09:33 -0800 (PST)
MIME-Version: 1.0
References: <20200210141324.21090-1-maz@kernel.org>
In-Reply-To: <20200210141324.21090-1-maz@kernel.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 19 Feb 2020 16:09:17 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3V=ur4AgLfat2cSyw8GrkCS2t06eqkzC-gXcc0xBpEPw@mail.gmail.com>
Message-ID: <CAK8P3a3V=ur4AgLfat2cSyw8GrkCS2t06eqkzC-gXcc0xBpEPw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
To: Marc Zyngier <maz@kernel.org>
X-Provags-ID: V03:K1:rYhaW/mapOw1kUSmxBUvDxvB2czEcYJ3IWZJOf7upuecuwb/F7l
 UvZd1mwCowmGNjAzmExh3JC70OuT3kLNsU/5D71Dc/mNSw5Qv604FqRojwS0PdNleY32YLF
 c3UsQIgxwFsscI+fyKOEJWrH+8wNZ2XOZL5sbtiNP/n63sqgUVhdSkMmhml99owi0+PMGeu
 dGlK4WYyWwdBchit+NFfA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9uLQ0Uuebh0=:M9NJHUqbRTjYlKJQ389EL8
 PijLpnxmblKzcAzkNpUbTJKYroSe0IvN0NYN7txOYMykydx5GIbqSXNT7310iVySr24qn/A+6
 omf6FKLD1x95BbEHNRRXzIUk5xkPOMd1FEhvR7KhNM38zSBmm5catO0/XjQRQ+Xpnj2iJuoQ3
 BJa3SXWbkST4Uj0ED3ED5y3+RijgCySnvjSWj2ILKNsa+e8Fp0UHe+bdIsRZBP6a2V8cXmc14
 MBSAjYZZtyhsevrjeoH4r4ZjphwMQc5OvNmsbP8BMH1qHxr/mtXZNyqqUs+BSj37arQZMVcef
 2STCNamOED5SvU80APzhwqi/z+MSiSLLDNYF9FD8SBU4GjU1Av73uss48f0uTmWVmOQbN87ht
 sPY2SAid1wFtWeCfhicUmiD96rEzMFlpULBY3DPdnjdnccZiiJP4QvySjJ5m4srArvVIN2FN8
 4FEBpPVIlxXZwkLquVqsqqLx/cHTn7UeHOjCaKhYqvhZOd0knNtF5AjOLS+/hRCTKI108G/P9
 A2UCRRyB/atPoRyTJ6b0h7Xwb6sjy9oQ2KmGfaecO5WsvTKe/opX3TNGQSd3bxeDedtD/VdLU
 FGqixAw4ITDEl035IOyvPjn3D2J+69ut8CLsrHlCXZxkUhzpS6Glp1yzrglL6HKcWpkaQ6HfL
 Abk/kY4JX+caNgZd0kPYK0drpNkOHCIHnTKYFIRZ1TcL8rwj/D2z/Q420BCXVD2wgfScOVPd2
 0BRKqCoQ2gMRavNdNEEtkmzltYqHlWNj33mZbHSNwvUxEQIsrgw0/fB+RNMlPiprqhH/kZbVo
 VVvFSGhp7xpUWMCXLLtr1Qwl/urMhp3d4tCrtlNF8G2kG/LqmA=
Cc: jailhouse-dev@googlegroups.com, Anders Berg <anders.berg@lsi.com>,
 Russell King <linux@arm.linux.org.uk>, kvm list <kvm@vger.kernel.org>,
 jean-philippe.brucker@arm.com, Jan Kiszka <jan.kiszka@siemens.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Mon, Feb 10, 2020 at 3:13 PM Marc Zyngier <maz@kernel.org> wrote:
>
> KVM/arm was merged just over 7 years ago, and has lived a very quiet
> life so far. It mostly works if you're prepared to deal with its
> limitations, it has been a good prototype for the arm64 version,
> but it suffers a few problems:
>
> - It is incomplete (no debug support, no PMU)
> - It hasn't followed any of the architectural evolutions
> - It has zero users (I don't count myself here)
> - It is more and more getting in the way of new arm64 developments
>
> So here it is: unless someone screams and shows that they rely on
> KVM/arm to be maintained upsteam, I'll remove 32bit host support
> form the tree. One of the reasons that makes me confident nobody is
> using it is that I never receive *any* bug report. Yes, it is perfect.
> But if you depend on KVM/arm being available in mainline, please shout.
>
> To reiterate: 32bit guest support for arm64 stays, of course. Only
> 32bit host goes. Once this is merged, I plan to move virt/kvm/arm to
> arm64, and cleanup all the now unnecessary abstractions.
>
> The patches have been generated with the -D option to avoid spamming
> everyone with huge diffs, and there is a kvm-arm/goodbye branch in
> my kernel.org repository.

Just one more thought before it's gone: is there any shared code
(header files?) that is used by the jailhouse hypervisor?

If there is, are there any plans to merge that into the mainline kernel
for arm32 in the near future?

I'm guessing the answer to at least one of those questions is 'no', so
we don't need to worry about it, but it seems better to ask.

      Arnd
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
