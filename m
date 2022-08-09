Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEAA9C19F2D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 08:46:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 182E04C3C4;
	Tue,  9 Aug 2022 04:46:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DutqyHNs3erY; Tue,  9 Aug 2022 04:46:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C2664C3CD;
	Tue,  9 Aug 2022 04:46:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E069A4C3C6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 04:46:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4mcDRAJ3Rh9D for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 04:46:49 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A0134C3C4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 04:46:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660034809;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=nAOgZSsnJxT5Shsx+uHCFUsu3HJRwfqepSFOiTyCokk=;
 b=Jh29rd2tumD41pitYALr1GDY+OSKSbdgiuCaup7FP+BikCvensyrDk3ieVwgqenhVFPzkN
 fEvmsDuiThem4Lx/tZ3lnCi5R8khRgLzbYd5U/mFukk5BOmEPrqnh+io6bTP0s9aHRRYmo
 I79Mfg5mOe9VeZQO/M9iMBlAiRQE3HE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-nNTpUUHVOM2aBTwNReifeQ-1; Tue, 09 Aug 2022 04:46:47 -0400
X-MC-Unique: nNTpUUHVOM2aBTwNReifeQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C61E1824605;
 Tue,  9 Aug 2022 08:46:47 +0000 (UTC)
Received: from [10.64.54.189] (vpn2-54-189.bne.redhat.com [10.64.54.189])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E34F9145BA44;
 Tue,  9 Aug 2022 08:46:42 +0000 (UTC)
Subject: Re: [PATCH 2/2] KVM: selftests: Use getcpu() instead of
 sched_getcpu() in rseq_test
To: Florian Weimer <fweimer@redhat.com>
References: <20220809060627.115847-1-gshan@redhat.com>
 <20220809060627.115847-3-gshan@redhat.com>
 <87y1vxncv1.fsf@oldenburg.str.redhat.com>
 <87mtcdnaxe.fsf@oldenburg.str.redhat.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <ea2ef1a2-0fd8-448b-d7ca-254603518823@redhat.com>
Date: Tue, 9 Aug 2022 18:46:39 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <87mtcdnaxe.fsf@oldenburg.str.redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Cc: shan.gavin@gmail.com, kvm@vger.kernel.org, maz@kernel.org,
 linux-kernel@vger.kernel.org, andrew.jones@linux.dev,
 mathieu.desnoyers@efficios.com, yihyu@redhat.com,
 linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
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

On 8/9/22 5:17 PM, Florian Weimer wrote:
> * Florian Weimer:
> 
>> * Gavin Shan:
>>
>>> sched_getcpu() is glibc dependent and it can simply return the CPU
>>> ID from the registered rseq information, as Florian Weimer pointed.
>>> In this case, it's pointless to compare the return value from
>>> sched_getcpu() and that fetched from the registered rseq information.
>>>
>>> Fix the issue by replacing sched_getcpu() with getcpu(), as Florian
>>> suggested. The comments are modified accordingly.
>>
>> Note that getcpu was added in glibc 2.29, so perhaps you need to perform
>> a direct system call?
> 
> One more thing: syscall(__NR_getcpu) also has the advantage that it
> wouldn't have to be changed again if node IDs become available via rseq
> and getcpu is implemented using that.
> 
> Thanks,
> Florian
> 

Thanks, Florian. It makes sense to me to use syscall(__NR_getcpu) in
next revision. Thanks for your quick review :)

I would hold for one or two days to post v2, to see if others have
more comments.

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
