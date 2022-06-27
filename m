Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A9FC43334
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jun 2022 16:22:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 968B84B2BC;
	Mon, 27 Jun 2022 12:22:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DOXs1X1DzuSg; Mon, 27 Jun 2022 12:22:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97A594B29E;
	Mon, 27 Jun 2022 12:22:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 198CA4B1DB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 12:22:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 67pKmTSzmUVL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jun 2022 12:22:51 -0400 (EDT)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F4A149EE3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 12:22:51 -0400 (EDT)
Received: by mail-pl1-f176.google.com with SMTP id q18so8587740pld.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jun 2022 09:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=cV3hVzy9TYCqPFueATEq37SOh6vFTuLA/SrvAB62Xzg=;
 b=BseriqoiozT548bWf87kfEM21QE/lsC7Xh53iRBx2LmFdeNav386MocuZafko2ZdzZ
 JQe5ovxOhcstFhT8iCD21C825q81Za8C3tdgW13ebnSYPD7k8WHS3yPH0VHQSCGZnmQf
 FicGbHrtEuD0O3jI+Q4LIietAgpYwoWp5qedMxPLBADENHHnn+UkkXouxHyxDA/j0F9g
 moM6KAIDklQszHLohnncrg9SWHa8qDcecTbUS930nHP7JYFxSIbGRQKh+59wLE+AXy7E
 fCLhJT8SPzPCj5eph3yGYAVFqleuzS1aYTb4Me1axhRhNHXk+NS3u9/PAs9nbb1c6HO+
 fcfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=cV3hVzy9TYCqPFueATEq37SOh6vFTuLA/SrvAB62Xzg=;
 b=IpUcIbhptTs/seu7fmxMDasJ3lpEMf4hGp0gsU0feicr4REvkT+t4Y7PvQ+9il2nss
 rADVAQtVjJyiXcAxyDmCBlxnA5U5w9dZxigocAl2av1bgv2/2sVUNZzYvfULC/Wmqbqf
 nqqU35j4ZqcCSVztSmwDHrgDmHXD3sUSSUAN1lnHne9t0+A/vLkh3eqBNo3pbtEt2/sT
 8DbSEHp97k3CNA9onkFeB1inmokWcO0n5C0sYrcmrPFg+H3c/QqTcasm62Vlj7jA6Lkm
 n1ZWzAIEw49Dz+KVZ9bCevmcNbzIyZxQj+kpiiZgMbuNze9ifW6STT90IOyCkGBssN1d
 Y7Vw==
X-Gm-Message-State: AJIora8q/iQkuVNzvPB0+Is3amCJ7wlAPIu49HCIoWJtdsqKNUmhxQlF
 AGbhju5ClqnSM8gkaBCQDLnUzA==
X-Google-Smtp-Source: AGRyM1v1/klo71FJcOnTZoW3zB85VLk+X/utjbZmu0W37du2cpFLJFufJZy1ShhykQNqxxTcsGcOvw==
X-Received: by 2002:a17:902:e54f:b0:16a:29de:9603 with SMTP id
 n15-20020a170902e54f00b0016a29de9603mr15741779plf.46.1656346970060; 
 Mon, 27 Jun 2022 09:22:50 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 o14-20020a17090a4e8e00b001e2bd411079sm9752135pjh.20.2022.06.27.09.22.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Jun 2022 09:22:49 -0700 (PDT)
Date: Mon, 27 Jun 2022 16:22:46 +0000
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v5 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
Message-ID: <YrnZVgq1E/u1nYm0@google.com>
References: <20220606222058.86688-1-yosryahmed@google.com>
 <20220606222058.86688-4-yosryahmed@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220606222058.86688-4-yosryahmed@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 linux-mm@kvack.org, Zefan Li <lizefan.x@bytedance.com>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>,
 cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Jun 06, 2022, Yosry Ahmed wrote:
> Count the pages used by KVM mmu on x86 for in secondary pagetable stats.

"for in" is funky.  And it's worth providing a brief explanation of what the
secondary pagetable stats actually are.  "secondary" is confusingly close to
"second level pagetables", e.g. might be misconstrued as KVM counters for the
number of stage-2 / two-dimension paging page (TDP) tables.

Code looks good, though it needs a rebased on kvm/queue.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
