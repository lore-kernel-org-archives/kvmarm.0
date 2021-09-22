Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0655C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 15:37:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2D749610A1
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 15:37:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2D749610A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95AEB4A500;
	Wed, 22 Sep 2021 11:37:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G2jXkYyd8gum; Wed, 22 Sep 2021 11:37:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 863644B08B;
	Wed, 22 Sep 2021 11:37:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 544764A500
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 11:37:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FaNqEWWiGQ88 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 11:37:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F69D40256
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 11:37:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632325061;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=yPMfBTlyhQaNIBRsQlgsKkEXI7vjlBDH2c8APmBdvAw=;
 b=GLJwTkgLpxnv7yuh8KpMLB5Vy7ZqEZowHFJ5LQOlC0yzN3/ptUE8CmqFDFRTXVR/CXglrk
 LcNg7D5OfzbvsLGv6+UpZR4q5FDz2IN36UgEo/3H/W5tIOwooBtgSjmbSQNjk7/aXgrl+7
 hnL/4zTkTWSphH5f8WX1eR87Rt9XWhA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-bqdcXD5mOsaloew4oLDTFA-1; Wed, 22 Sep 2021 11:37:38 -0400
X-MC-Unique: bqdcXD5mOsaloew4oLDTFA-1
Received: by mail-ed1-f70.google.com with SMTP id
 s12-20020a05640217cc00b003cde58450f1so3525562edy.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:37:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=yPMfBTlyhQaNIBRsQlgsKkEXI7vjlBDH2c8APmBdvAw=;
 b=KhheC1bsm5deZKDWenZMqO//Ao/N1Mud4gDNXV4ThrCtbdap5zPhVBy5r4WxPL6X88
 A/2/n1utwnF+PYmapFXjDh1CmHixa/R3KwOkBI+OycudC2opNBgA3raLEh0SS/ZWD8vt
 r587jJ7EkxIiy1K940PlUQCqAJb2M0+rHiJ2aWvkCRIdQBbKAIA65m9a0gXKPw6yZaTz
 qWZ3fz26SknUDc4i5LOBM4BR1c/ZCT8fMSnA+y1vJrSu6Lw4280re6+jjpqx3ZFyE0K7
 zeSTdmDM9iX26NmyVLy1FqWtRRlEIDdkE07mqBf8JfkdsExBwUFkKsum/tHrgxwQIDVB
 q+aA==
X-Gm-Message-State: AOAM531DzUFuM5Jwi+G4HU2FQ8pkwNs61PM9j+gvUH14w0+ac2FS0aHT
 C67HcwriE8G0YG/7KlkyKErXaCNq3tTFHmDnqLR+ywSc+Fe7XPpGLzV1+eckzGxBzwJTe7MU1EV
 H8xgqeMttlHmjnZ8isXsDK+Sa
X-Received: by 2002:a17:907:1df1:: with SMTP id
 og49mr176120ejc.35.1632325057663; 
 Wed, 22 Sep 2021 08:37:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqc1iXc2OLrx6isUvPIHnN9Gan4Ne4+V8C0dmc4M3Gy8q4yKHumt8T875e2Dt+Me/ihh1nbg==
X-Received: by 2002:a17:907:1df1:: with SMTP id
 og49mr176096ejc.35.1632325057433; 
 Wed, 22 Sep 2021 08:37:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id z20sm1398413edl.61.2021.09.22.08.37.36
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 22 Sep 2021 08:37:36 -0700 (PDT)
Subject: Re: [PATCH v1 3/3] KVM: arm64: Add histogram stats for handling time
 of arch specific exit reasons
To: Marc Zyngier <maz@kernel.org>, Jing Zhang <jingzhangos@google.com>
References: <20210922010851.2312845-1-jingzhangos@google.com>
 <20210922010851.2312845-3-jingzhangos@google.com>
 <87czp0voqg.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d16ecbd2-2bc9-2691-a21d-aef4e6f007b9@redhat.com>
Date: Wed, 22 Sep 2021 17:37:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87czp0voqg.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: KVM <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
 Will Deacon <will@kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>
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

On 22/09/21 13:22, Marc Zyngier wrote:
> Frankly, this is a job for BPF and the tracing subsystem, not for some
> hardcoded syndrome accounting. It would allow to extract meaningful
> information, prevent bloat, and crucially make it optional. Even empty
> trace points like the ones used in the scheduler would be infinitely
> better than this (load your own module that hooks into these trace
> points, expose the data you want, any way you want).

I agree.  I had left out for later the similar series you had for x86, 
but I felt the same as Marc; even just counting the number of 
occurrences of each exit reason is a nontrivial amount of memory to 
spend on each vCPU.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
