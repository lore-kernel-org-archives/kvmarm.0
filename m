Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A4DC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Jul 2022 01:25:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78F2B4BD96;
	Mon, 11 Jul 2022 21:25:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v38u+HcfqPZx; Mon, 11 Jul 2022 21:25:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36B5E4BD92;
	Mon, 11 Jul 2022 21:25:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F3EF4BD92
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jul 2022 21:25:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zqru1XxO5O5b for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Jul 2022 21:25:11 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E98E84BD8E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jul 2022 21:25:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1657589111;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type: content-transfer-encoding:content-transfer-encoding;
 bh=Jq022DmQUjw/2dl+SO2UbbEVon/N97i1/HaIwP1YzPE=;
 b=ZnSnoieD08WFuAHqtkdxC3Vm8Nfd8KwazffNj8o7XgY6KcEvjXI1IrGK0PGtJEWBP6cqxZ
 r+wAyY2b286jyS9DdvCFllQYMXb8MxITr/QPjfkxwtCTSmrtFr9i+pdoXO1u9pbPSTUwan
 GoFcMaB2oUo/Hbh32tt6+aoo4qAXoYU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-UxYxPhWyMLupN8UB1yJvNQ-1; Mon, 11 Jul 2022 21:25:08 -0400
X-MC-Unique: UxYxPhWyMLupN8UB1yJvNQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06C1D8032E3;
 Tue, 12 Jul 2022 01:25:08 +0000 (UTC)
Received: from [10.64.54.17] (vpn2-54-17.bne.redhat.com [10.64.54.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 135B01121314;
 Tue, 12 Jul 2022 01:25:05 +0000 (UTC)
To: kvmarm@lists.cs.columbia.edu
From: Gavin Shan <gshan@redhat.com>
Subject: [Issue] kvm/selftests/rseq_test failure on ARM64
Message-ID: <180e4b51-26fb-8f2a-9e83-673d8ee6a714@redhat.com>
Date: Tue, 12 Jul 2022 13:24:45 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Shan Gavin <shan.gavin@gmail.com>, Marc Zyngier <maz@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Sean,

We ran into kvm/selftests/rseq_test failure on ARM64, like below. I'm not sure
if you have quick idea about the root cause. The issue can't be reproduced
100%, meaning it happens occasionally.

host# uname -r
5.19.0-rc6-gavin+
host# # cat /proc/cpuinfo | grep processor | tail -n 1
processor	: 223
host# pwd
/home/gavin/sandbox/linux.main/tools/testing/selftests/kvm
host# for i in `seq 1 100`; do echo "--------> $i"; ./rseq_test; sleep 3; done
--------> 1
--------> 2
--------> 3
--------> 4
--------> 5
--------> 6
==== Test Assertion Failure ====
   rseq_test.c:265: rseq_cpu == cpu
   pid=3925 tid=3925 errno=4 - Interrupted system call
      1  0x0000000000401963: main at rseq_test.c:265 (discriminator 2)
      2  0x0000ffffb044affb: ?? ??:0
      3  0x0000ffffb044b0c7: ?? ??:0
      4  0x0000000000401a6f: _start at ??:?
   rseq CPU = 4, sched CPU = 27

Looking at tools/testing/selftests/kvm/rseq_test.c, it seems we have the assumption
that the 'main' and 'migration_worker' threads are synchronized in migration state.
However, I'm not sure it's correct. I think it's still possible that process migration
on 'main' thread could happen between the calls to sched_getcpu() and READ_ONCE()?

int main(int argc, char *argv[])
{
     :
     for (i = 0; !done; i++) {
         :
         do {
             /*
              * Drop bit 0 to force a mismatch if the count is odd,
              * i.e. if a migration is in-progress.
              */
              snapshot = atomic_read(&seq_cnt) & ~1;

              /*
               * Ensure reading sched_getcpu() and rseq.cpu_id
               * complete in a single "no migration" window, i.e. are
               * not reordered across the seq_cnt reads.
               */
               smp_rmb();
               cpu = sched_getcpu();                         /* process migration may happen after sched_getcpu() ? */
               rseq_cpu = READ_ONCE(__rseq.cpu_id);
               smp_rmb();
           } while (snapshot != atomic_read(&seq_cnt));
      }
}

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
