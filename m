Return-Path: <SRS0=ypkC=LK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A70D5C48BE8
	for <kvmarm@archiver.kernel.org>; Wed, 16 Jun 2021 19:45:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C58261351
	for <kvmarm@archiver.kernel.org>; Wed, 16 Jun 2021 19:45:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C58261351
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BC5F4AEDC;
	Wed, 16 Jun 2021 15:45:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OtJ8Wm11O73w; Wed, 16 Jun 2021 15:45:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68F6549F6C;
	Wed, 16 Jun 2021 15:45:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 990E449F6C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jun 2021 15:45:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GxBtwL2Qdic4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Jun 2021 15:45:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8751340874
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jun 2021 15:45:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623872707;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=+QNVwJfqsz7DuF9a+ahjJykVrEv0cF3FdHRVfv7uhlg=;
 b=ZcRtJiJQiZjdpORy+RGO5g8A8pVV+BzXXdQCf2IvqFYCVspeLmtK2YPULx5qG1DW+10p8R
 Cz4X29DNS4S5iBdStfeQRYdN37yCdl+mskDhAOu85UoCBnFq8u/jpgCmcr1xw3JryPkmdt
 oxQS1dGUV5CD6VOTGqgCYsOO9ZxRZ7Y=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-8WSvyyu3OQ2w6JfU4Cxx5A-1; Wed, 16 Jun 2021 15:45:06 -0400
X-MC-Unique: 8WSvyyu3OQ2w6JfU4Cxx5A-1
Received: by mail-ed1-f72.google.com with SMTP id
 a16-20020aa7cf100000b0290391819a774aso260413edy.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jun 2021 12:45:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=+QNVwJfqsz7DuF9a+ahjJykVrEv0cF3FdHRVfv7uhlg=;
 b=fc01//CjP7mBUK6bwrT6ZwYhVwUl1jXo2CZ/LaXHYn7rnSQx0r3rck+tRrZIxNHsLn
 F+vep72aeRCotC9ase/35JueNdk3T64KkHCT7DFcsRxNrx4z8J8oUKONppIm7ROIhiS4
 ho2y2hmZMjR1UVbwVYCKBod/5bwI2iA86qKClGi4WnnibD4siG61BTXKbcX/XKkhgTdp
 93ad3fjPcT/zpPYD4PPn8u3lGe+rvtpKXa/dob1xQtoLYzm41Y/98e+F9rv/WlKpVTMR
 le2N6OEcLZKhKcXcfci1Fx9Qy68YK0eySYEb1HiJCsB7Mr7XZoif7qkG1mIoasMgtt4P
 qocA==
X-Gm-Message-State: AOAM5316AixmmCGNoNq27ojFBrTZpqO5WVDl4JcRQZdNciGEDJlF81R/
 J6sa2VQpHcuaz5KLM+L5ciRVR0k5OS+yoCvRTCKMRUAa9CM6zzR82ON+D3eSMtr2o3ht5el3Qsi
 C/zfaSkTgqyMKvVahUiX/lOG5
X-Received: by 2002:a17:907:6fd:: with SMTP id
 yh29mr1241071ejb.432.1623872704923; 
 Wed, 16 Jun 2021 12:45:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4XKHV98pEZbROOGkCOI5giEsQGV4xvXa4BnXoBwGpr7AA8qMDKS7AagRuHdxurUSpCqNENg==
X-Received: by 2002:a17:907:6fd:: with SMTP id
 yh29mr1241026ejb.432.1623872704577; 
 Wed, 16 Jun 2021 12:45:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id m22sm233740ejn.50.2021.06.16.12.45.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 16 Jun 2021 12:45:03 -0700 (PDT)
To: Greg KH <gregkh@linuxfoundation.org>
References: <20210614212155.1670777-1-jingzhangos@google.com>
 <20210614212155.1670777-4-jingzhangos@google.com>
 <YMoW7SBqO9EPgCXw@kroah.com>
 <9b9a951d-d020-5599-5c4f-e154b40522b9@redhat.com>
 <YMpAcaqjk4ZN90gj@kroah.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v9 3/5] KVM: stats: Add documentation for statistics data
 binary interface
Message-ID: <56cbf176-4b89-fe52-1c84-56468b932cc8@redhat.com>
Date: Wed, 16 Jun 2021 21:45:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMpAcaqjk4ZN90gj@kroah.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 David Matlack <dmatlack@google.com>, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, LinuxMIPS <linux-mips@vger.kernel.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On 16/06/21 20:18, Greg KH wrote:
> On Wed, Jun 16, 2021 at 06:59:15PM +0200, Paolo Bonzini wrote:
>> - varlink structs are encoded as JSON dictionaries.  Therefore, every time
>> userspace reads the fields, the kernel has to include the field names as
>> JSON dictionary keys.  This means that a lot of time is spent writing
>> buffers, and on the receiving side parsing them.
> 
> Has this been measured?  Years ago when I messed with this, it was in
> the noise as JSON parsing is really fast these days.

Yes, parsing is really fast.  However, the work doesn't end at building 
an in-memory representation.  An efficient representation (and a schema 
that is negotiated in advance) makes it possible to do this work as late 
and as little as possible, instead of doing it on every fetch of the 
statistics.

For cloud vendors running virtual machines, they want to consolidate 
housekeeping tasks on as few CPUs as possible (because housekeeping CPUs 
cannot be billed to the customers), and every millisecond really counts.
ASCII is inviting, but things like Protobufs, FlatBuffers, Cap'n'Proto 
are all binary because all those hidden costs do exist.

>> - because numeric data has to be converted to ASCII the output doesn't have
>> fixed offsets, so it is not possible to make an efficient implementation of
>> pread.
> 
> efficient where?  In the kernel?

Yes, Jing's patches can just do a quick copy_to_user if pread does not 
access the schema.  And it's very simple code too.

>> - even though Varlink specifies that int is "usually int64", a little-known
>> gem is that JSON behavior for numbers not representable as a double (i.e.
>> exceeding 2^53) is implementation-defined
> 
> That's interesting, do the varlink developers know this?  And we can say
> "for the kernel int will be int64" and be done with it, so this
> shouldn't be that big of an issue.

Well yeah, but there's still the problem of what the other side thinks. 
  In the end varlink's interesting because it's just JSON, meaning 
there's plenty of parsers available---but they all too often don't 
separate int vs. double.  We had this issue with projects talking to 
QEMU (which has been using JSON the same way as varlink for ten years or 
so) and JSON parsers returning an overflow for 2^64-1 (because it rounds 
to 2^64) or an incorrect value.  I'm not saying it's a showstopper, it's 
just an unavoidable ugliness if you pick JSON.

>> For the schema, there are some specific problems with varlink, but also a
>> more generic issue.  The specific problems are:
>>
>> - the schema doesn't include the length of arrays.  This makes it hard to
>> compute in advance lengths and offsets of fields (even ignoring the fact
>> that data is not binary, which I'll get to later)
> 
> Do you care in advance?

Yes, once we add for example histograms we would like to include in the 
schema the size and number of the buckets.

> Again, I didn't think this was an issue with the kernel implementation
> in that the userspace side could determine the schema by the data coming
> from the kernel, it wouldn't have to "know" about it ahead of time.
> But I could be wrong.

No, you're right.  The C implementations are really just very thin 
wrappers over JSON.  There's very little "Varlink"ness in them.

However the interesting part of the schema are the metadata--the unit, 
whether something is an instant vs. a cumulative value, the bucket size 
when we add histograms.  These things are obviously not included in the 
data and must be communicated separately.  Userspace tools could also 
use a schema to validate user requests ("record the halt_poll_fail_ns 
every second").

>> All that said, what we _could_ do is serialize the schema as JSON
>> instead of using a binary format
> 
> It should be in some standard format. If not, and it sounds like you
> have looked into it, or at least the  userspace side, then that's fine.
> But you should write up a justification somewhere why you didn't use an
> existing format (what about the netlink format?)

I guess you're talking about NETLINK_GENERIC, that also has the issue 
that the schema (the attributes) is not dynamic but rather part of the 
uAPI.  We explicitly don't want them to be stable, they're like 
tracepoints in that respect and that's why we took ideas from trace-cmd. 
  Anyway, as a start Jing will summarize all these discussions in v10.

Thanks,

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
