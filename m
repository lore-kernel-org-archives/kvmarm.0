Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D356C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jul 2022 21:17:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAAFF4D909;
	Wed, 20 Jul 2022 17:17:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8aOBk7cREpqy; Wed, 20 Jul 2022 17:17:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8562D4D90D;
	Wed, 20 Jul 2022 17:17:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71F1F4D909
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 17:17:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WgfTxOIV86eP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2022 17:17:15 -0400 (EDT)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C5744D908
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 17:17:15 -0400 (EDT)
Received: by mail-pl1-f170.google.com with SMTP id w7so3671485plp.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 14:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=tQHyBpRSTCYBnbK0Fk3s8ggzdCtx/PSGX/g/RqDYeCY=;
 b=fGWF+358TslHXlxBmpEYiwgEzF5sORn15yu/rsarTVfNc7KeRD5pY93dFBpzQjDizT
 wbRGNgYa4gD4dngtKRr8cDciJquwlW55cR7IsqGZXcrorfhiwf/8j9j3sNQLn2oiVUAY
 A6vn/BvNjBJypZaK+WiSXefLIOOBhxakvq9Gl7zE8I3aHeGCbR/8s6HXd6KA8qZ+Nen1
 CRrLbMguE4G8Nmhw+QUsW17FAoDrN8VN7mCywerEDf8jjHmpfOdtdZiMfmsa61twNlFU
 Sp5TLU6N6TC5uRcPDRJClm6l4aFLNqnLS8qFNsBAC2J9cdEWL3GSosp/TvNyzgDRa2Kq
 B0lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=tQHyBpRSTCYBnbK0Fk3s8ggzdCtx/PSGX/g/RqDYeCY=;
 b=jWX620TTeG8wD0e0W4uuvfuSLrJ3vJONHwRp+UhEjgJQsmpfm5cjKNHdf2qHK0RtNI
 YYN+KMF3bL3VIhK7KCryEtrAXxLwWdxgogqCNyu/nMdVrHqxHDhnalrcnkxRqK01TJc9
 IzrmF4AcCZvIQt7Y8fGf+o7UMlR6cbNmjCpgiFTHClnfkLC4at4IQlZI1JOjqV6dNouZ
 /lmFkLAAWRsk03IhL8323QoEnjg99LVQ5pNvGGPxvBIx8xyzdpv8TVloxO/HdC1WVH+H
 7jXckudqH+5NWE/LQV77IRwawlULbXPlu7YqRGJeXUta3xfGe8iJFZRr5ThpcTe+9bbV
 hCqw==
X-Gm-Message-State: AJIora9RzSYomGGhEgmI8cbS8e3KbCq/yzANsyubCJfK8sURjT+8POWJ
 hYwr2654oLBZKhcIuqYx9deAjw==
X-Google-Smtp-Source: AGRyM1vDHPOlYpgyqZYYJMzbqy0L7voAhL5Adrluh21PEp9U4e1Rn3MopGX0XhMrQ293NsnS71mTdg==
X-Received: by 2002:a17:902:efc4:b0:16d:20ea:44f4 with SMTP id
 ja4-20020a170902efc400b0016d20ea44f4mr4954173plb.113.1658351833935; 
 Wed, 20 Jul 2022 14:17:13 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 l1-20020a63f301000000b00415320bc31dsm12379320pgh.32.2022.07.20.14.17.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 20 Jul 2022 14:17:12 -0700 (PDT)
Date: Wed, 20 Jul 2022 14:17:09 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [kvm-unit-tests PATCH 3/3] arm: pmu: Remove checks for !overflow
 in chained counters tests
Message-ID: <Ythw1UT1wFHbY/jN@google.com>
References: <20220718154910.3923412-1-ricarkol@google.com>
 <20220718154910.3923412-4-ricarkol@google.com>
 <87edyhz68i.wl-maz@kernel.org> <Yte/YXWYSikyQcqh@google.com>
 <875yjsyv67.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <875yjsyv67.wl-maz@kernel.org>
Cc: drjones@redhat.com, kvm@vger.kernel.org, oliver.upton@linux.dev,
 kvmarm@lists.cs.columbia.edu
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

On Wed, Jul 20, 2022 at 10:45:20AM +0100, Marc Zyngier wrote:
> On Wed, 20 Jul 2022 09:40:01 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Tue, Jul 19, 2022 at 12:34:05PM +0100, Marc Zyngier wrote:
> > > On Mon, 18 Jul 2022 16:49:10 +0100,
> > > Ricardo Koller <ricarkol@google.com> wrote:
> > > > 
> > > > A chained event overflowing on the low counter can set the overflow flag
> > > > in PMOVS.  KVM does not set it, but real HW and the fast-model seem to.
> > > > Moreover, the AArch64.IncrementEventCounter() pseudocode in the ARM ARM
> > > > (DDI 0487H.a, J1.1.1 "aarch64/debug") also sets the PMOVS bit on
> > > > overflow.
> > > 
> > > Isn't this indicative of a bug in the KVM emulation? To be honest, the
> > > pseudocode looks odd. It says:
> > > 
> > > <quote>
> > > 	if old_value<64:ovflw> != new_value<64:ovflw> then
> > > 	    PMOVSSET_EL0<idx> = '1';
> > > 	    PMOVSCLR_EL0<idx> = '1';
> > > </quote>
> > > 
> > > which I find remarkably ambiguous. Is this setting and clearing the
> > > overflow bit? Or setting it in the single register that backs the two
> > > accessors in whatever way it can?
> > > 
> > > If it is the second interpretation that is correct, then KVM
> > > definitely needs fixing
> > 
> > I think it's the second, as those two "= '1'" apply to the non-chained
> > counters case as well, which should definitely set the bit in PMOVSSET.
> > 
> > > (though this looks pretty involved for
> > > anything that isn't a SWINC event).
> > 
> > Ah, I see, there's a pretty convenient kvm_pmu_software_increment() for
> > SWINC, but a non-SWINC event is implemented as a single 64-bit perf
> > event.
> 
> Indeed. Which means we need to de-optimise chained counters to being
> 32bit events, which is pretty annoying (for rapidly firing events, the
> interrupt rate is going to be significantly higher).
> 
> I guess we should also investigate the support for FEAT_PMUv3p5 and
> native 64bit counters. Someone is bound to build it at some point.

The kernel perf event is implementing 64-bit counters using chained
counters. I assume this is already firing an interrupt for the low
counter overflow; we might need to just hook into that, investigating...

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
