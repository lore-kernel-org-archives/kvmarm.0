Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BE94E73A9
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 17:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792084679; cv=none; b=lo22Y66+ljagsVEyvJd/5IpsLucMk2y3cVmwm2ZMxtgK3+iGnThpMaEx3Jmtj4wntuUVPeqL6U2qiQAwBBJRNA41MbORUJ4RV/YfDNC+zG6NPdKouiSmh4+rWcA6UQxGPNa9fdL+BR8Rk1JWvPbfA9CEiDclDMxVSIJLI9T/dfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792084679; c=relaxed/simple;
	bh=97nz3x4cCT7jJVkf7khGZ92jWq9O4MzPPIoGZFfCE3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KZYvphNm1bXHkLI54FxTM3W1gZddzch5U1Jm8LDoi+a4Fg+V0eeP4V2oKzjetpUjkaOGEU5F+yMjghFHqFe+Kn8xvpFyqscxf4Yc9u2iFFFwehUzOwX5M9fDFfTpNBr/sS7gpZ5zgXAqf59ZqexvWazrNzpOybKtACtwNUG4Hoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BpXyloR5; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BpXyloR5"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-486e70f2457so889166f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 10:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792084669; x=1792689469; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nUb4cagls44kE5et9qrliHAU76p7w/thb7bKXpN7Lxs=;
        b=BpXyloR5zsnCOAOreYmL88y4UaQoHORCNIp19MgNMDKgC+Qmch8Idk9dC9J/tHXgLY
         XhEx0Djoi73/0I+d68ZUNwPMthn/arGJsRgziQp5HZpbT7hVaM5PpCYaZaiKVdX1yqQp
         uI39xNIZZ2h2OkRMZ8olC6iaccFMvA0a38UH0TfFhWK9cX0emoPSj0jQzop/tNd25P6b
         z3KRxhY0pfUWJQZFa+WMvQmGVqAiDB1IdEeI0767Nfme/LzUWGtLGl/j9HXR0ppBtqwl
         EpYheuEi2oLvVmTysd3O5+F/7jx7SUTocJ67uzxIF4dzlT0LB2WsC51k8PzXgiHlgMoH
         PR2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792084669; x=1792689469;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nUb4cagls44kE5et9qrliHAU76p7w/thb7bKXpN7Lxs=;
        b=fqHlwLxfhwO96cEmpxNfVNjG3fVeK4NwOgjq1NRyYq9MH2vNbTgSYNvIVKRruXchtC
         yHQARY8BpKrtb+CWV7NvdruFv1eG5hXxmGZ51gxhDDu4OKvlFFSRiavfuOi3WrjSfZRW
         oJegUH3Ty7LsmpTIfJfx9igfXgR+E1ANKGaVFdepoN4JeZKLYPI8ft3o022Q6hd9z1cD
         n9L/nVu2wJoFQbXLS3DhARFRE4jQ5bcIJCslMLYjpEqdZ9lsr6vlR5sYEtJrN/XYCSfA
         aTNspBjv4mZkqAIJFr37paylKEPTdSgd3aHMkoWOWL0FN4NFhwqdsuhq6B1sv9av+h/8
         s1fg==
X-Forwarded-Encrypted: i=1; AKwUvBx5MBQziYHZDsLUBb/kj3HD8cA/NA2ih8787wjDF2bL+hz44Uow4TSXJG2U1BZ4WFvUV//6AHU=@lists.linux.dev
X-Gm-Message-State: AFq9FYIkPjJoNdGWxUIgIEIxmx1AgKT/spv9yWhPupYC+P5gqdQPZvEI
	YGl2PZetRayhJ3kJNQBnaV74ALpS0lfPFzBCKWI2LmpB359f7x3s5xOT
X-Gm-Gg: AYBFou2R4HeMipq85Fm2U2L/Jt9ctDL89w+0hhtOlQknUcK5tcV2k/r0TpVRQDzsE8B
	B5LLPWxPWc4RzQq5NVTBDF//9lOm3x3PuX67qtzNHvYYXlDKAdRT06gj2iTMmnzPqc+8lqH23RQ
	VQanaP5Wi5k0aX8mSv1BWvlK3sMZqwebr4+03FwprD7DPxDzdipT5yTDI0PP8bJX/Ylh0ADVSnp
	X1Rb4VAHs5pRSL3eQNnn+IvyeCoQ8qXI52w4/heL02TwKZQMQ/IGU1CNLaYiBXHKect4Dn8KwF1
	ZguqoYjaedw5Y0tE5QIuUjycsMNqTa6SHWeomsMVsBdJObrBGq1DGUlIU7wr/2DI5jfRRc8QNBD
	kHFa26WDDZrKU9f9Xls9hwIJ4569YzFueQGJ09KWVaVoS9eY2paBD4TvslIvL+FHz7/zoe7Qs6D
	TxVmpo54Ab4YPfgcymEXvrzcU7ycA9RyqDs4WasrnwZDeyuDrzVa5WXsPyVUUbQzps8L/fs5Uf/
	VKN0yXd0nfdAq1LekbnIWFbkXwsErw+E2MIIwsnc8N7MPfnT2k/7IPbwbb8qAzH+JdYMpox4/NB
	ecrk7FIikoW8M+F6LCIpkaMt1MIIoQscW/I=
X-Received: by 2002:a5d:44cd:0:b0:488:89e4:c3af with SMTP id ffacd0b85a97d-48dbaae4869mr30499724f8f.45.1792084668569;
        Thu, 15 Oct 2026 10:17:48 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfaf1acd7sm1180327f8f.1.2026.10.15.10.17.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Oct 2026 10:17:48 -0700 (PDT)
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
Date: Thu, 15 Oct 2026 17:17:46 +0000
Message-ID: <20261015171746.51538-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAEvNRgHtB8j6=9r=txjsKvQM0F85nRN4KW5sdnuv_-Og=cWEfg@mail.gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org> <20261006183235.16576-1-griffoul@gmail.com> <CAEvNRgEseLO+LbkwXrEit0H2LH5Wx-srSvHEMpt0=upPL3tF=g@mail.gmail.com> <20261014095702.39676-1-griffoul@gmail.com> <CAEvNRgHtB8j6=9r=txjsKvQM0F85nRN4KW5sdnuv_-Og=cWEfg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Ackerley Tng <ackerleytng@google.com> writes:

> To borrow David's words, the part about this that makes me itch is
> conversion. We have to support conversions. Even if it doesn't merge in
> the first patch series, we have to have line of sight to how conversions
> would work.
>
> Conversion requests originate from the guest and then the host handles
> the guest request by making calling an ioctl on guest_memfd. Hopefully
> this part doesn't change with alternative provider support.

Agreed, and it doesn't change. Conversions still go through
guest_memfd. It is the only one that knows which pages are private.

> Suppose guest_memfd still gets the conversion request first, in RFCv2,
> to reach all the mappings in various page tables, it would have to be
>
> + [GUEST_MEMFD] -> [KVM], [USERSPACE]
> + [GUEST_MEMFD] -> [PROVIDER] -> [IOMMU]
>
> since guest_memfd must ensure no IOMMU mappings to guest private pages?
> There's that extra step through the [PROVIDER]...

Right, there is a step through [PROVIDER]. But it can be a step through
the mem_provider code in mm, which every provider shares, rather than
through each provider driver. Then guest_memfd doesn't need to know who
else maps the frames, and providers don't have to get it right one by
one.

Here is the idea, on top of your in-place conversion. The VMM gives the
same provider file to guest_memfd and to iommufd, as in v2. When
guest_memfd converts a range to private, it claims the range:

  int mem_provider_claim(struct mem_provider_attachment *att,
                         loff_t offset, loff_t len);
  void mem_provider_unclaim(struct mem_provider_attachment *att,
                            loff_t offset, loff_t len);

The claim revokes the range for every other consumer of the file. After
that, get_page() returns a hole to them. So iommufd unmaps the pages
and can't map them again, and nothing changes on the iommufd side.
guest_memfd zaps its own mappings, as it does today.

Going back to shared is the reverse. guest_memfd returns the frames to
the host first, then unclaims the range. The other consumers then map
the frames again. So a conversion looks like:

  [GUEST_MEMFD] -> [KVM], [USERSPACE]
  [GUEST_MEMFD] -> [PROVIDER] -> [IOMMU]

That is your second chain, but the [PROVIDER] step is the common code
in mm/mem_provider.c. It does the revokes and hands out the holes. The
provider driver itself only gets one callback, and it can refuse a
claim. For example, it would refuse if it also lends those frames
through another file. Conversions can already fail, so this fits. If a
later step fails, guest_memfd just unclaims the range.

This also answers your earlier question. The provider doesn't need to
know what is shared or private. It only needs to know which ranges are
claimed, so that it doesn't move or share them, and only takes them
back once the guest has given them up.

I haven't implemented this yet. My plan is to rebase on kvm-x86 next,
which has your conversion code. Then I'd demo it with a
KVM_X86_SW_PROTECTED_VM and the sample provider. A device sees a shared
page, loses it when the page becomes private, and sees the same frame
again when it goes back to shared.

Does that match what you have in mind?

> Thanks, I will prototype what I have in mind too to make sure things
> work as I think they will :)

Thanks, that would really help. The sample provider and the KVM
selftest in the series could be a starting point.

Thanks,
Fred
