Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40991EB1E
	for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 07:08:11 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id r18so1170661pgr.12
        for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 23:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UAu7Qq9urA/2CACA9Hh+1UR/gyDzRKpeK8exN8pGRGc=;
        b=tPom7jgm4aEV3UcuTrtkJ9WXPYx1xLs3GpHHDkKphwOmPBFKz+yATUKMk1dUX4Czj4
         9m5Z41vo7tXTj7X4CpnPP4xffZ3+eD1hoPOupmGXTUhfpccza0/QJojWLXRBN+MxesBW
         KZEcXnv6FIphs/mg4YlCNzY7DHdrlS6QVeSkGZLMgoDsYR++Us4LGtpvqaXaj5+hqdNN
         2LA9sydaeL6d283yzEM9HnUJWbNrbdbNUZkXH08AuHtpCWvJHy7hE6HSL3aJJbCpXFwI
         UD0QHIiRDU2+sHuipLJUXt8zTOxvp7n2MWM0ecdjFJKRG+6u2eNgX+75bjq4NKrmPGEK
         wCGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UAu7Qq9urA/2CACA9Hh+1UR/gyDzRKpeK8exN8pGRGc=;
        b=JuNAxH4RMrrgG1spofkDUNyLoKMCTgvt4QaEZ0/zSfR3/r0eXbUFdO2aCYcrXf5zK9
         Vj83n03kaHJZxgrNIfyJILYbxHNouMB5UlxxL7plzLld2TAEz8vkbZ8v6adVGahUI6T3
         7ADajR9ITxLJkJQcPVEX/JHkh2rBzquy0o2d+oeTPLYo8OPNwsvP35RhzZ0h2PoHRBuS
         G18UYb6OyblsubUp4uu3RT/UslEDvdUAd771+oCNYu9otzamYdvSzqrBKZjwKOoJkGT0
         DBE+AGpvRKxH1jL6rfERRwNARaiPJH8nSjfkDDT2CVDa/4gfkzSwdNlIey/WA9H3Vyfj
         E7wQ==
X-Gm-Message-State: ANoB5pl7rt59w/WOYoOnT8nkWxTpTz7J7ZoTDZkgHyVIsXxC/87O0h/s
	QkbW4ba143WnPTJ67E5chUzO7qXQWGztJCI6Eij0++SWblNfOQ==
X-Google-Smtp-Source: AA0mqf6FeRrcOYfgd5QoCZHb7tiY6I/edy2aB82zFoI+g9lRRZuamw4/hvEK8BIr963Kkgm7Yq/eSFkC85iYBhQeVzw=
X-Received: by 2002:aa7:80d8:0:b0:56d:98e3:4df8 with SMTP id
 a24-20020aa780d8000000b0056d98e34df8mr1695579pfn.37.1668668890570; Wed, 16
 Nov 2022 23:08:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221117002350.2178351-1-seanjc@google.com> <20221117002350.2178351-3-seanjc@google.com>
In-Reply-To: <20221117002350.2178351-3-seanjc@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 16 Nov 2022 23:07:53 -0800
Message-ID: <CAAeT=FyKq8oeer7b0McUkGRbvmUPH4+hLnWPKZmGQ3uWgkUNcQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Disable single-step without
 relying on ucall()
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221117070753.6rxeyDRKNBDBd5wAmYHO3Rg7I716qSq3aPc7KHdX29o@z>

On Wed, Nov 16, 2022 at 4:24 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Automatically disable single-step when the guest reaches the end of the
> verified section instead of using an explicit ucall() to ask userspace to
> disable single-step.  An upcoming change to implement a pool-based scheme
> for ucall() will add an atomic operation (bit test and set) in the guest
> ucall code, and if the compiler generate "old school" atomics, e.g.
>
>   40e57c:       c85f7c20        ldxr    x0, [x1]
>   40e580:       aa100011        orr     x17, x0, x16
>   40e584:       c80ffc31        stlxr   w15, x17, [x1]
>   40e588:       35ffffaf        cbnz    w15, 40e57c <__aarch64_ldset8_sync+0x1c>
>
> the guest will hang as the local exclusive monitor is reset by eret,
> i.e. the stlxr will always fail due to the VM-Exit for the debug
> exception.
>
> Link: https://lore.kernel.org/all/20221006003409.649993-8-seanjc@google.com
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
