Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A80C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:44:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2A00464F3A
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:44:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A00464F3A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 950BE4B59C;
	Wed, 10 Mar 2021 12:44:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FzawVDHGxLBV; Wed, 10 Mar 2021 12:44:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95CE94B297;
	Wed, 10 Mar 2021 12:44:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDC6C4B28C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:44:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IVxsgCFxM5Nn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:44:35 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB30C4B288
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:44:35 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615398275;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=hU8ekKHxTbztMp+pHZxvBx516z1N7ENAuWaGaufXY5Q=;
 b=M0nKwfWzqhzazwZTZoyLR5dfTH/VdD84Jp08AgmsK+luBt1inadsNcUK3IPvsgy3qeLJkz
 DAV/PGnY2zOyBKbiZ/mj/Zm6/YSQoxDZU3pGyz2Q9Uc0FiMSahSbkPXO+IBUBai8GfL66V
 yYnpc5SVsKHuCm27aJSD8VmrRnYUEqo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-kHPu2rz6On-4-1kq_nwxUg-1; Wed, 10 Mar 2021 12:44:31 -0500
X-MC-Unique: kHPu2rz6On-4-1kq_nwxUg-1
Received: by mail-ej1-f72.google.com with SMTP id n25so7556612ejd.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:44:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=hU8ekKHxTbztMp+pHZxvBx516z1N7ENAuWaGaufXY5Q=;
 b=IhC65SeVIM+7IRh+L58e5HxNsVCmMymVNoNv/mNTt4hCbn0hrIPDIIqk5u9bl1r5nG
 uRUHqfF+wt4XQNDsXJwSNzb7Ek8TNVARYf+FBFmmKidnNIIkNxkwvjz+82iMpsFnx0Qx
 laxLVjjdGWvVtXCqJadEWwWwL0CPmPZMIb15A72ZbPt//DgQ0WlaEAOaOk/X287imNtG
 jT0r8+P9AgG8LMsvn+pegEm6IYRIfj3oCONoi/S0TQPNdqC9idAmNlaYlILQfq2J09V3
 wonOUGcnvTmiVgp0hV1SGCEF7YjLcTH/6WebSkpZRrVtdDz6ywqNI3eNr4fEEDebFngy
 gevA==
X-Gm-Message-State: AOAM531HXSjaytvA9WO4kfWJRMisIiocVDKnhzJEISYXXxR6E17tWZI6
 xmp5OCF2GuosTR7dhhDsW7MTi49W9EjzHUqHLJ17TFP6Nyi7w/mLJNTNLdk/ntAQBS2dSP525iG
 QQ729Vn60iSw7SKXoDNRY7Fhx
X-Received: by 2002:aa7:ca02:: with SMTP id y2mr4748939eds.53.1615398270322;
 Wed, 10 Mar 2021 09:44:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxG/7Jpsz0wHHG4vrGLPJ/mZ70rGmjD1p1cn8m5yCq4LyuA7dJeziZrVH9s6TVL8ShkHCSIiQ==
X-Received: by 2002:aa7:ca02:: with SMTP id y2mr4748899eds.53.1615398270150;
 Wed, 10 Mar 2021 09:44:30 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id 90sm11387479edr.69.2021.03.10.09.44.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Mar 2021 09:44:29 -0800 (PST)
Subject: Re: [RFC PATCH 3/4] KVM: stats: Add ioctl commands to pull statistics
 in binary format
To: Marc Zyngier <maz@kernel.org>
References: <20210310003024.2026253-1-jingzhangos@google.com>
 <20210310003024.2026253-4-jingzhangos@google.com>
 <875z1zxb11.wl-maz@kernel.org>
 <a475d935-e404-93dd-4c6d-a5f8038d8f4d@redhat.com>
 <8735x3x7lu.wl-maz@kernel.org>
 <2749fe68-acbb-8f4d-dc76-4cb23edb9b35@redhat.com>
 <871rcmhq43.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fd37d21f-f3ae-d370-f8e1-cf552be3b2ee@redhat.com>
Date: Wed, 10 Mar 2021 18:44:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <871rcmhq43.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linux kselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVM ARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 Linux S390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Oliver Upton <oupton@google.com>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVM PPC <kvm-ppc@vger.kernel.org>,
 Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, Linux MIPS <linux-mips@vger.kernel.org>,
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

On 10/03/21 18:31, Marc Zyngier wrote:
>> Maintaining VM-global counters would require an atomic instruction and
>> would suffer lots of cacheline bouncing even on architectures that
>> have relaxed atomic memory operations.
> Which is why we have per-cpu counters already. Making use of them
> doesn't seem that outlandish.

But you wouldn't be able to guarantee consistency anyway, would you? 
You *could* copy N*M counters to userspace, but there's no guarantee 
that they are consistent, neither within a single vCPU nor within a 
single counter.

>> Speed/efficiency of retrieving statistics is important, but let's keep
>> in mind that the baseline for comparison is hundreds of syscalls and
>> filesystem lookups.
>
> Having that baseline in the cover letter would be a good start, as
> well as an indication of the frequency this is used at.

Can't disagree, especially on the latter which I have no idea about.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
