Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0683205
	for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 22:30:05 +0000 (UTC)
Received: by mail-io1-f74.google.com with SMTP id d20-20020a6bb414000000b0073dfed277b3so7401498iof.16
        for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 14:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ECyQ2h7pgSQ60EmXtNk1SWocHJlTygvBJCNq5ZcRNTo=;
        b=g8cKGXIYlOpwQIMI0zxYk1r5qU2O7f6RyEzh/KJBha7sUA9jfC465GN/y1ukzVsDmI
         TOAy0MVajT6cwunNgMzH8m3VmpL9sZ2y2WHe1ViAKxBEUVYDZuw4mwHamNqPj/G/J15z
         ekLz2v6YF5E5dr5YZdH1qtfCY+gS4DMEozX4fRruQvsdFBb/1emAzmyXMCkrgfiFIuLi
         mBXkfwQLoF+Sk0hP5R4tSAuHEG/sCt6YvWNxZRkSeRw6zF1Y/PCWmbqzxFvOH+hSSa2L
         qQA4LPwBUZyk7QUNLAheaoStrYcp84ivG1n/QfLQEy5qBk155HPBAQc6yrWBVdDxzM1h
         rWLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ECyQ2h7pgSQ60EmXtNk1SWocHJlTygvBJCNq5ZcRNTo=;
        b=U6suKdFoAuXfWSNfoa7xKyvDu9jxClRrb97O8zmeFCfNZ62nDCWn6KBVP0XhNHPZWh
         CNDfFz9z0Wu7JtDM6XJZoIWfBJe88aY4UdU2PdcpN74ixvVDOW/2bg7rmbcfcHOYqdYf
         4oSmZM+oolbKl1r2aFePJ0BAbsOWZJY5uUE0mYxzgZre/1en2ndYQlb7w4GueBe9M3on
         cxX/NXFxEVgsPYlFgO24Q4acK3X8EdKx8ADMugbWltoxsdNwTq2Ony4k05VaWMsI0Q6E
         ZjAc88YzB/w6n2H0EbNEDBuvFUwH18hsO42u2CRClpiFWXNCjSJTVf37ZuVH/uxT7Cw7
         9iYw==
X-Gm-Message-State: AO0yUKWvBDi9t2K6Xb4kGQeQqL+PiSBBfJEKPPIpNxGrI5tQlW+QpNt2
	TP9kBPfP0l9DgHOKr03zqfes525OMWPjn2BU8w==
X-Google-Smtp-Source: AK7set/gbGS3Uv2EswHYrTPmM4XxtlKLhss8UMOfmPrTUjGWeUJQrEGWJMcGShq3M35ce3TCkIqNRr9Ylp/xLNBnxg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:229a:b0:3be:81d3:5af3 with
 SMTP id y26-20020a056638229a00b003be81d35af3mr5208190jas.3.1677191404566;
 Thu, 23 Feb 2023 14:30:04 -0800 (PST)
Date: Thu, 23 Feb 2023 22:30:03 +0000
In-Reply-To: <20230216142123.2638675-4-maz@kernel.org> (message from Marc
 Zyngier on Thu, 16 Feb 2023 14:21:10 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt356w9fro.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 03/16] kvm: arm64: Expose {un,}lock_all_vcpus() to the
 reset of KVM
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, 
	ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

nit: kvm should be capitalized in the summary line
