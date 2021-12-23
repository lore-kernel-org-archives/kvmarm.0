Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC89C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 23 Dec 2021 17:00:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7047440FC0;
	Thu, 23 Dec 2021 12:00:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rNURqsH80BP6; Thu, 23 Dec 2021 12:00:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2492149DFF;
	Thu, 23 Dec 2021 12:00:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10A2040FC0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Dec 2021 12:00:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ejaKKJqr9k7G for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Dec 2021 12:00:17 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97CE640FAC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Dec 2021 12:00:17 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1640278817;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=QbDlCNO8BeLEzEuY1o/Yj/OOV9u7i5H7i/UVWO5+jqU=;
 b=bHAfROfX6ffbHPIEWcU7S+S6CQ5qF6FnfykTw5PKqkbsSR12Gc+s8Frw2DhRaVL3eaKViG
 e82yFtfj/ITpWda4OH6DSGePyPujOLsx3jkgfB/YPNq9TuWm2RKr5ohEj0+dq8JCUc9zWs
 YZPCpHroV4MKkAcNfYf7VtvIT1gRdzU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-1j0GayoYPnuL-norKwWSGQ-1; Thu, 23 Dec 2021 12:00:13 -0500
X-MC-Unique: 1j0GayoYPnuL-norKwWSGQ-1
Received: by mail-ed1-f72.google.com with SMTP id
 s12-20020a50ab0c000000b003efdf5a226fso4924631edc.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Dec 2021 09:00:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=QbDlCNO8BeLEzEuY1o/Yj/OOV9u7i5H7i/UVWO5+jqU=;
 b=medIBD2wHtWgZt4Qk6CZNcP0oqxj7XI5ymyHv9Z6otVGvoXQ9iFucaEgrXYYms6yIC
 nX7SkxuXni/jdE1IhzgFUyaOTKh8mtvY/w82ewRQ2O0yIik7mybVbIKs06LXLSTUmlnX
 Oq0+O8EUssENsxCJsocF0t+DXaytZwc1KSAdZDCVacTRf1tQ2TmqxJNHK7ebwQUXD2is
 DQMsmvs2j6tIVxXKp++Qz0dOs6VSZwg3S2zSkLZ80PexEJcMCcutEiBdDc2nDoNvReW2
 GYO4JXm5F1/4SV0A0vPj88pE1WuC3BTIBfHvd6471NdU/9EGDNqvnO/h7MF83iCP/0IA
 puNA==
X-Gm-Message-State: AOAM531JinzG9q8t+cjt3pZhsdHBIa3oywAXJqi0GZI/EcwFCLCps+ru
 8RUrScYJQU/PGUpYNGRn6sks3Es3M0q9GISa9TjzGaG065PkT8IAB24Qn0O4KARTvdPtwTQ9L6R
 kqLM4/rHiFcVG2/G/1Qn62ldG
X-Received: by 2002:a17:906:478a:: with SMTP id
 cw10mr2509594ejc.693.1640278812814; 
 Thu, 23 Dec 2021 09:00:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzOXau0JYojDMrB4uhQtijnQf3uwLfJ8/1WFDQKJxoqhmtXGvyUBxdGs2J03ArKxDWe2arRKw==
X-Received: by 2002:a17:906:478a:: with SMTP id
 cw10mr2509570ejc.693.1640278812612; 
 Thu, 23 Dec 2021 09:00:12 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id t9sm2203094edd.94.2021.12.23.09.00.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 23 Dec 2021 09:00:12 -0800 (PST)
Date: Thu, 23 Dec 2021 18:00:10 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/5] KVM: selftests: Initialise default mode in each test
Message-ID: <20211223170010.pekdezsyn75iuxqb@gator.home>
References: <20211216123135.754114-1-maz@kernel.org>
 <20211216123135.754114-3-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211216123135.754114-3-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, Dec 16, 2021 at 12:31:32PM +0000, Marc Zyngier wrote:
> As we are going to add support for a variable default mode on arm64,
> let's make sure it is setup first by sprinkling a number of calls
> to get_modes_append_default() when the test starts.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  tools/testing/selftests/kvm/aarch64/arch_timer.c       | 3 +++
>  tools/testing/selftests/kvm/aarch64/debug-exceptions.c | 3 +++
>  tools/testing/selftests/kvm/aarch64/get-reg-list.c     | 3 +++
>  tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c | 3 +++
>  tools/testing/selftests/kvm/aarch64/vgic_init.c        | 3 +++
>  tools/testing/selftests/kvm/kvm_binary_stats_test.c    | 3 +++
>  tools/testing/selftests/kvm/kvm_create_max_vcpus.c     | 3 +++
>  tools/testing/selftests/kvm/memslot_perf_test.c        | 4 ++++
>  tools/testing/selftests/kvm/rseq_test.c                | 3 +++
>  tools/testing/selftests/kvm/set_memory_region_test.c   | 4 ++++
>  tools/testing/selftests/kvm/steal_time.c               | 3 +++

I wish there was a better way to set the defaults for each test
without requiring a function call to be put at the beginning of
each test. Maybe we should create a constructor function? I.e.

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index f307c9f61981..603e09be12ae 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -148,7 +148,7 @@ LDFLAGS += -pthread $(no-pie-option) $(pgste-option)
 # $(TEST_GEN_PROGS) starts with $(OUTPUT)/
 include ../lib.mk
 
-STATIC_LIBS := $(OUTPUT)/libkvm.a
+STATIC_LIBS := lib/init.o $(OUTPUT)/libkvm.a
 LIBKVM_C := $(filter %.c,$(LIBKVM))
 LIBKVM_S := $(filter %.S,$(LIBKVM))
 LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
diff --git a/tools/testing/selftests/kvm/lib/init.c b/tools/testing/selftests/kvm/lib/init.c
new file mode 100644
index 000000000000..6f92a85aa263
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/init.c
@@ -0,0 +1,6 @@
+#include "guest_modes.h"
+
+void __attribute__((constructor)) main_init(void)
+{
+#ifdef __aarch64__
+       guest_modes_set_default();
+#endif
+}


Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
