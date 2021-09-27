Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2FBC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 15:16:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A10D0610A2
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 15:16:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A10D0610A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0B284B0C0;
	Mon, 27 Sep 2021 11:16:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6VSz3PwnCkL9; Mon, 27 Sep 2021 11:16:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3BE44B091;
	Mon, 27 Sep 2021 11:16:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D55994B086
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 11:16:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hARFOC83DUrC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 11:15:59 -0400 (EDT)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D31E0406E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 11:15:59 -0400 (EDT)
Received: by mail-pj1-f45.google.com with SMTP id h12so2322093pjj.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 08:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=J1aK1o24WWHw6k8idRjv4JjH9S5sZVXgl07HpLc8Nnw=;
 b=bQHxGWLkKAFfWjndxT1kv2LbZGzPIP4GMYqRTXgFhjFtycMwHf7oDbkLslbtR4pYd8
 yoFlCQc2ltGwam4vhlmoS3oimleu3pwe0TB2wEbQSMXNmcuSL2fEXMGKRR6VGAEKa+zx
 uBEyDrGhON68VlaGnkxqoD7VEINLMPpIUFZaO91NQhTftbZgCwvv8fSwFTGkn60+vb7M
 tzXRg07NdSFlGR9MnkHpbvjCWdgeDDxSzPrXKbohkx6P3LAtIvvQcCO2/whyo9eVK5YX
 lBKDG/n38SBu32xRrec0Hya+F6UV+98jAPrLz4eDF/C+dn9e2QJw1OXHZ3z9XcorwHMQ
 JAPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=J1aK1o24WWHw6k8idRjv4JjH9S5sZVXgl07HpLc8Nnw=;
 b=y43rdMsPPKVRkMQOz+BvUc+VKqL0iOdS9LXa4P6dP4B6WOFhdp1splQxAClM+ZHp/z
 HtArldi9BdWnh/DeyRL/kT3Nd7Z8KZQm1RcCjGKO0PYlTGaXW7ABgYmXWb8WKZ4CTdHe
 5+sJVfMtFlgChMf1iqLFlReaXGeNGCTaFN/uh/Xxh/qV9PzrVKc3eSvhfuBdBImsakhr
 XxJ6yydgi+XP5tgZa6BRSSNPxxzNW4uUdW8wYX0QGJ1eH4d4+KYyr8bwKs87x58TAJqL
 vGAHqact+vqSP1uqXcVRJMlB0+kCZ5GGbzUxBD2QyekQz+Nc6YuL/GiM8d4qPDyt4TAT
 z+4g==
X-Gm-Message-State: AOAM530PEDCahI/e9ruIq2slLOSlwS/TH/BPCHqeMffQyA1e4YYg+N5i
 VqPvf69xbQcMBJr4edTz/b8dNQ==
X-Google-Smtp-Source: ABdhPJyA6ONhd1Ga93hKwsqmjOKuFVk7/BNXzU8fonL5kd5O9SJ41kUDv10GPB3TNvNBUBEzEJ7IZA==
X-Received: by 2002:a17:90a:4207:: with SMTP id
 o7mr523060pjg.192.1632755758626; 
 Mon, 27 Sep 2021 08:15:58 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id r23sm20063784pjo.3.2021.09.27.08.15.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Sep 2021 08:15:57 -0700 (PDT)
Date: Mon, 27 Sep 2021 15:15:53 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: disabling halt polling broken? (was Re: [PATCH 00/14] KVM:
 Halt-polling fixes, cleanups and a new stat)
Message-ID: <YVHgKWiU9WWL9ACg@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com>
 <YVHcY6y1GmvGJnMg@google.com>
 <f37ab68c-61ce-b6fb-7a49-831bacfc7424@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f37ab68c-61ce-b6fb-7a49-831bacfc7424@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Jon Cargille <jcargill@google.com>, kvm-ppc@vger.kernel.org,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Sep 27, 2021, Paolo Bonzini wrote:
> On 27/09/21 16:59, Sean Christopherson wrote:
> > > commit acd05785e48c01edb2c4f4d014d28478b5f19fb5
> > > Author:     David Matlack<dmatlack@google.com>
> > > AuthorDate: Fri Apr 17 15:14:46 2020 -0700
> > > Commit:     Paolo Bonzini<pbonzini@redhat.com>
> > > CommitDate: Fri Apr 24 12:53:17 2020 -0400
> > > 
> > >      kvm: add capability for halt polling
> > > 
> > > broke the possibility for an admin to disable halt polling for already running KVM guests.
> > > In past times doing
> > > echo 0 > /sys/module/kvm/parameters/halt_poll_ns
> > > 
> > > stopped polling system wide.
> > > Now all KVM guests will use the halt_poll_ns value that was active during
> > > startup - even those that do not use KVM_CAP_HALT_POLL.
> > > 
> > > I guess this was not intended?
> 
> No, but...
> 
> > I would go so far as to say that halt_poll_ns should be a hard limit on
> > the capability
> 
> ... this would not be a good idea I think.  Anything that wants to do a lot
> of polling can just do "for (;;)".

Hmm, true, there is no danger to the system in having the capability override the
module param.

> So I think there are two possibilities that makes sense:
> 
> * track what is using KVM_CAP_HALT_POLL, and make writes to halt_poll_ns
> follow that

I think this option makes more sense, making halt_poll_ns read-only is basically
forcing users to switch to KVM_CAP_HALT_POLL.

> * just make halt_poll_ns read-only.
> 
> Paolo
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
