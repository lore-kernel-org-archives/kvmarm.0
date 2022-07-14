Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFCBCCA47B
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 15:35:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B51E14C5D3;
	Thu, 14 Jul 2022 11:35:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wj1o6JE7VLt3; Thu, 14 Jul 2022 11:35:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 326724C5CF;
	Thu, 14 Jul 2022 11:35:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C9934C591
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:35:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZZd3+a-dL9ZB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 11:35:21 -0400 (EDT)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED2D74C46F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:35:20 -0400 (EDT)
Received: by mail-pl1-f180.google.com with SMTP id k19so729738pll.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 08:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=jw1a9NtjnOcexhTaceVUjWOdMbEAyVZWH2rm/Z273eI=;
 b=YHnEONUUADoF25ewKQsfvyaT/jYYsD0ZZqw3dUFMQPFDIqP6QxU1Gpb0D0zhBERlk4
 VKYPTedjmR1o9+0RrFfJrMtLJAhnh2jkFQK7FHEckQH6vNf18NIQmbFu1N+i+GcmKMEt
 awvouvFnp4VVllw+8MZfUeMwz05GBkwWr7fX6y5KGYwKHq/XaaOPCiJOwB4MzUKgrij5
 2gvb97v1hB5c9mpWrDOHarQOn0UTpIKtgNpN/EwC9h2gVpIJW1UcgrH1N/lH7uZgaaNP
 kwJpnIKnP6HcP+iRMzRfB/NmzYruha9ZqRvaW3/u19SVpoTlenWU6qcMRSmyNA8OobMB
 8zQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=jw1a9NtjnOcexhTaceVUjWOdMbEAyVZWH2rm/Z273eI=;
 b=v2BBnkQZHf4rqmrQE0OBqpL9RW+fzX1H63FvpMF2Dfpqy2qg7OihzgkLklECg0ddUB
 +NcY2Z9UB7Yx2KFVXFp/BZovRPW+4Og9Lwq75oZ1GnWEQDVrYJuQff/eYROAg4N7EMke
 Lo3ObuWSIrNuKUOAygB0qlju520qYy75Lw2dtcPBtkeNIwaxKeUejkWjgadBg2pvu4Nl
 dhRjm2bqU5iBv24eD0plm4Qbh7FN2oa0A06SzdviHGDXqpw2Wn968JpU9CoIDlQK1ouN
 dPWFZYOsJvyRrUG9DqPGf8ILbnqKt5aV+2Kn6EpXesN8dfAO2IsWvYPz9KPE49TCtpSX
 0pnA==
X-Gm-Message-State: AJIora+NoaGu3wsaZriV9Gz1ICz48ntCr4AtcNnFeuNMwwNKURY3lTk+
 kpDVnBel5f9HDZgDsg8Hmi6r0A==
X-Google-Smtp-Source: AGRyM1vgNMOGyztZqnYxoIF9PKBibGcaOhduSNpBg1CPhgLHMpeyBynnCEbmfS68T5oS+8JWZemjrA==
X-Received: by 2002:a17:902:a388:b0:16b:d52b:a038 with SMTP id
 x8-20020a170902a38800b0016bd52ba038mr8872152pla.56.1657812919607; 
 Thu, 14 Jul 2022 08:35:19 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 mm18-20020a17090b359200b001efa35356besm3836222pjb.28.2022.07.14.08.35.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Jul 2022 08:35:19 -0700 (PDT)
Date: Thu, 14 Jul 2022 15:35:15 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: selftests: Double check on the current CPU in
 rseq_test
Message-ID: <YtA3s0VRj3x7vO7B@google.com>
References: <20220714080642.3376618-1-gshan@redhat.com>
 <cd5d029c-b396-45ef-917b-92e054659623@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cd5d029c-b396-45ef-917b-92e054659623@redhat.com>
Cc: shan.gavin@gmail.com, kvm@vger.kernel.org, maz@kernel.org,
 linux-kernel@vger.kernel.org, oliver.upton@linux.dev,
 mathieu.desnoyers@efficios.com, linux-kselftest@vger.kernel.org,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Thu, Jul 14, 2022, Paolo Bonzini wrote:
> On 7/14/22 10:06, Gavin Shan wrote:
> > In rseq_test, there are two threads created. Those two threads are
> > 'main' and 'migration_thread' separately. We also have the assumption
> > that non-migration status on 'migration-worker' thread guarantees the
> > same non-migration status on 'main' thread. Unfortunately, the assumption
> > isn't true. The 'main' thread can be migrated from one CPU to another
> > one between the calls to sched_getcpu() and READ_ONCE(__rseq.cpu_id).
> > The following assert is raised eventually because of the mismatched
> > CPU numbers.
> > 
> > The issue can be reproduced on arm64 system occasionally.
> 
> Hmm, this does not seem a correct patch - the threads are already
> synchronizing using seq_cnt, like this:
> 
> 	migration			main
> 	----------------------		--------------------------------
> 	seq_cnt = 1
> 	smp_wmb()
> 					snapshot = 0
> 					smp_rmb()
> 					cpu = sched_getcpu() reads 23
> 	sched_setaffinity()
> 					rseq_cpu = __rseq.cpuid reads 35
> 					smp_rmb()
> 					snapshot != seq_cnt -> retry
> 	smp_wmb()
> 	seq_cnt = 2
> 
> sched_setaffinity() is guaranteed to block until the task is enqueued on an
> allowed CPU.

Yes, and retrying could suppress detection of kernel bugs that this test is intended
to catch.

> Can you check that smp_rmb() and smp_wmb() generate correct instructions on
> arm64?

That seems like the most likely scenario (or a kernel bug), I distinctly remember
the barriers provided by tools/ being rather bizarre.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
