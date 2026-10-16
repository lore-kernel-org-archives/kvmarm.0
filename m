Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5D83F58E8
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 09:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792143976; cv=none; b=evUolGUw6P+1IDS/Vu9pbWOpax/FJdigOnx6ACdvVfl2c0FbJ5XAMeadh16A+kEEFuZRRWvKkm0yN4iagJzSZx9hbfG5lDscfoRpsP4cdSHYmNdRYusoEqEAsZk3+aH6vB6tRwb/PO7ciV2DL2Z/piJ+i/u63OzLdQ8byYfVMpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792143976; c=relaxed/simple;
	bh=WBdGcxWiDrcVKqaT6IjY7dlU/wWj/hMB+CXmv51CihE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VaAPH12kN5qsTmWokC2+4BcxlgpTGTP1Yssg3yEACaNFb5bHG3/ii6lJWAgVImvOpXDLXfQxFjeBPIkdr0EarpI9v2Mum6kSrzSyL5B5lNci+PvQtiRYsbgiwBJoG5og8k8bsCWvSR3WDDcLmDxlkpCzlU2QEjjYrnTUOlwluek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=URjumONf; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="URjumONf"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a16af2a232so48552225e9.1
        for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 02:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792143973; x=1792748773; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WBdGcxWiDrcVKqaT6IjY7dlU/wWj/hMB+CXmv51CihE=;
        b=URjumONfcfryt1WgeuAqgjRYS5Y9e/PDeAZq5vW+4zjAtO2opeCvVefEdusMUjQFdc
         p18kJCWeg0he0Fyk0wVyF0tyf2VahpI2s+k+dC3y/pNBDbBxenOGktoqLxkIPc+o7keB
         ACaNSuXTDaZmcCQjGI+txXujwnEsM4xIsndA9HfW7V6LYZal8kuPitoVQnkuQdG5NZZE
         kXWW8oHMTCB20QNdKwz9byhh8JM0cMWp1GLwSdF5cHfjGmTvgkGjgWMe2+TstmW79Z+b
         kuDlU7jSw5I0+GY0XIKz7CbaazIMVXUW63DvIS8d7GqgQHKsa2irApbWuHmql+PHfm3x
         9GdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792143973; x=1792748773;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WBdGcxWiDrcVKqaT6IjY7dlU/wWj/hMB+CXmv51CihE=;
        b=mY0uu2MyO/vvLhMROZ8xnKqZauS7vZNSvvT44509N7+a4BmWiuKJXNsd+/YLYDipYs
         4ExUfQaCS0WA9ViiFnk98Z3w96En96Q8XjUb4NcwdXSlMfY4xeiYT7rWrNudgi1ghkym
         qBW4Q3gc4eo4DyB9qaLVaZcRbBm0wUbxzsAxhHdd+1t3isTxSNxZZmtJ7smIrF2fVVq3
         HEH0C8jbr58zdu2gfYWlJ0OBokvXudBF3foeeB6zEl0zwIhK26q15KKkrigdKCGR0vhb
         i9eL9i2eVu3YgDomhHEV5UYyycgGg9KaSZljTNK9yhsFbQdWKiH4pESAo0zCFEh5Kgkk
         QZjw==
X-Forwarded-Encrypted: i=1; AKwUvByDOE0li4QOQ54+M1DKjFDmXpOCiWPgk61KUL08nDkjgt4su0F35eu2PfgySOPkY6acB32t8bs=@lists.linux.dev
X-Gm-Message-State: AFq9FYLsmT2ewQG51Awh/v10efLEi4o5HeD/3o6zJTIeSupGzUDp6NXW
	6ZtNwFv9xxAMhV0lSAnBhQTIlfEwyu130z8QpCa9lJos/eQBZbQs9MJWHrLRd20IMME26g==
X-Gm-Gg: AYBFou2cV9uaAjH1OmHNaa8c9XgLm+duIgOqmjcDpUL7kM5Sa+N4x684+SMqB9HNyjA
	YkGzk1cGyU7m8KluNR3v3uBXUoevsi5LbWlusDDg1cNl9JuiscX/DZfhojy6y4v/uQWFlXm5mPe
	u8TUvmS5Nxwv5XPXOokO5uvl6xQeH2NZbHC4/VQkNIn05FiL+pzrtYPkCLt//9MtnYRk+dl3lZ9
	qibqMujSH6JAxBZ7Csj86kka+VU9iYSH2uVlpfysHdf8S7ITYY/UZo1uPx3Tgv+MmZxQiFyiuTI
	RjkDrcSjuYQqVsadCBQMblc44QDrr0EelfXz0k5h8KfiZIkeUXbbioAdJH8nJU59Yfa6O3Sthah
	gCbD0QISTUsEPDH+YVIVWqJHCy0mIXdiK30b1QxBOtoZBxFPNGl6IoBf/39G6qACDkq+DZX2kEE
	JNVO3iDy7pwlXE3y4cNhRfx0bscKDLqIxmJEu6f1cPM6In0CM9DO6kTpJEKx2kvUBMeMpHhl56P
	aLYGjUVFg+ok5jdaB/WDhngtLpLYFThSzHMdFlmccbLHBxNUzpoCHsWsO1JnCntjEDwqL8MJWuU
	Hy1KXlhxH3IdSTu7400c410srdxtSdpjDt4=
X-Received: by 2002:a05:600c:83c6:b0:4a1:7093:40c7 with SMTP id 5b1f17b1804b1-4a18e493048mr406737735e9.8.1792143972697;
        Fri, 16 Oct 2026 02:46:12 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1cca43012sm17041055e9.3.2026.10.16.02.46.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Oct 2026 02:46:12 -0700 (PDT)
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
	Shuah Khan <skhan@linuxfoundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
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
Subject: Re: [RFC PATCH v2 07/11] iommufd: Use large IOMMU pages for provider mappings
Date: Fri, 16 Oct 2026 09:46:10 +0000
Message-ID: <20261016094610.57849-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261016001448.GC14213@ziepe.ca>
References: <20261014093733.90312-1-griffoul@gmail.com> <20261014093733.90312-8-griffoul@gmail.com> <20261016001448.GC14213@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, Oct 15, 2026 at 09:14:48PM -0300, Jason Gunthorpe wrote:
> You are going to need to go into generic_pt and implement cut and a
> more suitable unmap to make this stuff work properly. We can't over
> unmap on conversions.

Agreed. I'll drop this patch from v3 for now.

Just to check I understand what you have in mind: a cut operation in
generic_pt that splits a large entry in place into smaller ones, so
that the revoke unmaps exactly its range, and iommufd uses large pages
only on domains that support it?

> Also please don't write commit messages with AI. WTF is this even
> trying to say? The subject is "use large pages" and this text says
> "map each page with its own call"

Sorry about that. It goes away with the patch, and I'll check and
rewrite the other commit messages for v3.

Fred
