Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BAEC4332F
	for <kvmarm@archiver.kernel.org>; Tue, 20 Dec 2022 16:32:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A99424B3D1;
	Tue, 20 Dec 2022 11:32:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0tpZCfyKUvEp; Tue, 20 Dec 2022 11:32:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E75F4B492;
	Tue, 20 Dec 2022 11:32:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6E4F4B15C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Dec 2022 11:32:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zsxXAzIaQWP2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Dec 2022 11:32:02 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7676941021
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Dec 2022 11:32:02 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-437b250c03aso146663967b3.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Dec 2022 08:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
 :cc:subject:date:message-id:reply-to;
 bh=XrImwGduolMTyoyh8B4xmu2CI/C3wDtB3hW/6WtZSt8=;
 b=QYMLt5UshIud2hfhO6Xvx67bOysbCE2PlS8smMxii+jnx2XrX+Q5+IBqlnd7fwXZoA
 Kp5vXgqNGcnhkb6NgI3Y96WHlCoNZPiyxrfvAJK3ix5hWdyKaNP0SGy6bSoTRiUudY3/
 cY8F4IJYHzK3FaMsuE0wy2C82L1l7YUkonERzGOwSskkEVFJ8sHT7Xxl+7OFLwPIGfkQ
 pom6CKeqJjSsQq9D3t07sQvT315+iasLL0kSKcGSl+949Lpfvn2DkAGv1knmfnQu3arn
 sYGxcxyTRTjaCeWiygSq2gJ6PiT7vJWiMhWsaq+ARSKvtB7q9nco7iGW+YU3lhvQbwJk
 AgAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=XrImwGduolMTyoyh8B4xmu2CI/C3wDtB3hW/6WtZSt8=;
 b=1VqC/ZrkrfQlH2QMe3VGfpOPjyx2frWyLjmf1cY2mXz14xuj0sC5gpL+hbPQe37ZFy
 /qB6NNFpSgvDBAvFjHZHRg0UXNHBlgbW35VyUNAivkTG/BhYbwBQY8NAzoE0THExMTHU
 DWEhItFNWAAoD9zHfd3tqVAaV30Pl6UG/pzR0xNcQ9MezP3bugulE6bboRmHh9fcLW5g
 3IJpEECouPmO1sBgOn5MoxXvuPHcTFujRwzxT6cJLrjdDuSOe/nTpVKB0VoeDh6KNdjv
 NfBOaNhBwwG47f3Y8srnME5ca61EK5ae5O6NegnHoboV682sBibnUaYS0ld0nOjjNkoj
 zxog==
X-Gm-Message-State: ANoB5pmS5R2vxaY6pwIDD4iqTkqFyxe93Yj2CXxjQBdPUqXcdo/kg9hi
 /DsGBGy6TedMNe+J9Q2th7+gKKq1yFWU/XLc8g==
X-Google-Smtp-Source: AA0mqf7oHCF0W41mhDrjdzczDyjNBOgKqzvgVg5lQDJFYRpKE81aajcpRRzlPnT1UDYepvbYCCwBsqs2yOgViGTVFw==
X-Received: from coltonlewis-kvm.c.googlers.com
 ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:f90d:0:b0:404:7030:e1c0 with SMTP
 id x13-20020a81f90d000000b004047030e1c0mr6793086ywm.53.1671553921890; Tue, 20
 Dec 2022 08:32:01 -0800 (PST)
Date: Tue, 20 Dec 2022 16:32:00 +0000
In-Reply-To: <Y6GRXreBu56PqCyG@monolith.localdoman> (message from Alexandru
 Elisei on Tue, 20 Dec 2022 10:41:55 +0000)
Mime-Version: 1.0
Message-ID: <gsnt8rj2ghof.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [kvm-unit-tests PATCH] arm: Remove MAX_SMP probe loop
From: Colton Lewis <coltonlewis@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, andrew.jones@linux.dev,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Alexandru Elisei <alexandru.elisei@arm.com> writes:

> Though I'm not sure how you managed to get MAX_SMP to go down to 6 cores  
> on
> a 12 core machine. MAX_SMP is initialized to $(getconf _NPROCESSORS_ONLN),
> so the body of the loop should never execute. I also tried it on a 6 core
> machine, and MAX_SMP was 6, not 3.

> Am I missing something?

To be clear, 12 cores was a simplified example I did not directly
verify. What happened to me was 152 cores being cut down to 4. I was
confused why one machine was running a test with 4 cores when my other
machines were running with 8 and traced it to that loop. In effect the
loop was doing MAX_SMP=floor(MAX_SMP / 2) until MAX_SMP <= 8. I printed
the iterations and MAX_SMP followed the sequence 152->76->38->19->9->4.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
