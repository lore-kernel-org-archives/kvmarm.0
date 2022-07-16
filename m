Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D65C433EF
	for <kvmarm@archiver.kernel.org>; Sun, 17 Jul 2022 09:28:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8991B4C81B;
	Sun, 17 Jul 2022 05:28:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XILMjVftFFJM; Sun, 17 Jul 2022 05:28:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DBAD4C291;
	Sun, 17 Jul 2022 05:28:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC9A54C8D9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Jul 2022 17:48:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mMm4LlDZlJA5 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 16 Jul 2022 17:48:17 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8837E4C8D8
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Jul 2022 17:48:17 -0400 (EDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1658008095;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=x3HXgQUrco41LDbc708fhSxzFK309rLRf0po+Yszzrw=;
 b=eCdBgF63tI6bMObcpQ2Y+ue1cynT4Jr8YlUT8CmT88+KL0ZW5coTxvgDrWRKX0eWg+R9XG
 pAOeZUmflMafSfx6A4PQQXlBtoyV3SsnNpBSBlNL+gWLnU3/za90g0hILCXV5Yc4rzKB6w
 8Z2sLk2hjVwpKt6sYGVst9+JhM6176I=
Date: Sat, 16 Jul 2022 21:48:13 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: oliver.upton@linux.dev
Message-ID: <385aa28ad559874da8429c40a68570df@linux.dev>
Subject: Re: [PATCH v2] KVM: selftests: Fix target thread to be migrated
 in rseq_test
To: "Gavin Shan" <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
In-Reply-To: <20220716144537.3436743-1-gshan@redhat.com>
References: <20220716144537.3436743-1-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Mailman-Approved-At: Sun, 17 Jul 2022 05:28:40 -0400
Cc: shan.gavin@gmail.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
 shuah@kernel.org
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

Hi Gavin,

Thanks for cleaning this up.

July 16, 2022 7:45 AM, "Gavin Shan" <gshan@redhat.com> wrote:
> In rseq_test, there are two threads, which are thread group leader
> and migration worker. The migration worker relies on sched_setaffinity()
> to force migration on the thread group leader.

It may be clearer to describe it as a vCPU thread and a migration worker
thread. The meat of this test is to catch a regression in KVM.

> Unfortunately, we have

s/we have/the test has the/

> wrong parameter (0) passed to sched_getaffinity().

wrong PID

> It's actually
> forcing migration on the migration worker instead of the thread group
> leader.

What's missing is _why_ the migration worker is getting moved around by
the call. Perhaps instead it is better to state what a PID of 0 implies,
for those of us who haven't read their manpages in a while ;-)

> It also means migration can happen on the thread group leader
> at any time, which eventually leads to failure as the following logs
> show.
> 
> host# uname -r
> 5.19.0-rc6-gavin+
> host# # cat /proc/cpuinfo | grep processor | tail -n 1
> processor : 223
> host# pwd
> /home/gavin/sandbox/linux.main/tools/testing/selftests/kvm
> host# for i in `seq 1 100`; \
> do echo "--------> $i"; ./rseq_test; done
> --------> 1
> --------> 2
> --------> 3
> --------> 4
> --------> 5
> --------> 6
> ==== Test Assertion Failure ====
> rseq_test.c:265: rseq_cpu == cpu
> pid=3925 tid=3925 errno=4 - Interrupted system call
> 1 0x0000000000401963: main at rseq_test.c:265 (discriminator 2)
> 2 0x0000ffffb044affb: ?? ??:0
> 3 0x0000ffffb044b0c7: ?? ??:0
> 4 0x0000000000401a6f: _start at ??:?
> rseq CPU = 4, sched CPU = 27
> 
> This fixes the issue by passing correct parameter, tid of the group
> thread leader, to sched_setaffinity().

Kernel commit messages should have an imperative tone:

Fix the issue by ...

> Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
> Signed-off-by: Gavin Shan <gshan@redhat.com>

With the comments on the commit message addressed:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
