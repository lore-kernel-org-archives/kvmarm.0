Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C59D8C25B08
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 12:29:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4051D4D8E4;
	Wed, 10 Aug 2022 08:29:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6JVgHqJOqDN1; Wed, 10 Aug 2022 08:29:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 046134D8D3;
	Wed, 10 Aug 2022 08:29:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD8CC4D8D0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 08:29:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7-Am3HX7jNKO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 08:29:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE4A54D8D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 08:29:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660134547;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Ur0S3vxzmpV2P3Rj1K4ZEdqLq25lb9Wh81DhfR65pxA=;
 b=B7SMe3hznbmMRpZ6xrr0o7tKdLp25tE9UZBmE6Hh74rk9iFYY5XD7Abm1zGDV6udr8B4xh
 1Xo3rzaNaAJuWqNszyjqpZf0cI8NgvdXaaOlD4TYfd/zUsPipcMMFacI/obxXRz1poexhS
 JqhDHovgiQSlykC6nd/diP713Uz1vrA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-6q6O1np3OCm_n9la1xrKoQ-1; Wed, 10 Aug 2022 08:29:06 -0400
X-MC-Unique: 6q6O1np3OCm_n9la1xrKoQ-1
Received: by mail-ed1-f72.google.com with SMTP id
 b6-20020a056402278600b0043e686058feso9092673ede.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 05:29:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=Ur0S3vxzmpV2P3Rj1K4ZEdqLq25lb9Wh81DhfR65pxA=;
 b=Qzvtz3OrZPHWsgwOThk1emrRUR2jhz+m2iLOvd8FmZIPdoK2JEk9k8hSOXDBhJ6USz
 BxuTwk+Cfa41ED1ISxQz1511FBq0qMzW20oTd5GrtLMbVfpHxw6hw4nCYhCJ0sz32QBz
 07aHkyr2ecavoFJHwhRCHgG5+L4KmumeDQ9HhlF7NZY5uvTJUYe6jAX/+jVHwGQbJeAc
 cG4IagDA/dnWFosgi5p4Iq86itIZA3iAtdfv13YbetfyU8Qot84lG/m/90Yie24fX1PB
 YsloZ1SEZvNOyChQOimFSTKlpz/lE/lxYq7696+ZPXxRV3TAtHyE8WwqKFHndhzbr6Ll
 I/4Q==
X-Gm-Message-State: ACgBeo3eP02cdRto3vimcR2F6iQH/TnNrQtwv4jBxYLp/Yd+hgt5ES3k
 RKaFphfbkOWQFmbv8r8ry3uvx8zC9RPy3qDE8f5hzg2v0PmU78JpBVhoze+yxPjjAGhCgzwytar
 3XZxHDp6njvYJtE95yNCUk/Wu
X-Received: by 2002:a05:6402:35c3:b0:43d:f5d9:b65d with SMTP id
 z3-20020a05640235c300b0043df5d9b65dmr26615872edc.149.1660134545255; 
 Wed, 10 Aug 2022 05:29:05 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7s6VXCgxCV5nTHcb8Km+7rgGPW/D/i9ZJCl/KMbRISRjqKSsbjTlBqkKW6TQEEF4LuJCo/9g==
X-Received: by 2002:a05:6402:35c3:b0:43d:f5d9:b65d with SMTP id
 z3-20020a05640235c300b0043df5d9b65dmr26615846edc.149.1660134545002; 
 Wed, 10 Aug 2022 05:29:05 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 f15-20020a50ee8f000000b0043bc4b28464sm7671006edr.34.2022.08.10.05.29.03
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Aug 2022 05:29:04 -0700 (PDT)
Message-ID: <1e41a634-0419-e0a8-364c-2e30ed2dbe4d@redhat.com>
Date: Wed, 10 Aug 2022 14:29:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 1/2] KVM: selftests: Make rseq compatible with
 glibc-2.35
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Gavin Shan <gshan@redhat.com>
References: <20220810104114.6838-1-gshan@redhat.com>
 <20220810104114.6838-2-gshan@redhat.com>
 <876568572.367.1660134156963.JavaMail.zimbra@efficios.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <876568572.367.1660134156963.JavaMail.zimbra@efficios.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Florian Weimer <fweimer@redhat.com>, shan gavin <shan.gavin@gmail.com>,
 KVM list <kvm@vger.kernel.org>, maz <maz@kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 andrew jones <andrew.jones@linux.dev>, yihyu <yihyu@redhat.com>,
 linux-kselftest <linux-kselftest@vger.kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 8/10/22 14:22, Mathieu Desnoyers wrote:
>>
>> 	/*
>> 	 * Create and run a dummy VM that immediately exits to userspace via
>> @@ -256,7 +244,7 @@ int main(int argc, char *argv[])
>> 			 */
>> 			smp_rmb();
>> 			cpu = sched_getcpu();
>> -			rseq_cpu = READ_ONCE(__rseq.cpu_id);
>> +			rseq_cpu = READ_ONCE(__rseq->cpu_id);
> #include <rseq.h>
> 
> and use
> 
> rseq_current_cpu_raw().

Thanks, I squashed it and queued it for -rc1 (tested on both
glibc 2.34 and 2.35).

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 84e8425edc2c..987a76674f4f 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -29,7 +29,6 @@
  #define NR_TASK_MIGRATIONS 100000
  
  static pthread_t migration_thread;
-static struct rseq_abi *__rseq;
  static cpu_set_t possible_mask;
  static int min_cpu, max_cpu;
  static bool done;
@@ -218,7 +217,6 @@ int main(int argc, char *argv[])
  	r = rseq_register_current_thread();
  	TEST_ASSERT(!r, "rseq_register_current_thread failed, errno = %d (%s)",
  		    errno, strerror(errno));
-	__rseq = rseq_get_abi();
  
  	/*
  	 * Create and run a dummy VM that immediately exits to userspace via
@@ -256,7 +254,7 @@ int main(int argc, char *argv[])
  			 */
  			smp_rmb();
  			cpu = sched_getcpu();
-			rseq_cpu = READ_ONCE(__rseq->cpu_id);
+			rseq_cpu = rseq_current_cpu_raw();
  			smp_rmb();
  		} while (snapshot != atomic_read(&seq_cnt));
  

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
