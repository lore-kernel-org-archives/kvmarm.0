Return-Path: <SRS0=mTyv=AV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A455C433DF
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jul 2020 07:48:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AACB7207BC
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jul 2020 07:48:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UIwwVZez"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AACB7207BC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 140AD4B14D;
	Fri, 10 Jul 2020 03:48:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pV5AI++oepsI; Fri, 10 Jul 2020 03:48:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D2FF4B14E;
	Fri, 10 Jul 2020 03:48:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C43D4B14C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 03:48:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id scB8w1b5Ha0z for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2020 03:48:38 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CB994B138
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 03:48:38 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1594367318;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=w3lPi8IIyg6JHok2MkrSRXRUKV+20Z+zeyOlBbulHrA=;
 b=UIwwVZezTDq6vUmce3Y1ef+Ehzm4G3VyUPnegLqxtIOw4MahNujDj9DYBiQ22AT1KosoRF
 whFbgfxVdWntveU+CGH47c3k7ucYNEYnp0AWblCtvNadzsmUVivZCaOe7p63ePL4M9GI9d
 yyiK71vwBliW02CQo2kSbPhg2o6llng=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-N2MmoZW9MeGHpnyjm5PZiQ-1; Fri, 10 Jul 2020 03:48:36 -0400
X-MC-Unique: N2MmoZW9MeGHpnyjm5PZiQ-1
Received: by mail-wr1-f69.google.com with SMTP id g14so5041279wrp.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 00:48:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=w3lPi8IIyg6JHok2MkrSRXRUKV+20Z+zeyOlBbulHrA=;
 b=rpnLwyoZeRWPcCwMp2/StUNa+/VyvhftN/kgRfLVX9sipeq2by/6P7hGC9mzOURTsy
 uV41P/510BqDQyuKvKjp3B13P7D0nO8fjmwVhiNWeaeXVaRgVEKE/zy1OqC428BO5mZZ
 F5FvrF/xGuyPP8gNhDvxXpVfYlF3FuTLVL+vqGoIHGWOxdegC1njmW+cNqwiDKD7r/Qk
 9lTs88UqVzDjQye499kJ4B2gtvC5Hj49cpQLEmKB/S8jQIhCxCJWHZ8G9EkJ6T6o3zuO
 JLxNEMTaqp2mMFMMiGAtGgvQbqH/ZU8J4Pbt9Vk4+DtaObCN6cVdX/QV4WFK6qPXMi8t
 Q59w==
X-Gm-Message-State: AOAM530i65lOf2VNRXzuxKN/0vfH+plM1WZOVRLsRAk/Qm/7xNJvzpQT
 JADTHH+a5CEaGKYV9ORXlO9UNYtDq4JQoZ8zyS2KHa2+YYB/ZOHMFQrxiGvB3lYOtdQJq3GVgJb
 bJvIkrVsfTrvP2KDLsgwSpmEU
X-Received: by 2002:a7b:c952:: with SMTP id i18mr4118720wml.65.1594367315235; 
 Fri, 10 Jul 2020 00:48:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoVcmgycalDG2NxxBpe/F1Ip5MhErG5G/6zxHhUH+uoCv6KdhugBz3NZfr470zRIHVmrw60A==
X-Received: by 2002:a7b:c952:: with SMTP id i18mr4118689wml.65.1594367315031; 
 Fri, 10 Jul 2020 00:48:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c?
 ([2001:b07:6468:f312:9541:9439:cb0f:89c])
 by smtp.gmail.com with ESMTPSA id o9sm8786762wrs.1.2020.07.10.00.48.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 10 Jul 2020 00:48:34 -0700 (PDT)
Subject: Re: [PATCH v6 1/5] KVM: s390: clean up redundant 'kvm_run' parameters
To: Christian Borntraeger <borntraeger@de.ibm.com>,
 Tianjia Zhang <tianjia.zhang@linux.alibaba.com>, tsbogend@alpha.franken.de,
 paulus@ozlabs.org, mpe@ellerman.id.au, benh@kernel.crashing.org,
 frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
 heiko.carstens@de.ibm.com, gor@linux.ibm.com,
 sean.j.christopherson@intel.com, vkuznets@redhat.com, wanpengli@tencent.com,
 jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, maz@kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com,
 chenhuacai@gmail.com
References: <20200623131418.31473-1-tianjia.zhang@linux.alibaba.com>
 <20200623131418.31473-2-tianjia.zhang@linux.alibaba.com>
 <c49f8814-c7ea-6884-91c5-3dcd40c6509f@de.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2e986527-1585-e1b4-1251-ef36ac3bd233@redhat.com>
Date: Fri, 10 Jul 2020 09:48:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <c49f8814-c7ea-6884-91c5-3dcd40c6509f@de.ibm.com>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvmarm@lists.cs.columbia.edu,
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

On 23/06/20 17:31, Christian Borntraeger wrote:
> 
> I have trouble seeing value in this particular patch. We add LOCs
> without providing any noticable benefit. All other patches in this series at
> least reduce the amount of code. So I would defer this to Paolo if he prefers
> to have this way across all architectures. 

Yes, it adds lines of code but they're just

+	struct kvm_run *kvm_run = vcpu->run;

You could avoid the LoC increase by repeating vcpu->run over and over,
but I think the code overall is clearer.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
