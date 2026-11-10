Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794322065;
	b=a2LjgThB4tQZVueaZGKNjuoaLsFrKDSmoTYqOfm2+OydJ1J9Ct6E1v4zx/3TuL7ZYnhJ
	 84NIEnB+m+LuQOVIGU7aYQ6wnGwV8vsyw5c7CZLXeCIYvUGR46BYHsUAmXh6gwPQRV3fA
	 tqZOQb+Q7WKNl8MBuVbc/pZBzwGV2MUhqqBkW2T1WnuKbVkmiA8hmZfCexJOxxl7F0iQF
	 vFbqMYZHMz1wZRyzyaRuSxqBRUTZRJz5grsAxDySaStD3fJrDVRB+QUdBczI5mGTjdmx3
	 AKE4aGc1G8c9MfaKxmNimvETEoutadMcfdiCNLMM9mylOfPDcOoUvkm1Fc5KltSXnog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794322065;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=wsmZfHZmE1Rq7H1s1zpsPGYsOnEWBjtJgjdw36cOKzU=;
	b=y3Waut0u2aqXMqiLSW4qRU1Jx3HqLQWiEz9kxpOKZ1I8aY/oXgPK+MPhJaM8a/m2Buap
	 wJrg2KYpY0HaiaLZ6LSY2vahNedQFkUeFV56HfYSHAEYbG63jto1+FhrpXBE83O1OguLe
	 c+2ApuDft53vlyVR1qJjXziOJyJQm5b6mNOaAQVhKhnWF8ANYu2Xn1zXw9NlKyWNJcN6W
	 DB6RbQNptdF3Ouutgbu/UXz2BbEan+6JZz7s6IyoAG+jt8qP127iOtFvWdZtBS4tpBVf4
	 fRQnHW8RVbkoozBh9cDb8srYCWWcDOpZ0zNV8jwRC6/maKrEwnRHDisogN9zOePd7xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=CgqslMaz;
	arc=none smtp.remote-ip=209.85.217.46
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCDE60A263C
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 14:47:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDCDE60A263C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=CgqslMaz
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-7d2dbe5c4b0so703867137.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 06:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794322063; x=1794926863; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wsmZfHZmE1Rq7H1s1zpsPGYsOnEWBjtJgjdw36cOKzU=;
        b=CgqslMazslvAEhCXF/dQQXOIhli225UdMhxhzjvpaIm874bXlnUnBjDBHjFh0GJEZp
         jReme1EcwZFbASQff1BBIXCvc+eLu9SUGSsjDXos7c2edFF3lMDS+ep45JRS/BbHDIAZ
         uNT29Zn+5P5Z/xxgdL9CgshG11TO9+4Q9GLNeUxvOO1RkaZ1lukOIrdWVXfDKwxuqsiR
         39twyNx1hK3Mfc7FJiWk7PbC1xOhXLnroJSMWxQwvUdtly6phcp64dDLH4emDaO0AghE
         8EXIqEm+SWOAFySonHbw/10eXfljIiExUuCH3Ad2J6AL3gx0dNynRES7To+g39jmwf8e
         NnKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794322063; x=1794926863;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wsmZfHZmE1Rq7H1s1zpsPGYsOnEWBjtJgjdw36cOKzU=;
        b=TNgZhCj7ffCJ16v+ac699BTm0Yusb2Esrn2yHXmPAwkCri3suGxF4CzwXyqcLjjn/j
         mKKDwAWQ94qT1zClwt+Nrq4ghvQddhqOXwtEJB5ncLs6bF74EBSRLjFCDstm3jDhqYOr
         ESfDkkY9iEn/k8YK8rlP+F6T5jLSCirzpg321zLgUaGs9BXXK4xphUd9YEjUKHmQQEaj
         O/vl4yaqXmpHxuSTKqM/Ccpg7vdD1GRutlfg+S37xjxX2zErznOLzuGGez5+b+ZLQY0N
         XTR7lsw79PGdyjfgX5+q/DKidGRDvKeOWP9vcIG48j/1HzffCFyCCrZNXZmUtaUQiEFA
         AA0Q==
X-Forwarded-Encrypted: i=1; AL+hErGHmlHSKta5408hqzf4lQn9nTbRXH2uBvwfU6JGhDmQ7bJmqmRvy3VWatQRL8L8LW2DAtfaW48=@lists.linux.dev
X-Gm-Message-State: APuU4Z+bq91nX1ok9I1sxc6ufoiGtwdhJbDiKMSfllTJaBQJB113aVrf
	xnle5O2y9Kg363jCHNibulTtIwcXCcVa9asMDkY2ts01Vnuz+UX/qfqF5BWgKrjWvEs=
X-Gm-Gg: AYBFou1QRu3A2wKV82jec04/6m50+vBUAaC5ZMQIeqcka0dSXf0w3DsZYD5MDmeIooO
	3ZSRYh4+RX9VKvyxxJJVCrjzzya4qpzwuW5Yfq6mkF5LeZoc470btTIAf8KJfAsArkyotA4xaUG
	qZdBegXhOBP82tTMAlo+ANOzTOLQURZR5yK+Mq6j/4pxmF9bj/pgdkMfkafLnjTGAPwQzPhk4Vq
	+BkqHec4JDhg/bsAmCp4jxJp7frrOxf1mhO2kLadRafLW28uK/ZX/VcDOZRIZes05UNLM235iHW
	V/liXyBRsN5ATqvItCdRSW7NwYzgPMpJXt8ChixULGSBY7Neis+UdRnaVLujZ0LKfpmYa8Ba3/O
	nl9HzhQhVjqUjJyro79PwMagpdh/8OOl41H2VVKxsQJh3LfzZIne0oisHWfHv4Am1VthyA0Y1FZ
	STboLvc+S+8VBY+FO+F847ZslpermO4NFdWYd7ytA5CHn9B4ARywSLoU825gljjl8p0JwEs+7+U
	5l6qcnh1BLDtIL0CnKiWSIbjHGSOLEjuEsUNjnS6LFJW4JPmeTGH4PIrwJOIJ166VFvbPjFDNzj
	p00ehqqhek8/NmsPgi4/B3Xzt3DgFeCAlTMR0kLZ1ISHl9zXMHp9IG9hKUHXRkU66djIL09QkMr
	xSCSGjthTEFTyvle7Q4IPrhrNcsBNEvjrvN2SH4R/fdzxQdw=
X-Received: by 2002:a05:6102:8545:20b0:7ce:78f9:adf2 with SMTP id ada2fe7eead31-7d301b83b3amr570625137.9.1794322062505;
        Tue, 10 Nov 2026 06:47:42 -0800 (PST)
Received: from soleen.c.googlers.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99c2003b37csm1895903241.6.2026.11.10.06.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 06:47:41 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI
 compatibility
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, maz@kernel.org, 
 will@kernel.org, David Matlack <dmatlack@google.com>, 
 Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, 
 loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org, 
 baolu.lu@linux.intel.com, Bjorn Helgaas <bhelgaas@google.com>, 
 oupton@kernel.org, alex@shazbot.org, gle.com@google.com, 
 pbonzini@redhat.com, Andrew Morton <akpm@linux-foundation.org>, 
 kevin.tian@intel.com, joro@8bytes.org, kvmarm@lists.linux.dev, 
 linux-pci@vger.kernel.org, Pratyush Yadav <pratyush@kernel.org>, 
 kexec@lists.infradead.org, kvm@vger.kernel.org, iommu@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, skhawaja@google.com, sagis@google.com, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261110050202.529473-6-tarunsahu@google.com>
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-6-tarunsahu@google.com>
Date: Tue, 10 Nov 2026 09:47:35 -0500
Message-Id: <179432205559.2329176.3035981527541971699.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=22528;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=uDJhRLQFyAFvS1XggtjKlr4S7TK6dXpzWoFT/Nbd24Y=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq8y6LJvOvflb5TAokbmkAAlLkGbDN0PKKxSlaM
 zbmKy/X8K+JAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCavMuiwAKCRC7dyhM23N6
 3qPPD/9GJpxZPaX0RvVkHzUeyWGkOPZJ5dBxpjhvHr9eSA9ar/L2OjrFGzb+UUDdsyvtBVb5VCB
 5o5bs3he/MRfSVT+DSlNHyiU1onalGmvXGiWkBqg2cSMvP8HtvP8l8mSGOoNKpVFT71Uj+R5ToZ
 DB1mc58Rm0UyPkQvZ7RRwfiXYiRFkmQYRWOSXeAwEUxKseW1v1k9IEF0vaJEYaXVTXjjgiJ9IOz
 iGdngqwwDzkQjq73FbbaRNY6PzdU6eJe31/Iwo6mhj/wfFD6u2o4vx2wZBZLNJJuk9wEcNM23co
 xtteW+aBr5hx3ZnnNAI9Yg20cAu2Yyd7zq+hz0Nka5tBCXcpcPMMHIRnXenF02X+G80twYInwHD
 xEiYL7tXdwttVG0AiUupUE7BpslS3ZIwwn2jH6DU3lVLV0bC76+ZhbOmsVXlnsTDan3A/7MqeoD
 3kw91xJI7IYG7g4lGnAU9jnK6q2MgIPxHplhNPnmeJxgZR6+o8u0mvzea+xXNpO/eEPA9tve3dR
 WXN3XtgYNTob1yZf4j0KprCn0zMLGhA9JC9PJ/DBYE0YcK3up9p3XrjivyKarYNQcEad0DjKEU/
 B7exXXFGONOaEhLYhnQ+jFY1maFQFhRrNaueAiHN3QRa589YcK8nHxakuNGdq+G6yRKurgnhz4u
 jI4J2WZ9n1nhPGw==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569

> Serialized structures in KHO and Live Update Orchestrator currently rely
> on whole-structure compatibility strings or monolithic version fields to
> validate handed-over state across kexec. Any change to a serialized
> structure, even an optional additive field, requires bumping the
> compatibility string or version number and breaks live update between
> adjacent kernels.
> 
> Introduce a generic feature header (struct kho_ser_hdr) for serialized
> binary structures in include/linux/kho/abi/feature.h. Each subsystem
> groups the fields of its serialized structure under feature indices,
> starting with index 0 for base fields. When a subsystem adds a new
> capability, it appends new fields to the end of its payload structure
> under a new feature index. Retired fields are kept in place so existing
> field offsets never shift; if the type or format of a field needs to
> change, the existing field and feature are kept intact until retired and
> a new feature index with an appended field of the new type is added.
> Only when a change requires a complete break in the serialized layout or
> semantics that feature flags cannot handle, a new handler or format can
> be introduced with an incremented version number.
> 
> Each feature belongs to either a required feature space or an optional
> feature space. Both spaces are numbered independently starting from 0.
> In the serialized header, required features occupy the first nr_required
> bits, followed immediately by nr_optional bits for optional features:
> 
>   struct kho_ser_hdr {
>           __u32 size;
>           __u16 nr_required;
>           __u16 nr_optional;
>           __aligned_u64 flags[];
>   };
> 
> A set bit indicates that the feature is present in the payload. The
> truth table for deserialization:
> 
>   Source bit       Target            Action
>   Not set          -                 Accept: feature absent
>   Optional set     unknown or known  Accept: ignore or use the data
>   Required set     known             Accept: use the feature data
>   Required set     unknown           Reject: -EOPNOTSUPP
> 
> During deserialization, the target kernel only validates required
> features: if the source set any required feature bit at or beyond the
> known required feature count of the target kernel, validation fails with
> -EOPNOTSUPP. Optional features are never rejected; the target kernel
> simply checks whether known optional features are present before reading
> their data.
> 
> No subsystem defines feature flags yet. Every converted structure is
> registered with 0 required and 0 optional features, producing a compact
> 8-byte header with no flags entries. Feature enums can be added later as
> needed, once the first additive feature is introduced for a particular
> serialized structure. With nr_required set to 0, kho_ser_validate()
> rejects any incoming required feature bit while ignoring optional bits,
> allowing future kernels with additive features to evolve smoothly in
> both directions.
> 
> Each subsystem registers its serialized structure with:
> 
>         DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional)
> 
> This establishes compile-time assertions and provides type-checked
> helpers: kho_ser_size() for total allocation size, kho_ser_init() to
> initialize the header, kho_ser_payload() to access the typed payload at
> its dynamic offset, and kho_ser_validate() to validate required features
> during restoration. DECLARE_KHO_SER_HDR(name, *fhdr) declares a struct
> kho_ser_hdr pointer while verifying at compile time that name was
> registered with DECLARE_KHO_SER(), allowing callers to document which
> structure a feature header pointer represents.
> 
> An example demonstrating how a hypothetical structure defines its
> features:
> 
>   enum foo_ser_required {
>           FOO_SER_REQ_BAR,
>           __FOO_SER_NR_REQUIRED,
>   };
> 
>   enum foo_ser_optional {
>           FOO_SER_OPT_BAZ,
>           __FOO_SER_NR_OPTIONAL,
>   };
> 
>   struct foo_ser {
>           __u64 base;     /* base fields, always present */
>           __u64 bar;      /* FOO_SER_REQ_BAR */
>           __u64 baz;      /* FOO_SER_OPT_BAZ */
>   };
> 
>   DECLARE_KHO_SER(foo_ser, 24,
>                   __FOO_SER_NR_REQUIRED, __FOO_SER_NR_OPTIONAL);
> 
>   /* Serialize */
>   kho_ser_init(fhdr, foo_ser);
>   ser = kho_ser_payload(fhdr, foo_ser);
>   ser->bar = ...;
>   kho_ser_set_required(fhdr, FOO_SER_REQ_BAR);
>   ser->baz = ...;
>   kho_ser_set_optional(fhdr, FOO_SER_OPT_BAZ);
> 
>   /* Restore */
>   err = kho_ser_validate(fhdr, foo_ser);
>   ser = kho_ser_payload(fhdr, foo_ser);
>   if (kho_ser_has_required(fhdr, FOO_SER_REQ_BAR))
>           use ser->bar;
>   if (kho_ser_has_optional(fhdr, FOO_SER_OPT_BAZ))
>           use ser->baz;
> 
> Required and optional features each have their own enum, numbered
> independently from 0. New features are only appended at the end of their
> enum, never reordered or reused. The last entry of each enum (e.g.
> __FOO_SER_NR_REQUIRED) is the feature count passed to DECLARE_KHO_SER and
> stays last. The fields of a new feature are appended at the end of the
> payload. A reader accesses the fields of a feature only when its bit is set
> in the incoming header (kho_ser_has_required() or kho_ser_has_optional()),
> because an older source kernel does not serialize them. Use required for
> data the target must understand to restore correctly, and optional for
> data it can safely ignore. Variable length data that follows the payload,
> such as an array of entries, starts at fhdr->size, the size recorded by the
> source kernel, so it stays correct when a later feature appends fields to
> the payload. Document that serialization helpers describe this kernel's
> layout while deserialization helpers follow the incoming header.
> 
> Suggested-by: David Matlack <dmatlack@google.com>
> Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>
> diff --git a/include/linux/kho/abi/feature.h b/include/linux/kho/abi/feature.h
> new file mode 100644
> index 000000000000..55ff1b9e9b73
> --- /dev/null
> +++ b/include/linux/kho/abi/feature.h
> @@ -0,0 +1,372 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/**
> + * DOC: KHO Serialization Feature Header ABI
> + *
> + * Generic feature header for serialized binary data structures preserved
> + * across kexec via KHO or Live Update Orchestrator (LUO).

via KHO or LUO.

> + *
> + * Serialized structures start with an 8-byte base header (struct kho_ser_hdr)
> + * containing the total structure size (size, including header, flags, and
> + * payload) in bytes, the number of required features (nr_required), and the
> + * number of optional features (nr_optional). Following the header is a
> + * flexible array of 64-bit flags entries (flags[]) containing one bit per
> + * feature.
> + *
> + * Feature bits:
> + *   - Required feature N is at bit N of flags[].
> + *   - Optional feature N is at bit (nr_required + N) of flags[].
> + *   - The number of __u64 entries in flags[] is
> + *     DIV_ROUND_UP(nr_required + nr_optional, 64).
> + *   - When nr_required == 0 and nr_optional == 0, flags[] has zero entries
> + *     and the header is exactly 8 bytes.

The above is not needed in the documentation.

> + *
> + * A set bit indicates that the feature is present in the payload.
> + *
> + * Deserialization truth table:
> + *
> + *   Source bit       Target            Action
> + *   ----------       ------            ------
> + *   Not set          -                 Accept: feature absent
> + *   Optional set     unknown or known  Accept: ignore or use the data
> + *   Required set     known             Accept: use the feature data
> + *   Required set     unknown           Reject: -EOPNOTSUPP
> + *
> + * Validation trusts the incoming header: only set required feature bits at or
> + * beyond the target's known required feature count are rejected (-EOPNOTSUPP).
> + * Optional feature bits are never validated.
> + *

We can shorten the comment below (and commit message as well); there is 
no need to include sample code showing how the header is implemented in 
the doc comment. Too much stuff that is not really useful to the reader.

> + * Defining features:
> + *
> + * A serialized structure defines its features using enums and registers with
> + * DECLARE_KHO_SER()::
> + *
> + *   enum foo_ser_required {
> + *           FOO_SER_REQ_BAR,
> + *           __FOO_SER_NR_REQUIRED,
> + *   };
> + *
> + *   enum foo_ser_optional {
> + *           FOO_SER_OPT_BAZ,
> + *           __FOO_SER_NR_OPTIONAL,
> + *   };
> + *
> + *   struct foo_ser {
> + *           __u64 base;     // base fields, always present
> + *           __u64 bar;      // FOO_SER_REQ_BAR
> + *           __u64 baz;      // FOO_SER_OPT_BAZ
> + *   };
> + *
> + *   DECLARE_KHO_SER(foo_ser, 24,
> + *                   __FOO_SER_NR_REQUIRED, __FOO_SER_NR_OPTIONAL);
> + *
> + *   // Serialize
> + *   kho_ser_init(fhdr, foo_ser);
> + *   ser = kho_ser_payload(fhdr, foo_ser);
> + *   ser->bar = ...;
> + *   kho_ser_set_required(fhdr, FOO_SER_REQ_BAR);
> + *   ser->baz = ...;
> + *   kho_ser_set_optional(fhdr, FOO_SER_OPT_BAZ);
> + *
> + *   // Restore
> + *   err = kho_ser_validate(fhdr, foo_ser);
> + *   ser = kho_ser_payload(fhdr, foo_ser);
> + *   if (kho_ser_has_required(fhdr, FOO_SER_REQ_BAR))
> + *           use ser->bar;
> + *   if (kho_ser_has_optional(fhdr, FOO_SER_OPT_BAZ))
> + *           use ser->baz;
> + *
> + * Rules:
> + *   - Required and optional features each have their own enum, numbered
> + *     independently from 0.
> + *   - New features are only appended at the end of their enum, never
> + *     reordered or reused.
> + *   - The last entry of each enum (e.g. __FOO_SER_NR_REQUIRED) is the
> + *     feature count passed to DECLARE_KHO_SER and stays last.
> + *   - The fields of a new feature are appended at the end of the payload.
> + *   - A reader accesses the fields of a feature only when its bit is set in
> + *     the incoming header (kho_ser_has_required() or
> + *     kho_ser_has_optional()), because an older source kernel does not
> + *     serialize them.
> + *   - Use required for data the target must understand to restore
> + *     correctly, and optional for data it can safely ignore.
> + *   - Variable length data that follows the payload, such as an array of
> + *     entries, starts at fhdr->size, the size recorded by the source kernel,
> + *     so it stays correct when a later feature appends fields to the
> + *     payload.
> + *
> + * Writing and reading:
> + *
> + * kho_ser_size(), kho_ser_init(), kho_ser_set_required() and
> + * kho_ser_set_optional() (and the clear variants) use the values this
> + * kernel registered with DECLARE_KHO_SER(), so they describe this
> + * kernel's layout and are used when serializing.
> + *
> + * A reader of handed-over data uses only the incoming header:
> + * kho_ser_validate(), kho_ser_hdr_size(), kho_ser_payload(),
> + * kho_ser_has_required(), kho_ser_has_optional() and fhdr->size, so
> + * it follows the layout of the kernel that wrote the data. On data
> + * this kernel serialized, these give the same result.
> + *
> + * Use DECLARE_KHO_SER_HDR(name, *fhdr) (or const
> + * DECLARE_KHO_SER_HDR(name, *fhdr)) to document which registered
> + * structure a feature header pointer belongs to while verifying at
> + * compile time that the structure is registered with DECLARE_KHO_SER().
> + */
> +
> +#ifndef _LINUX_KHO_ABI_FEATURE_H
> +#define _LINUX_KHO_ABI_FEATURE_H
> +
> +#include <linux/build_bug.h>
> +#include <linux/err.h>
> +#include <linux/errno.h>
> +#include <linux/math.h>
> +#include <linux/string.h>
> +#include <linux/types.h>
> +
> +/**
> + * struct kho_ser_hdr - Header for serialized data structures in KHO.
> + * @size:        Total size in bytes (header + flags + payload).
> + * @nr_required: Number of required features known to the source kernel.
> + * @nr_optional: Number of optional features known to the source kernel.
> + * @flags:       Bitmask of present features (required, then optional).
> + */

Let's avoid tab-aligning the new doc comment. Apparently, that is not 
ideal because it makes future maintenance harder; each line must be 
re-aligned whenever longer fields are added.

> +struct kho_ser_hdr {
> +	__u32 size;
> +	__u16 nr_required;
> +	__u16 nr_optional;
> +	__aligned_u64 flags[];
> +};
> +

Please use u32/u16/u64, this is not uapi.

> +static_assert(sizeof(struct kho_ser_hdr) == 8);
> +static_assert(__alignof__(struct kho_ser_hdr) == 8);
> +
> +#define KHO_SER_NR_FLAGS(nr_required, nr_optional) \
> +	DIV_ROUND_UP((__u32)(nr_required) + (__u32)(nr_optional), 64)
> +
> +/**
> + * kho_ser_hdr_size - Calculate header size in bytes including flags.
> + * @fhdr: Pointer to the serialization header.
> + *
> + * Return: Size of the header and flags array in bytes.
> + */
> +static inline size_t kho_ser_hdr_size(const struct kho_ser_hdr *fhdr)
> +{
> +	return sizeof(*fhdr) + sizeof(__u64) *
> +		KHO_SER_NR_FLAGS(fhdr->nr_required, fhdr->nr_optional);
> +}
> +
> +/**
> + * kho_ser_set_required - Mark a required feature present in the payload.
> + * @fhdr:  Pointer to the serialization header.
> + * @feat: Required feature index to set.
> + */
> +static inline void kho_ser_set_required(struct kho_ser_hdr *fhdr, unsigned int feat)
> +{
> +	if (feat < fhdr->nr_required)
> +		fhdr->flags[feat / 64] |= 1ULL << (feat % 64);
> +}
> +
> +/**
> + * kho_ser_clear_required - Clear a required feature in the payload.
> + * @fhdr:  Pointer to the serialization header.
> + * @feat: Required feature index to clear.
> + */
> +static inline void kho_ser_clear_required(struct kho_ser_hdr *fhdr, unsigned int feat)
> +{
> +	if (feat < fhdr->nr_required)
> +		fhdr->flags[feat / 64] &= ~(1ULL << (feat % 64));
> +}
> +
> +/**
> + * kho_ser_set_optional - Mark an optional feature present in the payload.
> + * @fhdr:  Pointer to the serialization header.
> + * @feat: Optional feature index to set.
> + */
> +static inline void kho_ser_set_optional(struct kho_ser_hdr *fhdr, unsigned int feat)
> +{
> +	if (feat < fhdr->nr_optional) {
> +		unsigned int bit = (unsigned int)fhdr->nr_required + feat;
> +
> +		fhdr->flags[bit / 64] |= 1ULL << (bit % 64);
> +	}
> +}
> +
> +/**
> + * kho_ser_clear_optional - Clear an optional feature in the payload.
> + * @fhdr:  Pointer to the serialization header.
> + * @feat: Optional feature index to clear.
> + */
> +static inline void kho_ser_clear_optional(struct kho_ser_hdr *fhdr, unsigned int feat)
> +{
> +	if (feat < fhdr->nr_optional) {
> +		unsigned int bit = (unsigned int)fhdr->nr_required + feat;
> +
> +		fhdr->flags[bit / 64] &= ~(1ULL << (bit % 64));
> +	}
> +}
> +
> +/**
> + * kho_ser_has_required - Check if a required feature is present in the payload.
> + * @fhdr:  Pointer to the serialization header.
> + * @feat: Required feature index to check.
> + *
> + * Return: True if the feature is present, false otherwise or if the index
> + *         exceeds the header's known required feature count.
> + */
> +static inline bool kho_ser_has_required(const struct kho_ser_hdr *fhdr,
> +					unsigned int feat)
> +{
> +	if (feat >= fhdr->nr_required)
> +		return false;
> +	return !!(fhdr->flags[feat / 64] & (1ULL << (feat % 64)));
> +}
> +
> +/**
> + * kho_ser_has_optional - Check if an optional feature is present in the payload.
> + * @fhdr:  Pointer to the serialization header.
> + * @feat: Optional feature index to check.
> + *
> + * Return: True if the feature is present, false otherwise or if the index
> + *         exceeds the header's known optional feature count.
> + */
> +static inline bool kho_ser_has_optional(const struct kho_ser_hdr *fhdr,
> +					unsigned int feat)
> +{
> +	unsigned int bit;
> +
> +	if (feat >= fhdr->nr_optional)
> +		return false;
> +	bit = (unsigned int)fhdr->nr_required + feat;
> +	return !!(fhdr->flags[bit / 64] & (1ULL << (bit % 64)));
> +}
> +
> +/**
> + * __kho_ser_init - Initialize a serialization header and flags.
> + * @fhdr:          Pointer to the memory for the serialization header.
> + * @payload_size: Size of the payload structure in bytes.
> + * @nr_required:  Number of required features known by the caller.
> + * @nr_optional:  Number of optional features known by the caller.
> + */
> +static inline void __kho_ser_init(struct kho_ser_hdr *fhdr, __u32 payload_size,
> +				  __u16 nr_required, __u16 nr_optional)
> +{
> +	__u32 nr_flags = KHO_SER_NR_FLAGS(nr_required, nr_optional);
> +
> +	fhdr->size = sizeof(*fhdr) + sizeof(__u64) * nr_flags + payload_size;
> +	fhdr->nr_required = nr_required;
> +	fhdr->nr_optional = nr_optional;
> +	memset(fhdr->flags, 0, sizeof(__u64) * nr_flags);
> +}
> +
> +/**
> + * __kho_ser_payload - Return pointer to the payload following the header.
> + * @fhdr: Pointer to the serialization header.
> + *
> + * Return: Pointer to payload memory immediately after the flags array.
> + */
> +static inline void *__kho_ser_payload(const struct kho_ser_hdr *fhdr)
> +{
> +	return (void *)((const char *)fhdr + kho_ser_hdr_size(fhdr));
> +}
> +
> +/**
> + * __kho_ser_validate - Validate an incoming header against target capabilities.
> + * @fhdr:                Pointer to the serialization header.
> + * @target_nr_required: Number of required features supported by the target.
> + *
> + * Checks that the source did not set any required feature bits that the target
> + * kernel does not support (index >= @target_nr_required).
> + *
> + * Return: 0 if all required features are supported, or -EOPNOTSUPP on failure.
> + */
> +static inline int __kho_ser_validate(const struct kho_ser_hdr *fhdr,
> +				     __u16 target_nr_required)
> +{
> +	unsigned int i;
> +
> +	for (i = target_nr_required; i < fhdr->nr_required; i++) {
> +		if (fhdr->flags[i / 64] & (1ULL << (i % 64)))
> +			return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * DECLARE_KHO_SER - Register a serialized payload structure with KHO.
> + * @name:         Structure tag name (e.g. luo_ser).
> + * @payload_size: Compile-time expected size of struct @name in bytes.
> + * @nr_required:  Total number of defined required features.
> + * @nr_optional:  Total number of defined optional features.
> + *
> + * Size and 8-byte alignment are asserted under CONFIG_64BIT: KHO and LUO are
> + * 64-bit only, while !CONFIG_KEXEC_HANDOVER stubs pull ABI headers into
> + * 32-bit builds where u64 has 4-byte or 2-byte alignment.
> + */
> +#define DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional)	\
> +	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
> +		      sizeof(struct name) == (payload_size),		\
> +		      "struct " #name " size mismatch");		\
> +	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
> +		      __alignof__(struct name) == 8,			\
> +		      "struct " #name " must be 8-byte aligned");	\
> +	extern struct kho_ser_hdr __kho_ser_hdr_##name;			\
> +	enum {								\
> +		__KHO_SER_SIZE_##name = (payload_size),			\
> +		__KHO_SER_NR_REQUIRED_##name = (nr_required),		\
> +		__KHO_SER_NR_OPTIONAL_##name = (nr_optional),		\
> +	}
> +
> +/**
> + * DECLARE_KHO_SER_HDR - Declare a feature header variable, field, or parameter.
> + * @name: Structure tag name registered with DECLARE_KHO_SER().
> + * @decl: Declarator (e.g. *fhdr, **out_fhdr, or * inside DECLARE_KHOSER_PTR).
> + *
> + * Declares @decl with type struct kho_ser_hdr while checking at compile time
> + * that @name was registered with DECLARE_KHO_SER(), documenting which
> + * serialized payload structure a feature header pointer belongs to.
> + */
> +#define DECLARE_KHO_SER_HDR(name, decl)	typeof(__kho_ser_hdr_##name) decl
> +
> +/**
> + * kho_ser_size - Total size of header, flags, and payload for a structure.
> + * @name: Structure tag name registered with DECLARE_KHO_SER().
> + */
> +#define kho_ser_size(name)						\
> +	(sizeof(struct kho_ser_hdr) +					\
> +	 sizeof(__u64) * KHO_SER_NR_FLAGS(__KHO_SER_NR_REQUIRED_##name,	\
> +					  __KHO_SER_NR_OPTIONAL_##name) +\
> +	 __KHO_SER_SIZE_##name)
> +
> +/**
> + * kho_ser_init - Initialize a serialization header for a registered structure.
> + * @fhdr:  Pointer to allocated memory.
> + * @name: Structure tag name registered with DECLARE_KHO_SER().
> + */
> +#define kho_ser_init(fhdr, name)						\
> +	__kho_ser_init((fhdr), __KHO_SER_SIZE_##name,			\
> +		       __KHO_SER_NR_REQUIRED_##name,			\
> +		       __KHO_SER_NR_OPTIONAL_##name)
> +
> +/**
> + * kho_ser_payload - Return typed pointer to payload following the header.
> + * @fhdr:  Pointer to the serialization header.
> + * @name: Structure tag name registered with DECLARE_KHO_SER().
> + *
> + * The first operand only fails the build when DECLARE_KHO_SER(name) is
> + * missing.
> + */
> +#define kho_ser_payload(fhdr, name)					\
> +	((void)__KHO_SER_SIZE_##name,					\
> +	 (struct name *)__kho_ser_payload(fhdr))
> +
> +/**
> + * kho_ser_validate - Validate incoming required features for a structure.
> + * @fhdr:  Pointer to the incoming serialization header.
> + * @name: Structure tag name registered with DECLARE_KHO_SER().
> + */
> +#define kho_ser_validate(fhdr, name)					\
> +	__kho_ser_validate((fhdr), __KHO_SER_NR_REQUIRED_##name)
> +
> +#endif /* _LINUX_KHO_ABI_FEATURE_H */

Headers under include/linux/kho/abi/ are meant to describe the ABI 
layout only, so include/linux/kho/abi/feature.h should only contain the 
struct and declaration macros actually used by kho/abi/*.h headers:

- struct kho_ser_hdr (and its static_asserts)
- DECLARE_KHO_SER()
- DECLARE_KHO_SER_HDR()

Everything else here (KHO_SER_NR_FLAGS(), kho_ser_hdr_size(), 
kho_ser_size(), kho_ser_init(), kho_ser_payload(), kho_ser_validate(), 
kho_ser_{set,clear,has}_{required,optional}(), and the __kho_ser_*() 
helpers) is kernel runtime helper code and should be moved to 
include/linux/kexec_handover.h (which also avoids pulling string.h, 
math.h, err.h, and errno.h into the ABI header).

-- 
Pasha

