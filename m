Return-Path: <SRS0=ypkC=LK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7129EC48BE5
	for <kvmarm@archiver.kernel.org>; Wed, 16 Jun 2021 18:18:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B17BD613DA
	for <kvmarm@archiver.kernel.org>; Wed, 16 Jun 2021 18:18:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B17BD613DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 538FB4B08E;
	Wed, 16 Jun 2021 14:18:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6D6-67++BOZJ; Wed, 16 Jun 2021 14:18:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C645B4A4E5;
	Wed, 16 Jun 2021 14:18:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 185FD4A3A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jun 2021 14:18:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IVXpUZV0b42X for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Jun 2021 14:18:28 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9395440874
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Jun 2021 14:18:28 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AB59613DF;
 Wed, 16 Jun 2021 18:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1623867507;
 bh=yR3TWXQGACrmeWymexeG1By33MQORQQAF0TeHv4GW1M=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=COQk4a/UaxiwMIlcK4ZQEI0MCZ2TthwybNm0T8inJNsh3Yidk2jqKwkYKfI6/vX8w
 pcK3zCUY8ZCDHKJ3+LNjjBfu5DmAu+msMJwlh97PA3HqvuxBhAqDWS4Imj3zI8KyJn
 wjw0iwoWBPke8vFJ7rxJUwH+1tmTb1622MC5+WL8=
Date: Wed, 16 Jun 2021 20:18:25 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v9 3/5] KVM: stats: Add documentation for statistics data
 binary interface
Message-ID: <YMpAcaqjk4ZN90gj@kroah.com>
References: <20210614212155.1670777-1-jingzhangos@google.com>
 <20210614212155.1670777-4-jingzhangos@google.com>
 <YMoW7SBqO9EPgCXw@kroah.com>
 <9b9a951d-d020-5599-5c4f-e154b40522b9@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9b9a951d-d020-5599-5c4f-e154b40522b9@redhat.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Jun 16, 2021 at 06:59:15PM +0200, Paolo Bonzini wrote:
> On 16/06/21 17:21, Greg KH wrote:
> > I forgot to comment on this one, sorry for the delay.
> > 
> > Why are you "inventing" your own schema format here for this?  Why not
> > use a well-known or at least well-designed/implemented one that we have
> > in userspace already?
> > 
> > There are a few that I would love to see in the kernel, varlink being
> > the best example.  We have kernel examples of this and I would consider
> > using that as a transport for sysfs-like data in the future, but never
> > got around to it.
> 
> Thanks, that's a good observation, and it's a problem that the rationale and
> the design process didn't end up in either the documentation or the commit
> message (only the outcome did).  In order to fix that, this is going to be
> quite a long message.
> 
> Varlink comprises both a schema and an encoding, and each has its own
> problems.  For the encoding of the data, varlink is really just using JSON
> and it is really just the wrong tool here.  The first few problems that come
> to mind are:
> 
> - varlink structs are encoded as JSON dictionaries.  Therefore, every time
> userspace reads the fields, the kernel has to include the field names as
> JSON dictionary keys.  This means that a lot of time is spent writing
> buffers, and on the receiving side parsing them.

Has this been measured?  Years ago when I messed with this, it was in
the noise as JSON parsing is really fast these days.

> - because numeric data has to be converted to ASCII the output doesn't have
> fixed offsets, so it is not possible to make an efficient implementation of
> pread.

efficient where?  In the kernel?

> - even though Varlink specifies that int is "usually int64", a little-known
> gem is that JSON behavior for numbers not representable as a double (i.e.
> exceeding 2^53) is implementation-defined; implementations can and will mess
> up values outside that range.  This problem is not specific to this KVM
> stats usecase; varlink's schema specification really is at odds with its
> encoding specification.

That's interesting, do the varlink developers know this?  And we can say
"for the kernel int will be int64" and be done with it, so this
shouldn't be that big of an issue.

> For the schema, there are some specific problems with varlink, but also a
> more generic issue.  The specific problems are:
> 
> - the schema doesn't include the length of arrays.  This makes it hard to
> compute in advance lengths and offsets of fields (even ignoring the fact
> that data is not binary, which I'll get to later)

Do you care in advance?

> - the schema also is not extensible with user annotations.  In our case that
> would be mostly the unit in which the value is expressed.

units would be nice, I agree.

> The main problem with the various available serialization formats is that
> their schema languages are designed to be compiled with a code generator.
> Here instead the schema is transmitted from the kernel to userspace.
> Userspace is not really supposed to know what a value means or even that if
> it exists.  Userspace takes care of collecting the data from the kernel, but
> ultimately there will be a human that knows what e.g. "io_exits" or
> "req_event" means, and they will ask for the current value, or a plot over
> time, of a specific statistic.
> 
> Now, unlike most other schema languages, varlink does not require
> precompiling the schema in its C bindings.  However, this was mostly just
> the authors not bothering to write a C code generator---they did write one
> for Rust, for example.  When using the "official" varlink C bindings, you
> hardly use the schema at all.

I don't think the kernel implementation needs this, you can just specify
the schema "on the fly" and it should work.  Or maybe I'm wrong, it's
been a few years.

> Something similar to the above issues is quite common in other formats.  For
> example, FlatBuffers[2]'s schema language[1] does have annotations (which it
> calls metadata), but then we would still have to invent some standard
> annotations and teach programs about them.  However, the deal breaker is
> that again there is no way to transmit the schema from the server to the
> client, and that users are supposed to precompile the schema using a code
> generator.

Again, I didn't think this was an issue with the kernel implementation
in that the userspace side could determine the schema by the data coming
from the kernel, it wouldn't have to "know" about it ahead of time.

But I could be wrong.

> All that said, what we _could_ do is serialize the schema as JSON instead of
> using a binary format, like so:
> 
>   [{
>     "name": "exits",
>     "kind": "cumulative",
>     "count": 1
>   }, {
>     "name": "halt_poll_fail_ns",
>     "kind": "cumulative",
>     "unit": "seconds",
>     "scale": {"base": "pow2", exponent: -9},
>     "count": 1
>   }, ...]
> 
> while keeping the actual statistics as an array of u64 values just like in
> these patches.  The JSON representation of the schema would be always the
> same, so it could be treated as fixed-size and an efficient implementation
> of pread would be possible.  And once the schema is JSON, there could be a
> *meta*-schema expressed using the varlink language:
> 
>   # compare to struct kvm_stats_desc, included after my sig
>   # for reference
>   type StatsDescriptor {
>     name: string,
>     kind: (cumulative, instant, peak),
>     unit: ?(bytes, seconds, cycles),
>     scale: ?(base: (pow2, pow10), exponent: int),
>     count: int
>   }
> 
>   type StatsSchema {
>     name: string,
>     stats: []StatsDescriptor
>   }
> 
> Varlink would *not* be used in the kernel, because Varlink isreally just
> JSON.  The above ten lines (plus comments) would be dropped in
> Documentation/ as a .varlink file; they would be a convenient way to
> describe (to either a human or a program) how to parse the JSON schema.
> 
> There would then be another problem, namely how to include the varlink
> schema in the generated documentation, since right now there are for example
> no sphinx bindings for varlink.  Nevertheless, if you think it's better to
> have the schema as JSON instead of binary, according to the above varlink
> meta-schema, then we can look into it.

It should be in some standard format.  I'm not wed to varlink, but I
thought it solved some of your issues here with userspace not knowing
the schema ahead of time which is the key as it will change over time
and the kernel should be 'self-describing'.

If not, and it sounds like you have looked into it, or at least the
userspace side, then that's fine.

But you should write up a justification somewhere why you didn't use an
existing format (what about the netlink format?) in at least the
changelog, like you did here.  As you will be stuck with this api for
the next 20+ years, it's good to be confident in it :)

maybe someday we can get varlink into the tree, as I still think it
would be better than the ad-hoc implementations we currently have.

thanks,

greg k-h
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
