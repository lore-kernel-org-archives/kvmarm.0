Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD6AC4332F
	for <kvmarm@archiver.kernel.org>; Wed, 23 Nov 2022 06:27:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C94B4B62D;
	Wed, 23 Nov 2022 01:27:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Dsa4HzaqYq3L; Wed, 23 Nov 2022 01:27:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A6374B615;
	Wed, 23 Nov 2022 01:27:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 290D341070
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2022 01:27:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SjdUsiK4Bs8o for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Nov 2022 01:27:34 -0500 (EST)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F17549DEB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2022 01:27:34 -0500 (EST)
Received: by mail-pj1-f53.google.com with SMTP id k5so15097701pjo.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Nov 2022 22:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=tit1GoRDHXxGIzZdw8RHtC91q2gw44B8zNxKS7z02AA=;
 b=fqnDNTMFJXL6XBTeO+kRQJFWvP7cvAJx1e8OAUaq01/iImdfKXDQth+CsyTAS02ErY
 gOASCuAizTdmqPf5oolegW2ktzaQxnmm8fsEurNaP3n2A5eGDsVdiCQk7omLcW2Fsf2S
 d6eM1CdGhpj3oVBsg76UpeggwkYA2ZpHdbx9ZOht42+LjzbynTlqPC1AJu+Ys1YbvfuN
 9DPIqYCqPnVcmaFMZmdhqecrwmSt0sebO8Q/c8q2Dl8+K61eAoRUDjFLkI32HrMvP5V+
 8/u19Bqkt8t5bZcwoRi9HlB3NbnkFH9T5nDQlYaRQUwJenxVBBuN2WUHHZ/QPb2FQGOV
 QB3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=tit1GoRDHXxGIzZdw8RHtC91q2gw44B8zNxKS7z02AA=;
 b=Geaz5rrcCxcKdGncXsvZOoSgiEPzUjyidiNK3b+ghzWFyXSmiRMFa3wjFebgHSy5Ix
 5X/lMPrtWp7fb1tlQNgLK2Nb1cTZaQd/0Yov9QfC+pnZAJSjH160l53Ti7PEHM80wdPT
 g5g3wHwF9VoZVnFqsRslDQDGakhZzgpasGegsY1GuX/OusADNcMEiR8rKsbSLNq9W2p2
 ShKo6nWErDnIlmMACj4F830d6+b4bNneIOv6lXG3TVAH8do+90tpoJm3mzp1G7jQ74t6
 Z6F7tfXM6geFMQB1IVNQhe6ezW7Tn1Xx5GqUxucnWZoSgtARNk6oZnf1wt7k8brDnGUj
 q3RA==
X-Gm-Message-State: ANoB5pkJpysjMq2JkAmET7f9yaccZn3vsIWIUszsej1add5mt9AIs1FI
 kplJ68jKJ7zWC+i4tiDdlLZopVqg4MIKuJSXP7OmEQ==
X-Google-Smtp-Source: AA0mqf5nlutVfDZV3mLPMpBH63zenw1aNZTS1OGEV25ZP+8iiz3jkhX4OVBoK3Ai4ysrDyk3GPfTAhlBrvQ5qYUgktI=
X-Received: by 2002:a17:902:9006:b0:172:d410:2a91 with SMTP id
 a6-20020a170902900600b00172d4102a91mr7622542plp.30.1669184853196; Tue, 22 Nov
 2022 22:27:33 -0800 (PST)
MIME-Version: 1.0
References: <20221113163832.3154370-1-maz@kernel.org>
 <20221113163832.3154370-16-maz@kernel.org>
In-Reply-To: <20221113163832.3154370-16-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 22 Nov 2022 22:27:16 -0800
Message-ID: <CAAeT=Fz-zYX4qLt-RKvO6P0D5Si9vxxpsbALH1LPbON8efyEeg@mail.gmail.com>
Subject: Re: [PATCH v4 15/16] KVM: arm64: PMU: Simplify vcpu computation on
 perf overflow notification
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

On Sun, Nov 13, 2022 at 8:46 AM Marc Zyngier <maz@kernel.org> wrote:
>
> The way we compute the target vcpu on getting an overflow is
> a bit odd, as we use the PMC array as an anchor for kvm_pmc_to_vcpu,
> while we could directly compute the correct address.
>
> Get rid of the intermediate step and directly compute the target
> vcpu.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
