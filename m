Return-Path: <SRS0=Qgx2=LI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07356C48BE6
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 09:53:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7481B61289
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 09:53:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7481B61289
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E40B849F83;
	Mon, 14 Jun 2021 05:53:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5PGcE2ZVgRbv; Mon, 14 Jun 2021 05:53:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD47740808;
	Mon, 14 Jun 2021 05:53:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD1B440821
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 05:53:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zt-Q31KmMIAj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Jun 2021 05:53:27 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C8DE40808
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 05:53:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623664407;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=4kx9Q3nsVnRINu0vIrWoo9nXjPPqt9AsqYqJM+8URyI=;
 b=DmD/zzSyyUI6UUPShMbzTxNeTo/xOFNgRuLH8zvd5h0q5W3o9M/ziOX1UUGjGGaVMZ9WoP
 mcGiC1AiHS2I1M558nxIrQ4oQGaB9g2+2zTL58I/xRc3avbhZVbBrTqAXkuF9jWouL478/
 QU4KNwQ6Fyz3piVQwMfvIiZkExrV7so=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-cZJ87SDHMDOOPT7owJhnJg-1; Mon, 14 Jun 2021 05:53:26 -0400
X-MC-Unique: cZJ87SDHMDOOPT7owJhnJg-1
Received: by mail-ej1-f70.google.com with SMTP id
 am5-20020a1709065685b02903eef334e563so2843847ejc.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 02:53:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=4kx9Q3nsVnRINu0vIrWoo9nXjPPqt9AsqYqJM+8URyI=;
 b=AvDFzqfmBHy8G8iqphLxwLlElHIFFTXjv7GkEgQ+Eu25pmJO5rubMWxw/D8Spuz8Vb
 ghZAOVgKfXYUA/MDSinRb4iTxR6PlnU6E7cWdyWfRnIIr67RuWIGa0PlGHo4Uc+ILQA+
 EEsWkQf15iLtRMKRBYWlRI2YATLwHrgnTyKA1EuxjNytmO+vkOfyBoaUAnmWJ9o4vaPY
 1rn0UkFH9ceIyEP6oF/hh6wXo1JXGCOstVC6QKM4KjpiVwepCsMdJmIfYMwTlYgeimE5
 81miy0iriFPQ91wbAoGDfUBW97NGGhIVPoKe30sZjIFPCm5+HyTjAyDsVI0iy7vZQO34
 ZvYA==
X-Gm-Message-State: AOAM531VK5JW7IgavkpctCBfUJN006d0wB88/YemhFeCwZhHSFs7I8dZ
 wyzzIrNZl6TwRak/KmLKmVR2r+J1voZnwyPZYxpVmFNo3VKZnA6AU6qVG7XADRyhsRarby6Zt4b
 HTxJ7MIjC/xhu/ocyd3WXO4ZU
X-Received: by 2002:aa7:dd1a:: with SMTP id i26mr16204811edv.358.1623664405110; 
 Mon, 14 Jun 2021 02:53:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDkQ0JPU1g5M6jhW9DnavBLG6plfx7uGDLrqTbEtcjhKBQcyMeEBajFaPx2nWsm5OdUYvaJg==
X-Received: by 2002:aa7:dd1a:: with SMTP id i26mr16204789edv.358.1623664404859; 
 Mon, 14 Jun 2021 02:53:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id p10sm8486235edy.86.2021.06.14.02.53.23
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 14 Jun 2021 02:53:24 -0700 (PDT)
Subject: Re: [PATCH 0/4] Remove duplicated stats definitions for debugfs
To: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, LinuxMIPS
 <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
 LinuxS390 <linux-s390@vger.kernel.org>, Fuad Tabba <tabba@google.com>
References: <20210614025351.365284-1-jingzhangos@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dc48637c-e683-a64a-b744-bd5fe2037f31@redhat.com>
Date: Mon, 14 Jun 2021 11:53:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210614025351.365284-1-jingzhangos@google.com>
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

On 14/06/21 04:53, Jing Zhang wrote:
> This is a follow-up patchset to binary stats interface patchset as below:
> https://lore.kernel.org/kvm/20210611124624.1404010-1-jingzhangos@google.com
> 
> This patchset contains a commit to fix some missing stats and add static
> check to make sure we have the right number of stats descriptors and add an
> 'offset' field in stats descriptor to make sure the or order of stats
> descriptors is not relevant to the order of stats in vm/vcpu stats
> structure. This will totally avoid the possibility of missing stats and
> mismatched stats definitions.
> 
> The binary stats interface defines stats in another array of descriptors,
> while the original stats debugfs interface uses array of kvm_stats_debugfs
> item. To remove the duplicated stats definition, this patchset would
> utilize only the stats descriptors to provide stats information to debugfs
> interface. This patchset adds a 'mode' flag to support the read/write mode
> of stats, which can be used to indicate the file permission of debugfs
> stats files. It removes the usage of kvm_stats_debugfs_item and all the
> debugfs_entries defined in all archs.
> 
> The patch also fixes an issue that read only stats could be cleared in
> global level, though not permitted in VM level in the original debugfs
> code.

Thanks for putting this together quickly.  I think we can drop the mode, 
see the suggestion in patch 2.

It's probably best to fold the v8 for the stats functionality, these 
patches (squashed appropriately) and Fuad's remars in a single posting. 
  But I'm quite confident that it can make it in 5.14.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
