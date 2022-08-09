Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 246C0C19F2D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 20:53:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81B744C668;
	Tue,  9 Aug 2022 16:53:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6QCTxKwH1+rQ; Tue,  9 Aug 2022 16:53:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EE9F4C664;
	Tue,  9 Aug 2022 16:53:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01A504C661
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 16:53:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ARX2ajwRvsBa for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 16:53:42 -0400 (EDT)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E24574C65A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 16:53:41 -0400 (EDT)
Received: by mail-pl1-f182.google.com with SMTP id m2so12446189pls.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Aug 2022 13:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc;
 bh=pJblVN/EwDKnGoYTvY52rorYjnKswwmvjLRNuq3g3VE=;
 b=GbUPKddyRcffK7GnxZeqqcUioCOBYjZYcND1JWvpTTanaun1D9fGTvEAbdn125PW6m
 JLjs5YyKKh7edLtHVT0tHekB/pNop76ht7souklms4QnoaKiHs8glUoRTRM+Mfo8T9Wd
 Q8JXLAja5U0d1nkYehhAvAfuKo06DjcO+uoxCK8jXyV1FA9g3aXQEBfaTLKZJ6FVL/Mt
 NMgBfRYESMHWHpBAQGqe86ARj9HVA94d7TsUE/YkyfA1kBd8DX8QSHykjK5j4xexTJPv
 k3mNOu14Dx9T3iSZbwK0WM2QonrbFR+wdYL0qCqooRcYs3zUHOlu/GhNspIACNbPZ6x3
 ZDBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=pJblVN/EwDKnGoYTvY52rorYjnKswwmvjLRNuq3g3VE=;
 b=qbPCSdbAiY0IzYvYdbrAxhNXJKfrC9XWeSt5j48xxcE/h90lYOLCtINPa85rbruftr
 K2j7kjwXtCiKGU1OykWid5M3CfZ024OZnNTy3km6bQxj/308DFNFJqgKdJHyZvACwcJs
 H6IPPV7FWnNkGuL0SfOdT6/pFmGsnm6d56sqBytiLnvkBDYIKCYE8HlTyrSw6XptIVyy
 vAGOrMmxUFKLfUj7BmP9h2lD3QCG/ihaEDptc0pj3cPKCp/B95MjCGwqwr4t3jgNFSbW
 LQa+2nmIepd7xLybOhjsFd88mcdPd3LQC0Cq0m9imNX1XgC5R/HGf66z/nevRyQBINOU
 RgmA==
X-Gm-Message-State: ACgBeo0GL4sRdO4BdyZRJh2zVMUyUKN04LaNA77TXyomm3n0hJ70ir9U
 /vkUU9D8ko7vsRtxwbrInAzrvg==
X-Google-Smtp-Source: AA6agR5zPiBVnYt1kAUuxrAkMt0LXjWgm1wd+WLRJjf0RsoJ/oyZpNSqLwA3FNlryMJpO0oPIuNAIg==
X-Received: by 2002:a17:902:eb8a:b0:16d:c75a:c40b with SMTP id
 q10-20020a170902eb8a00b0016dc75ac40bmr25435222plg.102.1660078420716; 
 Tue, 09 Aug 2022 13:53:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 u8-20020a170902e5c800b00170a359eb0esm5711482plf.63.2022.08.09.13.53.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 09 Aug 2022 13:53:40 -0700 (PDT)
Date: Tue, 9 Aug 2022 20:53:36 +0000
From: Sean Christopherson <seanjc@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Use getcpu() instead of
 sched_getcpu() in rseq_test
Message-ID: <YvLJUEOcxaZKW0y1@google.com>
References: <20220809060627.115847-1-gshan@redhat.com>
 <20220809060627.115847-3-gshan@redhat.com>
 <87y1vxncv1.fsf@oldenburg.str.redhat.com>
 <87mtcdnaxe.fsf@oldenburg.str.redhat.com>
 <ea2ef1a2-0fd8-448b-d7ca-254603518823@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ea2ef1a2-0fd8-448b-d7ca-254603518823@redhat.com>
Cc: Florian Weimer <fweimer@redhat.com>, shan.gavin@gmail.com,
 kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 andrew.jones@linux.dev, mathieu.desnoyers@efficios.com, yihyu@redhat.com,
 linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
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

On Tue, Aug 09, 2022, Gavin Shan wrote:
> On 8/9/22 5:17 PM, Florian Weimer wrote:
> > * Florian Weimer:
> > 
> > > * Gavin Shan:
> > > 
> > > > sched_getcpu() is glibc dependent and it can simply return the CPU
> > > > ID from the registered rseq information, as Florian Weimer pointed.
> > > > In this case, it's pointless to compare the return value from
> > > > sched_getcpu() and that fetched from the registered rseq information.
> > > > 
> > > > Fix the issue by replacing sched_getcpu() with getcpu(), as Florian
> > > > suggested. The comments are modified accordingly.
> > > 
> > > Note that getcpu was added in glibc 2.29, so perhaps you need to perform
> > > a direct system call?
> > 
> > One more thing: syscall(__NR_getcpu) also has the advantage that it
> > wouldn't have to be changed again if node IDs become available via rseq
> > and getcpu is implemented using that.
> > 
> > Thanks,
> > Florian
> > 
> 
> Thanks, Florian. It makes sense to me to use syscall(__NR_getcpu) in
> next revision. Thanks for your quick review :)

+1, and definitely add a comment to prevent future "cleanup".
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
