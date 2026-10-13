Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15C947DF8E;
	Tue, 13 Oct 2026 05:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791868397; cv=none; b=eIyFgs34TYtglL9ejnvy/3CiA6vwnI8Qf912wd89lD4J8K+3G24Uo7xgeF6rWg4jESDAA4cfY7qNXrruFJjlfol0l6nAIWRIJGh7YHe6YvGq/9oYbXct/WhtzZONOLpzZSjw6HLshhhMCvw1+XTe2rrkCNnOj7VEjDchOWxLEA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791868397; c=relaxed/simple;
	bh=p8Zz7IgMclgStUHo6Bn7GZa81f1lXxrvkXQTVNRaFjQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ewieIm42vfT0BuKw+NZm17VjAUONeMAlF6djAiag15cJg4cTLFpoKGrenlOaZZHIfDh4S5RaD8KCosnllXbnzsn40i+JhMmDKPyWKx5d/r6ejjV3lXek4v3ZUw61HQT9cakuNm4UZDTj+ZC0rHvGkI2+ELSGO6H/syoVdDMkmvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VzCrDEQb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VzCrDEQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E989C1F000FF;
	Tue, 13 Oct 2026 05:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791868395;
	bh=GJNXTxAKDlJNxNUfVhfSQZRthKiPsKwpUGRTdAWw5nk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VzCrDEQbQkLh3MKfOcrVWwIP8JEXomYf5WXOVtkxPNomqYwc62kenfaWt4EtjgLr1
	 56jB5oIiN8pzQZeIE3LFciZow2fKaUlTkUhbRzOM+dcbTemWxjNlaDACdigHCayE87
	 aOYeG7A0j8blwTWF/PhrjdF/yqcwVCBZgEXlTLggA50DrIt7DidbhXOeZDYqd2wlwf
	 5VM61psLu8x0NOTS6zsnpsRtNRWIIa6D/I6cZXFg4QLjCBQLZUYg8H0fnCR6pdxExb
	 Rlsmno4/IPgxywaV4sYkjL4r0KtaTtxGQIturB/lLm5ZpL/LuERHtKpU8HslKH1Kgj
	 Tp4Z6gqmgQAbg==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
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
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v8 02/14] mm: Zero memory during shared memory
 transitions
In-Reply-To: <arZkEugXwCtKHH64@thinkstation>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
 <20260924100529.1398790-3-aneesh.kumar@kernel.org>
 <arZkEugXwCtKHH64@thinkstation>
Date: Tue, 13 Oct 2026 10:42:58 +0530
Message-ID: <yq5azewiqj39.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Kiryl Shutsemau <kas@kernel.org> writes:

> On Thu, Sep 24, 2026 at 03:35:17PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
>> index f904a636d449..1f1f39082391 100644
>> --- a/arch/x86/coco/tdx/tdx.c
>> +++ b/arch/x86/coco/tdx/tdx.c
>> @@ -978,6 +978,9 @@ static bool tdx_enc_status_changed(unsigned long vaddr, int numpages, bool enc)
>>  static int tdx_enc_status_change_prepare(unsigned long vaddr, int numpages,
>>  					 bool enc)
>>  {
>> +	if (!enc)
>> +		memset((void *)vaddr, 0, (size_t)numpages << PAGE_SHIFT);
>> +
>>  	/*
>>  	 * Only handle shared->private conversion here.
>>  	 * See the comment in tdx_early_init().
>
> This doesn't make sense to me.
>
> On TDX the memset zeroes a page that is about to be dropped.
> MapGPA(shared) makes the VMM back the GPA with different memory, and
> what the guest reads afterwards through the shared mapping is whatever
> the host has there.
>

Does TDX require the guest contents to be preserved when pages are
converted to shared?

The memset() is done here because CoCo shared-memory allocations now
ignore __GFP_ZERO and instead always zero the memory explicitly. For
CoCo architectures such as CCA, this must be done after the memory is
converted to shared because shared memory uses a different encryption
context.

The full patch avoids zeroing the memory twice. If __GFP_ZERO is used
for a CoCo shared-page allocation, the page is first zeroed during
allocation, then converted to shared, and must be zeroed again. I only
changed Arm CCA  in this series because I was unsure whether the other
architectures required similar changes. Therefore, every CoCo
architecture other than CCA currently performs the memset() before
conversion, while CCA performs it afterward.

If the host expects to see the guest contents from before the conversion
to shared, we will have to pass the allocation flags down to these
helpers and perform the memset() only when __GFP_ZERO was requested,
along the lines of:

https://lore.kernel.org/all/yq5aa4p82sqt.fsf@kernel.org

To keep the changes minimal, the current approach always performs the
memset() rather than passing down a flag.

-aneesh
