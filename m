Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793049253;
	b=XQ4V/FN+fdsWYj1EK70G3owY3Ry7bU+fjPd2YMXPrLrFvf+Bqae0tPXleGVAksEGsUtw
	 el/hWqP8CbY6DV+n7Eg7t1FEhiTWxtFSSKc0hTfbLWREG8QeCtn4zwhL82u7bye6R9BJe
	 dMLHwJOExtzDeCm9BRRw1FdNrnJbVzzufZFwDtNYMikyq5siI+M6Drh0v1qlb/EYdKnzl
	 9N8D8Ib+mDVPziH9fdmEOgze/mlSAWgu1a2iF2Cqmv0nqMcaBhXtC6HOztClrPUu1VfhX
	 n8Nv39vQD8nfohWCANgj0h5AyfSilCwVsxKWRbOe3QlUEWVfNS2NMk3irGgdu5BYiBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793049253;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=gKF3hAWDK1ltcE+SHB5ZbEu9q5rcNDasVCUAn/AhQHg=;
	b=GXnSD5wcHVnGL/4n1y/39ZaPl5A0rg46c1wOMdOEplGrKTJ/Vfkg8/e5+L6rwGwjImCh
	 K9t5BETQMK6qqnorGVBvt21qd+6X4vhN79HAx/cHlDaH4LS7ObaqoQJqdVHGbJ6HnRTRp
	 YH0hyrI8cvQ0UNhYxtxVwu6nAzoWGYnvB7AqfqAXkcOzIDAlWHg6aisl5YLtPclyF6m0f
	 i8coiHzilwM02DNd5krX+91NfpGpfBWO1XJhgnVEbmOdJK45hjDeqqD0K6hSveAEiI5pP
	 pl6E53RtSEHQ/sHJreGZVNWgmV6JRBiF/KaOPe8rX2rMclbGt3PkP/F1SIFchY3653Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b="uMY/pJuy";
	arc=none smtp.remote-ip=209.85.215.177
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0565F606A321
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 21:14:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0565F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=uMY/pJuy
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cdab938dc83so511730a12.3
        for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 14:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793049252; x=1793654052; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gKF3hAWDK1ltcE+SHB5ZbEu9q5rcNDasVCUAn/AhQHg=;
        b=uMY/pJuyqnXFquXlaQgbXXn/WLKQK/n+3UD8OtorTMynGREvFGk2kWQCxGjnV+CGBd
         zUM10wRLC+73bkS+rKt/q0gnqLvCUVRW11zkardjYkgI6O04fpl7MsywNnJ1bW5FL5gR
         qwQdX/UuZhJ0Hd7nka3/Xye9XxtpHUGRNz8QeVKx53rvCQS3x0UnmFtvdkDPJsTgCRe1
         VG2nR//bVQr69oW9wDfCMgQW4wQ96rhKOdnm+R47sVzfcUnlO1AQlw6sgt1X2HCa7sHQ
         fp+WdlntTGL+VwHHpoDrlpbSTNCfDOSHr1Wd/3YpYhYJdgYeAnPTvJ/tN5kRf+xGDPlS
         GrBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793049252; x=1793654052;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gKF3hAWDK1ltcE+SHB5ZbEu9q5rcNDasVCUAn/AhQHg=;
        b=ApaKCv53hU9wfBAU7yuR9b3rmXXdnA7ZfGVemlPXlwBnFNRlQeVGqvtzYvYlLSYUCy
         SLefPPoLY1asEzz3zdFI1r6Sl+/0455NtrXFXhyOw+SCX9aNWeKmZuinLsNHLEkkHYjn
         p8yOis7+p2bJoe0PtAmDIy0s/IWE/UxYtqSEQdMoCiws54TTMJ9CEQkVaxhL7VcKxunU
         LmgKGaNSdCjKsPR359n1NNkTwSDdQeaH+cXj+P7ZfJDoDwyndjLUuKu8Wzg6l/cBPcOU
         KSEv4j5dLfb07PDq3n0mSHKzVbCqmCSch8YjPgDLjoQppyFyHrDELeQUVfb6633gQkRL
         O5PA==
X-Forwarded-Encrypted: i=1; AKwUvBwejKEWjDffLnP6jMFKp7eVY2n76r1kzi45b9dXo30enIb/49akkBWcIUh7mwYMNXD6gCrgKQs=@lists.linux.dev
X-Gm-Message-State: AFq9FYK/piBLVcscr5X9EzRxAtWRHeVK2p9E79RdEP1DyYeu8aglrN5w
	MIr/ov9vsUTfQUUPLBfGCw+cWDU5tBNsBR6e+MazES0nlAoM6FleWkOlN88r+AqpSw==
X-Gm-Gg: AYBFou13B6oGuPVsT0Y6Mgw85dZ5B/JpJ3cRZN5mKSG+F/YYJ7/qJMBOoXKNbx8ZgpX
	alePQaSM+PTC8lI3adSSeufGMfS5vAagj25jIld7hsGrd9f3e597ud5lHZUxAn+KQitRdh665b5
	8KU2toOI3AXSBt4tO4mxc7OgM5Qnefp5W0H7JmIeckUg53Uk1SH5fQY0HXWPjfqm6JCuDmIMRgI
	msx9azeNk7VSQMUj44gdaSlmNXxgATGusZlrMGTjIjaWSg3e+noWl/5JbCnEc15Wy9luc6gLzqg
	K0V1fcVadOSgyXr+LJsl7TjOHyXFbI+6Yy/vhc9/jAkQhhJLVCwBG04QSQOktuD7OcPOetzlFgm
	Mcs17iBH5FAtNERe2VzasbG4x5QeJO0mNmAgSVUuUvZ/L5qc9LjcvWifBkTUlPCvP7j69rz66kh
	EMMliDPvRoOXzV1B4SEgMPtkyQgVPHzjnH89MUKvfWQHUhe9tRHjMjbdk3qQiucWzVELD1pPK9w
	utyZi/gi4w1h8SLNJN8/q+pWGpqiI7tJmfkiC+7D8ZFLFau+H8PVd3d9Yvm1MinpxZKlC0VgV8f
	U+BGAk5irJOtZFwMrMdYBCMOejFl7xeBs/6GRoCJrBo=
X-Received: by 2002:a05:6300:6bc9:b0:3e2:3392:53e7 with SMTP id adf61e73a8af0-3e7a1b97750mr5308652637.0.1793049251805;
        Mon, 26 Oct 2026 14:14:11 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a36b372888sm1666157b3a.30.2026.10.26.14.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 14:14:09 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:14:05 +0000
From: David Matlack <dmatlack@google.com>
To: tarunsahu@google.com
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com,
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org,
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com,
	will@kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
Message-ID: <at_CncIPYCxOVkLo@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-4-tarunsahu@google.com>
 <atlQ_Er0Ig7CCSxv@google.com>
 <CALzav=f00C4yOAseNunW8GgQTDUGWT927Qy=TLm-3-J0TEDH8Q@mail.gmail.com>
 <9huzzew0el59.fsf@tarunix.c.googlers.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9huzzew0el59.fsf@tarunix.c.googlers.com>

On 2026-10-26 11:50 AM, tarunsahu@google.com wrote:
> Right, Required bit should be source kernel payload property to tell
> target kernel that the payload must be handled to correctly deserialize
> the data. It should be source kernel (userspace) responsiblity to make
> sure it understand the target kernel before doing liveupdate.
> 
> Saying this, During deserialization, target kernel's required bit is not
> necessary. So I propose the following truth table.
> 
> Source hdr  Target supported[i]  Action
> ----------  -------------------  ----------------------------------
> 00          0 or 1               Accept: feature absent in payload
> 01          0                    Accept: ignore the feature data
> 01          1                    Accept: use the feature data
> 11          0                    Reject: -EOPNOTSUPP
> 11          1                    Accept: use the feature data
> 10          0 or 1               Reject: -EINVAL (invalid encoding)

Yes, this matches what I had in mind for the semantics.

To be explicit: the source kernel should set the bits for each Live
Update based on what is actually preserved, rather than generating the
header from a static per-kernel array. E.g. memfd would only mark a
feature present for memfds that actually use it. That's what allows
rollback to an older kernel as long as nothing being preserved depends
on the new feature.

But looking at this again, I think the required bit is redundant. Whether
a feature can be safely ignored is a property of the feature itself, not
of any particular file. Every file that has a feature present will have
the same required bit for it. The only thing that actually varies per
file is whether the feature is present.

The required bit still has to be conveyed to the target somehow, since
the kernel that needs it is the one that doesn't know about the feature.
But it can be conveyed by the feature's number rather than an extra bit:
split the flag space into required features and optional features, and
assign each feature to one of them when it is defined. This is similar
to the required_flags and optional_flags approach in struct pci_ser [1].

Keeping the same header shape as discussed with Pasha:

struct kho_ser_hdr {
    __u32 size;           /* Size of header + payload in bytes */
    __u16 nr_required;    /* Number of required feature bits */
    __u16 nr_optional;    /* Number of optional feature bits */
    __u64 flags[];        /* Required bits, followed by optional bits */
};

Required feature N is bit N of flags[], and optional feature N is bit
nr_required + N (using nr_required from the incoming header). The length
of flags[] is DIV_ROUND_UP(nr_required + nr_optional, 64). Both spaces
are numbered contiguously, so there are no gaps, and up to 64 features
still fit in a 16-byte header.

Each bit just means the feature is present, so the truth table becomes:

Source bit       Target supports  Action
---------------  ---------------  ------------------------------
Not set          -                Accept: feature absent
Optional set     No               Accept: ignore the feature data
Optional set     Yes              Accept: use the feature data
Required set     No               Reject: -EOPNOTSUPP
Required set     Yes              Accept: use the feature data

There is no invalid encoding left to check.

[1] https://lore.kernel.org/linux-pci/20261013162529.1928093-1-dmatlack@google.com/
