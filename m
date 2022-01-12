Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E86EC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jan 2022 18:24:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CFA249F43;
	Wed, 12 Jan 2022 13:24:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ic9jebyDMpmn; Wed, 12 Jan 2022 13:24:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C4F449F12;
	Wed, 12 Jan 2022 13:24:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A4BA49E3B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 13:24:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RM1AQj+GFKCv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jan 2022 13:24:36 -0500 (EST)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 32E1049E29
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 13:24:36 -0500 (EST)
Received: by mail-pj1-f53.google.com with SMTP id pj2so6699090pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 10:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ZmWNRIqHpgfFlpkzNid2AC/wsgEhhdjKgSthxqzupr0=;
 b=Hu0l1zFFoYveGm/teMMMLzjdYZZ9zlHgOwE5BiAa/3z6diZCXc1oZ+E0g3Wm2YT3T4
 zMZkwh6IK/rLwGDBUppTCSQwiB69w1v1Cv8Zr47GFjUlpUkHTF3/rvPZNi4YJH2B8TEZ
 Lyv7xmvISTTPRvYjZtNac+DUiLid4AEGwCa5xnmYyRz/c/jylydiABnVDFOnS7fNFFtD
 FOeyhg327siqhBuHgRQ9qcTdfQg76s8e3XPQUwRWNYi1FBbiPP3WL11PfBg6cJEkL1S6
 KkxJxDKOa/ryCIPaNWK/05qGqzmQdrQ6FQiyNHCRRx3A8OR3nVgXU4hU7ZlR7ZJu9jJJ
 hZyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ZmWNRIqHpgfFlpkzNid2AC/wsgEhhdjKgSthxqzupr0=;
 b=00gQrG71iHzp6H32ZtPYCe+d8s3oIsNcgrna/AAJ4Kptbsc1agdUZUMTWGnmQKotX2
 ubTY+H4VQAOgJs1a9sBzrM/8KaA3EyzumOVCch5Eo2PhwhVOvlU6RCQ+2G/C+5PUGBgQ
 4LMJzr8L9QYuvWraT7r9qi75yqjH51GJb1MwH+pX+ybMm6LXv+E1Sars+BWsawzk++fn
 5AvCX+natK0IV/QZhdDjicqCy3bM4tgYgrXbpkMV+rgodaIkOZSn3m73NNPzn+jD45A+
 2b7qOibq0nr5wKVDxNzIqdL2wTxMi40IQmok4txFXPYR8Gki/D3hDDSU1z7s97qp7BpW
 qehQ==
X-Gm-Message-State: AOAM532KlRg62o5u20GCfSjC5zP9PGgWVcsR7iFYL0g7tylmYZLSGU7W
 hq08hE4+Q13FL/QVCowgbX7IjA==
X-Google-Smtp-Source: ABdhPJxC3Spy6jAzawZZkjc8A2flGmd3z5F+VR5mfljb/8geqt6+8TviA+FPYekZyzWdSxeA0zZurA==
X-Received: by 2002:a17:902:8346:b0:149:d1c7:fdc0 with SMTP id
 z6-20020a170902834600b00149d1c7fdc0mr689096pln.166.1642011875155; 
 Wed, 12 Jan 2022 10:24:35 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id n15sm6311862pjj.12.2022.01.12.10.24.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 12 Jan 2022 10:24:34 -0800 (PST)
Date: Wed, 12 Jan 2022 18:24:31 +0000
From: Sean Christopherson <seanjc@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
Message-ID: <Yd8c3zlTweSGhwtt@google.com>
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-2-rananta@google.com>
 <Ydjje8qBOP3zDOZi@google.com>
 <CAJHc60ziKv6P4ZmpLXrv+s4DrrDtOwuQRAc4bKcrbR3aNAK5mQ@mail.gmail.com>
 <Yd3AGRtkBgWSmGf2@google.com>
 <CAJHc60w7vfHkg+9XkPw+38nZBWLLhETJj310ekM1HpQQTL_O0Q@mail.gmail.com>
 <Yd3UymPg++JW98/2@google.com>
 <CAJHc60yPmdyonJESHPHvXJR+ekugZev4XzsZc2YV2mnfBdy-bw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJHc60yPmdyonJESHPHvXJR+ekugZev4XzsZc2YV2mnfBdy-bw@mail.gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
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

On Wed, Jan 12, 2022, Raghavendra Rao Ananta wrote:
> Understood. I'll move it to arm64 and we can refactor it if there's a
> need for any other arch(s).

Before you do that, can you answer Jim's question on _why_ arm64 needs this?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
