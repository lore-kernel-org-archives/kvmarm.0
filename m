Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793119207;
	b=0F9b6LCEWPCa9Xn/NyI4UX4HHN4M+r54szPU4Dsldt4oYSp9Yu8g+KbyqqSNzF3qvOif
	 tpHbAE2PvFEnG1SEzG+5wq4AgSPn6biSwTzyCAoq5jVCco/nOlB3ttOH4zHfe3/rN34Zx
	 dBheoEr0xmfEuNcaLzT3drrCx83X7Iunr/JCoCVngtciEF6uBOfd6e5tXgXyJ80569z2W
	 ioEhIuvd8EHx3Pp2VOzybkSaioE1f8G3nslK1TgdLV8uaawyXPOp6Grap4oGDGeneJj3A
	 JDyqnBOrT5Ow2A0Rz8adOgWsvrwilCHbpq6RtjC+TY9lBax9QaqEW6dnxHs7hdgET5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793119207;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=gbXuStreYRF1M4k9Su5zd2++RJBOLVmoBCN1Uwl3TZ0=;
	b=21zdhDonAwGlEzJL9fEVdlcrBZAEQzWRyjx5Va26BXcSz4nwcVH5TJ8lCoFHX3AIt0JC
	 Q3CA6eAYl5dN54d7pbkYontuyuO9qOE23QUIVvH4+5Se48ERQE+qpd4eqhqzTl3aD9WnO
	 uciwX7rZ7EQk0FVM/avdjaBdFAD6ZB/UIHXUUacQiYVBTHGIV5ePtuM6JzST7jPGmPhsV
	 4OhYplIXpDjGd3dp2dLyjOAMga+H9MdBpfFTOJ051w3SuijHq9bQQCTNXZbgc3er4qmS3
	 lqOir7F9EKCzAnTjkx7caGMGN8X3f940Xak2gF6XfGEzLYj0Vylkv1ETEmsU0V8J94g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Xv1IGTwO;
	arc=none smtp.remote-ip=209.85.217.50
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35081606A320
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 16:40:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35081606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Xv1IGTwO
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-7cc0ccc2fddso1297906137.1
        for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 09:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793119206; x=1793724006; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gbXuStreYRF1M4k9Su5zd2++RJBOLVmoBCN1Uwl3TZ0=;
        b=Xv1IGTwOx7zDwjKN0Wy7F7V5RdbA0N+BOGqKP/NJmwX5gM8EOIWB7aErIjEP3fH8aj
         gT0e6ZKlSaD46GhyDDJV9sI0sxFx5OdIxdJtM/oTBQfWyBXOofMMgky0usJQ1jtyrpZM
         Nzkhid2r2UxX6RR7OTxRRpF6CZzM6ldAXQI0Oq04SGTSojU4AwkfncIYuzFYm9JLR11y
         OLJR4Kx18gUvW1/C3RIL6TFY6IgiUDaABWl4ay/5F80k630RpiAVR0vQiBg0uUi7WABY
         JcZZRW1QhGoSK1WVEzj1wbDLuvWlhfm+wWhuHTQEOo/YZoy5NwqlsIFS0h+to5mKPER7
         Qrxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793119206; x=1793724006;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gbXuStreYRF1M4k9Su5zd2++RJBOLVmoBCN1Uwl3TZ0=;
        b=Y4tPx/jMsHdKIWwhPN4l6nnwBJBJiJNV7FVsDnEwwPEWL0dYlXKrhFsNoXe5Z8u92t
         yt+ZV4GWUSzyc/dnXRfEzbQ5mbusIpp5NTZt2ROMCAqcXhnB0krxrRtyrRW9Y+gSgk6c
         IP6/LVyfE0Sf+Z75eYLf2JGl+b6ifXJxckXVSvUrJR5pGzlOPIZ/ygBeWgPptH+emQJ6
         QZw/0X6gtiC7jUW2dX2PUMVbKVbMnKR0hQnUFeunqjMgAxyE3TMNLv9K2X7Z81VDkRbC
         faMJ5dWnXmiu4wslJMXI6QukMzJ/Ljz9jrkCVT0oPSZ5A5LrviNLKYxCrXEfzQxFHPA5
         LG0Q==
X-Forwarded-Encrypted: i=1; AKwUvBxv4En2V3ZlO9PztahkOjx3MORwAvQx4/qI2ZpsvILTHWfrzXpw9ZqEk+eHjByOKIpQpAeuBcE=@lists.linux.dev
X-Gm-Message-State: AFq9FYL1rJYSLSvCPpajM8o58twQ0Q5/o7XloFdHsMW+rfKvMkWSrz4g
	hXxykrZZzA1xo9hheZVeQ6Qx9vy63LbhnXjux7bxh/UFqpPtoq+Jf+NfdFF/gQXjC8w=
X-Gm-Gg: AYBFou3KIzpZZyh+nHwIo6z/0vVc5fzkPB+M2KAMJzFbzvTy2E4VL6NVvh88NX1FUIH
	p8MzPZf3f6MMxHdFS5e6mlknPk7xSJKpmtHYtcIKR4OtWq/HVHDT2PanpIfzW4oXmVMb35n16Mj
	3usp/3NsdCY+ZUr6U+1euI1DdsKuS6swU/Fz7GcpXzZsIqGo3t/b4UhL1HxRKRPoEInzBGyE3E5
	Dbz54qRPZ6wGXVlAnEiQYKtodsE0hV85XV2A5QX/4WbLFVSHhP0bhaMePJ6SksH89It4jJSnMXx
	Dz4EbIXrXkVroRvAP8H4yr9z6MHSiJRThNycC517FgMlnuKPGq2a/tcyH983EVEdz4NNjy293/X
	764sBAa3QjSiF3N1/X7FwCRRg1Oh6YJ/7h4cy9SroYSDpW7NUGfB32GyjZVYne2Hd30z72JUllL
	FGRQQaiTQuwe6qZdQKZgWbFb2F2vE3CDoUfCCPruiZl4PgZhparENZw86Q2+m8VKxwlfsWHa+Wa
	pkUJWJIwnvukJcugydIRM+sBn980l3PCGh9CD8CzbYkZqVzowRJD4RQnhA0nZ3WayYzunQ8xTbm
	zVV1HGYzdI3pzNYZbm0E0WM3j5IWW1tDUZ/b8MG5uF9IPpVez3ndoJLxttIHA+94D0J8qSNy4WX
	/I01FtY3sIXG8deopUIXf7kido8qjWNlZLRLZsZejuuUIgT4Dbho=
X-Received: by 2002:a05:6102:5048:b0:7bf:74c1:b606 with SMTP id ada2fe7eead31-7ce5ce4227dmr3243460137.34.1793119205875;
        Tue, 27 Oct 2026 09:40:05 -0700 (PDT)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9912da2d9d1sm442866241.7.2026.10.27.09.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 09:40:05 -0700 (PDT)
Date: Tue, 27 Oct 2026 12:40:04 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>,
	joro@8bytes.org, Mike Rapoport <rppt@kernel.org>,
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
Message-ID: <auDT5MjXYq3lcQjE@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-4-tarunsahu@google.com>
 <atlQ_Er0Ig7CCSxv@google.com>
 <CALzav=f00C4yOAseNunW8GgQTDUGWT927Qy=TLm-3-J0TEDH8Q@mail.gmail.com>
 <9huzzew0el59.fsf@tarunix.c.googlers.com>
 <at_CncIPYCxOVkLo@google.com>
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
In-Reply-To: <at_CncIPYCxOVkLo@google.com>

On 10-26 21:14, David Matlack wrote:
> On 2026-10-26 11:50 AM, tarunsahu@google.com wrote:
> > Right, Required bit should be source kernel payload property to tell
> > target kernel that the payload must be handled to correctly deserialize
> > the data. It should be source kernel (userspace) responsiblity to make
> > sure it understand the target kernel before doing liveupdate.
> > 
> > Saying this, During deserialization, target kernel's required bit is not
> > necessary. So I propose the following truth table.
> > 
> > Source hdr  Target supported[i]  Action
> > ----------  -------------------  ----------------------------------
> > 00          0 or 1               Accept: feature absent in payload
> > 01          0                    Accept: ignore the feature data
> > 01          1                    Accept: use the feature data
> > 11          0                    Reject: -EOPNOTSUPP
> > 11          1                    Accept: use the feature data
> > 10          0 or 1               Reject: -EINVAL (invalid encoding)
> 
> Yes, this matches what I had in mind for the semantics.
> 
> To be explicit: the source kernel should set the bits for each Live
> Update based on what is actually preserved, rather than generating the
> header from a static per-kernel array. E.g. memfd would only mark a
> feature present for memfds that actually use it. That's what allows
> rollback to an older kernel as long as nothing being preserved depends
> on the new feature.
> 
> But looking at this again, I think the required bit is redundant. Whether
> a feature can be safely ignored is a property of the feature itself, not
> of any particular file. Every file that has a feature present will have
> the same required bit for it. The only thing that actually varies per
> file is whether the feature is present.
> 
> The required bit still has to be conveyed to the target somehow, since
> the kernel that needs it is the one that doesn't know about the feature.
> But it can be conveyed by the feature's number rather than an extra bit:
> split the flag space into required features and optional features, and
> assign each feature to one of them when it is defined. This is similar
> to the required_flags and optional_flags approach in struct pci_ser [1].
> 
> Keeping the same header shape as discussed with Pasha:
> 
> struct kho_ser_hdr {
>     __u32 size;           /* Size of header + payload in bytes */
>     __u16 nr_required;    /* Number of required feature bits */
>     __u16 nr_optional;    /* Number of optional feature bits */
>     __u64 flags[];        /* Required bits, followed by optional bits */
> };
> 
> Required feature N is bit N of flags[], and optional feature N is bit
> nr_required + N (using nr_required from the incoming header). The length
> of flags[] is DIV_ROUND_UP(nr_required + nr_optional, 64). Both spaces
> are numbered contiguously, so there are no gaps, and up to 64 features
> still fit in a 16-byte header.
> 
> Each bit just means the feature is present, so the truth table becomes:
> 
> Source bit       Target supports  Action
> ---------------  ---------------  ------------------------------
> Not set          -                Accept: feature absent
> Optional set     No               Accept: ignore the feature data
> Optional set     Yes              Accept: use the feature data
> Required set     No               Reject: -EOPNOTSUPP
> Required set     Yes              Accept: use the feature data
> 

I like this proposal. I bet most features are going to be either 
optional or required, and even if we ever have a magical 
sometimes-optional feature, it can have its own required flag. So, no 
need to pay double the cost on every flag.

Just need to make sure that optional features always start from 0, in 
their own enum, so the offset can be computed correctly in the incoming 
kernel.

Pasha
