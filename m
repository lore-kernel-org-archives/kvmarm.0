Return-Path: <SRS0=fzUG=OL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CDE9C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 16:44:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B53E6115A
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 16:44:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9B53E6115A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11B844A193;
	Tue, 21 Sep 2021 12:44:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H7-6kA-bHz4r; Tue, 21 Sep 2021 12:44:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77DB54B089;
	Tue, 21 Sep 2021 12:44:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB80A407ED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 12:44:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KpCH4Ry1G9iN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 12:44:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2888C40162
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 12:44:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632242678;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=2MOh25Z0CXinUksqYDluCoredOuFNiGvVHCwdZh/BTA=;
 b=fMQBRvFbKUREv2fA+AGvkCsmlbU6zexpDH0XZ7f9S+6tOtWrksGDgEYq1tJD5g/1pJpAQq
 NHx71FG/3pPj+hPpQHV/wluvJjANYWDxvg7ZaRm3yIhXhA62L9X0LzWiTFHHhN7KL3a8tk
 6O8nSkJsGIEhmzcttRNJ67nAEZ8utTA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-_TX066HkNom0ngZOLvT3mQ-1; Tue, 21 Sep 2021 12:44:37 -0400
X-MC-Unique: _TX066HkNom0ngZOLvT3mQ-1
Received: by mail-wr1-f72.google.com with SMTP id
 x7-20020a5d6507000000b0015dada209b1so9313191wru.15
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 09:44:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=2MOh25Z0CXinUksqYDluCoredOuFNiGvVHCwdZh/BTA=;
 b=xWjVrBsCVMYRTdqPVwpalenXLgKVpDpffwHsIfxMS8j97iM0kDDx9A4/gjRp8XFVTl
 9OIxdP6cOEBUQnFKm9VRgLTdDNe5p/Cz2OwUmyE8Awo0HqY5c2ALF+ewoU8u9IrntMJx
 2kh01UzKYCZT2ZzRFdYZI5brUTx0PN+CoycJtVHVUN9wHwF9AfUOK8sx6hcCSenukmvf
 kk0VG1uFPb5Y7bZa+8xl235eQVrYQyg7A9wyOs6oGjJlITGQxf7NUaL+xwaDG+qnZR0G
 llczpg3w0YSwsLpEpX7LUQfNZBm3f7hXTU10sYtpq/nWVNVo316l5Av5guzg9QXJawFO
 8TNA==
X-Gm-Message-State: AOAM530H7EhVYeaNJPUqE04VOvplx7I2lHDVGu/teu5vxMGFWhonbLgq
 aNWLUK3gu3dofbjc+qvpM1e83bKUmh98/Lcge6DOuAiNVaN+DRMET/nGTJb2Tij79d42z1G1sUe
 gUoa0ycikME4OTIq/zROrV/vm
X-Received: by 2002:adf:ef02:: with SMTP id e2mr35671908wro.401.1632242676306; 
 Tue, 21 Sep 2021 09:44:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsCp5ZrdIqXk735XH8pFAzorkNCbfLAUPGTe1MtIGjUyvp4uSPpnZgIUWeU9z8tn602zxqYg==
X-Received: by 2002:adf:ef02:: with SMTP id e2mr35671861wro.401.1632242676096; 
 Tue, 21 Sep 2021 09:44:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id k1sm20272243wrz.61.2021.09.21.09.44.21
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Sep 2021 09:44:35 -0700 (PDT)
Subject: Re: [PATCH v2 05/13] perf: Force architectures to opt-in to guest
 callbacks
To: Peter Zijlstra <peterz@infradead.org>,
 Sean Christopherson <seanjc@google.com>
References: <20210828003558.713983-1-seanjc@google.com>
 <20210828003558.713983-6-seanjc@google.com>
 <20210828194752.GC4353@worktop.programming.kicks-ass.net>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8ee13a69-f2c4-2413-2d6c-b6c0a559286e@redhat.com>
Date: Tue, 21 Sep 2021 18:44:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210828194752.GC4353@worktop.programming.kicks-ass.net>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Guo Ren <guoren@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Vincent Chen <deanbo422@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 linux-csky@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Ingo Molnar <mingo@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Like Xu <like.xu.linux@gmail.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Zhu Lingshan <lingshan.zhu@intel.com>, Will Deacon <will@kernel.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Greentime Hu <green.hu@gmail.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>, Nick Hu <nickhu@andestech.com>,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
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

On 28/08/21 21:47, Peter Zijlstra wrote:
>> +config HAVE_GUEST_PERF_EVENTS
>> +	bool
> 	depends on HAVE_KVM

It won't really do anything, since Kconfig does not detects conflicts 
between select' and 'depends on' clauses.

Rather, should the symbol be selected by KVM, instead of ARM64 and X86?

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
