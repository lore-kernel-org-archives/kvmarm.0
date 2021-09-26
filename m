Return-Path: <SRS0=xQSp=OQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF915C433EF
	for <kvmarm@archiver.kernel.org>; Sun, 26 Sep 2021 06:27:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2E4C7610A8
	for <kvmarm@archiver.kernel.org>; Sun, 26 Sep 2021 06:27:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2E4C7610A8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D81F4B089;
	Sun, 26 Sep 2021 02:27:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tcAzMLfx6ifL; Sun, 26 Sep 2021 02:27:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3934A4B0B3;
	Sun, 26 Sep 2021 02:27:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACA8A4B08F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Sep 2021 02:27:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2DDPEkbUQ90r for <kvmarm@lists.cs.columbia.edu>;
 Sun, 26 Sep 2021 02:27:35 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 711424B089
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Sep 2021 02:27:35 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632637655;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=1TiBTpYstMaABQ/rAwh18m9vsSq3OqvaFEu629LcCL8=;
 b=AT5/PG0z3EzdeorlWOjcalMkMIuqdx/kSJlyedxA9a0Z5HaOAWh19SuOyQfVfP1hscnXDo
 ndrzwXzzRB5LVNi85EvMVI55Hx7Hnns/fgrq4gRTKomf4x5KJinVbPpTd/gfSLSyo8Vl98
 RL+yotYrs93Q304RJn+4O16zB8UkSk4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-tCY2hFG0NSqIqsvHdrxaVw-1; Sun, 26 Sep 2021 02:27:33 -0400
X-MC-Unique: tCY2hFG0NSqIqsvHdrxaVw-1
Received: by mail-ed1-f69.google.com with SMTP id
 r11-20020aa7cfcb000000b003d4fbd652b9so14500756edy.14
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Sep 2021 23:27:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=1TiBTpYstMaABQ/rAwh18m9vsSq3OqvaFEu629LcCL8=;
 b=z3wAVS1vQu5gL1TtcrbwKn8ay6NT/LgRFGzndi1mIR9NuEUea94tzkIsfhPOSWaujy
 W6nNSCtNtVqYb2qvj21RdpJZ/RfB0PGhyqCq23aibB8q77GK491A37lWY5rE+ZpuCfgl
 oeBgCdcxWOdC3z0w0G6NuM8O6HBretHfqCXFtIB7SgSO9HWNsni1f8M23tKT56HwOoMd
 XdxDZZ/aYG0Xq0byZK2LFG3XIube8ltCHHE9zLyi/zjjrsiYDyfwTwRolTeHBNopiY77
 NdjuYTxQI8XVl5Ai51IidibfUBp4LLLuvOrqzsyJAOyXwDvGFa6hA/0l9PFmBqm54NjW
 k4Vw==
X-Gm-Message-State: AOAM533KA8sgJ5949P8T2A1Fbnm5ZiSzeXV1bk3arAWgDiGgZcJUfn1p
 auOLNpZurgQtGWJPngQPrkuprr+bxqF0nbrDFq0r/CzcEtnnXCxw/v0n1dVjmCAZeBDnLjQ/Zn9
 e17iRbG+qimv/yamKdNfzx4B/
X-Received: by 2002:a17:906:bcf5:: with SMTP id
 op21mr21248194ejb.114.1632637652475; 
 Sat, 25 Sep 2021 23:27:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKIxMWhBoRL018xLqTu0jQnou9ZPZ7BoXp91FbgfoN587mWDIRzysD7Ruz1/cm6u5Gy8RhTw==
X-Received: by 2002:a17:906:bcf5:: with SMTP id
 op21mr21248168ejb.114.1632637652217; 
 Sat, 25 Sep 2021 23:27:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045?
 ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
 by smtp.gmail.com with ESMTPSA id dk27sm8333826edb.19.2021.09.25.23.27.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 25 Sep 2021 23:27:31 -0700 (PDT)
Message-ID: <80d90ee6-0d43-3735-5c26-be8c3d72d493@redhat.com>
Date: Sun, 26 Sep 2021 08:27:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 07/14] KVM: Don't block+unblock when halt-polling is
 successful
To: Marc Zyngier <maz@kernel.org>, Sean Christopherson <seanjc@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-8-seanjc@google.com> <878rzlass2.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <878rzlass2.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On 25/09/21 11:50, Marc Zyngier wrote:
>> there is no need for arm64 to put/load
>> the vGIC as KVM hasn't relinquished control of the vCPU in any way.
> 
> This doesn't mean that there is no requirement for any state
> change. The put/load on GICv4 is crucial for performance, and the VMCR
> resync is a correctness requirement.

I wouldn't even say it's crucial for performance: halt polling cannot 
work and is a waste of time without (the current implementation of) 
put/load.

However, is activating the doorbell necessary?  If possible, polling the 
VGIC directly for pending VLPIs without touching the ITS (for example by 
emulating IAR reads) may make sense.  IIUC that must be done at EL2 
though, so maybe it would even make sense to move all of halt polling to 
EL2 for the nVHE case.  It all depends on benchmark results, of course.

Sorry for the many stupid questions I'm asking lately, but I'm trying to 
pay more attention to ARM and understand the VGIC and EL1/EL2 split better.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
