Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD95DC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 11:44:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 354EB6139E
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 11:44:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 354EB6139E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0C594B273;
	Mon,  4 Oct 2021 07:44:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j+964Z9fqbkg; Mon,  4 Oct 2021 07:44:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A50544B260;
	Mon,  4 Oct 2021 07:44:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9A184B216
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 07:44:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cUPmDRqAPg5b for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 07:44:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E203F4B1F0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 07:44:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633347879;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=GTIIQiwexuN1RAdzEPgfC+3jBs1EDWZPLEcgd8QeZcU=;
 b=Iwj57JAN+ZtEu4OSWQOMq3eJNWoHLHfQM0IJcu2WvDZwoOROQwXBH0HdC9jB/Vreo+Rrw8
 4lqUK6KiY7CXzdEmO3mP4Zpvash6vNMYgM0GxY+PXFI+fevc4IfGUyZOcdrkKcMfOfALdy
 JYiUOlSujnvsOkEYjYH1daoOaW8GKGM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-JkFPgEqVO5OSVdapJ95xzg-1; Mon, 04 Oct 2021 07:44:38 -0400
X-MC-Unique: JkFPgEqVO5OSVdapJ95xzg-1
Received: by mail-ed1-f69.google.com with SMTP id
 c7-20020a05640227c700b003d27f41f1d4so16871617ede.16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 04:44:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=GTIIQiwexuN1RAdzEPgfC+3jBs1EDWZPLEcgd8QeZcU=;
 b=lO4B3KJSk4SN40f3JEmy0owebfH377rut5qOHARA2B0mK0Fok9p3Boxz9hoONAdT8s
 1djYgw9J+Zl983l8W4nUHE6HTT4Czq0Y/S4fg0QFagUcZCqGfDJCnUzDt704JZKbVgqu
 k7Ra2YQT98X2HiXrzELbwr3s/3vZBc4igcXOz5oXZt1VJ6LYQL3lR5norXshyAtWhlOJ
 1YHyPwJQR68tDYKWiDFLClwWC8ih5tOij+LCkSPraWHbTlB+O9i0TqmMKM/alROUJMw1
 ygTyVy7Rhk9H0/FnV40jBbT8BNcdvowuwyt8tTOPSIroOtwsIlPBYmXu0Rp75nVg0qBu
 qffQ==
X-Gm-Message-State: AOAM531+tylckAVk2LqJrKQzPmla2kCUt2PCXmAQxL2kiebSWqGN+h6D
 FFnm1+Jd4qP/LMCQAZWdNb/itjEy5VLTrrjrdl0yFx2HSJ1yLnOgqfHrXxdc8cg27Ix8G6Hz/l2
 ef737Rfbtse0p4EI+AuYzizaE
X-Received: by 2002:a17:906:e85:: with SMTP id
 p5mr16759555ejf.159.1633347877513; 
 Mon, 04 Oct 2021 04:44:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDeQKGDooaTNNGCBgf5hxRexDWyP01P+aRkP4Sg07t5/j6jHx/UP99CoVqUE4SEK2W0rQKSg==
X-Received: by 2002:a17:906:e85:: with SMTP id
 p5mr16759518ejf.159.1633347877279; 
 Mon, 04 Oct 2021 04:44:37 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id b5sm7125953edu.13.2021.10.04.04.44.35
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 04 Oct 2021 04:44:36 -0700 (PDT)
Message-ID: <89b4ab4e-c443-2b14-e878-8c04d066f5b0@redhat.com>
Date: Mon, 4 Oct 2021 13:44:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v8 7/7] KVM: x86: Expose TSC offset controls to userspace
To: Marcelo Tosatti <mtosatti@redhat.com>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-8-oupton@google.com>
 <20210930191416.GA19068@fuller.cnet>
 <48151d08-ee29-2b98-b6e1-f3c8a1ff26bc@redhat.com>
 <20211001103200.GA39746@fuller.cnet>
 <7901cb84-052d-92b6-1e6a-028396c2c691@redhat.com>
 <20211001191117.GA69579@fuller.cnet>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211001191117.GA69579@fuller.cnet>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Peter Shier <pshier@google.com>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On 01/10/21 21:11, Marcelo Tosatti wrote:
> That said, the point is: why not advance the_TSC_  values
> (instead of kvmclock nanoseconds), as doing so would reduce
> the "the CLOCK_REALTIME delay which is introduced during migration"
> for both kvmclock users and modern tsc clocksource users.

It already does, that's the cool part.  Take again the formula here:

    guest_off_1 = t_0 + guest_off_0 + (k_1 - k_0) * freq - t_1

and set:

	t_1 = t_0 + host_off_0_1 + (k_1 - k_0) * freq

i.e. t_0 and t_1 are different because 1) the machines were booted at 
different times, which is host_off_0_1 2) t_1 includes the migration 
downtime between k_0 and k_1

Now you have:

    guest_off_1 = t_0 + guest_off_0 + (k_1 - k_0) * freq
	       - t_0 - real_off_n - (k_1 - k_0) * freq

    guest_off_1 = guest_off_0 - host_off_0_1

That is, the TSC is exactly the same as it was on the source, just 
adjusted because the two machines were booted at different times.

The need to have precise (ns, cycle) pairings is exactly because it 
ensures that everything cancels in the formula, and all that is left is 
the differences in the TSC of the two hosts.

Paolo

> So yes, i also like this patchset, but would like it even more
> if it fixed the case above as well (and not sure whether adding
> the migration delta to KVMCLOCK makes it harder to fix TSC case
> later).

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
