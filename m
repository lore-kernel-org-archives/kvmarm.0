Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60559C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jul 2022 17:08:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE9F34B84D;
	Thu,  7 Jul 2022 13:08:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kSgymrmtyhuD; Thu,  7 Jul 2022 13:08:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B33834B9A1;
	Thu,  7 Jul 2022 13:08:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FFBC4B902
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jul 2022 13:08:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HFWIsUuDqK1L for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jul 2022 13:08:41 -0400 (EDT)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
 [209.85.210.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 257834B8AC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jul 2022 13:08:41 -0400 (EDT)
Received: by mail-pf1-f181.google.com with SMTP id l124so10259774pfl.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Jul 2022 10:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=aDwhAz56getKu/7dUfZtUNg+bMQnNfCv/r3Lo81Gt4c=;
 b=OKld0gkkD90FJcYLX8kyBvnUJUDj9BzEcNLpEOkQeEoIWLEfJ2D+KLUYi5d/Q8PoU7
 fjQxBXgI1cNDJZYaFxlz5v1fdwQCKeXJkZtFR5RoS/IDTRWL4cuMqkcJ9PjDItMp5wWX
 cQfcJhh+YhR/nZj1cqhKJ2CtyJIUuzgZP9DjYym+UVyxAz73eOTRQV8nS5lt21HahXSD
 ECMRqQ+Wtp5dAO9uMSd2eec76gtUdPShhuNbCQQpwn+GeFn/m/DVh17yUhgN6YfG/Awq
 ASzsGt9WU4hHjobp076NKKcyYMpGP+arYWU6ObtfpOJF/se0lT+3Q5og9NgLxhiDiJft
 Vr3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=aDwhAz56getKu/7dUfZtUNg+bMQnNfCv/r3Lo81Gt4c=;
 b=aN5VRsiDdITr132vMnshjiLGF/UnBmzK5YEjux+OE65GgKpr3i1p0eo20VInSRDhtv
 41++cXKyqnpTdwuhF/oQTJ8+1DA6GNWMLBFZ/jlD9eIqVUFn8In0Cp2/d3bWaFRmKZgB
 0R+tMUQ9ovBJTOcokowY+obP823WQedS/WVMuT4BsUAKedGLngu2WnIc6qvN5tnTRWJI
 z7clukOKyTn28vb2G6sKBVnJyirxlsEwtgD1eoA4ml0CnK332ccP11RYCnXNBO6LKt6j
 zz5ycM3OVVOgUubAD2xk8Rwlw6J7xhxf1q3vhUD5jIwYQPu35205qmsSrwN6lrAVz2xp
 NSqg==
X-Gm-Message-State: AJIora+ThVNiXWO1zg/lZz9seWsbE+MEKGqgFIGx9HxbHwlxKmcqS45k
 Js1dLgt1FGaRBBXldJAeLLjgaA==
X-Google-Smtp-Source: AGRyM1ufPqH2WbJJzRXHiO3zNWh9EqE5AA0H0qB0Szi3BpKm2CLKdbn8dZanOb84ZZc4TKI1GbfHAQ==
X-Received: by 2002:a17:903:25d6:b0:16b:f5cd:2cc3 with SMTP id
 jc22-20020a17090325d600b0016bf5cd2cc3mr14214425plb.74.1657213719848; 
 Thu, 07 Jul 2022 10:08:39 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 r20-20020a170902be1400b0016b68cf6ae5sm23565302pls.226.2022.07.07.10.08.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 Jul 2022 10:08:39 -0700 (PDT)
Date: Thu, 7 Jul 2022 17:08:35 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 00/22] Support SDEI Virtualization
Message-ID: <YscTE/dPQIeiobT1@google.com>
References: <20220527080253.1562538-1-gshan@redhat.com>
 <6bdb9280-3530-dc1f-d33e-5bc1c5ac927b@redhat.com>
 <87iloq2oke.wl-maz@kernel.org>
 <f719c5fb-3e41-38ac-1b16-fcb603e4911f@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f719c5fb-3e41-38ac-1b16-fcb603e4911f@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Jonathan.Cameron@huawei.com,
 linux-kernel@vger.kernel.org, eauger@redhat.com, shan.gavin@gmail.com,
 Catalin Marinas <catalin.marinas@arm.com>, vkuznets@redhat.com,
 shijie@amperemail.onmicrosoft.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, Peter Feiner <pfeiner@google.com>
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

On Tue, Jul 05, 2022, Paolo Bonzini wrote:
> That said: Peter, Sean, Google uses or used postcopy extensively on GCE
> (https://dl.acm.org/doi/pdf/10.1145/3296975.3186415).  If it doesn't use it
> on x86, do you have any insights on why?

We still use postcopy, but we don't use async #PF.  Async #PF is disabled (mostly?)
because the x86 implementation was such a mess prior to switching to IRQ-based
delivery and AFAIK we haven't re-evaluated it since that update.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
