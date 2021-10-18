Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0714C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 10:45:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3970961002
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 10:45:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3970961002
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99E714B1DC;
	Mon, 18 Oct 2021 06:45:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2xDS8X5oFJWg; Mon, 18 Oct 2021 06:45:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D4E94B239;
	Mon, 18 Oct 2021 06:45:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 599B34B20C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 06:45:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MFL0JHCCxM+A for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 06:45:10 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F7C44B1DC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 06:45:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1634553910;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=1uyCEHCiTKNcqpUO1aFErGSv7mBpXKpc6cxyusKebck=;
 b=VDwMAlHPj1TREGSw72d4kTXjfN2/5GmI34suUagaQBI0tLgcwhnP4WVpVwVjBYz6rl4YdE
 z7nVKQUrIRG9/WUw+vTH/CuR6X6/FDPO1RqxlFxrNeCfWN6E2ubAxqFR/9VUYfwbHLvh6F
 wGI97KZKDVCIZuAOiZ9WdY0vKGZ5TBc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-E1MsC6cJM9ODe0S9VokbsQ-1; Mon, 18 Oct 2021 06:45:09 -0400
X-MC-Unique: E1MsC6cJM9ODe0S9VokbsQ-1
Received: by mail-ed1-f71.google.com with SMTP id
 t28-20020a508d5c000000b003dad7fc5caeso13941910edt.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 03:45:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=1uyCEHCiTKNcqpUO1aFErGSv7mBpXKpc6cxyusKebck=;
 b=2nvpi5h1WfEj4BJpkBpv1RsqQWO434gGDTTgswNI3nI11nLDzhMbqh+16zjhD57LMF
 J1hnKr8nwGZMwtVRNVxsGd/1pHzDJ6IZlsX4o69zLV6lsfWC9fn1nYm7Ihg/h6MDlbmI
 C/ttdUoCG0VZIrcpWHP/qNlw+VtYtOPomZrsgfYC7ko3U7rcUvgX7tdEE2GPz96HEvJ2
 JMFEPNa585R/5Bx71XaeBlL9KBgC3iedQejMbKNO4wSwNG76GXkIO0XwuZfyQ/FYOmci
 dqoOpXDIHoUTVAd45zKibGbYkQJnzDkhWELCYIW/lD1CkdvhvHyZn++r4vMs/uzzXeZz
 r3Bg==
X-Gm-Message-State: AOAM530/O55m9baCubjlZfvae3wEy7cxsvWuWSWWP5A+Tfequ5pID9Bv
 bGvTG6tv7LmYc2P6MTf36A61f5gkI0lDHTCezqyB5hcQAf0nOzEEr+14YEpBsTD1HcR7LLIny7P
 0kGIgYXYMaMdw1uS3KSx1bWnl
X-Received: by 2002:a17:906:2606:: with SMTP id
 h6mr29039237ejc.301.1634553907943; 
 Mon, 18 Oct 2021 03:45:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0/tbTFUMN7jqyIWaGL6Z8CJvBwotkH9WB6m3QCyklG9WBS81dg1B+4X6yxbU7dGtDKT0pcQ==
X-Received: by 2002:a17:906:2606:: with SMTP id
 h6mr29039202ejc.301.1634553907748; 
 Mon, 18 Oct 2021 03:45:07 -0700 (PDT)
Received: from gator.home (cst2-174-2.cust.vodafone.cz. [31.30.174.2])
 by smtp.gmail.com with ESMTPSA id v13sm10285018edl.69.2021.10.18.03.45.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Oct 2021 03:45:07 -0700 (PDT)
Date: Mon, 18 Oct 2021 12:45:05 +0200
From: Andrew Jones <drjones@redhat.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v9 00/22] KVM: arm64: Fixed features for protected VMs
Message-ID: <20211018104505.52jvpuhxkbstzerg@gator.home>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
 <CA+EHjTxBW2fzSk5wMLceRwExqJwXGTtrK1GZ2L6J-Oh9VCDJJg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CA+EHjTxBW2fzSk5wMLceRwExqJwXGTtrK1GZ2L6J-Oh9VCDJJg@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kernel-team@android.com, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 pbonzini@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Mon, Oct 18, 2021 at 10:51:54AM +0100, Fuad Tabba wrote:
> Hi Marc,
> 
> On Wed, Oct 13, 2021 at 1:04 PM Marc Zyngier <maz@kernel.org> wrote:
> >
> > This is an update on Fuad's series[1].
> >
> > Instead of going going back and forth over a series that has seen a
> > fair few versions, I've opted for simply writing a set of fixes on
> > top, hopefully greatly simplifying the handling of most registers, and
> > moving things around to suit my own taste (just because I can).
> >
> > I won't be reposting the initial 11 patches, which is why this series
> > in is reply to patch 11.
> 
> Thanks for this series. I've reviewed, built it, and tested it with a
> dummy protected VM (since we don't have proper protected VMs yet),
> which initializes some of the relevant protected VMs metadata as well
> as its control registers. So fwiw:
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> 
> And to whatever extent possible at this stage:
> Tested-by: Fuad Tabba <tabba@google.com>
>

Hi Fuad,

Out of curiosity, when testing pKVM, what VMM do you use? Also, can you
describe what a "dummy pVM" is? Is it a just pVM which is not actually
protected? How similar is a pVM to a typical VIRTIO-using VM? Actually,
maybe I should just ask if there are instructions for playing with pKVM
somewhere that I could get a pointer to.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
