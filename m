Return-Path: <SRS0=nF4w=P6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC40AC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 00:40:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A3886135E
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 00:40:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5A3886135E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C64584B1AF;
	Wed, 10 Nov 2021 19:40:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ODlzHnQi8phM; Wed, 10 Nov 2021 19:40:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E20F4B176;
	Wed, 10 Nov 2021 19:40:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E9FC4B176
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 19:39:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8VP3yFVd5HdF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 19:39:58 -0500 (EST)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
 [209.85.210.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D7604B12E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 19:39:58 -0500 (EST)
Received: by mail-pf1-f181.google.com with SMTP id y5so4111217pfb.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 16:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=GCvgNnriUarmCbicpFHHYqZw6hipmqUHqLUNYcuQ5mQ=;
 b=C/MSXc16d+vnyvPXnpHvWobOFVkGiZtvk8Fqn9KlAR5wdGaXHNSYYEqouCychGdG8p
 5qAR+o3QR3qaB0TDQ3yAC+dSCwOdKvfiEZ3Kln4q4atLvJqPKPRHW1o5zq6Ns5xwkOtC
 ik1lkhQwf39tyN70E9VZseTQvLWw0Txmbjd6Pu8ATSLAClCUTw6YIKKav5QdSu46fQ/5
 +e5c/wEbKgc1jOnG5VvHUJ9ey6iGYkWAk7F4ceZqKKEK8rilWv0ZFkZJXl5cjnWfQIx8
 55tsEZ8ESYtzoMLt6c2A3hOaXpTct4C6eIipQoqRcDMTUY4c5FxHvAnMIbgpRMgbfXry
 LjOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=GCvgNnriUarmCbicpFHHYqZw6hipmqUHqLUNYcuQ5mQ=;
 b=ZDlwiI32gGWhHsB2NrbFcSyWOBJqUGIzd2Xy6LY9p2aidWew+C1jyTfFETt/KGjFE/
 iYkRqoOlH8V5x0XIh8QreYHQP7PDNrEcNnsfyx7c3KOAVmBAMbrrGaWK45qhfdbdo3Kt
 cKuZBzKzpVIBLxHACbYjvkp5a9VhjhzXlejW2cUREZ/V3B9OChpqrnAvfRyBghSDq7bo
 9E/eEJ5MZOk098YPHnlIOGAj29mzaZVSoDnA6PO6uSYZv1kvy8xy6HPJR3St+kwABQ8Y
 p3LZJL6pI3m9V0RFIRT65zHewUPS0UG5vyEgkzBw3t1taKHwCwHC1nqUg7q5qcFD6dA+
 dBtw==
X-Gm-Message-State: AOAM531VIHyew5pbPAucpL+UOwseEvjiBj4AP8IgaKp/y8ZN4sdc4vcp
 F8Nam8QrfBdMOz/9zOTCNz3AMg==
X-Google-Smtp-Source: ABdhPJyzWkgci9VXixrCRz+lgwFJsP+1qd2jH9xIE5pUKSl6Qej6NdegD7xki773sUR8p4Puao3+lQ==
X-Received: by 2002:a63:6302:: with SMTP id x2mr1983608pgb.5.1636591196936;
 Wed, 10 Nov 2021 16:39:56 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id h194sm750078pfe.156.2021.11.10.16.39.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 10 Nov 2021 16:39:56 -0800 (PST)
Date: Thu, 11 Nov 2021 00:39:52 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 01/16] perf: Ensure perf_guest_cbs aren't reloaded
 between !NULL check and deref
Message-ID: <YYxmWGB6IUwEu4VZ@google.com>
References: <20210922000533.713300-1-seanjc@google.com>
 <20210922000533.713300-2-seanjc@google.com>
 <77e3a76a-016b-8945-a1d5-aae4075e2147@gmail.com>
 <YYPrst2CUBXLYc9h@google.com>
 <f86fe9cb-bf4b-1c10-e0da-276fbb3f62ee@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f86fe9cb-bf4b-1c10-e0da-276fbb3f62ee@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>, Guo Ren <guoren@kernel.org>,
 linux-riscv@lists.infradead.org, Vincent Chen <deanbo422@gmail.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Stefano Stabellini <sstabellini@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, linux-csky@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, xen-devel@lists.xenproject.org,
 Juergen Gross <jgross@suse.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Zhu Lingshan <lingshan.zhu@intel.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Greentime Hu <green.hu@gmail.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Namhyung Kim <namhyung@kernel.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Like Xu <like.xu.linux@gmail.com>, Nick Hu <nickhu@andestech.com>,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, Marc Zyngier <maz@kernel.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Wed, Nov 10, 2021, Paolo Bonzini wrote:
> On 11/4/21 15:18, Sean Christopherson wrote:
> > If I'm interpeting Paolo's suggestion
> > correctly, he's pointing out that oustanding stores to the function pointers in
> > @cbs need to complete before assigning a non-NULL pointer to perf_guest_cbs,
> > otherwise a perf event handler may see a valid pointer with half-baked callbacks.
> > 
> > I think smp_store_release() with a comment would be appropriate, assuming my
> > above interpretation is correct.
> > 
> 
> Yes, exactly.  It should even be rcu_assign_pointer(), matching the
> synchronize_rcu()

And perf_guest_cbs should be tagged __rcu and accessed accordingly.  Which is
effectively what this version (poorly) implemented with a homebrewed mix of
{READ,WRITE}_ONCE, lockdep(), and synchronize_rcu().

> in patch 1 (and the change can be done in patch 1, too).

Ya, the change needs to go into patch 1.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
