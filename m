Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794835376;
	b=wuvlKOw+VAbITBNyGf5IhiefkK5wA75mg6DC3Brf5ZqQBGQzfjAkjMPht9dVkwKMy+Gb
	 fPPcmk1fTQjRYhSJFv2xJg5FDoF9+X8RV+IPm/nYwcqNRY1XboWSgPgyrVwE+PvHKPqMc
	 mMlmKhxdUZ5Me7gxsFeRjteF8eH/n0yN9AII6OiYai2QWQZ3vI3CC1uCfaDL73u4d4daS
	 4qsrWx3qthel7Z1UA8oSsNhXpmnrgJGKFMb5lUgYmF/P184aaHpzCXK3qozdD+uIjNR3m
	 WgGx148MrlnKvzxy5AeWEd2PqZkdgkziRfNJdST8/8XtlyyZBIRaUQKvQEAMKcp9k4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794835376;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Ip0og70Tt8f+28eOZ5F6oTc6DjrtMrQ1wymW+Uokrdw=;
	b=ULMm50RyltipzMHYeWvPK7AUfRUg2EGvMVeS+5uGKAXGvL21N2hVC1iyfv+Hl81lpwAn
	 emF6SqnAiRR2OkG9dDEonTE4BQEnlBabKLyTQPZkOiuk6dY42cGvmQLIEjrk7hinaZeHK
	 rzNPRaKxJwY+jxzRoD6wn02Aqlqc/vW7OMDo0X8t57ScnGGJQTlsnbzdu/JLdvlwARkX+
	 y3R1+SMZYgVcEXGOcbIKrbxDEkAQf+C1iDVBKxBD+Yyt5UV1aWz9++poOzGeDintPlHTE
	 0c/q9g7//CiFkMP+qvtwK17XxMT8OQHXErvKjxhLV56OKgSOQhDTnbTbzZh4/98OByQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b="CubF/Gca";
	arc=none smtp.remote-ip=209.85.160.177
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BDC606A331
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 13:22:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96BDC606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=CubF/Gca
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5569551d19dso58960291cf.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 05:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794835375; x=1795440175; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ip0og70Tt8f+28eOZ5F6oTc6DjrtMrQ1wymW+Uokrdw=;
        b=CubF/GcaiGFCo3GZWG2pELmqF4rZ40ATX0kx85qe7Z8AAvQlvgHscvAGv6ruClcDvS
         oeFYKBO9uR/eExr/GZz6leE7D36V+SFmt3HFGpNGIrKY/YHYJVm1fi8VoWVYykbIJTMq
         zle9F8jweprPSbgzRjCw8luh0sWSgzLHNKO+QzIFtvkDzLPvzPQc7ZGWOZdG6mhpnMPP
         Gw0JpzaMQLs4DL9i12WoXZgMbeKDGd82gEw3YDpuezYDws1mr9HVhQGlrn1w3BPIyqsF
         J6EkL1pwH2dTo8otz19u6MQjuEPvZIC8iEiP6O5tvGkeLkFEYS9KJrn5M7yn5Fjdf+Sf
         veVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794835375; x=1795440175;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ip0og70Tt8f+28eOZ5F6oTc6DjrtMrQ1wymW+Uokrdw=;
        b=ZZWIoy3PagJ+bT65h2holQ0U7bPw3PNtKN4wGd2yVRChbcmWjZ/MSig7+QA77ilip+
         IQM4ozyDx8tipGfFwQB6LtJz/onqg03OJEPzNkY68cgg0kH0qWQlVxzohzvpkM1zGQRn
         sw7SnnKauSQKWKA3B+XDFzrUlKcMYBdJxgoNYBXqHBKbCbTG/lUfftZ4TAVJm23u6dGn
         Ty8QYjMIx8PCt6MQChVsRG9/WKG843jxXU7xICMYcYXTdEldyzy6iPKLMFKbGBVL+UYl
         gvel/6fgQepwsw9QJ8VkJVzv6tCbK2+v5k7iSGkPOY9vk0YWFWqCYl+56HPhYCPw4q7n
         SmUA==
X-Forwarded-Encrypted: i=1; AL+hErH4wJii8n4p1f0lb/H3w8ZOvigl4f6Cx8yJDT0YBR8oO38cbDubA6f6l5+nZsttVy6Otv3mmms=@lists.linux.dev
X-Gm-Message-State: APuU4Z9ZRFVRhtW7nPi/t3WAjxjNrsf3PzLO4mvw44hhWJ9Uv12k7nbc
	TwEY5uAXP4i+VIwVI/uG36rhoCytkgSNUX5rm4j1ECJbI0swJN4UC2oAHs413b1UxyA=
X-Gm-Gg: AYBFou3UDgu1a+1GHYXkzng4L15rgdGmNsciMsW1acu3Zsg6PtYfnM86znid1U/jPeu
	IYA3k09gY4hF4wJ76zkahzCVnCmx0YCfonO0n7/z9P6npV0u7LPBwPAR8UhjnppsEntcRGOwYiR
	MmmhgkXaHunSNRI6YBUjY7npNVyMdG6yQR6vRsfCqXQYIfV0l/9wSUZ0BI5TdcRMuh/dOOm1miH
	wf3JjRphpjnrBDzG6FZp2ACPOayX8kihMpmH1Dx5V+Rg07UmcX8jHvg56F/txb12f9hvjnsMn9c
	/SENKE+cvPaEu9M/u6ksWssSodrpmlY2IySwsshnF/H9O6y5F6KnVKUKcNYxPFycUKQ9H5kVw8t
	skMkd1Kx2AuXDlAHdq8WTvOv6WtCzPZy3SvLYC2YEXkbEwdyfyrjkBnekKU5f5EeRmb0UUDe41n
	Hul1bHt8le+uRyz7vS+VcxEK+PiKSxOtGX3GshIW9CWnGLTo10n5cfx7GMM7rO8azYDTAJTcgme
	iAyLgVXCr6+cKhvQM52ufjjAU2y1YHpO4suODKjU7ge3LtVioeuJfLcmzrH/r4XKLkGCpas3Wda
	6G4BcA==
X-Received: by 2002:a05:622a:e190:20b0:55b:9d8d:f29e with SMTP id d75a77b69052e-55b9d8df528mr93734571cf.9.1794835373441;
        Mon, 16 Nov 2026 05:22:53 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55ad0f07afesm80824241cf.16.2026.11.16.05.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 05:22:52 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xSwfb-00000009Kvw-33KL;
	Mon, 16 Nov 2026 09:22:51 -0400
Date: Mon, 16 Nov 2026 09:22:51 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	Michael Roth <michael.roth@amd.com>, pankaj.gupta@amd.com
Subject: Re: [PATCH v10 00/13] coco: guest: Add a shared-granule allocator
 for host-shared memory
Message-ID: <20261116132251.GJ2532299@ziepe.ca>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <0524abf4-2306-4046-aade-c23aa7d1e0e6@arm.com>
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
In-Reply-To: <0524abf4-2306-4046-aade-c23aa7d1e0e6@arm.com>

On Mon, Nov 16, 2026 at 10:09:35AM +0000, Suzuki K Poulose wrote:
> Cc Michael Roth, Alexey, Pankaj Gupta
> 
> On 16/11/2026 09:11, Aneesh Kumar K.V (Arm) wrote:
> > 
> > This series tightens the alignment requirements for buffers that are shared
> > between confidential-computing guests and the host, and adds a common
> > allocator for host-shared memory.
> > 
> > When a guest runs with private memory, buffers shared with the hypervisor
> > are not only accessed by the guest. They are also accessed by the host
> > kernel, and the host may manage the corresponding shared/private state at a
> > granularity larger than the guest page size.
> > 
> > Architectures such as Arm can detect incorrect accesses to Realm physical
> > address space PFNs through GPC faults. However, relying on that as the only
> > line of defence is fragile and can still lead to kernel crashes. The risk
> > is especially visible for shared buffers that are later mmapped into
> > userspace, such as guest_memfd or dma-buf backed allocations. Once
> > userspace can access the mapping, the kernel cannot guarantee that
> > applications will only touch the intended 4K region rather than the whole
> > host page mapped into their address space. Those userspace addresses may
> > also be passed back into the kernel and accessed through the linear map,
> > resulting in a GPC fault.
> 
> IIUC, AMD SEV-SNP also has a similar requirement for other reasons, to
> align the "shared" allocations within a guest (2MB ?, as mentioned by
> David Kaplan at the LPC).
> 
> Michael, Alexey,
> 
> Please could you share your thoughts on this series ?

Yes, I think we concluded at LPC that AMD should use this series with
a 2MB setting rather than try to do their HW assisted smash/unsmash

Jason
