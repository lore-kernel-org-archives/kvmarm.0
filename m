Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794330231;
	b=2MiKqmwblYZoFk9D2zMOfDkSYjAW/DjmB3O3803Ap26SazOfG7wICKME0Kwu541GCZfq
	 9vOjvxeNukArvNxh5a4YT5nb79m//96fzBmVdsYlKsmeHFP7usjI8wsWQC+cz7fWF0iTz
	 48PF+Pj/vjF6gS//15rTX6AOF1Q4hAxEeIdclGWR6tmEd7Jz6Up8N2EM6DPT0qXcyDFOp
	 +k6fhsS+DcaP/XseH8wKuE0oUqLobiXJZmyNa1LRq0N96k/QoS5WJczYiGNwjiAawwgsW
	 MvQlb567OaxPAwjMxajDLfkqCGp4velBQ5gWVCdW+fDQ02+cR15TT7pjGsyHmJFsTjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794330231;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Mime-Version:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:Cc:Subject:
	 From:To:X-Mailer:References:In-Reply-To;
	bh=vqBeli1UK7UsB0colEXax3/fZJsEEio4CkgX2Fv7UF4=;
	b=uE0CyoZdhKq5Yk43RHV32aWr5Uw2xJzYekYQomnCkpcUWgvqcw2ikUgBoAYQORdR2O47
	 3tcYez6dbBdujMBOY+znYHRqvtDdQ2MVcNoC58lVvDvyY0N2FhrENPqQQhjc0YOCPZb8J
	 aIGaJqiom/xe3mZfQ1kS5/WTcMYERLPCEvZN3lHoXdvthwgCWyTE+k9R9qIxPxMJKGCd+
	 LKJLRI6VFO+ywX+7aN3GsWz/pnqvjDVnWjb+9Z+uRwEvAAByxQnLdWq3KMjkXnq2YeP14
	 PHnAJuRa0pR+WGcms9p6XNkGEBP7cJhjp/oFPx7895egsezYP4LZnlohmcwQkComWgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XnHZmP5J;
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBAB606A32E
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 17:03:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FBAB606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XnHZmP5J
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3b094e649d3so1408246a91.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 09:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794330231; x=1794935031; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vqBeli1UK7UsB0colEXax3/fZJsEEio4CkgX2Fv7UF4=;
        b=XnHZmP5J2WVlzvlOUmrOvKw/TjGwN9RN3JgG85bGTpPbvNN3Pm3O9IUj5+B4TEgcOU
         LRBlDqbHVjGUTgCtRYYFFR7JgL5ZB64zw58JQRPHdTw+SSgsGP5QxxPLcfB/r1I99RBC
         e5RmIBYsWlpCLhFbGPjZpnKOO93VvvRjg5Gng2CUuj8uhkrbBKMTaqa1GaCm1ph+hAx5
         Tdi48hiOTR6q2GY+cIL0EaJn5hDWZcr+tsCITV/hCgPBHAtSvCZJFDbmqAvCG/DEPv4n
         YVqetN8pKEJIDckP+aOM9Fp2c7hXLkk9hXbnukWjtL/I4LuAHgj1YrX6DlyPye5Q1mZo
         CDCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794330231; x=1794935031;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vqBeli1UK7UsB0colEXax3/fZJsEEio4CkgX2Fv7UF4=;
        b=wzQxzTkbLNKBJHvENPozsgKrpJ2VnKolARwIoCNXPKeNJFXGr+bWTFBCNbEcMSaQGV
         WLd6LvimKeb6HRjfCz6WHuxsZQs1M0Df21F3FfzfqJtl48WqHwK2hue8CYnGgsu+HRwl
         UfuD8OIHmed/pyWm3WbJ0C3qPkYYziy5rUlSs0heyW4R5Uh8z7hTrMeSQ9bSLl/zpmMa
         yaLxFmcGUw+OtmtIXofxE4CClBX3XmRLGs2gkXxnpm25Lmn0ix/9UEQzgpDQuBzd03RA
         LMsyf0Pfz66l2nmfM+g40NNboxgMovtdlum9Nm3ti9b649n4NWwOgX+paqAt+sQzir8N
         qc5w==
X-Gm-Message-State: APuU4Z+9HchfLEWZK7YwAJkMPXq+qBQzI73VsYdz2XVuhwgptBBe5xC3
	79Ur2qNtUX6OGlZJaQNs8B3LxN0IIDcqeX6t9fkJiM1CNZJcOs5NtCTkepB+nvfR7g==
X-Gm-Gg: AYBFou1683C2OJHnslriO5KRsq5QZNhpBXYoxHooCPcLfxjUyxQquCTUTVp6jAYeH+G
	QJtl8Ru3LShKyLtOuZHy0ei11DtaB5TkpWtk6VxjrGkav+DZe4vhy7FSO6KZNGPFaspiRhw93PV
	CuHe5RTY73fjImtimBQTKACtzsz8xEfJzOt8etjoxhVzMLVPDvmHVd2TZtfcFBqAEi/5BBgZJcd
	0TZEeUzH/BkfSVu23C7afTiM6blUy50i449U7ZIrxJz4aEN6W72JVkPYwolMIpwgWB/xfiTE1f/
	4RzMUJHAY8wvkpGDgEoiFftmti7EBGs57pdnoFj1ygnyYGl8mGYpRBvW7y7FPdecLBUyV+5Rb89
	ckGLaJcUFIhLF+NE7rgMGoWslYkF88rF47TgD7WHkN7QXRMqQ40uIvqKif+ykaBjCQZkTMqXZBg
	2CRM6aCiw2wOd1mfjzsJpdP4azJ5BRlfVH/84HECS1ugEJqlLBN3iYrSxdM67lB7xrYzlx16n8O
	PSed4tst0dvqSDfsQ6rwezzt5NcGCg1kp6JC63KwyoCAKvEOwdGFf4iBxUZFtTxDeYAMxB+6hjE
	H+XTAbiKFMfqfOIpsIQ/XSV3HWTJlzyk4wMsIyWns+QXAjqLl6CZiNS5O+BvqdBc
X-Received: by 2002:a17:90b:524d:b0:3a6:e901:e79b with SMTP id 98e67ed59e1d1-3b166cc14bamr3213232a91.15.1794330230055;
        Tue, 10 Nov 2026 09:03:50 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db85a9bsm514293a91.14.2026.11.10.09.03.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 09:03:48 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Nov 2026 17:03:48 +0000
Message-Id: <DMROZB8DPEWD.W2BFC7JIBVZP@google.com>
Cc: <kvmarm@lists.linux.dev>, <linux-pci@vger.kernel.org>, "Pratyush Yadav"
 <pratyush@kernel.org>, <kexec@lists.infradead.org>, <kvm@vger.kernel.org>,
 <iommu@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
 <skhawaja@google.com>, <sagis@google.com>, <linux-arch@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 02/19] kho: block: Record the entry size in the block
 header
From: "David Matlack" <dmatlack@google.com>
To: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>,
 <robin.murphy@arm.com>, <maz@kernel.org>, <will@kernel.org>, "David
 Matlack" <dmatlack@google.com>, "Alexander Graf" <graf@amazon.com>,
 <seanjc@google.com>, <jgg@nvidia.com>, <loganodell@google.com>,
 <arnd@arndb.de>, <dwmw2@infradead.org>, <baolu.lu@linux.intel.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, <oupton@kernel.org>, <alex@shazbot.org>,
 <gle.com@google.com>, <pbonzini@redhat.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, <kevin.tian@intel.com>, <joro@8bytes.org>
X-Mailer: aerc 0.21.0
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-3-tarunsahu@google.com>
In-Reply-To: <20261110050202.529473-3-tarunsahu@google.com>

On Tue Nov 10, 2026 at 5:01 AM UTC, Tarun Sahu wrote:
> Add an entry_size field to struct kho_block_header_ser. On the outgoing
> side, record bs->entry_size into every block header during allocation.
> During restoration, derive the entry stride directly from the block
> header instead of relying on caller-supplied dimensions. The
> kho_block_set_init() interface remains unchanged. A zero entry size,

Since the entry size now comes from the block headers, incoming block
sets should not take an entry size at all. I pointed this out on the
PCI patch (16/19) as well. As is, every incoming path still calls
kho_block_set_init() with this kernel's (outgoing) entry size, which
kho_block_set_restore() then silently overwrites. That makes the
callers (e.g. pci_flb_retrieve() and the LUO session/file restore
paths) read as if they iterate incoming entries with the outgoing entry
size. kho_block_set_restore() should initialize the block set itself
from the incoming block headers, and the incoming paths should drop the
kho_block_set_init() call.

Please also add an accessor for the entry size, e.g.
kho_block_set_entry_size(). Users of the block set need it to check that
incoming entries are large enough for the fields they read, and that
the fields of a feature are within the entry.

[...]

> + * Each block header also records the size of its entries. A newer kerne=
l may
> + * append fields to an entry, so the kernel that writes a block and the =
kernel
> + * that reads it can use different entry sizes. The reader steps through=
 the
> + * entries with the recorded size, so every entry is found, and it does =
not read
> + * beyond the recorded size of an entry.

KHO blocks can't guarantee the last part. The iterator returns a void *
that the caller casts to its own struct, so it is up to the caller to
not read fields beyond the entry size. Please document that callers must
check the entry size before accessing fields that may not be present.

