Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B19DC54EE9
	for <kvmarm@archiver.kernel.org>; Mon, 19 Sep 2022 16:38:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DDDB4B601;
	Mon, 19 Sep 2022 12:38:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SFxwNvswrB-6; Mon, 19 Sep 2022 12:38:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B4FF4B646;
	Mon, 19 Sep 2022 12:38:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EC9B4B62A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 12:38:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YYfbnpl48qSf for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Sep 2022 12:38:19 -0400 (EDT)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
 [209.85.215.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 841334B5F6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 12:38:19 -0400 (EDT)
Received: by mail-pg1-f181.google.com with SMTP id h188so27227837pgc.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 09:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date;
 bh=gY/UR9x/qOV2lGsC3f/dNydQCP5zey4ni1VZmLdB2sU=;
 b=a17YlCo4W0uVFQSimQafEREjJhNlH9kb+63RuRVf41i/AZXMoemz0mLoN4QX70s9Zb
 ecKTBbTuvHERgtsHhbu4v3d7zulBtVAgkpW0VjyVXu5vWjVdZiwUKabiw2PCY21H3CRO
 fdfwxUtktAx+2vdVrN9qkuSAf5OToVZuI/OfchZ1vU+49bSFecdnd+EfkeAO09TfxFIQ
 e8NEOC0RVt4jAgXhR+yEkQsEyhwqI1DdKW6+R3g92S5Yo+0NWD0ecwZfPBrc0sjqM/OH
 2tlB9ya9/TBvQ8vkQ9VqdF/+ae+A9RP+30x73i2xWxGnsTAaNFnmAb0MnHgeqLZUAiLF
 V0jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=gY/UR9x/qOV2lGsC3f/dNydQCP5zey4ni1VZmLdB2sU=;
 b=tg+jbPUSmA/ulap+pqzXdi6gVFEw4fb3kbIz6IZj6Oo0pfKTcib4TITKRSr7de86D3
 E4OPWWszhj+21d0SgecYnF2VziudA2xCJ60P4jFdpvUQdenjInKprgrzvO14onjqO06p
 MP0DD9dQbGL6bfmxIbCO13sDHl/mub/8P9R7IKQAsyxYNJ/xLRPkRMA3ki74negbZDga
 Dr3KEq1ITmS3M03MSoSlyqBIN/ey4D5wqRpwS+UtPQuM9EgrPO5le36MoUVIfV632q+e
 nRgeCX3oZxIRiRFr/3Wb7BNJBjRjhTJwMg1pUR+9deD7wIbxbTcEUKbD+2dGqLTo/y6j
 RuWg==
X-Gm-Message-State: ACrzQf0fP2ExKaEKsYfV1HhKDZH5qIRPyTDhEOtZezwPJqXpLOXme8u4
 4B0wtE2acbdM0vJe08dMhy8mzw==
X-Google-Smtp-Source: AMsMyM4riMa7m9Kmjyb6lV4lCPhU+JvUDmpzSnBTRy+EoC39ozFv24uP/la1fuH1jYm+AHcO9h7PRA==
X-Received: by 2002:a05:6a00:b41:b0:52f:59dc:75 with SMTP id
 p1-20020a056a000b4100b0052f59dc0075mr19642038pfo.33.1663605498289; 
 Mon, 19 Sep 2022 09:38:18 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 az8-20020a056a02004800b0043a20e50c1bsm2388227pgb.84.2022.09.19.09.38.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 19 Sep 2022 09:38:17 -0700 (PDT)
Date: Mon, 19 Sep 2022 16:38:14 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 00/13] KVM: selftests: Add aarch64/page_fault_test
Message-ID: <Yyia9uqpaIm4JyH+@google.com>
References: <20220906180930.230218-1-ricarkol@google.com>
 <166358370892.2832387.8903539023908338224.b4-ty@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <166358370892.2832387.8903539023908338224.b4-ty@kernel.org>
Cc: kvm@vger.kernel.org, bgardon@google.com, andrew.jones@linux.dev,
 axelrasmussen@google.com, dmatlack@google.com, pbonzini@redhat.com,
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

On Mon, Sep 19, 2022, Marc Zyngier wrote:
> On Tue, 6 Sep 2022 18:09:17 +0000, Ricardo Koller wrote:
> > This series adds a new aarch64 selftest for testing stage 2 fault handling for
> > various combinations of guest accesses (e.g., write, S1PTW), backing sources
> > (e.g., anon), and types of faults (e.g., read on hugetlbfs with a hole, write
> > on a readonly memslot). Each test tries a different combination and then checks
> > that the access results in the right behavior (e.g., uffd faults with the right
> > address and write/read flag). Some interesting combinations are:
> > 
> > [...]
> 
> Given how long this has been around, I've picked this series up, applying
> Oliver's fixes in the process.

Any chance this can be undone?  A big reason why this is at v6 is because of the
common API changes, and due to KVM Forum I've effectively had three working days
since this was posted, and others have probably had even less, i.e. lack of reviews
on v6 isn't because no one cares.

It's not the end of the world if we have to fix things up on top, but we'd avoid
a decent amount of churn if we can instead unwind and do a v7.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
