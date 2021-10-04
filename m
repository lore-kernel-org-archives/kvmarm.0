Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9989AC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 15:48:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 19E5C61360
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 15:48:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 19E5C61360
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88D404B2A7;
	Mon,  4 Oct 2021 11:48:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7d5B70LPSkVQ; Mon,  4 Oct 2021 11:48:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 838AB4B2A6;
	Mon,  4 Oct 2021 11:48:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D300B4B2A5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 11:48:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JNs+ruAmdDHH for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 11:48:50 -0400 (EDT)
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com
 [209.85.215.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC47A4B2A8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 11:48:50 -0400 (EDT)
Received: by mail-pg1-f172.google.com with SMTP id q201so4288508pgq.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 08:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=2+QVME3jGaX4i+4s06oICt3IEB5F1SLw8aq76ldkx6M=;
 b=UMra/6DAPUEGVAl64opwRUJGSDSURdpDW8J1XYpxrQHqkqPa79+2Epym9qE4NswufM
 iSJYfb1NZ7WrTHW16xrNcj/koM+2VFUNKlA4pGoUjxAE3Dom2sZbGjj2tDSNvtrXlwgd
 2pYWIGYVjHmgK7y22qCZkA9rWxjTopKCCH223DH8UYnJ+GH+1xdmVFvJfflKYl682hXu
 DGgxVrODnzoPicd7sAsTOt+1qsbhCrUEP2FMEW27hRe1q65hHS13+/1fmc2gWftcdpFb
 rrBSz7PtQV83LINwFcG/4+uRzrbT/CyVTlqbsCuwtx3czddxnrl3Ua0bsl0vufCNiH0q
 rUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=2+QVME3jGaX4i+4s06oICt3IEB5F1SLw8aq76ldkx6M=;
 b=ivWRfLzWWnpLLZ3KRl3wXIpSwnBc7BSBPPs9VUje21MQQVJZzeGiJjdFaXIivYcPui
 GYHz6uGreHTfhrm7+V8iOGQ33I4Fqbit2LX1zoeBViGbzEZuJH+YxZqUrYZ2Em2GuZbT
 d448YxyR1I3BfISkq8naW/KDhQw4fRF3/d19QMSqR/cs8q9B8AMIux9llWn3VWDRDKD4
 EkatSrAF8a5h+rQmMAnFm14UotWm6KWnBAHXiBecPxEesV1ufnJBwGiKDjYNoC7E8NnH
 u1DGmIlRol8ySpdJqTcs20TGhHzxQghFg2+VsB1Vc5hEvo6MrHUjaaoGJxGCESSmuf52
 Ac6w==
X-Gm-Message-State: AOAM531nCi9O6aXQ+A+p7V0uBIiIsLmTWqQQc6E3AzLhEdyf5ncZQ62j
 haMi3IU2a5+HewoToCvD0S2dYQ==
X-Google-Smtp-Source: ABdhPJxJsWjoIvrmIZg9ung+Ty/mnWFZBl04uc7InBbcLjywVlqeNBL2YDyrTzIOAh/1YDgsXq/ovA==
X-Received: by 2002:a05:6a00:c8c:b0:447:bddb:c83 with SMTP id
 a12-20020a056a000c8c00b00447bddb0c83mr26862283pfv.1.1633362529436; 
 Mon, 04 Oct 2021 08:48:49 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id h4sm4880532pjm.14.2021.10.04.08.48.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Oct 2021 08:48:48 -0700 (PDT)
Date: Mon, 4 Oct 2021 08:48:45 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 01/10] kvm: arm64: vgic: Introduce vgic_check_iorange
Message-ID: <YVsiXYFKSG/C4dGD@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-2-ricarkol@google.com>
 <4ab60884-e006-723a-c026-b3e8c0ccb349@redhat.com>
 <YVTX1L8u8NMxHAyE@google.com>
 <1613b54f-2c4b-a57a-d4ba-92e866c5ff1f@redhat.com>
 <YVYp1E7bqIFttXF+@google.com> <87k0iwsxce.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87k0iwsxce.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, shuah@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On Fri, Oct 01, 2021 at 02:12:17PM +0100, Marc Zyngier wrote:
> On Thu, 30 Sep 2021 22:19:16 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Thu, Sep 30, 2021 at 09:02:12AM +0200, Eric Auger wrote:
> > > Hi,
> > > 
> > > On 9/29/21 11:17 PM, Ricardo Koller wrote:
> > > > On Wed, Sep 29, 2021 at 06:29:21PM +0200, Eric Auger wrote:
> > > >> Hi Ricardo,
> > > >>
> > > >> On 9/28/21 8:47 PM, Ricardo Koller wrote:
> > > >>> Add the new vgic_check_iorange helper that checks that an iorange is
> > > >>> sane: the start address and size have valid alignments, the range is
> > > >>> within the addressable PA range, start+size doesn't overflow, and the
> > > >>> start wasn't already defined.
> > > >>>
> > > >>> No functional change.
> > > >>>
> > > >>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > >>> ---
> > > >>>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 22 ++++++++++++++++++++++
> > > >>>  arch/arm64/kvm/vgic/vgic.h            |  4 ++++
> > > >>>  2 files changed, 26 insertions(+)
> > > >>>
> > > >>> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > > >>> index 7740995de982..f714aded67b2 100644
> > > >>> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > > >>> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > > >>> @@ -29,6 +29,28 @@ int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
> > > >>>  	return 0;
> > > >>>  }
> > > >>>  
> > > >>> +int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
> > > >>> +		       phys_addr_t addr, phys_addr_t alignment,
> > > >>> +		       phys_addr_t size)
> > > >>> +{
> > > >>> +	int ret;
> > > >>> +
> > > >>> +	ret = vgic_check_ioaddr(kvm, ioaddr, addr, alignment);
> > > >> nit: not related to this patch but I am just wondering why we are
> > > >> passing phys_addr_t *ioaddr downto vgic_check_ioaddr and thus to
> > > >>
> > > >> vgic_check_iorange()? This must be a leftover of some old code?
> > > >>
> > > > It's used to check that the base of a region is not already set.
> > > > kvm_vgic_addr() uses it to make that check;
> > > > vgic_v3_alloc_redist_region() does not:
> > > >
> > > >   rdreg->base = VGIC_ADDR_UNDEF; // so the "not already defined" check passes
> > > >   ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);
> > > Yes but I meant why a pointer?
> > 
> > I can't think of any good reason. It must be some leftover as you said.
> 
> It definitely is. Please have a patch to fix that. Also, it doesn't
> look like vgic_check_ioaddr() has any other user at the end of the
> series. Worth getting rid of.

ACK fixing that and getting rid of vgic_check_ioaddr().

Thanks,
Ricardo

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
