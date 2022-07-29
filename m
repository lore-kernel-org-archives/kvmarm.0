Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19725C19F2B
	for <kvmarm@archiver.kernel.org>; Fri, 29 Jul 2022 14:15:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 669BC4CC9C;
	Fri, 29 Jul 2022 10:15:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Sls3MruZFJbm; Fri, 29 Jul 2022 10:15:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4CE44CCAB;
	Fri, 29 Jul 2022 10:15:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB3384CCA6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jul 2022 10:15:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NEzHAZz6yT-g for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Jul 2022 10:15:03 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 832264CC9C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jul 2022 10:15:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1659104103;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=VLmoxPjTF613oNOA3Psl0qHB0kkbJHX6uvP3gaTWm5o=;
 b=iKXN521Q74fQdYsyKERrQLlydNdabBIByR1pCUzB6y0rdLSzgwE58eGoUJFmRd2FCTk6Xw
 tp7nFTSadKCzuKLDgENyMLeXuj6LUHgYhyTKk348M+RZGky62xG+DyvdR//ZCwlweSNLWf
 4XYTwKJZFxq8oyBbYAdlRfiyTfkB8T8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-UcTMZj2vNuWCnhc_ANR4_A-1; Fri, 29 Jul 2022 10:15:01 -0400
X-MC-Unique: UcTMZj2vNuWCnhc_ANR4_A-1
Received: by mail-ej1-f71.google.com with SMTP id
 qk18-20020a1709077f9200b0072b95d9eea3so1844764ejc.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jul 2022 07:15:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=VLmoxPjTF613oNOA3Psl0qHB0kkbJHX6uvP3gaTWm5o=;
 b=jS7DE06jNUppWknA5zRi78K7PAhCsJq+AcjR5uVA0OQrv/pCJHet5WKsFwUwwDi0/d
 384t/w/YahKu6ZvVODbRx3ghBhwT/fYslxVTuU94C3QomKq3uWBiaFw9Oi2hDBGQZZMO
 PCs9L4VuwC8fF1oQW6+GOvVrZrDvmpBP3qawutRF6Chi+BcigBMWaWyFZp0Wl1iX5vdq
 pYEDWTuXAT5D+cF5X7NFrtJbaHVqn0IonlJ+b5BhJOE5T7p42BTTtfh5QF0VzSOsPch8
 FreFdtBhePWrGQ4TpPKvLqPyVKLRlsqL9JB7Sg5Rxt2f1tzZnjpVhrDFGecW5RZ8GmSV
 Psdw==
X-Gm-Message-State: AJIora/5Tl0jplOhwoc5gZxR+LpyiLLo8Vvg5qNHj4ATGtyHKMAoeYZq
 qOOMZ83r4/wb9YdE8XsDBXC9tnE3u/w/Wm8WKv0BpH5JPHlF5IpnovwjLsq6nE/1UR+yMtKSN4Y
 3f31nFRcNwlwNXtZn/8z9vjEv
X-Received: by 2002:a05:6402:42cb:b0:43b:e8eb:cbc1 with SMTP id
 i11-20020a05640242cb00b0043be8ebcbc1mr3702658edc.414.1659104100508; 
 Fri, 29 Jul 2022 07:15:00 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vUJOgt2w6+0Q5Jaq5HwRHoU+9HQJ7tv7rOc0xdWVP8kM+f15P1mKwXqY/YUj6dgr4mhcfjNw==
X-Received: by 2002:a05:6402:42cb:b0:43b:e8eb:cbc1 with SMTP id
 i11-20020a05640242cb00b0043be8ebcbc1mr3702624edc.414.1659104100238; 
 Fri, 29 Jul 2022 07:15:00 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 s21-20020aa7cb15000000b0043cfda1368fsm2215428edt.82.2022.07.29.07.14.58
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 29 Jul 2022 07:14:59 -0700 (PDT)
Message-ID: <0f5c4c7e-55dd-1042-ed44-0208b8483690@redhat.com>
Date: Fri, 29 Jul 2022 16:14:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [GIT PULL] KVM/arm64 updates for 5.20
To: Marc Zyngier <maz@kernel.org>
References: <20220729084308.1881661-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220729084308.1881661-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andrey Konovalov <andreyknvl@google.com>,
 Masahiro Yamada <masahiroy@kernel.org>,
 "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 7/29/22 10:43, Marc Zyngier wrote:
> Paolo,
> 
> Here's the bulk of the KVM/arm64 updates for 5.20. Major feature is
> the new unwinder for the nVHE modes. The rest is mostly rewriting some
> unloved aspects of the arm64 port (sysregs, flags). Further details in
> the tag description.
> 
> Note that this PR contains a shared branch with the arm64 tree
> containing some of the stacktrace updates. There is also a minor
> conflict with your tree in one of the selftests, already resolved in
> -next.
> 
> Please pull,
> 
> 	M.

Pulled, thanks.  Because it's Friday and the RISC-V pull brought in all 
the new x86 RETbleed stuff, it may be a couple days before I finish 
retesting and do push it out to kvm.git.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
