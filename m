Return-Path: <SRS0=QomF=6E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68FC9C54FD0
	for <kvmarm@archiver.kernel.org>; Mon, 20 Apr 2020 21:04:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DD2002078C
	for <kvmarm@archiver.kernel.org>; Mon, 20 Apr 2020 21:04:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gekU46IF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD2002078C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B8734B175;
	Mon, 20 Apr 2020 17:04:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VQgtEvkPAQ9W; Mon, 20 Apr 2020 17:04:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 748B14B158;
	Mon, 20 Apr 2020 17:04:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F44B4B139
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2020 17:04:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FHV4YWpjLvFR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Apr 2020 17:04:46 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 614354B130
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2020 17:04:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587416685;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=el4OTjYf5mEySshudgJWDWTRuJmOvD4sG0r7YGx0AyM=;
 b=gekU46IFWfZ4L8PuXfRgIdXjW603HxxLC6JtcOzfKhSNUvfcJBXwh/O1kymwvXFgaDdXk5
 iDBxR0P+pNUokS+vqNMiztGWta9gQQcfB0YHDa3HwlpOubRqL+RdSbXb587BSSaVotttcf
 4SKbZBZZbGyovYrZVkLdZy6RwME4wA0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-Bbrbmi0WO8uQnXOkJS-xCQ-1; Mon, 20 Apr 2020 17:04:42 -0400
X-MC-Unique: Bbrbmi0WO8uQnXOkJS-xCQ-1
Received: by mail-wr1-f72.google.com with SMTP id e5so6350544wrs.23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2020 14:04:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=el4OTjYf5mEySshudgJWDWTRuJmOvD4sG0r7YGx0AyM=;
 b=RRvdM8aiBoVJZwj/JF0brV2mUDj6rNr5O+JmLtLm9F0nT0Uh74wyXhLKh4d9u+Rndp
 f3iR4xYuDT6ttvuDH+QWdLlvVOH6SY0MUP8rF4ncKfr4ua62yQlSFThc+AHVsIlfj7ae
 9jHFEc4EYXdu0NyLY+6wA+uUP702vYTy/e8K6LECpzKQ1HXtw6Fea91rRXSjLXvddKjZ
 jRKoYP5FWrDWqfEJhWfmkQjtR4Yts7HKCpNdCcropdfHBOL2Vm0A70PLA9oLg6yDSbDc
 3Kmv0/Oo5dCGKJtJ8krsbuJLL/+xSN8ZcGlD0VpKnyc6mWKZLYIg//jshpONtapMOk5m
 WgIA==
X-Gm-Message-State: AGi0PuZ7zHJUX6qUTI+Lbgkcb9Z7ISSNrQoZdleaqcESgmh0EJAVfHAo
 lBMUDJSy2PdwI/Q0Fkd1LHBj9LcRrgXHvyLayfL+T+LRYyZfUDEz8OBajoAJXzO7M+tvG5KVyau
 1AfMNlumnYZblpsN3pxM4yu6U
X-Received: by 2002:a05:600c:2c0f:: with SMTP id
 q15mr1372501wmg.185.1587416679646; 
 Mon, 20 Apr 2020 14:04:39 -0700 (PDT)
X-Google-Smtp-Source: APiQypLCHmby4MneKzzDfoFddn0WzGOWW+JhFqcNNGOFAialDolkEgs5MBOpolhNVZ8zYuGZUO7k8A==
X-Received: by 2002:a05:600c:2c0f:: with SMTP id
 q15mr1372470wmg.185.1587416679373; 
 Mon, 20 Apr 2020 14:04:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5c18:5523:c13e:fa9f?
 ([2001:b07:6468:f312:5c18:5523:c13e:fa9f])
 by smtp.gmail.com with ESMTPSA id a20sm944701wra.26.2020.04.20.14.04.37
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 20 Apr 2020 14:04:38 -0700 (PDT)
Subject: Re: [PATCH v2] kvm: Replace vcpu->swait with rcuwait
To: Davidlohr Bueso <dave@stgolabs.net>, Marc Zyngier <maz@kernel.org>
References: <20200324044453.15733-1-dave@stgolabs.net>
 <20200324044453.15733-4-dave@stgolabs.net>
 <20200420164132.tjzk5ebx35m66yce@linux-p48b>
 <418acdb5001a9ae836095b7187338085@misterjones.org>
 <20200420205641.6sgsllj6pmsnwrvp@linux-p48b>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f7cc83fe-3e91-0057-9af2-26c201456689@redhat.com>
Date: Mon, 20 Apr 2020 23:04:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200420205641.6sgsllj6pmsnwrvp@linux-p48b>
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

On 20/04/20 22:56, Davidlohr Bueso wrote:
> On Mon, 20 Apr 2020, Marc Zyngier wrote:
> 
>> This looks like a change in the semantics of the tracepoint. Before this
>> change, 'waited' would have been true if the vcpu waited at all. Here,
>> you'd
>> have false if it has been interrupted by a signal, even if the vcpu
>> has waited
>> for a period of time.
> 
> Hmm but sleeps are now uninterruptible as we're using TASK_IDLE.

Hold on, does that mean that you can't anymore send a signal in order to
kick a thread out of KVM_RUN?  Or am I just misunderstanding?

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
