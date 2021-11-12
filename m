Return-Path: <SRS0=9vag=P7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BACCC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 07:55:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C684161038
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 07:55:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C684161038
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D7694B235;
	Fri, 12 Nov 2021 02:55:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id njAjDohWOQy8; Fri, 12 Nov 2021 02:55:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC9754B213;
	Fri, 12 Nov 2021 02:55:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36C794B210
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 02:55:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UwXBHHBv8piA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Nov 2021 02:55:42 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25DE94B20E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 02:55:42 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636703741;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=lF7lzRoeZrlEIt3gHEFyVsRoWpbej1ntDFwYNAiQdJI=;
 b=S6A/GlnSpDzjNW679UfW03taT2ANpf1+QVkTv90xFzlXyD9qhmp3Bfq1yt6m12HW5vT5so
 XEJZTEkL889uu4T4jUYgKh/o5vHn1J4MhFfJvlgy3haalKiVWWCD20dn4Azf1myGmzHoAw
 4lshvNz3yoegOCHCCtEsHvsVg+IrS3w=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-oBYC2gNROlyxnSteoyQrDw-1; Fri, 12 Nov 2021 02:55:38 -0500
X-MC-Unique: oBYC2gNROlyxnSteoyQrDw-1
Received: by mail-ed1-f72.google.com with SMTP id
 l15-20020a056402124f00b003e57269ab87so930656edw.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 23:55:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=lF7lzRoeZrlEIt3gHEFyVsRoWpbej1ntDFwYNAiQdJI=;
 b=UFAMNDzg8RwxcGGEODrkdFvbikhuC0Jmb1QJgHK9VhIoVwC/fgSheSGf8PID7frhkV
 VwWx5iROozNVTBAfTVL8P3HcJugRmfRgfIFe6d5q1W6IyXnqoKKm1jPgTbcyjep0M1iR
 CPoNKAnsfr7F5CJVk7WCfQfyxUnWLIrdZjOndxa8vrWXlMPPHMvLIiy0AgOY+fYuZ2bz
 jn7n/S0E5IkVrfduOGM1v6Md7I9XW8NRJ1XRx+EaJMMK3MLqCPG99LmC9+eIdokmuWMn
 lfjaly5sYt0zYLpUM34l33metnECujPFkZOE06BNAK/3hCw9BassCk/knNxiyEo2TXK+
 V3xQ==
X-Gm-Message-State: AOAM532KdCwc1xXm/71x8kit4YXrLzDi6YLn4BNidj0yq79sBPNwWZbT
 MccmZAiWjW5/amPPp6dDE1grx373bWuVQVZmI4BXMtMZ8ys43aWXfaln/9LE9J/JFjdGp1sSmqD
 Xauy0YC1BQjkdoiL4vVpp39Kr
X-Received: by 2002:a17:907:6e10:: with SMTP id
 sd16mr17768033ejc.158.1636703737517; 
 Thu, 11 Nov 2021 23:55:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzVTSyaI9bwf+cK3HRTYkkEGrfXsl4Cvt+Fkmz/7JDyaorMKEA4Mec75P9Nt6V8a8edl3Ld8g==
X-Received: by 2002:a17:907:6e10:: with SMTP id
 sd16mr17767982ejc.158.1636703737318; 
 Thu, 11 Nov 2021 23:55:37 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e?
 ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
 by smtp.gmail.com with ESMTPSA id n1sm2700678edf.45.2021.11.11.23.55.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 11 Nov 2021 23:55:36 -0800 (PST)
Message-ID: <016d5b91-6910-2aca-0db1-a65079449454@redhat.com>
Date: Fri, 12 Nov 2021 08:55:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v4 01/17] perf: Protect perf_guest_cbs with RCU
To: Peter Zijlstra <peterz@infradead.org>
References: <20211111020738.2512932-1-seanjc@google.com>
 <20211111020738.2512932-2-seanjc@google.com>
 <d784dc27-72d0-d64f-e1f4-a2b9a5f86dd4@redhat.com>
 <YYz03fcDRV9NZnyA@hirez.programming.kicks-ass.net>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YYz03fcDRV9NZnyA@hirez.programming.kicks-ass.net>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Guo Ren <guoren@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Vincent Chen <deanbo422@gmail.com>, Will Deacon <will@kernel.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 Russell King <linux@armlinux.org.uk>, linux-csky@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, Ingo Molnar <mingo@redhat.com>,
 Like Xu <like.xu.linux@gmail.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Zhu Lingshan <lingshan.zhu@intel.com>, Jiri Olsa <jolsa@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Greentime Hu <green.hu@gmail.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>, Like Xu <like.xu@linux.intel.com>,
 Nick Hu <nickhu@andestech.com>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Palmer Dabbelt <palmer@dabbelt.com>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 11/11/21 11:47, Peter Zijlstra wrote:
>> This technically could be RCU_INIT_POINTER but it's not worth a respin.
>> There are dozens of other occurrences, and if somebody wanted they
>> could use Coccinelle to fix all of them.
> I've been pushing the other way, trying to get rid of RCU_INIT_POINTER()
> since rcu_assign_pointer(, NULL) actualy DTRT per __builtin_constant_p()
> etc.

Oh, that's pretty cool to know, thanks!

Paolo

> There's a very few sites where we use RCU_INIT_POINTER() with a !NULL
> argument, and those are 'special'.
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
