Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A74B31A572
	for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 09:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791799086; cv=none; b=jJsT9OJBGQ9EpxLyreEMK5/hquXYIjb2yZkRqvWKaBvF15EUcn2COfrls7jYwDz18ly72Wh98DkD1OisIEwxAGCUCzzFz8C4nmrt3B2ycax8X79Qx8JI6sPFJFXxROOV+sPVPJacDUiM8v91KRkjqOwA+nazVcZ/0/JcsPWv4Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791799086; c=relaxed/simple;
	bh=8okIb6HYVMsdy6+U5xUzJ+gBO/rOBVZ3zjrTun8vSUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qh4CE7hfQInZkHSdkg55PPQGMEmt6JwMpHlXxPI9R8XzyojV1RLyGB22E7P+r69xcBa5Cy4tEwXl/Q8Mz6p8wEPxdJXA5MQmlxcDVLCwVlk50HMxAVIF3U726eL22PbN7xaMNLGjoXOWeYvW65YlOTbOYcRW7Nioa6ncBrAlrcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q36tnJt8; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q36tnJt8"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6af9cc73235so1176777a12.0
        for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 02:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791799082; x=1792403882; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8okIb6HYVMsdy6+U5xUzJ+gBO/rOBVZ3zjrTun8vSUo=;
        b=q36tnJt8YgPGTRVA2zqhtvRvjL/aWTgE+ohzWe/fUBXnLgAZBfhKoPxUkkgPVJh03o
         d7n6Jw9UNUENT3zUU5gQhXkqB9rbcG6L9I/ZJgQQ+7oTmseT5CmKK5KtipO23i1lgw1t
         itZmtttdAjO4U5eCNJiRPFm1y756lPJI6bv66wHUVKlX0yNpygQQ+zh+DEupI43neMvk
         l7D/fbk5lyGmSF46eqrG+cVcp6/LEwHKVZdIEe4VRqNCLfPm0wTzuJg0EeZ7sWlPycqi
         KMwKch0CdQkwadDRn9HmjdOb0d3+N9bxurbBtHKhJO4YJUBk3KK7vWzBc/1hyG5TDYHV
         1Y4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791799082; x=1792403882;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8okIb6HYVMsdy6+U5xUzJ+gBO/rOBVZ3zjrTun8vSUo=;
        b=rdTLkmoRUyFaoCbDAyfzsn4KcOlzb5WCeyMMxsOBs3SLun8EmT6WPvCrqWNLOk59SN
         Wk3OlhLQ35VVEScKyU2rKYK6xXTOF5R8gLSpHrzBeSE11kBFzKMpIgCXN6OcphYPfcHC
         JxUqtggkzgHYyfxqAbbO98yxH7N7DxmHYKqQ5zU4IUcsyZySvdUlPjOdFZRp8nL1Nvju
         OStRMHeI3z1aT8TUzYNMbJeLCcs25uQN3hhAsrSmWflorhUig/I2jWM6HOSW+llFBxxi
         vgFZjJRF9/dAi6wFC2CjmTalAxn5FqGWQDKouSW5qerb2YSrZ5+B0jB+6SmT6xzBtYfI
         cUbg==
X-Forwarded-Encrypted: i=1; AKwUvBzP4uU9GVfLqCfqHWjh0CefYqVWZ2tLaTkhuGOuwjfgjaCVp1sZOrLiQXmimh7TsJZyTP5rDpQ=@lists.linux.dev
X-Gm-Message-State: AFq9FYIdeGa0xFRyiB52eio0PHNS3w4KYAsWWuM6H2azH+WsjeLk0oKV
	HefEfPIqP3UTBFKefUnqkNpCe/Ma6EIQZP5cAQ1cq+NE5dtbhwUlD17B
X-Gm-Gg: AYBFou3A3MIBaGCTPKQnpmEefmoVpbF9vtYkgbBCxO+gpoO+H/Ytqn7ymTYkjbYzWsY
	+rmfOiPsq9k9gcfUEBbQ6t41oyyw2mf5a6cumLDD8wC2458htQj7d6XSyiIl5rUzAl2Ei2U1OXs
	A/9a+d5Jk/8zKO914Sbgpn1S51IGcaOBlrqy/CQUriPBqf3Gv9E9q6DfX9/pDSNk+7wIXBxi6nt
	KvDErnoiTbZFH43cUUVkXML3n0Aryy5MP1lkN8VRxEs07DEezjjrCsCz52Z/+3B27XKm+ICU6+y
	u9fmOf5wFtsmxN0xHbUH3RSoblExrb+GVRxDoOyNxNxmIAAUiood+ijFoGN/IJz5DpmGCHwXk3t
	sVyHOOKThfeypkDWmf1rSmpxv13iRGtbfxXRVvdiY+I7e/V1KEVJHWmku6KJed7sq6XyKkKNH79
	vx2WEn5Z9SRUkQ/UjWBmwDixnGurDjunRvk7DHM6uQtrGNNQcYcW4wr2Wj5n8RpdK5YDNeiBzzz
	biQPj8K0oYdD0co1ulM3xe+YbUkyc8ghqALP8ZycurGOkIi5koATFGLvi6HEgL3tg3nglr0u9oe
	a4Kvs2/3YJz+hW2BUjGX/tqkOz8nSEVSuMsP7WD/qIZSLA==
X-Received: by 2002:a17:906:f59d:b0:c2a:b008:8cc0 with SMTP id a640c23a62f3a-c31a70e5566mr981263366b.28.1791799082342;
        Mon, 12 Oct 2026 02:58:02 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b178d1605fsm4928885a12.2.2026.10.12.02.58.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2026 02:58:01 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
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
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
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
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] mm: Memory providers for guest_memfd and iommufd
Date: Mon, 12 Oct 2026 09:58:00 +0000
Message-ID: <20261012095800.50250-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <yq5ald8680t2.fsf@kernel.org>
References: <20260720111259.122911-1-dwmw2@infradead.org> <20261006183235.16576-1-griffoul@gmail.com> <yq5ald8680t2.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Sat, Oct 10, 2026, Aneesh Kumar K.V wrote:
> I have been working on something similar for confidential computing use
> cases. There is likely some overlap between this series and what I posted
> at [1].
>
> I have not reviewed this series in detail yet, but I will compare the two
> approaches and identify what can be shared between the use cases. Please
> let me know how you would like to proceed.
>
> [1] https://lore.kernel.org/all/20261010072504.536230-1-aneesh.kumar@kernel.org/

Thanks for the pointer. I read your series, and Ackerley's resource fd
RFC that it builds on. The use cases differ, but the interfaces overlap,
and it would be good to agree on the common parts.

All three series add a flag and an fd to KVM_CREATE_GUEST_MEMFD. I
think one resource_fd is enough, with guest_memfd picking the backend
from the kind of file it gets. I am happy to drop provider_fd for
Ackerley's flag and field. We also find the provider from the file in
three different ways; I would like us to pick one, preferably without
a registry.

The main constraint on our side is that the provider stays the authority
on which frame backs which page: it moves pages between VMs and has to
survive a live update. What would not work for us is guest_memfd
becoming the primary manager of PFN memory, as Ackerley suggests. Your
get_pfn() leaves VFIO as the authority for the BAR, so I think we agree
there.

You refuse dma-buf exports while guest_memfd is attached. That is
roughly what the memory provider interface is for: one owner, several
users, and one revoke that reaches all of them. A BAR exposed as a
provider file could be mapped by both guest_memfd and iommufd.

I plan to change the revoke anyway, because iommufd must not leave the
device with a hole: it should replace mappings in place instead of
unmapping and remapping. Would that fit your case? I suspect it depends
on locking, for example whether you have to revoke while holding
memory_lock.

Shared/private state and the conversion hooks would stay in
guest_memfd and the arch code, as in your series.

Does that sound reasonable? Ackerley, David, any thoughts?

Thanks,
Fred
