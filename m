Return-Path: <SRS0=r+CV=5K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03397C54FCF
	for <kvmarm@archiver.kernel.org>; Wed, 25 Mar 2020 17:10:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7A6812077D
	for <kvmarm@archiver.kernel.org>; Wed, 25 Mar 2020 17:10:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dI5HyYSG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A6812077D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EA2C4B09B;
	Wed, 25 Mar 2020 13:10:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h2dp3yU5HdAs; Wed, 25 Mar 2020 13:10:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E8C74B08D;
	Wed, 25 Mar 2020 13:10:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC8B24B086
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2020 13:10:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rax4icmxxZbZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Mar 2020 13:10:01 -0400 (EDT)
Received: from us-smtp-delivery-74.mimecast.com
 (us-smtp-delivery-74.mimecast.com [63.128.21.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A0004A49F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2020 13:10:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585156200;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=vevCBANHYn2Lnc4NylQjd/uYKWuxOb7yWJMgri8X8CA=;
 b=dI5HyYSG8peRvBLcKJE7RvFcKpwoY3IZgL+TsBqmiuOz5oTPm1T0QXIpDNFe9faW3ooHOr
 XZtRpgs9+ZFzITuk1IHestWiJcS91EnxOzvbG7RvhaokYEtluXoeoG0K1WfU86rfSZigtH
 LXTh4swPsjq5bD1s3Ypkvlp3uaOnxbs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-znsO0_HcPGKg2sY_I9mvSw-1; Wed, 25 Mar 2020 13:09:59 -0400
X-MC-Unique: znsO0_HcPGKg2sY_I9mvSw-1
Received: by mail-wr1-f72.google.com with SMTP id o18so1448445wrx.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2020 10:09:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=vevCBANHYn2Lnc4NylQjd/uYKWuxOb7yWJMgri8X8CA=;
 b=XyE4+E2h3UIsjzHTVW4+SRIKSfLvcYAvbpSLmJdlKOa/56Jy3gwW2tuEWJYdpWxH6J
 ulmZOYwsyUbS6s1+iJ7JuyrEdHa/7SQAmfAHMr667AxWtOhduXWHXh6uFeT/Hmyffmqn
 o+TbGeRygCO1r7J9y7CQ0aKDAS83ovRkuje8TojGq5jlJ8gD8Q9p0DxOf5Ainoz/fL8w
 CYvDQcUB8sMBd1XJY0mfCJgg8Gp667NJloOsYtRmidok1k1tWajiVaNnDTHZdvnMwt5b
 Jd/cGZb+I2f11vPAu7h8A2rIV58IW2mGSbfQolcQ3Pn8/Mt9/6Gvke/sCxql56Bj55r1
 Thxg==
X-Gm-Message-State: ANhLgQ1oHx6IN92cCFJ0q8BURJEZyxM+vcE9rg3tdJqrypnQRchY23/i
 4oTgEyw+vJ6cGa8l2cb+X0tPg4AUaUGwQLYPsKRijkuxL8NjseQxmNDFz86PXSyDMVFSGIfsjJm
 rFZ9VAfpmlBvfnpwpp6QGWG8c
X-Received: by 2002:a1c:ab54:: with SMTP id u81mr4174244wme.166.1585156195993; 
 Wed, 25 Mar 2020 10:09:55 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsDeuPAf6z2VeRFRt7ZJYFWF9FC4OwqXVMD3tFXVyspIst/9JsJ8aRkJ29STSyG+27J7ShG6g==
X-Received: by 2002:a1c:ab54:: with SMTP id u81mr4174213wme.166.1585156195636; 
 Wed, 25 Mar 2020 10:09:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e4f4:3c00:2b79:d6dc?
 ([2001:b07:6468:f312:e4f4:3c00:2b79:d6dc])
 by smtp.gmail.com with ESMTPSA id q8sm35205395wrc.8.2020.03.25.10.09.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 25 Mar 2020 10:09:54 -0700 (PDT)
Subject: Re: [PATCH 3/4] kvm: Replace vcpu->swait with rcuwait
To: Davidlohr Bueso <dave@stgolabs.net>, tglx@linutronix.de
References: <20200324044453.15733-1-dave@stgolabs.net>
 <20200324044453.15733-4-dave@stgolabs.net>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a6b23828-aa50-bea0-1d2d-03e2871239d4@redhat.com>
Date: Wed, 25 Mar 2020 18:09:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324044453.15733-4-dave@stgolabs.net>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>, peterz@infradead.org,
 torvalds@linux-foundation.org, bigeasy@linutronix.de,
 linux-kernel@vger.kernel.org, rostedt@goodmis.org, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, joel@joelfernandes.org, will@kernel.org,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 24/03/20 05:44, Davidlohr Bueso wrote:
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 71244bf87c3a..e049fcb3dffb 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -290,8 +290,7 @@ static enum hrtimer_restart kvm_mips_comparecount_wakeup(struct hrtimer *timer)
>  	kvm_mips_callbacks->queue_timer_int(vcpu);
>  
>  	vcpu->arch.wait = 0;
> -	if (swq_has_sleeper(&vcpu->wq))
> -		swake_up_one(&vcpu->wq);
> +	rcuwait_wake_up(&vcpu->wait)

This is missing a semicolon.  (KVM MIPS is known not to compile and will
be changed to "depends on BROKEN" in 5.7).

Paolo

>  	return kvm_mips_count_timeout(vcpu);

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
