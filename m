Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC644C4332F
	for <kvmarm@archiver.kernel.org>; Tue,  1 Nov 2022 20:22:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 510F14BABE;
	Tue,  1 Nov 2022 16:22:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XFI5o6-zA5LY; Tue,  1 Nov 2022 16:22:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AD444BA8C;
	Tue,  1 Nov 2022 16:22:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 438664BA8C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2022 16:22:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t0-5UC3YCBzS for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Nov 2022 16:22:20 -0400 (EDT)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C5B14BA1C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2022 16:22:19 -0400 (EDT)
Received: by mail-pf1-f180.google.com with SMTP id v28so14320567pfi.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Nov 2022 13:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=xVkJZtEBpIeuzqQn3nnjuzEWSUM1mVqhj+nnH0c1tQc=;
 b=M4X/osJ6VqZpKNtuP99fp4hNhqecoTugRL5QfWaIhyUxA9c53vT2gzUsKKGIv4cq+D
 N4IonfyyypScYrsv8ODBCuTAKMU/o3MuedyC4XY7mQxji9pS70V0SKgDvwYFSfWhghQ5
 DSHIteFpQ5DT8H/yuhvbuDJ+aT14g2LOoyFC7UtDqZDOCQSYZGT07KnHz1DlHeril/bj
 KZ6lYlB1F8nR11PVom9zZllOxYKCdv33fJC9+NNvtrvNHgsPRLMmiaeyoIMyvL0/2rzw
 cm6ucLucJ1hX/EB3aXe+tUxGs+j1hQ/M65oNHUJ7CRlwtvLEnlMzSzEVZREE3HFHamlW
 wBrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=xVkJZtEBpIeuzqQn3nnjuzEWSUM1mVqhj+nnH0c1tQc=;
 b=PLofyllPSkeAYngW9NEphs5IcvE/eGEfvAVWY6IRcGtusMo7WnkKaj7TpJthzgZNnA
 0zmdhJFyZfOayZNCYHJeVtIpIw+RGTn5kty6P2gJmb1xpQHaU6ZK+Xg+xffb3RFOeMZO
 nSYupg36NPKQtehwa/79ETr5F1pXrj4zl+39QOpAAauJ3Ya+nzgtAHv3xaTIPNG/qFns
 S7t0puFHrWVy+m5aeoMlc1cGO4mkZSWsSDoCwsPpQsByaLkKIdXy52TJN5porQhIvKvH
 Y8GeUxD99aNOpH832uJ9467eOn4NoJ2qfL1ATZoLrUfLzPpiSij5UdYrH8JO7l+dDIxt
 828w==
X-Gm-Message-State: ACrzQf3qjQug3NIulHpJUj5r/WQgtx9pwUXwPboZTG8zQF0uo92Sp2AH
 5yKbsM5a0mcrlqInjN5Y9wsBpQ==
X-Google-Smtp-Source: AMsMyM7fD/Ym5AIcfwQwPvEeDSThfT/5hUO484wIK3KagW5eWCNhPeqPpcfATaT8FOx4g4d/EWqTBw==
X-Received: by 2002:a05:6a00:2481:b0:56b:dc84:7ad1 with SMTP id
 c1-20020a056a00248100b0056bdc847ad1mr21687157pfv.43.1667334139000; 
 Tue, 01 Nov 2022 13:22:19 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 x5-20020a170902ec8500b00187022627d8sm6816709plg.62.2022.11.01.13.22.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Nov 2022 13:22:18 -0700 (PDT)
Date: Tue, 1 Nov 2022 20:22:15 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v3 08/15] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y2F/96RnvGPompIC@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
 <20221027221752.1683510-9-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221027221752.1683510-9-oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thu, Oct 27, 2022, Oliver Upton wrote:
> The use of RCU is necessary to safely change the stage-2 page tables in
> parallel.

RCU isn't strictly necessary, it's simply _a_ way to ensure readers have gone
away prior to freeing memory.  E.g. another method (used on x86 at least), is to
disable IRQs when walking page tables without holding mmu_lock, and then requiring
paths that free page tables to effectively do an IPI shootdown of all CPUs that
are reading page tables.

And "safely change" is misleading.  RCU doesn't allow safely _changing_ page
tables; if RCU did, then patch 10 wouldn't need to implement atomic updates.
Protecting page table walks with RCU is purely about ensuring readers have gone
away prior to freeing the backing memory, an entirely different mechanism is needed
to allow parallel updates, e.g. the CMPXCHG + KVM_INVALID_PTE_LOCKED approach to
ensure only one walker "owns" the detached page table.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
