Return-Path: <SRS0=i7fx=6J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56CC4C55186
	for <kvmarm@archiver.kernel.org>; Sat, 25 Apr 2020 09:26:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C421D2074F
	for <kvmarm@archiver.kernel.org>; Sat, 25 Apr 2020 09:26:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ii2Q4Zvb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C421D2074F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A5344B293;
	Sat, 25 Apr 2020 05:26:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Aqf6kp2WH-kq; Sat, 25 Apr 2020 05:26:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 054CD4B28E;
	Sat, 25 Apr 2020 05:26:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63CB74B287
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Apr 2020 05:26:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V2ObY+ujeBxO for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Apr 2020 05:26:30 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78CEE4B282
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Apr 2020 05:26:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587806790;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=EcIayTYvRSnN3LHp4TWg4vfwCvPsVctRGypt1w6ru+g=;
 b=Ii2Q4ZvbwG1jR2LsrUckfTBdsSRwq4nFcjVvPUSeO7eH1yyKPIo0Ta3AUhkYzdcHEwt1pV
 CcM6fs6cnQUd6mE2mkdYitM6L/PznjyulOIgP6r5R6Emdtn0GwRpINf57lxiKD7wjeOjb1
 8UEwhBz4qu6fUrzDXnRA/UI+j+CnxlA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-_OfRuBl2Ok-rDCzARqYWeg-1; Sat, 25 Apr 2020 05:26:28 -0400
X-MC-Unique: _OfRuBl2Ok-rDCzARqYWeg-1
Received: by mail-wr1-f70.google.com with SMTP id a3so6450476wro.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Apr 2020 02:26:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=EcIayTYvRSnN3LHp4TWg4vfwCvPsVctRGypt1w6ru+g=;
 b=Ny/KEr7nnJHmjKy1mCr/ZpHlDBWeatQ+bJfWXtkTJEhhg7mf2PulHCj7KRH82xB7jI
 HLEltGRFCsFlPIgVr4cYV7EIdA+g2U5DUIDvYc6Y+JDXcTttgThEnV2TYTQKbVxPze8Q
 qFPMHcOn7qVL7M0zdM13V6PUfWIvXo/u2LcllLDiDpGyZUixdRyeQh6zHYcqXjWOuJ3X
 GvPfBhTOQBjaOMhgCVv1zWcSjFa/zSx8KegFX6sY4DkRPFJ3VXAzCSSzZwG+H6qVUfvJ
 kdcWysV4ueCqC+3JNL6ykl5qec7bCZLLIHM8Ij+T5mfa3Vp6M0+c0yIYzdMxvw7kClo2
 vh/Q==
X-Gm-Message-State: AGi0PuZA8D2mNeki2d2sFBTZebE0Lf8d+kU03hLwuHqo6FMsOaBe4s8l
 4vscR66lIhcZtk/SWlecwHuVfVlkWuwAb/n4YeRDgZBVc6zp7mpC86bGe59mvNwDwIKjtcWPJ+p
 hYQG9w58lTlBgP/KDJZBphY8b
X-Received: by 2002:a5d:6148:: with SMTP id y8mr15777245wrt.236.1587806787068; 
 Sat, 25 Apr 2020 02:26:27 -0700 (PDT)
X-Google-Smtp-Source: APiQypJrEPwo8PqkSy+AwbDGziqW7HxlTyJldn8EHJDzRKu+Q7IPdJOabx47EoCj6fSXW6f/LRnEmQ==
X-Received: by 2002:a5d:6148:: with SMTP id y8mr15777218wrt.236.1587806786753; 
 Sat, 25 Apr 2020 02:26:26 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
 by smtp.gmail.com with ESMTPSA id j13sm11628472wro.51.2020.04.25.02.26.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 25 Apr 2020 02:26:26 -0700 (PDT)
Subject: Re: [PATCH v4 1/2] target/arm: kvm: Handle DABT with no valid ISS
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Andrew Jones <drjones@redhat.com>
References: <20200323113227.3169-1-beata.michalska@linaro.org>
 <20200323113227.3169-2-beata.michalska@linaro.org>
 <CAFEAcA_uWS+cVRk=BKra8AhsD+B1syVzhXeCMttSKwQDdo=j3w@mail.gmail.com>
 <20200417131032.lcyunbjwofsn2nzz@kamzik.brq.redhat.com>
 <20200424121633.GF3106@work-vm>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d6f4b17c-1202-3aef-320a-247dc0295277@redhat.com>
Date: Sat, 25 Apr 2020 11:24:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200424121633.GF3106@work-vm>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: quintela@redhat.com, QEMU Developers <qemu-devel@nongnu.org>,
 qemu-arm <qemu-arm@nongnu.org>, kvmarm@lists.cs.columbia.edu
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

On 24/04/20 14:16, Dr. David Alan Gilbert wrote:
>>> I was trying to work out whether we need to migrate this state,
>>> and I'm not sure. Andrew, do you know? I think this comes down
>>> to "at what points in QEMU's kvm run loop can migration kick in",
>>> and specifically if we get a KVM_EXIT_ARM_NISV do we definitely
>>> go round the loop and KVM_RUN again without ever checking
>>> to see if we should do a migration ?
>>>
>> I'd prefer a migration expert confirm this, so I've CC'ed David and Juan,
>> but afaict there's no way to break out of the KVM_RUN loop after a
>> successful (ret=0) call to kvm_arch_handle_exit() until after the next
>> KVM_RUN ioctl. This is because even if migration kicks the vcpus between
>> kvm_arch_handle_exit() and the next run, the signal won't do anything
>> other than prepare the vcpu for an immediate exit.

As far as QEMU is concerned, this should be enough for Beata's patch to
be safe.  If the signal causes KVM to exit before KVM_EXIT_ARM_NISV,
it's of course okay.  If you get a KVM_EXIT_ARM_NISV, however, KVM_RUN
will exit with return code 0 and kvm_cpu_exec will:

- set env->ext_dabt_pending

- go round the loop again

- notice cpu->exit_request and schedule an immediate exit

- call kvm_arch_put_registers

- call KVM_RUN again, which will exit with -EINTR

- exit the loop and allow migration to proceed

However, I'm not sure that it's a good idea to

+        /* Clear instantly if the call was successful */
+        env->ext_dabt_pending = 0;

Rather, this should be done by the next kvm_arch_get_registers when it
calls KVM_GET_VCPU_EVENTS.  It's also possible to add an assertion in
kvm_get_vcpu_events that it you always get zero, to justify that the
field is not migrated.

Thanks,

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
