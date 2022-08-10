Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A90E5C25B08
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 12:13:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0904C4D892;
	Wed, 10 Aug 2022 08:13:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@efficios.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LLqRDIQvI86a; Wed, 10 Aug 2022 08:13:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB4B94D88D;
	Wed, 10 Aug 2022 08:13:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 929874BD9A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 08:13:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6deAx0r1qZNl for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 08:13:48 -0400 (EDT)
Received: from mail.efficios.com (mail.efficios.com [167.114.26.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39DEB4BD24
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 08:13:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mail.efficios.com (Postfix) with ESMTP id B914F43E374;
 Wed, 10 Aug 2022 08:13:47 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
 by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
 with ESMTP id 8t9Hz8TKmCkp; Wed, 10 Aug 2022 08:13:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mail.efficios.com (Postfix) with ESMTP id 299A343E476;
 Wed, 10 Aug 2022 08:13:47 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 299A343E476
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=default; t=1660133627;
 bh=0eurnLuzGZ3qRL2RZDsSm+WisnojruHn4tv9O7FmRX8=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=QQxEv68RxQrIJUHel8B5NqVQiSRYnTSX4SMexm5Stu1Q6lDuB3Ld3kNF2nGXeiFaz
 0IKoFvLzBOXNgbT2unYVeCTDOIH8xQ0HOrNsOldtTX8qr4iF1NDl5/DKOD8/v4HMR6
 PMivxdTdid9OgK3LPHZRDRAgQ6N2N8CoRdQKvT3w2ir1Z+XqJVN6Xk/Vov3cnRjxLc
 hShyheT/68e7en/rTTa1gcsdqJPqxrUFbFOT1k3NwvCvbbnIXz+kBNi5fQe2/+okH8
 MSKifwpchrzhRFkCX6bsVwD8NNb/dq3SzM4HXydzMHSr+yZb10QsTDgSme9/sFNQHO
 +kKVcxxeW2KEA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
 by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
 with ESMTP id mEyeHWUF-4Si; Wed, 10 Aug 2022 08:13:47 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
 by mail.efficios.com (Postfix) with ESMTP id 10D1543E88F;
 Wed, 10 Aug 2022 08:13:47 -0400 (EDT)
Date: Wed, 10 Aug 2022 08:13:46 -0400 (EDT)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Sean Christopherson <seanjc@google.com>
Message-ID: <1478461718.353.1660133626967.JavaMail.zimbra@efficios.com>
In-Reply-To: <YvLT1fd8ddybF5Uw@google.com>
References: <20220809060627.115847-1-gshan@redhat.com>
 <8735e6ncxw.fsf@oldenburg.str.redhat.com>
 <7844e3fa-e49e-de75-e424-e82d3a023dd6@redhat.com>
 <87o7wtnay6.fsf@oldenburg.str.redhat.com>
 <616d4de6-81f6-9d14-4e57-4a79fec45690@redhat.com>
 <797306043.114963.1660047714774.JavaMail.zimbra@efficios.com>
 <1014177394.115022.1660052656961.JavaMail.zimbra@efficios.com>
 <YvLT1fd8ddybF5Uw@google.com>
Subject: Re: [PATCH 1/2] KVM: selftests: Make rseq compatible with glibc-2.35
MIME-Version: 1.0
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4372 (ZimbraWebClient - FF103
 (Linux)/8.8.15_GA_4372)
Thread-Topic: selftests: Make rseq compatible with glibc-2.35
Thread-Index: 2L3u2zUliaiWmqLcWHUzldusZle8bA==
Cc: Florian Weimer <fweimer@redhat.com>, shan gavin <shan.gavin@gmail.com>,
 KVM list <kvm@vger.kernel.org>, maz <maz@kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 andrew jones <andrew.jones@linux.dev>, yihyu <yihyu@redhat.com>,
 linux-kselftest <linux-kselftest@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, shuah <shuah@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

----- On Aug 9, 2022, at 5:38 PM, Sean Christopherson seanjc@google.com wrote:

> On Tue, Aug 09, 2022, Mathieu Desnoyers wrote:
>> ----- On Aug 9, 2022, at 8:21 AM, Mathieu Desnoyers
>> mathieu.desnoyers@efficios.com wrote:
>> 
>> > ----- Gavin Shan <gshan@redhat.com> wrote:
>> >> Hi Florian,
>> >> 
>> >> On 8/9/22 5:16 PM, Florian Weimer wrote:
>> >> >>> __builtin_thread_pointer doesn't work on all architectures/GCC
>> >> >>> versions.
>> >> >>> Is this a problem for selftests?
>> >> >>>
>> >> >>
>> >> >> It's a problem as the test case is running on all architectures. I think I
>> >> >> need introduce our own __builtin_thread_pointer() for where it's not
>> >> >> supported: (1) PowerPC  (2) x86 without GCC 11
>> >> >>
>> >> >> Please let me know if I still have missed cases where
>> >> >> __buitin_thread_pointer() isn't supported?
>> >> > 
>> >> > As far as I know, these are the two outliers that also have rseq
>> >> > support.  The list is a bit longer if we also consider non-rseq
>> >> > architectures (csky, hppa, ia64, m68k, microblaze, sparc, don't know
>> >> > about the Linux architectures without glibc support).
>> >> > 
>> >> 
>> >> For kvm/selftests, there are 3 architectures involved actually. So we
>> >> just need consider 4 cases: aarch64, x86, s390 and other. For other
>> >> case, we just use __builtin_thread_pointer() to maintain code's
>> >> integrity, but it's not called at all.
>> >> 
>> >> I think kvm/selftest is always relying on glibc if I'm correct.
>> > 
>> > All those are handled in the rseq selftests and in librseq. Why duplicate all
>> > that logic again?
>> 
>> More to the point, considering that we have all the relevant rseq registration
>> code in tools/testing/selftests/rseq/rseq.c already, and the relevant thread
>> pointer getter code in tools/testing/selftests/rseq/rseq-*thread-pointer.h,
>> is there an easy way to get test applications in tools/testing/selftests/kvm
>> and in tools/testing/selftests/rseq to share that common code ?
>> 
>> Keeping duplicated compatibility code is bad for long-term maintainability.
> 
> Any reason not to simply add tools/lib/rseq.c and then expose a helper to get
> the
> registered rseq struct?

Indeed, moving rseq.c to tools/lib/ would allow building a .so from any selftest
which needs to use it.

And we could move the relevant rseq helper header files to tools/include/rseq/*
as well.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
