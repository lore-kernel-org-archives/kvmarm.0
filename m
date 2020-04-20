Return-Path: <SRS0=QomF=6E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA78FC3815B
	for <kvmarm@archiver.kernel.org>; Mon, 20 Apr 2020 17:25:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3077F2078C
	for <kvmarm@archiver.kernel.org>; Mon, 20 Apr 2020 17:25:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YlT7IHYd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3077F2078C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F3074B11F;
	Mon, 20 Apr 2020 13:25:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dlrcNGRe2rD1; Mon, 20 Apr 2020 13:25:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A18674B136;
	Mon, 20 Apr 2020 13:25:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E5BE4B11F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2020 13:25:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3HjEYzku97YB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Apr 2020 13:25:35 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 372A84B118
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2020 13:25:35 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587403535;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5zFau9oVnCy2aNDs2gF30gGKofVM+mf7Njlmsy7kpl8=;
 b=YlT7IHYdQfA3bvM0WSqEBDMX3cNFnc6dvck77nRNV5fupThoYNkus+NwNIp990xwOUNqcb
 ReajhmzFPfwDyEGkhmKPV5ii2buR4ICukPOIkfQq5jT9hBwCX48DQBR7xWT7/Sa5FhOcSM
 4YVz0BO8s3UXu5lr7pEK2i+yLM8ayTc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-0mpgg4BiPfywQavySsu77Q-1; Mon, 20 Apr 2020 13:25:31 -0400
X-MC-Unique: 0mpgg4BiPfywQavySsu77Q-1
Received: by mail-wm1-f69.google.com with SMTP id 71so129139wmb.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2020 10:25:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=4Wi4I6E0HOoTIiwC/qCL3vbIOZi357RgujrqauiVCgo=;
 b=sntzZtRc3GT3CLFppPochUlmaNGmYyBPGXQ/GUJBx8OnhXSSd7+6U7OzmruVtSvd7j
 4c4bS9Mm/IbYDTRMPAkZDFUQeXIzvDtqrXiMyDcPvqLvImV2Suewual2ZwrmDDTg8DMV
 FW62F6FBFIKyk09IQQL5tF9LwmiI1h6/B4GNx9M3B9R4mrXNLEoCtVRUxTNxW4Bcas+e
 cLY+R/U6vQdr9SizTzEHsRRQdB6jTXpPg/drtMfYE7Whs9XI5Sw6dLkrP4OeDVIOANdX
 0k2TeVQXZanzslZjEQ/2+CtVPm/jcRcP6Lgna63oCwptHd8C9NEKEWaoeJmryU7dJ+ga
 nojw==
X-Gm-Message-State: AGi0PuZU5FSHXApZYxW469bf/+jN3zHwqugSX70igOTg+yJS6UrWlst6
 auwSRwk7t9HTm+QLXUwKZLeXwD020UlbNI4GFw6V7kXZHRLVIRbuu4xT3k4o4kjfer3PT0f78oI
 9wc5IXlvudSSNF1b6U6dsY1po
X-Received: by 2002:adf:c109:: with SMTP id r9mr19678381wre.265.1587403530025; 
 Mon, 20 Apr 2020 10:25:30 -0700 (PDT)
X-Google-Smtp-Source: APiQypLifiyD2rISqsBTFDUXYG+CQzr+z4iBiqXWbcljpUFDAk2pWd1/77hoQLgJWF6OMqcIiIWbgw==
X-Received: by 2002:adf:c109:: with SMTP id r9mr19678363wre.265.1587403529829; 
 Mon, 20 Apr 2020 10:25:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:199a:e5ab:a38c:544c?
 ([2001:b07:6468:f312:199a:e5ab:a38c:544c])
 by smtp.gmail.com with ESMTPSA id h2sm240458wro.9.2020.04.20.10.25.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 20 Apr 2020 10:25:29 -0700 (PDT)
Subject: Re: [PATCH v2] kvm: Replace vcpu->swait with rcuwait
To: Marc Zyngier <maz@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>
References: <20200324044453.15733-1-dave@stgolabs.net>
 <20200324044453.15733-4-dave@stgolabs.net>
 <20200420164132.tjzk5ebx35m66yce@linux-p48b>
 <418acdb5001a9ae836095b7187338085@misterjones.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <22800f1b-3bdb-15b4-7592-93a7b244b45a@redhat.com>
Date: Mon, 20 Apr 2020 19:25:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <418acdb5001a9ae836095b7187338085@misterjones.org>
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
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 20/04/20 19:12, Marc Zyngier wrote:
>>
>>
>> -=A0=A0=A0 trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcp=
u));
>> +=A0=A0=A0 trace_kvm_vcpu_wakeup(block_ns, !block_check,
>> vcpu_valid_wakeup(vcpu));
> =

> This looks like a change in the semantics of the tracepoint. Before
> this change, 'waited' would have been true if the vcpu waited at all.
> Here, you'd have false if it has been interrupted by a signal, even
> if the vcpu has waited for a period of time.
True, good catch.  Perhaps add macros prepare_to_rcuwait and
finish_rcuwait?

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
