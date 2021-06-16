Return-Path: <SRS0=ypkC=LK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB918C48BE6
	for <kvmarm@archiver.kernel.org>; Wed, 16 Jun 2021 16:59:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6B037613B9
	for <kvmarm@archiver.kernel.org>; Wed, 16 Jun 2021 16:59:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B037613B9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBAAF4B08E;
	Wed, 16 Jun 2021 12:59:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tDoOzJJikozf; Wed, 16 Jun 2021 12:59:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 878B949F82;
	Wed, 16 Jun 2021 12:59:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 040A34048A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jun 2021 12:59:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5Ne9NOmP+87C for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Jun 2021 12:59:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4B03402DB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jun 2021 12:59:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623862761;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=CSaKm7Um2oPV0vgrRNxfNZveJ3Fyoig0t9ydKjDoicw=;
 b=VEa9EgL8Gvq/Q+pi59nGrDPLgwKlEYCN8XH92OH1lcsvcJ/8JmDHGa8d2hr2yn74df7JDH
 Wx5qsrfa7kgZKGRT7dTJCZ4sQCbrU7xFzV0qPasHeMW7ZJMMWiLIEoLOMrpQ4DuHoO21rJ
 PlRwSgCtC8RbTHT2tsQLXeQk4GfVpuE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-FYx8KM0qPXaZmGzD1lY-gQ-1; Wed, 16 Jun 2021 12:59:20 -0400
X-MC-Unique: FYx8KM0qPXaZmGzD1lY-gQ-1
Received: by mail-ed1-f69.google.com with SMTP id
 dd28-20020a056402313cb029038fc9850034so29098edb.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jun 2021 09:59:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=CSaKm7Um2oPV0vgrRNxfNZveJ3Fyoig0t9ydKjDoicw=;
 b=UNmNifoOr95sENqvE5ycPiBKF7fa1RY5As6h6PxPuTeipacPQQEYex57qBQ3bdZn3O
 76c0eLJ3aItv2V8ebV3gqdRXPNzotgAylBmKbvZkuhz9421OmhHxsdSXF9cBKboJ0JLX
 9xqoC3QJHYNQWmVZTtahMV4sWK0KNESPVaXak7wmdZV9LYo0uoDNYVZ5NByx4c/Vtpyv
 zo3vLm9UrV8Raj+bik/GhGyYjF2++qKV02KJCtKzdBvxdHJWa2HY+L3K1KnlDhSKTm0Q
 RQ2psln50oek53brKEQD/n2KvNHz44+i/sVGi9cXo4RCM83UYa5N2m8fkcWBcV1Q7wuP
 FqjQ==
X-Gm-Message-State: AOAM531V5i+kwWfWTovxM27VsilTpJiu84tvpgxg0eo+lppJX+kKdOWG
 Z3Ftrl1FogHbecJfj1nu/klc9mhhp1qbl14BVL0Mny2ht/T0ehQQWpBtIrDTnIdEnMv/Qdjg9/u
 8RuibcQlgf3pV7f0bLiu+CYT+
X-Received: by 2002:a17:906:5053:: with SMTP id
 e19mr483655ejk.251.1623862759116; 
 Wed, 16 Jun 2021 09:59:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6Emn8wPqyvgKohGYGtUKYf4y4jrRKJJ2HFHwhTepqW0F8ugL/e9E7NezRGCz6vjrObsyEOg==
X-Received: by 2002:a17:906:5053:: with SMTP id
 e19mr483616ejk.251.1623862758801; 
 Wed, 16 Jun 2021 09:59:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id a3sm2208828edu.61.2021.06.16.09.59.16
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 16 Jun 2021 09:59:17 -0700 (PDT)
To: Greg KH <gregkh@linuxfoundation.org>, Jing Zhang <jingzhangos@google.com>
References: <20210614212155.1670777-1-jingzhangos@google.com>
 <20210614212155.1670777-4-jingzhangos@google.com>
 <YMoW7SBqO9EPgCXw@kroah.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v9 3/5] KVM: stats: Add documentation for statistics data
 binary interface
Message-ID: <9b9a951d-d020-5599-5c4f-e154b40522b9@redhat.com>
Date: Wed, 16 Jun 2021 18:59:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMoW7SBqO9EPgCXw@kroah.com>
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

On 16/06/21 17:21, Greg KH wrote:
> I forgot to comment on this one, sorry for the delay.
> 
> Why are you "inventing" your own schema format here for this?  Why not
> use a well-known or at least well-designed/implemented one that we have
> in userspace already?
> 
> There are a few that I would love to see in the kernel, varlink being
> the best example.  We have kernel examples of this and I would consider
> using that as a transport for sysfs-like data in the future, but never
> got around to it.

Thanks, that's a good observation, and it's a problem that the rationale 
and the design process didn't end up in either the documentation or the 
commit message (only the outcome did).  In order to fix that, this is 
going to be quite a long message.

Varlink comprises both a schema and an encoding, and each has its own 
problems.  For the encoding of the data, varlink is really just using 
JSON and it is really just the wrong tool here.  The first few problems 
that come to mind are:

- varlink structs are encoded as JSON dictionaries.  Therefore, every 
time userspace reads the fields, the kernel has to include the field 
names as JSON dictionary keys.  This means that a lot of time is spent 
writing buffers, and on the receiving side parsing them.

- because numeric data has to be converted to ASCII the output doesn't 
have fixed offsets, so it is not possible to make an efficient 
implementation of pread.

- even though Varlink specifies that int is "usually int64", a 
little-known gem is that JSON behavior for numbers not representable as 
a double (i.e. exceeding 2^53) is implementation-defined; 
implementations can and will mess up values outside that range.  This 
problem is not specific to this KVM stats usecase; varlink's schema 
specification really is at odds with its encoding specification.


For the schema, there are some specific problems with varlink, but also 
a more generic issue.  The specific problems are:

- the schema doesn't include the length of arrays.  This makes it hard 
to compute in advance lengths and offsets of fields (even ignoring the 
fact that data is not binary, which I'll get to later)

- the schema also is not extensible with user annotations.  In our case 
that would be mostly the unit in which the value is expressed.

The main problem with the various available serialization formats is 
that their schema languages are designed to be compiled with a code 
generator.  Here instead the schema is transmitted from the kernel to 
userspace.  Userspace is not really supposed to know what a value means 
or even that if it exists.  Userspace takes care of collecting the data 
from the kernel, but ultimately there will be a human that knows what 
e.g. "io_exits" or "req_event" means, and they will ask for the current 
value, or a plot over time, of a specific statistic.

Now, unlike most other schema languages, varlink does not require 
precompiling the schema in its C bindings.  However, this was mostly 
just the authors not bothering to write a C code generator---they did 
write one for Rust, for example.  When using the "official" varlink C 
bindings, you hardly use the schema at all.

Something similar to the above issues is quite common in other formats. 
  For example, FlatBuffers[2]'s schema language[1] does have annotations 
(which it calls metadata), but then we would still have to invent some 
standard annotations and teach programs about them.  However, the deal 
breaker is that again there is no way to transmit the schema from the 
server to the client, and that users are supposed to precompile the 
schema using a code generator.


All that said, what we _could_ do is serialize the schema as JSON 
instead of using a binary format, like so:

   [{
     "name": "exits",
     "kind": "cumulative",
     "count": 1
   }, {
     "name": "halt_poll_fail_ns",
     "kind": "cumulative",
     "unit": "seconds",
     "scale": {"base": "pow2", exponent: -9},
     "count": 1
   }, ...]

while keeping the actual statistics as an array of u64 values just like 
in these patches.  The JSON representation of the schema would be always 
the same, so it could be treated as fixed-size and an efficient 
implementation of pread would be possible.  And once the schema is JSON, 
there could be a *meta*-schema expressed using the varlink language:

   # compare to struct kvm_stats_desc, included after my sig
   # for reference
   type StatsDescriptor {
     name: string,
     kind: (cumulative, instant, peak),
     unit: ?(bytes, seconds, cycles),
     scale: ?(base: (pow2, pow10), exponent: int),
     count: int
   }

   type StatsSchema {
     name: string,
     stats: []StatsDescriptor
   }

Varlink would *not* be used in the kernel, because Varlink isreally 
just JSON.  The above ten lines (plus comments) would be dropped in 
Documentation/ as a .varlink file; they would be a convenient way to 
describe (to either a human or a program) how to parse the JSON schema.

There would then be another problem, namely how to include the varlink 
schema in the generated documentation, since right now there are for 
example no sphinx bindings for varlink.  Nevertheless, if you think it's 
better to have the schema as JSON instead of binary, according to the 
above varlink meta-schema, then we can look into it.

Thanks,

Paolo

>> +	struct kvm_stats_desc {
>> +		__u32 flags;
>> +		__s16 exponent;
>> +		__u16 size;
>> +		__u32 offset;
>> +		__u32 unused;
>> +		char name[0];
>> +	};

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
