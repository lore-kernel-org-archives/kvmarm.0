Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C54C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jan 2022 18:31:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07DD84A7FD;
	Wed, 12 Jan 2022 13:31:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zZTZuvLAsM7S; Wed, 12 Jan 2022 13:31:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A79C49F5A;
	Wed, 12 Jan 2022 13:31:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22D1149F43
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 13:31:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DdldhVStJbqK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jan 2022 13:31:40 -0500 (EST)
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com
 [209.85.214.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37BC949ED3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 13:31:40 -0500 (EST)
Received: by mail-pl1-f177.google.com with SMTP id i6so5259507pla.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 10:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=hYmCHm4aNV5MWHJ2O9sOJo3oj6e9bMVyslBUiuNSQSY=;
 b=RTVWcU7/7YxaTBvjms3xZXcXKXnRNDO+q+rqpHu0nVgDNdyJGCDkK7TMjWOezse7GR
 QWYAX9fOCh/4hLWo82x6OXCba7GFXqrdQnQVkPpCaMr7GNl/X2qJx9uonr5yyjIigsgL
 BYhET0Pzd5rNskkijaCwfiNThZRzqTZzKktSyCqhMrj+jtkMUZKVd7X/GtwQH4XdknyE
 LiDoY3HZ+nRrQ4KP8y6+pDVef8sx3g4X2XknY1qntpalhGUwLMj4u5ZPVyqBptPyStut
 utgqGxeIcyigEoev+Ooj827LBO21B7SsU4+kSfbdx33uJT6PIYmCDSSiIyOid32XPFJb
 I0rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=hYmCHm4aNV5MWHJ2O9sOJo3oj6e9bMVyslBUiuNSQSY=;
 b=MLG72flcJ9tSWzij3tdpTzKBSGJzEMPVlJEshaoBVcDGVo3v9hpd4+9PvuKm8y2JiW
 PsgcvcL00cdE/m0h2Z+orV2KO9xr8nenSGz1jCRD4R6hJyhq5Y2R/GuqHXPhr7qenQkM
 1Ez428EDathhru65UltegoSzX5pAR+146vSS3kw16lfTskMkk8KsaNlLkwvv6GWgXQ0B
 mgbKOBJrik9WjwGwOLBGBPymNd96F0hhqaSZWQv3CNxCwxhi9/38U3Ffr2R6bSWvEGpg
 2SqnHZE7LAr9ceImDPzgXgI4jUOQTXebToZfv3DF3q5L9L5lBasfddXQM4X0JRKPsZOB
 4+ow==
X-Gm-Message-State: AOAM5309WHxofkiSX/GMLhVy668w/HK0hOHw3aO4dCGuUPFyWQV5uoVq
 qthnmfzusnbs9aeV+Y0uknJeKA==
X-Google-Smtp-Source: ABdhPJwnKqqyDplMQ8Wu3iAphZ5zMnNVPszqWhJ0cEFr9eYR/EuOPheLOy/ZOYelMYL4sArC3nG8KQ==
X-Received: by 2002:a05:6a00:22d2:b0:4c1:d0dd:4b with SMTP id
 f18-20020a056a0022d200b004c1d0dd004bmr535865pfj.59.1642012299180; 
 Wed, 12 Jan 2022 10:31:39 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id t27sm329995pgm.52.2022.01.12.10.31.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 12 Jan 2022 10:31:38 -0800 (PST)
Date: Wed, 12 Jan 2022 18:31:35 +0000
From: Sean Christopherson <seanjc@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
Message-ID: <Yd8eh2dAjN49TlQH@google.com>
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-2-rananta@google.com>
 <Ydjje8qBOP3zDOZi@google.com>
 <CAJHc60ziKv6P4ZmpLXrv+s4DrrDtOwuQRAc4bKcrbR3aNAK5mQ@mail.gmail.com>
 <Yd3AGRtkBgWSmGf2@google.com>
 <CAJHc60w7vfHkg+9XkPw+38nZBWLLhETJj310ekM1HpQQTL_O0Q@mail.gmail.com>
 <Yd3UymPg++JW98/2@google.com>
 <CAJHc60yPmdyonJESHPHvXJR+ekugZev4XzsZc2YV2mnfBdy-bw@mail.gmail.com>
 <Yd8c3zlTweSGhwtt@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yd8c3zlTweSGhwtt@google.com>
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

On Wed, Jan 12, 2022, Sean Christopherson wrote:
> On Wed, Jan 12, 2022, Raghavendra Rao Ananta wrote:
> > Understood. I'll move it to arm64 and we can refactor it if there's a
> > need for any other arch(s).
> 
> Before you do that, can you answer Jim's question on _why_ arm64 needs this?

Gah, sorry, kvmarm@lists.cs.columbia.edu once again lost the spam battle with Gmail.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
