Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9544379C36
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 14:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787237276; cv=pass; b=QmaLJhl08QIf3OIj2cb92CakB1PBPcscJZo56rModju15OtKNnfSiLCRDtIq5rsw4UEailsISrOgxDVorBMGFPYZ/8Sbi+JwG5sM1uDHVDTCbx0mb7h/G5HlV15cUvNTVHXjGGRK0KUMMNgde7cU4sRjx4RJMhunG7Esn7gLMrk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787237276; c=relaxed/simple;
	bh=r2hCL7XoFnqzQ8NQfsCqgeEbkv/DQ0+Almk3HSia9aY=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hjz4i0CvXJjENJ0we2sjYoUpaHzRmlsdAubgd+moBvTZLpdsGLVMv+eB2xi+y7TzkfR8yd/S2MihwguD8Wr1zt6rrkVYwx+xWwop5WbeoWBBMt8wu+liOtEX11hD6KW8kRkfvf/DDXW5IzkmIbREPJ83+HlpuatqVhs7SpdYe60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BeZptTw1; arc=pass smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BeZptTw1"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8f1e274ccb9so13016186d6.2
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 07:47:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787237273; cv=none;
        d=google.com; s=arc-20260327;
        b=KFUyzyXbG1W2MrtFIV9NOGu2B2TsGupAl5n4m3jqeYfJpuTWz6LPLFfFcmag+f7wUu
         OL9c6gXer+SF578QfHSX3h0t7JtsfLJC3gSp7vVdpabO/l97yOSRiyri8PtdTzry04kT
         cdE/+2T6JTu5fmZKR2GAYl+XcH7AlXdLrvdqYjzMSI55uJcdcCwcJcDBOgidPWBHW4Ez
         m/kJw+50hd4ce/WTsE2j9/i41Kx4MRXOgaMitTM8wA3JmTYK92GInxKW8PfiLxWi+OYM
         DvSO29vCfrD8bfxGPNghTHOHKfCPTrdaB0doWzd0kceAqIULACozglK/jtPUsODvtgtv
         njcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=wW5t0G/U8sBPBIi/hy7+eXOaj+vhlsnXo8EJATEvXbc=;
        fh=icINkaw2zkrktYoTaLWshwzzqoCez8s5r2r7q9vtl6g=;
        b=d1XmiAAZ6aubbWVBkLK+U9vc9l+afb1l2gHbXsvLYQnPqdb1KMZ4mMElzUr7iI8YA+
         BF9i+OWAzGFxl07NOl3MMuyJPJ8L8uPZSBlP72T+P49zc/j6BtggUkQeMLB8ETR32v3l
         PEsoVNt8BNVh5e6C9GAhTihqm0n8JcmZtaVkSHmrPkYpcBes37dgT7jD63OYGxvDYdVl
         Jdz4LuiSN+yLbMan2zK5CWwxIkdBlsG7OPvO5vP5LI4KsThyP/Fe++sBPTOPOd7uG2MF
         K6L8aggDCirJwA96esC09v/xz22RB2oXf9Ij3R36SgTvNdlYK8hz+lHD555sMW9HtNU6
         41+g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787237273; x=1787842073; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wW5t0G/U8sBPBIi/hy7+eXOaj+vhlsnXo8EJATEvXbc=;
        b=BeZptTw1cFk4XIfkpeH9wGUptsVjCgeJ+3EkMRs606GT7Wwg9jpdjab3V3s4E4kfUB
         pYfErh9mHMsIVft337bn/rC7zJ+Er3pkWCSg0E9tICqw33w+ToX9I/GqeVHgl9mlkBcO
         RLlsc8H/vkGWp9ZT6pK2FCGf8HGM9xBfpI3f8h1ZGtu9B78qviin+SsNwU0yH4+eOFBz
         kpTMGL2r0L7MkaWxC3oRi3M14ekOTZZJEHz5S3thw6Brq+YM9EyUmI9ohBJ081cTzE3S
         d34GJeUHQ8QxuV6Akvd1kKuMn+BbiJeZ7lmX8eVvvGOAMg8XEbzata/PEoN1hiyagsh1
         hU4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787237273; x=1787842073;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wW5t0G/U8sBPBIi/hy7+eXOaj+vhlsnXo8EJATEvXbc=;
        b=HIIRb0qX50pvfQO7DLv5eohQ0oJu2CQ8uxYO2wv97BoAyy3xwOcJGarf2f7/w52QQ8
         Cz7PisMizEGtWr1mwMBa5kEYjKy9W/Tk6cL46urAenLbwlOKqwFzj9FkA5p4+TXkhnF3
         HCy/kucVYPoaH/4SeIRZ8a8pJCOebMzZTtO2/HaY6ST2pZ7pm1YLDm4Lss3OQdDJlDjm
         IwKBBRiNC+62kv9IlMEgnbeXIdxmf/we97lnmLT6RgeFpkgLqUuwrwU3t6WDk7z3Jj42
         yx8u5XuIu5mXXE2YD4WlLwj+Q+5EANOe2Vysuc1k71X/N4oC48wJUQaM8Y3udc/8FpZG
         7DDw==
X-Forwarded-Encrypted: i=1; AHgh+Rra4S8E8LMzBRXfVsB2nBlKlH+w0w+E1Bw8dj76tEM3S82PmluufeCQJ/kVqLNl7dJJmV1jwog=@lists.linux.dev
X-Gm-Message-State: AFuF++mMCBjOjZS6BfZrmHHYpbtUXe0vcizuQV3hQKoSyi0t5uRTIJ7k
	rlQB1EXzjV6M+xoEKJYt9Wh2SKhAV+essz5HCxSN059sTjn+KznW3/yMFW/ZmPrcfJv7i0e7TlW
	LG+6nXUFohCbwCklKjwMVsnY8YHRQELgWRccWSgE6
X-Gm-Gg: AR+sD12PJ3FoB0H9RTZviyWNlEJjg0nNQamvfDOSeLQXP7uedWhhSBCPeVkYcgXhWtQ
	wWJnvwHGWTcrEAZqA7xuIheyHRcN1apVI3XTjIHAzqhP8X+seSZb1OVVyoo5jfU0o8jf8np6NwB
	XZTq7cFmPeRj9DGaR6YZu5+Mpejpr5sDK7QPwBxLTTP+dzGeiU43aUHeukQkv8IRgJgzQrai/id
	rxLrMZLONtcVAVNp9/d8OvtyU+lhftB9WGB4quhMHvzVM3getTzhYfPsuPoDOQzsftmEEdYofVF
	CNGXCj9R/6m97Arl28QWjL2v/QNznsby6WymIZ6HhongStTSUvjLDfPS7RYPjIm8gEQo+sQQ2yU
	f17A=
X-Received: by 2002:a05:6214:401:b0:8dc:2c21:32bd with SMTP id
 6a1803df08f44-90c5e68b4abmr133956736d6.1.1787237272678; Thu, 20 Aug 2026
 07:47:52 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 20 Aug 2026 07:47:51 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 20 Aug 2026 07:47:51 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aoVut/h1u7HdFxkR@yzhao56-desk.sh.intel.com>
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-4-5298f42d49bb@google.com> <aoVut/h1u7HdFxkR@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 20 Aug 2026 07:47:51 -0700
X-Gm-Features: AcwNN1WYYXv3T1n5AIJ_TiYtLTY6vDd5CVOeUwq99s4OCRdrQcgzzR3vkPd99ho
Message-ID: <CAEvNRgFFs2BC7m8YH7RnQSysU+eDqOjQpqAxL09mwJgrT_iYww@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: guest_memfd: Stop returning struct page from
 PFN lookup
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>, Fuad Tabba <tabba@google.com>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, Vishal Annapurve <vannapurve@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Tue, Aug 18, 2026 at 09:15:55AM +0000, Ackerley Tng wrote:
>> From: Sean Christopherson <seanjc@google.com>
>>
>> KVM currently expects guest_memfd PFN lookups to return a refcounted
>> struct page, which callers hold across fault handling.
>>
>> Holding a page reference across fault handling is problematic for
>> guest_memfd. In-place memory conversions between confidential
>> computing shared and private states inspect folio refcounts to ensure
>> exclusive ownership by guest_memfd. A concurrent guest page fault
>> taking a reference on the folio causes conversions to fail due to an
>> elevated refcount.
> Nit:
> As this series is based on kvm-x86/next, where there's no in-place memory
> conversion yet, kvm_gmem_get_pfn() does not hold shared filemap invalidate lock.
>
> However, the benefit of dropping the folio reference immediately before
> returning from the guest_memfd PFN lookup -- preventing conversion failures due
> to an elevated refcount -- should be effective only if the reference is dropped
> before releasing the shared filemap invalidate lock.
>
> Do we need to make this info clear, since I think it's important? :)
>

Is this what you meant?

  In-place conversions uses the filemap_invalidate_lock() for
  synchronization of shared/private state. In kvm_gmem_get_pfn(), the
  PFN needs to be prepared according to its shared/private state. Hence,
  the filemap_invalidate_lock() is held while guest_memfd gets a folio
  and decides to make private before returning a PFN.

  In kvm_gmem_get_pfn(), the folio refcount is dropped before releasing
  filemap_invalidate_lock(). This ensures that a competing conversion
  grabbing the filemap_invalidate_lock() will never see an elevated
  refcount due to guest_memfd's folio-getting process.

It seems a bit weird to fit this into the commit message for this
patch. I think I could put the above two paragraphs into the patch that
introduces the filemap_invalidate_lock in kvm_gmem_get_pfn()?

>> guest_memfd already notifies KVM of page invalidations, so callers
>> within KVM only need to respect the MMU invalidation protocol to safely
>> rely on guest_memfd for page presence.
>>
>> Furthermore, removing struct page from the guest_memfd PFN lookup moves
>> KVM closer toward supporting memory backends that are not backed by
>> struct page.
>
> Could we also explain why the lack of SetPageDirty() (and mark_page_accessed())
> for a gmem page, due to NULL being passed to kvm_release_faultin_page(), is
> harmless?
>

Sounds good. What do you think of this, continuing from the paragraph
beginning "Furthermore":

  Drop the folio reference immediately before returning from the
  guest_memfd PFN lookup, and stop returning the struct page pointer.

  ARM's gmem_abort() is guest_memfd specific. Since guest_memfd no longer
  returns a page pointer, there's also no need to do any
  freeing. kvm_release_faultin_page() originally also serves to set the page
  dirty and accessed under some conditions. The dirty and accessed flags
  don't matter for guest_memfd anyway, so it is safe to just drop the call to
  kvm_release_faultin_page().

  For ARM's kvm_translate_vncr(), initialize the local page pointer to NULL
  so that the shared cleanup path that releases fault-in pages safely no-ops
  for guest_memfd.

  For x86, no additional changes are required in the MMU fault path
  because the page fault tracking structure is zero-initialized at the
  start of page fault handling, ensuring the refcounted page pointer is
  already NULL.

>>
>> [...snip...]
>>
