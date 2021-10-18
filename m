Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B91CC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 12:34:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 940D9604E9
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 12:34:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 940D9604E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA5CC4B282;
	Mon, 18 Oct 2021 08:34:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FR+Aq6uZDs9u; Mon, 18 Oct 2021 08:34:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D10094B208;
	Mon, 18 Oct 2021 08:34:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F0BF4B265
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 08:34:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TvfMLgHMl5fM for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 08:34:31 -0400 (EDT)
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com
 [209.85.210.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7EC894B208
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 08:34:31 -0400 (EDT)
Received: by mail-ot1-f52.google.com with SMTP id
 b4-20020a9d7544000000b00552ab826e3aso3662762otl.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 05:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=1pbSkqWxiSZgJ8e5OjIcgFH/1bBQSml1rT02P7vRiI8=;
 b=Mgez5oeoSkR2Rfz90An/K8bMShcEt62O9xMJHG2RoiYEVmzfIBQxHJ4d5vdTZ6v31H
 L0IT059zRHYOmef8sJmO1oflziQY7bbPRfhrja6d7dtbka+dM6x6L8/4FQOfHwB26wdv
 kY7Gh2SM5lI9RuTLn0YbJB9veeZN+M3KRADX5Yv1nSFP5i99IGPTCpAC5P0T7Wt9HtuN
 uNmuTJkg4ag9DNYfCqh9pbvTVWwOx6ZiLp1tKrtkJs3JcmYE6DxAi+M/E8NdiyFFVRwY
 LXRR+V84Bqp2JG2NInoUALz+Q5xh7vVpNXCVVZpk8JAD8PYdsSzJUQfE30kYhpzXQ/Lm
 ne3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=1pbSkqWxiSZgJ8e5OjIcgFH/1bBQSml1rT02P7vRiI8=;
 b=tUxnaoC8qb3RlfwTXCNp9Jv2vdoibpCGs7qyiGf65wRJe0IEGAhG3WAsf8YVktxgYn
 3hadf76D92INcQB7XjfqeSdRVw+9VnzZXHo66hrsHq4zV0JORIPWpqpn2rfwuElHoBbi
 L7pM/g5MNa6Y4GKiW35aXFuEekeL9F8g2f2Z2hmZX/uww4kLkejT1aDh5LXqVulkgiX6
 naw9dCIOqs5DzAJpVRb/W0V/RihLabVpnsRQE4lXf2Z5E8cI0nFN7fxIbkWGXUpFSQRs
 Byuw74Mo+cUvLxST/f/mxja1ub0LOdq4GSQL2o4zuDEpkNFwtMoHYlsBZZ3uCAyFbEpG
 e9+A==
X-Gm-Message-State: AOAM531RkvokWgNZA8SMsU+esP3gg1CRYrsHslfqbq0sdEnU/0ftcdr3
 AJFSvzGQ/v2Y7o3q4Blwz7fZuLsH1X5L1dwPXP26lw==
X-Google-Smtp-Source: ABdhPJwmLCo4x7wGytVHP4ezHwU7qhNTDaKBXu8Z84dYPzNngqLyw3XKmfneyTsFw7kja67groR2U7W6EsbitXQCZTU=
X-Received: by 2002:a05:6830:210c:: with SMTP id
 i12mr21214780otc.102.1634560470718; 
 Mon, 18 Oct 2021 05:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
 <CA+EHjTxBW2fzSk5wMLceRwExqJwXGTtrK1GZ2L6J-Oh9VCDJJg@mail.gmail.com>
 <20211018104505.52jvpuhxkbstzerg@gator.home>
In-Reply-To: <20211018104505.52jvpuhxkbstzerg@gator.home>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 18 Oct 2021 13:33:54 +0100
Message-ID: <CA+EHjTyDMMMp_jzdfL-OUoBv0YU8pbxMnCu4vErVCex7wHa6bw@mail.gmail.com>
Subject: Re: [PATCH v9 00/22] KVM: arm64: Fixed features for protected VMs
To: Andrew Jones <drjones@redhat.com>
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

Hi,

On Mon, Oct 18, 2021 at 11:45 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Oct 18, 2021 at 10:51:54AM +0100, Fuad Tabba wrote:
> > Hi Marc,
> >
> > On Wed, Oct 13, 2021 at 1:04 PM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > This is an update on Fuad's series[1].
> > >
> > > Instead of going going back and forth over a series that has seen a
> > > fair few versions, I've opted for simply writing a set of fixes on
> > > top, hopefully greatly simplifying the handling of most registers, and
> > > moving things around to suit my own taste (just because I can).
> > >
> > > I won't be reposting the initial 11 patches, which is why this series
> > > in is reply to patch 11.
> >
> > Thanks for this series. I've reviewed, built it, and tested it with a
> > dummy protected VM (since we don't have proper protected VMs yet),
> > which initializes some of the relevant protected VMs metadata as well
> > as its control registers. So fwiw:
> >
> > Reviewed-by: Fuad Tabba <tabba@google.com>
> >
> > And to whatever extent possible at this stage:
> > Tested-by: Fuad Tabba <tabba@google.com>
> >
>
> Hi Fuad,
>
> Out of curiosity, when testing pKVM, what VMM do you use? Also, can you
> describe what a "dummy pVM" is? Is it a just pVM which is not actually
> protected? How similar is a pVM to a typical VIRTIO-using VM? Actually,
> maybe I should just ask if there are instructions for playing with pKVM
> somewhere that I could get a pointer to.

Considering the WIP state of pKVM, my setup is hacky and not that
stable. I use QEMU, along with Will'ls pKVM user ABI patches [*] and a
couple of hacks added on top to run a normal VM with the protected
codepath applied to it, to be able to do some testing and sanity
checking. There isn't really any proper way of playing with protected
VMs yet.

Thanks,
/fuad

[*] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/

> Thanks,
> drew
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
