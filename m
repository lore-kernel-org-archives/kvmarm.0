Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E8DC10F13
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 19:36:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 21C7A2083E
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 19:36:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="GsBfuMaH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21C7A2083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDB354A479;
	Mon,  8 Apr 2019 15:36:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VESRHEHB+ocx; Mon,  8 Apr 2019 15:36:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8CE14A47D;
	Mon,  8 Apr 2019 15:36:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CCC04A3B2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 13:18:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G85IPaykEQbE for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Apr 2019 13:18:49 -0400 (EDT)
Received: from mail-io1-f67.google.com (mail-io1-f67.google.com
 [209.85.166.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E91204A382
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 13:18:48 -0400 (EDT)
Received: by mail-io1-f67.google.com with SMTP id x7so11733833ioh.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Apr 2019 10:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=I0hrpN+n/xSYHN63HyWBfrYsRb+kkodDIb8th+w7s5I=;
 b=GsBfuMaHUMFMyzJ3V3cYar4SzFP84sahUwvImGTlosHxgTZML0TQ8i1Rxrf9pna63Z
 +8iTfa7HdE19DVDqKIJisqZotDWqq9S47+ynqm4pFCv6ZPYmzSV690VRArTsGR1DyZPf
 MKARniVRmy644xNGCuq33rBCsv5PtLXOyAi42pi8YgUk4mqoysEYP8L/Pi1g5R+ZC//I
 lCteEbGd0wMnzni/h33aVERpQwfaU/omsrfuFQsTNIpd7LG93gh3uCn1A3wr2+lp506n
 kdA69KJXF50ka1HlRteSgnLoa3qoc5nhbqyWiZpoQlKJoxCYCmKE/754f2o80y7XGBPD
 jc0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=I0hrpN+n/xSYHN63HyWBfrYsRb+kkodDIb8th+w7s5I=;
 b=sjtYioFm3KhePEFMLR+0SH60pBGL7XBhaDm4hGUiZuAfgCd2wmemlpzLln4E1YTXXw
 omDj7Y6IEbm7wmdJytJfzLaMYnTxrc6waEmDEIt29+U6pW6U2K1UXQ2XyV/+v2F9F4mG
 gopFxclKPN2UB9Dag4m+R7umDAgcNgpQ1QupTiRm9CbmmIw7v+N28u/crX+KfVBAtiLD
 Ujnw3411ZGty11j27T/wpt59AmWqtwp+dBTh4cttpN5pxB5OhHipKNJjgMruA/62RTOk
 OOUyDRAEKebXQAdvQ/FkNJX3crti3AWVIEcX81LPEO6zP/etNAeWSQB5xJ032GygSuIc
 imgw==
X-Gm-Message-State: APjAAAWYScolcc8PS6U0ctAi9rgfDaATjj4xr+TTV8750U20rfBbNRLE
 /i300eo7kTWys0Irsd7clcKXyg==
X-Google-Smtp-Source: APXvYqxYY5wiGAUEvbwJM7zFq7gs6fRUiI1Rxe3i35EIz8JlwJ7p7elg72cgSIhhFLj69XH5vFY/kQ==
X-Received: by 2002:a6b:d119:: with SMTP id l25mr20027875iob.278.1554743927679; 
 Mon, 08 Apr 2019 10:18:47 -0700 (PDT)
Received: from google.com ([2620:15c:183:0:a0c3:519e:9276:fc96])
 by smtp.gmail.com with ESMTPSA id w4sm11647834ioa.38.2019.04.08.10.18.46
 (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
 Mon, 08 Apr 2019 10:18:47 -0700 (PDT)
Date: Mon, 8 Apr 2019 11:18:42 -0600
From: Yu Zhao <yuzhao@google.com>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH V2] KVM: ARM: Remove pgtable page standard functions from
 stage-2 page tables
Message-ID: <20190408171842.GA218114@google.com>
References: <3be0b7e0-2ef8-babb-88c9-d229e0fdd220@arm.com>
 <1552397145-10665-1-git-send-email-anshuman.khandual@arm.com>
 <20190401161638.GB22092@fuggles.cambridge.arm.com>
 <20190401183425.GA106130@google.com>
 <20190402090349.GA25936@fuggles.cambridge.arm.com>
 <20190408142212.GA4331@fuggles.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190408142212.GA4331@fuggles.cambridge.arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailman-Approved-At: Mon, 08 Apr 2019 15:36:35 -0400
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190408171842.mFSqttf0mdsPQhTEbuDKTH4wZHwUVZYk4zeZpkg135w@z>

On Mon, Apr 08, 2019 at 03:22:38PM +0100, Will Deacon wrote:
> On Tue, Apr 02, 2019 at 10:04:30AM +0100, Will Deacon wrote:
> > On Mon, Apr 01, 2019 at 12:34:25PM -0600, Yu Zhao wrote:
> > > On Mon, Apr 01, 2019 at 05:16:38PM +0100, Will Deacon wrote:
> > > > [+KVM/ARM folks, since I can't take this without an Ack in place from them]
> > > > 
> > > > My understanding is that this patch is intended to replace patch 3/4 in
> > > > this series:
> > > > 
> > > > http://lists.infradead.org/pipermail/linux-arm-kernel/2019-March/638083.html
> > > 
> > > Yes, and sorry for the confusion. I could send an updated series once
> > > this patch is merged. Thanks.
> > 
> > That's alright, I think I'm on top of it (but I'll ask you to check whatever
> > I end up merging). Just wanted to make it easy for the kvm folks to dive in
> > with no context!
> 
> Ok, I've pushed this out onto a temporary branch before I merge it into
> -next:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=pgtable-ctors
> 
> Please can you confirm that it looks ok?

LGTM, thanks.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
