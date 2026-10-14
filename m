Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B604DF4AC
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 09:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791971829; cv=none; b=a0T2xNaW4dCzNPpEsSyt8G/MBzxn7FZB+58b38dabn5GkAShqQq50lJ/pwOFlJqYSVjxs7YNMu6dWjT7qI9w2NnHmERv+fnhU2Sz4zqxaHw2j6AnztFXw6hmFzQ8Y61UuIA8VV/MMyWxgj07Hz0Y8GWWmgYxzZ2ICj30JSDz70k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791971829; c=relaxed/simple;
	bh=qA69ri66dsMoSQKZKokr8N+gVHGTbzuvnNDHG21QYWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VuDlj3p5otCgfK2ZHNU8loLLOktB6MXPJ7rGGqpNEKuKdkF/OppaIrdPay2ncSrWhWkY5ipdhT4WA4U1DjhqTygEvnZb4XyAiI6pyLUlHZ+w70Qbl+Rk9flPjjsJQEXkNZ//pVquPNkR5cBJvjGWA0E8jItbPJY5yKRQLa7/8AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EKZFATO0; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EKZFATO0"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a1698ea378so32290175e9.2
        for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 02:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791971824; x=1792576624; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JhQ5yirY83poEzPx8x3H8aN7RnWItIKkuGofgEQwLq8=;
        b=EKZFATO0MH7u7TkdkA+HreJfWb/32uc+jHHdfRsHZ49S7jB7rciDRhRB6rEkI59v3z
         Fjx1IbK9FqN7WuUJnsuNi1HIKHyHPzNODLeiE92G3v2Ej05Q88AG3RAiWIJBZGSfYA4U
         wgJ66xQTaQ+ov6mtaKg/EMqySXiDRpDPKsxRaUNJAyX9G/Q436yUTqB/fzv8/r4Me+zm
         e/AYLjGTaVm4EiEsqrk7lmfOW4/735k8A1BitebvXn57f3A6m4GtluB/SUWFYZ3WwXW/
         9kERYkPBTNFpgcXpASmySdhIqWOaFjqbAQY+Aeb48xY8x7E6iVB8VZYiVjvAtD9ZB8z2
         DgdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791971824; x=1792576624;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JhQ5yirY83poEzPx8x3H8aN7RnWItIKkuGofgEQwLq8=;
        b=Akb7Bc8ZUpOQOsm2AuujMUzE7x+CX+x/ZvtvKp0DOpBUXVJY86VTlTnRGQEBr5mKny
         pkmkX/KC+3I/FmUQzCgBvQi4xNijPRiruSYVn9t+vuCOrqGR8M/r4ae/soOv1AaSbDI5
         ML3GhkwBBIiirXCMkiUIx6by8PjHH6wxpWpI9BbaVVGUApnU6Ui8EdbDjHUJc3NhNm0B
         IKoEaJZQHDza7aKXrrqgxTNjj87pbKBTsNrTeHsThmnpLTIsiW7vpaPY1CXpK6HW0IgQ
         4xywNMWb5ZmVH8SkzSUOKjvpjIy8RXWV9eabm9kty97DjoXRjskkfQxgmPOeRyEKWj9e
         MgAA==
X-Forwarded-Encrypted: i=1; AKwUvBxMLOhyfRhLGThfDZo/AgAv16sfBLUhDk1mYm9BcE++Bxdstx8WQyzFdeitMYh8PCKEbPv25B0=@lists.linux.dev
X-Gm-Message-State: AFq9FYIUE6RWhnI8T7IUOn5qKXHhEG9grog3JKcFt79L6Xc2AQDL4Sne
	AW8cwLx7ROgpg8TEjMobAK2uDBJy3Hipuk9GFEAm6SIU4C8k/OFYWoD/
X-Gm-Gg: AYBFou3fllyTVQgWkatbI3GuhcQbk1rtC/AEbviDiXZPyo/wm7CMGD4nKENbj6lHEbQ
	sJSSatmcBUXVd4GI5g//iBl5cH/K7tY3tcc/x9u7kYlN931lH9KocBv5lWX0QfYsgEUWQEVVA/c
	Z7IGEeQu+Gk+hRQ6wx0S1Dnqj2UrB+xwUAMnPOVFJzCYM9QcmWo1wVT8wFZKU/1bP4oHOJGl+00
	mqKGwyIIfnt6AOfwD0JLzrrjqS4BO4ll8z326Vzn5damOlTbmqMf52NuYVZK8qS34nVdumCnAPj
	97/KLdsNae4sKxRP+T7vO2XO5hGwoHz+9SltZLwgnI8//1Lm6K8ALDipDltPselzoJjwp6ZTBRR
	EA/v42j69bpklF1NsKo5xVZDltigqUkBIwFHHdpDvuX7jhrOw5zxFev2cCG4wmdeqUD9c7BFwia
	bxIrUtwo5aVBv+hMmcqCK6JEOG4F23sBgEKVWmtEf3qcjwEQwBayimza5UiM8zSSGE5wbkLryjW
	NDAAmgrBKo75MrI/VRMP6UkZCFTA9CeFKrZ+41Kw29+f2CS/io9N7uTOQjrOn3DhbOAXaPmovCm
	UmQ0pxFApwmifIMPiKCHz2XO3cYlHQE+g/4E
X-Received: by 2002:a05:600c:4747:b0:4a1:80d8:aed0 with SMTP id 5b1f17b1804b1-4a18e4a9862mr311763425e9.15.1791971824195;
        Wed, 14 Oct 2026 02:57:04 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0ac5257sm11206338f8f.42.2026.10.14.02.57.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Oct 2026 02:57:03 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Ackerley Tng <ackerleytng@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] mm: Memory providers for guest_memfd and iommufd
Date: Wed, 14 Oct 2026 09:57:02 +0000
Message-ID: <20261014095702.39676-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAEvNRgEseLO+LbkwXrEit0H2LH5Wx-srSvHEMpt0=upPL3tF=g@mail.gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org> <20261006183235.16576-1-griffoul@gmail.com> <CAEvNRgEseLO+LbkwXrEit0H2LH5Wx-srSvHEMpt0=upPL3tF=g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Ackerley Tng <ackerleytng@google.com> writes:

> When the provider wants to revoke the page, the notifications/function
> calls flow this way, the last [ENTITY] in the chain actually does the
> zapping.
>
> + [PROVIDER] -> [KVM]
> + [PROVIDER] -> [DMABUF] -> [IOMMU]
> + [PROVIDER] -> [GUEST_MEMFD] -> [USERSPACE] (AFAICT this was not
>   implemented in the RFC.)

Thanks for going through it. I have just posted v2:

  https://lore.kernel.org/all/20261014093733.90312-1-griffoul@gmail.com/

It changes two of these chains. dma-buf is gone: iommufd attaches to
the provider file itself, through a small interface in mm. And
guest_memfd now maps the file into userspace from the provider's
frames, so a revoke also zaps the VMM's mapping:

  [PROVIDER] -> [GUEST_MEMFD] -> [KVM], [USERSPACE]
  [PROVIDER] -> [IOMMU]

> IIUC guest_memfd conversions was not illustrated in the RFC: what
> happens on a shared -> private conversion?

There are none yet. Only VMs of type KVM_X86_DEFAULT_VM can use a
provider, so all their memory is shared.

> Does your provider need to know if some memory was transitioned between
> shared/private states? The provider can be notified too, if
> necessary. If not, then isn't guest_memfd doing all the coordination
> better than going via the provider?

Our provider does not need to know, and I agree: once there is private
memory, guest_memfd converts the pages, so it should tell the others
what to zap.

I think the two models meet there, and the v2 cover letter now says so.
The iommufd side of v2 does not pin and keeps no references: it asks for
the frame behind each page, treats a page with no frame as a hole, and
maps again on a revoke. guest_memfd can offer that for its own file:
shared pages return their frames, private pages are holes, and
guest_memfd revokes a range whenever it converts it, in either
direction. That is your [GUEST_MEMFD] -> [IOMMU], and it should work for
folio-backed guest_memfd without memfd_pin_folios() or refcounts, as
long as guest_memfd also revokes a range before it frees its folios.

The one difference is that v2 also lets iommufd map a provider file
directly. Going through guest_memfd would add nothing without private
memory: it would only pass each revoke on. And memory that only devices
use, such as MMIO, does not go through guest_memfd at all. Both paths
would use the same iommufd code.

> Does the revocation model work for you? If it helps, I can rebuild the
> sample provider to illustrate how the revocation can be done.

Yes, the revocation model works for us. v2 replaces David's sample
with one that moves, donates and makes pages read-only, and a selftest
that checks the guest, the device and the VMM's mapping after each
change. It may be a good base if you want to try guest_memfd as the
provider for iommufd on top of it.

> 4. [DIRECTMAP] Kernel direct map.

Agreed, that is separate. The memory we have in mind is a range hidden
from the host with memmap=, so it is not in the direct map.

Thanks,
Fred
