Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B607FC4167B
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 01:23:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CD7C4291D;
	Tue, 29 Nov 2022 20:23:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XyF2eoNsfDVg; Tue, 29 Nov 2022 20:23:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 358AB43399;
	Tue, 29 Nov 2022 20:23:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AD324291D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2022 20:23:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6nVXNIFMFwOg for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Nov 2022 20:23:25 -0500 (EST)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C5C34B086
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2022 20:23:25 -0500 (EST)
Received: by mail-pl1-f180.google.com with SMTP id d6so15176819pll.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2022 17:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=ewUKpCuoaPzAR2fmrr+FD3H80AnrDry9LxbpWXLNvF4=;
 b=fb6DDgCaO06aAL+G5/T2sy0zhAJSlkluomnYowvIHNfrJbn2iaW5lHshIKewz5bOza
 ZaVgBpSB1cf2gMMANnU8K3AmjeUTIEKMNAbICy4G4jI4J2CpMNUvY/Js2ymp2Vkdcrpc
 I/d8R9iBlPs25vU0P4/h91XTk5DY/HLFSeS9bfgUuz+/VqMoOnk6kDmp8yWPVrf6tnND
 gTm4F2hpkbVA2broOTWoHcFoZM+TXUmFgKcJTGxHhtdYC50vDAMDfxB23yxt9I+Qq5xa
 Efw8DrsJ1oUnwHKABaYjsxPhyqo6wl960Zc0CTDg/x5TzQW5EkrrtjjLH6tEdMXomJIo
 QP7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=ewUKpCuoaPzAR2fmrr+FD3H80AnrDry9LxbpWXLNvF4=;
 b=VQq4HlcNaa8IQhkGRQuIGGZ+yQAd0Kf324yWBAYAVRK5w4C7pWQr8ZZae+HJi4axlV
 +F9SH2HpjhzpemLOnowr8s3HYDxdfDqRjeGDJ3Szot4Iri2qJPW2m9jRdks4sRb8YogB
 x6As8XJ0htuef5eCIvlZ0RT9KxbJ9/fVa+wdlHqBe7fxCIoJ2vsY3mesKhQo2NY400zJ
 kLEBdngZR4csvtGnM7mapI+cwNbo2eKgEUX6jUqyO5auQ2dEr7sCT7skgRh0dOxEIE27
 ALYd/HW7xC0SSaDm2uPQjQUdY/A3Si1JroBfQUMbcGSW5mkEeXWHclN7I/plxKk3aebv
 GqtA==
X-Gm-Message-State: ANoB5plrhMeXz80TFu5SAwnOzkw7KVl50Kqil4goGx/VqZmkEK1udrnz
 V8keSWPt6bx30qp0YHCH+MXfeA==
X-Google-Smtp-Source: AA0mqf7fkXBzPKsGf+r09kMkzskIdRv4AjvbWaWxjMbW/TRWAGLM3zhTZlBXjYYEDVoWL3AUhcc9xA==
X-Received: by 2002:a17:902:db07:b0:189:9ee0:cca4 with SMTP id
 m7-20020a170902db0700b001899ee0cca4mr4412610plx.74.1669771404345; 
 Tue, 29 Nov 2022 17:23:24 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 z3-20020aa79903000000b0056da63c8515sm119230pff.91.2022.11.29.17.23.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 29 Nov 2022 17:23:23 -0800 (PST)
Date: Tue, 29 Nov 2022 17:23:20 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 2/4] KVM: arm64: Don't serialize if the access flag isn't
 set
Message-ID: <Y4awiKLuKORZmU2z@google.com>
References: <20221129191946.1735662-1-oliver.upton@linux.dev>
 <20221129191946.1735662-3-oliver.upton@linux.dev>
 <Y4Zw/J3srTsZ57P7@google.com> <Y4Z2aWVEnluy+d3+@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y4Z2aWVEnluy+d3+@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Tue, Nov 29, 2022 at 09:15:21PM +0000, Oliver Upton wrote:
> Hi Ricardo,
> 
> Thanks for having a look.
> 
> On Tue, Nov 29, 2022 at 12:52:12PM -0800, Ricardo Koller wrote:
> > On Tue, Nov 29, 2022 at 07:19:44PM +0000, Oliver Upton wrote:
> 
> [...]
> 
> > > +	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> > > +				       &pte, NULL, 0);
> > > +	if (!ret)
> > > +		dsb(ishst);
> > 
> > At the moment, the only reason for stage2_update_leaf_attrs() to not
> > update the PTE is if it's not valid:
> > 
> > 	if (!kvm_pte_valid(pte))
> > 			return 0;
> > 
> > I guess you could check that as well:
> > 
> > +	if (!ret || kvm_pte_valid(pte))
> > +		dsb(ishst);
> 
> Thanks for catching this.
> 
> Instead of pivoting on the returned PTE value, how about we return
> -EAGAIN from the early return in stage2_attr_walker()? It would better
> match the pattern used elsewhere in the pgtable code.

That works, although I would use another return code (e.g., EINVAL)? as
that's not exactly a "try again" type of error.

> 
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
