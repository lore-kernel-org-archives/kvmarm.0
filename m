Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 943CFC4332F
	for <kvmarm@archiver.kernel.org>; Mon, 17 Oct 2022 22:08:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11E7A4B7FE;
	Mon, 17 Oct 2022 18:08:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lGcbJCFK52Q2; Mon, 17 Oct 2022 18:08:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE7C74B6C5;
	Mon, 17 Oct 2022 18:08:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A59584B642
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 18:08:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5PgYQGZZKeKQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Oct 2022 18:08:53 -0400 (EDT)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 911654B637
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 18:08:53 -0400 (EDT)
Received: by mail-pj1-f44.google.com with SMTP id
 p3-20020a17090a284300b0020a85fa3ffcso15558879pjf.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 15:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=E/4DPPSX+8EYQafccV5qoWyCAmySO2GlahoEOcD6yiE=;
 b=Yr6JLfOIBxsKsz9I81OiNXnHbvZe5DM4pgR+uEoYH9sosgPO2rEO9K4G+qgZcbCE0U
 dTjnOvWDqDSlsJfMdwq3OtHjSYCYd3/LLgOEG5kyfW2xJhshGpV8I3QhStzNjmwrCJ0A
 gYEc6qcNjEDJoOlg83VOzJm1C9FvslOZE52zCPRKmR5jIRODorBIp1kj6JrSJJzQZqQE
 I+X0qBQoHjnWHd6E2mDIrvtlcei3hjswxq7xnKtwkiV7YL4gFTCpNIkofc842YMEeDRj
 eOpmxZRx843MuJ2S2rHWvSqj1+3EhvznOxSzyBMMZpc+HrJVthRanCFpAx6bGuHwJ/YG
 7DFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=E/4DPPSX+8EYQafccV5qoWyCAmySO2GlahoEOcD6yiE=;
 b=eTapsd28GeoK7aTXZIxUSYUSYO+k5gYM7OJf3cFLi+/PtAIZXNBQV1/ILIgHBALDIv
 8m9IM0hIZq3TltqW8Z5ZaHJHaDkso7HiBUWtrEmgI95Nv+udGzOo6E8KZ9M5A8ZowF2t
 tIsiUrozSR2fFEd7mqs+XQB5n1BaWJOERBSproA95GyrQrrWf1292yXOfBZoMkwy+knt
 Y87sdl+kIMBeS2xcTwj+y1kMgNT+t1bNaEb0vLcKkhjDWAEg5FKN4XXlUycKkJgcrD44
 OjEG4wUPPAWQsCIdVqQaCehKqHkhr73Ou1GuFPezEo7FV85ZqQPzSMwxh7jfteH9FIKo
 glqg==
X-Gm-Message-State: ACrzQf0FFO0mq+N7IArk4YVGyhFeVG4SDQGCHqv2KrW8Gr+RgQeuSP+O
 00IifE3hWUZvkP18jy+PcDX59g==
X-Google-Smtp-Source: AMsMyM7OKbGy+gHYEZBmAhjYnTpH7SayEGMvYLH1S8U7VKh6K5NkPUXY+1ryx2Vy+ZsIUIHEmiPNNw==
X-Received: by 2002:a17:903:2347:b0:181:33f0:f64e with SMTP id
 c7-20020a170903234700b0018133f0f64emr14442474plh.106.1666044532381; 
 Mon, 17 Oct 2022 15:08:52 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 y17-20020a17090a8b1100b0020936894e76sm6659955pjn.10.2022.10.17.15.08.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 17 Oct 2022 15:08:51 -0700 (PDT)
Date: Mon, 17 Oct 2022 22:08:48 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate
 memory sizes
Message-ID: <Y03ScGUUCA1KwlLF@google.com>
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
 <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 zhenyzha@redhat.com, shan.gavin@gmail.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
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

On Mon, Oct 17, 2022, Maciej S. Szmigiero wrote:
> > +#define MEM_EXTRA_SIZE		0x10000
>
> Also, an expression like "(64 << 10)" is more readable than a "1"
> with a tail of zeroes (it's easy to add one zero too many or be one
> zero short).

+1 to not open coding raw numbers.

I think it's high time KVM selftests add #defines for the common sizes, e.g. SIZE_4KB,
16KB, 64K, 2MB, 1GB, etc...

Alternatively (or in addition), just #define 1KB, 1MB, 1GB, and 1TB, and then do
math off of those.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
