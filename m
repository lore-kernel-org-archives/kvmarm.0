Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B2BC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  6 May 2022 19:18:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53A144B11E;
	Fri,  6 May 2022 15:18:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dMWepPd-5HzS; Fri,  6 May 2022 15:18:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 557024B0F5;
	Fri,  6 May 2022 15:18:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 576D64B104
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 15:18:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g1Ud8jQOcmWB for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2022 15:18:25 -0400 (EDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com
 [209.85.167.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 44CE749ECF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 15:18:25 -0400 (EDT)
Received: by mail-lf1-f46.google.com with SMTP id u23so8474384lfc.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 06 May 2022 12:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=gq/gl/FI3wYJsrnbCzQm2bNyQ1Zxb9MLdkOQWzlXPQs=;
 b=W3zIs23sSWG8ORW1qlYtbDUPstZdw8G1+D8QTYT1TYtqO//vpXIcEcaPF2Nc3Lp38B
 gXSm/bWtZ8x2kxUzJDCyyk6ajyELFbkvOcbWKgyVckuBGH42VTsZbCpLntz/TzNupGcz
 dsui/cFSCapFC5YtMfQK/d92UVB0SQQKhzLuzI74PaSnlbOGPRDAEOEQVZc1ojfPlyAi
 h2WAFdv1J6CS4hqtchui+dlaPyW2dLDY4shPevrxJAp7dC6MwokbSp9Yj18deOv1auky
 Gan0xmQs+XCle+NxEUYT1UkIWKF4ZFJ2t8xu6PkU/5kP8qdPm9jFKjcckxkwwfkmcAIf
 xjbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=gq/gl/FI3wYJsrnbCzQm2bNyQ1Zxb9MLdkOQWzlXPQs=;
 b=K5hSYqbRhWeVnx0tiANUvQL3KXRLH6BZW7/eFyZTH9880Zz12ZhD5v8y1UoqoZ7MSR
 3YTOS/vJR58xPIsq3DQnyYc70nBMNWVSpNOFEqruX0Wg41W8qnedkzRJsBqMSYWrp2sh
 jYgmPcdZqmyDfxrN5DeM9KxXTzbMqUz/w7VBS2pvTHslnU6haxr7nFlPbXowcr7eVNgE
 SZ5ChD+8vejryegVIXRmQW7d8St/p58EtvBOp3OKr33vvkHqw/uPXEh0SOGHbSqDRiiJ
 ngHY3Q2FoKxUrLG/RgE+SzHmYlU37u7rRJZ9pQjlfXpmnl2ftlHXGlSPlshIOmd9J8VJ
 wpZg==
X-Gm-Message-State: AOAM530DApzfrjiT474bPh50QK2XHEPxI4cBvmbVl1H03eQq5QkpjyNM
 CKTb2T087I0S6CR3n+FhBUrFGuurLUvonWsVNyqRAg==
X-Google-Smtp-Source: ABdhPJyOL3mD8Xsc3l1JLJTNvCUhq8PVk6+DgYm/cn6njrwzIBFsD6kYOIC/2KdoP6kQKuXeQ9Er9jocaazqPLOT5AQ=
X-Received: by 2002:a05:6512:1287:b0:473:b904:b27c with SMTP id
 u7-20020a056512128700b00473b904b27cmr3473357lfs.361.1651864703455; Fri, 06
 May 2022 12:18:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
 <20220311175717.616958-1-oupton@google.com>
 <20220506130101.GC22892@willie-the-truck>
In-Reply-To: <20220506130101.GC22892@willie-the-truck>
From: Oliver Upton <oupton@google.com>
Date: Fri, 6 May 2022 12:18:12 -0700
Message-ID: <CAOQ_QshP8NH0WkyDmqbfRf--+wyWNepqSgtSq2F_AxyeB-EaHA@mail.gmail.com>
Subject: Re: [RFC PATCH kvmtool 0/5] ARM: Implement PSCI SYSTEM_SUSPEND
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
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

Hi Will,

On Fri, May 6, 2022 at 6:01 AM Will Deacon <will@kernel.org> wrote:
>
> Looks like the kernel-side changes are queued now, so please can you resend
> this series? I also think you can drop the AArch32 support, unless you see a
> compelling reason for it?

You bet. I was going to wait for 5.19-rc1 just for the dust to settle
and get a stable number for the UAPI bits. I think the ARM changes
have some light conflicts with SEV work in Paolo's tree.

All for dropping AArch32, means less work for me :-P

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
