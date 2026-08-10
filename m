Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAE442C517
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 23:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786404195; cv=none; b=iQw695n6+K0eSNvuUfCJHyx5gLwQ4vep+gqU0aXTFe+o87zTUfP/Clmib9AknR7j1tcKZ9tIyW37qk2RPVeT95oQYaUJcIo3Utt/qZsaMJ4KaEl8UjQCSIGStT1Zt7Rq6WH808q2ldLeUeVF7Hi/81GxJH93XclxRXLZO1Supuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786404195; c=relaxed/simple;
	bh=6riWePLyH2qYVpMlK+T7n9ft2OfONf7BSNufpXaF5IY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fjCfMqcBxJoyvHhhERzHr5ZhVsRfYu4JTSwx7YLv/nIQ5mUrc2PObdjIRNxVatkZ/Rsh8TedOdQJ5n09gwpN2Iqprfi0cDdL3qE5tE6W8mlcgeF7qO0sGssqLvZB1eN29vixxPL9YDSXE7/Anb6SyO5TnGR3SaHkkQdm9Z7mqe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MU7CORaj; arc=none smtp.client-ip=209.85.214.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MU7CORaj"
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cc5faecf01so4534935ad.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 16:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786404193; x=1787008993; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FpMqKDZdeqkAxP+HMbo4Vf8RyrsMvHYCAM3HPa8Xz3s=;
        b=MU7CORajfU+YnOwYQdWWr7rmWPUVg43jEhMkzlOuPXXH7FvhrESrcDJW+jRnn3OZcE
         +HV7v86Mgm0OG/u0OZi+lW/T2WzIRKFC3VLUDq5r3om8LltnzNSnUVASOWYbu28g2zAd
         swLl57j3HmvJlY9rD7ZtoJWUllQ3924czgMUE2xEc5CSJSz4WrAjwstWY0mRA+Gduhq3
         UrFnsWyT0jOR/wo53pTUVkKDB5B8E8iopRhXvV8sU1aRGZ/oLmXUR1+Ro1bItX0btZ2e
         lACoFpSshqSqSH3rMP3GlXL4YuZBH0Fbz2aidItRQpb3c9sx7xBR2+KKc7AP8xAFUO4v
         dRcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786404193; x=1787008993;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FpMqKDZdeqkAxP+HMbo4Vf8RyrsMvHYCAM3HPa8Xz3s=;
        b=n1nh+IXUZJdSXEWBSjQ2K20ffj3Z75Q2Q9CIKju5FC2G+LDurrN9mJ1/HphBV54NyJ
         bHBoYyXvkQAann/le0R8OZnsvXVJNNF/F++rZ2wjDptl9nAxXCLX2U4c2rVRnh39IvX3
         E+5CVwZoTd6IIzWBehzEwGdiHXax8Hm/DndFlnY3/Pm2TUsupHHVhMofaouMnQQ0+rKm
         6drfProq9VN1BcvhZa/ebvdEBiNgx7RSU/9m5Zr8x3a1LT2MOIaK0cE26qcOj1evN8pP
         FLgeQnhQVKBv317LNHKAcKP2NR5ucup2Ja2tNa+cFZiRtX8PXbfTLR8GQA/aIGH+LOKX
         50Vw==
X-Forwarded-Encrypted: i=1; AHgh+Roju6GNA8npUhYIlxYnxTmD+qX4IPjDr3ZJZiFLp4QDTaVql8yV34CLCLKtpTJAnh2DJnEij7o=@lists.linux.dev
X-Gm-Message-State: AOJu0YzyZY4fGYFQhEPn2hOwWoOKlK1q0xpe/Ypt8PM22wIlwSnnusSn
	Cls2Y6z3LhWdhwR3/c+azJv52kQxrhPMfNpFTlwx2qh5qY7dGtHg4zk+24rp+TxfAwf/7US2Zsi
	GY/W+KQ==
X-Received: from plkb4.prod.google.com ([2002:a17:903:fa4:b0:2c0:a516:2c2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fdad:b0:2bf:9760:b94d
 with SMTP id d9443c01a7336-2d0ca7fd072mr611571635ad.15.1786404192685; Mon, 10
 Aug 2026 16:23:12 -0700 (PDT)
Date: Mon, 10 Aug 2026 16:23:12 -0700
In-Reply-To: <20260728121138.1103610-5-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-5-tarunsahu@google.com>
Message-ID: <anpdYD1UaO0ffQgi@google.com>
Subject: Re: [PATCH v4 04/11] KVM: Track weak reference to vm_file in struct kvm
From: Sean Christopherson <seanjc@google.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 28, 2026, Tarun Sahu wrote:
> - Add a weak reference 'vm_file' in struct kvm under

"vm_file" is effectively already claimed by vm_area_struct.vm_file.  *If* we go
this route, I would very strongly prefer to take a dependency on "vfio: Use
file-based reference counting for KVM"[*].  I'll poke that thread, we really
should land that one particular patch long before the s390-is-arm64 insanity.

Empashish on "if" because this all feels backwards.  It's not at all clear to
me why liveupdate goes directly to guest_memfd, but then requires a token associated
with the VM.

https://lore.kernel.org/all/20260731130902.654679-2-seiden@linux.ibm.com
