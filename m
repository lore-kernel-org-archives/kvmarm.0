Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0604C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 21 Apr 2022 17:16:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20C4A4B27C;
	Thu, 21 Apr 2022 13:16:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yAsCSLDnRn69; Thu, 21 Apr 2022 13:16:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDB324B21A;
	Thu, 21 Apr 2022 13:16:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C42084B231
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 13:16:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qA9m0DziE-uN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Apr 2022 13:16:51 -0400 (EDT)
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com
 [209.85.166.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9CE944B21A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 13:16:51 -0400 (EDT)
Received: by mail-il1-f179.google.com with SMTP id o5so3471390ils.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 10:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=XzhY22rtiJ4F18tBLtgYTs/jI9h0RWvVOlQ+tRau+5o=;
 b=pK42OJHT0CeEuc0jhItLyks4fe+Xnjx0pc5hU0u/pCXZcWmvdLl+OE/12crIT84m1F
 VJVkgDjOAeSiFct9qEntE2I7HQ1FsGWVdJ86FpnqgNsfTfFHKscoqGSRaypz7Xt4ApBh
 ZWPI/IJ+v4WeM4TVbVbI0n82DvePsALfkbz2hG6tI9YDWgnZK9vxY7tbZj+zXBgU2Z5E
 oe3zu+r8g49xPpC22rBu0pNm4L+j/CKW6d9J3NRboLuKc2JLq8Hp75N/p14Gkc0TadDu
 Vi1nIgZNnu6KydVo6ByWz3Ztrc+m4Ejx2hSRQF+gUi4ZgBi6hO1FnbAGc8yqszaU6zwx
 Njag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=XzhY22rtiJ4F18tBLtgYTs/jI9h0RWvVOlQ+tRau+5o=;
 b=t9z/BlbEQk6WplIzxSPrctXpbtsilUv1ROg7ob1PiOc7jepGPmtrDbjoZtf62vbs7f
 rmf4+jYOPGu/OskbKnpeFia05Jp0qAaOAb335kkLzmnLbvm2MryAthrMqH+aJIgXMgnI
 Zl54kQkH75qVal4ZBToLyZQb7GtYH5Zpqldf+Csy9zSXnp2W8mPuKYkWmkLZ5I4hbzbZ
 12f38RkyBPbAIW2m2CUZGQBuJ93mvML7t8OAfp4DdEDSD+yKkGbioVdasTiRS4WzjZr4
 Ie1uaLpoiqnH2QIf1rRvFq+WDJ6k8wJY+gQqVZPbUbjnW0sF7BIWXtcRoUH/9yHRQ9iK
 ss4Q==
X-Gm-Message-State: AOAM532KN0jtlphbhmb6nUBl6maGqTYoX4H9P1QEsTIS0DObX5OvZmdm
 NWFOhwJIszqxBqca2jrycJLgqA==
X-Google-Smtp-Source: ABdhPJz6XkmJvX5hjmcdaIfdUbIKzuxRz6hJn/RCOLM3kCv4aIyILwYHTuG617IunDBh4Y458w/0tg==
X-Received: by 2002:a05:6e02:b41:b0:2cc:55ae:91b0 with SMTP id
 f1-20020a056e020b4100b002cc55ae91b0mr334271ilu.126.1650561410732; 
 Thu, 21 Apr 2022 10:16:50 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 n12-20020a92dd0c000000b002cac22690b6sm12524629ilm.0.2022.04.21.10.16.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 21 Apr 2022 10:16:49 -0700 (PDT)
Date: Thu, 21 Apr 2022 17:16:46 +0000
From: Oliver Upton <oupton@google.com>
To: Ben Gardon <bgardon@google.com>
Subject: Re: [RFC PATCH 10/17] KVM: arm64: Assume a table pte is already
 owned in post-order traversal
Message-ID: <YmGRfoVUuDZ2YTyc@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-11-oupton@google.com>
 <CANgfPd-LZf1tkSiFTkJ-rww4Cmaign4bJRsg1KWm5eA2P5=j+A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANgfPd-LZf1tkSiFTkJ-rww4Cmaign4bJRsg1KWm5eA2P5=j+A@mail.gmail.com>
Cc: kvm <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Thu, Apr 21, 2022 at 09:11:37AM -0700, Ben Gardon wrote:
> On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
> >
> > For parallel walks that collapse a table into a block KVM ensures a
> > locked invalid pte is visible to all observers in pre-order traversal.
> > As such, there is no need to try breaking the pte again.
> 
> When you're doing the pre and post-order traversals, are they
> implemented as separate traversals from the root, or is it a kind of
> pre and post-order where non-leaf nodes are visited on the way down
> and on the way up?

The latter. We do one walk of the tables and fire the appropriate
visitor callbacks based on what part of the walk we're in.

> I assume either could be made to work, but the re-traversal from the
> root probably minimizes TLB flushes, whereas the pre-and-post-order
> would be a more efficient walk?

When we need to start doing operations on a whole range of memory this
way I completely agree (collapse to 2M, shatter to 4K for a memslot,
etc.).

For the current use cases of the stage 2 walker, to coalesce TLBIs we'd
need a better science around when to do blast all of stage 2 vs. TLBI with
an IPA argument. IOW, we go through a decent bit of trouble to avoid
flushing all of stage 2 unless deemed necessary. And the other unfortunate
thing about that is I doubt observations are portable between implementations
so the point where we cut over to a full flush is likely highly dependent
on the microarch.

Later revisions of the ARM architecture bring us TLBI instructions that
take a range argument, which could help a lot in this department.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
