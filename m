Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD8F6C00140
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 12:17:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 169DF4D8C0;
	Wed, 10 Aug 2022 08:17:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@efficios.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OS+3u8IiNVao; Wed, 10 Aug 2022 08:17:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B75C84D8BC;
	Wed, 10 Aug 2022 08:17:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CE9B4D8BC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 08:17:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ODzipuNdwH9n for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 08:17:37 -0400 (EDT)
Received: from mail.efficios.com (mail.efficios.com [167.114.26.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 830AD4D8BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 08:17:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mail.efficios.com (Postfix) with ESMTP id 332E943E67C;
 Wed, 10 Aug 2022 08:17:37 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
 by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
 with ESMTP id fmsC52ArUCu9; Wed, 10 Aug 2022 08:17:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mail.efficios.com (Postfix) with ESMTP id 82CA243EC00;
 Wed, 10 Aug 2022 08:17:36 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 82CA243EC00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=default; t=1660133856;
 bh=z/S5E8pzolwFXFR8jg1hlqAWy+Ftp2WJVCfJkxZFnjU=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=pjAhsQ4sa6auvGQv08vRoseCyLEf7FPvQzv0LQRcUn0mOTdpl/u/wE+HEEO0k/igG
 ll7/m5meDy/y3V9+0hLhHcusrr8oKLYXflXxKqOUkHYkhQA24+OdzJw2l9LKhceNs8
 lbUqJAnKP1bCbKu0Q1dqJ87ggY/iXOZTQSAS2xUYQ449kVkloUcVQs/snGclpQZrxd
 QD5nJzRS/xnwt+XHILxmgCFq0WofTI13cxtDU53pkU7tYXRoyFg19ChP2Ket3fZKUv
 v5EksArNNwCu9BdqpPOLmpO7SBwW6ES9vNsQbEN7oGynHAp8sX/V7WiC7zJpabuzXC
 ptjVO90zJCSzA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
 by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
 with ESMTP id 64bOvJHL_oS6; Wed, 10 Aug 2022 08:17:36 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
 by mail.efficios.com (Postfix) with ESMTP id 6E44743E920;
 Wed, 10 Aug 2022 08:17:36 -0400 (EDT)
Date: Wed, 10 Aug 2022 08:17:36 -0400 (EDT)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <392275844.358.1660133856396.JavaMail.zimbra@efficios.com>
In-Reply-To: <bb97efaf-4f58-c192-a489-e71ebbebce8c@redhat.com>
References: <20220809060627.115847-1-gshan@redhat.com>
 <20220809060627.115847-2-gshan@redhat.com>
 <8735e6ncxw.fsf@oldenburg.str.redhat.com>
 <7844e3fa-e49e-de75-e424-e82d3a023dd6@redhat.com>
 <87o7wtnay6.fsf@oldenburg.str.redhat.com>
 <616d4de6-81f6-9d14-4e57-4a79fec45690@redhat.com>
 <797306043.114963.1660047714774.JavaMail.zimbra@efficios.com>
 <bb97efaf-4f58-c192-a489-e71ebbebce8c@redhat.com>
Subject: Re: [PATCH 1/2] KVM: selftests: Make rseq compatible with glibc-2.35
MIME-Version: 1.0
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4372 (ZimbraWebClient - FF103
 (Linux)/8.8.15_GA_4372)
Thread-Topic: selftests: Make rseq compatible with glibc-2.35
Thread-Index: tvTixx8jfu1/z35roKHtooGvD9+zmA==
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

----- On Aug 10, 2022, at 5:14 AM, Paolo Bonzini pbonzini@redhat.com wrote:

> On 8/9/22 14:21, Mathieu Desnoyers wrote:
>>> For kvm/selftests, there are 3 architectures involved actually. So we
>>> just need consider 4 cases: aarch64, x86, s390 and other. For other
>>> case, we just use __builtin_thread_pointer() to maintain code's
>>> integrity, but it's not called at all.
>>>
>>> I think kvm/selftest is always relying on glibc if I'm correct.
>> All those are handled in the rseq selftests and in librseq. Why duplicate all
>> that logic again?
> 
> Yeah, rseq_test should reuse librseq code.  The simplest way,
> if slightly hackish, is to do something like
> 
> diff --git a/tools/testing/selftests/kvm/Makefile
> b/tools/testing/selftests/kvm/Makefile
> index 690b499c3471..6c192b0ec304 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -37,6 +37,7 @@ ifeq ($(ARCH),riscv)
>  	UNAME_M := riscv
>  endif
>  
>  LIBKVM += lib/assert.c
>  LIBKVM += lib/elf.c
>  LIBKVM += lib/guest_modes.c
> @@ -198,7 +199,7 @@ endif
>  CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
>  	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
>  	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
> -	-I$(<D) -Iinclude/$(UNAME_M) -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
> +	-I$(<D) -Iinclude/$(UNAME_M) -I.. $(EXTRA_CFLAGS) $(KHDR_INCLUDES) -I../rseq
>  
>  no-pie-option := $(call try-run, echo 'int main() { return 0; }' | \
>          $(CC) -Werror -no-pie -x c - -o "$$TMP", -no-pie)
> 
> 
> and just #include "../rseq/rseq.c" in rseq_test.c.

Hi Paolo,

Indeed, this hack seems to be a good approach to immediately fix things without
moving around all source files and headers. In the longer term, I'd prefer Sean's
proposal to move rseq.c to tools/lib/ (and to move rseq headers to tools/include/rseq/).
This can be done in a follow up phase though. I'll put a note on my todo list
for after I come back from vacation.

I'll be able to do this refactoring on top of this fix.

Thanks,

Mathieu

> 
> Thanks,
> 
> Paolo

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
