Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4342EC54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 27 Sep 2022 17:49:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C59774B69D;
	Tue, 27 Sep 2022 13:49:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8z+Gf1JKIch6; Tue, 27 Sep 2022 13:49:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA3264B6C8;
	Tue, 27 Sep 2022 13:49:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FD404B650
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 13:49:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id spqsDCy+shaf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2022 13:49:04 -0400 (EDT)
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com
 [209.85.166.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F1BA4B64E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 13:49:04 -0400 (EDT)
Received: by mail-il1-f174.google.com with SMTP id v1so5495815ilq.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 10:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=aH5zY6y4AfoLNMJw/j/1E8ilTfiC2ZGSCFZ+mICKnl8=;
 b=hjD82U6QZ7vWgB3aKUqxIHx7uLRDY+PcY/enPg2cqnqmZKGLg4UhLPDXuZUQ6qwhZW
 qfLu5LSwOMwVVD2uSOk7Iswfy6MJfHCd7IUHXvNmD2astnQzod0kSvrvsjszWrJQIiUn
 8HEuA9jyZX/DB95xq2FOExGaCSjljxjNeIaeOgq6mOXTq5guJsCvo0+B82B/AmO3BWG/
 HxeuIWKqNAsMmoDcjS9ER3j0EZkomrD0ZSPKVGqo3V8Q4PG41UGwDovBo7hIYwstXQyH
 MVnEN9crkiX4tRX4a4lekaK9IXHW7M4I9z/UQIt0JaCZz2qtANOK2mfmenzAjWc/i6xO
 BcOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=aH5zY6y4AfoLNMJw/j/1E8ilTfiC2ZGSCFZ+mICKnl8=;
 b=os2+s0pVDcgMPG+hnBYt/xNw6rAjg+G0e54x4BmYyy+2nQnekR70nD5Hw/qYF85W5r
 W6wizRXl7V+Iv2G1M84P8jFXZQqmsNRDgQVlg0hA8dCHXHU8nbDjkJRok/bETzatQ2xj
 z6ItEahNNfbtVMIkGnX3BVYWLIgwTBiWYAzha1QrL0B1O8iwK4bnZjLs35OquWLbLHLh
 7XiABgOKNUjGty/gYWTjc1J2SGqVF2tNCBIaPoAqEDCZHRHzWOPapM6c7j+F9nL2V8jX
 KfDUMn8VpFdHNDWmaO2M57V1H6crYnXIFklxG13636ExzgwIWNwT81AT4GWrStmq5IXX
 MB1g==
X-Gm-Message-State: ACrzQf3Hj+8EkvZ8H5AMpvIEb8RX9Qt4g9DkxOx5cNRHvxOh6tFQOpH9
 0sXZo2osTQTcoSuV03Ck7vLcQdQ39hvV2izFTra/mA==
X-Google-Smtp-Source: AMsMyM4WSdgcs3053+4q6G+gKJ/OL8h98odCYYex/ySfuvKuvzP9K3W1FYm+E0hfdBtdE3gYPJCBVhXItsWGJJe5ZGg=
X-Received: by 2002:a05:6e02:1bcc:b0:2f7:2d36:36b1 with SMTP id
 x12-20020a056e021bcc00b002f72d3636b1mr10950913ilv.240.1664300943591; Tue, 27
 Sep 2022 10:49:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220927002715.2142353-1-mizhang@google.com>
 <YzKGqLzjv0I/gkMi@google.com> <86zgel6rz8.wl-maz@kernel.org>
In-Reply-To: <86zgel6rz8.wl-maz@kernel.org>
From: Mingwei Zhang <mizhang@google.com>
Date: Tue, 27 Sep 2022 10:48:52 -0700
Message-ID: <CAL715W+gJKH+3xgFzUjPs6SAMwZCzkF5NNOTDpa4ov2qZ3r_iA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Cleanup the __get_fault_info() to take out
 the code that validates HPFAR
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 LKML <linux-kernel@vger.kernel.org>, Will Deacon <will@kernel.org>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

>
> Honestly, I'd refrain from such changes *unless* they enable something
> else. The current code is well understood by people hacking on it, and
> although I don't mind revamping it, it has to be for a good reason.
>
> I'd be much more receptive to such a change if it was a prefix to
> something that actually made a significant change.
>
> Thanks,
>
>         M.
>
Hi Marc,

Thanks for the feedback.  I am not sure about the style of the KVM ARM
side. But in general I think mixing the generic code for ARM and
specific CPU errata handling is misleading. For instance, in this
case:

+     if ((esr & ESR_ELx_FSC_TYPE) == FSC_PERM)
+             return false;
+
+     if (cpus_have_final_cap(ARM64_WORKAROUND_834220))
+             return false;

As shown it would be much cleaner to separate the two cases as the
former case is suggested in ARMv8 Spec D13.2.55. The latter case would
definitely come from a different source.

But I also don't have a strong opinion pushing this one. So, let me
pull it back then :)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
