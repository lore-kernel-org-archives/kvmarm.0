Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED71CC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Dec 2021 16:34:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70CF94B30A;
	Fri, 17 Dec 2021 11:34:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HnZubc9oq7pu; Fri, 17 Dec 2021 11:34:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 752554B328;
	Fri, 17 Dec 2021 11:34:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B01734B316
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 11:34:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZCTXQvj0CsuX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Dec 2021 11:34:11 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC9CB4B30A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 11:34:11 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1639758851;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ChIkAA1P0rhxmMj+OSv7E9eITrJWi4wnxfRUd873BMw=;
 b=CPd1BWE6OLW6SVUtnbR0MlqmxFBZNBNn9TTR2FqUcxr6iLSE/uRPshQrQptexjsKCngcii
 qqakzCoK2xx1tXpugALuqC5jezmuVRnJZhLxfNh/CcQLnXo8q0m2DlSq0xSGKDvtuquI8k
 P8roqy9OvmyotpJqtGXg9ADaq/ftmBU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-hmGwkjJzPfKS8lqgWAji9w-1; Fri, 17 Dec 2021 11:34:10 -0500
X-MC-Unique: hmGwkjJzPfKS8lqgWAji9w-1
Received: by mail-wm1-f71.google.com with SMTP id
 z13-20020a05600c0a0d00b003457d6619f8so799438wmp.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 08:34:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=ChIkAA1P0rhxmMj+OSv7E9eITrJWi4wnxfRUd873BMw=;
 b=39Mv+2T/HhcW6Dk2fkfNte8ZLJB3PgwMwIai48YGKlLsHOXS1JP4FbKepdqMt6FJB7
 btemEH9Xxw76xT94Mt/bJ67H+dfYMeqU2w9yUcourM5mUVUvj7a+DZRjwM6mFoAMhhEl
 b6LpAWkj1w6Ag1uRaLUhbp7pFii8/8YW10SwmSfDNw6k/3QcAJg4Hro/m2VD8FTKXO3G
 KQ3jgQovyWFqktQGw0IUeW7NDiTBAraPmLoc6Y0nJQ6ZfIIq/JJfTbb00cx4PQ/IOnKx
 VIfj16hLa+ci7ACLOTLCWxGlHJR/j6pXoFVkg49ZBLWSs6hDBlZDuE53LUWZg0bSlLMT
 hOOg==
X-Gm-Message-State: AOAM532UmlWlitosNqs2AZ6YAXpBYtSeWuE6T8a0N6+3IqUohSntu0/X
 U4Igz5DmpJMIlqxYpvpjEKWXeu+cag8lkcTIaEbF/Jy3WVG10EuLsTmnXezkvIqBLtOziT1KnPv
 PCdJIb1+kwZpUXgu0e2n3AMMV
X-Received: by 2002:adf:fb05:: with SMTP id c5mr3071893wrr.497.1639758849202; 
 Fri, 17 Dec 2021 08:34:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzDLzLvZGGbxXRIrttXF2p3HboGOachfgkml4ByJfP3WTVmRAGVDmx2EyyY0y0qV0GcR/afCw==
X-Received: by 2002:adf:fb05:: with SMTP id c5mr3071876wrr.497.1639758849019; 
 Fri, 17 Dec 2021 08:34:09 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe?
 ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
 by smtp.googlemail.com with ESMTPSA id h204sm7828484wmh.33.2021.12.17.08.34.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 17 Dec 2021 08:34:08 -0800 (PST)
Message-ID: <f3d6095a-70aa-3da0-08a6-3caff2638809@redhat.com>
Date: Fri, 17 Dec 2021 17:34:04 +0100
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
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211217160749.GS641268@paulmck-ThinkPad-P17-Gen-1>
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

On 12/17/21 17:07, Paul E. McKenney wrote:
>> rcu_note_context_switch() is a point-in-time notification; it's not strictly
>> necessary, but it may improve performance a bit by avoiding unnecessary IPIs
>> from the RCU subsystem.
>>
>> There's no benefit from doing it when you're back from the guest, because at
>> that point the CPU is just running normal kernel code.
>
> Do scheduling-clock interrupts from guest mode have the "user" parameter
> set?  If so, that would keep RCU happy.

No, thread is in supervisor mode.  But after every interrupt (timer tick 
or anything), one of three things can happen:

* KVM will go around the execution loop and invoke 
rcu_note_context_switch() again

* or KVM will go back to user space

* or the thread will be preempted

and either will keep RCU happy as far as I understand.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
