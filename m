Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EFE32ED55
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 09:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787043897; cv=pass; b=hxOMnQW1B4P9gG9BlbhQvdGke/f0qIoCq/UAKPibjN0p5Z4ozoNU+324Lcs8D1hjRQTGjdDK0TkLddcGedYMAN+xJrS+zh0dOA8EdRO+OzccOoXjasrkxxX1nbFAJrr8tZN3VEpaJK1V7LiN+IErPlmy5bDC0eLUAQ+FRV2XaOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787043897; c=relaxed/simple;
	bh=u0iX0ZXqqeDNbxxfcHZ8oa2/UskWfEs4uf2Cr7iZDNE=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UeS8f7z4Xqq5G8srb2uQdM/wGMgO8puCFe7bq3r1FYXRj0eKGk8CGd2PSR1S1bbXxukuSSegwIHPRGiaVstjOiRQBEARzQDE4dRCOten4lNiPNFBB2HWz/c3R82IPuaoMT9am93rWpvXRSwF3Xcy7C2PGGpdLyx+mbsObAtlJ2E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PbM+9m46; arc=pass smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PbM+9m46"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c96b08cdd1cso3198113a12.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 02:04:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787043895; cv=none;
        d=google.com; s=arc-20260327;
        b=q+8738CzRGEmWHLpPmAS80b2wlYSHsyZ5qUxKA3fOue1h6rV9sYS4mdKM3wfZk0HFH
         opZAqqHpA8Qu7mq6zxfcVUsJ0sE1f/vdL6yzy5Z98LI0X4qvJx37JAjqle1Klz1bhuUw
         zSn7dOWPPmHGuYAIOuIV4pFZCeQxVVKbk5OwWqJrdIAkviSEt20fhAD2dNcxE4jYncGh
         qRe5hPc5ToLLoEA9fwfz7Zf8KeL2kvn7NKXInVdzbQhNlHrHlfxmQIfmNTTmJpURgCTv
         gzEQK9rCYGUTLgn0fZOpAt5b0kVH7pdtC7o8R8CK8zDVI7x4R5q8MY8m9Nc3lERGvXoK
         p9nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=RmZFJZDIQbP9rBN00CF0YOoIPLZVCPcoza0mwPaURTk=;
        fh=QQvvuupYup27/auDT9pAWPCiCqH8kPj3VO4vU7sMtvw=;
        b=NY+CQ2Jg4HcEaNk7KTmEJ7WLMsJgs87T0RDb+aDLU58nF5O5jEDbcSahEHB2bCy0+0
         Hd5HNst6Ho3eqbNqV9YfNa/Mc2TuIRq06pi96tlyq+rT5XSWOhXkSoHU9DVWtYtU9Tvd
         pCb8P24VP9d6u6FZtgP/IEcLbo2yFzaqn5oa/81qCE+koRijkx80J1dlh/6Fh8fORJLX
         l7I3qVCbRY4FTf1KXyp/YPeDrJMTHqZpNpZ5Sp7oYM4ERLBspv1kh0/0bUixFFFzLugO
         Xa8xM49zMOtnXkeE5HL/PjCECO/dPvpqboKgpypfV0pdYAGACp3JhccBZleR8Yw2gQLP
         88LA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787043895; x=1787648695; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RmZFJZDIQbP9rBN00CF0YOoIPLZVCPcoza0mwPaURTk=;
        b=PbM+9m462NYx3f9uaWF478iMAZ/Z/HjxqEBrty5OrPsOlPYojHiQ8Ped4S4g2/VV4H
         JC+fndF5kf6QKjemhsI59cNpUZ15Fmh0Os3Dk4dL52yM+v6IPK59W7/7daKtb2dkRwq5
         NoMD7ipZw0aAZZuJl5CtIqNyXIQXH7S/pO0CjTXpmj0rwhZykjtBP+m+XTPHxXXUf7BC
         s2DgAXgI4+2uHiJwiH87ti9BYS+Hz8hq7YdgTlb0JgZCdXxei1ijwxoM6v194iYQNVi5
         W4TV+mGWFbpF97PvI9S86VuuuE8RMNs5X7nXZ9qsSj4H1tmHHzC86+9f4i5hHi7PZiO1
         V7UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787043895; x=1787648695;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RmZFJZDIQbP9rBN00CF0YOoIPLZVCPcoza0mwPaURTk=;
        b=V4Ev15sJWeXBF3SaT6sutKiEvMSUG8nInwJ8Le2QREMXBqA1I+pzHrL2aASp+MAPa9
         UEAfWzMjkH2td9wP+j+gc2JYjQV5jDVdGH7J6CxU97WFAdC+vYtEH/3jSUBlY7E1ig8q
         hFfWc7gRiCfPGajXmPv7KGTGi5C34fTDM414xE1dMvSv+W+y5xJcKewUufovWue9qBX6
         +dRUC0roJtHJYCADw51O30VEEHGUH4Wp3C+b45oC1dmBGY9ClbVzYTjrFt7sT+8blOo+
         gfcBt6A/0wSbSbdBv9wfUc6GJuzehpGZAZNhW0GABSwgsjlyUMmr9RofDF9sSvKJyF+F
         8h+g==
X-Forwarded-Encrypted: i=1; AHgh+RqktaJemHQkaKq6mkFBou97GkvPPUNi1Y6azE9mNtmRsXrHP5NxOdeL66AX7kdYB0y0p0fNu0A=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2bsbxB/G7Hg3eZ2VMez6LXpKWXHrMUT+bc+QNMGmoVLkTmw5H
	yvqZU4Z3un64ClBqcqfdnpIYlvZl2beCJEWtzUtoouq7klEkZqDV8BVW/3WPUfLdoHVOmVpB1Qy
	j4LxE9lcUyK1p+3XrKWvUu3jcBbIJAVzewSCJKIoq
X-Gm-Gg: AR+sD11fZ4HbJaFZsfHXCFRhHyOxwB54OjSBpLO1v3womfjvkLJgi0y/0CNWrzLWYgb
	sXB/l8e9YQKxhAMrx082qbjRKc5IKwlhzcDRpojsFlJW8QwjBUpQzDHFa1gtPSa2BbafaE7bjo7
	JhbBLwPQfyfqRaCLt8K8I7KLL02rAb9dDw/KdCeo7zlioR56jSwRLX5swx1zzN6wSEOgBAhVqFH
	pfAbVOtIQBsyT2VekWMMJEBS0EaE+FlTGNmkII84s4l/zye3Ce/fYiGjSwFlKSRSJM+N9VXPJ55
	EdB+iu30s6TA1G2xzpXBsut4ZjHjrft1vcZ9lv5J4vGc8CQgAqhIM1lgF7zVg23is5MvcVpdJAk
	=
X-Received: by 2002:a17:90b:4f84:b0:38e:fea2:df53 with SMTP id
 98e67ed59e1d1-3933bd186f4mr33702008a91.4.1787043894543; Tue, 18 Aug 2026
 02:04:54 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 18 Aug 2026 02:04:52 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 18 Aug 2026 02:04:52 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aoQT00rN8a5TQ88+@yzhao56-desk.sh.intel.com>
References: <20260818-gmem-no-return-page-v1-0-4f8d939efdbc@google.com>
 <20260818-gmem-no-return-page-v1-2-4f8d939efdbc@google.com> <aoQT00rN8a5TQ88+@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Tue, 18 Aug 2026 02:04:52 -0700
X-Gm-Features: AcwNN1UM5CcnTZUcMQPeXSglijNaI2oVBWDnjgv4CaplShdt0x4B0EyQ_Yo4Fyc
Message-ID: <CAEvNRgGiYFaKAH-qAWy4W5nrmP5fYR0AkhU_t0X_NdTTcxgv7g@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: SEV: Drop page refcount early during RMP fault handling
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

> On Tue, Aug 18, 2026 at 08:12:36AM +0000, Ackerley Tng wrote:
>> When handling an RMP fault, KVM retrieves the PFN for a private GPA from
>> guest_memfd. The page reference taken during PFN lookup is not needed for
>> the remainder of the handler, as checking the RMP entry, splitting the
>> 2MB page via PSMASH, and zapping shadow page tables only operate on PFNs.
>>
>> Drop the page reference immediately after retrieving the PFN instead of
>> holding it across the entire handler.
>>
>> A later patch will follow up with completely not returning refcounted pages
>> from kvm_gmem_get_pfn().
>>
>> No functional change intended.
>>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> ---
>>  arch/x86/kvm/svm/sev.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index b2738362a928b..19c31fa944e34 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -5036,12 +5036,13 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>>  				    gpa);
>>  		return;
>>  	}
>> +	kvm_release_page_unused(page);
>>
>>  	ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
>>  	if (ret || !assigned) {
>>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, no assigned RMP entry found for GPA 0x%llx PFN 0x%llx error %d\n",
>>  				    gpa, pfn, ret);
>> -		goto out_no_trace;
>> +		return;
>>  	}
> Hi Ackerley,
>
> You missed the parts in [1] which save mmu_seq before invoking kvm_gmem_get_pfn(),
> +       mmu_seq = kvm->mmu_invalidate_seq;
> +       smp_rmb();
>
> and check mmu_invalidate_retry_gfn() before snp_rmptable_psmash(pfn):
>
> +       scoped_guard(read_lock)(&kvm->mmu_lock) {
> +               if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))
>                         goto out;
>
> [1] https://lore.kernel.org/all/an5RJYTwlYeym--O@google.com/

I thought it wasn't necessary after the fix in patch 1 but the
maintainer is always right, lol and Sashiko is right too. I'm preparing
a v2.

>>  	/*
>> @@ -5088,8 +5089,6 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>>  	kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
>>  out:
>>  	trace_kvm_rmp_fault(vcpu, gpa, pfn, error_code, rmp_level, ret);
>> -out_no_trace:
>> -	kvm_release_page_unused(page);
>>  }
>>
>>  static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
>>
>> --
>> 2.55.0.699.gb54405d56f-goog
>>
