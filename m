Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE6DC25B0D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 10:28:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB0474CC23;
	Tue,  9 Aug 2022 06:28:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jvmahXP1YNvM; Tue,  9 Aug 2022 06:28:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69E8B4C606;
	Tue,  9 Aug 2022 06:28:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 332CB4C3BA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 03:17:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6CMGRkzcS7e4 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 03:17:10 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BFF14CD3C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 03:17:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660029429;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=guDnNs6GIE6VYYfJC3LF3y7xxWcKYPW4yEpvV6OunCc=;
 b=Uzge/ge+X0ejmtO2lCx2cXDzyYvS6yDyRoS2otdWKsQ6J9gi6ypMnD2ukpD8IU/cOFAgS5
 JliaVV+OMn7TO9ALpq8QDYiQVH0UhOyu3IAvoAOL42X36CgR3LrPqwYSQSz3H0ra2Gb39U
 DCsLUpQc3fseFjwCWWG+z/HNlSGbmNM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-I1YrsPXbNI-JfbNgRuspjg-1; Tue, 09 Aug 2022 03:17:06 -0400
X-MC-Unique: I1YrsPXbNI-JfbNgRuspjg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE1AA1019C8E;
 Tue,  9 Aug 2022 07:17:05 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.39.193.65])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D89D9945D0;
 Tue,  9 Aug 2022 07:17:02 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Use getcpu() instead of
 sched_getcpu() in rseq_test
References: <20220809060627.115847-1-gshan@redhat.com>
 <20220809060627.115847-3-gshan@redhat.com>
 <87y1vxncv1.fsf@oldenburg.str.redhat.com>
Date: Tue, 09 Aug 2022 09:17:01 +0200
In-Reply-To: <87y1vxncv1.fsf@oldenburg.str.redhat.com> (Florian Weimer's
 message of "Tue, 09 Aug 2022 08:35:14 +0200")
Message-ID: <87mtcdnaxe.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Tue, 09 Aug 2022 06:28:50 -0400
Cc: shan.gavin@gmail.com, kvm@vger.kernel.org, maz@kernel.org,
 linux-kernel@vger.kernel.org, andrew.jones@linux.dev,
 mathieu.desnoyers@efficios.com, yihyu@redhat.com,
 linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
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

* Florian Weimer:

> * Gavin Shan:
>
>> sched_getcpu() is glibc dependent and it can simply return the CPU
>> ID from the registered rseq information, as Florian Weimer pointed.
>> In this case, it's pointless to compare the return value from
>> sched_getcpu() and that fetched from the registered rseq information.
>>
>> Fix the issue by replacing sched_getcpu() with getcpu(), as Florian
>> suggested. The comments are modified accordingly.
>
> Note that getcpu was added in glibc 2.29, so perhaps you need to perform
> a direct system call?

One more thing: syscall(__NR_getcpu) also has the advantage that it
wouldn't have to be changed again if node IDs become available via rseq
and getcpu is implemented using that.

Thanks,
Florian

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
