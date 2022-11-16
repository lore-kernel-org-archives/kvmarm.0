Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B699C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 16 Nov 2022 17:06:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFD394B865;
	Wed, 16 Nov 2022 12:06:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HZZrLiZvSwQu; Wed, 16 Nov 2022 12:06:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F34E44B86B;
	Wed, 16 Nov 2022 12:06:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 598A44B865
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:06:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 02n88LqH7URu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 12:06:50 -0500 (EST)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com
 [209.85.218.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 44D204B82B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 12:06:50 -0500 (EST)
Received: by mail-ej1-f47.google.com with SMTP id kt23so45668464ejc.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 09:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=ntvWgXmyJ+ykqZ+C7I8wJwNPUjVuwRNNvjO3LgHYeZQ=;
 b=ijm23BXVpC91ubga8PZXme39BcIbxyQVTExxRKXLSvZDwSo1X0uMeKsr7Af4VNMN5F
 3NheMhsqE43RygVDM/jqGXonihzTc9MNVlqK3YiBbqPGVwkBhqeJxKrh3IDLPdbivdbI
 5UF69y2Xsi16bX6JXRDlIbeGzG+NFKuoa1rTjK5uI3yc98PJ8r/C7knt4fsZiZaPbBEu
 C+nUdfI+n3I89DEqDmtzg89PBhJJuF2Dzei+N7FTHK2b76i7PNqem+0Dv9w4cD2XuUjs
 tPnFZNspYuymVCs3upZV9M8kNEsHnbByVfWFQGI1a07rLlebliWtUZeAmqqUJl7ny9QT
 lKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=ntvWgXmyJ+ykqZ+C7I8wJwNPUjVuwRNNvjO3LgHYeZQ=;
 b=sFk6a8bWOnbc0yax/wIfJ9KAvOHpLCORHYP/tc0QD9H4hpoPVRzAXHBiPpic7Woqv0
 ulCs66va7gHoptvkIUg9mApfaexUqkL9Am5iT1/Y5o+3K4V2aZEHXJ6S+WatdyenqNow
 UQ2yEveXJjmdCKTbPn3lwFBcfOO7SBljtkuu6zn18QgdG6my1Qiq/p5WnuGZp5bvXitL
 xaW+dYaw2hSXulQlgheJijg9e6+5rSqsY5dqiw0uj4ur65NoTC4Wj2U/IAg+vi2minTH
 loBcz/zP/ZBF80o8zkXaFLdzUv3nlvJjzkTIN/1SHSB17Y76g2tNX5DMtLcYmvewGTfn
 jOgQ==
X-Gm-Message-State: ANoB5pmXxoLcAyvzxGzRjhcq1vJd5vAUJ1zZzJ3lK7EMvAbk1lNwqlOh
 2KQC7mBTTKYJyIxs7cEHF1U9dw==
X-Google-Smtp-Source: AA0mqf7OUgDhaAkgf87o1aEoAM3GV5pr2cWK1jkNVYywr1xdXN9du8Ug6c89/kiZd1oJFyyfqrOXQw==
X-Received: by 2002:a17:906:a2d4:b0:7ac:db70:2f90 with SMTP id
 by20-20020a170906a2d400b007acdb702f90mr18116893ejb.297.1668618409178; 
 Wed, 16 Nov 2022 09:06:49 -0800 (PST)
Received: from google.com (64.227.90.34.bc.googleusercontent.com.
 [34.90.227.64]) by smtp.gmail.com with ESMTPSA id
 r18-20020a1709061bb200b0077d37a5d401sm7115248ejg.33.2022.11.16.09.06.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Nov 2022 09:06:48 -0800 (PST)
Date: Wed, 16 Nov 2022 17:06:44 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
 Andrew Walbran <qwandor@google.com>
Subject: Re: [PATCH 12/12] ANDROID: KVM: arm64: pkvm: Add support for
 fragmented FF-A descriptors
Message-ID: <Y3UYpGBlU1W62Mfz@google.com>
References: <20221116170335.2341003-1-qperret@google.com>
 <20221116170335.2341003-13-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221116170335.2341003-13-qperret@google.com>
Cc: kvmarm@lists.linux.dev, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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

On Wednesday 16 Nov 2022 at 17:03:35 (+0000), Quentin Perret wrote:
> FF-A memory descriptors may need to be sent in fragments when they don't
> fit in the mailboxes. Doing so involves using the FRAG_TX and FRAG_RX
> primitives defined in the FF-A protocol.
> 
> Add support in the pKVM FF-A relayer for fragmented descriptors by
> monitoring outgoing FRAG_TX transactions and by buffering large
> descriptors on the reclaim path.

And it seems that I have forgotten to remove the ANDROID: tag from this
patch prior to posting ... Please ignore, it'll be gone in v2.

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
