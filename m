Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE61C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  3 May 2022 14:17:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F12B24B1BC;
	Tue,  3 May 2022 10:17:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Szw5ovxHi0vh; Tue,  3 May 2022 10:17:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9D784B152;
	Tue,  3 May 2022 10:17:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DA334B13E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 10:17:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UwuImrgjLi6f for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 10:17:30 -0400 (EDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com
 [209.85.218.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35C7C49EC1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 10:17:30 -0400 (EDT)
Received: by mail-ej1-f49.google.com with SMTP id dk23so33732349ejb.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 07:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=fbgMapne1rH6/kKlRXWbC6sN+d3viTII31UcYeBu5g4=;
 b=p5StzTBTAohsMwlL6jHQBWtTQobIcqESt3kLVZnkNHJSG2DdBFZF7Tgs5QaZmPnlCr
 F1l8QZ0lnzdHlhRVHnwsSRNzlNALEMzZuSnQCxowMh6uXeXOg3ZbmSEabk7olar1pdpp
 9pZRvS+REXlThgWE/quskEMYIGVZw1x55jioiJE011eju4WdbP9ZextM5/dSqGnzJ/OA
 Ip3n3G3Q5wiRXN3pJWPKqD+r0Wk199FnUkUPdXWP8Vhe6xFQIDSvsecKYYscAjJp/an6
 Yukn9oKICYgAyT+VGWoiAnlgJf7HCdoInuF1DHTluTYZYb7iUxSiRZ05KmZ0heDnRw16
 aUzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fbgMapne1rH6/kKlRXWbC6sN+d3viTII31UcYeBu5g4=;
 b=hJLpYgl90nfh1oZKaBm+ovajc+4TZF24Rrh1JFnnuaPZkwIObM+0oFLHvYp+KQu+OR
 cTZWqWjN4u/5KHKdoNwynboHcTbZyaChjAvl6A0qBn2FxiKLZFPdnvLX6G2EefKUYZ9Q
 Ft5HV/ORYEc7frNlZzS3NgVPuvtg4oFCJHNefHNaoDkYgT2xujWQHy/ku+8WterbLOya
 oCQNEF12jEAs4z0Cs1iCgV5BVg/wVomU5kI033GyTyrMJYyxFbWEOU6fooY5ZITcf7Hb
 QUolrFOPVTdZbCWGivmvRu/paglWVA7ooQ10Nb1Odkg4pJ6k8asPR2HHQ66Ogr/tOMV3
 h5Ow==
X-Gm-Message-State: AOAM533IGsRXj1YdNjL9SSITqjvXoRvBDPxWuhVyCILK2nrg8E1ovmZP
 YlLOfuotAoQxC8UIGfQPxmOZYg==
X-Google-Smtp-Source: ABdhPJzSpQ9MzxynGtzoIUDLeJ/DfizCDd1t2kS5FNmZLRZhA9C+R6Uh6yCEZ5JtfHxxtU8soK6nAQ==
X-Received: by 2002:a17:906:d555:b0:6da:ac8c:f66b with SMTP id
 cr21-20020a170906d55500b006daac8cf66bmr15765063ejc.107.1651587448896; 
 Tue, 03 May 2022 07:17:28 -0700 (PDT)
Received: from google.com (30.171.91.34.bc.googleusercontent.com.
 [34.91.171.30]) by smtp.gmail.com with ESMTPSA id
 hg13-20020a1709072ccd00b006f3ef214df3sm4657306ejc.89.2022.05.03.07.17.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 03 May 2022 07:17:28 -0700 (PDT)
Date: Tue, 3 May 2022 14:17:25 +0000
From: Quentin Perret <qperret@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [RFC PATCH 09/17] KVM: arm64: Tear down unlinked page tables in
 parallel walk
Message-ID: <YnE5dfaC3HpXli26@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-10-oupton@google.com>
 <YmFactP0GnSp3vEv@google.com> <YmGJGIrNVmdqYJj8@google.com>
 <YmLRLf2GQSgA97Kr@google.com> <YmMTC2f0DiAU5OtZ@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YmMTC2f0DiAU5OtZ@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Ben Gardon <bgardon@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Friday 22 Apr 2022 at 20:41:47 (+0000), Oliver Upton wrote:
> On Fri, Apr 22, 2022 at 04:00:45PM +0000, Quentin Perret wrote:
> > On Thursday 21 Apr 2022 at 16:40:56 (+0000), Oliver Upton wrote:
> > > The other option would be to not touch the subtree at all until the rcu
> > > callback, as at that point software will not tweak the tables any more.
> > > No need for atomics/spinning and can just do a boring traversal.
> > 
> > Right that is sort of what I had in mind. Note that I'm still trying to
> > make my mind about the overall approach -- I can see how RCU protection
> > provides a rather elegant solution to this problem, but this makes the
> > whole thing inaccessible to e.g. pKVM where RCU is a non-starter.
> 
> Heh, figuring out how to do this for pKVM seemed hard hence my lazy
> attempt :)
> 
> > A
> > possible alternative that comes to mind would be to have all walkers
> > take references on the pages as they walk down, and release them on
> > their way back, but I'm still not sure how to make this race-safe. I'll
> > have a think ...
> 
> Does pKVM ever collapse tables into blocks? That is the only reason any
> of this mess ever gets roped in. If not I think it is possible to get
> away with a rwlock with unmap on the write side and everything else on
> the read side, right?
> 
> As far as regular KVM goes we get in this business when disabling dirty
> logging on a memslot. Guest faults will lazily collapse the tables back
> into blocks. An equally valid implementation would be just to unmap the
> whole memslot and have the guest build out the tables again, which could
> work with the aforementioned rwlock.

Apologies for the delay on this one, I was away for a while.

Yup, that all makes sense. FWIW the pKVM use-case I have in mind is
slightly different. Specifically, in the pKVM world the hypervisor
maintains a stage-2 for the host, that is all identity mapped. So we use
nice big block mappings as much as we can. But when a protected guest
starts, the hypervisor needs to break down the host stage-2 blocks to
unmap the 4K guest pages from the host (which is where the protection
comes from in pKVM). And when the guest is torn down, the host can
reclaim its pages, hence putting us in a position to coallesce its
stage-2 into nice big blocks again. Note that none of this coallescing
is currently implemented even in our pKVM prototype, so it's a bit
unfair to ask you to deal with this stuff now, but clearly it'd be cool
if there was a way we could make these things coexist and even ideally
share some code...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
