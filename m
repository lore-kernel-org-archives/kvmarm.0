Return-Path: <SRS0=OpMx=BP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 843D6C433E0
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 18:33:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EC63622D05
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 18:33:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R+pYN9zk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC63622D05
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77A464B5C7;
	Wed,  5 Aug 2020 14:33:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AZlvoQnWakkt; Wed,  5 Aug 2020 14:33:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79D2C4B5B9;
	Wed,  5 Aug 2020 14:33:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3C9E4B5B4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 14:33:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nMIll8yauXDi for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2020 14:33:25 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BBAB4B5B2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 14:33:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1596652404;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9f+2zDm4d3yS1aPT9FWf6YX+aMMcQwVi71lbZAVl4mM=;
 b=R+pYN9zk2eqkqgwGdCCdeLM/5QoGJz0LkKruPWg1zmnfi5hr4muOamRhuLFpc+0G/kLO+h
 hkJOWiYxv31aaDBdHo/bxjHpbZ6+myElklQxrU0zQyshK/g826yPVQYFQHAPt2SHGrYntM
 koe7coWKUpTrU79ljk2HTcTpzBakpPU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-t2NYEDoSMKSPQuM5en_u3Q-1; Wed, 05 Aug 2020 14:33:23 -0400
X-MC-Unique: t2NYEDoSMKSPQuM5en_u3Q-1
Received: by mail-wm1-f69.google.com with SMTP id q15so3035680wmj.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Aug 2020 11:33:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=9f+2zDm4d3yS1aPT9FWf6YX+aMMcQwVi71lbZAVl4mM=;
 b=X0gbDxp0KZ/qTAlJv5WaQvHaChQVQ/44s2MxrX9ug0jLd7jrsnAUV1LmcZdyPVWV8y
 YDA0UvC1SSCl80aqLPEuFJWWYMpux/9V+TpmAL8bYpoQB9gYPo9ZW4Y1dtqduXpoyiz2
 7CBP/iX0C7rW37NJbXP+knLbjFls3evx6AQKh39cjuFp5tUzYcq3b1cGQcsp8uGpul7n
 11g+56lz5GrI7zpVjBsm8lc0uTvx5Ta49u1r6LmxbxGTkx7DTQkCqKMTzDWB0JcUWh0Z
 G4rM6tcpm7ULBgGXc3mq+uugqkRrdCN7tBzkKK4c2fJKrZsZQI/ODQgcCopr6JbtnZ2X
 17yQ==
X-Gm-Message-State: AOAM5315V4qF3HM6sqfOjCh5xDkTTOyCJM2phzKAYihVtGOy5ooB211s
 hsjEJZSc7shVccdZfpMEZct7FFROzCcQP24hWV/Zin06Ir2I1r6Ll0KufC6Oi8YwZBXsisnPQyN
 +KySGRdBInpbz04Ii4NPHjoRD
X-Received: by 2002:adf:9e8b:: with SMTP id a11mr3749365wrf.309.1596652064626; 
 Wed, 05 Aug 2020 11:27:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+KGNj0NBLJYeB8xi8DpGwW88pM+R8FK55z7m1ZgGHhl3YLU9QV1yCfid7toTnvyJBWOJg6Q==
X-Received: by 2002:adf:9e8b:: with SMTP id a11mr3749340wrf.309.1596652064286; 
 Wed, 05 Aug 2020 11:27:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7841:78cc:18c6:1e20?
 ([2001:b07:6468:f312:7841:78cc:18c6:1e20])
 by smtp.gmail.com with ESMTPSA id f124sm3610601wmf.7.2020.08.05.11.27.42
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 05 Aug 2020 11:27:43 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 updates for 5.9
To: Marc Zyngier <maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <879fd9c1-b0ce-1085-dade-64a7bf40bb4f@redhat.com>
Date: Wed, 5 Aug 2020 20:27:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
Content-Language: en-US
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Peng Hao <richard.peng@oppo.com>, kernel-team@android.com,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexander Graf <graf@amazon.com>,
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

On 05/08/20 19:56, Marc Zyngier wrote:
> Hi Paolo,
> 
> This is the bulk of the 5.9 patches for KVM/arm64. It is a pretty busy
> merge window for us this time, thanks to the ongoing Protected KVM
> work. We have changes all over the map, but the most important piece
> probably is the way we now build the EL2 code on non-VHE systems. On
> top of giving us better control over what gets pulled in there, it
> allowed us to enable instrumentation on VHE systems.
> 
> The rest is a mixed bag of new features (TTL TLB invalidation, Pointer
> Auth on non-VHE), preliminary patches for NV, some early MMU rework
> before the 5.10 onslaught, and tons of cleanups.
> 
> A few things to notice:
> 
> - We share a branch with the arm64 tree, which has gone in already.
> 
> - There are a number of known conflicts with Sean's MMU cache rework,
>   as well as the late fixes that went in 5.8. The conflicts are pretty
>   simple to resolve, and -next has the right resolutions already.

Ok, since I have already an x86 conflict I'll wait to pull this until
next week.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
