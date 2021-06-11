Return-Path: <SRS0=JLBt=LF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99EFAC48BE5
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 13:35:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 19C8D61404
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 13:35:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19C8D61404
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AA3F4B0CA;
	Fri, 11 Jun 2021 09:35:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FPcP2pCGh8Zg; Fri, 11 Jun 2021 09:35:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 878AA4B096;
	Fri, 11 Jun 2021 09:35:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A16284A551
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 09:35:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pnnCjWf+iWOR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Jun 2021 09:35:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C57AD4A319
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 09:35:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623418502;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=zlTvKdwzw5MkeEEEC9I9PiSc9XRaRFcAGdPS/4M7/T4=;
 b=FRqFKLZsbjoyQruyeiFbH0viF18e7E3266p2IR93NUzAS3/Hn2icFRVHyulwND6ae0khkQ
 Nt9ab2cu9LOa1e+JaNUyg86a5s4sfEMN0XKllXUjrYmulByi5lWUDFp+TDDyohKbM5x93F
 YYtMruKjkOc0KMfeE9PCiSE+Zsf3fto=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-R4BaGaoXPpexoAqOSjayQA-1; Fri, 11 Jun 2021 09:35:01 -0400
X-MC-Unique: R4BaGaoXPpexoAqOSjayQA-1
Received: by mail-wr1-f70.google.com with SMTP id
 q15-20020adfc50f0000b0290111f48b865cso2659298wrf.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 06:35:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=zlTvKdwzw5MkeEEEC9I9PiSc9XRaRFcAGdPS/4M7/T4=;
 b=H0DbIuS/Hn8PkwPpipUsA19bC6SCwTD/+p9S2l6/QBWMjR0bet+lZwwsgOtdK8rwC2
 thla/iBcw6OxNltmrXYDHwpTA3oypWQFSzqtM0AfPDaoZP/oIy1BcvXDqrsL9GjeltqX
 bFxYrB3nUkSQCn/WpEP2EK+t9dipgbW4EXpq1kSJCxX61Zms0ZQKnED2LiuYdTdUq0Hq
 5dvxmVqtXTNzVrYtH5mBiWg3T1JB/Km1KjBFxeySGuti7vJUVPVV0jciLvE6GUEiZiD/
 QU5M7mI9Svlm1FTXnf0IhCLq+voKJ37mbppQqdgY1RjXwIbng0yc/uiZV+HveLc0e6BT
 0Ttg==
X-Gm-Message-State: AOAM532ybyx0WGWYwghpQ9EphHtt/8SeJXDUjvRRw/lh65lqvn/AxT8O
 YWN+vPoOkHTliVRlX2MMAypK211uaYOXTMY1h2r63QvgCzlBbrS8vVz6+hyGC9HPnfsQx8k5V+A
 CTVCXRss6camoVig2FhqOoTfP
X-Received: by 2002:a5d:59a9:: with SMTP id p9mr4119005wrr.86.1623418499473;
 Fri, 11 Jun 2021 06:34:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQM71M7BxbgLxkAQ6Zmo10Dt54e39XGmZG2f98CnpQkRKj9ZJdrEctz2F/sjq+A79DdtQBVQ==
X-Received: by 2002:a5d:59a9:: with SMTP id p9mr4118955wrr.86.1623418499200;
 Fri, 11 Jun 2021 06:34:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id t4sm7169792wru.53.2021.06.11.06.34.56
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 11 Jun 2021 06:34:58 -0700 (PDT)
To: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, LinuxMIPS
 <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
 LinuxS390 <linux-s390@vger.kernel.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>,
 Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>,
 David Rientjes <rientjes@google.com>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 David Matlack <dmatlack@google.com>, Ricardo Koller <ricarkol@google.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20210611124624.1404010-1-jingzhangos@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v8 0/4] KVM statistics data fd-based binary interface
Message-ID: <d9d440f0-ac2d-5a90-4e90-5eaa365f422e@redhat.com>
Date: Fri, 11 Jun 2021 15:34:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210611124624.1404010-1-jingzhangos@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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

On 11/06/21 14:46, Jing Zhang wrote:
> This patchset provides a file descriptor for every VM and VCPU to read
> KVM statistics data in binary format.
> It is meant to provide a lightweight, flexible, scalable and efficient
> lock-free solution for user space telemetry applications to pull the
> statistics data periodically for large scale systems. The pulling
> frequency could be as high as a few times per second.
> In this patchset, every statistics data are treated to have some
> attributes as below:
>    * architecture dependent or generic
>    * VM statistics data or VCPU statistics data
>    * type: cumulative, instantaneous,
>    * unit: none for simple counter, nanosecond, microsecond,
>      millisecond, second, Byte, KiByte, MiByte, GiByte. Clock Cycles
> Since no lock/synchronization is used, the consistency between all
> the statistics data is not guaranteed. That means not all statistics
> data are read out at the exact same time, since the statistics date
> are still being updated by KVM subsystems while they are read out.

The binary interface itself looks good.  Can you do a follow-up patch to 
remove struct kvm_stats_debugfs_item and avoid the duplication?  I'd 
rather have that too before committing the code.

Thanks,

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
