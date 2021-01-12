Return-Path: <SRS0=ZMJ6=GP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8826BC433E0
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 16:15:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB118223C8
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jan 2021 16:15:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB118223C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21EA24B222;
	Tue, 12 Jan 2021 11:15:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nFWQB2vIOyJi; Tue, 12 Jan 2021 11:15:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 008FE4B1F1;
	Tue, 12 Jan 2021 11:15:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E64E74B1F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 11:15:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Kk3Ws1nGPPE9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Jan 2021 11:15:32 -0500 (EST)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com
 [209.85.221.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BFE34B137
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 11:15:32 -0500 (EST)
Received: by mail-wr1-f54.google.com with SMTP id i9so3088746wrc.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Jan 2021 08:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=fCwX2K3NvzAcpBSMx6nSsu4wGXEXUGQppC3ZRHgJJR8=;
 b=T4Suq8sc8lQnpteBsLr6UZxTcH9j8G7kxKlkqFCYGip/iaonBY1bHQ1oEIYiR/mBrZ
 izvOVjsD3VXx3ixRso71U2wVPQq8ImIzBvHd6GxvlaOsx1nuSaipg0fF+u6HGDyt6ckB
 0dHAVNHgwIM41Dhho2dF7YYFhimMSZNmaTuVVek8lqc2dYzTe8OX4XJ81GRotQMkIAgq
 BzSawYViZz+ddmdHmZnB1C33yqBldAHidvdq/xthmbWU+UpVGfsW7Zi2iBjIcuiGN0nY
 WzWoLbAvtKuWaZaWMF0JzYi5jMyFcn8VJ0B8CvLDBuOr3fiEoYQOtmLyFCsKDoDVcllQ
 /+1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fCwX2K3NvzAcpBSMx6nSsu4wGXEXUGQppC3ZRHgJJR8=;
 b=CL2LL86LExwLgSqJI5D2c9pP7HWih2LkaPIkZZbiuhLJxB1NmcVFjGxWLpvKKtLpKN
 HFiYw9ZAYkXEyUMf1IRP0w34uoqo3dFk+wYS5SZZ5JAsI4lPr1O4o3jX8E2htpYiMtbo
 kvJBaJJbKoXSGKgFV2VZh/FbFUPfYey4KEcSQxRAKIWDdDAodhPEYoXm1pQNxwFCNcih
 rJh2uHeGGyxlWPslqKqxXqjZ7SNh8d80tVyUWoXFb0tbSHCuRYfef5Efvxomw8bmAv6a
 wCXCxWlA5A7hlaQqy54ZGk8/a20SNdEs7ECRs7/ZL+8Vrhah2iAr1zyJm/4AbtrRC6Qf
 mZOA==
X-Gm-Message-State: AOAM531U8EvwHWhRelHEJ4kXKVa2gD9cIuY+J0/VQVYJlIF8rmPDlRZi
 NCiUtzbmhH/ZCRvUh8tCL1wKUQ==
X-Google-Smtp-Source: ABdhPJzhdjkHwgzmaGqOq1dE6kZDAT+wivTTIYKEWvX5CDhRyyg51yQJu64CEWkYgKmGA3S/ZHwb0Q==
X-Received: by 2002:adf:9525:: with SMTP id 34mr5210739wrs.389.1610468131478; 
 Tue, 12 Jan 2021 08:15:31 -0800 (PST)
Received: from google.com (49.222.77.34.bc.googleusercontent.com.
 [34.77.222.49])
 by smtp.gmail.com with ESMTPSA id r82sm4838130wma.18.2021.01.12.08.15.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 12 Jan 2021 08:15:30 -0800 (PST)
Date: Tue, 12 Jan 2021 16:15:28 +0000
From: Quentin Perret <qperret@google.com>
To: Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC PATCH v2 15/26] of/fdt: Introduce
 early_init_dt_add_memory_hyp()
Message-ID: <X/3LIGgx83XJ+U0F@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-16-qperret@google.com>
 <CAL_JsqLmzFWmTc=6JSRMofSEVRx9GCrwGxEsYog9dC16EMGdvQ@mail.gmail.com>
 <X/1xN2UxiUxkzAiN@google.com>
 <CAL_Jsq+5d+Ox_-m_Rd83R9xoZb6e2cxCNfbL8YPzKdwj=y0M8Q@mail.gmail.com>
 <X/2xlxx9Ucp4UZvL@google.com>
 <CAL_Jsq+o+t4YYXEW_nYqMsT4ubYJWe6Kdhu614RtrCqsHBtfLw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+o+t4YYXEW_nYqMsT4ubYJWe6Kdhu614RtrCqsHBtfLw@mail.gmail.com>
Cc: devicetree@vger.kernel.org, Android Kernel Team <kernel-team@android.com>,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Tuesday 12 Jan 2021 at 09:53:36 (-0600), Rob Herring wrote:
> On Tue, Jan 12, 2021 at 8:26 AM Quentin Perret <qperret@google.com> wrote:
> >
> > On Tuesday 12 Jan 2021 at 08:10:47 (-0600), Rob Herring wrote:
> > > On Tue, Jan 12, 2021 at 3:51 AM Quentin Perret <qperret@google.com> wrote:
> > > >
> > > > On Monday 11 Jan 2021 at 08:45:10 (-0600), Rob Herring wrote:
> > > > > On Fri, Jan 8, 2021 at 6:16 AM Quentin Perret <qperret@google.com> wrote:
> > > > > >
> > > > > > Introduce early_init_dt_add_memory_hyp() to allow KVM to conserve a copy
> > > > > > of the memory regions parsed from DT. This will be needed in the context
> > > > > > of the protected nVHE feature of KVM/arm64 where the code running at EL2
> > > > > > will be cleanly separated from the host kernel during boot, and will
> > > > > > need its own representation of memory.
> > > > >
> > > > > What happened to doing this with memblock?
> > > >
> > > > I gave it a go, but as mentioned in v1, I ran into issues for nomap
> > > > regions. I want the hypervisor to know about these memory regions (it's
> > > > possible some of those will be given to protected guests for instance)
> > > > but these seem to be entirely removed from the memblocks when using DT:
> > > >
> > > > https://elixir.bootlin.com/linux/latest/source/drivers/of/fdt.c#L1153
> > > >
> > > > EFI appears to do things differently, though, as it 'just' uses
> > > > memblock_mark_nomap() instead of actively removing the memblock. And that
> > > > means I could actually use the memblock API for EFI, but I'd rather
> > > > have a common solution. I tried to understand why things are done
> > > > differently but couldn't find an answer and kept things simple and
> > > > working for now.
> > > >
> > > > Is there a good reason for not using memblock_mark_nomap() with DT? If
> > > > not, I'm happy to try that.
> > >
> > > There were 2 patches to do that, but it never got resolved. See here[1].
> >
> > Thanks. So the DT stuff predates the introduction of memblock_mark_nomap,
> > that's why...
> >
> > By reading the discussions, [1] still looks a sensible patch on its own,
> > independently from the issue Nicolas tried to solve. Any reason for not
> > applying it?
> 
> As I mentioned in the thread, same patch with 2 different reasons. So
> I just wanted a better commit message covering both.

Sorry if I'm being thick, but I'm not seeing it. How are they the same?
IIUC, as per Nicolas' last reply, using memblock_mark_nomap() does not
solve his issue with a broken DT. These 2 patches address two completely
separate issues no?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
