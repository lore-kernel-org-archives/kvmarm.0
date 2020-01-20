Return-Path: <SRS0=lFwt=3J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD38C2D0DB
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 13:51:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2F36D217F4
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jan 2020 13:51:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QKzBNCVC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F36D217F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B36E4AEB4;
	Mon, 20 Jan 2020 08:51:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1hfM1K5CZITJ; Mon, 20 Jan 2020 08:51:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 147084AEF6;
	Mon, 20 Jan 2020 08:51:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95C104AEC3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 08:51:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cHgh2jo-WNFR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jan 2020 08:51:37 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 926C34AEB4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jan 2020 08:51:37 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579528297;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=LayzTmfI9tt8icMlZ4vxXXVEjOS+TCI8dYAoQTD0v24=;
 b=QKzBNCVCOeGek+x+Brs+MdoootA/cTLmls7PaOgBbsBZ4MWw7ebsCRwO18ErxGQkdHai7R
 4GmFRpzN6EWDxBdUgm4M8OntVsaOWCEqM8z9S277y9H8L7nn4Uv3NxLQyA4rDGNE8YXN4p
 8vZSPZQs+0LnAVnrSaqA8c/OtDio8Qc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-BitWFVWnPIGwIT2FxLW-Pg-1; Mon, 20 Jan 2020 08:51:34 -0500
X-MC-Unique: BitWFVWnPIGwIT2FxLW-Pg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A40C1005510;
 Mon, 20 Jan 2020 13:51:33 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 544C510013A7;
 Mon, 20 Jan 2020 13:51:32 +0000 (UTC)
Date: Mon, 20 Jan 2020 14:51:29 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] arm64: KVM: Add XXX UAPI notes for swapped registers
Message-ID: <20200120135129.tgucvvwbeef2q3js@kamzik.brq.redhat.com>
References: <20200120130825.28838-1-drjones@redhat.com>
 <99903fdb3e0d34cb7957981b484fc28c@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <99903fdb3e0d34cb7957981b484fc28c@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Mon, Jan 20, 2020 at 01:26:32PM +0000, Marc Zyngier wrote:
> Hi Andrew,
> 
> Many thanks for this. Comments below.
> 
> On 2020-01-20 13:08, Andrew Jones wrote:
> > Two UAPI system register IDs do not derive their values from the
> > ARM system register encodings. This is because their values were
> > accidentally swapped. As the IDs are API, they cannot be changed.
> > Add XXX notes to point them out.
> > 
> > Suggested-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  Documentation/virt/kvm/api.txt    |  8 ++++++++
> >  arch/arm64/include/uapi/asm/kvm.h | 11 +++++++++--
> >  2 files changed, 17 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/virt/kvm/api.txt
> > b/Documentation/virt/kvm/api.txt
> > index ebb37b34dcfc..11556fc457c3 100644
> > --- a/Documentation/virt/kvm/api.txt
> > +++ b/Documentation/virt/kvm/api.txt
> > @@ -2196,6 +2196,14 @@ arm64 CCSIDR registers are demultiplexed by
> > CSSELR value:
> >  arm64 system registers have the following id bit patterns:
> >    0x6030 0000 0013 <op0:2> <op1:3> <crn:4> <crm:4> <op2:3>
> > 
> > +XXX: Two system register IDs do not follow the specified pattern.
> > These
> > +     are KVM_REG_ARM_TIMER_CVAL and KVM_REG_ARM_TIMER_CNT, which map to
> > +     system registers CNTV_CVAL_EL0 and CNTVCT_EL0 respectively.  These
> > +     two had their values accidentally swapped, which means TIMER_CVAL
> > is
> > +     derived from the register encoding for CNTVCT_EL0 and TIMER_CNT is
> > +     derived from the register encoding for CNTV_CVAL_EL0.  As this is
> > +     API, it must remain this way.
> 
> Is 'XXX' an establiched way of documenting this kind of misfeature?
> I couldn't find any other occurrence in Documentation, but I haven't
> searched very hard.

I didn't find anything claiming it was the standard way of doing it. I
also considered using 'NOTE', but I was afraid it wouldn't stand out
as a "problem" enough. And, even though 'BUG' would certainly stand out,
I felt it implied we should be posting a fix.

Anyway, I'd be happy to change it to whatever the consensus is.

Thanks,
drew

> 
> If nobody has a better idea, I'll queue it as is.
> 
> Thanks,
> 
>         M.
> -- 
> Jazz is not dead. It just smells funny...
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
