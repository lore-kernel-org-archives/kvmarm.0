Return-Path: <SRS0=wisL=6F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6602C2BA19
	for <kvmarm@archiver.kernel.org>; Tue, 21 Apr 2020 09:45:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6C3EC2087E
	for <kvmarm@archiver.kernel.org>; Tue, 21 Apr 2020 09:45:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZmrRktX9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C3EC2087E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E16544B117;
	Tue, 21 Apr 2020 05:45:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CKQcuwxVHNZY; Tue, 21 Apr 2020 05:45:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01AFC4B11A;
	Tue, 21 Apr 2020 05:45:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C2884B109
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2020 05:45:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HPDFS-TmasvA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Apr 2020 05:45:04 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AABD24B0F3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2020 05:45:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587462304;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QQEG806Zdu9gRuTErXPOwiRWiDajtPBXwIo3XxrNhOs=;
 b=ZmrRktX9sBOEluyXlNgNNmmpHkJuz3ddDgcIcXoPXeAuEcmVnVUsG7CTDOQiPhWWJty230
 rBol7vsIpxslL5jOiLCqVHbUCz98CqAiYQ2+pFU97hD5unxkJK/Q2gT5/xyBvgM7/18qPY
 5apInr6b1vk729boX85i5DgT5uGvuLc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-6dnbgtoTMMmBoVvKn-jTwA-1; Tue, 21 Apr 2020 05:45:00 -0400
X-MC-Unique: 6dnbgtoTMMmBoVvKn-jTwA-1
Received: by mail-wm1-f72.google.com with SMTP id q5so1219738wmc.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Apr 2020 02:45:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=Vn871PQoRr8hKR73ojEvQDx4nU8OlY1HT3TpH6BJBpc=;
 b=mJwTVHeju00vH+vgkFtQyUuP9t8WPqmz/ISxF2E2gZQj/eJjkuyH8B7NOr9Jok8Zdc
 Bkn5AQH6a8SNZAuansrlr7q8Ph4xC8OiG6EFnFNqWhg/4L2oq+j1u99v5kapLSfTu2B2
 nikSV0OO32RJPPBFKd/DzuJ99hHOubxd1j78lTbfqI4Qm3/qW9WCaniNhkmRtWWK3Gw5
 DQLTMH+bP6YqmzFgBBoZFgJDoJ4ca1ZtfKTC80MoJr+Bg5AD5KbeN6XiTRNfbbsoML6J
 5fKMAvafzhF3bcxpYqM0WlMPR7UTmepLQIftodi+kLBohI5nKxBEpbPoueKEMOt694MZ
 Byxw==
X-Gm-Message-State: AGi0PuZyLjD7ntmf6CzvQQQcIOwy8B9lKbNiM2upQuRiXRbeEfCV5HD/
 0jC6j9udGgK80gCyj2smb0QGlc9wvBJDWvP9/+SVtihIC+ONzK5+sepfNdKisgzvyIlQaKiZxib
 sZcDcylpAn0NUJQZtq4yWsfwo
X-Received: by 2002:adf:e982:: with SMTP id h2mr22309078wrm.425.1587462299213; 
 Tue, 21 Apr 2020 02:44:59 -0700 (PDT)
X-Google-Smtp-Source: APiQypLbdpxyM62zaDI9d+6FTcqhJenduGXb99s5sXM8ly8KhMH8Zk/YVGvLVp9YOKq9Pttf2tCjnw==
X-Received: by 2002:adf:e982:: with SMTP id h2mr22309050wrm.425.1587462299019; 
 Tue, 21 Apr 2020 02:44:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d0a0:f143:e9e4:2926?
 ([2001:b07:6468:f312:d0a0:f143:e9e4:2926])
 by smtp.gmail.com with ESMTPSA id a7sm2684985wmj.12.2020.04.21.02.43.43
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Apr 2020 02:44:58 -0700 (PDT)
Subject: Re: [PATCH v2] kvm: Replace vcpu->swait with rcuwait
To: Davidlohr Bueso <dave@stgolabs.net>
References: <20200324044453.15733-1-dave@stgolabs.net>
 <20200324044453.15733-4-dave@stgolabs.net>
 <20200420164132.tjzk5ebx35m66yce@linux-p48b>
 <418acdb5001a9ae836095b7187338085@misterjones.org>
 <20200420205641.6sgsllj6pmsnwrvp@linux-p48b>
 <f7cc83fe-3e91-0057-9af2-26c201456689@redhat.com>
 <20200420215014.sarodevmhphnkkn7@linux-p48b>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <02e1b00d-a8ea-a947-bbe6-0b1380aa7ec4@redhat.com>
Date: Tue, 21 Apr 2020 11:43:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200420215014.sarodevmhphnkkn7@linux-p48b>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>, peterz@infradead.org,
 Marc Zyngier <maz@kernel.org>, bigeasy@linutronix.de,
 linux-kernel@vger.kernel.org, rostedt@goodmis.org, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, will@kernel.org, joel@joelfernandes.org,
 tglx@linutronix.de, torvalds@linux-foundation.org,
 kvmarm@lists.cs.columbia.edu
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

On 20/04/20 23:50, Davidlohr Bueso wrote:
> On Mon, 20 Apr 2020, Paolo Bonzini wrote:
> =

>> On 20/04/20 22:56, Davidlohr Bueso wrote:
>>> On Mon, 20 Apr 2020, Marc Zyngier wrote:
>>>
>>>> This looks like a change in the semantics of the tracepoint. Before
>>>> this
>>>> change, 'waited' would have been true if the vcpu waited at all. Here,
>>>> you'd
>>>> have false if it has been interrupted by a signal, even if the vcpu
>>>> has waited
>>>> for a period of time.
>>>
>>> Hmm but sleeps are now uninterruptible as we're using TASK_IDLE.
>>
>> Hold on, does that mean that you can't anymore send a signal in order to
>> kick a thread out of KVM_RUN?=A0 Or am I just misunderstanding?
> =

> Considering that the return value of the interruptible wait is not
> checked, I would not think this breaks KVM_RUN.

What return value?  kvm_vcpu_check_block checks signal_pending, so you
could have a case where the signal is injected but you're not woken up.

Admittedly I am not familiar with how TASK_* work under the hood, but it
does seem to be like that.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
