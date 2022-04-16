Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1AE0C433EF
	for <kvmarm@archiver.kernel.org>; Sat, 16 Apr 2022 06:23:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CA2A49ED6;
	Sat, 16 Apr 2022 02:23:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9OF7YJT3+SXa; Sat, 16 Apr 2022 02:23:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0321F49EE3;
	Sat, 16 Apr 2022 02:23:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DDB749EE3
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Apr 2022 02:23:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hWMb48+AIt1t for <kvmarm@lists.cs.columbia.edu>;
 Sat, 16 Apr 2022 02:23:54 -0400 (EDT)
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com
 [209.85.166.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3333549ED6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Apr 2022 02:23:54 -0400 (EDT)
Received: by mail-il1-f170.google.com with SMTP id y11so387233ilp.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 23:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=7kGQzOanbVYOn3E2/I6eHWRNeF8kbJWDccGBZinYNyA=;
 b=rBmeWm6Xh+wdDYz5RPh2Ezh8mTuDrZ8Mz6yu3hX/xrzi0KrXHeGg5fQOMpAcGwa7XQ
 D/4DlrKL0TuDE5GPF55FXnCOyyrejef3SexMyLDkah+mHcvIDOEHVuh8yoy1yWkYOdC9
 DGFvbrGMS4cskIXRvDRG6GlMHXumEloo72d4GtrD2uGABdHkVhp+QwE/6eJD38UGyqfR
 cNJAEP2KkCUZw0LySL/SZ3vwN9c7hwog2Diek3Mo+I+DATDBG2ZKCIfvSU7iK0Mz878m
 9Xr5nh9E42A0lzxvShmg6W4DNDINRq2eEzdxbhoC2SuxZD4WO520ggYTJmAswNKS/F4b
 STzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=7kGQzOanbVYOn3E2/I6eHWRNeF8kbJWDccGBZinYNyA=;
 b=MRlONUGlhGsOAT/DiVu3yynr4UkugeCzTmErd2fcCy5Tb03R+QeZJt6yuoPVdXWijP
 HOYovL6w9PP+VIT88Nvi9neLI41zF5y27mRKiiwJG+ThTA0PaMUeym7L+qTMRjmMpNOC
 lz+B134eLFwtRXiAoW+z/PVoa4ahmsNJiZobaoI9NpuFaC4e1Yqd1yHXo3irtZBCkH+I
 OAStObyhJQuECwsVotehtcCP1g4SLigXk680B0PYmCb4zs6yNopJtZ7XkbZzbI86yMs/
 +3KbpvTSUba25KaLR9TwdJ9qDYvegVnpamuQSeJSOU0t3NWGVIs9wJ1xb8AOVr1ifbvw
 Qewg==
X-Gm-Message-State: AOAM53230tuI6yDSntb3ZPholzebGCQHg3oMgCk5rONFcAq4j9ujHMAg
 5jTCO4Gvs3QMcQLxM/9v/uuISOcw1tfwqg==
X-Google-Smtp-Source: ABdhPJx4jhYq1M16sthiEkXqSurfMvFzfqy3CGbYFohSNEFKufgt1T3p0m6z4tUXcXTYLx8II2g5Zw==
X-Received: by 2002:a05:6e02:1d85:b0:2cb:fa5e:73fa with SMTP id
 h5-20020a056e021d8500b002cbfa5e73famr861577ila.294.1650090233095; 
 Fri, 15 Apr 2022 23:23:53 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 y4-20020a92d204000000b002ca9d47d5d0sm3814128ily.20.2022.04.15.23.23.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Apr 2022 23:23:50 -0700 (PDT)
Date: Sat, 16 Apr 2022 06:23:46 +0000
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: Re: [RFC PATCH 00/17] KVM: arm64: Parallelize stage 2 fault handling
Message-ID: <Ylpg8l0BDlNpDWjs@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, Peter Shier <pshier@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Fri, Apr 15, 2022 at 09:58:44PM +0000, Oliver Upton wrote:

[...]

> 
> Smoke tested with KVM selftests + kvm_page_table_test w/ 2M hugetlb to
> exercise the table pruning code. Haven't done anything beyond this,
> sending as an RFC now to get eyes on the code.

Ok, got around to testing this thing a bit harder. Keep in mind that
permission faults at PAGE_SIZE granularity already go on the read side
of the lock. I used the dirty_log_perf_test with 4G/vCPU and anonymous
THP all the way up to 48 vCPUs. Here is the data as it compares to
5.18-rc2.

Dirty log time (split 2M -> 4K):

+-------+----------+-------------------+
| vCPUs | 5.18-rc2 | 5.18-rc2 + series |
+-------+----------+-------------------+
|     1 | 0.83s    | 0.85s             |
|     2 | 0.95s    | 1.07s             |
|     4 | 2.65s    | 1.13s             |
|     8 | 4.88s    | 1.33s             |
|    16 | 9.71s    | 1.73s             |
|    32 | 20.43s   | 3.99s             |
|    48 | 29.15s   | 6.28s             |
+-------+----------+-------------------+

The scaling of prefaulting pass looks better too (same config):

+-------+----------+-------------------+
| vCPUs | 5.18-rc2 | 5.18-rc2 + series |
+-------+----------+-------------------+
|     1 | 0.42s    | 0.18s             |
|     2 | 0.55s    | 0.19s             |
|     4 | 0.79s    | 0.27s             |
|     8 | 1.29s    | 0.35s             |
|    16 | 2.03s    | 0.53s             |
|    32 | 4.03s    | 1.01s             |
|    48 | 6.10s    | 1.51s             |
+-------+----------+-------------------+

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
