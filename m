Return-Path: <SRS0=c4fT=6H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BE14C2BA19
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 08:58:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B8A752084D
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 08:58:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iGAOCQ8q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8A752084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ED064B099;
	Thu, 23 Apr 2020 04:58:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lvB49Sn6HMMc; Thu, 23 Apr 2020 04:58:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 341774B0E1;
	Thu, 23 Apr 2020 04:58:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DC984B096
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 04:58:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4wsE5CCWpwRq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2020 04:58:09 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 551B54B093
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 04:58:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587632289;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Kkq0uwjQBfxJhQKuYr+1chwz4XGWFG4HzoEt9DzJrws=;
 b=iGAOCQ8qlGPHFbP9p+FqEGRRLBMdsIE6UH6o4zEembVbztHHxC/JWhRoWv34o5h0XkQf9s
 dgj4jftcqXalejir7yAhsFS1HfgyurbDpxr3ZVe0F+AoDhsiUlgKIEvcAr97EuXqM4PKQa
 Wgk7i3h8Mv5BWJLy7gLrXX+R+3kGtvs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-zMUrZ67PN_qpVtj0okhbWg-1; Thu, 23 Apr 2020 04:58:07 -0400
X-MC-Unique: zMUrZ67PN_qpVtj0okhbWg-1
Received: by mail-wr1-f70.google.com with SMTP id p16so2524531wro.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 01:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=Kkq0uwjQBfxJhQKuYr+1chwz4XGWFG4HzoEt9DzJrws=;
 b=IpAwr9IwpyDsA+EasPG2XsTXpy2nT+TEGzgqHcRVb3ROl8gSQXa0ZWOmLwhUEFT7hg
 lJ8iURCm54vZJJ88UAOJl7QguBOr23x9oJAIEUvKX3dnU6mXPGlUnWs3RsPqZye8EcIZ
 E8cJbfhTlyOmsbDh1K/U7NrT4x+VfqtccnmTDCLKBJo3IYx6khWvNB3Gh2Tuk9O+vicG
 O08FVmwfPGKyqhNPbZbI4Atz4VqBl2ueUDclUvCAH7bTaxwN8ehXZjVTIunsEi8x4evn
 eMGNHWCYSSY/8kR+uAP1xj/WkVO0a2s75/SQV0zM5ZCLN7Bgc1k/Mnsi6HhCjlIljDpB
 GOoQ==
X-Gm-Message-State: AGi0PubxE5ehpoA3vaaILskuju0yaq3UlCmJcvmyEtLkEorZ8XEgG7uI
 pXzdvlQysVP8X9uMYCjWsBE44m7CeewbWVBP1XyEbt9slp/TwWU23ytKWevUjRu7tr4ppCvm3HV
 jWtO0SLk5UiCKtAv/XZ34M0T6
X-Received: by 2002:a5d:664f:: with SMTP id f15mr3609435wrw.72.1587632286118; 
 Thu, 23 Apr 2020 01:58:06 -0700 (PDT)
X-Google-Smtp-Source: APiQypJw0BmW6FuCWHcq3ZxzvKLkyVd4P0Y1C0QqksviQgntreRVEaQvmWwFSAjOCQTYt1Fqs4tEqA==
X-Received: by 2002:a5d:664f:: with SMTP id f15mr3609406wrw.72.1587632285847; 
 Thu, 23 Apr 2020 01:58:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d0a0:f143:e9e4:2926?
 ([2001:b07:6468:f312:d0a0:f143:e9e4:2926])
 by smtp.gmail.com with ESMTPSA id h2sm2810041wmf.34.2020.04.23.01.58.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 23 Apr 2020 01:58:05 -0700 (PDT)
Subject: Re: [PATCH 4/5] kvm: Replace vcpu->swait with rcuwait
To: Marc Zyngier <maz@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>
References: <20200422040739.18601-1-dave@stgolabs.net>
 <20200422040739.18601-5-dave@stgolabs.net> <20200423094140.69909bbb@why>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f07f6f55-9339-04b0-3877-d3240abd6d9c@redhat.com>
Date: Thu, 23 Apr 2020 10:57:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200423094140.69909bbb@why>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>, peterz@infradead.org,
 will@kernel.org, bigeasy@linutronix.de, linux-kernel@vger.kernel.org,
 rostedt@goodmis.org, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, joel@joelfernandes.org, tglx@linutronix.de,
 torvalds@linux-foundation.org, kvmarm@lists.cs.columbia.edu
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

On 23/04/20 10:41, Marc Zyngier wrote:
>>  
>> -	if (swait_active(kvm_arch_vcpu_wq(vcpu)))
>> +	if (rcu_dereference(kvm_arch_vpu_get_wait(vcpu)) != NULL)
> This doesn't compile (wrong function name, and rcu_dereference takes a
> variable). But whatever it would do if we fixed it looks dodgy. it isn't
> the rcuwait structure that you want to dereference, but rcuwait->task
> (we are checking whether we are called because we are blocking or being
> preempted).
> 

Yes, I agree.  Replacing swait with rcuwait is all good, but please make
the API look the same first.  Just like you added prepare_to_rcuwait and
finish_rcuwait, let's add rcuwait_active as well.

Actually let's do it like this:

1) Davidlohr, please post only patches 1-3 to "equalize" the swait and
rcuwait APIs.

2) Peter, please prepare a topic branch for those, or provide Acked-by

3) let's get everything else through the KVM tree.

Thanks,

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
