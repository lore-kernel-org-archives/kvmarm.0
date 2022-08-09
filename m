Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBB0C25B0C
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 13:44:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 360C54CCBD;
	Tue,  9 Aug 2022 09:44:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@efficios.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sUhI1MFc4Ztv; Tue,  9 Aug 2022 09:44:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE4B84CCAE;
	Tue,  9 Aug 2022 09:44:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41A564CCA8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 09:44:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7uzxCWWrX2JU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 09:44:17 -0400 (EDT)
Received: from mail.efficios.com (mail.efficios.com [167.114.26.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E5E064CCA7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 09:44:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mail.efficios.com (Postfix) with ESMTP id 977AA429DBD;
 Tue,  9 Aug 2022 09:44:17 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
 by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
 with ESMTP id A2tXyMn9D4L2; Tue,  9 Aug 2022 09:44:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mail.efficios.com (Postfix) with ESMTP id 17218429DBC;
 Tue,  9 Aug 2022 09:44:17 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 17218429DBC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=default; t=1660052657;
 bh=s4MwCgSocyslqz8qzo8aK6OHgXabE2tT23dUh+6dXe0=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=WY/02Qm5yS41kNoN/cNg3tLp3INF8QD6x80M50bSMHG0rPvTpcohEzEJ+m9T0Sgh8
 m63RBvDXINU2u2nkSES8DSygcKfYNJZBCeCdrMLLmGqHWOdrFkpRVl0PBpOIPHWFst
 S5zitE8F0woj3d8UGX0G9XzsWhMfCoVSednEvGn5QPf6piJoF83OMVE/g+Q+2g94SA
 x5vJNBJ6yDt//R57FTo3OATfaEfK2wV6lmRTHwL0s/hFHIOOVfcMKhgIfKklGUn1yd
 GofDXEDGnRNV11dizNmeF10xLouUIm2X1uRyHpFWKfGCmMm/VTaUCK3nv3dqMAXuPF
 wlRS+WWD8OA4w==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
 by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
 with ESMTP id kq9Zg0-sw3D5; Tue,  9 Aug 2022 09:44:17 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
 by mail.efficios.com (Postfix) with ESMTP id 034A1429DBB;
 Tue,  9 Aug 2022 09:44:17 -0400 (EDT)
Date: Tue, 9 Aug 2022 09:44:16 -0400 (EDT)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Gavin Shan <gshan@redhat.com>, shuah <shuah@kernel.org>
Message-ID: <1014177394.115022.1660052656961.JavaMail.zimbra@efficios.com>
In-Reply-To: <797306043.114963.1660047714774.JavaMail.zimbra@efficios.com>
References: <20220809060627.115847-1-gshan@redhat.com>
 <20220809060627.115847-2-gshan@redhat.com>
 <8735e6ncxw.fsf@oldenburg.str.redhat.com>
 <7844e3fa-e49e-de75-e424-e82d3a023dd6@redhat.com>
 <87o7wtnay6.fsf@oldenburg.str.redhat.com>
 <616d4de6-81f6-9d14-4e57-4a79fec45690@redhat.com>
 <797306043.114963.1660047714774.JavaMail.zimbra@efficios.com>
Subject: Re: [PATCH 1/2] KVM: selftests: Make rseq compatible with glibc-2.35
MIME-Version: 1.0
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4304 (ZimbraWebClient - FF103
 (Linux)/8.8.15_GA_4304)
Thread-Topic: selftests: Make rseq compatible with glibc-2.35
Thread-Index: oHLHOFY5Vh2uVE5+gR7UtW52F8t44qAjgRJ1
Cc: Florian Weimer <fweimer@redhat.com>, shan gavin <shan.gavin@gmail.com>,
 KVM list <kvm@vger.kernel.org>, maz <maz@kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 andrew jones <andrew.jones@linux.dev>, yihyu@redhat.com,
 linux-kselftest <linux-kselftest@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

----- On Aug 9, 2022, at 8:21 AM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> ----- Gavin Shan <gshan@redhat.com> wrote:
>> Hi Florian,
>> 
>> On 8/9/22 5:16 PM, Florian Weimer wrote:
>> >>> __builtin_thread_pointer doesn't work on all architectures/GCC
>> >>> versions.
>> >>> Is this a problem for selftests?
>> >>>
>> >>
>> >> It's a problem as the test case is running on all architectures. I think I
>> >> need introduce our own __builtin_thread_pointer() for where it's not
>> >> supported: (1) PowerPC  (2) x86 without GCC 11
>> >>
>> >> Please let me know if I still have missed cases where
>> >> __buitin_thread_pointer() isn't supported?
>> > 
>> > As far as I know, these are the two outliers that also have rseq
>> > support.  The list is a bit longer if we also consider non-rseq
>> > architectures (csky, hppa, ia64, m68k, microblaze, sparc, don't know
>> > about the Linux architectures without glibc support).
>> > 
>> 
>> For kvm/selftests, there are 3 architectures involved actually. So we
>> just need consider 4 cases: aarch64, x86, s390 and other. For other
>> case, we just use __builtin_thread_pointer() to maintain code's
>> integrity, but it's not called at all.
>> 
>> I think kvm/selftest is always relying on glibc if I'm correct.
> 
> All those are handled in the rseq selftests and in librseq. Why duplicate all
> that logic again?

More to the point, considering that we have all the relevant rseq registration
code in tools/testing/selftests/rseq/rseq.c already, and the relevant thread
pointer getter code in tools/testing/selftests/rseq/rseq-*thread-pointer.h,
is there an easy way to get test applications in tools/testing/selftests/kvm
and in tools/testing/selftests/rseq to share that common code ?

Keeping duplicated compatibility code is bad for long-term maintainability.

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
