Return-Path: <SRS0=0wdR=FM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A13AC4361B
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 20:13:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 25FB223B26
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 20:13:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25FB223B26
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B55594B152;
	Tue,  8 Dec 2020 15:13:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k+S+VO5f+KHO; Tue,  8 Dec 2020 15:13:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8030E4B2B4;
	Tue,  8 Dec 2020 15:13:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C750D4B1A8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 15:02:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xi6qCfkmLV7U for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2020 15:02:59 -0500 (EST)
Received: from mail-qv1-f66.google.com (mail-qv1-f66.google.com
 [209.85.219.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EBC604B1C9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 15:02:58 -0500 (EST)
Received: by mail-qv1-f66.google.com with SMTP id l7so3462070qvt.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Dec 2020 12:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=FpPpi8VoMtsoCPIRy8jenvKh8eCrXui01GBoXCmAibc=;
 b=Gje8dhYAHnzmhozDV6nyAB+eibl0NgYpORU05kDPkIsFQm37tYrnN4/L5WpaA6uvS+
 +dHvy4ZXN5zo4qJlmIohacYz1zhwiR/rtYyTWwJJkoG/BYkpxYe4DqDiHWO1G0udLWou
 1SE763ZcU8jYBPs4Sw8FnjLo5u6/kP+LatT4YlexzoE/lP6uul6Bwq7qCPg8w9eQDohr
 GADmErF1mrU4ZhcphF1gcZDAHe1M4sEMEjXCsCP6RDQPv+yg+Ad6+iXiDc+OU9sLeEGp
 f10bwiv7KZrCdvjE52W3zNx8L0cQ8XX6FbT+jBECaVlKTrFlaRkYVNHsf/Nozqzzrro7
 qBuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=FpPpi8VoMtsoCPIRy8jenvKh8eCrXui01GBoXCmAibc=;
 b=lmkFA8kJxFWvl5H9Wr9zAQt4SmLhPdriPcqgT4imJC3wj8sznd68LciSzEc6TiwKt2
 V0dbBjVwzSCd8lUwpzNAmyBqeCgtYnjO0xw7Ee+LjbV2z7tQT7SQnFcPRKE7UhpEOFUl
 wC883EDj4BMKPS6NmpKne0k8bd0nhThNp1m1oDn7LTh0JdlOk+IfgRnh9dpHSG7CfOMX
 5+l1UI8bforx5xrKZSeFyvXM8HcxfOsL94FD2xZSezgNC9Jlxkm8aYlEgo2EIRi0WCuV
 P0PDDxYg3lrj8cKqxOvy6lrocuwCtKCUeZJtjLEFWEkA4FQOH4nRZFS+xKtj8wtLdqsV
 SCSw==
X-Gm-Message-State: AOAM531r3V/Mxj++k6sWUvwdkKI5F9VBTm+MH1cyZy/LmSZhXeShrsoS
 0ywluJbgfb0XiEYAGB5J1aLR/b42OvsCRZWVemkYdQ==
X-Google-Smtp-Source: ABdhPJwfAM3wWeibHv8RrcoIhrJYGQjLkXIowS5Q4MiQJ6CrIMru6ycDzCbJFu7Uh1Oc0y/LYVfq5je68a5SrPqTFLM=
X-Received: by 2002:ad4:59d2:: with SMTP id el18mr22835717qvb.35.1607457778234; 
 Tue, 08 Dec 2020 12:02:58 -0800 (PST)
MIME-Version: 1.0
References: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
 <20200817020310.GA1210848@jagdpanzerIV.localdomain>
 <fe72592c-c721-bece-1469-95eebf931299@huawei.com>
 <cbcfb402b7fdb8a2a45b80fbb0e79f3e@kernel.org>
 <20200911085841.GB562@jagdpanzerIV.localdomain>
In-Reply-To: <20200911085841.GB562@jagdpanzerIV.localdomain>
From: Joel Fernandes <joelaf@google.com>
Date: Tue, 8 Dec 2020 15:02:47 -0500
Message-ID: <CAJWu+oq26OK1-7Ze2pb5xpRJ-tS9wtXOdGFrYpHq+fhkyGhjkA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/4] arm64:kvm: teach guest sched that VCPUs can be
 preempted
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
X-Mailman-Approved-At: Tue, 08 Dec 2020 15:13:23 -0500
Cc: Marc Zyngier <maz@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Suleiman Souhlal <suleiman@google.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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

On Fri, Sep 11, 2020 at 4:58 AM Sergey Senozhatsky
<sergey.senozhatsky@gmail.com> wrote:
>
> My apologies for the slow reply.
>
> On (20/08/17 13:25), Marc Zyngier wrote:
> >
> > It really isn't the same thing at all. You are exposing PV spinlocks,
> > while Sergey exposes preemption to vcpus.
> >
>
> Correct, we see vcpu preemption as a "fundamental" feature, with
> consequences that affect scheduling, which is a core feature :)
>
> Marc, is there anything in particular that you dislike about this RFC
> patch set? Joel has some ideas, which we may discuss offline if that
> works for you.

Hi Marc, Sergey, Just checking what is the latest on this series?

About the idea me and Sergey discussed, at a high level we discussed
being able to share information similar to "Is the vCPU preempted?"
using a more arch-independent infrastructure. I do not believe this
needs to be arch-specific. Maybe the speciifc mechanism about how to
share a page of information needs to be arch-specific, but the actual
information shared need not be. This could open the door to sharing
more such information in an arch-independent way (for example, if the
scheduler needs to know other information such as the capacity of the
CPU that the vCPU is on).

Other thoughts?

thanks,

 - Joel
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
