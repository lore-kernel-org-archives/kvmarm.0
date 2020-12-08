Return-Path: <SRS0=0wdR=FM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24505C433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 10:05:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5B93C23A84
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 10:05:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B93C23A84
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B71E14B0CF;
	Tue,  8 Dec 2020 05:05:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xciWLPU6DYlE; Tue,  8 Dec 2020 05:05:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 805624B0E7;
	Tue,  8 Dec 2020 05:05:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28AC04B0CF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 05:05:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id whl4IKO6ZZDQ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2020 05:05:16 -0500 (EST)
Received: from mail-il1-f196.google.com (mail-il1-f196.google.com
 [209.85.166.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 185DF4B0B1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 05:05:16 -0500 (EST)
Received: by mail-il1-f196.google.com with SMTP id y9so15044837ilb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Dec 2020 02:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=6LnaMpP28AhPqELORDxpGyeiGhwKtr8NCKhAMEZEzqQ=;
 b=L+XfISbAFgIfxS87GxCrhYKiMlmtmU5q/4XzGt+1MaYqX7WC0zjKyC1Dp3QGCCvgnH
 4Gpgwf4v95REbXpzfOqs9IRRzSp79kxWAWGJd89bfzw+XjIeZFNMOMauWMNFCF3/3nt2
 zd8PEkloYYtPaNNZ+1G2lzwarlH9aEdIlkS+bJ43S7ldxD2c18GQqiWAoiTvqYQtW2X1
 ZI8us7flGSUPvGATq6ryamJYxE7fjGHSLVOgrTGr5FZwPIDy+OUoQnStdw3Gbk9OPwa2
 N3mCmhQI1e6ycPMeVeZN7Ty/aIbvbo+r1+8pKiWcvZQLGYs6YjDEzgDqvqZYdNvS8DF0
 OrvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=6LnaMpP28AhPqELORDxpGyeiGhwKtr8NCKhAMEZEzqQ=;
 b=pExG0XA5xgS2GKDGzxv3ANVm4sdOxZieUkrDi4JurZkxGIuZMXmIl4JD8+KwY19PY7
 0VJdtD2FgazbI7DU+JMUB0mlz7bEwDUJOwNcpfNARw8ALEBFXxqfBG4qEGOuwHPW0iOG
 7U+8cZY605o6fHinP8Vto9hXnco4eaFjay/RfwtoUWo9nt5azN9jSbS23kV3tWXtUTLM
 w02+dsO/F8uUn/Bfx6tk+Y49FqsAk0Vufky3Kpt7D7tpf3h+7FSZ1pBEv/wRUinGyIZH
 wB57mW4+TD3CQ1z2UQONZwLi+BTwk80WV+Y3iMfEBrIzlutjFfCxbgN/mKDHqbmq7IDv
 D1Ow==
X-Gm-Message-State: AOAM533aupo7+A8JnYLtYgqZkWNscu5CANXjNo4xEqJrzvmt9YW/Jljq
 3aW/inhhG1OHsjX4VEsvsf5OLIQWYIxaNyFcPrqV
X-Google-Smtp-Source: ABdhPJzbW06b3ZpO7gii59Pgjr48fjbD4MN+PTILyZ+espZo0UlzULDTEXFvIxozz3h4K7c5WAC4auSaiGwiH8gZ6m8=
X-Received: by 2002:a92:98db:: with SMTP id a88mr24921073ill.106.1607421915457; 
 Tue, 08 Dec 2020 02:05:15 -0800 (PST)
MIME-Version: 1.0
References: <20201119153901.53705-1-steven.price@arm.com>
 <CAFEAcA85fiqA206FuFANKbV_3GkfY1F8Gv7MP58BgTT81bs9kA@mail.gmail.com>
 <20201119184248.4bycy6ouvaxqdiiy@kamzik.brq.redhat.com>
 <db5ad775fa7cfe7defbd78d9ca6ccfd8@kernel.org>
 <c25c297e-e9b5-ab3f-e401-c21ddd4d2ad1@arm.com>
 <CAJc+Z1H7akXwDtVvQLiGVVyZ0DfmsxyJQhE7Sno6aAO9GaafEA@mail.gmail.com>
 <46fd98a2-ee39-0086-9159-b38c406935ab@arm.com>
 <CAFEAcA_Q8RSB-zcS8+cEfvWz_0U5GLzmsf12m_7BFjX8h-1hrA@mail.gmail.com>
 <b975422f-14fd-13b3-c8ca-e8b1a68c0837@arm.com> <20201207164428.GD3135@work-vm>
In-Reply-To: <20201207164428.GD3135@work-vm>
From: Haibo Xu <haibo.xu@linaro.org>
Date: Tue, 8 Dec 2020 18:05:04 +0800
Message-ID: <CAJc+Z1FbouCed4Hfc79CbuVtyKV-2=uiQQABtjPV0+drM=J5ZQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] MTE support for KVM guest
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Juan Quintela <quintela@redhat.com>,
 QEMU Developers <qemu-devel@nongnu.org>, Marc Zyngier <maz@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Steven Price <steven.price@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 dgibson@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 Dave Martin <Dave.Martin@arm.com>
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

On Tue, 8 Dec 2020 at 00:44, Dr. David Alan Gilbert <dgilbert@redhat.com> wrote:
>
> * Steven Price (steven.price@arm.com) wrote:
> > On 07/12/2020 15:27, Peter Maydell wrote:
> > > On Mon, 7 Dec 2020 at 14:48, Steven Price <steven.price@arm.com> wrote:
> > > > Sounds like you are making good progress - thanks for the update. Have
> > > > you thought about how the PROT_MTE mappings might work if QEMU itself
> > > > were to use MTE? My worry is that we end up with MTE in a guest
> > > > preventing QEMU from using MTE itself (because of the PROT_MTE
> > > > mappings). I'm hoping QEMU can wrap its use of guest memory in a
> > > > sequence which disables tag checking (something similar will be needed
> > > > for the "protected VM" use case anyway), but this isn't something I've
> > > > looked into.
> > >
> > > It's not entirely the same as the "protected VM" case. For that
> > > the patches currently on list basically special case "this is a
> > > debug access (eg from gdbstub/monitor)" which then either gets
> > > to go via "decrypt guest RAM for debug" or gets failed depending
> > > on whether the VM has a debug-is-ok flag enabled. For an MTE
> > > guest the common case will be guests doing standard DMA operations
> > > to or from guest memory. The ideal API for that from QEMU's
> > > point of view would be "accesses to guest RAM don't do tag
> > > checks, even if tag checks are enabled for accesses QEMU does to
> > > memory it has allocated itself as a normal userspace program".
> >
> > Sorry, I know I simplified it rather by saying it's similar to protected VM.
> > Basically as I see it there are three types of memory access:
> >
> > 1) Debug case - has to go via a special case for decryption or ignoring the
> > MTE tag value. Hopefully this can be abstracted in the same way.
> >
> > 2) Migration - for a protected VM there's likely to be a special method to
> > allow the VMM access to the encrypted memory (AFAIK memory is usually kept
> > inaccessible to the VMM). For MTE this again has to be special cased as we
> > actually want both the data and the tag values.
> >
> > 3) Device DMA - for a protected VM it's usual to unencrypt a small area of
> > memory (with the permission of the guest) and use that as a bounce buffer.
> > This is possible with MTE: have an area the VMM purposefully maps with
> > PROT_MTE. The issue is that this has a performance overhead and we can do
> > better with MTE because it's trivial for the VMM to disable the protection
> > for any memory.
>
> Those all sound very similar to the AMD SEV world;  there's the special
> case for Debug that Peter mentioned; migration is ...complicated and
> needs special case that's still being figured out, and as I understand
> Device DMA also uses a bounce buffer (and swiotlb in the guest to make
> that happen).
>
>
> I'm not sure about the stories for the IBM hardware equivalents.

Like s390-skeys(storage keys) support in Qemu?

I have read the migration support for the s390-skeys in Qemu and found
that the logic is very similar to that of MTE, except the difference that the
s390-skeys were migrated separately from that of the guest memory data
while for MTE, I think the guest memory tags should go with the  memory data.

>
> Dave
>
> > The part I'm unsure on is how easy it is for QEMU to deal with (3) without
> > the overhead of bounce buffers. Ideally there'd already be a wrapper for
> > guest memory accesses and that could just be wrapped with setting TCO during
> > the access. I suspect the actual situation is more complex though, and I'm
> > hoping Haibo's investigations will help us understand this.
> >
> > Thanks,
> >
> > Steve
> >
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
