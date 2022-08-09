Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF75FC19F2D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 10:28:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 491CE4C38A;
	Tue,  9 Aug 2022 06:28:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id agUNg1fUkq2X; Tue,  9 Aug 2022 06:28:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 144764C45F;
	Tue,  9 Aug 2022 06:28:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B0EA4CFB5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 02:33:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Op0BAsWF39DW for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 02:33:42 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 478134CF6F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 02:33:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660026821;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=wDEFUEUXWfV3mOjw64c6fomBw3vcWdz+3Pw9Zm2DtUE=;
 b=h1H1fffLQpCfVQQ2kB3+jm+gGuQoHKK5Rrf/SquEGczXegSNy8zZai+p1YdaLRJTfRn0mx
 YIuuVdbLqK5zuy4XACxvCr41I5oUedy6+AzuK6yNOD1/vzQgprq5AfTjZ8pZ2aOH77Qba/
 bFtl6I8gZ6PHMpt0kAIS3vqS/v0EEJI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-4-ft3tWvNVOUZxhcd6aQLg-1; Tue, 09 Aug 2022 02:33:36 -0400
X-MC-Unique: 4-ft3tWvNVOUZxhcd6aQLg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D77EC805B9A;
 Tue,  9 Aug 2022 06:33:35 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.39.193.65])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F41A51121315;
 Tue,  9 Aug 2022 06:33:32 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 1/2] KVM: selftests: Make rseq compatible with glibc-2.35
References: <20220809060627.115847-1-gshan@redhat.com>
 <20220809060627.115847-2-gshan@redhat.com>
Date: Tue, 09 Aug 2022 08:33:31 +0200
In-Reply-To: <20220809060627.115847-2-gshan@redhat.com> (Gavin Shan's message
 of "Tue, 9 Aug 2022 14:06:26 +0800")
Message-ID: <8735e6ncxw.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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

* Gavin Shan:

> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> index a54d4d05a058..acb1bf1f06b3 100644
> --- a/tools/testing/selftests/kvm/rseq_test.c
> +++ b/tools/testing/selftests/kvm/rseq_test.c
> @@ -9,6 +9,7 @@
>  #include <string.h>
>  #include <signal.h>
>  #include <syscall.h>
> +#include <dlfcn.h>
>  #include <sys/ioctl.h>
>  #include <sys/sysinfo.h>
>  #include <asm/barrier.h>

I'm surprised that there isn't a Makefile update to link with -ldl
(still required for glibc 2.33 and earlier).

> @@ -36,6 +37,8 @@ static __thread volatile struct rseq __rseq = {
>   */
>  #define NR_TASK_MIGRATIONS 100000
>  
> +static bool __rseq_ownership;
> +static volatile struct rseq *__rseq_info;
>  static pthread_t migration_thread;
>  static cpu_set_t possible_mask;
>  static int min_cpu, max_cpu;
> @@ -49,11 +52,33 @@ static void guest_code(void)
>  		GUEST_SYNC(0);
>  }
>  
> +static void sys_rseq_ownership(void)
> +{
> +	long *offset;
> +	unsigned int *size, *flags;
> +
> +	offset = dlsym(RTLD_NEXT, "__rseq_offset");
> +	size = dlsym(RTLD_NEXT, "__rseq_size");
> +	flags = dlsym(RTLD_NEXT, "__rseq_flags");
> +
> +	if (offset && size && *size && flags) {
> +		__rseq_ownership = false;
> +		__rseq_info = (struct rseq *)((uintptr_t)__builtin_thread_pointer() +
> +					      *offset);

__builtin_thread_pointer doesn't work on all architectures/GCC versions.
Is this a problem for selftests?

Thanks,
Florian

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
