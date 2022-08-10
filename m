Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88409C00140
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 09:14:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F04934D6EC;
	Wed, 10 Aug 2022 05:14:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d6B48I9P+sDg; Wed, 10 Aug 2022 05:14:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B044A4D6ED;
	Wed, 10 Aug 2022 05:14:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ABA04D6D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 05:14:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RG1uy+qnHeJj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 05:14:30 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39C7B4D656
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 05:14:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660122869;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=BrnJHJ9Mo9d6LF8fLd160jO7vgau2DqXTrpWN+Q+1lI=;
 b=RXaZz1UmALADfSZd6nqENNKeV6RTrjA6XTcCEfVyZyuqF8ExA3rY4SAxycEYTt6DanDkfc
 BqDLOQgxwWjdCtZPklWTJLCOxef70ro6WahkKM7DzVDaNSofgJWh5pGTcOSrVxwtwh1JdN
 4pjOElMtsAVTYbsyYVtvZBStHpU7d6Q=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-uBFgsiwQOISbO23Roy6Hag-1; Wed, 10 Aug 2022 05:14:26 -0400
X-MC-Unique: uBFgsiwQOISbO23Roy6Hag-1
Received: by mail-ed1-f69.google.com with SMTP id
 l19-20020a056402255300b0043df64f9a0fso8900257edb.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 02:14:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
 :content-language:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=BrnJHJ9Mo9d6LF8fLd160jO7vgau2DqXTrpWN+Q+1lI=;
 b=NhkRFMpcfnF62XbPhsbRq6I1dF2som97m0snFH6kn+WWe1uL3gMEfCb0eJkotOxxo4
 yURV2GajdU9m4gxB6QUFhfrad2h2vLRUEdV3e4KquIeGeRlYGw/ADDxw7SecC65xNVfp
 fAP5WC+m8v2aU+jxOG3YQWr9G+A+Ah+7cRSocLz0Rf1v38tLGcvTxB4siBp+E45rDCBL
 rIeSeGvd91VBrRP/U8Si9o6+JQ2XqhKqNCCDC059kX3fT2sQCT5tkQ7S34XEgHX2hori
 huR131vO+RF2L+n6k/mPaZnql6lCKRAttv84o+z8+DBwayM3E00qZtVrFqsS++wSRMPt
 3ylQ==
X-Gm-Message-State: ACgBeo3EUpe3dmElqQ3FDZa7km6uuQZqfHewPANoVpRb9LYpNV9jD6kY
 MtT9reJ5UBj1wFHm9yipaAHbJTg75NK7wnb9xLKhAGSZoqyn6vJSXRTgWNbRoecxBIJ/Wgk4Vif
 OUwrKOtYPMmQFQj9jWBEccC7j
X-Received: by 2002:a05:6402:1cc4:b0:440:5af8:41c9 with SMTP id
 ds4-20020a0564021cc400b004405af841c9mr17458856edb.339.1660122865407; 
 Wed, 10 Aug 2022 02:14:25 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4bQLwz0ay5kkw96DxJDx6+n/9y/Y6jEQ5yxdYJMMBH3d4Jv3191+PBY5JzY9jgLVspgmOkjg==
X-Received: by 2002:a05:6402:1cc4:b0:440:5af8:41c9 with SMTP id
 ds4-20020a0564021cc400b004405af841c9mr17458830edb.339.1660122865199; 
 Wed, 10 Aug 2022 02:14:25 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 r17-20020a17090609d100b0073145afd156sm162913eje.80.2022.08.10.02.14.21
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Aug 2022 02:14:24 -0700 (PDT)
Message-ID: <bb97efaf-4f58-c192-a489-e71ebbebce8c@redhat.com>
Date: Wed, 10 Aug 2022 11:14:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Gavin Shan <gshan@redhat.com>
References: <20220809060627.115847-1-gshan@redhat.com>
 <20220809060627.115847-2-gshan@redhat.com>
 <8735e6ncxw.fsf@oldenburg.str.redhat.com>
 <7844e3fa-e49e-de75-e424-e82d3a023dd6@redhat.com>
 <87o7wtnay6.fsf@oldenburg.str.redhat.com>
 <616d4de6-81f6-9d14-4e57-4a79fec45690@redhat.com>
 <797306043.114963.1660047714774.JavaMail.zimbra@efficios.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] KVM: selftests: Make rseq compatible with glibc-2.35
In-Reply-To: <797306043.114963.1660047714774.JavaMail.zimbra@efficios.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Florian Weimer <fweimer@redhat.com>, shan gavin <shan.gavin@gmail.com>,
 kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 andrew jones <andrew.jones@linux.dev>, yihyu@redhat.com,
 linux-kselftest@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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

On 8/9/22 14:21, Mathieu Desnoyers wrote:
>> For kvm/selftests, there are 3 architectures involved actually. So we
>> just need consider 4 cases: aarch64, x86, s390 and other. For other
>> case, we just use __builtin_thread_pointer() to maintain code's
>> integrity, but it's not called at all.
>>
>> I think kvm/selftest is always relying on glibc if I'm correct.
> All those are handled in the rseq selftests and in librseq. Why duplicate all that logic again?

Yeah, rseq_test should reuse librseq code.  The simplest way,
if slightly hackish, is to do something like

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 690b499c3471..6c192b0ec304 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -37,6 +37,7 @@ ifeq ($(ARCH),riscv)
  	UNAME_M := riscv
  endif
  
  LIBKVM += lib/assert.c
  LIBKVM += lib/elf.c
  LIBKVM += lib/guest_modes.c
@@ -198,7 +199,7 @@ endif
  CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
  	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
  	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
-	-I$(<D) -Iinclude/$(UNAME_M) -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
+	-I$(<D) -Iinclude/$(UNAME_M) -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES) -I../rseq
  
  no-pie-option := $(call try-run, echo 'int main() { return 0; }' | \
          $(CC) -Werror -no-pie -x c - -o "$$TMP", -no-pie)


and just #include "../rseq/rseq.c" in rseq_test.c.

Thanks,

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
