Return-Path: <SRS0=1iKH=4I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA3FC11D05
	for <kvmarm@archiver.kernel.org>; Thu, 20 Feb 2020 12:44:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 62B7224672
	for <kvmarm@archiver.kernel.org>; Thu, 20 Feb 2020 12:44:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WScAF959"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62B7224672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD64B4ACEE;
	Thu, 20 Feb 2020 07:44:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@samsung.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p9lrK-qgPVCF; Thu, 20 Feb 2020 07:44:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 577034AEB2;
	Thu, 20 Feb 2020 07:44:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA8B14ACE9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Feb 2020 07:44:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yv1DABJfYV9B for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Feb 2020 07:44:32 -0500 (EST)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73A154AC89
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Feb 2020 07:44:32 -0500 (EST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20200220124429euoutp0156ed4c7a9d07be5cfa03bd8547ebec27~1HPHyz5912688326883euoutp01C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Feb 2020 12:44:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20200220124429euoutp0156ed4c7a9d07be5cfa03bd8547ebec27~1HPHyz5912688326883euoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
 s=mail20170921; t=1582202669;
 bh=eOUJH64mDRUYkaF/Fmv6vlocyb0IuzOO7tU5aRS8RS4=;
 h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
 b=WScAF959TNK7Lb+5lbe+lmIVe3Qc6bOXAQKyVIpcTj+wkZgfc4Loq/jSxQeKBMI/B
 c1EHyNSrq3FxreJWkqB7aRCCRVcdEpaSVo2U+GOf2ypwmJZoUQU6ulp3Qg0uqglXoE
 +l9SG3A6NqIi38itiIe5szf8bbgVB5p4OV1yOdjM=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20200220124429eucas1p2467c16c49560ed4c9361f43231a21615~1HPHfyh7b1746517465eucas1p2a;
 Thu, 20 Feb 2020 12:44:29 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 78.D5.61286.D2F7E4E5; Thu, 20
 Feb 2020 12:44:29 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20200220124428eucas1p21bed94ccd20a711ea46998a6ba4a2da7~1HPHJuyqG0498004980eucas1p2B;
 Thu, 20 Feb 2020 12:44:28 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20200220124428eusmtrp2f08eae080687e9735fb181e08c8d6e50~1HPHI71W30852708527eusmtrp2j;
 Thu, 20 Feb 2020 12:44:28 +0000 (GMT)
X-AuditID: cbfec7f2-ef1ff7000001ef66-ff-5e4e7f2dac6c
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 93.28.08375.C2F7E4E5; Thu, 20
 Feb 2020 12:44:28 +0000 (GMT)
Received: from [106.120.51.15] (unknown [106.120.51.15]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20200220124428eusmtip260f44b076586efbd03c8d8931c583612~1HPGV7SWK0219102191eusmtip2L;
 Thu, 20 Feb 2020 12:44:27 +0000 (GMT)
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <621a0a92-6432-6c3e-cb69-0b601764fa69@samsung.com>
Date: Thu, 20 Feb 2020 13:44:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200210141324.21090-1-maz@kernel.org>
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRjm27nsbLg6m8Y+LLpMMorM7EIfFFEQeCqywB9hoDXzOMVNbcdL
 SuDKsporQpK2ZSmVmMtLO9m8lIZWs9JU7GZe6OYCrVHZ1UmaZ4fKf8/7Ps/7Pc/78lGYykcE
 U8mpGawxVavXkHLc5R7vCgvLi4pbeapNjp4du4Cj30VuKXJaawnUUxONXrVUSFDh+wISdXdf
 l6KS4gPoy6N2KeLfPSfQwBMFaix5SKA7rkkCdfIuHNkGBgCqtjbh6Ojg2k1KpupiFWCO5ltI
 ZsJXBJhG+5CUKeMzGd5xkmS6+SqMuXEljxktNEmYTy3PSOZ0nQMwX/n5uwL2yDcksPrkLNYY
 vnGfPOmKlyfSGyMOeu5/kZjA7xAzoChIr4Ej7gAzkFMq+iqAJuc4MAPZdPENwJoCpUh8BbCz
 8DIuEMJA82gVIRIVABYOdJNi4QWwsrxZKqgC6S3wse24/6kg+hD0jBf7JzC6GIeOS16JQJB0
 BDR7zaSAFfRGaB0tIQSM04uh41aHf3gOHQvPV97FRY0SPrQN+7FsOob15Wv/Oxi9ANZ7SzAR
 q2H/cKlEMIN0OQWbHpzDxNzTid4eJkUcCEfb66QingenGv8O5AP4pqtaKhYWAJ8csQJRtR4O
 dvlI4WQYvRTWNoWL7c3Q7cyXiJecBfu8SjHELFjkEnyFtgKeKFCJ6lBob6/5Z9va04udARr7
 jNXsM9axz1jH/t+3DOAOoGYzOYOO5SJS2ewVnNbAZabqVuxPM/Bg+kd2TLaPNYDvvfFtgKaA
 JkDxecmOOBWhzeJyDG0AUpgmSBEaEBWnUiRoc3JZY9peY6ae5drAXArXqBWrL43EqmidNoNN
 Ydl01viXlVCyYBNQJpYlW8ZauXRFWIz9wreFoaX81LYxXUb/0OzJnM2wq34rciZZ1JHhjrqK
 p9GL7u2O2+rZGd+gS1lny7NswSYuRp/Wz9fl5fZt6JvQfFjAJXrKbb9kphStq+dmpPOHZ/Dn
 8sVnzZXXknv6jrf4Eldn3/4UtGr3x5gpd0XIi+2tag3OJWkjlmFGTvsHapKVsI0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e/4PV2der84g5v3DC2uts5lsfg76Ri7
 xcYZ61ktLqwLtri/bzmTRfezNjaL8+c3sFvMmVpo8fHUcXaLTY+vsVrcvsxrsXPOSVaL/dv+
 sVqc2bSNxWLm7duMFmtn7GKxaLlj6iDosWbeGkaPluYeNo/fvyYxeuycdZfdY8GmUo9NqzrZ
 PM5vWsPssXlJvcer7gYmj/f7rrJ59G1ZxejxeZNcAE+Unk1RfmlJqkJGfnGJrVK0oYWRnqGl
 hZ6RiaWeobF5rJWRqZK+nU1Kak5mWWqRvl2CXsaSt5tYC3YaVjw9+pGpgfGvchcjJ4eEgInE
 3ldrWLsYuTiEBJYySpx/coENIiEjcXJaAyuELSzx51oXG0TRa0aJFQdfsIAkhAVcJM7ObGcE
 sUUEaiRazv1nAiliFpjJItHzcTk7REc7o8SDJXvARrEJGEp0ve0CW8ErYCcx49UcsDiLgKrE
 qt2nwSaJCsRK3JjZwQRRIyhxcuYTsG2cQLfOuPkALM4sYCYxb/NDZghbXmL72zlQtrjErSfz
 mSYwCs1C0j4LScssJC2zkLQsYGRZxSiSWlqcm55bbKhXnJhbXJqXrpecn7uJEZgWth37uXkH
 46WNwYcYBTgYlXh4P6j7xgmxJpYVV+YeYpTgYFYS4VXj8YsT4k1JrKxKLcqPLyrNSS0+xGgK
 9NxEZinR5HxgysoriTc0NTS3sDQ0NzY3NrNQEuftEDgYIySQnliSmp2aWpBaBNPHxMEp1cBY
 KWp3pmPL+jdbg/sU3zotle2eNn9nVGnyU1fh/O+rXNrOXrdgvX2p0ME3RF6nMrIg+rhr48o9
 1R+m938JLOmQylr768Wx+onXDz39Xnlt3Y+JuZdudt/TTP29Ob5vbX2DxNN6xxU91dX7vmqc
 jP78cfap2LqaF4Ln5zTrr5Zilcp7c65xtd8dJZbijERDLeai4kQAAboQDiEDAAA=
X-CMS-MailID: 20200220124428eucas1p21bed94ccd20a711ea46998a6ba4a2da7
X-Msg-Generator: CA
X-RootMTR: 20200210141344eucas1p25a6da0b0251931ef3659397a6f34c0c3
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200210141344eucas1p25a6da0b0251931ef3659397a6f34c0c3
References: <CGME20200210141344eucas1p25a6da0b0251931ef3659397a6f34c0c3@eucas1p2.samsung.com>
 <20200210141324.21090-1-maz@kernel.org>
Cc: Anders Berg <anders.berg@lsi.com>, Russell King <linux@arm.linux.org.uk>,
 Arnd Bergmann <arnd@arndb.de>, Krzysztof Kozlowski <krzk@kernel.org>,
 Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>
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

On 10.02.2020 15:13, Marc Zyngier wrote:
> KVM/arm was merged just over 7 years ago, and has lived a very quiet
> life so far. It mostly works if you're prepared to deal with its
> limitations, it has been a good prototype for the arm64 version,
> but it suffers a few problems:
>
> - It is incomplete (no debug support, no PMU)
> - It hasn't followed any of the architectural evolutions
> - It has zero users (I don't count myself here)
> - It is more and more getting in the way of new arm64 developments

That is a bit sad information. Mainline Exynos finally got everything 
that was needed to run it on the quite popular Samsung Exynos5422-based 
Odroid XU4/HC1/MC1 boards. According to the Odroid related forums it is 
being used. We also use it internally at Samsung.

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
>
> Marc Zyngier (5):
>    arm: Unplug KVM from the build system
>    arm: Remove KVM from config files
>    arm: Remove 32bit KVM host support
>    arm: Remove HYP/Stage-2 page-table support
>    arm: Remove GICv3 vgic compatibility macros
>
>   Documentation/virt/kvm/arm/hyp-abi.txt |    5 +
>   arch/arm/Kconfig                       |    2 -
>   arch/arm/Makefile                      |    1 -
>   arch/arm/configs/axm55xx_defconfig     |    2 -
>   arch/arm/include/asm/arch_gicv3.h      |  114 --
>   arch/arm/include/asm/kvm_arm.h         |  239 ----
>   arch/arm/include/asm/kvm_asm.h         |   77 --
>   arch/arm/include/asm/kvm_coproc.h      |   36 -
>   arch/arm/include/asm/kvm_emulate.h     |  372 ------
>   arch/arm/include/asm/kvm_host.h        |  459 --------
>   arch/arm/include/asm/kvm_hyp.h         |  127 ---
>   arch/arm/include/asm/kvm_mmu.h         |  435 -------
>   arch/arm/include/asm/kvm_ras.h         |   14 -
>   arch/arm/include/asm/pgtable-3level.h  |   20 -
>   arch/arm/include/asm/pgtable.h         |    9 -
>   arch/arm/include/asm/sections.h        |    6 +-
>   arch/arm/include/asm/stage2_pgtable.h  |   75 --
>   arch/arm/include/asm/virt.h            |   12 -
>   arch/arm/include/uapi/asm/kvm.h        |  314 -----
>   arch/arm/kernel/asm-offsets.c          |   11 -
>   arch/arm/kernel/vmlinux-xip.lds.S      |    8 -
>   arch/arm/kernel/vmlinux.lds.S          |    8 -
>   arch/arm/kernel/vmlinux.lds.h          |   10 -
>   arch/arm/kvm/Kconfig                   |   59 -
>   arch/arm/kvm/Makefile                  |   43 -
>   arch/arm/kvm/coproc.c                  | 1455 ------------------------
>   arch/arm/kvm/coproc.h                  |  130 ---
>   arch/arm/kvm/coproc_a15.c              |   39 -
>   arch/arm/kvm/coproc_a7.c               |   42 -
>   arch/arm/kvm/emulate.c                 |  166 ---
>   arch/arm/kvm/guest.c                   |  387 -------
>   arch/arm/kvm/handle_exit.c             |  175 ---
>   arch/arm/kvm/hyp/Makefile              |   34 -
>   arch/arm/kvm/hyp/banked-sr.c           |   70 --
>   arch/arm/kvm/hyp/cp15-sr.c             |   72 --
>   arch/arm/kvm/hyp/entry.S               |  121 --
>   arch/arm/kvm/hyp/hyp-entry.S           |  295 -----
>   arch/arm/kvm/hyp/s2-setup.c            |   22 -
>   arch/arm/kvm/hyp/switch.c              |  242 ----
>   arch/arm/kvm/hyp/tlb.c                 |   68 --
>   arch/arm/kvm/hyp/vfp.S                 |   57 -
>   arch/arm/kvm/init.S                    |  157 ---
>   arch/arm/kvm/interrupts.S              |   36 -
>   arch/arm/kvm/irq.h                     |   16 -
>   arch/arm/kvm/reset.c                   |   86 --
>   arch/arm/kvm/trace.h                   |   86 --
>   arch/arm/kvm/vgic-v3-coproc.c          |   27 -
>   arch/arm/mach-exynos/Kconfig           |    2 +-
>   arch/arm/mm/mmu.c                      |   26 -
>   49 files changed, 7 insertions(+), 6262 deletions(-)
>   delete mode 100644 arch/arm/include/asm/kvm_arm.h
>   delete mode 100644 arch/arm/include/asm/kvm_asm.h
>   delete mode 100644 arch/arm/include/asm/kvm_coproc.h
>   delete mode 100644 arch/arm/include/asm/kvm_emulate.h
>   delete mode 100644 arch/arm/include/asm/kvm_host.h
>   delete mode 100644 arch/arm/include/asm/kvm_hyp.h
>   delete mode 100644 arch/arm/include/asm/kvm_mmu.h
>   delete mode 100644 arch/arm/include/asm/kvm_ras.h
>   delete mode 100644 arch/arm/include/asm/stage2_pgtable.h
>   delete mode 100644 arch/arm/include/uapi/asm/kvm.h
>   delete mode 100644 arch/arm/kvm/Kconfig
>   delete mode 100644 arch/arm/kvm/Makefile
>   delete mode 100644 arch/arm/kvm/coproc.c
>   delete mode 100644 arch/arm/kvm/coproc.h
>   delete mode 100644 arch/arm/kvm/coproc_a15.c
>   delete mode 100644 arch/arm/kvm/coproc_a7.c
>   delete mode 100644 arch/arm/kvm/emulate.c
>   delete mode 100644 arch/arm/kvm/guest.c
>   delete mode 100644 arch/arm/kvm/handle_exit.c
>   delete mode 100644 arch/arm/kvm/hyp/Makefile
>   delete mode 100644 arch/arm/kvm/hyp/banked-sr.c
>   delete mode 100644 arch/arm/kvm/hyp/cp15-sr.c
>   delete mode 100644 arch/arm/kvm/hyp/entry.S
>   delete mode 100644 arch/arm/kvm/hyp/hyp-entry.S
>   delete mode 100644 arch/arm/kvm/hyp/s2-setup.c
>   delete mode 100644 arch/arm/kvm/hyp/switch.c
>   delete mode 100644 arch/arm/kvm/hyp/tlb.c
>   delete mode 100644 arch/arm/kvm/hyp/vfp.S
>   delete mode 100644 arch/arm/kvm/init.S
>   delete mode 100644 arch/arm/kvm/interrupts.S
>   delete mode 100644 arch/arm/kvm/irq.h
>   delete mode 100644 arch/arm/kvm/reset.c
>   delete mode 100644 arch/arm/kvm/trace.h
>   delete mode 100644 arch/arm/kvm/vgic-v3-coproc.c
>
Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
