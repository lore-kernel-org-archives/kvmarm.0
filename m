Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19823474267
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 10:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792148288; cv=none; b=eOUyX7X00bvRi0h6e4/tsxsJu6ky4/pWX17HCgGue4CaSGJ8LCcanDAncdkS5/OiipW2oSy3Dcb6aY9E+A9trGA7UbqUZV3Ai6Oo4k3M7UAqIG7pJLiegBzSCD4DVf1rIE320zXBrAmFr7PbvdLiyuHJno+J/4l8pqQGeBjPYY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792148288; c=relaxed/simple;
	bh=Fg04sF4wbeMFqUdM8zmoRfU3uiwkIyCVmr/Efwdeo90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nodXIjlkWrz57rmlZC8JgY17HkJeqKhbzKWL7rMvyMvyH6JU2rlDGfegbaicfkTGAjKLTiJreyjDI1tB0cRymOX1A/27rTeG4AYAeQv+t/kX3Ig/MDPY4nF89eVv7FEzDJEOAWPEKRniNzXEyyBAnstxxrR6m7m/SoMjVGpJc+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rdKU3Ex0; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rdKU3Ex0"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a17baef589so27224035e9.0
        for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 03:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792148275; x=1792753075; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JjoY/Y//bNqM95eGJvwXGt/YGARtJeL2jF1lkb5NGWs=;
        b=rdKU3Ex0BJB3RKleH37Jpa5Od03LCfCIAFW/iQcsXbyqjMJ5EVpVB9LKCjDKRn5+aq
         bYaVIp3Xsn4bVi0WeriwZG8eZYNYX68UXwJsA0NvCnn9losA/n4bBTqNV3WgeWaWw2uC
         oXe52PRlQxx/urS5KIM3wY6XLwBw7caVov62Kt2fEdiYnrZAMXFXilIbl/Z8mGZNvVTJ
         +m2t7Q8UzeR5guqhXMN3qOMiehCxunmYrN+YINobbbZGidoWJ/VH6ImzFW65Yz13Qt5L
         xNLAaM5hkneSN8YBmfrPVWtooDjyuBdGU0BwHDyUvWhrEcczyWH5tWInrmeLMIhjD2vF
         6etA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792148275; x=1792753075;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JjoY/Y//bNqM95eGJvwXGt/YGARtJeL2jF1lkb5NGWs=;
        b=lFtBZaKdXWZEdIWzOXg8KphcjKzNUNv6VvHgZxeeIiBGFEFhwYu5AUH1xKra1Tyv2U
         m22OK/QaToLvYgPs36RjjIEfRQ0bmMBVpOHM2tAQ9uyE29k8rm/Lm+pq/XbKrX7j0Tbi
         aN5EKlSEOnwrzkCnAx+yorsqKedzu/aXibnLZ7lBwwx7dq65rPQjMMWrCcHXitQfKwfb
         0inZ69eihdDTmpDcoGhqJjKG7pFxdEgtG/pEOiQXrx0ZymD0Hkhz5GTquW5L1ZTmtSSq
         pV3/nE6PGE5xOLfvjVD+AtJfFElu8Fm1OY0bg1pPVyKQ2doDWE30Pv4pc9eVMCtgIjiD
         dDIg==
X-Forwarded-Encrypted: i=1; AKwUvBxEvwYc5MbjOTZQChvo1R+KgV5l7eQvrenFiU+M2VLBuvPhGML7Qyvm8ku3XB1Xs3XqQ0iiwoI=@lists.linux.dev
X-Gm-Message-State: AFq9FYLouCDW/AEgA10l6YZ4miWPliIMMzyGAnVu8J6yc4izhAX0WeQW
	Qz5K/ULHl1brUE2rehqEk16gdmH+b9VC2xev4AWMRPtnDe2Yud5OP9Z0
X-Gm-Gg: AYBFou1pWQ6iq1seFwBVguf8grlCGesUt6YyAQ+NqPkElB50cpWugexa8diQcS0EMGi
	N8l5iGXQXFttn0pSJyCAcWC63Yewa3WM8Ljy71prU9IgC4ptdax5PJ6TjpTmnZ4u3yS8H/udoz+
	vZV0/9iSSgKivpPkZddDQtXF2fyV18Ntf+qL1MBE68QJ+0CuUiWjvC/cxjGPf1TxpW0B5ZDZ7up
	o0zRi6pMmNUPKVuqRbvfOYfQcvAt/KKUrdhMfmGQbfPkjYXZeCGZBqtnmz2WJOi3An0qwtfDl8E
	zpnntkmuUYvr/0I+a01qlgd/OpPB/DWFViEnf/BPwYkc+PmciUjAaAxxdi+B+NZrpRIvrIT6nJ2
	DbOaEsLin37VLUpF7CPTNABNwjEy72pDgh734/E3lkkvYmFwcBKX/CaegpaseebfQGJb9EWceLG
	qpm/r1MBp2y2wpFVx91YbaCMbMGtTRQ2BThpy9WM8UQbemINtI6i4ZTvsO+1vRA9Mt7oyp1eMJ6
	r3zlh0UIkY+XHyEc7goCpevYx8F035gaAIBmi+mV1UWydDBUhCwBgXE91mktxQuLTZ7q1ZhOLyw
	ja/ytGnBq9BTPJDdGS+Tlga7U69AmwBBu+s=
X-Received: by 2002:a05:600d:82c8:b0:4a1:cedc:ab51 with SMTP id 5b1f17b1804b1-4a1cedcac09mr30065765e9.35.1792148274917;
        Fri, 16 Oct 2026 03:57:54 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1c8ae6d2esm50003685e9.6.2026.10.16.03.57.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Oct 2026 03:57:54 -0700 (PDT)
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
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
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
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/11] mm: Memory providers for guest_memfd and iommufd
Date: Fri, 16 Oct 2026 10:57:52 +0000
Message-ID: <20261016105752.68015-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <yq5a4iem57qv.fsf@kernel.org>
References: <20261014093733.90312-1-griffoul@gmail.com> <yq5a4iem57qv.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Aneesh Kumar K.V <aneesh.kumar@kernel.org> writes:

> What confused me was the introduction of memory providers as a subsystem
> in their own. What we really need is the ability to map PFNs from
> other subsystems into KVM stage-2 and into subsystems such as iommufd?.
>
> Restricting the scope to the above, at least initially, would make this
> much easier to reason about.

Thanks for looking at it. I should have explained this better in the
cover letter.

A memory provider is the driver that owns some memory, like a carve-out
or a device BAR. It lends pages to whoever maps them, and it can take
any of them back later. guest_memfd is one user of that memory, and
iommufd is another, but neither depends on the other.

With this series, iommufd can map a provider file without any VM. Today
it cannot map such memory, because memory without struct page cannot be
pinned. For example, a host service that recycles provider memory
between VMs could clear it with a DMA engine driven through VFIO and
iommufd, instead of the CPU. And since such memory can outlive the
process, or a kexec of the host, a network or storage dataplane could
restart or be updated without losing its DMA buffers.

> For my use case, the VFIO fd becomes the backing provider (referred to
> as backend below). We can create a guest_memfd using that
> resource_fd, allowing MMIO BAR ranges to be mapped into KVM stage-2.

That fits well. VFIO could be a provider for its BARs: get_page()
reports the BAR frames with the MMIO type. guest_memfd takes the VFIO fd
as resource_fd, and iommufd can map the same fd. That could also replace
the dma-buf plus symbol_get() path that iommufd uses for vfio-pci today.

> Another feature provided by this series is the ability to map the same
> range into iommufd. We probably want to restrict this to shared ranges.
> It may be simpler for guest_memfd to drive this.

Agreed that guest_memfd must drive shared and private. I replied to
Ackerley on how that could work with the provider interface:

  https://lore.kernel.org/all/20261015171746.51538-1-griffoul@gmail.com/

In short, on a conversion to private, guest_memfd claims the range on
the provider file. The provider code in mm then revokes it for every
other consumer, iommufd included, and hands them holes until guest_memfd
unclaims it. So guest_memfd stays in charge of conversions, and
iommufd only ever maps shared pages, without going through guest_memfd.

> Currently, a private-to-shared conversion causes a VM exit, followed by
> an IOAS_MAP for the newly shared range. Could using guest_memfd with
> IOAS_MAP_FILE avoid this?

Yes, the IOAS_MAP goes away. The conversion itself still comes through
the VMM, but once guest_memfd unclaims the range, iommufd maps the
pages again on its own.

> Perhaps the series could be rearranged as follows:
>
> - Allow a guest_memfd fd to be used with IOAS_MAP_FILE.
> - Add a VFIO or other backend for guest_memfd, without calling it a provider.
> - Add support for guest_memfd to provide guest PFNs to other subsystems
>   through its file descriptor.

I'd rather not make guest_memfd the only way in. With kvm_gmem_ops,
each backend implements a guest_memfd: it binds memslots, invalidates
KVM's mappings, handles the host mapping, and for confidential VMs
prepares the frames and gives them back to the host. That puts KVM
internals in every driver. With a provider, the driver only reports its
frames and revokes them, and guest_memfd does the KVM side once, for
every provider.

Your diagram already uses mem_provider_ops between guest_memfd and
iommufd. It is the same interface: get the frame behind a page, and
revoke a range. So I'd define it once and let drivers use it too. That
also covers the cases above, where there is no VM and no guest_memfd to
go through.

guest_memfd can still provide its own file to iommufd where there is no
provider behind it, for a guest_memfd that allocates folios. That would
use the same interface, and the same iommufd code.

Would that work for your VFIO case?

Thanks,
Fred
