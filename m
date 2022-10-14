Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D8E7C4332F
	for <kvmarm@archiver.kernel.org>; Fri, 14 Oct 2022 21:15:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B08DC4B62E;
	Fri, 14 Oct 2022 17:15:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8in0X804pPrT; Fri, 14 Oct 2022 17:15:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 916394B5F5;
	Fri, 14 Oct 2022 17:15:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5737B4B355
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 17:15:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kkK3euoa7HgA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Oct 2022 17:15:07 -0400 (EDT)
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com
 [209.85.210.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3592D4966F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 17:15:07 -0400 (EDT)
Received: by mail-pf1-f172.google.com with SMTP id d10so6016301pfh.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 14:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=PZCd+YWp6Rkdf8GaAemTwPAfWHSubBGbIoqG74NI1ms=;
 b=cRoXvbDvQMwnmouYRU9bA6BnbMqIjlR+t9dwtgHTh24hpPv7uk3XmVXIJbgw6P8Eg9
 uU3QY2KRaVJK0F92yWi4lVW7keg0Y9Lful81loNULOo4P9SHVXeJSgQyrCaLfy3IHwIO
 Obc5PDktwXnmgO12NR7VgdJPy/2idgNnHwyMniFZgxK7Es52QbzYDil5VIddOwZ9ycLV
 /tsBIK0Z4qWqa44E/uQID8GzRzZNBvLyhcV8n6p+8JmNYRddayZJ+2GJDUnWEp21MPsQ
 FphmiTX70hT3biWGoKJmjEUTUTIpadx1/5gtx6nTy/QFCJcUIglQuje8g1WsugdjDiHx
 c6Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=PZCd+YWp6Rkdf8GaAemTwPAfWHSubBGbIoqG74NI1ms=;
 b=1cCec+nSYa3ZuItsSjqoDVAlxf/RmFznA16Renzc7/rp96AWzVZzYjpUxbP6+mv7wZ
 XKsVDQEZ6yJmge6fhRFC/NYnsVN+Gh5U5XB9987547KLZKdnn65Ezmm/Y521KQAiIVpA
 Ct37a+kbWP9AnWjUoHQzBFnx6cltiOSLEnQ+9HjdhIJj3j5w16psLYNGC7HX1z/i+Bjs
 As1MvVnFhCjAIGYIVu9e1mLKHb52rknafIInmh1Mu2PZjfyVhDqxtG8BS5ZeFxZ1coj6
 jEGgP66iVLCE2nXSWDBt5NtW4BumY/Qvo8UW8SIB6e8sR9sLri4BUiCJIYb6vrCIKewn
 FfSw==
X-Gm-Message-State: ACrzQf33FmovgS4PoQEKt3QUJqBvVmN4E1H7bDKFD7CjU5ghhlXXxXEz
 P1oG/74WqsDykfID8p1D8QQ4tQ==
X-Google-Smtp-Source: AMsMyM6RmjeHSSzE4pJtJXoG7Eo99Kdim1xVs2z0jB4XgAle1pf8E0nfbUcXkYLxxP7MtTx96ZTsyw==
X-Received: by 2002:aa7:8d17:0:b0:560:485a:e242 with SMTP id
 j23-20020aa78d17000000b00560485ae242mr7099026pfe.31.1665782106003; 
 Fri, 14 Oct 2022 14:15:06 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 u2-20020a17090341c200b0017f7bef8cfasm2127464ple.281.2022.10.14.14.15.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 14 Oct 2022 14:15:05 -0700 (PDT)
Date: Fri, 14 Oct 2022 21:15:01 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v9 01/14] KVM: selftests: Add a userfaultfd library
Message-ID: <Y0nRVTcWGybRAw+q@google.com>
References: <20221011010628.1734342-1-ricarkol@google.com>
 <20221011010628.1734342-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221011010628.1734342-2-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu, dmatlack@google.com
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

On Tue, Oct 11, 2022, Ricardo Koller wrote:
> +struct uffd_desc *uffd_setup_demand_paging(int uffd_mode,
> +		useconds_t uffd_delay, void *hva, uint64_t len,
> +		uffd_handler_t handler)

s/uffd_delay/delay, and then this prototype is easier to align.  Keeping the
uffd_ prefix for "mode" makes sense since that might be ambiguous, but like
"handler", I don't see much value in prefixing "delay".

struct uffd_desc *uffd_setup_demand_paging(int uffd_mode, useconds_t delay,
					   void *hva, uint64_t len,
					   uffd_handler_t handler)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
