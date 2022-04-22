Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 564F1C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 22 Apr 2022 20:41:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B260549EB5;
	Fri, 22 Apr 2022 16:41:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 640hrQwgXbXQ; Fri, 22 Apr 2022 16:41:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A41524A193;
	Fri, 22 Apr 2022 16:41:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF9FD49F06
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 16:41:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6kcNWgtSnYmA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Apr 2022 16:41:56 -0400 (EDT)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com
 [209.85.166.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E7A3A49EB5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 16:41:55 -0400 (EDT)
Received: by mail-io1-f47.google.com with SMTP id c125so9814445iof.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 13:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=PIHedjvBDUsd4o0hzUsuDNj6ptFVTAlpQe59DURQa44=;
 b=oPO5Yme2y6EXk+fi6Lg8OhVIAVnIWkQGaDDC9BX04q6vbLeGn9fa4C+0nNAI1KB3Ap
 GJ3lDkeLxz/RC2Mn+I0BJbJ/SIcCy3bkUVoidHCqveVWxNpOniChJSHEjoXOUv3v3hEK
 ttEB6l7t9bxij3rfjOiWbcpjsBWLHC8NYvFw48qjT/lcQV79kYwH7HvuHrqnzfqm2VhL
 jmbhjaqlWtqQLTXWVnSmIL7dtVKNqaQgoLSPeES5HDckhkWXKBxiE3YsewOYkDwjCvdc
 wRZSzh0E0v/26h84z5+gDanAse3uW30/Q8TyYTi046k7NDB4ay0Wi/dpb949ukm52o+K
 ZEMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=PIHedjvBDUsd4o0hzUsuDNj6ptFVTAlpQe59DURQa44=;
 b=g68z3Dy/h8QCegjAIRm0wT51Sq7ZtpUgO5m/Klo3tF3y2924XVUP1XWVlyDRKzVvp5
 yGVQ/SCVUofy0Qo0HOgxc3q6SnF0mZuJaXHPkYUntahWLxpVBn+ICUykEmTdbKEU2piV
 PfQNKUajg+7RCk9gtOTkSoAlqKSYC2/k1XS6E0tB7t0U2pPCl0G/2GS/CH+oaWTq565E
 bx3AmE/DankSs8n7MnP7iVsRJvsYpw2A6qnqmZBUdVC8s7+OjF1Fa7t3+tY59efdfEG/
 qj81nFR3ha7lk7FHVcOrX5wNnMzK00BfZi7IhMBA1Xf8E2qZhDTemoIYIkIf6ICS7ULF
 S++g==
X-Gm-Message-State: AOAM533sA2S03PKQCI/b0bXiJ1hyKr2k5gHaBOwJotNsvfnQJoNYt0A8
 Iov9fsMAXDioJveF3ziqGqJhNw==
X-Google-Smtp-Source: ABdhPJy+APL9BkWInbd+QFDrmKyPHiSNDP9EVCz9Mw0NDYDizkUIV8IR5t71M6VANKddfh1vSizGaA==
X-Received: by 2002:a05:6638:35a0:b0:32a:8f99:fa03 with SMTP id
 v32-20020a05663835a000b0032a8f99fa03mr3002986jal.8.1650660115087; 
 Fri, 22 Apr 2022 13:41:55 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 w3-20020a92d2c3000000b002cbca0cd15fsm1970376ilg.8.2022.04.22.13.41.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 22 Apr 2022 13:41:53 -0700 (PDT)
Date: Fri, 22 Apr 2022 20:41:47 +0000
From: Oliver Upton <oupton@google.com>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH 09/17] KVM: arm64: Tear down unlinked page tables in
 parallel walk
Message-ID: <YmMTC2f0DiAU5OtZ@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-10-oupton@google.com>
 <YmFactP0GnSp3vEv@google.com> <YmGJGIrNVmdqYJj8@google.com>
 <YmLRLf2GQSgA97Kr@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YmLRLf2GQSgA97Kr@google.com>
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

On Fri, Apr 22, 2022 at 04:00:45PM +0000, Quentin Perret wrote:
> On Thursday 21 Apr 2022 at 16:40:56 (+0000), Oliver Upton wrote:
> > The other option would be to not touch the subtree at all until the rcu
> > callback, as at that point software will not tweak the tables any more.
> > No need for atomics/spinning and can just do a boring traversal.
> 
> Right that is sort of what I had in mind. Note that I'm still trying to
> make my mind about the overall approach -- I can see how RCU protection
> provides a rather elegant solution to this problem, but this makes the
> whole thing inaccessible to e.g. pKVM where RCU is a non-starter.

Heh, figuring out how to do this for pKVM seemed hard hence my lazy
attempt :)

> A
> possible alternative that comes to mind would be to have all walkers
> take references on the pages as they walk down, and release them on
> their way back, but I'm still not sure how to make this race-safe. I'll
> have a think ...

Does pKVM ever collapse tables into blocks? That is the only reason any
of this mess ever gets roped in. If not I think it is possible to get
away with a rwlock with unmap on the write side and everything else on
the read side, right?

As far as regular KVM goes we get in this business when disabling dirty
logging on a memslot. Guest faults will lazily collapse the tables back
into blocks. An equally valid implementation would be just to unmap the
whole memslot and have the guest build out the tables again, which could
work with the aforementioned rwlock.

Do any of my ramblings sound workable? :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
