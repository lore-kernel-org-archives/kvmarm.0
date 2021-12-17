Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0382C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 17 Dec 2021 17:02:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C6694B35A;
	Fri, 17 Dec 2021 12:02:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EJvTqcoH-PGD; Fri, 17 Dec 2021 12:02:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34F9E4B35B;
	Fri, 17 Dec 2021 12:02:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 165E74B34C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 12:02:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZCltJ48lbF0w for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Dec 2021 12:02:34 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B42E4B348
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 12:02:34 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1639760554;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=58xC6/7sDobq7k3UfPIWPW94AtvXxt+V86z+2iDC+2w=;
 b=Urko740bB9htAI+7p+wyutL2cil/oVdU1hiaI/BR67km2WC42CuxDMCajpH4dK2Vs1t+kp
 IGEeiMGAwZoDWlqWi92wg3i54hhQBiRFNt+1XjytQfZacQcgwVyGJGLf8pDVFJGaOWmLbe
 XIVtrRMV+9txokyNCapc2uTrT8CJFHI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-SirN12meN-SyFKCm8KLArw-1; Fri, 17 Dec 2021 12:02:32 -0500
X-MC-Unique: SirN12meN-SyFKCm8KLArw-1
Received: by mail-wm1-f71.google.com with SMTP id
 f202-20020a1c1fd3000000b00344f1cae317so2071582wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 09:02:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=58xC6/7sDobq7k3UfPIWPW94AtvXxt+V86z+2iDC+2w=;
 b=2jvHdziOKklD+L+wr053uAYal2jKnzvSKEw22fPh73dIQIteAwpmUulcgtyN118LzQ
 iS3t7orZQgPk41N+WwKKaA4g06LXvp9N8MCtLSAC4jhPwyf8AaKIwGu5zSGCxySZRbD1
 R9JxoMMW6/IBaEFrlRCDHZqUy88NcZQGq6L0XNGEUEaTKfobJM+QuJ4n6m6+/IvmCJPn
 JD7V6dIfyKwH2t1Eq1LQ2X7PG3bWJK21YdOyFQa8WZwuxBtc2pU01tS8mP8hJr0AAlwS
 aznHlhxMjL6HIyH7U/54GFKxtOia9Gmy3LdVIJ935W1hABeKPK1+uNwnddP54uTybk1G
 kIFQ==
X-Gm-Message-State: AOAM531vipQKEkZkMVNoGz9KzC5Zo93e6umFHAEUuYVYYpZzzYTTiCWV
 y7dgWl2R9tpxtiTcVWRGhzoKad2aMtRqqO0eMPF0Mpnk3BrNuW6iD4QGBwl8M7/1/tWxhHw/zZg
 2ZjElSPUZe0cdA3X22MULs/2W
X-Received: by 2002:a5d:50c2:: with SMTP id f2mr1630549wrt.459.1639760551531; 
 Fri, 17 Dec 2021 09:02:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxt1I8ke5xrxCT2VayX74T7SOcgRXF4/LpFPypHzz/NgKLPu11J2MlPuURQrtM4+KYAlz3k6Q==
X-Received: by 2002:a5d:50c2:: with SMTP id f2mr1630536wrt.459.1639760551326; 
 Fri, 17 Dec 2021 09:02:31 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312::ac3? ([2001:b07:6468:f312::ac3])
 by smtp.googlemail.com with ESMTPSA id u14sm8273562wrf.39.2021.12.17.09.02.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 17 Dec 2021 09:02:30 -0800 (PST)
Message-ID: <4c369ca2-2ad0-4a02-90e9-2d82df6c289d@redhat.com>
Date: Fri, 17 Dec 2021 18:02:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Possible nohz-full/RCU issue in arm64 KVM
To: paulmck@kernel.org
References: <d80e440375896f75d45e227d40af60ca7ba24ceb.camel@redhat.com>
 <YbyO40zDW/kvUHEE@FVFF77S0Q05N>
 <70f112072d9496d21901946ea82832d3ed3a8cb2.camel@redhat.com>
 <Ybyg1r/Q6EfeuXGV@FVFF77S0Q05N>
 <9ab8107f-ff41-6a9e-57e1-a261bea93aca@redhat.com>
 <20211217160749.GS641268@paulmck-ThinkPad-P17-Gen-1>
 <f3d6095a-70aa-3da0-08a6-3caff2638809@redhat.com>
 <20211217164535.GU641268@paulmck-ThinkPad-P17-Gen-1>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211217164535.GU641268@paulmck-ThinkPad-P17-Gen-1>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: maz <maz@kernel.org>, frederic <frederic@kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
 rcu <rcu@vger.kernel.org>, Nicolas Saenz Julienne <nsaenzju@redhat.com>,
 Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

On 12/17/21 17:45, Paul E. McKenney wrote:
> On Fri, Dec 17, 2021 at 05:34:04PM +0100, Paolo Bonzini wrote:
>> On 12/17/21 17:07, Paul E. McKenney wrote:
>>>> rcu_note_context_switch() is a point-in-time notification; it's not strictly
>>>> necessary, but it may improve performance a bit by avoiding unnecessary IPIs
>>>> from the RCU subsystem.
>>>>
>>>> There's no benefit from doing it when you're back from the guest, because at
>>>> that point the CPU is just running normal kernel code.
>>>
>>> Do scheduling-clock interrupts from guest mode have the "user" parameter
>>> set?  If so, that would keep RCU happy.
>>
>> No, thread is in supervisor mode.  But after every interrupt (timer tick or
>> anything), one of three things can happen:
>>
>> * KVM will go around the execution loop and invoke rcu_note_context_switch()
>> again
>>
>> * or KVM will go back to user space
> 
> Here "user space" is a user process as opposed to a guest OS?

Yes, that code runs from ioctl(KVM_RUN) and the ioctl will return to the 
calling process.

Paolo

>> * or the thread will be preempted
>>
>> and either will keep RCU happy as far as I understand.
> 
> Regardless of the answer to my question above, yes, these will keep
> RCU happy.  ;-)

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
