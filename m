Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00367C352A1
	for <kvmarm@archiver.kernel.org>; Tue,  6 Dec 2022 18:10:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63A5840C80;
	Tue,  6 Dec 2022 13:10:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kGiYO4xdXYqS; Tue,  6 Dec 2022 13:10:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 331B54B3D0;
	Tue,  6 Dec 2022 13:10:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AEE141016
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 13:10:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QghjjIWOM88t for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2022 13:10:37 -0500 (EST)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8CB7140C80
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 13:10:37 -0500 (EST)
Received: by mail-pl1-f170.google.com with SMTP id w23so14700564ply.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Dec 2022 10:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=gAdL/5nVVJu1FQlGTdfBjUls0ERNiH40RtP9DKw3LIs=;
 b=l9AGT4fXhM1oH7Du6wFnaTWjSCn3ASy0EdsFYwoxpz1XTmSJrI/6IYPrztRWGtgphI
 MEU1JwB6naZw7c/1ettMldjjpLk7glwpCWqV3EXpRuhUI+cM9iyuVCU+X8uFtQpMw16H
 y+VgP6Yz+mAMFxaAy3HgfBPOTFYdo5y/iogmk26sWTFOPpJyLaBDhg94MEROnHf5IE94
 nWYww6CfABnUnL1AnWY2Cgwf8IRzYPXH3CPErKTJKwYOxZqve3srRPJGRu+YDWCJOMyj
 ciVWMbA+0QFhqsdHTxv5x8llaaAKjhSyqtXi87fJCtsbFm+lXv45WSeSP6LhgyyqgED4
 rVjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=gAdL/5nVVJu1FQlGTdfBjUls0ERNiH40RtP9DKw3LIs=;
 b=cX/TTuD5nzE8mjGCJ5FViryY91NfXKhjfhuQHtUPup/mwIR+ui/UJDkwxqBoiL889X
 9bt0wyKW67dece/Xj0MbN96gJE4ev17j08hWjKrAT1U45F9y/zrn221Hkjuo/YBSuKA9
 AJDj9FPSkgFZS3uUhU0ptlETbuUlZOkvHW/3rv/vUFSqCeT30QC3bN0zKqU+qvFt1nQ9
 S9Gdzd25JuFAAiIrGPI2rtjRHt71oXP1QtmIEYZZBH5HIUuh+qDFlmPJDR26Ah3aon6Z
 7fvgVxYw2LOVmlXcMIo7L29pd5LyV43CeSZtni9Ovwawiwq274nA90tiTO6re6KVbNit
 jwxA==
X-Gm-Message-State: ANoB5pko5QJ1xoUSl59GNM5lcjZ/g1hRPPXEvTgewxyIZQdAZqpvOclh
 qwg0z8Vhhvg4XQBH5FKUFy5d5A==
X-Google-Smtp-Source: AA0mqf5SWGEOLKnaGxze9XgAsm4nFZyJ++7ROo35teN3Ikc66p+MXKu2i9uybgiJng0VsXfgkbFF9Q==
X-Received: by 2002:a17:90a:c68d:b0:219:d415:d787 with SMTP id
 n13-20020a17090ac68d00b00219d415d787mr11690151pjt.127.1670350236316; 
 Tue, 06 Dec 2022 10:10:36 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 x14-20020a170902ec8e00b001897916be2bsm12957433plg.268.2022.12.06.10.10.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 06 Dec 2022 10:10:35 -0800 (PST)
Date: Tue, 6 Dec 2022 18:10:32 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
Message-ID: <Y4+FmDM7E5WYP3zV@google.com>
References: <20221205155845.233018-1-maz@kernel.org>
 <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Usama Arif <usama.arif@bytedance.com>,
 Bagas Sanjaya <bagasdotme@gmail.com>, Ben Gardon <bgardon@google.com>,
 "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Marek Szyprowski <m.szyprowski@samsung.com>, Marc Zyngier <maz@kernel.org>,
 Steven Price <steven.price@arm.com>, linux-arm-kernel@lists.infradead.org,
 Jakub Kicinski <kuba@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Brown <broonie@kernel.org>,
 kvmarm@lists.linux.dev, Peter Collingbourne <pcc@google.com>,
 Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>, Zhiyuan Dai <daizhiyuan@phytium.com.cn>,
 Andrew Morton <akpm@linux-foundation.org>
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

On Tue, Dec 06, 2022, Paolo Bonzini wrote:
> On 12/5/22 16:58, Marc Zyngier wrote:
> > - There is a lot of selftest conflicts with your own branch, see:
> > 
> >    https://lore.kernel.org/r/20221201112432.4cb9ae42@canb.auug.org.au
> >    https://lore.kernel.org/r/20221201113626.438f13c5@canb.auug.org.au
> >    https://lore.kernel.org/r/20221201115741.7de32422@canb.auug.org.au
> >    https://lore.kernel.org/r/20221201120939.3c19f004@canb.auug.org.au
> >    https://lore.kernel.org/r/20221201131623.18ebc8d8@canb.auug.org.au
> > 
> >    for a rather exhaustive collection.
> 
> Yeah, I saw them in Stephen's messages but missed your reply.
> 
> In retrospect, at least Gavin's series for memslot_perf_test should have
> been applied by both of us with a topic branch, but there's so many
> conflicts all over the place that it's hard to single out one series.
> It just happens.

Alternatively, we could have a dedicated selftests/kvm tree (or branch)?

I almost suggested doing that on multiple occasions this cycle, but ultimately
decided not to because it would effectively mean splitting series that touch KVM
and selftests into different trees, which would create a different kind of
dependency hell.  Or maybe a hybrid approach where series that only (or mostly?)
touch selftests go into a dedicated tree?

I get the feeling that I'm overthinking things though, this level of activity and
conflicts should be relatively rare.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
