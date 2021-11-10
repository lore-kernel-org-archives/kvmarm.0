Return-Path: <SRS0=+uR8=P5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15354C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 11:08:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 80F0E61241
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 11:08:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 80F0E61241
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E86394B2FD;
	Wed, 10 Nov 2021 06:08:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wQtNZEw-E1GP; Wed, 10 Nov 2021 06:08:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE8F14B2D0;
	Wed, 10 Nov 2021 06:08:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A37F4B2BC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 06:08:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZdMAFrxLiFgE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 06:08:01 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7A264B2B8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 06:08:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636542481;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=48dRn8RRnq7Fx6Bqaf9CAoNN40en8LqbHxW41Xnziw0=;
 b=dpWL7meooMgtBAmdDfRcE8M23Cvi9RojMiz0s6vfwne6xMgsHhy5yvRUBJSzSbnpT+vZE7
 UtCi2D18EuXvv1RNmj8iYDIBbQ1c3dwPweBTrUq4Kyiep81DMsIqjoi0EQBaFMqGXHjyw5
 9ddfqP0gd5Ejvqk0mMic57gjbIsJyWo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-mKn8Vk6JMryVY-jClPzSlQ-1; Wed, 10 Nov 2021 06:08:00 -0500
X-MC-Unique: mKn8Vk6JMryVY-jClPzSlQ-1
Received: by mail-ed1-f69.google.com with SMTP id
 w12-20020a056402268c00b003e2ab5a3370so2069585edd.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 03:08:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=48dRn8RRnq7Fx6Bqaf9CAoNN40en8LqbHxW41Xnziw0=;
 b=BSU1DdhUqJrd/qDRV4DomDYMoSRW/yQWPqaVjRyXFkXXqMKZn4iS1TOMeR8/3JTh0r
 HOmt6zSgq9+ATZpfevzYGYwi47cRlwF3juhEgBQ87MLz6v/szdy0poxptDncD52NepSN
 zyHHW2VqKjjMGtzo1VrrZU3jlaotDiIUYlynZav5CMKXpjg6KWQ1ipJ+cBhcFwXEXtOW
 jDtSdnLREy+9Zx5zfjNzFrH1Pp13aAnIHnAmtVGQ8hfW1ag4fJV1zMpd/gzrwcJ8b/m9
 QZg72B8+ZXO45YeHdE1SBLHQ1oejAXyNOz4pX7CruYfhFzibFKnxsmlq+cyvYeEinBzb
 6Y2g==
X-Gm-Message-State: AOAM531gQOYVb3iVR5H8GHLNLBzNVAFI4r+Tv5H+SUxO1UM16GJg64+A
 B5nS0KYUqQ8SH/Ux/y37pJL4ZzDxZqkrjv01OkShlZg2YHtRtvA/o3EOwhC8I24Rgb2hXKQHhbL
 KDjCfWkefyzPDiQXHUIxBsMgg
X-Received: by 2002:a17:907:86a6:: with SMTP id
 qa38mr18779904ejc.286.1636542479501; 
 Wed, 10 Nov 2021 03:07:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxIY9E3GGXDTMKNhG94s7x2qpu4nLPlWqmcyoHulhCMNs+PGo9+5ZlP1mG10EA68G9ox4DyaA==
X-Received: by 2002:a17:907:86a6:: with SMTP id
 qa38mr18779839ejc.286.1636542479231; 
 Wed, 10 Nov 2021 03:07:59 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045?
 ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
 by smtp.gmail.com with ESMTPSA id g21sm9257171edb.89.2021.11.10.03.07.55
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Nov 2021 03:07:58 -0800 (PST)
Message-ID: <f86fe9cb-bf4b-1c10-e0da-276fbb3f62ee@redhat.com>
Date: Wed, 10 Nov 2021 12:07:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 01/16] perf: Ensure perf_guest_cbs aren't reloaded
 between !NULL check and deref
To: Sean Christopherson <seanjc@google.com>, Like Xu <like.xu.linux@gmail.com>
References: <20210922000533.713300-1-seanjc@google.com>
 <20210922000533.713300-2-seanjc@google.com>
 <77e3a76a-016b-8945-a1d5-aae4075e2147@gmail.com>
 <YYPrst2CUBXLYc9h@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YYPrst2CUBXLYc9h@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>, Guo Ren <guoren@kernel.org>,
 linux-riscv@lists.infradead.org, Vincent Chen <deanbo422@gmail.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Stefano Stabellini <sstabellini@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, linux-csky@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, xen-devel@lists.xenproject.org,
 Albert Ou <aou@eecs.berkeley.edu>, Zhu Lingshan <lingshan.zhu@intel.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Greentime Hu <green.hu@gmail.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Namhyung Kim <namhyung@kernel.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>, Nick Hu <nickhu@andestech.com>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 11/4/21 15:18, Sean Christopherson wrote:
> If I'm interpeting Paolo's suggestion
> correctly, he's pointing out that oustanding stores to the function pointers in
> @cbs need to complete before assigning a non-NULL pointer to perf_guest_cbs,
> otherwise a perf event handler may see a valid pointer with half-baked callbacks.
> 
> I think smp_store_release() with a comment would be appropriate, assuming my
> above interpretation is correct.
> 

Yes, exactly.  It should even be rcu_assign_pointer(), matching the 
synchronize_rcu() in patch 1 (and the change can be done in patch 1, too).

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
