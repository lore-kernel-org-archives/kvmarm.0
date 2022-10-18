Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68DF9C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 18 Oct 2022 15:51:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA6EE4B881;
	Tue, 18 Oct 2022 11:51:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r24Cpkz8EijC; Tue, 18 Oct 2022 11:51:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77F084B890;
	Tue, 18 Oct 2022 11:51:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1026C4B881
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Oct 2022 11:51:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WxY6POC6iFLu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Oct 2022 11:51:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 016904B87A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Oct 2022 11:51:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1666108266;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=BoKkcuxL5NREz5vjMqNcHiKa9FwvH6HgAB/kBFDCW9w=;
 b=EVk6DkR0bDh7yFQeh26xG1LOrKSa8m/AyEXdIqcK29MDFF7xwn0tMW0gk98z5Hext7j7Kl
 piyZAL88kIDJRvQiv8mHyXRL7X3ctNWw88dsjMNcrux92z1Fn8gJrsApgzNMSqMysuJUS0
 SPOs2YcsLC/8/wtihjPNIJDl5GyAYKo=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-418-8-cclLocPoiWpYXzNnbb0w-1; Tue, 18 Oct 2022 11:51:05 -0400
X-MC-Unique: 8-cclLocPoiWpYXzNnbb0w-1
Received: by mail-io1-f71.google.com with SMTP id
 w6-20020a6bd606000000b006bcd951c261so7647077ioa.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Oct 2022 08:51:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=BoKkcuxL5NREz5vjMqNcHiKa9FwvH6HgAB/kBFDCW9w=;
 b=OXbgZSOPaGtBZtdEhsRMX3eGnd5C3oa+IpPjIa7WlQ5Uo2EEQ9CeAslEKgttVAgqoG
 47/9CVxbj4fUrIwyzEw/bpIynGqf83g39foMrrpt8xj8yHGIgToMaH3WCXrgrzw1L20A
 UZQEFap57t077xhd27uao89gEmf+PuJx1FDgpUACWo0HIWFuX/lVuv7FLxMlorKeLqyN
 KkESGHio9fLVNMySBi135O+voBRKgjEOS5wqFd9NNJomZkf6+h8zp24fiXOEv/alJ+dR
 BbwEpdmRkeFNOs9WwTUYyaHL9aqNPPtZjphexvAZLkTqNBH7JUcqyPdi9cG/Z5CkJFmP
 3/Lw==
X-Gm-Message-State: ACrzQf19dahwobibcS7HDwb2JKxVOAjlyEM2aVBAYo6aEupLXp1zfDrK
 HoEP/wZoLyQWbS0hIiLpKRZIWLQS2OsU9tjl/lFWRum7rRarDO1qAm7fP/ZSETf9FyLHKHi2vwB
 NSMPcb81Ba+YSLZvTFE+Fg4g9
X-Received: by 2002:a05:6638:1903:b0:363:e824:2193 with SMTP id
 p3-20020a056638190300b00363e8242193mr2260582jal.40.1666108264898; 
 Tue, 18 Oct 2022 08:51:04 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7rTkkIhDBNg5wS6havwCc+dTDzEUFDvH98GZ+b7II2SM5/9WtuFcl6vpreWjVh7ZL84I5kVw==
X-Received: by 2002:a05:6638:1903:b0:363:e824:2193 with SMTP id
 p3-20020a056638190300b00363e8242193mr2260559jal.40.1666108264633; 
 Tue, 18 Oct 2022 08:51:04 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 h39-20020a022b27000000b00363c866d646sm1188924jaa.26.2022.10.18.08.51.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 18 Oct 2022 08:51:04 -0700 (PDT)
Date: Tue, 18 Oct 2022 11:50:59 -0400
From: Peter Xu <peterx@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Y07LY41y6ZRL3d3S@x1n>
References: <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
 <Y0A4VaSwllsSrVxT@x1n> <Y0SoX2/E828mbxuf@google.com>
 <Y0SvexjbHN78XVcq@xz-m1.local> <Y0SxnoT5u7+1TCT+@google.com>
 <Y0S2zY4G7jBxVgpu@xz-m1.local> <Y0TDCxfVVme8uPGU@google.com>
 <Y0mUh5dEErRVtfjl@x1n> <Y05X4o1TxxkvES9E@google.com>
MIME-Version: 1.0
In-Reply-To: <Y05X4o1TxxkvES9E@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 dmatlack@google.com, will@kernel.org, shan.gavin@gmail.com, bgardon@google.com,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, zhenyzha@redhat.com,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Tue, Oct 18, 2022 at 10:38:10AM +0300, Oliver Upton wrote:
> If we ever get to the point that we can relax this restriction i think a
> flag on the BITMAP_WITH_TABLE cap that says "I don't actually set any
> bits in the bitmap" would do. We shouldn't hide the cap entirely, as
> that would be ABI breakage for VMMs that expect bitmap+ring.

I'd rather drop the cap directly if it's just a boolean that tells us
"whether we need bitmap to back rings". Btw when I said "dropping it" I
meant "don't return 1 for the cap anymore" - we definitely need to make the
cap macro stable as part of kvm API..

But I think I misunderstood the proposal previously, sorry. I assumed we
were discussing an internal HAVE_DIRTY_RING_WITH_BITMAP only.  I noticed
this only after I had a closer look at Gavin's patch.  Having a cap exposed
sounds always good to me.

I'll comment on Gavin's patch directly, thanks.

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
