Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B5CC43217
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 20:02:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DDCC4086D;
	Mon, 14 Mar 2022 16:02:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Xsmi6NgKxGiD; Mon, 14 Mar 2022 16:02:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F138A49EF6;
	Mon, 14 Mar 2022 16:02:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BCC449EBD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 16:02:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QchIad3AQH-O for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 16:02:03 -0400 (EDT)
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com
 [209.85.166.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 36E5A404CD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 16:02:03 -0400 (EDT)
Received: by mail-io1-f49.google.com with SMTP id z7so19753183iom.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 13:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=uWhSAiXtN2kud9zOcgRUJbOu6RBWnBBMw3VH5eaYAVk=;
 b=Z5wn1jQkI/tL2La22TjtqzWpSST81fZ9JcfOvXLTViP7hWAWBun1uo/L60hUZ9iA+W
 ni8c1XupVrx+ACPqZTP9bZzCN55x9A10H4PAwRVU8kMoHC84aaHcwfimlpYyD7ZfeBoY
 yZv/RuGavd53xyvNtorLgojnnZaQyWj2bc72UBvtfwe/6i9ljb5FBMkXn1vJzOVZ3974
 Zcrao9MJ597SPt/7ht67phLP+6X+0u150bJLMC7SEEHFZIWfYGMKY4fEeDtl9z2wiuot
 bf9zjyK+9hn3/IwDvngTcmKxVaONIFKuREe/M3XMiaZXrL258a836JAUj9Mmc9wsrOTL
 qCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uWhSAiXtN2kud9zOcgRUJbOu6RBWnBBMw3VH5eaYAVk=;
 b=ax8+25s3By2C7Z/Pm/GX/Og6838pkv25EqmzYfna/mXCsJojw5Z2edfbKzGFpWBHk0
 09452cS0ZL6mXdoaGbVd/UWD8j6pJLIoABqdDINI5Pd8rRkiVWhSWD3olsdGF/vo3m/r
 YqdcaYF4fLLmzp3wOcYvrCeblFNHi5wVUJS+GCbLo7aGe9I1qGL9ur3hs2TOz9Kyte/G
 Nje7DLOiPe2R+/MldmprDqzZIKfcAwEk9gWR9jOl4JIPy6jVb/1cMEwr+aY6vZIiMBLb
 LmDKn/sKFQ3HIjSQWOKk6BZSvdb1t28gkXPhC5P3zQn57qyEWd5xkRrcG2BPOEm7kIWN
 QLjQ==
X-Gm-Message-State: AOAM531hs9pisqRIwznaxZ1CacbwFn9vgnLh52eA9e5/wt7bq/qd2LCp
 uRxtx/O8HPvuMMtbH+ibZaOV9A==
X-Google-Smtp-Source: ABdhPJx5zEqKVyMxJ+r6McoYCQD64sld7d8x7eq7OhmRF56lD4EEnSDeeaZi8lEf/y3UDHbyHhJz9w==
X-Received: by 2002:a5d:8d1a:0:b0:633:283d:8959 with SMTP id
 p26-20020a5d8d1a000000b00633283d8959mr19911675ioj.80.1647288122399; 
 Mon, 14 Mar 2022 13:02:02 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 f1-20020a056e020b4100b002c68e176293sm8273190ilu.87.2022.03.14.13.02.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 14 Mar 2022 13:02:01 -0700 (PDT)
Date: Mon, 14 Mar 2022 20:01:58 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 09/13] Docs: KVM: Rename psci.rst to hypercalls.rst
Message-ID: <Yi+fNr9w28Nz2j3G@google.com>
References: <20220224172559.4170192-1-rananta@google.com>
 <20220224172559.4170192-10-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220224172559.4170192-10-rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

On Thu, Feb 24, 2022 at 05:25:55PM +0000, Raghavendra Rao Ananta wrote:
> Since the doc now covers more of general hypercalls'
> details, rather than just PSCI, rename the file to a
> more appropriate name- hypercalls.rst.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

You should move the file before adding to it IMO (switch this patch with
the previous one).

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} | 0
>  1 file changed, 0 insertions(+), 0 deletions(-)
>  rename Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} (100%)
> 
> diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/hypercalls.rst
> similarity index 100%
> rename from Documentation/virt/kvm/arm/psci.rst
> rename to Documentation/virt/kvm/arm/hypercalls.rst
> -- 
> 2.35.1.473.g83b2b277ed-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
