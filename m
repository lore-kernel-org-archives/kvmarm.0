Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793138235;
	b=pWES3C3Qeo4huz11IgTANPHb+0lZgNQMlvgMrvkjcw4alREye5GYcRQExCMw7RMDt1O7
	 jcRrNRj/QTUTShMuWkKkPv/XqAiTN8UrHOVlq8iVGKXkLOxDTWZSp5/oCuYUivLWgsLyV
	 fUFdw9HIK+atU/FHjquhh4+pQDzE+uJmEUzSwtSANuBv8TFasPh1fpe0uX5yx3sNC73wm
	 DaiNVS/L9EwUunJ2ZUrREfgJtMwVa/NnQdKZYePF3cK+vC68e2myzZu9gyfXeh56Z8UkF
	 DKA4JNQ7+s5k+FLECTUNDi+5stDnDqKGW2MRaalDjwJG85RzQHy3DuJvYmsW7zL3Mlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793138235;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=INM4lTecUqg3+ORjH8the43AegIL5wVO95lrhujQQt0=;
	b=S7Xew42K93/4AFv5zFCb6ySeZLwlcY8nN4FFLrcazk47Kt3FM3y6LdhXgw/OFNV/hoN1
	 dpX9G2hltSt3wY3fpuyYNxJMzWkAzJZY0lK6/vmHq94cfkp+U7JETuvpH9hlzGMPtDroo
	 nTsf/sijnn618YPGOqm/Uo0LGLQDnoArOR7SUZj04lrQiOxYXwLnG01QhocYvXVg6iJjT
	 8xnagxNkmas0L03rwry2AOc/0SwKmlhAkJDyB+mJu1jvvSzxtcjuqsK0hzoTxhJ/gbfSj
	 SEihL8juvd18BxNfyoexnp5sVUiAk3OOFCq5VUf8lwWLErP7htxt3jjDqXt9qcFJfvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kxsoicWg;
	arc=none smtp.remote-ip=209.85.218.70
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BA5606A31D
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 21:57:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86BA5606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kxsoicWg
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c414c206673so28545466b.0
        for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 14:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793138234; x=1793743034; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=INM4lTecUqg3+ORjH8the43AegIL5wVO95lrhujQQt0=;
        b=kxsoicWgG7G1+eLe9hFdJSwgP8qLVfrgCB2Zm6fy0Prna5EfvBeRzlhOf5yBottD++
         vPnAvGJGZpH82myuYnNvj42kpluDlTVGvANSLPUnT/D1uVmhyPiJK9K6Mzn6AUrJIo14
         noe0+cJQJMcVZX4QxvhfqvIm4r+NDmLv8WGU7ZkbfbI3Ol3heMYUizHZpMq9r8i1LN2q
         WTp3rRb9/92FnRI6We2dvrqlCAxhfTuprzbl2ivz6uZYSlF93EZntrPp+BW1E6jVf5LL
         bli1HDbTA4+ZaMQThfc/dKdYA8aoMa2WOhrud8Qp0qXVe/wMpR/OrFNZmZAByvpxoNaT
         b24w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793138234; x=1793743034;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=INM4lTecUqg3+ORjH8the43AegIL5wVO95lrhujQQt0=;
        b=2vC47ZmAmgxqN3uyHP07f5IvUZXZdbNcvCoLLKzuFBOp/Ubxle48XrLDoAKeNzSCE/
         SSjjxJAskyt64UuoNnSHeYf05TCEL6WrkbmNeniOnSNl1shPpO9aZp6fRJB2t8x0vhNK
         OzCsKf3X9v6ICiSbONlQxxU17jQqCBYTjkuOnvLksEf63vdsIta4hjhc2/FxfgJb7gTp
         aEOUJeTEwyGnkdxO4DSOd4FuFTyHsTyjvZ5/U8v/CtU2mr57a0IEj8/3N9VQ1AqfnSJj
         Rqli5J4DeajRGoQ8kK61YEGybTVJSKdxbOB///D0DrJGbIMV7he08zUcwuvvPGu09ClJ
         z98g==
X-Forwarded-Encrypted: i=1; AKwUvBwsKKHkYeBsyv5CXVTbVUutYKjLbeKeQH6j3Un0DFnz8Qd/ES8M3Yp8OK4sCEsuYEp79+gMEPA=@lists.linux.dev
X-Gm-Message-State: AFq9FYKH75I0VDTm15vYEvAlS5veU4fxZJ+99tnSAnnXPd1QNBT9VNOM
	4CKS6TBvHgYbUBcTeGFCLoxyUQUfcf3843etKBbxQrWQJ42UrfC3hsHcv7KKlS5bwYbrJEF31mE
	kcs+QZw6oT8n/Q9T1aQ==
X-Received: from ejkh2.prod.google.com ([2002:a17:906:7182:b0:c46:743f:a4b9])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:e84b:b0:c2e:3a72:ffbd with SMTP id a640c23a62f3a-c49bdf71b7bmr44517166b.41.1793138233642;
 Tue, 27 Oct 2026 14:57:13 -0700 (PDT)
Date: Tue, 27 Oct 2026 21:57:12 +0000
In-Reply-To: <CALzav=dYKAP7pKfoPtz32X1cT_tH4LN0X47_jTO8_HOCT4Pi=w@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <atlQ_Er0Ig7CCSxv@google.com> <CALzav=f00C4yOAseNunW8GgQTDUGWT927Qy=TLm-3-J0TEDH8Q@mail.gmail.com>
 <9huzzew0el59.fsf@tarunix.c.googlers.com> <at_CncIPYCxOVkLo@google.com>
 <auDT5MjXYq3lcQjE@google.com> <CALzav=dYKAP7pKfoPtz32X1cT_tH4LN0X47_jTO8_HOCT4Pi=w@mail.gmail.com>
Message-ID: <9huztsm6958n.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
From: tarunsahu@google.com
To: David Matlack <dmatlack@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

David Matlack <dmatlack@google.com> writes:

> On Tue, Oct 27, 2026 at 9:40=E2=80=AFAM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
>>
>> On 10-26 21:14, David Matlack wrote:
>> > On 2026-10-26 11:50 AM, tarunsahu@google.com wrote:
>> > > Right, Required bit should be source kernel payload property to tell
>> > > target kernel that the payload must be handled to correctly deserial=
ize
>> > > the data. It should be source kernel (userspace) responsiblity to ma=
ke
>> > > sure it understand the target kernel before doing liveupdate.
>> > >
>> > > Saying this, During deserialization, target kernel's required bit is=
 not
>> > > necessary. So I propose the following truth table.
>> > >
>> > > Source hdr  Target supported[i]  Action
>> > > ----------  -------------------  ----------------------------------
>> > > 00          0 or 1               Accept: feature absent in payload
>> > > 01          0                    Accept: ignore the feature data
>> > > 01          1                    Accept: use the feature data
>> > > 11          0                    Reject: -EOPNOTSUPP
>> > > 11          1                    Accept: use the feature data
>> > > 10          0 or 1               Reject: -EINVAL (invalid encoding)
>> >
>> > Yes, this matches what I had in mind for the semantics.
>> >
>> > To be explicit: the source kernel should set the bits for each Live
>> > Update based on what is actually preserved, rather than generating the
>> > header from a static per-kernel array. E.g. memfd would only mark a
>> > feature present for memfds that actually use it. That's what allows
>> > rollback to an older kernel as long as nothing being preserved depends
>> > on the new feature.
>> >
>> > But looking at this again, I think the required bit is redundant. Whet=
her
>> > a feature can be safely ignored is a property of the feature itself, n=
ot
>> > of any particular file. Every file that has a feature present will hav=
e
>> > the same required bit for it. The only thing that actually varies per
>> > file is whether the feature is present.
>> >
>> > The required bit still has to be conveyed to the target somehow, since
>> > the kernel that needs it is the one that doesn't know about the featur=
e.
>> > But it can be conveyed by the feature's number rather than an extra bi=
t:
>> > split the flag space into required features and optional features, and
>> > assign each feature to one of them when it is defined. This is similar
>> > to the required_flags and optional_flags approach in struct pci_ser [1=
].
>> >
>> > Keeping the same header shape as discussed with Pasha:
>> >
>> > struct kho_ser_hdr {
>> >     __u32 size;           /* Size of header + payload in bytes */
>> >     __u16 nr_required;    /* Number of required feature bits */
>> >     __u16 nr_optional;    /* Number of optional feature bits */
>> >     __u64 flags[];        /* Required bits, followed by optional bits =
*/
>> > };
>> >
>> > Required feature N is bit N of flags[], and optional feature N is bit
>> > nr_required + N (using nr_required from the incoming header). The leng=
th
>> > of flags[] is DIV_ROUND_UP(nr_required + nr_optional, 64). Both spaces
>> > are numbered contiguously, so there are no gaps, and up to 64 features
>> > still fit in a 16-byte header.
>> >
>> > Each bit just means the feature is present, so the truth table becomes=
:
>> >
>> > Source bit       Target supports  Action
>> > ---------------  ---------------  ------------------------------
>> > Not set          -                Accept: feature absent
>> > Optional set     No               Accept: ignore the feature data
>> > Optional set     Yes              Accept: use the feature data
>> > Required set     No               Reject: -EOPNOTSUPP
>> > Required set     Yes              Accept: use the feature data
>> >
>>
>> I like this proposal. I bet most features are going to be either
>> optional or required, and even if we ever have a magical
>> sometimes-optional feature, it can have its own required flag. So, no
>> need to pay double the cost on every flag.
>>
>> Just need to make sure that optional features always start from 0, in
>> their own enum, so the offset can be computed correctly in the incoming
>> kernel.
>
> Right. Instead of having a single 32-bit feature space where every
> feature can either be optional or required, we have 2 16-bit feature
> spaces, one for required features and one for optional features. Both
> feature spaces span from 0 to 2^16-1, and then are packed into
> flags[].


Okay sounds good. I will send the next version soon. Also I belive the
design is decided, So I will drop the RFC tag also.

~Tarun
