Return-Path: <SRS0=fBez=57=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC66CC2BB55
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 12:11:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 48F49206F9
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 12:11:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fPs7s5Bj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48F49206F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A71994B110;
	Wed, 15 Apr 2020 08:11:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eFrVK3oFsQFi; Wed, 15 Apr 2020 08:11:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C65914B123;
	Wed, 15 Apr 2020 08:11:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92DDF4B123
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 08:11:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jqZbv9St-c23 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Apr 2020 08:11:43 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 792834B110
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 08:11:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586952703;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7z2lxhqtqRac6OWBHZcztpuLVVDTo4I3uiQvbh1thqo=;
 b=fPs7s5BjNPIR/RA3hQkHQyTAl649bLZIiGzUKhrw7roorZGsjKZtVdU2wZj5ebhiG0ndK1
 NoNHmGW0ONe9E95vqOQR7/8st+QGK082Co+6j0q6FQzy9w725QRqBCZOT/Kod5hOxl5+KZ
 ond6sr2IPbR8CgkK6o0fheQviEIU0js=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159--qLN0zT_OMGWTcXjVSZcaw-1; Wed, 15 Apr 2020 08:11:39 -0400
X-MC-Unique: -qLN0zT_OMGWTcXjVSZcaw-1
Received: by mail-wm1-f69.google.com with SMTP id h184so2087964wmf.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 05:11:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=3g8pOUWTOZg7Xu60Mt7A1x/Ov3i7r+YKQXs6UW5HczM=;
 b=aXAVLXb782Fvup0g/MdxupXP0I8VUr3khVMnzSAhSqy61P/CU/oe9UA6KNFVHgA6eI
 +HV2lzm3khNhzAYMmCk1VjrpDfT881WAqh3BIgv8SZubePtCPKP6lJ1Hl7E+mo3mfuNT
 QBn1Lj5NFJ/TMCA84Cu/wJzDkmdCwRAMjbm+ebgaMA4mCBWvwDyTFJkob5zthR610UST
 O2c27Gff81C8/nQ7KrytB14z0FNTspjUf+WVDbcVVGWRxr+0ldH7RzaJdfXdk+gTkGmd
 hpQdRukDQ8FYenE9F/FvD6CG/lMIIxu+vbeUvW6qlsfWi/ZLp6YgHcey3w4YctAG2fch
 xTCw==
X-Gm-Message-State: AGi0PuYGxn6Zx4mnRbZRkwTeVwBA8geQ5+wucVUG2JuPyYAxlrZfc0nQ
 UQkIuU2YgNKOwp8iluFBxkkYoE+pLsUWHvb47NrpEL847OB4fXHf9P0XLBDZL3xCv4oJ0rNaGzx
 MMOBLaqdxWd2HptrHB2iQVcqR
X-Received: by 2002:a5d:688f:: with SMTP id h15mr29234462wru.352.1586952698408; 
 Wed, 15 Apr 2020 05:11:38 -0700 (PDT)
X-Google-Smtp-Source: APiQypKdWpo7ENEPbDqHP93vSXvdpZwuSMQZ1BbP1xfwyNZcod/63Icpez1n6CuR5oR+nIQbYmcMPw==
X-Received: by 2002:a5d:688f:: with SMTP id h15mr29234435wru.352.1586952698180; 
 Wed, 15 Apr 2020 05:11:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e?
 ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
 by smtp.gmail.com with ESMTPSA id q8sm22064722wmg.22.2020.04.15.05.11.36
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 15 Apr 2020 05:11:37 -0700 (PDT)
Subject: Re: [PATCH 3/4] kvm: Replace vcpu->swait with rcuwait
To: Davidlohr Bueso <dave@stgolabs.net>
References: <20200324044453.15733-1-dave@stgolabs.net>
 <20200324044453.15733-4-dave@stgolabs.net>
 <a6b23828-aa50-bea0-1d2d-03e2871239d4@redhat.com>
 <20200414211243.7vehybdrvbzmbduu@linux-p48b>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b2f87633-8eef-4f84-5e65-a80523ca34f8@redhat.com>
Date: Wed, 15 Apr 2020 14:11:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200414211243.7vehybdrvbzmbduu@linux-p48b>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>, peterz@infradead.org,
 torvalds@linux-foundation.org, bigeasy@linutronix.de,
 linux-kernel@vger.kernel.org, rostedt@goodmis.org, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, joel@joelfernandes.org, tglx@linutronix.de,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 14/04/20 23:12, Davidlohr Bueso wrote:
> On Wed, 25 Mar 2020, Paolo Bonzini wrote:
> =

>> On 24/03/20 05:44, Davidlohr Bueso wrote:
>>> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
>>> index 71244bf87c3a..e049fcb3dffb 100644
>>> --- a/arch/mips/kvm/mips.c
>>> +++ b/arch/mips/kvm/mips.c
>>> @@ -290,8 +290,7 @@ static enum hrtimer_restart
>>> kvm_mips_comparecount_wakeup(struct hrtimer *timer)
>>> =A0=A0=A0=A0kvm_mips_callbacks->queue_timer_int(vcpu);
>>>
>>> =A0=A0=A0=A0vcpu->arch.wait =3D 0;
>>> -=A0=A0=A0 if (swq_has_sleeper(&vcpu->wq))
>>> -=A0=A0=A0=A0=A0=A0=A0 swake_up_one(&vcpu->wq);
>>> +=A0=A0=A0 rcuwait_wake_up(&vcpu->wait)
>>
>> This is missing a semicolon.=A0 (KVM MIPS is known not to compile and wi=
ll
>> be changed to "depends on BROKEN" in 5.7).
> =

> Do you want me to send another version with this fix or do you prefer
> fixing it when/if picked up?

It's up to the TIP tree people, but sending a fixed version is probably
the best way to get their attention. :)

I can also queue it myself (for 5.7 even) if I get an Acked-by from
Peter though.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
